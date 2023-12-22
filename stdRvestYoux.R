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

starHeader="https://www.youx.xxx/"
className = "a.thumb__link"

typeName = "channels"
channelName = "anilos"
pageTail=""
channelName = readline(prompt="enter Keyword: ")
lastPageNum = as.numeric(readline(prompt="enter total pages: "))

pageHeader = paste0(starHeader, typeName, "/",channelName)
theFilename = paste0("youx ", channelName, ".html")
titleName = paste0("youx ", channelName)

wholePage = character()

url = pageHeader
cat(url, "\n")

addr=1:lastPageNum
lentocpage = lastPageNum
cat("\ntotal pages: ",lentocpage,"\n")

ProcessStartTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")

dhms <- function(t){
    paste(t %/% (60*60*24), "day" 
         ,paste(formatC(t %/% (60*60) %% 24, width = 2, format = "d", flag = "0")
               ,formatC(t %/% 60 %% 60, width = 2, format = "d", flag = "0")
               ,formatC(t %% 60, width = 2, format = "d", flag = "0")
               ,sep = ":"
               )
         )
}

for(i in 1:length(addr)){
 cat(i, "of", length(addr), " ")

 url = paste0(pageHeader,'/',addr[i],pageTail)
 cat("url:",url, "\n")

 pagesource <- read_html(url, encoding = "utf-8")
 itemList <- html_nodes(pagesource, className)
 links = html_attr(itemList, "href")
 images = html_nodes(itemList, "img")
 imgSrc = html_attr(images, "data-src")
 linksTxt = html_attr(images, "alt")

# cleaning
 links = gsub("^.*?=", "", links)
 links = gsub("%253A", ":", links)
 links = gsub("%252F", "/", links)
 links = gsub("/&tag.*", "/", links)

 result = paste0('<div><a href="', links, '"><img class="lazy" data-src="', imgSrc, '"><br>', linksTxt, '</a></div>')
 #rmid = grep('Friends only', result)
 #result = result[-rmid]

wholePage = c(wholePage, result)

 if(i == 10){
   ProcessEndTime = Sys.time()
   LoopTime = as.numeric(ProcessEndTime - ProcessStartTime, units="secs")
   ecTime = length(addr)*LoopTime/10

   cat(red(
        "\n\n Expect to complete at: ", as.character(ProcessStartTime + ecTime),"\n",
        "per cycle time: ", dhms(LoopTime/10),"\n",
        "total time: ", dhms(ecTime),"\n\n"
      ))
 }
}

#writeClipboard(wholePage)
templateHead = readLines("templateHead.txt")
templateTail = readLines("templateTail.txt")
templateHead = gsub("mom50", paste0(titleName, ": ",length(wholePage)), templateHead)

sink(theFilename)
cat(templateHead, sep="\n")
cat(wholePage, sep="\n")
cat(templateTail, sep="\n")
sink()

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Task completed! loop time: ", dhms(LoopTime),"\n\n\n")
cat(theFilename, "created!", "Total links: ", length(wholePage), "\n")
theFilename = paste0('"',theFilename,'"')

shell(theFilename)
