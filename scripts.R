# script to create igraph data needed for visualizations

source("create_package_igraph.R")

# set package name here:
pkgname <- "stringr"

pkginfo <- download.packages(pkgname, tempdir())

untar(pkginfo[2], exdir = tempdir())

pkgigraph <- create_package_igraph(file.path(tempdir(),pkginfo[1]), external = TRUE)

saveRDS(pkgigraph, file.path("data", pkginfo[1]))

