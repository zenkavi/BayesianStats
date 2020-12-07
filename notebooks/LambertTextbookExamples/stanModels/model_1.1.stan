
data {
  // Hetergoneous model example: likely to overfit data; doesn't give an estimate for the overall mean (which is what we're trying to estimate)
  int K; //number of schools
  int N; //total number of observations
  real X[N]; // observations
  int school[N];// index with id of school to which individual belong
}

parameters {
  real mu[K];
  real<lower=0> sigma[K];
}

model {
  for(i in 1:N){
    X[i] ~ normal(mu[school[i]], sigma[school[i]]);
  }
  mu ~ normal(50,20);
  sigma ~ lognormal(1,1);
}