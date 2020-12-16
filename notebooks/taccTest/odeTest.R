library(cmdstanr)
set.seed(1302589023)

# Compare stan model fitting time using ODE vs no ODE for a function with an analytical solution

# y(0) = 1
# dy/dx = 1
# y = x+1
make_states = function(n=500, mu=0, sigma=3){
  x = c(0, rnorm(n-1, mu, sigma))
  y = x+1
  states = cbind(x, y)
  return(states)
}

testStates = make_states()

testData = list(T = nrow(testStates)-1,
                state0 = testStates[1,],
                states = testStates[-1,],
                ts = 1:(nrow(testStates)-1),
                t0 = 0)

test_model = function(dat, model_path, output_path){
  
  mod = cmdstan_model(model_path)
  start_time = Sys.time()
  fit <- mod$sample(data = dat)
  end_time = Sys.time()
  
  print(end_time-start_time)
  print("Saving model fit...")
  
  fit$save_object(file = output_path)
  
  return(fit)
}

ode_fit1 = test_model(testData, "stanModels/odeTest1.stan", "stanModels/fit_odeTest1.RDS")
ode_fit2 = test_model(testData, "stanModels/odeTest2.stan", "stanModels/fit_odeTest2.RDS")
