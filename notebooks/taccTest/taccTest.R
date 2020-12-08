library(cmdstanr)

set.seed(343857240)

make_fake_data = function(n=250, bs =c(.5, .7), sigma = .5){
  data = data.frame(x1 = rnorm(n, 0, 1),
                    x2 = rnorm(n, 0, 1))
  
  data = data %>% 
    mutate(noise = rnorm(n, mean = 0, sd = sigma),
           y = bs[1]*x1+bs[2]*x2+noise)
  return(data)
}

testData = make_fake_data(n=500)

mod = cmdstan_model("stanModels/taccTest.stan")

start = Sys.time()
fit <- mod$sample(data = testData)
end = start = Sys.time()

print(end-start)
print("Saving model fit...")

fit$save_object(file = "fit_taccTest.RDS")