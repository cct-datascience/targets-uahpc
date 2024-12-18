# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) 
library(crew)
library(crew.cluster)
library(autometric) #for logging

# You'll need to replace this with your HPC group name.  You can discover the name by running `va` when logged into the HPC.
hpc_group <- "kristinariemer" 

# Detect whether you're on HPC & not with an Open On Demand session (which cannot submit SLURM jobs) and set appropriate controller
slurm_host <- Sys.getenv("SLURM_SUBMIT_HOST")
hpc <- grepl("hpc\\.arizona\\.edu", slurm_host) & !grepl("ood", slurm_host)


# Set up potential controllers
controller_hpc_small <- crew.cluster::crew_controller_slurm(
  name = "hpc_small",
  workers = 2,
  seconds_idle = 300,  # time until workers are shut down after idle
  options_metrics = crew_options_metrics(
    path = "/dev/stdout",
    seconds_interval = 1
  ),
  options_cluster = crew.cluster::crew_options_slurm(
    script_lines = c(
      paste0("#SBATCH --account ", hpc_group),
      "module load R/4.4"
      #add additional lines to the SLURM job script as necessary here
    ),
    log_output = "logs/crew_small_log_%A.out",
    log_error = "logs/crew_small_log_%A.err",
    memory_gigabytes_per_cpu = 5,
    cpus_per_task = 2, #total 10gb RAM
    time_minutes = 1200, # wall time for each worker
    partition = "standard"
  )
)

controller_hpc_large <- crew.cluster::crew_controller_slurm(
  name = "hpc_large",
  workers = 2,
  seconds_idle = 2000,  # time until workers are shut down after idle
  options_metrics = crew_options_metrics(
    path = "/dev/stdout",
    seconds_interval = 1
  ),
  options_cluster = crew.cluster::crew_options_slurm(
    script_lines = c(
      paste0("#SBATCH --account ", hpc_group),
      "module load R/4.4"
      #add additional lines to the SLURM job script as necessary here
    ),
    log_output = "logs/crew_large_log_%A.out",
    log_error = "logs/crew_large_log_%A.err",
    memory_gigabytes_per_cpu = 5,
    cpus_per_task = 4, #total 10gb RAM
    time_minutes = 1200, # wall time for each worker
    partition = "standard"
  )
)

controller_local <- crew_controller_local(
  name = "local",
  workers = 2,
  options_local = crew::crew_options_local(log_directory = "logs"),
  options_metrics = crew::crew_options_metrics(
    path = "/dev/stdout",
    seconds_interval = 1
  )
)

# Set target options:
tar_option_set(
  packages = c("tibble"), # Packages that your targets need for their tasks.
  controller = crew::crew_controller_group(controller_hpc_small, controller_hpc_large, controller_local),
  resources = tar_resources(
    #if on HPC use "hpc_small" controller by default, otherwise use "local"
    crew = tar_resources_crew(controller = ifelse(hpc, "hpc_small", "local"))
  ),
  # It should be safe to assume that all workers have read/write access to the
  # _targets/ directory.  These setting should speed things up.
  storage = "worker",
  retrieval = "worker"
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
    lm(y ~ x*z, data = data),
    #for this target only, use a worker with more cores and RAM
    resources = tar_resources(
      crew = tar_resources_crew(controller = ifelse(hpc, "hpc_large", "local"))
    )
  ),
  tar_target(
    model_compare,
    AIC(model1, model2, model3)
  )
)

