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
