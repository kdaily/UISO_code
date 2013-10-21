# Install required libraries
required_libs <- c("ProjectTemplate", "reshape", "plyr", "ggplot2",
                   "xtable", "grid", "affy", "annotate", "limma",
                   "hgu133a2.db", "sva", "arrayQualityMetrics",
                   "affyQCReport", "snow", "cluster", "randomForest",
                   "sigclust", "genefilter", "GSA", "venneuler", "GEOquery")

for (i in 1:length(required_libs)) {
  if (!(required_libs[i] %in% rownames(installed.packages()))) {
    install.packages(required_libs[i])
  }
}

# Install BioConductor
source("http://bioconductor.org/biocLite.R")
biocLite()
