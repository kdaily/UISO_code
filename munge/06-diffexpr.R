## Set up all comparisons of individual cell lines and tumor samples
MCC.sample.names <- c(grep("MT.*", sampleNames(eset.original), value=TRUE),
                      grep("Mkl.*", sampleNames(eset.original), value=TRUE),
                      grep("Waga.*", sampleNames(eset.original), value=TRUE),
                      grep("UISO.*", sampleNames(eset.original), value=TRUE))

eset.tumor.vs.cell <- eset.original.filter[, MCC.sample.names]

MCC.samples <- data.frame(class=gsub("MT.*", "Tumor", MCC.sample.names))
MCC.samples <- transform(MCC.samples, class=gsub("_.*$", "", class))
MCC.samples <- transform(MCC.samples, class=gsub("-", "", class))
MCC.samples <- transform(MCC.samples, class=factor(class))

rownames(MCC.samples) <- MCC.sample.names

MCC.samples <- transform(MCC.samples, type=c(rep("Tumor", 23), rep("ClassicCellLine", 12), rep("UISOCellLine", 9)))

pData(eset.tumor.vs.cell) <- transform(pData(eset.tumor.vs.cell), sample_class=MCC.samples$class, sample_type=MCC.samples$type)

## Find array weights; had little effect on outcome
## array.weights <- arrayWeights(eset.tumor.vs.cell, design.tumor.vs.cell)
array.weights <- NULL

design.tumor.vs.cell <- model.matrix(~0 + MCC.samples$class)
colnames(design.tumor.vs.cell) <- levels(MCC.samples$class)

cont.matrix.tumor.vs.cell <- makeContrasts(Tumor.Mkl1=Mkl1 - Tumor,
                                           Tumor.Waga=Waga- Tumor,
                                           Tumor.UISO=UISO - Tumor,
                                           Mkl1.Waga=Mkl1 - Waga,
                                           Mkl1.UISO=Mkl1 - UISO,
                                           Waga.UISO=Waga - UISO,
                                           levels=design.tumor.vs.cell)

fit.tumor.vs.cell <- lmFit(eset.tumor.vs.cell, design.tumor.vs.cell, weights=array.weights, method="ls")
fit2.tumor.vs.cell <- contrasts.fit(fit.tumor.vs.cell, cont.matrix.tumor.vs.cell)
fit2.tumor.vs.cell <- eBayes(fit2.tumor.vs.cell)

testdec <- decideTests(fit2.tumor.vs.cell, adjust.method="BH", p.value=0.05, lfc=1)
testdec.df <- abs(as.data.frame(testdec)[, c('Tumor.UISO', 'Tumor.Mkl1', 'Tumor.Waga')])

testdec.list <- list(Tumor.UISO=rownames(subset(testdec.df, Tumor.UISO != 0)),
                     Tumor.Mkl1=rownames(subset(testdec.df, Tumor.Mkl1 != 0)),
                     Tumor.WaGa=rownames(subset(testdec.df, Tumor.Waga != 0)))

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

# Compare all classic cell lines (Mkl-1 and WaGa) to UISO and MCC tumors
design.tumor.classic.variant <- model.matrix(~0 + MCC.samples$type)
colnames(design.tumor.classic.variant) <- levels(MCC.samples$type)

cont.matrix.tumor.classic.variant <- makeContrasts(Classic.Tumor=ClassicCellLine - Tumor,
                                                   Classic.UISO=ClassicCellLine - UISOCellLine,
                                                   levels=design.tumor.classic.variant)

fit.tumor.classic.variant <- lmFit(eset.tumor.vs.cell, design.tumor.classic.variant, weights=array.weights, method="ls")
fit2.tumor.classic.variant <- contrasts.fit(fit.tumor.classic.variant, cont.matrix.tumor.classic.variant)
fit2.tumor.classic.variant <- eBayes(fit2.tumor.classic.variant)
 
testdec <- decideTests(fit2.tumor.classic.variant, lfc=1)
testdec.df <- abs(as.data.frame(testdec))

testdec.list <- list(Classic.Tumor=rownames(subset(testdec.df, Classic.Tumor != 0)),
                     Classic.UISO=rownames(subset(testdec.df, Classic.UISO != 0)))

# At time of writing, Vennerable could not be installed for R 3.0.0
# If you have R <= 2.15, install Vennerable and then the following will run

# testdec.venn <- Venn(testdec.list)
# pdf("graphs/proportionalvenn.tumorclassicvariant.pdf", width=10, height=10)
# plot(testdec.venn, doWeights=TRUE, show=list(Faces=TRUE), type="circles")
# dev.off()

# This is a workaround using venneuler
# The plot is representative of the one in the publication
setmember <- with(ldply(testdec.list, .fun=length), rep(.id, V1))
element <- as.character(unlist(testdec.list))
m <- data.frame(element, setmember)
v <- venneuler(m)
pdf("graphs/proportionalvenn.tumorclassicvariant.pdf", width=10, height=10)
plot(v)
dev.off()

pdf("graphs/venn.tumorclassicvariant.pdf")
vennDiagram(testdec)
dev.off()
