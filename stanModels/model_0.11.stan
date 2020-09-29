
data { 
  // Discrete variable example where two biased coins are thrown 10 times for 20 experiements to identify 1. which coin it is 2. the probability that it lands heads
  int<lower=1> nStudy; //number of studies
  int<lower=1> N; //samples per study (max 10)
  int<lower = 0, upper=N> X[nStudy];
}

parameters {
 ordered[2] alpha; // 'ordered' type ensures the probability for one coin is larger than the other for a given experiment
}

transformed parameters {
  real<lower=0, upper=1> theta[2];
  matrix[nStudy, 2] lp; //log probability matrix that will be marginalized over; each row contains the log probabilities for the identity of each coin given the data
  
  for(i in 1:2){
    theta[i] = inv_logit(alpha[i]); //logit formulation for binomial distribution
  }
  
  for(n in 1:nStudy){
    for(s in 1:2){
      // Unnormalized log posterior density for each state in each study
      lp[n, s] = log(.5) + binomial_logit_lpmf(X[n]|N, alpha[s]);
    }
  }
}

model {
  for (n in 1:nStudy){
    //marginalizing the joint density over the s; i.e. sums both values for each study and increments the log probability by that amount
    target += log_sum_exp(lp[n]);
  }
}

generated quantities {
  real pstate[nStudy];
  for (n in 1:nStudy){
    // transforming logit back to probability
    //pstate[n] = exp(lp[n,1])/(exp(lp[n,1]) + exp(lp[n,2]));
    
    // more numerically stable way of writing the same thing
    pstate[n] = exp(lp[n,1]-log_sum_exp(lp[n]));
  }
}
