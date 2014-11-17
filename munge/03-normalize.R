## Normalize
eset.original <- rma(data.cel)

# Override the feature data with more informative gene names
# The data is in data/fdata.hgu133a2.Rdata
fData(eset.original) <- fdata.hgu133a2[featureNames(eset.original), ]

ProjectTemplate::cache("eset.original")

# Remove the bottom 40% of probesets by variance
original.nsfilter <- nsFilter(eset.original, remove.dupEntrez=FALSE, require.entrez=FALSE, var.cutoff=0.4)
eset.original.filter <- original.nsfilter$eset

ProjectTemplate::cache("eset.original.filter")
