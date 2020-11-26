
data {
  int<lower=1> N_train; // number of trials per subject
  int<lower=1> N_test;
  int<lower=-1, upper=2> choice_train[N_train]; // choices cast for each trial in columns
  int<lower=-1, upper=2> choice_test[N_test];
  real outcome_train[N_train];  // no lower and upper bounds; outcomes cast for each trial in columns
  real outcome_test[N_test];
}

parameters {
  // Declare all parameters as vectors for vectorizing
  real<lower=0, upper=1> theta;
}


model {

  for (t in 1:N_train) {
    // compute action probabilities
    choice_train[t] ~ bernoulli(theta);
  }
  
  // individual parameters
  theta ~ beta(100, 1);
}

generated quantities {
  // For log likelihood calculation
  vector[N_test] log_lik;
  
  { // local section, this saves time and space
  for (t in 1:N_test) {
    // compute log likelihood of current trial
    log_lik[t] = bernoulli_lpmf(choice_test[t] | theta);
    
  }
  }
}
