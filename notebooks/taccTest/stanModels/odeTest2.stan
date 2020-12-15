
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
  vector[2] state0; // initial state
  vector[2] states[T]; //states[1] = x(t); states[2] = y(t)
  real ts[T]; // time points
  real t0; // first time point 0
}

parameters {
  real sigma;
}

model {
  vector[2] z[T] = ode_rk45(dy_dx, state0, t0, ts);
  
  for (i in 1:T){
    states[,i] ~ normal(z[,i], sigma); 
  }
  sigma ~ lognormal(-1, 1);
}
