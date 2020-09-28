
data {
  real Y[10]; // Heights for N people
}

parameters {
  real mu;
  real<lower=0> sigma;
}

model {
  Y ~ normal(mu, sigma); // vectorised version of the above loop
  mu ~ normal(1.5, 0.1);
  sigma ~ gamma(1, 1);
}

generated quantities {
  int aMax_indicator;
  int aMin_indicator;
  
  // Generate posterior predictive samples
  
 {vector[10] lSimData; //simulated data vector created within {} to reduce memory overhead; this way it won't be saved in the output of this model fit
  for(i in 1:10){
    // Normal random number generator
    lSimData[i] = normal_rng(mu, sigma);
  }
  
  // Compare with real data
  // How frequently is the generated data more extreme than real data
  aMax_indicator = max(lSimData) > max(Y);
  aMin_indicator = min(lSimData) > min(Y);
  }
}
