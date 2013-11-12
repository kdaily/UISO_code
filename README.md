Supplementary Code for *"The UISO Cell Line is Not Representative of Merkel Cell Carcinoma"*
========================================================

This repository contains all of the code necessary to analyze and produce figures for the publication.

R 2.15 or better is required.

Setup
-----

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

First, set your working directory to the root of the respository (where the README.md is). Then, to run everything, change the lines in the global config file for munging and loading data (**WARNING: some steps require a lot of memory**).

```
data_loading: on
munging: on
```

Then:

```{r}
library(ProjectTemplate)
load.project()
```

If you want to run things individually, then turn of munging, and run (source) each of the files in the munge directory sequentially.

Creating all figures and tables
-------------------------------

Look in the `reports` directory for the files `AllFigures.Rmd` and `SuppMat.Rmd`. These files will recreate the figures in the manuscript and supplementary material, respectively.
