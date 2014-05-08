## Comparisons of individual cell lines and tumor samples

MCC.tumor.sample.names <- subset(sampleNames(eset.original.filter), pData(eset.original.filter)$type == "MCC tissue")

eset.tumors <- eset.original.filter[, MCC.tumor.sample.names]

## Find array weights; had little effect on outcome
## array.weights <- arrayWeights(eset.tumor.vs.cell, design.tumor.vs.cell)
array.weights <- NULL

pData(eset.tumors)$MCPyV.status <- factor(pData(eset.tumors)$MCPyV.status, labels=c("negative", "positive"))
design.tumors.MCPyV.status <- model.matrix(~0 + pData(eset.tumors)$MCPyV.status)
colnames(design.tumors.MCPyV.status) <- levels(pData(eset.tumors)$MCPyV.status)

cont.matrix.tumors.MCPyV.status <- makeContrasts(MCPyV.status=positive - negative,
                                             levels=design.tumors.MCPyV.status)

fit.tumors.MCPyV.status <- lmFit(eset.tumors, design.tumors.MCPyV.status, weights=array.weights, method="ls")
fit2.tumors.MCPyV.status <- contrasts.fit(fit.tumors.MCPyV.status, cont.matrix.tumors.MCPyV.status)
fit2.tumors.MCPyV.status <- eBayes(fit2.tumors.MCPyV.status)

pData(eset.tumors)$privsmet <- factor(pData(eset.tumors)$privsmet)
design.tumors.privsmet <- model.matrix(~0 + pData(eset.tumors)$privsmet)
colnames(design.tumors.privsmet) <- levels(pData(eset.tumors)$privsmet)

cont.matrix.tumors.privsmet <- makeContrasts(privsmet=pri - met,
                                             levels=design.tumors.privsmet)

fit.tumors.privsmet <- lmFit(eset.tumors, design.tumors.privsmet, weights=array.weights, method="ls")
fit2.tumors.privsmet <- contrasts.fit(fit.tumors.privsmet, cont.matrix.tumors.privsmet)
fit2.tumors.privsmet <- eBayes(fit2.tumors.privsmet)


pData(eset.tumors)$recurrence <- factor(pData(eset.tumors)$recurrence)
design.tumors.recurrence <- model.matrix(~0 + pData(eset.tumors)$recurrence)
colnames(design.tumors.recurrence) <- levels(pData(eset.tumors)$recurrence)

cont.matrix.tumors.recurrence <- makeContrasts(recurrence=N - Y,
                                               levels=design.tumors.recurrence)

fit.tumors.recurrence <- lmFit(eset.tumors, design.tumors.recurrence, weights=array.weights, method="ls")
fit2.tumors.recurrence <- contrasts.fit(fit.tumors.recurrence, cont.matrix.tumors.recurrence)
fit2.tumors.recurrence <- eBayes(fit2.tumors.recurrence)

pData(eset.tumors)$stage.code <- factor(pData(eset.tumors)$stage.code)
design.tumors.stage.code <- model.matrix(~0 + pData(eset.tumors)$stage.code)
colnames(design.tumors.stage.code) <- levels(pData(eset.tumors)$stage.code)

cont.matrix.tumors.stage.code <- makeContrasts(stage.code=early - late,
                                               levels=design.tumors.stage.code)

fit.tumors.stage.code <- lmFit(eset.tumors, design.tumors.stage.code, weights=array.weights, method="ls")
fit2.tumors.stage.code <- contrasts.fit(fit.tumors.stage.code, cont.matrix.tumors.stage.code)
fit2.tumors.stage.code <- eBayes(fit2.tumors.stage.code)

ProjectTemplate::cache("fit2.tumors.privsmet")
ProjectTemplate::cache("fit2.tumors.recurrence")
ProjectTemplate::cache("fit2.tumors.stage.code")
ProjectTemplate::cache("fit2.tumors.MCPyV.status")



