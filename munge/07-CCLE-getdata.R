## Read the CCLE data
## Get data from GSE through GEO

## This data is split into 4 subsets
gse36133 <- getGEO("GSE36133", GSEMatrix=TRUE, destdir="./data/CCLE/")

exprs.gse36133 <- do.call('cbind', lapply(gse36133, exprs))
samplenames.gse36133 <- as.character(do.call("c", lapply(gse36133, sampleNames)))
pdata.gse36133 <- do.call('rbind', lapply(gse36133, pData))
rownames(pdata.gse36133) <- samplenames.gse36133
annotation.gse36133 <- annotation(gse36133$`GSE36133_series_matrix-1.txt.gz`)
fdata.gse36133 <- fData(gse36133$`GSE36133_series_matrix-1.txt.gz`)
eset.gse36133 <- new("ExpressionSet",
                     exprs = exprs.gse36133,
                     phenoData=as(pdata.gse36133, "AnnotatedDataFrame"),
                     annotation=annotation.gse36133,
                     featureData=as(fdata.gse36133, "AnnotatedDataFrame"))

## Only work with a few records of specific histological subtypes
pdata.keep.gse36133 <- subset(pData(eset.gse36133),
                              characteristics_ch1.1 %in% c("histology: malignant_melanoma",
                                                           "histology: Ewings_sarcoma-peripheral_primitive_neuroectodermal_tumour"))## ,
                                                           ## "histology: primitive_neuroectodermal_tumour-medulloblastoma"),)

pdata.keep.gse36133$cancer.type = NA

which.change <- as.character(pdata.keep.gse36133$characteristics_ch1.1) == "histology: Ewings_sarcoma-peripheral_primitive_neuroectodermal_tumour"
pdata.keep.gse36133$cancer.type[which.change] <- "Ewings"

## which.change <- pdata.keep.gse36133$characteristics_ch1.1 == "histology: primitive_neuroectodermal_tumour-medulloblastoma"
## pdata.keep.gse36133$cancer.type[which.change] <- "Medullo"

which.change <- pdata.keep.gse36133$characteristics_ch1.1 == "histology: malignant_melanoma"
pdata.keep.gse36133$cancer.type[which.change] <- "Melanoma"

## Squamous cell lung
pdata.keep.gse36133.lungscc <- subset(pData(eset.gse36133),
                                      characteristics_ch1 %in% c("primary site: lung") & characteristics_ch1.2 %in% c("histology subtype1: squamous_cell_carcinoma"),
)
pdata.keep.gse36133.lungscc$cancer.type <- "Lung SCC"
pdata.keep.gse36133 <- rbind(pdata.keep.gse36133, pdata.keep.gse36133.lungscc)

## lung adeno
pdata.keep.gse36133.lungadeno <- subset(pData(eset.gse36133),
                                        characteristics_ch1 %in% c("primary site: lung") & characteristics_ch1.2 %in% c("histology subtype1: adenocarcinoma"),
)
pdata.keep.gse36133.lungadeno$cancer.type <- "Lung Adeno"
pdata.keep.gse36133 <- rbind(pdata.keep.gse36133, pdata.keep.gse36133.lungadeno)


## SCLC's
pdata.keep.gse36133.sclc <- subset(pData(eset.gse36133),
                                     characteristics_ch1 %in% c("primary site: lung") & characteristics_ch1.2 %in% c("histology subtype1: small_cell_carcinoma"),
                                     )
pdata.keep.gse36133.sclc$cancer.type <- "SCLC"
pdata.keep.gse36133 <- rbind(pdata.keep.gse36133, pdata.keep.gse36133.sclc)

 
## breast cancers
pdata.keep.gse36133.breast <- subset(pData(eset.gse36133),
                                     characteristics_ch1 %in% c("primary site: breast") & characteristics_ch1.1 %in% c("histology: carcinoma"),
                                     )
pdata.keep.gse36133.breast$cancer.type <- "Breast"
pdata.keep.gse36133 <- rbind(pdata.keep.gse36133, pdata.keep.gse36133.breast)

## pancreatic cancers
pdata.keep.gse36133.pancreas <- subset(pData(eset.gse36133),
                                       characteristics_ch1 %in% c("primary site: pancreas") # & characteristics_ch1.2 %in% c("histology subtype1: ductal_carcinoma"),
                                       )
pdata.keep.gse36133.pancreas$cancer.type <- "Pancreas"
pdata.keep.gse36133 <- rbind(pdata.keep.gse36133, pdata.keep.gse36133.pancreas)

# Liver hepatocellular carcinoma
pdata.keep.gse36133.liver <- subset(pData(eset.gse36133),
                                     characteristics_ch1 %in% c("primary site: liver") & characteristics_ch1.2 %in% c("histology subtype1: hepatocellular_carcinoma"),
)
pdata.keep.gse36133.liver$cancer.type <- "Hepato"
pdata.keep.gse36133 <- rbind(pdata.keep.gse36133, pdata.keep.gse36133.liver)

pdata.keep.gse36133 <- transform(pdata.keep.gse36133,
                                 cel.file.name=gsub("ftp://ftp.ncbi.nih.gov/pub/geo/DATA/supplementary/samples/GSM.*/GSM.*/",
                                   "../data/CEL/use/",
                                   as.character(pdata.keep.gse36133$supplementary_file))
                                 )

pdata.keep.gse36133 <- transform(pdata.keep.gse36133, cel.file.name=gsub("\\.gz", "", cel.file.name))

## Need to get the raw files
# They will be stored here
pdata.keep.gse36133$cel.file.name <- gsub(".*/", "./data/CCLE/", pdata.keep.gse36133$supplementary_file)

for (fn in pdata.keep.gse36133$supplementary_file) {
  download.file(fn, destfile=paste0("./data/CCLE/", gsub(".*/", "", fn)))
}

## Combine the pdata of the CCLE and MCC data

pdata.combined <- data.frame(sample=c(rownames(pdata.keep.gse36133), as.character(clinical.data.hgu133plus2$sample)),
                             cel.file.name=c(pdata.keep.gse36133$cel.file.name, as.character(clinical.data.hgu133plus2$cel.file.name)),
                             batch=c(rep(1, nrow(pdata.keep.gse36133)), as.character(clinical.data.hgu133plus2$batch)),
                             cancer.type=c(pdata.keep.gse36133$cancer.type, as.character(clinical.data.hgu133plus2$cancertype)),
                             class=c(pdata.keep.gse36133$cancer.type, as.character(clinical.data.hgu133plus2$class)))

rownames(pdata.combined) <- pdata.combined$sample

print(table(pdata.combined$cancer.type))

# ProjectTemplate::cache("gse36133")
# ProjectTemplate::cache("eset.gse36133")
ProjectTemplate::cache("pdata.keep.gse36133")
ProjectTemplate::cache("pdata.combined")

