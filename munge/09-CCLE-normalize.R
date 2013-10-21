## Use RMA to normalize
eset.original.rma.u133plus2 <- rma(data.cel.combined.u133plus2)
pData(eset.original.rma.u133plus2) <- pData(data.cel.combined.u133plus2)
fData(eset.original.rma.u133plus2) <- fData(data.cel.combined.u133plus2)
protocolData(eset.original.rma.u133plus2) <- protocolData(data.cel.combined.u133plus2)

ProjectTemplate::cache("eset.original.rma.u133plus2")

