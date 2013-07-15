## Make a correlation boxplot comparing the cell lines to the tumors

dataset.original <- eset.original.filter

# Subset of samples and make sample classes
which.MCCtumor <- grep("MT.*", sampleNames(dataset.original))
which.mkl1 <- grep("Mkl.*", sampleNames(dataset.original))
which.waga <- grep("Waga.*", sampleNames(dataset.original))
which.uiso <- grep("UISO_late.*", sampleNames(dataset.original))

keep <- c(which.MCCtumor, which.mkl1, which.waga, which.uiso)
dataset.original <- dataset.original[, keep]

pData(dataset.original)$sample_class <- factor(rep(c("Tumor", "Mkl-1", "WaGa", "UISO"),
                                                   c(length(which.MCCtumor), length(which.mkl1), length(which.waga), length(which.uiso))))

pData(dataset.original)$sample_class <- factor(c(rep("Tumor", length(which.MCCtumor)),
                                                 rep("Mkl-1", length(which.mkl1)),
                                                 rep("WaGa", length(which.waga)),
                                                 rep("UISO", length(which.uiso))))

dataset <- dataset.original

# Compute correlation
dataset.cor <- cor(exprs(dataset), method='spearman')

# Keep only the necessary columns and rows and
# set self correlation values (including within group) to NA
dataset.cor[upper.tri(dataset.cor, diag=TRUE)] <- NA
# upperTriangle(dataset.cor, diag=TRUE) <- NA
dataset.cor[grep("Mkl", rownames(dataset.cor)), grep("Mkl", rownames(dataset.cor))] <- NA
dataset.cor[grep("Waga", rownames(dataset.cor)), grep("Waga", rownames(dataset.cor))] <- NA
dataset.cor[grep("UISO", rownames(dataset.cor)), grep("UISO", rownames(dataset.cor))] <- NA

exclude.rows <- -(1:(length(which.MCCtumor)))
dataset.cor <- dataset.cor[exclude.rows, ]

# Reshape the data
dataset.cor <- transform(dataset.cor, sample=rownames(dataset.cor))
dataset.cor.melted <- melt(dataset.cor, id.vars=c("sample"), na.rm=TRUE)

# For some reason, melt changed the Mkl-1's name...
dataset.cor.melted$variable <- factor(gsub("\\.", "-", dataset.cor.melted$variable))

# Get sample_class from the phenotypeData based on the sample column
dataset.cor.melted <- merge(dataset.cor.melted, pData(dataset)[, c("sample", "sample_class")], by.x="sample", by.y="sample")

dataset.cor.melted$sample_class <- factor(dataset.cor.melted$sample_class, 
                                          levels=c("Mkl-1", "WaGa", "UISO"),
                                          labels=c("Mkl-1", "WaGa", "UISO"),
                                          ordered=TRUE)

# Get everything from the phenotypeData again, based on the variable column
dataset.cor.melted <- merge(dataset.cor.melted, pData(dataset.original), by.x="variable", by.y="sample")
dataset.cor.melted <- dataset.cor.melted[, c('sample', 'variable', 'value', 'sample_class.x', "sample_class.y", "MCPyV.status")]

# Add some grouping factors
dataset.cor.melted <- transform(dataset.cor.melted,
                                comparison=factor(with(dataset.cor.melted, paste(sample_class.x, sample_class.y, sep=".")),
                                                  levels=c("Mkl-1.Tumor", "WaGa.Tumor", "UISO.Tumor", "WaGa.Mkl-1", "UISO.Mkl-1", "UISO.WaGa"),
                                                  ordered=TRUE),
                                tumorORnot=factor(dataset.cor.melted$sample_class.y == "Tumor", #c("MCC Tumor", "SCLC Tumor"), 
                                                  labels=c("Cell line vs. cell line", "Cell line vs. tumor")))


# plot
p <- ggplot(dataset.cor.melted, aes(x=comparison, y=value))
p <- p + geom_boxplot(notch=FALSE, outlier.size=0)
p <- p + geom_jitter(aes(color=MCPyV.status, shape=MCPyV.status), position=position_jitter(width=0.1), alpha=0.6)
p <- p + facet_grid(. ~ tumorORnot, scales="free_x")
p <- p + labs(x="", y=expression(Correlation~(rho)))
p <- p + scale_color_brewer(palette='Set1')
p <- p + guides(colour=guide_legend("Tumor MCV Status"), shape=guide_legend("Tumor MCV Status"))
p <- p + ylim(c(0.5,1))
p <- p + theme_bw() + theme(axis.text=element_text(size=20), 
                            legend.title=element_text(size=20),
                            legend.text=element_text(size=20),
                            legend.position=c(0.6, 0.2),
                            axis.title.x=element_text(size=20),
                            axis.title.x=element_text(size=20),
                            axis.title.y=element_text(size=20, angle=90),
                            strip.text.x=element_text(size=24))

## print(p)
ggsave("graphs/correlation_boxplot_celllines.pdf", p, width=15, height=7, dpi=300)
