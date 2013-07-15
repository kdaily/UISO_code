Supplementary Code for "The UISO Cell Line is Not Representative of Merkel Cell Carcinoma"
========================================================

This repository contains all of the code necessary to analyze and produce figures for the publication.

First, it requires ProjectTemplate:

http://projecttemplate.net/index.html

All other dependencies can be found in:

```
config/global.cfg
```

First, set your working directory to the root of the respository (where the README.md is). Then, to run everything, change the lines in the global config file for munging and loading data (WARNING: some things require a lot of memory).

```
data_loading: on
munging: on
```

Then:

```{r}
library(ProjectTemplate)
load.project()
```

If you want to run things individually, then turn of munging, and run each of the files in the munge directory sequentially.
