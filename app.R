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
      p("* IT'S ALL ABOUT THE SUBGRAPHS: Zoom/pan and then hover or click a node--or choose a function from the dropdown box--to see reverse function dependencies for that function only."),
        p("* TO SAVE IMAGE: Right click while hovering on selected node."),
      p("* CAVEAT: Misses functions called in purrr::map statements and similar (to be fixed)"),
      span("* For more info on rendering function, see:"),
      a("http://rpubs.com/jtr13/vis_package", href = "http://rpubs.com/jtr13/vis_package", target = "_blank"), br(), br(),
    span("* Source code:"),
    a("http://www.github.com/jtr13/packageexplorer", href = "http://www.github.com/jtr13/packageexplorer", target = "_blank"),
    p(" "),
    p("* To improve speed, tidyverse package info is stored. Last update: Jan. 15, 2019")

  ),

    mainPanel(

      titlePanel("Tidyverse Function Dependency Explorer"),

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

