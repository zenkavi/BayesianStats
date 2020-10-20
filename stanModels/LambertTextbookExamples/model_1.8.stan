
data {
// Pooled model of voter behavior
  int N;
  int vote[N];
  int rlgblg[N];
  real age[N];
  int gender[N]; //1 for men; 0 for women
}

parameters {
  real alpha;
  real beta_g;
  real beta_a;
  real beta_r;
}

model {
  for (i in 1:N){
    vote[i] ~ bernoulli_logit(alpha + beta_g*gender[i] + beta_a * age[i] + beta_r * rlgblg[i]);
  }
  
  alpha ~ normal(0, 1);
  beta_g ~ normal(0, 1);
  beta_a  ~ normal(0, 1);
  beta_r  ~ normal(0, 1);
}
