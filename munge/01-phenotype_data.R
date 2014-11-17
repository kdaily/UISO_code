# Clinical data is read in when loading the project from the data directory

clinical.data <- transform(clinical.data,
                           MCPyV.status=factor(MCPyV.status, levels=c("negative","positive"), 
                                               labels=c("Virus negative", "Virus positive"),
                                               ordered=TRUE),
                           classic=factor(classic, levels=c("UISOCellLine", "VariantCellLine",
                                                            "ClassicCellLine", "Tumor"), 
                                               ordered=TRUE),
                           batch=factor(batch),
                           platform="hgu133a2")

clinical.data$type <- with(clinical.data, paste(cancertype, sample.type, sep=""))
clinical.data$type <- factor(clinical.data$type,
                             levels=c("MCCcellline", "MCCtissue", "SCLCtissue"),
                             labels=c("MCC cell line", "MCC tissue", "SCLC tissue"))

rownames(clinical.data) <- clinical.data$sample

clinical.data.hgu133plus2 <- transform(clinical.data.hgu133plus2,
                                       MCPyV.status=factor(MCPyV.status, levels=c("negative","positive"), 
                                                           labels=c("Virus negative", "Virus positive"),
                                                           ordered=TRUE),
                                       platform="hgu133plus2")

rownames(clinical.data.hgu133plus2) <- clinical.data.hgu133plus2$sample

ProjectTemplate::cache("clinical.data")
ProjectTemplate::cache("clinical.data.hgu133plus2")
