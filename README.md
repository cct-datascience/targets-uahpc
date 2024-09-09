# targets-uahpc

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10963005.svg)](https://doi.org/10.5281/zenodo.10963005)

<!-- badges: end -->

This is a minimal example of a [`targets`](https://docs.ropensci.org/targets/) workflow that can be run on the [University of Arizona cluster computer](https://uarizona.atlassian.net/wiki/spaces/UAHPC/overview).
`targets` is an R package for workflow management that can save you time by automatically skipping code that doesn’t need to be re-run when you make changes to your data or code.
It also makes parallelization relatively easy by allowing you to define each target as a separate SLURM job with the [`crew.cluster`](https://wlandau.github.io/crew.cluster/) package.

## Prerequisites:

-   [A UA HPC account](https://uarizona.atlassian.net/wiki/spaces/UAHPC/pages/75990889/Account+Creation)
-   Some familiarity with R, RStudio, the [`renv` pacakge](https://rstudio.github.io/renv/articles/renv.html), and the [`targets` package](https://books.ropensci.org/targets/)
-   A GitHub account

## To set-up:

To get this bare-bones pipeline running on the HPC:

1.  Click the “Use this template” button to create a repo under your own GitHub user name.
2.  Modify the HPC group name in `_targets.R` and in `run.sh` to be your PI group.
3.  [SSH into the UA HPC](https://uarizona.atlassian.net/wiki/spaces/UAHPC/pages/75990560/System+Access).
4.  Clone this repo on the HPC, e.g. with `git clone https://github.com/your-user-name/targets-uahpc.git`.
5.  Start an interactive session on the HPC, e.g. with `interactive -a <groupname>` .
6.  Load R with `module load R`.
7.  Launch R from within the `targets-uahpc/` directory with the `R` command
8.  The [`renv` package](https://rstudio.github.io/renv/) should install itself. After it is done, you can install all necessary R packages by running `renv::restore()`.

To modify the pipeline to run *your* code, you'll need to edit the list of targets in `_targets.R` as well as functions in the `R/` folder.
See the [targets manual](https://books.ropensci.org/targets/) for more information.

Note that use of the `renv` package for tracking dependencies isn't strictly necessary, but it does simplify package installation on the HPC.
As you add R packages dependencies, you can use `targets::tar_renv()` to update the `_targets_packages.R` file and then `renv::snapshot()` to add them to `renv.lock`.
On the HPC, running `renv::restore()` not only installs any missing R packages, it also automatically detects system dependencies and lets you know if they aren't installed.

## Running the pipeline

There are several ways you can run the pipeline that each have pros and cons:

1.  Using RStudio running on Open OnDemand
2.  From R running on the command line
3.  By submitting `run.sh` as a SLURM job

### Open OnDemand

Log in to the [Open OnDemand app dashboard](https://ood.hpc.arizona.edu/pun/sys/dashboard/apps/index).
Choose an RStudio Server session and start a session specifying cores, memory per core, wall-time etc.
Keep in mind, that with this method `targets` won't launch workers as SLURM jobs, but as separate R processes using the cores you select, so be sure to request a large enough allocation to support the workers.
From RStudio use the File \> Open Project...
menu and navigate to the .Rproj file for this project.
Then, from the console, run `targets::tar_make()` optionally with the `as_job = TRUE` argument to run it as a background process.
You can occasionally check the progress of the pipeline in a variety of ways including `targets::tar_visnetwork()`.

### From R

SSH into the HPC, navigate to this project, and request an interactive session with `interactive -a <groupname> -t <HH:MM:SS>` where you replace the groupname with your group name, and the time stamp with how ever long you think the pipeline will take to run.
Load R with `module load R` and launch it with `R`.
Then you can run `targets::tar_make()` to kick off the pipeline and watch the progress in the R console.

### With `run.sh`

Edit the `run.sh` file to update your group name and the wall-time for the main process.
SSH into the HPC, navigate to this project, and run `sbatch run.sh`.
You can watch progress by occasionally running `squeue -u yourusername` to see the workers launch and you can peek at the `logs/` folder.
You can find the most recently modified log files with something like `ls -lt | head -n 5` and then you can read the logs with `cat targets_main_9814039.out` (or whatever file name you want to read).

## Notes:

The `_targets/` store can grow to be quite large depending on the size of data and the number of targets created.
Your home folder on the HPC only allows 50GB of storage, so it may be wise to clone this to `/groups/<groupname>/` instead, which by default has 500GB of storage.
`targets` can optionally use cloud storage, which has the benefit of making completed targets easily accessible on a local machine.
See the [targets manual](https://books.ropensci.org/targets/cloud-storage.html) for more info on setting up cloud storage.

Code in `_targets.R` will attempt to detect if you are able to launch SLURM jobs and if not (e.g. you are not on the HPC or are using Open On Demand) it will fall back to using `crew::crew_controller_local()`.
