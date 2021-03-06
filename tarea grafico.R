###### Libreria YAPO ###############

sacandoPrecio <- function(htmlSeg){
  nodoBread <- html_nodes(htmlSeg, ".offer")
  if(length(nodoBread)>0){
    precio <- html_text(nodoBread)
    precio <- gsub("\\t","",precio)
    precio <- gsub("\\n","",precio)
    precio <- gsub("\\$","",precio)
    precio <- gsub("[.]","",precio)
    precio <- as.numeric(precio)
  }else{
    precio = NA
  }
  return(precio)
}

obtenerCategoria <- function(htmlSeg){
  nodoBread <- html_nodes(htmlSeg, ".breadcrumbs")
  nodoBread <- html_nodes(nodoBread, "strong")
  return(html_text(nodoBread))
}

obtenerComuna <- function(htmlSeg){
  nodoBread <- html_nodes(htmlSeg, "seller-info")
  comuna <- html_attr(nodoBread,"region")
  return(gsub("Región Metropolitana, ","",comuna))
}

obtenerTipoNegocio <- function(htmlSeg){
  nodoBread <- html_nodes(htmlSeg, ".details")
  nodoBread <- html_nodes(nodoBread, "table")
  tabla <- html_table(nodoBread)[[1]]
  subsettn <- unlist(subset(tabla, X1 == 'Tipo')[2])
  if(length(subsettn)>0){
    return(subsettn)
  }else{
    return(NA)
  }
}

obtenerAnioUsuarioYapo <- function(htmlSeg){
  nodoBread <- html_nodes(htmlSeg, "seller-info")
  seniority <- html_attr(nodoBread,"seniority")
  seniority <- gsub("En Yapo desde ","",seniority)
  return(strsplit(seniority," ")[[1]][2])
}

obtenerPublicacionesActivasUsuarioYapo <- function(htmlSeg){
  nodoBread <- html_nodes(htmlSeg, "seller-info")
  actives <- html_attr(nodoBread,"actives")
  return(gsub("[.]","",actives))
}

obtenerPublicacionesTotalesUsuarioYapo <- function(htmlSeg){
  nodoBread <- html_nodes(htmlSeg, "seller-info")
  historical <- html_attr(nodoBread,"historical")
  return(gsub("[.]","",historical))
}

############ Yapo Documento 

install.packages("rvest")

# cargar las librerias
library(xml2)
library(rvest)
source('libreriasYapo.R')

fullDatos <- data.frame()
for(numeroPagina in 1:3){
  readHtml <- read_html(paste("https://www.yapo.cl/region_metropolitana?ca=15_s&o=",numeroPagina,sep = ""))
  print(paste("Descargando pagina nro:",numeroPagina))
  nodeTabla <- html_nodes(readHtml, ".listing_thumbs")
  nodeTabla <- html_nodes(nodeTabla, ".title")
  linksProductos <- html_attr(nodeTabla,"href")
  
  for (urlYapo in linksProductos) {
    htmlSeg <- read_html(urlYapo)
    
    print(paste("Descargando URL ==> ",urlYapo))
    
    textoTipoAviso <- obtenerCategoria(htmlSeg)
    precio <- sacandoPrecio(htmlSeg)
    comuna <- obtenerComuna(htmlSeg)
    tipoNegocio <- obtenerTipoNegocio(htmlSeg)
    anioUsuarioyapo <- obtenerAnioUsuarioYapo(htmlSeg)
    publicacionesactivasusuarioyapo <- obtenerPublicacionesActivasUsuarioYapo(htmlSeg)
    publicacionestotalesusuarioyapo <- obtenerPublicacionesTotalesUsuarioYapo(htmlSeg)
    
    fullDatos <- rbind(fullDatos,data.frame(comuna = comuna, categoria = textoTipoAviso, precio = precio,
                                            tiponegocio = tipoNegocio, aniousuarioyapo = anioUsuarioyapo,
                                            urlyapo = urlYapo ))
  }
}




View(fullDatos)

####################### GUIA DE GRAFICOS

install.packages("tidyverse")

library(ggplot2)
library(tidyverse)
library(datasets)
library(dplyr)


names(fullDatos)

fullDatos %>%  filter(categoria=="Ofertas de empleo") 

filter(fullDatos,comuna=="Regi�n Metropolitana, Maip�")

fullDatos<-as.tibble(fullDatos)


Autos<- fullDatos %>% filter(categoria=="Autos, camionetas y 4x4")


ggplot(fullDatos, aes(y=comuna, x=categoria))+ geom_bar(stat = "identity", position="dodge")

############# INTENTE TODO PARA PODER FILTRAR LOS DATOS Y PODER HACER EL ANALISIS, PERO EL R ME MARCA MULTIPLES ERRORES




