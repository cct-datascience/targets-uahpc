

<!-- README.md is generated from README.Qmd. Please edit that file -->

# targets-uahpc

⚠️ Work in progress ⚠️

<!-- badges: start -->
<!-- badges: end -->

This is a minimal example of a
[`targets`](https://docs.ropensci.org/targets/) workflow that can be run
on the University of Arizona cluster computer. `targets` is an R package
for workflow management that can save you time by automatically skipping
code that doesn’t need to be re-run when you make changes to your data
or code. It also makes parallelization relatively easy by allowing you
to define each target as a separate SLURM job with the `crew.cluster`
package.

## Prerequisites:

- A UA HPC account
- Some familiarity with R, RStudio, and the `targets` package
- A GitHub account

## To Use:

1.  SSH into the UA HPC
2.  Start an interactive session, e.g. with
    `elgato && interactive -a <groupname>`
3.  Clone this repo
    `git clone https://github.com/cct-datascience/targets-uahpc.git`
4.  Load R with `module load R`
5.  Launch R from within the `targets-uahpc/` directory with `R`
6.  `renv` should install itself. After it is done, you can install all
    necessary R packages with `renv::restore()`
7.  Modify the HPC group name in `_targets.R` to be your PI group.
8.  Run `tar_make()` to start the pipeline
