library(shiny)
library(shinythemes)

gwas38_traits <- read.table("gwas38_traits.txt", header = TRUE, sep = "\t")

diseases <- c("choose below", as.character(gwas38_traits$Trait))

shinyUI(fluidPage(theme = shinytheme("united"),
                  titlePanel("GWAS disease- & trait-associated SNP locations of the human genome"),

                  sidebarLayout(
                    sidebarPanel(

                      sliderInput("pvalmlog",
                                  "-log(p-value):",
                                  min = -13,
                                  max = 332,
                                  value = -13),

                      sliderInput("orbeta",
                                  "odds ratio/ beta-coefficient :",
                                  min = 0,
                                  max = 4426,
                                  value = 0),

                      selectInput("variable1", "First trait:",
                                  choices = diseases[-1]),

                      selectInput("variable2", "Second trait:",
                                  choices = diseases),

                      selectInput("variable3", "Third trait:",
                                  choices = diseases),

                      selectInput("variable4", "Fourth trait:",
                                  choices = diseases),

                      selectInput("variable5", "Fifth trait:",
                                  choices = diseases),

                      selectInput("variable6", "Sixth trait:",
                                  choices = diseases),

                      selectInput("variable7", "Seventh trait:",
                                  choices = diseases),

                      selectInput("variable8", "Eighth trait:",
                                  choices = diseases)
                    ),
                    mainPanel(
                      br(),
                      p("The National Human Genome Research Institute (NHGRI) catalog of Genome-Wide Association Studies (GWAS) is a curated resource of single-nucleotide polymorphisms (SNP)-trait associations. The database contains more than 100,000 SNPs and all SNP-trait associations with a p-value <1 × 10^−5."),
                      p("This app is based on the 'gwascat' R package and its 'ebicat38' database and shows trait-associated SNP locations of the human genome."),
                      p("For more info on how I built this app check out", a("my blog.", href = "https://shiring.github.io/")),
                      br(),
                      h4("How to use this app:"),
                      div("Out of 1320 available traits or diseases you can choose up to 8 on the left-side panel und see their chromosomal locations below. The traits are sorted alphabetically. You can also start typing in the drop-down panel and traits matching your query will be suggested.", style = "color:blue"),
                      br(),
                      div("With the two sliders on the left-side panel you can select SNPs above a p-value threshold (-log of association p-value) and/or above an odds ratio/ beta-coefficient threshold. The higher the -log of the p-value the more significant the association of the SNP with the trait. Beware that some SNPs have no odds ratio value and will be shown regardless of the threshold.", style = "color:blue"),
                      br(),
                      div("The table directly below the plot shows the number of SNPs for each selected trait (without subsetting when p-value or odds ratio are changed). The second table below the first shows detailed information for each SNP of the chosen traits. This table shows only SNPs which are plotted (it subsets according to p-value and odds ratio thresholds).", style = "color:blue"),
                      br(),
                      div("Loading might take a few seconds...", style = "color:red"),
                      br(),
                      plotOutput("plot"),
                      tableOutput('table'),
                      tableOutput('table2'),
                      br(),
                      p("GWAS catalog:", a("http://www.ebi.ac.uk/gwas/", href = "http://www.ebi.ac.uk/gwas/")),
                      p(a("Welter, Danielle et al. “The NHGRI GWAS Catalog, a Curated Resource of SNP-Trait Associations.” Nucleic Acids Research 42.Database issue (2014): D1001–D1006. PMC. Web. 17 Dec. 2016.", href = "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3965119/"))
                    )
                  )
))
