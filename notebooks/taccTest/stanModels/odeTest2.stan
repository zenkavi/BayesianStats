
functions{
  vector dy_dx(real t,
              vector state) {
                
    vector[1] dydx;
    dydx[1] = state[1] - state[2];
    return dydx;
  }
}

data {
  int<lower=0> T;
  vector[2] state0;
  vector[2] states[T]; //states[1] = x; states[2] = y
  real ts[T];
  real t0;
}

parameters {
  real sigma;
}

model {
  vector[2] z[T] = ode_rk45(dy_dx, state0, t0, ts, sigma);
  
  for (i in 1:T){
    y[,i] ~ normal(z[,i], sigma); 
  }
  sigma ~ lognormal(-1, 1);
}
