## Use the original cdf, hgu133plus2
data.cel.combined.u133plus2 <- ReadAffy(filenames=as.character(pdata.combined$cel.file.name),
                                        sampleNames=pdata.combined$sample,
                                        phenoData=pdata.combined,
                                        cdfname="hgu133plus2")


featureData(data.cel.combined.u133plus2) <- fdata.hgu133plus2
ProjectTemplate::cache("data.cel.combined.u133plus2")

