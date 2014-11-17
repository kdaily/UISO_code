# From https://gist.github.com/kdaily/7806586

# Convert an ExpressionSet into a GCT file for GSEA or IGV.
eset2gct <- function(eset, filename) {
  
  numsamples <- ncol(exprs(eset))
  numprobes <- nrow(exprs(eset))
  row1.dummy <- rep("", numsamples + 1)
  row2.dummy <- rep("", numsamples)
  cat(c(paste(c("#1.2", row1.dummy), collapse="\t"), paste(c(numprobes, numsamples, row2.dummy), collapse="\t")), file=filename, sep="\n")
  tmp <- data.frame(NAME=rownames(exprs(eset)), Description="NA", exprs(eset))
  write.table(tmp, file=filename, sep="\t", append=TRUE, quote=FALSE, row.names=FALSE)
}

# Write out class labels
# Assumes that df has rows that represent each sample
# The classcol selected is converted to a factor
write_class <- function(df, classcol, filename) {
  classes <- factor(df[, classcol])
  cat(paste(c(nrow(df), length(levels(classes)), 1), collapse=" "),
      paste(c("#", levels(classes)), collapse=" "),
      paste(classes, collapse=" "), file=filename, sep="\n")
}

# Convert the ExpressionSet featureData into CHIP format for GSEA.
# Specify which column from the featureData to use as the ID, symbol, and description (title)
# Headers need to be as specified (Probe Set ID, Gene Symbol, Gene Title)
eset2chip <- function(eset, idcol="ID", symbolcol="gene.symbol", titlecol="Gene.Title", filename) {
  tmp <- fData(eset)[, c(idcol, symbolcol, titlecol)]
  colnames(tmp) <- c("Probe Set ID", "Gene Symbol", "Gene Title")
  write.table(tmp, file=filename, sep="\t", quote=FALSE, row.names=FALSE)
}

# Convert a limma differential expression fit object to a ranked list.
# Currently defaults to use the t-statistic.
fit2rnk <- function(fit, stat='t', coef, filename) {
  tt <- topTable(fit, coef=coef, n=1e10, sort.by="none")
  write.table(tt[, c("ID", stat)], file=filename, sep="\t", quote=FALSE, row.names=FALSE)
}

gsea_result_filename <- function(gsea_template, gsea_run, gsea_direction) {
  
  paste(gsea_template, ".", gsea_run, "/",
        "gsea_report_for_na_", gsea_direction, "_", gsea_run, ".xls",
        sep="")
  
}