
data {
  // Hierarchical model with ****non-centred parameterisation****
  int K; //number of schools
  int N; //total number of observations
  real X[N]; // observations
  int school[N];// index with id of school to which individual belong
}

parameters {
  real<lower=0> sigma[K]; // not sure if this is needed anymore
  real mu_bar;
  real<lower=0> sigma_bar;
  real mu_raw;
}

transformed parameters{
  real mu[K];
  for (i in 1:K){
    mu[i] = mu_bar + mu_raw * sigma_bar; 
  }
}

model {
  for(i in 1:N){
    X[i] ~ normal(mu[school[i]], sigma[school[i]]);
  }
  
    // non-centred parameterisation reduces the dependency between the global and local parameters in sampling to reduce problems of e.g. divergen chains and slower optimization
  // sigma ~ normal(sigma_bar, 1); //not sure about this
  mu_raw ~ normal(0, 1);
  mu_bar ~ normal(50,20);
  sigma_bar ~ lognormal(1,1);
}

generated quantities{
  // We want to estimate the mean test score for a randomly selected student
  // mu_average is the mean test score in a hypothetical school
  real mu_average;
  mu_average = normal_rng(mu_bar, sigma_bar);
}