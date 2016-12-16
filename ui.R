library(shiny)
library(shinythemes)

library(gwascat)
data(ebicat38)

gwas38 <- as.data.frame(ebicat38)
gwas38_traits <- as.data.frame(table(gwas38$DISEASE.TRAIT))
gwas38_traits <- gwas38_traits[order(gwas38_traits$Freq, decreasing = TRUE), ]

diseases <- c("choose below", as.character(gwas38_traits$Var1))

shinyUI(fluidPage(theme = shinytheme("united"),
                  titlePanel("GWAS disease-associated SNP locations in the human genome"),

                  sidebarLayout(
                    sidebarPanel(

                      selectInput("variable", "First disease:",
                                  choices = diseases[-1]),

                      selectInput("variable2", "Second disease:",
                                  choices = diseases),

                      selectInput("variable3", "Third disease:",
                                  choices = diseases),

                      selectInput("variable4", "Fourth disease:",
                                  choices = diseases),

                      selectInput("variable5", "Fifth disease:",
                                  choices = diseases),

                      selectInput("variable6", "Sixth disease:",
                                  choices = diseases),

                      selectInput("variable7", "Seventh disease:",
                                  choices = diseases),

                      selectInput("variable8", "Eighth disease:",
                                  choices = diseases),

                      selectInput("variable9", "Ninth disease:",
                                  choices = diseases)
                    ),
                    mainPanel(
                      div("Choose one or multiple diseases on the left-side panel und see their chromosomal locations below:", style = "color:blue"),
                      br(),
                      plotOutput("plot"),
                      p("GWAS catalog:", a("http://www.ebi.ac.uk/gwas/", href = "http://www.ebi.ac.uk/gwas/"))
                    )
                  )
))
