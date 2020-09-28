
data {
  int<lower=0> N;
  real X[N];
}

parameters {
  real mu;
  real<lower=0> sigma;
}

model {
  X ~ normal(mu, sigma);
  mu ~ normal(0, 1);
  sigma ~ lognormal(0, 1);
}

// for WAIC and LOO-CV we need log likelihood for each data point
// specify this as a generated quantity for the distribution described in the model
generated quantities{
  vector [N] logLikelihood;
  for (i in 1:N){
    logLikelihood[i] = normal_lpdf(X[i]|mu, sigma);
  }
}
