
<!-- README.md is generated from README.Qmd. Please edit that file -->

# targets-uahpc

<!-- badges: start -->
<!-- badges: end -->

This is a minimal example of a
[`targets`](https://docs.ropensci.org/targets/) workflow that can be run
on your computer or on the University of Arizona cluster computer
through [Open on Demand](https://ood.hpc.arizona.edu/). `targets` is an
R package for workflow management that can save you time by
automatically skipping code that doesn’t need to be re-run when you make
changes to your data or code. It also makes parallelization relatively
easy.

## Prerequisites:

- A UAz HPC account
- Some familiarity with R, RStudio, and the `targets` package
- A GitHub account

## To Use:

1.  Click the green “Use this template” button to make a copy into your
    own GitHub account

2.  In your copy of the template, click the green “Code” button and copy
    the URL ending in .git

3.  Open RStudio, click File \> New Project…

4.  Select “Version Control” then “Git” and paste in the .git URL from
    step 2. Click “create project” to open the project.

5.  This project uses
    [`renv`](https://rstudio.github.io/renv/articles/renv.html) to
    manage R package dependencies. Run `renv::restore()` in the R
    console to install all needed packages.

6.  Run `targets` workflow:

    To run the workflow, you can use `tar_make()` or you can run targets
    in parallel using `tar_make_clustermq()` where you supply the number
    of parallel workers with the `workers` argument. To examine the
    workflow, you can use `tar_visnetwork()` to see a graph somewhat
    like this:

``` mermaid
graph LR
  subgraph legend
    direction LR
    x7420bd9270f8d27d([""Up to date""]):::uptodate --- x0a52b03877696646([""Outdated""]):::outdated
    x0a52b03877696646([""Outdated""]):::outdated --- xbf4603d6c2c2ad6b([""Stem""]):::none
  end
  subgraph Graph
    direction LR
    xb7119b48552d1da3(["data"]):::uptodate --> xe1eeca7af8e0b529(["model"]):::uptodate
    x6e52cb0f1668cc22(["readme"]):::outdated --> x6e52cb0f1668cc22(["readme"]):::outdated
  end
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef outdated stroke:#000000,color:#000000,fill:#78B7C5;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
  linkStyle 1 stroke-width:0px;
  linkStyle 3 stroke-width:0px;
```
