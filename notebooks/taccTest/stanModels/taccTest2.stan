
functions {
  real partial_sum_lpdf(real[] slice_y,
                        int start, int end,
                        vector x1,
                        vector x2,
                        vector beta,
                        real sigma) {
    return normal_lupdf(slice_y | beta[1]*x1[start:end]+beta[2]*x2[start:end], sigma);
  }
}

data {
  int N; 
  real y[N];
  vector[N] x1;
  vector[N] x2;
  int<lower=1> grainsize;
}

parameters {
  vector[2] beta;
  real<lower=0> sigma;
}

model {
  beta ~ normal(0, 1);
  sigma ~ lognormal(1,1);
  target += reduce_sum(partial_sum_lupdf, y, grainsize, x1, x2, beta, sigma);
}
