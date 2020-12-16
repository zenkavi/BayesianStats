
functions{
  int find_interval_elem(real x, vector sorted, int start_ind){
    int res;
    int N;
    int max_iter;
    real left;
    real right;
    int left_ind;
    int right_ind;
    int iter;
    
    N = num_elements(sorted);
    
    if(N == 0) return(0);
    
    left_ind  = start_ind;
    right_ind = N;
    
    max_iter = 100 * N;
    left  = sorted[left_ind ] - x;
    right = sorted[right_ind] - x;
    
    if(0 <= left)  return(left_ind-1);
    if(0 == right) return(N-1);
    if(0 >  right) return(N);
    
    iter = 1;
    while((right_ind - left_ind) > 1  && iter != max_iter) {
      int mid_ind;
      real mid;
      // is there a controlled way without being yelled at with a
      // warning?
      mid_ind = (left_ind + right_ind) / 2;
      mid = sorted[mid_ind] - x;
      if (mid == 0) return(mid_ind-1);
      if (left  * mid < 0) { right = mid; right_ind = mid_ind; }
      if (right * mid < 0) { left  = mid; left_ind  = mid_ind; }
      iter = iter + 1;
    }
    if(iter == max_iter)
    print("Maximum number of iterations reached.");
    return(left_ind);
  }
  
  vector dy_dx(real t,
              vector state,
              vector diffx,
              vector ts) {
                
    int d = find_interval_elem(t, ts, 1);
    
    if(d == 0){
      d = 1;
    }

    vector[2] dydx;
    dydx[1] = diffx[d]; //no change for x? this doesn't make sense
    dydx[2] = state[1] - state[2]; //derivative of y
    return dydx;
  }
}

data {
  int T; //nrow states-1
  vector[2] state0; // initial state
  vector[2] states[T]; //states[1] = x(t); states[2] = y(t)
  real ts[T]; // time points
  real t0; // first time point 0
  vector[T] diffx;
}

parameters {
  real sigma;
}

transformed parameters{
  vector[2] z[T] = ode_rk45(dy_dx, state0, t0, ts, diffx, to_vector(ts));
}

model {
  
  for (i in 1:2){
    states[,i] ~ normal(z[,i], sigma); 
  }
  sigma ~ lognormal(-1, 1);
}
