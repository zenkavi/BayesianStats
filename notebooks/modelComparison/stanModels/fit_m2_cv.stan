
data {
  int N_train; 
  real y_train[N_train];
  real x1_train[N_train];
  real x2_train[N_train];
  int N_test; 
  real y_test[N_test];
  real x1_test[N_test];
  real x2_test[N_test];
}

parameters {
  real b1;
  real b2;
  real<lower=0> sigma;
}

model {
  for(i in 1:N_train){
    y_train[i] ~ normal(b1*x1_train[i]+b2*x2_train[i], sigma);
  }
  b1 ~ normal(0, 1);
  sigma ~ lognormal(1,1);
}

generated quantities {
  real logLikelihood[N_test];
  for(i in 1:N_test){
    logLikelihood[i]=normal_lpdf(y_test[i]|b1*x1_test[i]+b2*x2_test[i], sigma);
  }
}
