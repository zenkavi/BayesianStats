
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
  real<lower=0, upper=1> alpha;
  real<lower=0, upper=5> beta;
}


model {
  vector[2] ev; // expected value
  real PE;      // prediction error

  ev = initV;

    for (t in 1:T) {
      // compute action probabilities
    //choice[t] ~ categorical_logit(tau * ev);
    choice[t] ~ bernoulli_logit(beta * (ev[2]-ev[1]));

      // prediction error
    PE = outcome[t] - ev[choice[t]+1];

      // value updating (learning)
    ev[choice[t]+1] += alpha * PE;
  }

  // individual parameters
  alpha ~ beta(1, 1);
  beta ~ gamma(1, 2);
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
      log_lik += bernoulli_logit_lpmf(choice[t] | beta * (ev[2]-ev[1]));

        // generate posterior prediction for current trial
      //y_pred[t] = categorical_rng(softmax(tau * ev));
      y_pred[t] = bernoulli_rng(inv_logit(beta * (ev[2]-ev[1])));

        // prediction error
      PE = outcome[t] - ev[choice[t]+1];

        // value updating (learning)
      ev[choice[t]+1] += alpha * PE;
    }
  }
}


