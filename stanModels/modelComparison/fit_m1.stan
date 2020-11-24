
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

// generated quantities {
//   // posterior predictive check variables: compare the mean of the worst school to the worst predicted scores
//   real y_pred[N];
//   real logLikelihood[N];
//   for(i in 1:N){
//     y_pred[i]=normal_rng(b1, sigma);
//     logLikelihood[i]=normal_lpdf(y_pred[i]|b1, sigma);
//   }
// }