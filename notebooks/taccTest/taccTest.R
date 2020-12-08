library(cmdstanr)

set.seed(343857240)

make_fake_data = function(n=250, bs =c(.5, .7), sigma = .5){
  data = data.frame(x1 = rnorm(n, 0, 1),
                    x2 = rnorm(n, 0, 1),
                    grainsize = 1)
  
  data = data %>% 
    mutate(noise = rnorm(n, mean = 0, sd = sigma),
           y = bs[1]*x1+bs[2]*x2+noise)
  return(data)
}

convert_to_standata = function(data){
  stanData = list(N = nrow(data), y=data$y, x1 = data$x1, x2 = data$x2, grainsize = unique(data$grainsize))
  return(stanData)
}

testData = make_fake_data(n=500)

test_model = function(model_path, output_path){
  mod = cmdstan_model(model_path)
  start_time = Sys.time()
  fit <- mod$sample(data = convert_to_standata(testData))
  end_time = Sys.time()
  
  print(end_time-start_time)
  print("Saving model fit...")
  
  fit$save_object(file = output_path)
  
  return(fit)
}

fit1 = test_model("stanModels/taccTest1.stan", "stanModels/fit_taccTest1.RDS")
fit2 = test_model("stanModels/taccTest2.stan", "stanModels/fit_taccTest2.RDS")
