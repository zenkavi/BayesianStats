
data {
  real Y[10]; // Heights for N people
}

parameters {
  real mu;
  real<lower=0> sigma;
}

model {
  // for(i in 1:10){
    // Y[i] ~ normal(mu, sigma);
    // more explicit way of writing what the above expression does
    // updates the target container that holds the neg log prob
    // target += normal_lpdf(Y[i]|mu, sigma);
    // this could be used if you need actual log probability of the model
    // otherwise models with ~ operator are faster
  //}
  
  // page 379: "increment the overall log probability by an amount given by the log likelihood of a data point Y for a normal distribution with a mean of my and sd of sigma""
  Y ~ normal(mu, sigma); // vectorised version of the above loop
  mu ~ normal(1.5, 0.1);
  sigma ~ gamma(1, 1);
}

generated quantities {
  vector[10] lSimData;
  int aMax_indicator;
  int aMin_indicator;
  
  // Generate posterior predictive samples
  for(i in 1:10){
    // Normal random number generator
    lSimData[i] = normal_rng(mu, sigma);
  }
  
  // Compare with real data
  // How frequently is the generated data more extreme than real data
  aMax_indicator = max(lSimData) > max(Y);
  aMin_indicator = min(lSimData) > min(Y);
}
