# Read all the CEL files
data.cel <- ReadAffy(filenames=as.character(clinical.data$cel.file.name),
                     sampleNames=clinical.data$sample,
                     phenoData=clinical.data)

# Normalize the dates for testing batch effects
protocolData(data.cel)$ScanDate <- sub("T", " ", protocolData(data.cel)$ScanDate)
protocolData(data.cel)$ScanDate <- sub("Z", "", protocolData(data.cel)$ScanDate)
protocolData(data.cel)$date <- sub(" .*", "", protocolData(data.cel)$ScanDate)
protocolData(data.cel)$date <- factor(protocolData(data.cel)$date)

# Cache the data
ProjectTemplate::cache("data.cel")
