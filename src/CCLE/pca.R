## Do PCA

dataset <- eset.batcheffect.nomod

pca <- prcomp(t(exprs(dataset)), scale=TRUE)
pc <- pca$x

## Proportion of variance
pca.summary <- summary(pca)
pca.var <- data.frame(variance=pca.summary$importance[2, ], pc=names(pca.summary$importance[2, ]))
pca.var <- head(pca.var, 10)
pca.var <- transform(pca.var, pc=factor(pc, levels=names(pca.summary$importance[2, ]), ordered=TRUE))
p <- ggplot(pca.var, aes(x=pc, y=variance)) + geom_bar(stat="identity")
p <- p + theme_bw() + theme(axis.text.x=element_text(size=14, angle=270),
                            axis.text.y=element_text(size=10),
                            legend.position="none") ## + coord_flip()

pdf("graphs/ccle_pca_variance.pdf", width=10, height=10)
print(p)
dev.off()

## Plot on PC1 and PC2
pc.data <- data.frame(pc, sample=rownames(pc))
rownames(pc.data) <- rownames(pc)
pc.data <- cbind(pc.data[rownames(pc), ], pData(dataset)[rownames(pc), ])

pc.data$cancer.type <- factor(as.character(pc.data$cancer.type),
                             levels=c("MCC", "Ewings", "Hepato", "Lung Adeno", "Breast", "Lung SCC", "Melanoma", "Pancreas", "SCLC"),
                              ordered=TRUE)

samplename.labels <- ifelse(as.character(pc.data$cancer.type) == "MCC", rownames(pc.data), "")

pc.data.other <- subset(pc.data, !(cancer.type %in% c('MCC')))
pc.data.MCC <- subset(pc.data, cancer.type == 'MCC' & !grepl("UISO", pc.data$sample))
pc.data.UISO <- subset(pc.data, cancer.type == 'MCC' & grepl("UISO", pc.data$sample))

p <- ggplot()
p <- p + geom_point(data=pc.data.other, aes(x=PC1, y=PC2, color=cancer.type), alpha=0.5, size=5, show_guide=TRUE)
p <- p + scale_colour_manual("Cancer type",
                             values=c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00", "#D94801", "#A65628", "#F781BF"))

p <- p + geom_point(data=pc.data.MCC, aes(x=PC1, y=PC2), size=7, color="black")
p <- p + geom_point(data=pc.data.MCC, aes(x=PC1, y=PC2), size=5, color="#F41A1C")
p <- p + geom_text(data=pc.data.MCC, aes(x=PC1, y=PC2, label=rownames(pc.data.MCC)),
                   hjust=1.0, vjust=-1.25, size=4)

p <- p + geom_point(data=pc.data.UISO, aes(x=PC1, y=PC2), size=7, color="black")
p <- p + geom_point(data=pc.data.UISO, aes(x=PC1, y=PC2), size=5, color="#6BAED6")
p <- p + geom_text(data=pc.data.UISO, aes(x=PC1, y=PC2, label=rownames(pc.data.UISO)),
                   hjust=-0.1, vjust=-0.75, size=4)

p <- p + labs(x="Principal component 1", y="Principal component 2")
p <- p + theme_bw() + theme(legend.position=c(0.85,0.2),
                            legend.title=element_text(size=14),
                            legend.text=element_text(size=12),
                            legend.background=element_rect(colour="black"),
                            panel.background = element_rect(fill = "#FFFFFF"))

p

ggsave("graphs/ccle_pca1v2.pdf", p, width=8, height=8)