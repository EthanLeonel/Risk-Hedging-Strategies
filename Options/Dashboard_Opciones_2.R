#
# TAREA EXAMEN 4 - VALUACIÓN DE OPCIONES
#
# 
#
#    
#

library(shiny)
library(shinydashboard)
library(derivmkts)
library(data.table)
library(DT)

header <- {
  dashboardHeader(title = "Tarea Examen 4 - Valuación de Opciones",titleWidth = 500)
}

sidebar <- {
  dashboardSidebar(disable = TRUE)
} 

body <- dashboardBody({
  
  fluidRow(
    tabBox( width = 12,
            id = "tabset1"
            ,tabPanel( "Tablero 1"
                       ,column(width = 4
                               ,selectizeInput("Op"
                                               ,"Tipo de opción"
                                               ,choices =c('Call','Put')
                                               ,selected = c("Call"), 
                                               multiple = FALSE)
                               ,sliderInput(inputId = 'r',label = 'Tasa libre de riesgo',value = .06,min = .01,max = .2,step = .01)
                               ,sliderInput(inputId = 'nstep',label = 'Número de divisiones',value = 10,min = 3,max = 15,step = 1)
                       )
                       
                       ,column( width = 4
                                ,sliderInput(inputId = 's',label = 'Precio Spot',value = 20,min = 1,max = 100,step = 1)
                                ,sliderInput(inputId = 'sigma',label = 'Volatilidad anual',value = .2,min = .01,max = 2,step = .01)
                       )
                       
                       ,column(width = 4
                               ,sliderInput(inputId = 'k',label = 'Strike',value = 30,min = 1,max = 100,step = 1)
                               ,sliderInput(inputId = 'tt',label = 'Tiempo en años',value = 2, min = .5,max = 5,step = .5)
                               ,submitButton("Actualizar Filtros",icon("sync"),width = '150px')
                       )
                       
                       ,fluidRow(
                         box(
                           width = 12,
                           title = "Filtros Activos:",
                           textOutput("filtros_activos")
                         )
                       )
                       
                       ,fluidRow(
                         box(width = 12
                             ,HTML("<b>","Precio de la Prima","</b>")
                             ,verbatimTextOutput('t1')
                             ,plotOutput('g1')
                         )
                       )
            )
            
            ,tabPanel("Tablero 2"
                      ,tabsetPanel(
                        tabPanel("Sin Pago de Dividendos"
                                 ,column(width = 4
                                         ,selectizeInput(inputId = 'Op1',label='Tipo de opción',choices = c('Call','Put'),selected = c("Call"),multiple = FALSE)
                                         ,sliderInput(inputId = 'sigma1',label = 'Volatilidad anual',value = .2,min = .01,max = 2,step = .01)
                                         , sliderInput(inputId = 'precio1',label = 'Precio Opción',value = 10,min = 0,max = 100)
                                 )
                                 
                                 ,column(width = 4
                                         ,sliderInput(inputId = 's1',label = 'Spot',value = 20,min = 1,max = 100)
                                         ,sliderInput(inputId = 'r1',label = 'Tasa libre de riesgo',value = .06,min = .01,max = .2,step = .01)
                                 )
                                 
                                 ,column(width = 4
                                         ,sliderInput(inputId = 'k1',label = 'Strike',value = 30,min = 1,max = 100)
                                         ,sliderInput(inputId = 'tt1',label = 'Tiempo en años',value = .5, min = .5,max = 5,step = .5)
                                         ,submitButton("Actualizar Filtros",icon("sync"),width = '150px')
                                 )
                                 
                                 ,fluidRow(
                                   box(
                                     width = 12,
                                     title = "Filtros Activos:",
                                     textOutput("filtros_activos1")
                                   )
                                 )
                                 
                                 ,fluidRow(
                                   box( width = 12
                                        #Salida sin dividendos
                                        ,column(width = 4,DT::dataTableOutput('t11'))
                                   )
                                 )
                                 
                                 
                        )
                        ,tabPanel("Con pago de dividendos"
                                  ,column(width = 4
                                          ,selectInput(inputId = 'Op2',label='Tipo de opción',choices = c('Call','Put'))
                                          ,sliderInput(inputId = 'sigma2',label = 'Volatilidad anual',value = .2, min = .01,max = 2,step = .01)
                                          ,sliderInput(inputId = 'd2',label = 'Tasa de dividendos',value = .05,min = .01,max = .2,step = .01)
                                  )
                                  
                                  ,column(width = 4
                                          ,sliderInput(inputId = 's2',label = 'Spot',value = 20,min = 1,max = 100)
                                          ,sliderInput(inputId = 'r2',label = 'Tasa libre de riesgo',value = .06,min = .01,max = .2,step = .01)
                                          ,sliderInput(inputId = 'precio2',label = 'Precio Opción',value = 10,min = 0,max = 100)
                                  )
                                  
                                  ,column(width = 4
                                          ,sliderInput(inputId = 'k2',label = 'Strike',value = 30,min = 1,max = 100)
                                          ,sliderInput(inputId = 'tt2',label = 'Tiempo en años',value = .5,min = .5,max = 5,step = .5)
                                          ,submitButton("Actualizar Filtros",icon("sync"),width = '150px')
                                  )
                                  
                                  ,fluidRow(
                                    box(
                                      width = 12,
                                      title = "Filtros Activos:",
                                      textOutput("filtros_activos2")
                                    )
                                  )
                                  
                                  ,fluidRow(
                                    box(width = 12
                                        #Salida con dividendos
                                        ,column(width = 4,DT::dataTableOutput('t2'))
                                    )
                                  )
                                  
                        )
                        
                        ,tabPanel('Divisas'
                                  ,column(width = 4
                                          ,selectizeInput(inputId = 'Op3',label='Tipo de opción',choices = c('Call','Put')) 
                                          ,sliderInput(inputId = 'sigma3',label = 'Volatilidad anual',value = .2,min = .01,max = 2,step = .01)
                                          ,sliderInput(inputId = 'rf3',label = 'Tasa foranea',value = .02,
                                                       min = .01,max = .2,step = .01)
                                  )
                                  
                                  ,column(width = 4
                                          ,sliderInput(inputId = 's3',label = 'Spot',value = 20,min = 1,max = 100,step = 1)
                                          ,sliderInput(inputId = 'rl3',label = 'Tasa local',value = .07,
                                                       min = .01,max = .2,step = .01)
                                          ,sliderInput(inputId = 'precio3',label = 'Precio Opción',value = 10,min = 0,max = 100)
                                          
                                  )
                                  
                                  ,column(width = 4
                                          ,sliderInput(inputId = 'k3',label = 'Strike',value = 30,min = 1,max = 100,step = 1)
                                          , sliderInput(inputId = 'tt3',label = 'Tiempo en años',value = .5,
                                                        min = .5,max = 5,step = .5)
                                          ,submitButton("Actualizar Filtros",icon("sync"),width = '150px')
                                          
                                  )
                                  
                                  ,fluidRow(
                                    box(
                                      width = 12,
                                      title = "Filtros Activos:",
                                      textOutput("filtros_activos3")
                                    )
                                  )
                                  
                                  ,fluidRow(
                                    box(width = 12
                                        #Salida para divisas
                                        ,column(width = 4,DT::dataTableOutput('t3'))
                                    )
                                  )
                                  
                        )
                        
                        ,tabPanel('Futuros'
                                  ,column(width = 4
                                          ,selectInput(inputId = 'Op4',label='Tipo de opción',choices = c('Call','Put'))
                                          ,sliderInput(inputId = 'sigma4',label = 'Volatilidad anual',value = .2,min = .01,max = 2,step = .01)
                                          , sliderInput(inputId = 'precio4',label = 'Precio Opción',value = 10,min = 0,max = 100)
                                  )
                                  
                                  ,column(width = 4
                                          ,sliderInput(inputId = 'F04',label = 'Spot',value = 20,min = 1,max = 100)
                                          ,sliderInput(inputId = 'r4',label = 'Tasa local',value = .07, min = .01,max = .2,step = .01)
                                  )
                                  
                                  ,column(width = 4
                                          ,sliderInput(inputId = 'k4',label = 'Strike',value = 30,min = 1,max = 100)
                                          ,sliderInput(inputId = 'tt4',label = 'Tiempo en años',value = .5,min = .5,max = 5,step = .5)
                                          ,submitButton("Actualizar Filtros",icon("sync"),width = '150px')
                                  )
                                  
                                  ,fluidRow(
                                    box(
                                      width = 12,
                                      title = "Filtros Activos:",
                                      textOutput("filtros_activos4")
                                    )
                                  )
                                  
                                  ,fluidRow(
                                    box(width = 12
                                        #Salida para divisas
                                        ,column(width = 4,DT::dataTableOutput('t4'))
                                    )
                                  )
                                  
                                  
                                  
                                  
                        )
                        
                      )
                      
                      
                      
                      
            )
            
    )
    
    
    
  )
  
  
  
})



ui <- dashboardPage(header, 
                    sidebar, 
                    body,
                    skin="blue"
)

server <- function(input,output){
  
  # Filtros Activos
  output$filtros_activos <- renderText({ 
    # browser()
    HTML(
      "Opción:",input$Op,"||", "Spot:", input$s, "||", "Strike:", input$k, "||", "Volatilidad:", input$sigma, "||"
      , "Tasa:", input$r, "||", "Tiempo:", input$tt,"||", "Divisiones:", input$nstep
    )
  })
  
  # Filtros Activos1
  output$filtros_activos1 <- renderText({ 
    # browser()
    HTML(
      "Opción:",input$Op1,"||", "Spot:", input$s1, "||", "Strike:", input$k1, "||", "Volatilidad:", input$sigma1, "||"
      , "Tasa:", input$r1, "||", "Tiempo:", input$tt1,"||","Precio Opción:", input$precio1
      
    )
  })
  
  # Filtros Activos2
  output$filtros_activos2 <- renderText({ 
    # browser()
    HTML(
      "Opción:",input$Op2,"||", "Spot:", input$s2, "||", "Strike:", input$k2, "||", "Volatilidad:", input$sigma2, "||"
      , "Tasa:", input$r2, "||", "Tiempo:", input$tt2,"||", "Dividendos:", input$d2, "||","Precio Opción:", input$precio2
    )
  })
  
  # Filtros Activos3
  output$filtros_activos3 <- renderText({ 
    # browser()
    HTML(
      "Opción:",input$Op3,"||", "Spot:", input$s3, "||", "Strike:", input$k3, "||", "Volatilidad:", input$sigma2, "||"
      , "Tasa local", input$rl3, "||", "Tiempo:", input$tt3,"||", "Tasa Foránea:", input$rf3, "||","Precio Opción:", input$precio3
    )
  })
  
  # Filtros Activos4
  output$filtros_activos4 <- renderText({ 
    # browser()
    HTML(
      "Opción:",input$Op4,"||", "Spot:", input$F04, "||", "Strike:", input$k4, "||", "Volatilidad:", input$sigma4, "||"
      , "Tasa", input$r4, "||", "Tiempo:", input$tt4, "||","Precio Opción:", input$precio4
    )
  })
  
  #Precio de la prima
  output$t1 <- renderText({
    
    if(input$Op=='Call'){
      binomopt(input$s,input$k,input$sigma,input$r,input$tt, 0,input$nstep,crr = T,putopt = F, american = F)
      
    } else{
      binomopt(input$s,input$k,input$sigma,input$r,input$tt, 0,input$nstep,crr = T,putopt = T, american = F)
    }
  })
  
  #Gráfica
  output$g1 <- renderPlot({
    
    #binomplot(input$s,input$k,input$sigma,input$r,input$tt,0, input$nstep,crr = T, putopt = F, plotvalues= T)
    
    if(input$Op=='Call'){
      binomplot(input$s,input$k,input$sigma,input$r,input$tt,0, input$nstep,crr = T, putopt = F, american = F)
    } else{
      binomplot(input$s,input$k,input$sigma,input$r,input$tt,0, input$nstep,crr = T, putopt = T, american = F)
    }
    
    
  })
  
  #Tabla sin pago de dividendos
  output$t11 <- DT::renderDataTable({
    
    if(input$Op1=='Call'){
      
      a <- bsopt(input$s1,input$k1,input$sigma1,input$r1,input$tt1,0)
      b <- bscallimpvol(input$s1,input$k1,input$r1,input$tt1,0,input$precio1)
      nombres_call <- c("Precio prima call","Delta", "Gamma", "Vega", "Rho", "Theta", "Volatilidad Implícita")
      valores_call <- c(a[[1]][1],a[[1]][2],a[[1]][3],a[[1]][4],a[[1]][5],a[[1]][6],b )
      
      A1 <- data.table("Nombre"=nombres_call,"Valor" = valores_call)
      DT::datatable(A1,extensions = 'Buttons',
                    rownames = FALSE,
                    options = list(buttons = c('excel'),
                                   fixedColumns = TRUE,
                                   autoWidth = FALSE,
                                   dom = 'tB',paging = FALSE, searching = FALSE, scrollX = TRUE, 
                                   initComplete = JS(
                                     "function(settings, json) {",
                                     "$(this.api().table().header()).css({'background-color': '#1F618D ', 'color': '#fff', 'font-family': 'Century Gothic'});",
                                     "}")))
      
    }else{
      a <- bsopt(input$s1,input$k1,input$sigma1,input$r1,input$tt1,0)
      b <- bsputimpvol(input$s1,input$k1,input$r1,input$tt1,0,input$precio1)
      
      nombres_put <- c('Precio prima put:','Delta:','Gamma', 'Vega', 'Rho', 'Theta', 'Volatilidad Implícita')
      valores_put <- c(a[[2]][1],a[[2]][2],a[[2]][3],a[[2]][4],a[[2]][5],a[[2]][6],b)
      
      DT::datatable(data.table("Nombre" = nombres_put, "Valor" = valores_put),extensions = 'Buttons',
                    rownames = FALSE,
                    options = list(buttons = c('excel'),
                                   fixedColumns = TRUE,
                                   autoWidth = FALSE,
                                   dom = 'tB',paging = FALSE, searching = FALSE, scrollX = TRUE, 
                                   initComplete = JS(
                                     "function(settings, json) {",
                                     "$(this.api().table().header()).css({'background-color': '#1F618D ', 'color': '#fff', 'font-family': 'Century Gothic'});",
                                     "}")))
      
      
    }
    
  })
  
  # Tabla con pago de dividendos
  output$t2 <- DT::renderDataTable({
    if(input$Op2=='Call'){
      a <- bsopt(input$s2,input$k2,input$sigma2,input$r2,input$tt2,input$d2)
      b <- bscallimpvol(input$s2,input$k2,input$r2,input$tt2,input$d2,input$precio2)
      
      nombres_call2 <- c("Precio prima call","Delta", "Gamma", "Vega", "Rho", "Theta", "Volatilidad Implícita")
      valores_call2 <- c(a[[1]][1],a[[1]][2],a[[1]][3],a[[1]][4],a[[1]][5],a[[1]][6],b )
      
      DT::datatable(data.table("Nombre" = nombres_call2, "Valor" = valores_call2),extensions = 'Buttons',
                    rownames = FALSE,
                    options = list(buttons = c('excel'),
                                   fixedColumns = TRUE,
                                   autoWidth = FALSE,
                                   dom = 'tB',paging = FALSE, searching = FALSE, scrollX = TRUE, 
                                   initComplete = JS(
                                     "function(settings, json) {",
                                     "$(this.api().table().header()).css({'background-color': '#1F618D ', 'color': '#fff', 'font-family': 'Century Gothic'});",
                                     "}")))
      
    }else{
      a <- bsopt(input$s2,input$k2,input$sigma2,input$r2,input$tt2,input$d2)
      b <- bsputimpvol(input$s2,input$k2,input$r2,input$tt2,input$d2,input$precio2)
      
      nombres_put2 <- c("Precio prima call","Delta", "Gamma", "Vega", "Rho", "Theta", "Volatilidad Implícita")
      valores_put2 <- c(a[[2]][1],a[[2]][2],a[[2]][3],a[[2]][4],a[[2]][5],a[[2]][6],b)
      
      DT::datatable(data.table("Nombre" = nombres_put2, "Valor" = valores_put2),extensions = 'Buttons',
                    rownames = FALSE,
                    options = list(buttons = c('excel'),
                                   fixedColumns = TRUE,
                                   autoWidth = FALSE,
                                   dom = 'tB',paging = FALSE, searching = FALSE, scrollX = TRUE, 
                                   initComplete = JS(
                                     "function(settings, json) {",
                                     "$(this.api().table().header()).css({'background-color': '#1F618D ', 'color': '#fff', 'font-family': 'Century Gothic'});",
                                     "}")))
      
      
    }
  })
  
  #Tabla para divisas
  output$t3 <- DT::renderDataTable({
    if(input$Op3=='Call'){
      a <- bsopt(input$s3,input$k3,input$sigma3,input$rl3,input$tt3,input$rf3)
      b <- bscallimpvol(input$s3,input$k3,input$rl3,input$tt3,input$rf3,input$precio3)
      
      nombres_call3 <- c("Precio prima call","Delta", "Gamma", "Vega", "Rho", "Theta", "Volatilidad Implícita")
      valores_call3 <- c(a[[1]][1],a[[1]][2],a[[1]][3],a[[1]][4],a[[1]][5],a[[1]][6],b )
      
      DT::datatable(data.table("Nombre" = nombres_call3, "Valor" = valores_call3),extensions = 'Buttons',
                    rownames = FALSE,
                    options = list(buttons = c('excel'),
                                   fixedColumns = TRUE,
                                   autoWidth = FALSE,
                                   dom = 'tB',paging = FALSE, searching = FALSE, scrollX = TRUE, 
                                   initComplete = JS(
                                     "function(settings, json) {",
                                     "$(this.api().table().header()).css({'background-color': '#1F618D ', 'color': '#fff', 'font-family': 'Century Gothic'});",
                                     "}")))
      
      
    }else{
      a <- bsopt(input$s3,input$k3,input$sigma3,input$rl3,input$tt3,input$rf3)
      b <- bsputimpvol(input$s3,input$k3,input$rl3,input$tt3,input$rf3,input$precio3)
      
      nombres_put3 <- c("Precio prima call","Delta", "Gamma", "Vega", "Rho", "Theta", "Volatilidad Implícita")
      valores_put3 <- c(a[[2]][1],a[[2]][2],a[[2]][3],a[[2]][4],a[[2]][5],a[[2]][6],b)
      
      DT::datatable(data.table("Nombre" = nombres_put3, "Valor" = valores_put3),extensions = 'Buttons',
                    rownames = FALSE,
                    options = list(buttons = c('excel'),
                                   fixedColumns = TRUE,
                                   autoWidth = FALSE,
                                   dom = 'tB',paging = FALSE, searching = FALSE, scrollX = TRUE, 
                                   initComplete = JS(
                                     "function(settings, json) {",
                                     "$(this.api().table().header()).css({'background-color': '#1F618D ', 'color': '#fff', 'font-family': 'Century Gothic'});",
                                     "}")))
      
    }
  }) 
  
  # Tabla para Futuros
  output$t4 <- DT::renderDataTable({
    if(input$Op4=='Call'){
      a <- bsopt(input$F04,input$k4,input$sigma4,input$r4,input$tt4,input$r4)
      b <- bscallimpvol(input$F04,input$k4,input$r4,input$tt4,input$r4,input$precio4)
      
      nombres_call4 <- c("Precio prima call","Delta", "Gamma", "Vega", "Rho", "Theta", "Volatilidad Implícita")
      valores_call4 <- c(a[[1]][1],a[[1]][2],a[[1]][3],a[[1]][4],a[[1]][5],a[[1]][6],b )
      
      DT::datatable(data.table("Nombre" = nombres_call4, "Valor" = valores_call4),extensions = 'Buttons',
                    rownames = FALSE,
                    options = list(buttons = c('excel'),
                                   fixedColumns = TRUE,
                                   autoWidth = FALSE,
                                   dom = 'tB',paging = FALSE, searching = FALSE, scrollX = TRUE, 
                                   initComplete = JS(
                                     "function(settings, json) {",
                                     "$(this.api().table().header()).css({'background-color': '#1F618D ', 'color': '#fff', 'font-family': 'Century Gothic'});",
                                     "}")))
      
    }else{
      a <- bsopt(input$F04,input$k4,input$sigma4,input$r4,input$tt4,input$r4)
      b <- bsputimpvol(input$F04,input$k4,input$r4,input$tt4,input$r4,input$precio4)
      
      nombres_put4 <- c("Precio prima call","Delta", "Gamma", "Vega", "Rho", "Theta", "Volatilidad Implícita")
      valores_put4 <- c(a[[2]][1],a[[2]][2],a[[2]][3],a[[2]][4],a[[2]][5],a[[2]][6],b)
      
      DT::datatable(data.table("Nombre" = nombres_put4, "Valor" = valores_put4),extensions = 'Buttons',
                    rownames = FALSE,
                    options = list(buttons = c('excel'),
                                   fixedColumns = TRUE,
                                   autoWidth = FALSE,
                                   dom = 'tB',paging = FALSE, searching = FALSE, scrollX = TRUE, 
                                   initComplete = JS(
                                     "function(settings, json) {",
                                     "$(this.api().table().header()).css({'background-color': '#1F618D ', 'color': '#fff', 'font-family': 'Century Gothic'});",
                                     "}")))
      
    }
  }) 
  
  
  
  
}


# Run the application 
shinyApp(ui = ui, server = server)



