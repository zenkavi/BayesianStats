# Send to TACC via
# rsync -avzh nmm_tacc zenkavi@stampede2.tacc.utexas.edu:/work/04127/zenkavi/stampede2

library(cmdstanr)
library(RCurl)

# Read in most recent versions of helper functions from github
helpers_path = 'https://raw.githubusercontent.com/zenkavi/NetworkGLM/master/helpers/r_helpers/'
eval(parse(text = getURL(paste0(helpers_path, 'networkModel.R'), ssl.verifypeer = FALSE)))
eval(parse(text = getURL(paste0(helpers_path, 'make_stimtimes.R'), ssl.verifypeer = FALSE)))

W = matrix(c(0, .2, 0,
             .4, 0, 0,
             0, .3, 0), nrow=3, byrow=T)

task = data.frame(stim = c(c(0,0,0,1),rep(0,97)))

task$time = rep(1:nrow(task))

cur_args_dict = list('dt'=.5,  
                     'g'=1, 
                     'noise'= NULL,
                     'noise_loc'= 0, 
                     'noise_scale'= 0,
                     's'=.7,
                     'stim_mag'=.5,
                     'taskdata'=NULL,
                     'tasktiming'=task$stim,
                     'tau'=1, 
                     'Tmax'=max(task$time),
                     'W'= W)

cur_args_dict$stim_node = 1
cur_args_dict$I = make_stimtimes(cur_args_dict$stim_node, cur_args_dict)$stimtimes

net_dat = networkModel(W, cur_args_dict)

nmm_data = list(N_TS = dim(net_dat)[2],
                N = dim(net_dat)[1],
                ts = 1:dim(net_dat)[2],
                y_init = net_dat[,1],
                y = t(net_dat),
                W = cur_args_dict$W,
                I = cur_args_dict$I[1,],
                t0 = 0)

# Can check compiling locally
mod = cmdstan_model("stanModels/nmm_ode.stan")

#DO NOT RUN LOCALLY
start_time = Sys.time()
print("Beginning sampling...")
fit <- mod$sample(data = nmm_data)
print("Saving model fit...")
fit$save_object(file = "fit_nmm_ode.RDS")
end_time = Sys.time()
print(end_time-start_time)