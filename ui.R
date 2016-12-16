library(shiny)

shinyUI(fluidPage(
  titlePanel("GWAS disease-associated SNP locations in the human genome"),

  sidebarLayout(
    sidebarPanel(

      selectInput("variable", "First disease:",
                  list("Addiction" = "Addiction",
                       "Acne (severe)"  = "Acne (severe)",
                       "Obesity-related traits" = "Obesity-related traits",
                       "Height" = "Height",
                       "IgG glycosylation" = "IgG glycosylation",
                       "Type 2 diabetes" = "Type 2 diabetes")),

      selectInput("variable2", "Second disease:",
                  list("Addiction" = "Addiction",
                       "Acne (severe)"  = "Acne (severe)",
                       "Obesity-related traits" = "Obesity-related traits",
                       "Height" = "Height",
                       "IgG glycosylation" = "IgG glycosylation",
                       "Type 2 diabetes" = "Type 2 diabetes")),

      selectInput("variable3", "Third disease:",
                  list("Addiction" = "Addiction",
                       "Acne (severe)"  = "Acne (severe)",
                       "Obesity-related traits" = "Obesity-related traits",
                       "Height" = "Height",
                       "IgG glycosylation" = "IgG glycosylation",
                       "Type 2 diabetes" = "Type 2 diabetes"))
    ),
    mainPanel(
      h3(textOutput("caption")),
      div("Choose one or multiple diseases on the left-side panel und see their chromosomal locations below:", style = "color:blue"),
      plotOutput("plot"),
      p("GWAS catalog:", a("http://www.ebi.ac.uk/gwas/", href = "http://www.ebi.ac.uk/gwas/"))
    )
  )
))
