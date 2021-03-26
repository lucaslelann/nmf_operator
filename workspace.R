library(tercen)
library(dplyr)
library(NMF)

options("tercen.workflowId" = "686a2e2bba117e0c118bcb715300b5d3")
options("tercen.stepId"     = "52110340-a9c9-49fd-ba1e-a9b0cc4639b4")

getOption("tercen.workflowId")
getOption("tercen.stepId")

minmax <- function(x) { return((x- min(x)) /(max(x)-min(x))) }

# To get a vector, use apply instead of lapply
ctx <- tercenCtx()

n_clust <- 5
if(!is.null(ctx$op.value("n_clust"))) n_clust <- as.integer(ctx$op.value("n_clust"))

df <- ctx$as.matrix() %>% t %>% as_tibble()
df <- as_tibble(lapply(df, minmax))
colnames(df) <- ctx$rselect()[[1]]

library(ANN2)
ac <- autoencoder(
  asinh(x = df)[, ], c(16, 2, 16),
  activ.functions = c("relu", "linear", "relu"),
  optim.type = "adam",
  loss.type = "squared",
  n.epochs = 30
)

encoded <- encode(ac, df)
encoded2 <- encode(ac, df,compression.layer = 3) > 0
clusters <- max.col(encoded2, ties.method = "first")
# clusters <- as.numeric(as.factor(apply(encoded2, 1, paste0, collapse = "")))
plot(encoded, col = clusters)

heatmap(encoded[1:1000, ])

reconstruction_plot(ac, df)
compression_plot(ac, df)
recX <- reconstruct(ac, df)
ac$
plot(recX$reconstructed)
ac$Rcpp_ANN$predict(as.matrix(df))

library(NMF)
fit.nmf <- nmf(
  asinh(x = df),
  5,
  method='offset'# 'Frobenius'
)
nmfAlgorithm()
# exctract the H and W matrices from the nmf run result
w.mat <- NMF::basis(fit.nmf)
clusters <- max.col(w.mat, ties.method = "first")
plot(encoded, col = clusters)

w.mat <- as.data.frame(w.mat)
colnames(w.mat) <- paste0("Archetype_", 1:ncol(w.mat))
w.mat$clusters <- clusters
w.mat$.ci <- seq(0, nrow(w.mat) - 1) 
w.mat <- w.mat %>%
  ctx$addNamespace()



h.mat <- t(NMF::coef(fit.nmf))
h.mat <- as.data.frame(h.mat)
colnames(h.mat) <- paste0("H_Archetype_", 1:ncol(h.mat))
h.mat$.ri <- seq(0, nrow(h.mat) - 1)
h.mat <- h.mat %>%
  ctx$addNamespace()

list(w.mat, h.mat) %>%
  ctx$save()
