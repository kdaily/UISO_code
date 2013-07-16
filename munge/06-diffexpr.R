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

# At time of writing, Vennerable could not be installed for R 3.0.0
# If you have R <= 2.15, install Vennerable and then the following will run

# testdec.venn <- Venn(testdec.list)
# pdf("graphs/proportionalvenn.cellvstumor.pdf", width=10, height=10)
# plot(testdec.venn, doWeights=TRUE, show=list(Faces=TRUE), type="circles")
# dev.off()

# This is a workaround using venneuler
# The plot is representative of the one in the publication
setmember <- with(ldply(testdec.list, .fun=length), rep(.id, V1))
element <- as.character(unlist(testdec.list))
m <- data.frame(element, setmember)
v <- venneuler(m)
pdf("graphs/proportionalvenn.cellvstumor.pdf", width=10, height=10)
plot(v)
dev.off()

# Regular venn diagram to see the counts of things in each set
pdf("graphs/venn.cellvstumor.pdf")
vennDiagram(testdec[, 1:3])
dev.off()
