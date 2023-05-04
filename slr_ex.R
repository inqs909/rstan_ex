library(cmdstanr)
library(parallel)
model <- cmdstan_model("slr_ex.stan")



slr_sim <- \(index){
x <- rnorm(1000, 4)
y <- 4 - 3 * x + rnorm(1000, sd = 2)
data <- list(N = length(x), X = x, Y = y)
res <- model$sample(data = data, chains = 4, 
                  iter_warmup = 2000, iter_sampling = 3000
                    )
res_sum <- res$summary()$mean
return(res_sum)
}

post <- mclapply(1:1000, slr_sim, mc.cores = 25)

nsim <- length(post)
nparam <- length(post[[1]])
res_mat <- matrix(nrow = nsim, ncol = nparam)
for(i in 1:nsim){
res_mat[i,] <- post[[i]]
}
colMeans(res_mat)
apply(res_mat, 2, sd)

