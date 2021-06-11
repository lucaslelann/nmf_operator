library(tercen)
library(dplyr)
library(NMF)

minmax <- function(x) { return((x- min(x)) /(max(x)-min(x))) }

ctx <- tercenCtx()

n_clust <- 5
if(!is.null(ctx$op.value("n_clust"))) n_clust <- as.integer(ctx$op.value("n_clust"))

nmf_method <- "offset"
if(!is.null(ctx$op.value("nmf_method"))) n_clust <- as.character(ctx$op.value("nmf_method"))

df <- ctx$as.matrix() %>% t
colnames(df) <- ctx$rselect()[[1]]
df <- df %>% as_tibble
df <- as_tibble(lapply(df, minmax))

fit.nmf <- nmf(
  asinh(x = df),
  5,
  method=nmf_method
)
w.mat <- NMF::basis(fit.nmf)
clusters <- max.col(w.mat, ties.method = "first")

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
