
functions{
  vector dy_dx(real t,
              vector state) {
                
    vector[1] dydx;
    dydx[1] = state[1] - state[2];
    return dydx;
  }
}

data {
  int<lower=0> N;
  vector[2] state0;
  vector[2] states[N]; //states[1] = x; states[2] = y
  real ts[N];
}

parameters {
  real sigma;
}

model {
  vector[1] z[N] = ode_rk45(dy_dx, state0, 0, ts, sigma);
  
  for (i in 1:N){
    y[i] ~ normal(z[i], sigma); 
  }
  sigma ~ lognormal(-1, 1);
}
