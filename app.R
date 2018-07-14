library(shiny)
library(visNetwork)

pkgs <- list.files("data")
igraphs <- lapply(file.path("data", pkgs), readRDS)

ui <- fluidPage(

  sidebarLayout(

    sidebarPanel(

      selectInput("pkgname", label = "Choose package:", choices = pkgs),
      br(),
      br(),

      checkboxInput("freeze", "Freeze non-selected nodes", TRUE),

      checkboxInput("external", "Include external functions", FALSE),

      conditionalPanel(condition = "input.freeze == false",
                       sliderInput("centralGravity",
                                   "centralGravity:",
                                   min = 0,
                                   max = 1,
                                   value = .3)
      ),

      h4("Notes: "),
      p("* When plot renders, hover, click, or choose a function from the dropdown box to see reverse function dependencies. Right click in browser to save image."),
      p("* Large packages may take a minute or more to load."),
      p("* Misses functions called in purrr::map statements and similar (to be fixed)"),
      p("* For more info on rendering function, see:"),
      a("http://rpubs.com/jtr13/vis_package", href = "http://rpubs.com/jtr13/vis_package", target = "_blank")

    ),

    mainPanel(

      titlePanel("Tidyverse Function Dependency Explorer"),

      p("Package location:"),

      verbatimTextOutput('directorypath'),

      visNetworkOutput("network")
    )
  )
)

server <- function(input, output) {

  ## render the network diagram
  output$network <- renderVisNetwork({
    i <- which(pkgs == input$pkgname)
    pkginspector::vis_package(igraph_obj = igraphs[[i]],
                              physics = !input$freeze,
                              external = input$external,
                              centralGravity = input$centralGravity,
                              icons = FALSE)
  })
}

# Run the application
shinyApp(ui = ui, server = server)

