# this download cannot download full page and reason unknown

# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
setwd("C:/Users/User/Pictures/sexpage")

#library(audio)
library(rvest)
library(crayon)
 ligSilver <- make_style("#889988")

pageHeader ="https://www.pornhub.com/pornstars?gender=female&cup=d&breasttype=natural&page="
className = "div.wrap a"
pageTail=""
lentocpage = 79
theFilename = "phubStars.js"
wholePage = character()

    dhms <- function(t){
        paste(t %/% (60*60*24), "day" 
             ,paste(formatC(t %/% (60*60) %% 24, width = 2, format = "d", flag = "0")
                   ,formatC(t %/% 60 %% 60, width = 2, format = "d", flag = "0")
                   ,formatC(t %% 60, width = 2, format = "d", flag = "0")
                   ,sep = ":"
                   )
             )
    }


    for(i in 1:lentocpage){
     url = paste0(pageHeader,pageTail, i)
     cat("url:",url, "\n")
     pagesource <- read_html(url)
     className = "div.wrap a"
     #className = ".phimage a"

     itemList <- html_nodes(pagesource, className)
     links = html_attr(itemList, "href")
     #links = paste0("https://www.pornhub.com", links)
     #links = gsub("\\/view_video.php\\?viewkey=", "https://www.pornhub.com/embed/", links)
     rmlinks = grep("javascript", links)
     if(length(rmlinks)>0){
       links = links[-rmlinks]
     }

     # writeClipboard(as.character(itemList[1]))
     images = html_nodes(itemList, "img")
     imgSrc = html_attr(images, "src")
     linksTxt = html_attr(images, "alt")

     result = paste0('<div><a href="', links, '"><img src="', imgSrc, '"><br>', linksTxt, '</a></div>')

     wholePage = c(wholePage, result)
    }

    wholePage = gsub("'", ".", wholePage)
    wholePage = gsub("<div>", "'", wholePage)
    wholePage = gsub("</div>", "',", wholePage)

      sink(theFilename)
        cat(wholePage, sep="\n")
      sink()

    cat(red("Task completed!\n"))
