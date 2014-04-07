# WARNING! THIS STEP NEEDS AT LEAST 16GB OF MEMORY
# 
dataset <- eset.original.rma.u133plus2

## Don't use model for cancer type
mod <- NULL
par.prior <- TRUE

exprs.batcheffect.nomod <- ComBat(dat=exprs(dataset), batch=pData(dataset)$batch, mod=mod, numCovs=NULL, par.prior=par.prior, prior.plots=TRUE)
ProjectTemplate::cache("exprs.batcheffect.nomod")

eset.batcheffect.nomod <- dataset
exprs(eset.batcheffect.nomod) <- exprs.batcheffect.nomod
ProjectTemplate::cache("eset.batcheffect.nomod")
# arrayQualityMetrics(expressionset=eset.batcheffect.nomod, outdir="reports/QC/RMA_plus2_batcheffect/", intgroup="batch", force=T)
