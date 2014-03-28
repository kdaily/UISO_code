# Install required libraries
required_libs <- c("ProjectTemplate", "reshape", "plyr", "ggplot2",
                   "knitr", "xtable", "grid", "affy", "annotate", "limma",
                   "hgu133a2.db", "hgu133plus2.db", "sva", "arrayQualityMetrics",
                   "affyQCReport", "snow", "cluster", "randomForest",
                   "sigclust", "genefilter", "GSA", "venneuler", "GEOquery", "devtools")

for (i in 1:length(required_libs)) {
  if (!(required_libs[i] %in% rownames(installed.packages()))) {
    install.packages(required_libs[i])
  }
}

# Install BioConductor
source("http://bioconductor.org/biocLite.R")
biocLite()

# Install dendextend from github
require(devtools)
install_github('dendextend', 'talgalili')
require(Rcpp)
install_github('dendextendRcpp', 'talgalili')

# rmarkdown for compiling reports (figures and supplementals) if not using
# RStudio
install_github("rstudio/rmarkdown")
