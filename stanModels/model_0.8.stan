
data {
  int NTest;
  int NTrain;
  real XTrain[NTrain];
  real XTest[NTest];
}

parameters {
  real mu;
  real<lower=0> sigma;
  real nu;
}

model {
  XTrain ~ student_t(nu, mu, sigma);
  mu ~ normal(0, 1);
  sigma ~ lognormal(0, 1);
  nu ~ lognormal(0, 1);
}

generated quantities{
  vector[NTest] logLikelihood;
  for (i in 1:NTest){
    logLikelihood[i] = student_t_lpdf(XTest[i]|nu, mu, sigma);
  }
}
