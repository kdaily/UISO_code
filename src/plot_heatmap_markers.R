## Heatmap of MCC and SCLC markers

## Set up all comparisons of individual cell lines and tumor samples
MCC.sample.names <- c(grep("MT.*", sampleNames(eset.original.filter), value=TRUE),
                      grep("LT.*", sampleNames(eset.original.filter), value=TRUE),
                      grep("Mkl.*", sampleNames(eset.original.filter), value=TRUE),
                      grep("Waga.*", sampleNames(eset.original.filter), value=TRUE),
                      grep("UISO.*", sampleNames(eset.original.filter), value=TRUE))

dataset <- eset.original.filter[, MCC.sample.names]
# sampleNames(dataset) <- gsub("_late", "", sampleNames(dataset))
# pData(dataset)$sample <- gsub("_late", "", pData(dataset)$sample)

# select by probe
controls <- c("213953_at", "204697_s_at", "212843_at", "201313_at", "209016_s_at", "221916_at", "221336_at")
esetSel <- dataset[controls, ]

controls.gene.symbols <- fData(esetSel)$gene.symbol
controls.gene.levels <- rev(c("CHGA", "NCAM1", "ENO2", "KRT20", "NEFL", "ATOH1", "KRT7"))
controls.gene.labels <- rev(c("CHG", "CD56", "NSE", "CK20", "NEFL", "ATOH1", "KRT7"))
controls.gene.symbols <- factor(as.character(fData(esetSel)$gene.symbol), 
                                levels=controls.gene.levels,
                                labels=controls.gene.labels, ordered=TRUE)


tmpdata <- cbind(exprs(esetSel), fData(esetSel))

my.mat.melted <- melt(tmpdata, id.vars=c("ID", "gene.symbol"), measure.vars=sampleNames(esetSel))
colnames(my.mat.melted) <- c("ID", "gene.symbol", "sample", "value")

my.mat.melted <- merge(my.mat.melted, pData(esetSel), by.x="sample", by.y="sample")

my.mat.melted <- transform(my.mat.melted, plot.name=paste(gene.symbol, ID), sample.type=factor(as.character(sample.type), labels=c("Cell Line", "Tissue")))
## my.mat.melted <- transform(my.mat.melted, plot.name=factor(plot.name, levels=plot.name[fit.rows$order], ordered=TRUE))

my.mat.melted <- transform(my.mat.melted,
                           sample=factor(sample, levels=unique(sample[order(sample.type)]), ordered=TRUE),
                           plot.name=factor(plot.name, levels=plot.name[order(gene.symbol)], ordered=TRUE))


my.mat.melted$gene.symbol <- factor(as.character(my.mat.melted$gene.symbol), 
                                    levels=controls.gene.levels,
                                    labels=controls.gene.labels, ordered=TRUE)

p <- ggplot(my.mat.melted, aes(y=gene.symbol, x=sample))
p <- p + geom_tile(aes(fill=value), size=0.5, color="white")
p <- p + scale_fill_gradient2("", low="blue", mid="white", high="red",
                              breaks=seq(2,16,2), limits=c(2,15),
                              midpoint=median(exprs(eset.original.filter)))
p <- p + labs(y="Gene", x="Sample")
p <- p + facet_grid(. ~ cancertype + sample.type, scales="free", space="free")
p <- p + theme_bw()
p <- p + theme(axis.text.x=element_text(size=16, angle=270, vjust=0.5), axis.text.y=element_text(size=16),
               axis.title.x=element_text(size=20), axis.title.y=element_text(size=20, angle=90),
               legend.key.width=unit(25, "points"),
               legend.key.height=unit(50, "points"),
               legend.text=element_text(size=12),
               legend.title=element_text(size=16),
               strip.text.x=element_text(size=20)) ## + coord_flip()

print(p)
ggsave("graphs/heatmap_markers.pdf", width=20, height=5, dpi=300)
