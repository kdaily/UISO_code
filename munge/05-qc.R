# # This does not run by default as it is time consuming
# # Uncomment to run

# # Run quality control metrics on raw data
# tmp.data.cel <- data.cel
# pData(tmp.data.cel) <- pData(data.cel)[, c("sample", "type")]
# arrayQualityMetrics(expressionset=tmp.data.cel, outdir="./reports/QC/Raw/", force=T, intgroup="type")
# 
# QCReport(data.cel, file="./reports/QC/RawDataQC.pdf")
# 
# # Run quality control metrics on RMA processed data
# tmp.eset.original <- eset.original
# pData(tmp.eset.original) <- pData(tmp.eset.original)[, c("sample", "type")]
# arrayQualityMetrics(expressionset=tmp.eset.original, outdir="./reports/QC/RMA/", force=T, intgroup="type")
# 
# ProjectTemplate::cache("qc.raw")
# ProjectTemplate::cache("qc.rma")
