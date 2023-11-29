library(targets)
source("R/functions.R")
library(crew)

tar_option_set(packages = c("readxl", "SDMWorkflows", "janitor", "data.table", "V.PhyloMaker"),
               controller = crew_controller_local(workers = 6),
               error = "null")
list(
  tar_target(file, "First_10_species.csv", format = "file"),
  tar_target(data, get_data(file)),
  tar_target(Only_Plants, filter_plants(data)),
  tar_target(Presences,
             get_plant_presences(Only_Plants),
             pattern = map(Only_Plants)),
  tar_target(Presence_summary, summarise_presences(Presences),
             pattern = map(Presences)),
  tar_target(Over_5, Filter_Over_5(Presence_summary))
)