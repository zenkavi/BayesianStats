
data {
  real Y[10]; // Heights for N people
}

parameters {
  real mu;
  real<lower=0> sigmaSq;
}

transformed parameters{
  real sigma;
  sigma = sqrt(sigmaSq);
}

model {
  Y ~ normal(mu, sigma); 
  mu ~ normal(1.5, 0.1);
  sigmaSq ~ gamma(5, 1);
}
