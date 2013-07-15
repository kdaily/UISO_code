## Use all probes after filtering to cluster

dataset <- eset.original.filter

d <- as.dist(1 - cor(exprs(dataset), method="spearman"))

pdf("graphs/agnes_hierarchical_average.pdf", width=12, height=6)
plot(agnes(d, diss=TRUE, method='average'), which.plots=2, xlab="Dissimilarity = 1 - Correlation", main="Average Linkage")
dev.off()
