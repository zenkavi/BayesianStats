
functions {
  vector sho(real t,
             vector y,
             real theta) {
    vector[2] dydt;
    dydt[1] = y[2];
    dydt[2] = -y[1] - theta * y[2];
    return dydt;
  }
}

data {
  int<lower=1> T; //max t
  vector[2] y0; // initial state
  real t0; // start time
  real ts[T]; //timepoints?
  real theta;
}

model {
}


generated quantities {
  vector[2] y_sim[T] = ode_rk45(sho, y0, t0, ts, theta);
  // add measurement error
  for (t in 1:T) {
    y_sim[t, 1] += normal_rng(0, 0.1);
    y_sim[t, 2] += normal_rng(0, 0.1);
  }
}

