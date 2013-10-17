## Comparisons of individual cell lines and tumor samples

MCC.sample.names <- subset(sampleNames(eset.original.filter), pData(eset.original.filter)$cancertype == "MCC")

eset.tumor.vs.cell <- eset.original.filter[, MCC.sample.names]

## Find array weights; had little effect on outcome
## array.weights <- arrayWeights(eset.tumor.vs.cell, design.tumor.vs.cell)
array.weights <- NULL

design.tumor.vs.cell <- model.matrix(~0 + pData(eset.tumor.vs.cell)$class)
colnames(design.tumor.vs.cell) <- levels(pData(eset.tumor.vs.cell)$class)

cont.matrix.tumor.vs.cell <- makeContrasts(Tumor.Mkl1=Mkl1 - Tumor,
                                           Tumor.WaGa=WaGa- Tumor,
                                           Tumor.UISO=UISO - Tumor,
                                           Mkl1.WaGa=Mkl1 - WaGa,
                                           Mkl1.UISO=Mkl1 - UISO,
                                           WaGa.UISO=WaGa - UISO,
                                           levels=design.tumor.vs.cell)

fit.tumor.vs.cell <- lmFit(eset.tumor.vs.cell, design.tumor.vs.cell, weights=array.weights, method="ls")
fit2.tumor.vs.cell <- contrasts.fit(fit.tumor.vs.cell, cont.matrix.tumor.vs.cell)
fit2.tumor.vs.cell <- eBayes(fit2.tumor.vs.cell)

testdec <- decideTests(fit2.tumor.vs.cell, adjust.method="BH", p.value=0.05, lfc=1)
testdec.df <- abs(as.data.frame(testdec)[, c('Tumor.UISO', 'Tumor.Mkl1', 'Tumor.WaGa')])

testdec.list <- list(Tumor.UISO=rownames(subset(testdec.df, Tumor.UISO != 0)),
                     Tumor.Mkl1=rownames(subset(testdec.df, Tumor.Mkl1 != 0)),
                     Tumor.WaGa=rownames(subset(testdec.df, Tumor.WaGa != 0)))

ProjectTemplate::cache('testdec')
ProjectTemplate::cache('testdec.list')
ProjectTemplate::cache('testdec.df')
ProjectTemplate::cache('fit2.tumor.vs.cell')
