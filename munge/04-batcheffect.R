# This does not run by default because it is very time consuming
# We determined that batch correction was not needed (and could not be effectively tested since most factors are confounded with the known batch)

# # Test for a batch effect on processing date while not controlling for any other factor
# exprs.batcheffect.noadj <- ComBat(dat=exprs(eset.original), batch=as.numeric(protocolData(data)$date), mod=NULL, numCovs=NULL, par.prior=par.prior)
# eset.batcheffect.noadj <- eset.original
# exprs(eset.batcheffect.noadj) <- exprs.batcheffect.noadj

# # Test for a batch effect on processing date while controlling for cancer type
# mod <- model.matrix(~as.factor(cancertype), data=pData(eset.original))
# par.prior <- FALSE
# exprs.batcheffect <- ComBat(dat=exprs(eset.original), batch=as.numeric(protocolData(data)$date), mod=mod, numCovs=NULL, par.prior=par.prior)
# eset.batcheffect <- eset.original
# exprs(eset.batcheffect) <- exprs.batcheffect

# # Test for a batch effect on processing date while controlling for sample type
# mod.sampletypeonly <- model.matrix(~ as.factor(sample.type), data=pData(eset.original))
# par.prior <- FALSE
# exprs.batcheffect.sampletypeonly <- ComBat(dat=exprs(eset.original), batch=as.numeric(protocolData(data)$date), mod=mod.sampletypeonly, numCovs=NULL, par.prior=par.prior)
# eset.batcheffect.sampletypeonly <- eset.original
# exprs(eset.batcheffect.sampletypeonly) <- exprs.batcheffect.sampletypeonly

# # Test for a batch effect on processing date while controlling for cancer type and sample type
# mod.sampletype <- model.matrix(~as.factor(cancertype) + as.factor(sample.type), data=pData(eset.original))
# par.prior <- FALSE
# exprs.batcheffect.sampletype <- ComBat(dat=exprs(eset.original), batch=as.numeric(protocolData(data)$date), mod=mod.sampletype, numCovs=NULL, par.prior=par.prior)
# eset.batcheffect.sampletype <- eset.original
# exprs(eset.batcheffect.sampletype) <- exprs.batcheffect.sampletype



