
data {
  real Y[10];
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
  Y ~ normal(mu, sigma); // vectorised version of the above loop
  mu ~ normal(1.5, 0.1);
  sigma ~ gamma(1, 1);
}
