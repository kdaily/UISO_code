# Do random forest with all the cell lines EXCEPT UISO

set.seed(1)

tmp <- eset.batcheffect.nomod

dataset.filter <- nsFilter(tmp, remove.dupEntrez=FALSE, require.entrez=FALSE, var.cutoff=0.4)
print(dataset.filter$filter.log$numLowVar)
dataset <- dataset.filter$eset

## Use all data except Variants
mcc.variants <- grepl("UISO", sampleNames(dataset)) | grepl("MCC", sampleNames(dataset))

dataset.train <- dataset[, !mcc.variants]
edata.train <- t(exprs(dataset.train))
classes.train.allcelllines <- factor(as.character(pData(dataset.train)$cancer.type))

dataset.test <- dataset[, mcc.variants]
edata.test <- t(exprs(dataset.test))


# set sample size to min sample size - 1
sample.size <- rep(min(table(classes.train.allcelllines)), length(levels(classes.train.allcelllines))) - 1

rf.eset.nouiso <- randomForest(x=edata.train, y=classes.train.allcelllines, ntree=1000,
                                     sampsize=sample.size, strata=classes.train.allcelllines, replace=TRUE,
                                     importance=TRUE, proximity=TRUE,
                                     keep.trees=FALSE, keep.inbag=TRUE,
                                     do.trace=100)

rf.eset.nouiso.predict <- as.data.frame(predict(rf.eset.nouiso, edata.test, type="prob"))
rf.eset.nouiso.predict$cancertype <- "MCCVariant"

rf.eset.nouiso.predict.train <- as.data.frame(predict(rf.eset.nouiso, edata.train, type="prob"))
rf.eset.nouiso.predict.train$cancertype <- classes.train.allcelllines

ProjectTemplate::cache('rf.eset.nouiso')
ProjectTemplate::cache('rf.eset.nouiso.predict')
ProjectTemplate::cache('rf.eset.nouiso.predict.train')
