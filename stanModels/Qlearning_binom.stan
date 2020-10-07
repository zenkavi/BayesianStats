
data {
  int<lower=1> T; // number of trials per subject
  int<lower=-1, upper=2> choice[T]; // choices cast for each trial in columns
  real outcome[T];  // no lower and upper bounds; outcomes cast for each trial in columns
}

transformed data {
  vector[2] initV;  // initial values for EV
  initV = rep_vector(0.0, 2);
}

parameters {
// Declare all parameters as vectors for vectorizing
  vector[2] mu_pr;
  vector<lower=0>[2] sigma;

  real A_pr;    // learning rate
  real tau_pr;  // inverse temperature
}

transformed parameters {
  // subject-level parameters
  real<lower=0, upper=1> A;
  real<lower=0, upper=5> tau;

  A   = Phi_approx(mu_pr[1]  + sigma[1]  * A_pr);
  tau = Phi_approx(mu_pr[2] + sigma[2] * tau_pr) * 5;
}


model {
  vector[2] ev; // expected value
  real PE;      // prediction error

  ev = initV;

    for (t in 1:T) {
      // compute action probabilities
    //choice[t] ~ categorical_logit(tau * ev);
    choice[t] ~ bernoulli_logit(tau * (ev[2]-ev[1]));

      // prediction error
    PE = outcome[t] - ev[choice[t]+1];

      // value updating (learning)
    ev[choice[t]+1] += A * PE;
  }
  // Hyperparameters
  mu_pr  ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // individual parameters
  A_pr   ~ normal(0, 1);
  tau_pr ~ normal(0, 1);
}

generated quantities {
  // For log likelihood calculation
  real log_lik;

  // For posterior predictive check
  real y_pred[T];

  // Set all posterior predictions to 0 (avoids NULL values)
  for (t in 1:T) {
    y_pred[t] = -1;
  }
  
  { // local section, this saves time and space
    vector[2] ev; // expected value
    real PE;      // prediction error

    // Initialize values
    ev = initV;

    log_lik = 0;

    for (t in 1:T) {
        // compute log likelihood of current trial
      //log_lik += categorical_logit_lpmf(choice[t] | tau * ev);
      log_lik += bernoulli_logit_lpmf(choice[t] | tau * (ev[2]-ev[1]));

        // generate posterior prediction for current trial
      //y_pred[t] = categorical_rng(softmax(tau * ev));
      y_pred[t] = bernoulli_rng(inv_logit(tau * (ev[2]-ev[1])));

        // prediction error
      PE = outcome[t] - ev[choice[t]+1];

        // value updating (learning)
      ev[choice[t]+1] += A * PE;
    }
  }
}


