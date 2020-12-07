
data {
// Hierarchical model of poling data
  int K;
  int Y[K];
  int N[K];
}

parameters {
 real<lower=0, upper=1> alpha; //overall probability that an individual intends to vote 'remain'
 real<lower=0> kappa; // our confidence in this value
 vector<lower=0, upper=1>[K] theta; //probability that an individual intends to vote 'remain' for each polling station
}

model {
  for(i in 1:K){
    //Likelihood
    Y[i] ~ binomial(N[i], theta[i]);
  }
  
  //prior
  //using a transformed parameterization of a beta distribution
  theta ~ beta(alpha * kappa, (1-alpha)*kappa);
  
  //hyper-priors
  kappa ~ pareto(1, .3);
  alpha ~ beta(5, 5); // this prior has most weight towards .5, which means an equal split of remainer and leavers
}

// Purpose of the model is to estimate proportion of 'remain' votes in the referendum; 
// step 1: independently sample alpha and kappa from their posteriors
// step 2: sample a theta using these parameters for a beta distribution
generated quantities{
  real<lower=0, upper=1> aTheta;
  aTheta = beta_rng(alpha * kappa, (1-alpha)*kappa);
}

