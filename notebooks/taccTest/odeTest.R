library(cmdstanr)

# Compare stan model fitting time using ODE vs no ODE for a function with an analytical solution


test_model = function(testData, model_path, output_path){
  
  mod = cmdstan_model(model_path)
  start_time = Sys.time()
  fit <- mod$sample(data = testData)
  end_time = Sys.time()
  
  print(end_time-start_time)
  print("Saving model fit...")
  
  fit$save_object(file = output_path)
  
  return(fit)
}

ode_fit1 = test_model("stanModels/odeTest1.stan", "stanModels/fit_odeTest1.RDS")
ode_fit2 = test_model("stanModels/odeTest2.stan", "stanModels/fit_odeTest2.RDS")