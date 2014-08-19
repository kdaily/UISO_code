## Comparisons of individual cell lines and tumor samples

MCC.sample.names <- subset(sampleNames(eset.original.filter),
                           with(pData(eset.original.filter), cancertype == "MCC" & sample != "MC01"))

eset.tumor.vs.cell <- eset.original.filter[, MCC.sample.names]

## Find array weights; had little effect on outcome
## array.weights <- arrayWeights(eset.tumor.vs.cell, design.tumor.vs.cell)
array.weights <- NULL

design.tumor.vs.cell <- model.matrix(~0 + pData(eset.tumor.vs.cell)$classic)
colnames(design.tumor.vs.cell) <- levels(pData(eset.tumor.vs.cell)$classic)

cont.matrix.tumor.vs.cell <- makeContrasts(Tumor.Classic=Tumor - ClassicCellLine,
                                           Tumor.Variant=Tumor - VariantCellLine,
                                           Tumor.UISO=Tumor - UISOCellLine,
#                                            Classic.Variant=ClassicCellLine - VariantCellLine,
#                                            Classic.UISO=ClassicCellLine - UISOCellLine,
#                                            Variant.UISO=VariantCellLine - UISOCellLine,
                                           levels=design.tumor.vs.cell)

# Fit with filtered data
fit.tumor.vs.cell <- lmFit(eset.tumor.vs.cell, design.tumor.vs.cell,
                           weights=array.weights, method="ls")
fit2.tumor.vs.cell <- contrasts.fit(fit.tumor.vs.cell, cont.matrix.tumor.vs.cell)
fit2.tumor.vs.cell <- eBayes(fit2.tumor.vs.cell)

# Fit with non variance filtered data
fit.tumor.vs.cell.nofilter <- lmFit(eset.original[, MCC.sample.names],
                                    design.tumor.vs.cell,
                                    weights=array.weights, method="ls")
fit2.tumor.vs.cell.nofilter <- contrasts.fit(fit.tumor.vs.cell.nofilter, cont.matrix.tumor.vs.cell)
fit2.tumor.vs.cell.nofilter <- eBayes(fit2.tumor.vs.cell.nofilter)

testdec <- decideTests(fit2.tumor.vs.cell, adjust.method="BH", p.value=0.05, lfc=1)
testdec.df <- abs(as.data.frame(testdec)[, c('Tumor.Classic', 'Tumor.Variant', 'Tumor.UISO')])

testdec.list <- list(Tumor.UISO=rownames(subset(testdec.df, Tumor.UISO != 0)),
                     Tumor.Classic=rownames(subset(testdec.df, Tumor.Classic != 0)),
                     Tumor.Variant=rownames(subset(testdec.df, Tumor.Variant != 0)))

ProjectTemplate::cache('testdec')
ProjectTemplate::cache('testdec.list')
ProjectTemplate::cache('testdec.df')
ProjectTemplate::cache('fit2.tumor.vs.cell')

# Write out data to run in GSEA
# Needs to source("./lib/gsea_helpers.R")
eset2chip(eset.original.filter, filename="./data/GSEA/tumor_classic_variant_filter.chip")
fit2rnk(fit=fit2.tumor.vs.cell, stat="t", coef="Tumor.Classic", filename="./data/GSEA/tumor_vs_classic_filter.rnk")
fit2rnk(fit=fit2.tumor.vs.cell, stat="t", coef="Tumor.Variant", filename="./data/GSEA/tumor_vs_variant_filter.rnk")
fit2rnk(fit=fit2.tumor.vs.cell, stat="t", coef="Tumor.UISO", filename="./data/GSEA/tumor_vs_uiso_filter.rnk")

# Write out with unfiltered data
eset2chip(eset.original, filename="./data/GSEA/tumor_classic_variant.chip")
fit2rnk(fit=fit2.tumor.vs.cell.nofilter, stat="t", coef="Tumor.Classic", filename="./data/GSEA/tumor_vs_classic.rnk")
fit2rnk(fit=fit2.tumor.vs.cell.nofilter, stat="t", coef="Tumor.Variant", filename="./data/GSEA/tumor_vs_variant.rnk")
fit2rnk(fit=fit2.tumor.vs.cell.nofilter, stat="t", coef="Tumor.UISO", filename="./data/GSEA/tumor_vs_uiso.rnk")
