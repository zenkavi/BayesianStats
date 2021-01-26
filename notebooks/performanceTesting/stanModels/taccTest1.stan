
data {
  int N; 
  real y[N];
  real x1[N];
  real x2[N];
}

parameters {
  vector[2] beta;
  real<lower=0> sigma;
}

model {
  for(i in 1:N){
    y[i] ~ normal(beta[1]*x1[i] + beta[2]*x2[i], sigma);
  }
  beta ~ normal(0, 1);
  sigma ~ lognormal(1,1);
}
