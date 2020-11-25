
data {
  int N; 
  real y[N];
  real x1[N];
  real x2[N];
}

parameters {
  real b1;
  real b2;
  real<lower=0> sigma;
}

model {
  for(i in 1:N){
    y[i] ~ normal(b1*x1[i] + b2*x2[i], sigma);
  }
  b1 ~ normal(0, 1);
  b2 ~ normal(0, 1);
  sigma ~ lognormal(1,1);
}
