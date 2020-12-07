
data {
  // Pooled model for linear regression of test scores predicted by meals, female etc.
  int N;
  real score[N];
  real meals[N];
  real female[N];
  real english[N];
}

parameters {
  // Model is pooled because there is a single parameter for all schools and local education authorities
  real alpha;
  real beta_m;
  real beta_f;
  real beta_e;
  real<lower=0> sigma;
}

model {
  for (i in 1:N){
    score[i] ~ normal(alpha + beta_m*meals[i] + beta_f*female[i] + beta_e*english[i], sigma);
  }
  
  alpha ~ normal(50, 10);
  beta_m ~ normal(0, 1);
  beta_f ~ normal(0, 1);
  beta_e ~ normal(0, 1);
  sigma ~ normal(0, 2);
}
