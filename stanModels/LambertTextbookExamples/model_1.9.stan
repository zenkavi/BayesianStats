
data {
// Hierarchical model of voter behavior (not confirmed)
  int N; //number of subjects
  int K; //number of countries
  int vote[N];
  int rlgblg[N];
  real age[N];
  int gender[N]; //1 for men; 0 for women
  int country[N];
}

parameters {
  real alpha[K];
  real beta_g[K];
  real beta_a[K];
  real beta_r[K];
  real alpha_top;
  real beta_g_top;
  real beta_a_top;
  real beta_r_top;
  real<lower=0> alpha_sigma;
  real<lower=0> beta_g_sigma;
  real<lower=0> beta_a_sigma;
  real<lower=0> beta_r_sigma;
}

model {
  for (i in 1:N){
    int aCountry;
    aCountry = country[i];
    vote[i] ~ bernoulli_logit(alpha[aCountry] + beta_g[aCountry]*gender[i] + beta_a[aCountry] * age[i] + beta_r[aCountry] * rlgblg[i]);
  }
  
  // Priors
  alpha ~ normal(alpha_top, alpha_sigma);
  beta_g ~ normal(beta_g_top, beta_g_sigma);
  beta_a  ~ normal(beta_a_top,beta_a_sigma);
  beta_r  ~ normal(beta_r_top, beta_a_sigma);
  
  //Hyperpriors
  alpha_top ~ normal(50, 20);
  beta_g_top ~ normal(0, 1);
  beta_a_top ~ normal(0, 1);
  beta_r_top ~ normal(0, 1);
  alpha_sigma ~ normal(0, 1);
  beta_g_sigma ~ normal(0, 1);
  beta_a_sigma ~ normal(0, 1);
  beta_r_sigma ~ normal(0, 1);
}
