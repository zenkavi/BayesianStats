
data {
  // Hierarchical model example: models where priors are parameters instead of numbers (i.e. hyper-priors)
  int K; //number of schools
  int N; //total number of observations
  real X[N]; // observations
  int school[N];// index with id of school to which individual belong
}

parameters {
  real mu[K];
  real<lower=0> sigma[K];
  real mu_bar;
  real<lower=0> sigma_bar;
}

model {
  for(i in 1:N){
    X[i] ~ normal(mu[school[i]], sigma[school[i]]);
  }
  mu ~ normal(mu_bar, sigma_bar);
  sigma ~ normal(sigma_bar, 1); //not sure about this
  mu_bar ~ normal(50,20);
  sigma_bar ~ lognormal(1,1);
}

generated quantities{
  // We want to estimate the mean test score for a randomly selected student
  // mu_average is the mean test score in a hypothetical school
  real mu_average;
  mu_average = normal_rng(mu_bar, sigma_bar);
}