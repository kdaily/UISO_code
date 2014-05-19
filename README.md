Code for *"Assessment of Cancer Cell Line Representativeness using Microarrays for Merkel Cell Carcinoma"*.

This repository contains all of the code necessary to run data analysis and produce figures and tables for the publication.

License
------

The content of this project is licensed under the [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](http://creativecommons.org/licenses/by-nc-sa/4.0/) license.


Setup
-----

R 3.0 or better is required.

Consult or run/source `setup.R` for installation of all required packages.

It requires ProjectTemplate:

http://projecttemplate.net/index.html

and Bioconductor:

http://www.bioconductor.org/

as well as other dependencies listed in:

```
config/global.cfg
```

Running and processing data
-------

First, set your working directory to the root of the respository (where the README.md is). Then, to run everything, change the lines in the global config file for munging and loading data.

```
data_loading: on
munging: on
```

Then:

```{r}
source("run.R")
```

Then, to run the CCLE-specific processing:


```{r}
source("runCCLE.R")
```

**WARNING: The CCLE data processing requires a lot (>20GB) of main memory to hold the expression data. The batch processing step can take >15 hours.**

All steps can be run individually. Turn of munging (in `config/global.cfg`), and run (source) each of the files in the `munge` directory sequentially.

Creating figures and tables
-------------------------------
All of the figures in the main text and the supplementary materials can be reproduced from the R Markdown files in the `reports` directory (`AllFigures.Rmd` and `SuppMat.Rmd`, respectively).
**All of the previous steps must be run prior to these.**
