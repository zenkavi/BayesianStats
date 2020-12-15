

data {
  int<lower=0> N;
  real x[N];
  real y[N];
  real y0;
}

parameters {
  real sigma;
}

model {
  for (i in 1:N){
    y[i] ~ normal(x[i] - 1 + 2*exp(-x[i]), sigma); 
  }
  sigma ~ lognormal(-1, 1);
}
