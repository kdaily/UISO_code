# Process the CCLE data.
# WARNING: The CCLE data processing requires a lot ($>20$GB)
# of main memory to hold the expression data.
# The batch processing step can take $>15$ hours.

source("munge/CCLE/07-CCLE-getdata.R")
source("munge/CCLE/08-CCLE-readcel.R")
source("munge/CCLE/09-CCLE-normalize.R")
source("munge/CCLE/10-CCLE-qc.R")
source("munge/CCLE/11-CCLE-batcheffect.R")
source("munge/CCLE/12-randomForest.R")
