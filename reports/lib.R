# From http://gastonsanchez.wordpress.com/2012/08/27/scatterplot-matrices-with-ggplot/
makePairs <- function(data)
{
  grid <- expand.grid(x = 1:ncol(data), y = 1:ncol(data))
  grid <- subset(grid, x != y)
  all <- do.call("rbind", lapply(1:nrow(grid), function(i) {
    xcol <- grid[i, "x"]
    ycol <- grid[i, "y"]
    data.frame(xvar = names(data)[ycol], yvar = names(data)[xcol],
               x = data[, xcol], y = data[, ycol], data)
  }))
  all$xvar <- factor(all$xvar, levels = names(data))
  all$yvar <- factor(all$yvar, levels = names(data))
  densities <- do.call("rbind", lapply(1:ncol(data), function(i) {
    data.frame(xvar = names(data)[i], yvar = names(data)[i], x = data[, i])
  }))
  list(all=all, densities=densities)
}

# Get specific cols from phenodata of an ExpressionSet
usefulpdata <- function(eset, cols=c("sample", "MCPyV.status", "classic", "class", "privsmet", "stage.code", "type")) {
  
  pData(eset)[, cols]
  
}


processct <- function(filename, ...) {
  CtData <- SDMFrame(filename)
  
  result <- ddCtExpression(CtData, ...)
  result
  
}

formatctdata <- function(result, gene.levels) {
  exprs.melted <- melt(exprs(result))
  Ct.melted <- melt(Ct(result))
  Cterrs.melted <- melt(CtErr(result))
  ddCt.melted <- melt(ddCt(result))
  dCt.melted <- melt(dCt(result))
  dCterrs.melted <- melt(dCtErr(result))
  CN.melted <- melt(2**(-dCt(result)))
  
  data.melted <- data.frame(Gene=factor(exprs.melted$Detector,
                                        levels=gene.levels, ordered=TRUE),
                            Sample=factor(exprs.melted$Sample), 
                            Ct=Ct.melted$value,
                            ddCt=ddCt.melted$value,
                            dCt=dCt.melted$value,
                            dCtSE=dCterrs.melted$value,
                            CopyNumber=CN.melted$value) 
  
  data.melted
  
}