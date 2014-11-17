library(rgl)

# pairs plot
type.colors <- c(brewer.pal(9, "Blues")[c(8, 4, 6)], 
                 brewer.pal(9, "Greens")[c(8)], 
                 brewer.pal(9, "Oranges")[c(4, 6)], 
                 brewer.pal(9, "Blues")[c(9)], 
                 brewer.pal(9, "Reds")[c(8)]) 

plotdata$color <- type.colors[match(plotdata$newclass, levels(plotdata$newclass))]

pp <- dget("pca3dview.R")

plot3d(x=plotdata$PC1, y=plotdata$PC2, z=plotdata$PC3, 
       xlab="PC1", ylab="PC2", zlab="PC3", 
       type="s", col=plotdata$color, size=1,
       box=TRUE, axes=TRUE)
par3d(pp)

pp <- par3d(no.readonly=TRUE)
dput(pp, file="pca3dview.R", control = "all")

