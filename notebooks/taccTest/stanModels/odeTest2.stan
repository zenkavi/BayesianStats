
functions{
  vector dy_dx(real t,
              vector state) {
                
    vector[2] dydx;
    dydx[1] = 1; 
    dydx[2] = 1; //derivative of y
    return dydx;
  }
}

data {
  int T; //nrow states-1
  vector[2] state0; // initial state y(0)=1
  vector[2] states[T]; //states[1] = x(t); states[2] = y(t)
  real ts[T]; // time points
  real t0; // first time point 0
}

parameters {
  real sigma;
}

transformed parameters{
  vector[2] z[T] = ode_rk45(dy_dx, state0, t0, ts);
}

model {
  
  for (i in 1:2){
    states[,i] ~ normal(z[,i], sigma); 
  }
  sigma ~ lognormal(-1, 1);
}
