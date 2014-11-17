# plotdata$newclass <- ifelse(plotdata$class == "Tumor",
#                             as.character(plotdata$cancertype),
#                             as.character(plotdata$class))
# 
# plotdata$newclass <- factor(plotdata$newclass, ordered=TRUE,
#                             levels=c("MC01", "WaGa", "Mkl1", "UISO", "MCC13", "MCC26", "MCC", "SCLC"),
#                             labels=c("MC01", "WaGa", "Mkl-1", "UISO", "MCC13", "MCC26", "MCC Tumor", "SCLC Tumor"))


source("lib.R")

# expand iris data frame for pairs plot
gg1 = makePairs(plotdata[, c("PC1", "PC2", "PC3")])

# new data frame mega iris
mega_data = data.frame(gg1$all,
                       class=rep(plotdata$newclass, length=nrow(gg1$all)),
                       sample.type=rep(plotdata$sample.type, length=nrow(gg1$all)),
                       MCPyV.status=rep(plotdata$MCPyV.status, length=nrow(gg1$all)))

# pairs plot
type.colors <- c(brewer.pal(9, "Blues")[c(8, 4, 6)], 
                 brewer.pal(9, "Greens")[c(8)], 
                 brewer.pal(9, "Oranges")[c(4, 6)], 
                 brewer.pal(9, "Blues")[c(9)], 
                 brewer.pal(9, "Reds")[c(8)]) 

point.shapes <- c(19,19,19,19,19,19,17,17)

p <- ggplot(mega_data, aes_string(x = "x", y = "y"))
p <- p + facet_grid(xvar ~ yvar, scales = "free")
p <- p + geom_point(aes(colour=class, shape=sample.type), na.rm = TRUE, alpha=0.8, size=4)

# MCV positive cases
mega_data.MCV <- subset(mega_data, MCPyV.status == "Virus negative")
p <- p + geom_point(data=mega_data.MCV, colour="white", shape="x", na.rm = TRUE, alpha=0.8, size=4)

# p <- p + stat_density(aes(x = x, y = ..scaled.. * diff(range(x)) + min(x)),
#                       data = gg1$densities, position = "identity",
#                       colour = "grey20", geom = "line")
p <- p + scale_color_manual("Sample group", values=type.colors)
p <- p + scale_shape_manual("Sample type", values=c(19,17), guide = 'none')
p <- p + guides(color=guide_legend("Sample group", override.aes = list(shape=point.shapes)))
p <- p + labs(x="", y="")
p <- p + theme_bw() + theme(legend.position="top",
                            strip.text=element_text(size=14),
                            axis.title=element_text(size=14),
                            axis.text=element_blank(),
                            legend.title=element_text(size=14),
                            legend.text=element_text(size=12))
p

