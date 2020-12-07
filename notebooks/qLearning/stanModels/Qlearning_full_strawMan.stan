
data {
  int<lower=1> T_train; // number of trials per subject
  int<lower=-1, upper=2> choice_train[T_train]; // choices cast for each trial in columns
  real outcome_train[T_train];  // no lower and upper bounds; outcomes cast for each trial in columns
}

parameters {
  // Declare all parameters as vectors for vectorizing
  real<lower=0, upper=1> theta;
}


model {

  for (t in 1:T_train) {
    // compute action probabilities
    // choice_train[t] ~ bernoulli(theta);
    target += bernoulli_logit_lpmf(choice_train[t] | theta);
  }
  
  // individual parameters
  theta ~ beta(100, 1);
}
