## Train random forest on MCC and SCLC tumor samples
## Apply to cell lines

set.seed(1)

MCC.tumor.sample.names <- subset(sampleNames(eset.original.filter),
                                 pData(eset.original.filter)$type == "MCC tissue")

eset.tumors <- eset.original.filter[, MCC.tumor.sample.names]

dataset.train <- eset.tumors

edata.train <- t(exprs(dataset.train))
classes.train <- factor(pData(dataset.train)$MCPyV.status)

ntree <- 3000
ntree.trace <- 0.1 * ntree
sampsize <- c(5, 5)

rf.eset.tumorcomp <- randomForest(x=edata.train,
                                  y=classes.train,
                                  strata=classes.train,
                                  sampsize=sampsize,
                                  ntree=ntree,
                                  replace=TRUE,
                                  importance=TRUE,
                                  proximity=TRUE,
                                  keep.trees=FALSE,
                                  keep.inbag=TRUE,
                                  do.trace=ntree.trace)

rf.eset.tumorcomp

## Need to cache these to compile RMarkdown reports (in ./reports/)
ProjectTemplate::cache("rf.eset.tumorcomp")
