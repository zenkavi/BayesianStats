
data {
  int N; 
  real y[N];
  real x1[N];
}

parameters {
  real b1;
  real<lower=0> sigma;
}

model {
  for(i in 1:N){
    y[i] ~ normal(b1*x1[i], sigma);
  }
  b1 ~ normal(0, 1);
  sigma ~ lognormal(1,1);
}
