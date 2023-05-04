library(cmdstanr)
model <- cmdstan_model("slr_ex.stan")




x <- rnorm(1000, 4)
y <- 4 - 3 * x + rnorm(1000, sd = 2)
data <- list(N = length(x), X = x, Y = y)
res <- model$sample(data = data, seed = 655,
                    chains = 6, iter_warmup = 2000,
                    iter_sampling = 3000
                    )
res_sum <- res$summary()
