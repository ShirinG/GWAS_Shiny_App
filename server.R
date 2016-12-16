library(shiny)
library(AnnotationDbi)
library(org.Hs.eg.db)

library(EnsDb.Hsapiens.v79)
edb <- EnsDb.Hsapiens.v79

keys <- keys(edb, keytype="SEQNAME")
chromosome_length <- select(edb, keys=keys, columns=c("SEQLENGTH", "SEQNAME"), keytype="SEQNAME")
chromosome_length <- chromosome_length[grep("^[0-9]+$|^X$|^Y$|^MT$", chromosome_length$SEQNAME), ]

chr_data <- chromosome_length
chr_data$SEQNAME <- as.factor(chr_data$SEQNAME)
f=c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "X", "Y", "MT")
chr_data <- within(chr_data, SEQNAME <- factor(SEQNAME, levels=f))

library(ggplot2)

library(gwascat)
data(ebicat38)

gwas38 <- as.data.frame(ebicat38)
gwas38_traits <- as.data.frame(table(gwas38$DISEASE.TRAIT))

# Define server logic required to plot variables
shinyServer(function(input, output) {

  # Create a reactive text
  text <- reactive({
    if (input$variable == input$variable2){
      paste("Chromosomal location of SNPs for", input$variable)
    } else {
      paste("Chromosomal location of SNPs for", input$variable, "&", input$variable2)
    }
  })

  # Return as text the selected variables
  output$caption <- renderText({
    text()
  })

  # Generate a plot of the requested variables
  output$plot <- renderPlot({
    p <- ggplot(data = chr_data, aes(x = SEQNAME, y = as.numeric(SEQLENGTH))) + geom_bar(stat = "identity", fill = "grey90", color = "black") +
      theme(
        axis.text = element_text(size = 14),
        axis.title = element_text(size = 14),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "white"),
        legend.position="bottom"
      ) +
      labs(x="Chromosome", y="Position")

    plot_snps <- function(trait){

      if (length(unique(trait)) == 1){
        trait <- unique(trait)
        snps_data <- as.data.frame(locs4trait(ebicat38, trait = paste(trait), tag="DISEASE/TRAIT"))
        snps_data <- data.frame(Chr = snps_data$seqnames,
                                Start = snps_data$CHR_POS,
                                SNPid = snps_data$SNPS,
                                Trait = rep(paste(trait), nrow(snps_data)),
                                PVALUE_MLOG = snps_data$PVALUE_MLOG,
                                OR.or.BETA = snps_data$OR.or.BETA)

      } else {

        for(i in 1:length(trait)){

          trait_pre <- trait[i]
          snps_data_pre <- as.data.frame(locs4trait(ebicat38, trait = paste(trait_pre), tag="DISEASE/TRAIT"))
          snps_data_pre <- data.frame(Chr = snps_data_pre$seqnames,
                                      Start = snps_data_pre$CHR_POS,
                                      SNPid = snps_data_pre$SNPS,
                                      Trait = rep(paste(trait_pre), nrow(snps_data_pre)),
                                      PVALUE_MLOG = snps_data_pre$PVALUE_MLOG,
                                      OR.or.BETA = snps_data_pre$OR.or.BETA)

          if (i == 1){

            snps_data <- snps_data_pre

          } else {

            snps_data <- rbind(snps_data, snps_data_pre)

          }
        }
      }

      p + geom_segment(data=snps_data, aes(x=as.numeric(as.character(Chr))-0.45, xend=as.numeric(as.character(Chr))+0.45,
                                           y=Start, yend=Start, colour=Trait), size=2, alpha = 0.5) +
        scale_colour_brewer(palette="Set1")

    }

    print(plot_snps(trait = c(input$variable, input$variable2, input$variable3)))
  })
})
