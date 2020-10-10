
data {
  int<lower=1> T; // number of trials per subject
  real ev[2, T]; // expected value cast for each trial in columns
  real outcome[T];  // no lower and upper bounds; outcomes cast for each trial in columns
}

transformed data{
  real val_diff[T];
  real PE[t];
  
  for(t in 1:T){
    val_diff[t] = ev[2,t] - ev[1,t];
    PE[t] = max(ev[,t]) - outcome[t];
  }

}

parameters {
  real<lower=0, upper=1> alpha;
  real<lower=0, upper=5> beta;
}


model {
  int choice[T];
  real PE;      // prediction error

    for (t in 1:T) {
      // compute action probabilities
    choice[t] ~ bernoulli_logit(beta * (ev[2,t]-ev[1,t]));

      // prediction error
    PE = outcome[t] - ev[choice[t]+1,t];

      // value updating (learning)
    ev[choice[t]+1,t] += alpha * PE;
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
      log_lik += bernoulli_logit_lpmf(choice[t] | beta * (ev[2]-ev[1]));

        // generate posterior prediction for current trial
      y_pred[t] = bernoulli_rng(inv_logit(beta * (ev[2]-ev[1])));

        // prediction error
      PE = outcome[t] - ev[choice[t]+1];

        // value updating (learning)
      ev[choice[t]+1] += alpha * PE;
    }
  }
}
