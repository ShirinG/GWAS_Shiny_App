library(shiny)

chr_data <- read.table("chromosome_length.txt", header = TRUE, sep = "\t")

chr_data$SEQNAME <- as.factor(chr_data$SEQNAME)
f = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "X", "Y", "MT")
chr_data <- within(chr_data, SEQNAME <- factor(SEQNAME, levels = f))

library(ggplot2)

gwas38 <- read.table("gwas38.txt", header = TRUE, sep = "\t")
gwas38_traits <- read.table("gwas38_traits.txt", header = TRUE, sep = "\t")

# Define server logic required to plot variables
shinyServer(function(input, output) {

  # Generate a plot of the requested variables
  output$plot <- renderPlot({

    plot_snps <- function(trait){

      if (any(trait == "choose below")){
        trait <- trait[-which(trait == "choose below")]
      } else {
        trait <- unique(trait)
      }

        for (i in 1:length(unique(trait))){

          trait_pre <- unique(trait)[i]
          snps_data_pre <- gwas38[which(gwas38$DISEASE.TRAIT == paste(trait_pre)), ]
          snps_data_pre <- data.frame(Chr = snps_data_pre$seqnames,
                                      Start = snps_data_pre$CHR_POS,
                                      SNPid = snps_data_pre$SNPS,
                                      Trait = rep(paste(trait_pre), nrow(snps_data_pre)),
                                      PVALUE_MLOG = snps_data_pre$PVALUE_MLOG,
                                      OR.or.BETA = snps_data_pre$OR.or.BETA)

          snps_data_pre <- subset(snps_data_pre, PVALUE_MLOG > input$pvalmlog)
          snps_data_pre <- subset(snps_data_pre, OR.or.BETA > input$orbeta | is.na(OR.or.BETA))

          if (i == 1){

            snps_data <- snps_data_pre

          } else {

            snps_data <- rbind(snps_data, snps_data_pre)

          }
        }

      snps_data <- within(snps_data, Chr <- factor(Chr, levels = f))

      p <- ggplot(data = snps_data, aes(x = Chr, y = as.numeric(Start))) +
        geom_bar(data = chr_data, aes(x = SEQNAME, y = as.numeric(SEQLENGTH)), stat = "identity", fill = "grey90", color = "black") +
        theme(
          axis.text = element_text(size = 14),
          axis.title = element_text(size = 14),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_rect(fill = "white"),
          legend.position = "bottom"
        ) +
        labs(x = "Chromosome", y = "Position")

      p + geom_segment(data = snps_data, aes(x = as.numeric(as.character(Chr)) - 0.45, xend = as.numeric(as.character(Chr)) + 0.45,
                                           y = Start, yend = Start, colour = Trait), size = 2, alpha = 0.5) +
        scale_colour_brewer(palette = "Set1") +
        guides(colour = guide_legend(ncol = 3, byrow = FALSE))

      }

    plot_snps(trait = c(input$variable1, input$variable2, input$variable3, input$variable4, input$variable5, input$variable6, input$variable7, input$variable8, input$variable9))
  })

  output$table <- renderTable({
    table <- gwas38_traits[which(gwas38_traits$Trait %in% c(input$variable1, input$variable2, input$variable3, input$variable4, input$variable5, input$variable6, input$variable7, input$variable8)), ]

    })

  output$table2 <- renderTable({
    table <- gwas38[which(gwas38$DISEASE.TRAIT %in% c(input$variable1, input$variable2, input$variable3, input$variable4, input$variable5, input$variable6, input$variable7, input$variable8)), c(1:5, 8, 10, 11, 13, 14, 20, 27, 32, 33, 34, 36)]

    table <- subset(table, PVALUE_MLOG > input$pvalmlog)
    table <- subset(table, OR.or.BETA > input$orbeta | is.na(OR.or.BETA))

    table[order(table$seqnames), ]
    })

})
