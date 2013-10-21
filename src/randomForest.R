## Train random forest on MCC and SCLC tumor samples
## Apply to cell lines

set.seed(1)
dataset <- eset.original.filter

# Predict on cell lines
samplenames.predict <- c("MC01", "Mkl-1_1", "Mkl-1_2", "Mkl-1_3", "Mkl-1_4", "Mkl-1_5", "Mkl-1_6",
                         "Waga_1", "Waga_2", "Waga_3", "Waga_4", "Waga_5", "Waga_6",
                         "UISO_1", "UISO_2", "UISO_3", "UISO_4", "UISO_5", "UISO_6")

# Train on tumor samples
samplenames.train <- sampleNames(dataset)[!(sampleNames(dataset) %in% samplenames.predict)]

dataset.train <- dataset[, as.character(samplenames.train)]
edata.train <- t(exprs(dataset.train))
classes.train <- pData(dataset.train)$cancertype

## Use cell lines for prediction
dataset.predict <- dataset[, samplenames.predict]

## Use balanced sample size with the size of the smaller sample
sample.size <- c(8,8)

rf.eset <- randomForest(x=edata.train, y=classes.train, ntree=1000,
                        sampsize=sample.size, replace=TRUE, strata=classes.train,
                        importance=FALSE, proximity=TRUE, keep.trees=FALSE, keep.inbag=TRUE,
                        do.trace=100)

rf.predict <- cbind(as.data.frame(predict(rf.eset, t(exprs(dataset.predict)), type="prob")),
                    class=pData(dataset.predict)$class)


## Need to cache these to compile RMarkdown reports (in ./reports/)
ProjectTemplate::cache("rf.eset")
ProjectTemplate::cache("rf.predict")
ProjectTemplate::cache("samplenames.train")
ProjectTemplate::cache("classes.train")