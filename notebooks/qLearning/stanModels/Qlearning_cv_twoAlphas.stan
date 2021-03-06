
data {
  int<lower=1> N_train; // number of trials per subject
  int<lower=1> N_test;
  int<lower=-1, upper=2> choice_train[N_train]; // choices cast for each trial in columns
  int<lower=-1, upper=2> choice_test[N_test];
  real outcome_train[N_train];  // no lower and upper bounds; outcomes cast for each trial in columns
  real outcome_test[N_test];
}

transformed data {
  vector[2] initV;  // initial values for EV
  //initV = rep_vector(0.0, 2);
  initV = rep_vector(0.5, 2);
}

parameters {
  // Declare all parameters as vectors for vectorizing
  real<lower=0, upper=1> alpha_pos;
  real<lower=0, upper=1> alpha_neg;
  real<lower=0, upper=5> beta;
}


model {
  vector[2] ev; // expected value
  real PE;      // prediction error
  
  ev = initV;
  
  for (t in 1:N_train) {
    // compute action probabilities
    choice_train[t] ~ bernoulli_logit(beta * (ev[2]-ev[1]));
    
    // prediction error
    PE = outcome_train[t] - ev[choice_train[t]+1];
    
    // value updating (learning)
    if(PE>=0){
      ev[choice_train[t]+1] += alpha_pos * PE;
    } else {
      ev[choice_train[t]+1] += alpha_neg * PE;
    }
    
  }
  
  // individual parameters
  alpha_pos ~ beta(1, 1);
  alpha_neg ~ beta(1, 1);
  beta ~ gamma(1, 2);
  
}

generated quantities {
  // For log likelihood calculation
  vector[N_test] log_lik;

  { // local section, this saves time and space
  vector[2] ev; // expected value
  real PE;      // prediction error
  
  // Initialize values
  ev = initV;
  
  for (t in 1:N_test) {
    // compute log likelihood of current trial
    log_lik[t] = bernoulli_logit_lpmf(choice_test[t] | beta * (ev[2]-ev[1]));

    // prediction error
    PE = outcome_test[t] - ev[choice_test[t]+1];
    
    // value updating (learning)
    if(PE>=0){
      ev[choice_test[t]+1] += alpha_pos * PE;
    } else {
      ev[choice_test[t]+1] += alpha_neg * PE;
    }
  }
  }
}
