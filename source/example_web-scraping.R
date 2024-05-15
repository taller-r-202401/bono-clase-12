
## packages
require(pacman)
p_load(tidyverse,rvest,xml2)

##=== extraer las url ===##
lista_url <- list()
for (i in 1:165){
     
     ## get html
     html_main <- read_html(paste0("https://www.properati.com.co/s/barranquilla-atlantico/apartamento/venta","/",i))
    
     ## subset html 
     html_subset <- html_main %>% html_node(xpath='//*[@id="listings"]/section')
    
     ## subtraer link
     url <- html_subset %>% html_nodes("a") %>% html_attr("href")
     url_full <- paste0("https://www.properati.com.co",url)
     lista_url[[i]] <- url_full
}

all_url <- lista_url %>% unlist %>% str_subset("proyecto" , negate = T)

##=== obtener los atributos de la vivienda ===##

## save data
fill=rep(NA,length(all_url))
data <- tibble(price=fill , features=fill , 
               descripcion=fill , url=fill)

## loop
for (j in 1:nrow(data)){
  
     ## sleep 
     Sys.sleep(5)
  
     ## get html-inmueble 
     html_i <- read_html(all_url[j])
    
     ## price
     price <- html_i %>% 
              html_element(xpath='//*[@id="prices-and-fees"]/div/div') %>% 
              html_text2()
     
     ## features
     features <- html_i %>%
                 html_element(xpath='/html/body/section/div[2]/div[1]/div[2]') %>%
                 html_text2() # %>% strsplit(split="\n")
    
     ## descripcion
     descripcion <- html_i %>%
                    html_node("#description-text") %>%
                    html_text2()
     
     ## data
     data$price[j] <- price
     data$features[j] <- features
     data$descripcion[j] <- descripcion
     data$url[j] <- all_url[j]
}
  
## export data
export(data , "output/data_barranquilla.rds")
  

html <- read_html(db$url[100])
write_xml(x = html, file = "output/html_100.html")



  