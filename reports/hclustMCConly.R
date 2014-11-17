MCC.sample.names <- subset(sampleNames(eset.original.filter), pData(eset.original.filter)$cancertype == "MCC")

dataset <- eset.original.filter[, MCC.sample.names]

d <- as.dist(1 - cor(exprs(dataset), method="spearman"))
agnes.hc <- agnes(d, diss=TRUE, method='average')

hc <- as.dendrogram(agnes.hc)
hc <- hang.dendrogram(hc, hang = 0.1)

virus.status <- pData(dataset)[labels(hc), ]$MCPyV.status

hc.colors <- ifelse(virus.status == "Virus positive", 'red', 'blue')
hc.colors[is.na(virus.status)] <- "black"
labels_colors(hc) <- hc.colors

plot(hc, xlab="Dissimilarity = 1 - Correlation", main="")
text(x=5.4, y=c(0.3, 0.27, 0.24),
     labels=c("MCV-positive", "MCV-negative", "Not tested"),
     col=c("red", "blue", "black"), cex=1.25)

# pdf("../graphs/fig1a.pdf", width=12, height=6)
# plot(hc, xlab="Dissimilarity = 1 - Correlation", main="")
# text(x=5.4, y=c(0.3, 0.27, 0.24),
#      labels=c("MCV-positive", "MCV-negative", "Not tested"),
#      col=c("red", "blue", "black"), cex=1.25)
# dev.off() # so device number is not printed.
