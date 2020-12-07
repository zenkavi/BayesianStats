
data {
  int<lower=1> N; //number of subjects
  int<lower=1> T; // number of trials per subject
  int<lower=-1, upper=2> choice[N, T]; // choices cast for each trial in columns
  real outcome[N, T];  // no lower and upper bounds; outcomes cast for each trial in columns
}

transformed data {
  vector[2] initV;  // initial values for EV
  initV = rep_vector(0.5, 2);
}

parameters {
// Declare all parameters as vectors for vectorizing
  real<lower=0, upper=1> g_alpha;
  real<lower=0, upper=5> g_beta;
  real<lower=0, upper=1> alpha[N];
  real<lower=0, upper=5> beta[N];
}

model {
  
  for (i in 1:N){
    vector[2] ev; // expected value
    real PE;      // prediction error

    ev = initV;
    for (t in 1:T) {
      // compute action probabilities
    choice[i, t] ~ bernoulli_logit(beta[i] * (ev[2]-ev[1]));

      // prediction error [adding 1 to choice[i, t] for indexing ev]
    PE = outcome[i, t] - ev[choice[i, t]+1];

      // value updating (learning)
    ev[choice[i, t]+1] += alpha[i] * PE;
    }
  }
  
  // Priors
  g_alpha ~ beta(1, 1);
  g_beta ~ gamma(1, 2);
  alpha ~ normal(g_alpha, .1);
  beta ~ normal(g_beta, .5);

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
    
    for(i in 1:N){
      vector[2] ev; // expected value
      real PE;      // prediction error
      
      // Initialize values
      ev = initV;
      
      log_lik = 0;
      
      
      for (t in 1:T) {
        // compute log likelihood of current trial
        log_lik += bernoulli_logit_lpmf(choice[i, t] | beta[i] * (ev[2]-ev[1]));
        
        // generate posterior prediction for current trial
        y_pred[t] = bernoulli_rng(inv_logit(beta[i] * (ev[2]-ev[1])));
        
        // prediction error
        PE = outcome[i, t] - ev[choice[i, t]+1];
        
        // value updating (learning)
        ev[choice[i, t]+1] += alpha[i] * PE;
      }
    }
  }
}
