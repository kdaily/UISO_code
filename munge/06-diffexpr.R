## Comparisons of individual cell lines and tumor samples

MCC.sample.names <- subset(sampleNames(eset.original.filter), pData(eset.original.filter)$cancertype == "MCC")

eset.tumor.vs.cell <- eset.original.filter[, MCC.sample.names]

## Find array weights; had little effect on outcome
## array.weights <- arrayWeights(eset.tumor.vs.cell, design.tumor.vs.cell)
array.weights <- NULL

design.tumor.vs.cell <- model.matrix(~0 + pData(eset.tumor.vs.cell)$classic)
colnames(design.tumor.vs.cell) <- levels(pData(eset.tumor.vs.cell)$classic)

cont.matrix.tumor.vs.cell <- makeContrasts(Tumor.Classic=ClassicCellLine - Tumor,
                                           Tumor.Variant=VariantCellLine- Tumor,
                                           Tumor.UISO=UISOCellLine - Tumor,
#                                            Classic.Variant=ClassicCellLine - VariantCellLine,
#                                            Classic.UISO=ClassicCellLine - UISOCellLine,
#                                            Variant.UISO=VariantCellLine - UISOCellLine,
                                           levels=design.tumor.vs.cell)

fit.tumor.vs.cell <- lmFit(eset.tumor.vs.cell, design.tumor.vs.cell,
                           weights=array.weights, method="ls")

fit2.tumor.vs.cell <- contrasts.fit(fit.tumor.vs.cell, cont.matrix.tumor.vs.cell)
fit2.tumor.vs.cell <- eBayes(fit2.tumor.vs.cell)

testdec <- decideTests(fit2.tumor.vs.cell, adjust.method="BH", p.value=0.05, lfc=1)
testdec.df <- abs(as.data.frame(testdec)[, c('Tumor.Classic', 'Tumor.Variant', 'Tumor.UISO')])

testdec.list <- list(Tumor.UISO=rownames(subset(testdec.df, Tumor.UISO != 0)),
                     Tumor.Classic=rownames(subset(testdec.df, Tumor.Classic != 0)),
                     Tumor.Variant=rownames(subset(testdec.df, Tumor.Variant != 0)))

ProjectTemplate::cache('testdec')
ProjectTemplate::cache('testdec.list')
ProjectTemplate::cache('testdec.df')
ProjectTemplate::cache('fit2.tumor.vs.cell')
