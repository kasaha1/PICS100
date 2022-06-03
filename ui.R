#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(heatmaply)
library(shinycssloaders)
library(HGNChelper)
library(shinythemes)

library(BiocManager)
options(repos = BiocManager::repositories())

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    theme = shinytheme("journal"),
    # Application title
    # tags$img(src="PICSicon.jpg",width = 100,height = 50),
    titlePanel("PICS100 classfication for Hepatocellular carcinoma"),
    # titlePanel( div(column(width = 3, tags$img(src = "PICSicon.jpg",width = 80,height = 40)),column(width = 8, h3("PICS100 prediction by Ju-Seog's Lab"))),windowTitle="PICS100" ),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            tags$img(
                src = "PICS100icon.png",
                width = 200,
                height = 70
            ),
            br(),
            br(),
            fileInput(
                'geneExprfile',
                h4('Choose or Drag&drop the mRNA expression file(txt/csv)'),
                accept = c('text/csv',
                           'text/comma-separated-values,text/plain',
                           '.csv')
            ),
            radioButtons(
                'standardizationType',
                'Standardization',
                c(
                    'Non-standardization (For single-sample use)' = 'NoneS',
                    # 'Mendian-centering only' = 'medianCenter',
                    'Median-centering and dividing by SD' = 'devidedBySD'
                ),
                'devidedBySD'
            ),
            actionButton("doPrediction", "Prediction", class = "btn-primary"),
            br(),
            br(),
            downloadButton('downloadResults', 'Download result table')
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                type = "tabs",
                tabPanel(
                    "Your dataset summary",
                    h3(textOutput("preparation")),
                    tableOutput("tablesConvertedGeneSymbols"),
                    tableOutput("MissingValuesSymbols"),
                    plotlyOutput("resultPiePlot") %>% withSpinner(color =
                                                                      "#0dc5c1"),
                    plotlyOutput("resultSummaryPlot")
                ),
                
                tabPanel(
                    "Your results",
                    h4("PICS100 classification"),
                    img(
                        src = "Fig1.png",
                        width = 350,
                        height = 200
                    ),
                    br(),
                    br(),
                    h3(textOutput("preparation2")),
                    plotlyOutput("resultHeatmapPlot") %>% withSpinner(color =
                                                                          "#0dc5c1"),
                    tableOutput("tablesTemp"),
                ),
                tabPanel(
                    "How to use",
                    HTML(
                        "&nbsp; <p>Hi. This is the prediction tool for the analysis of HCC subtype using mRNA expression data.</p><p>Just upload your dataset. And press the prediction button. That's all. You can download example dataset from"
                    ),
                    tags$a(href = "https://raw.githubusercontent.com/kasaha1/PICS100/main/www/testDataset/Example_ZS159.txt", " here"),
                    HTML("or the below button."),
                    br(),
                    downloadButton('downloadExample', 'Download Example dataset'),
                    br(),
                    HTML("</p><p>&nbsp;</p><p><b>Step 1. Prepare of dataset.</b></p>"),
                    img(
                        src = "testDatasetExample.png",
                        width = 500,
                        height = 150
                    ),
                    HTML(
                        "<p> &nbsp;</p><p> The first line contains the labels Name(<em>HUGO Gene Nomenclature</em>) followed by the identifiers for each sample in the dataset.The dataset is the gene-level transcription estimates, as in log2(x+1) transformed normalized count.&nbsp; </br>* The alias symbols are automatically converted to HGNC approved symbols by the HGNChelper package.&nbsp;</p><p>&nbsp;</p><p><b>Step 2. Standardization. </b> &nbsp;</p><p> Select the data standardization method. &nbsp;</p><p><b>Step 3. Prediction.</b> &nbsp;</p><p> Press the prediction button. &nbsp;</p><p><b>Step 4. Check out the results.</b> &nbsp;</p><p>After analysis, You can find the results at the result tab. The results of dataset could be downloaded using the download button.</p>"
                    )
                    
                ),
                tabPanel(
                    "About PICS100",
                    HTML(
                        "<p>While many studies revealed genomic subtypes of hepatocellular carcinoma (HCC), they are not translated to the clinic yet due to lack of consensus. We aim to examine consensus of genomic subtypes and uncover their clinical significance. We integrated 15 previously established genomic signatures for HCC to uncover consensus genomic subtypes.<b> We also developed and validated a robust predictor of consensus subtype with 100 genes (PICS100).<b><p> "
                    ),
                    img(
                        src = "Fig2.png",
                        width = 500,
                        height = 600
                    ),
                    h5(textOutput("counter"))
                )
            )
        )
    )
))
