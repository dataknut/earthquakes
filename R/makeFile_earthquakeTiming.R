library(data.table)
library(drake)
library(readr)

baseURL <- "https://quakesearch.geonet.org.nz/csv?"
bbox <- "163.95996,-49.18170,182.63672,-32.28713"
startDate <- "2018-09-01"
endDate <- "2019-08-13"

dataURL <- paste0(baseURL, 
                  "bbox=", bbox, 
                  "&startdate=", startDate,
                  "&enddate=", endDate)

pPath <- path.expand(paste0(here::here(), "docs/plots/"))
docPath <- path.expand(paste0(here::here(), "docs/"))

getData <- function(url){
  df <- readr::read_csv(dataURL)
  dt <- data.table::as.data.table(df)
  return(dt)
}

# drake plan ----
rmdFile <- paste0(here::here(), "/R/earthquakeTiming.Rmd")
htmlFile <- paste0(here::here(), "/docs/earthquakeTiming.html")
plan <- drake::drake_plan(
  drakeData = getData(dataURL),
  report = rmarkdown::render(
    knitr_in(rmdFile),
    output_file = file_out(htmlFile),
    quiet = TRUE
  )
)


# test it ----
plan

config <- drake_config(plan)
vis_drake_graph(config)

# do it ----
make(plan)