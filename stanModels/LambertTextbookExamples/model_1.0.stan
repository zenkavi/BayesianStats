
data {
  // Pooled model example: Assuming one mean for all schools
  int N; //total number of observations
  real X[N]; // observations
}

parameters {
  real mu;
  real<lower=0> sigma;
}

model {
  for(i in 1:N){
    X[i] ~ normal(mu, sigma);
  }
  mu ~ normal(50,20);
  sigma ~ lognormal(1,1);
}

generated quantities {
  // posterior predictive check variables: compare the mean of the worst school to the worst predicted scores
  real XSim[N];
  real logLikelihood[N];
  for(i in 1:N){
    XSim[i]=normal_rng(mu, sigma);
    logLikelihood[i]=normal_lpdf(XSim[i]|mu, sigma);
  }
}
