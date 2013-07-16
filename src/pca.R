## Do PCA

dataset <- eset.original.filter

pca <- prcomp(t(exprs(dataset)), scale=TRUE, center=TRUE)
pc <- pca$x

## Proportion of variance
pca.summary <- summary(pca)
pca.var <- data.frame(variance=pca.summary$importance[2, ], pc=names(pca.summary$importance[2, ]))
pca.var <- head(pca.var, 10)
pca.var <- transform(pca.var, pc=factor(pc, levels=names(pca.summary$importance[2, ]), ordered=TRUE))
p <- ggplot(pca.var, aes(x=pc, y=variance)) + geom_bar(stat="identity") + labs(x="Principal Component", y="Variance")
p <- p + theme_bw() + theme(axis.text.x=element_text(size=10, angle=270), 
                            axis.text.y=element_text(size=10),
                            legend.position="none") ## + coord_flip()

ggsave("graphs/pca_variance.pdf", p)

## Plot on PC1 and PC2
pc.data <- data.frame(pc, sample=rownames(pc))
rownames(pc.data) <- rownames(pc)
pc.data <- cbind(pc.data[rownames(pc), ], pData(dataset)[rownames(pc), ])

p <- ggplot(pc.data, aes(x=PC1, y=PC2)) + geom_point(aes(color=cancertype, 
                                                         shape=factor(sample.type, 
                                                                      labels=c("Cell line", "Tissue"))),
                                                     size=6)
p <- p + xlim(-75, 200)
p <- p + geom_text(aes(label=rownames(pc.data)), hjust=0.8, vjust=-0.75, size=4)
p <- p + scale_colour_brewer("Cancer type", palette="Set1")
p <- p + scale_shape_manual("Sample type", values=c(18,16))
p <- p + labs(x="Principal component 1", y="Principal component 2")
p <- p + theme_bw() + theme(legend.position=c(0.85, 0.85),
                           legend.title=element_text(size=14),
                           legend.text=element_text(size=12),
                           legend.background=element_rect(colour="black"),
                           axis.title.x=element_text(size=14), axis.title.y=element_text(size=14, angle=90),
                           axis.text.x=element_text(size=12), axis.text.y=element_text(size=12),
                           panel.background=element_rect())

ggsave("graphs/pca_1v2_cancertype.pdf", p, width=10, height=10)
