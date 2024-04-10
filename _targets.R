# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed.
library(crew.cluster)
library(fs)

# You'll need to replace this with your HPC group name.  You can discover the name by running `va` when logged into the HPC.
hpc_group <- "kristinariemer" #TODO maybe get this from .Renviron var instead

# Detect whether you're on HPC & not with an Open On Demand session (which cannot submit SLURM jobs) and set appropriate controller
slurm_host <- Sys.getenv("SLURM_SUBMIT_HOST")

if (grepl("hpc\\.arizona\\.edu", slurm_host) & !grepl("ood", slurm_host)) {
  controller <- crew.cluster::crew_controller_slurm(
    workers = 3,
    seconds_idle = 120, #time until workers are shut down after idle
    slurm_partition = "standard",
    slurm_time_minutes = 60, #wall time for each worker
    slurm_log_output = "logs/crew_log_%A.out",
    slurm_log_error = "logs/crew_log_%A.err",
    slurm_memory_gigabytes_per_cpu = 4,
    slurm_cpus_per_task = 1,
    script_lines = c(
      paste0("#SBATCH --account ", hpc_group),
      "module load R"
      #add additional lines to the SLURM job script as necessary here
    )
  )
} else {
  controller <- crew::crew_controller_local(workers = 3, seconds_idle = 60)
}

# Set target options:
tar_option_set(
  packages = c("tibble"), # Packages that your targets need for their tasks.
  controller = controller
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# tar_source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
tar_plan(
  tar_target(
    data_raw,
    tibble(x = rnorm(100), y = rnorm(100), z = rnorm(100))
  ),
  #this just simulates a long-running step
  tar_target(
    data,
    do_stuff(data_raw),
  ),
  tar_target(
    model1,
    lm(y ~ x, data = data)
  ),
  #these three models should be run in parallel as three separate SLURM jobs
  tar_target(
    model2,
    lm(y ~ x + z, data = data)
  ),
  tar_target(
    model3,
    lm(y ~ x*z, data = data)
  ),
  tar_target(
    model_compare,
    AIC(model1, model2, model3)
  )
)

