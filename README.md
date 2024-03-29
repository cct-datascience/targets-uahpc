# targets-uahpc

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

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
4.  Start an interactive session on the HPC, e.g. with `elgato && interactive -a <groupname>` .
5.  Clone this repo on the HPC, e.g. with `git clone https://github.com/your-user-name/targets-uahpc.git`.
6.  On the HPC, load R with `module load R`.
7.  Launch R from within the `targets-uahpc/` directory with the `R` command
8.  The [`renv` package](https://rstudio.github.io/renv/) should install itself. After it is done, you can install all necessary R packages by running `renv::restore()`.
9.  Run `tar_make()` to start the pipeline.

## Notes:

The `targets` package stores intermediate objects in a `_targets/` folder in the project root by default.
You can [configure a different target store](https://books.ropensci.org/targets/data.html#local-data-store) with `tar_config_set()` or by creating a `_targets.yaml` file.
Your home folder on the HPC only allows 50GB of storage, so it may be wise to use a folder in `/groups/<groupname>/` instead.
The best way to do this is probably to create a symlink from your project to a folder created in `/groups/<groupname>/` and to specify this symlink as your targets store.
I haven’t had a chance to test this setup yet, so please let me know how it goes if you try it.
