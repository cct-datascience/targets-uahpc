# targets-uahpc

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10963005.svg)](https://doi.org/10.5281/zenodo.10963005)

<!-- badges: end -->

This is a minimal example of a [`targets`](https://docs.ropensci.org/targets/) workflow that can be run on the [University of Arizona cluster computer](https://uarizona.atlassian.net/wiki/spaces/UAHPC/overview).
`targets` is an R package for workflow management that can save you time by automatically skipping code that doesn’t need to be re-run when you make changes to your data or code.
It also makes parallelization relatively easy by allowing you to define each target as a separate SLURM job with the [`crew.cluster`](https://wlandau.github.io/crew.cluster/) package.

## Prerequisites:

-   [A UA HPC account](https://uarizona.atlassian.net/wiki/spaces/UAHPC/pages/75990889/Account+Creation)
-   Some familiarity with R, RStudio, and the `targets` package
-   A GitHub account

## To Use:

1.  Click the “Use this template” button to create a repo under your own GitHub user name.
2.  Modify the HPC group name in `_targets.R` to be your PI group.
3.  [SSH into the UA HPC](https://uarizona.atlassian.net/wiki/spaces/UAHPC/pages/75990560/System+Access).
4.  Clone this repo on the HPC, e.g. with `git clone https://github.com/your-user-name/targets-uahpc.git`.
5.  Start an interactive session on the HPC, e.g. with `interactive -a <groupname>` .
6.  Load R with `module load R`.
7.  Launch R from within the `targets-uahpc/` directory with the `R` command
8.  The [`renv` package](https://rstudio.github.io/renv/) should install itself. After it is done, you can install all necessary R packages by running `renv::restore()`.
9.  Run `tar_make()` to start the pipeline.

## Notes:

The `_targets/` store can grow to be quite large depending on the size of data and the number of targets created.
Your home folder on the HPC only allows 50GB of storage, so it may be wise to clone this to `/groups/<groupname>/` instead, which by default has 500GB of storage.
`targets` can optionally use cloud storage, which has the benefit of making completed targets easily accessible on a local machine.
See the [targets manual](https://books.ropensci.org/targets/cloud-storage.html) for more info on setting up cloud storage.

Because of restrictions that UAHPC has on running processes on login nodes, the `tls` option to `crew.cluster::crew_controller_slurm()` should not be used.
That is, you cannot run `tar_make()` locally (e.g. on your laptop) and have it start SLURM jobs on the HPC.
Code in `_targets.R` will attempt to detect if you are able to launch SLURM jobs and if not (e.g. you are not on the HPC or are using Open On Demand) it will fall back to using `crew::crew_controller_local()`.
