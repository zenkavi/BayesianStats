
functions{
  
  // if we believe that variable X follows a random distribution not defined in Stan 
  // we can use it for inference by writing a function that returns the log density for each value of the parameters 
  //(in this case this would be the log for each value of mu)
  
  // the suffix `_lpdf` tells Stan to regards this function as a log prob density function which then can be used in the `model` definition below
  
  // Custom prob distribution requires the data generated by the pdf as its first argument followed by the parameters of the pdf
  real example_lpdf(real aX, real aMu){
    return (log(sqrt(2)/(pi() * (1+ (aX- aMu)^4))));
  }
}

data {
  int<lower=0> N;
  real X[N];
}

parameters {
  real mu;
}

model {
  for (i in 1:N){
    X[i] ~ example(mu); // interesting that the `example` function is not directly defined anywhere
  }
  mu ~ normal(0,2);
}
