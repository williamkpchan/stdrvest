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
# https://www.pornhub.com/channels/dreamgirlsmembers/videos?page=1
# 2269

pageHeader="https://www.pornhub.com/channels/"
pageTail="/videos?page="
className = ".phimage a"

#titleName = "dreamgirlsmembers"
titleName = readline(prompt="enter title name: ")
#totalVideos = 2269
totalVideos = as.numeric(readline(prompt="enter totalVideos: "))
totalPages = ceiling(totalVideos/36)

theFilename = paste0('pohub ',titleName, ".html")
allLinks = character()
wholePage = character()

addr = 1:totalPages

lentocpage = length(addr)
cat("\nlentocpage: ",lentocpage,"\n")

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
 cat(i, "/", length(addr), " ")
 #guess_encoding(pagesource)
 #pagesource <- read_html(paste0(pageHeader,addr[i],pageTail), encoding = "UTF-8")
 #url = paste0(pageHeader,addr[i],pageTail)

 url = paste0(pageHeader, titleName, pageTail,addr[i] )
 #url = paste0(pageHeader,addr[i],pageTail)
 cat(url, "\n")
 pagesource <- read_html(url)

 itemList <- html_nodes(pagesource, className)
 itemHref = html_attr(itemList, "href")
 linksTxt = html_attr(itemList, "title")
 linksTxt = gsub("\\'","\\\\'",linksTxt)

 images = html_nodes(itemList, "img")
 imgSrc = html_attr(images, "src")

 result = paste0('\'', itemHref, '"><img src="', imgSrc, '"><br>', linksTxt, '\',')
 result = gsub("/embed/", "", result)
 
 allLinks = c(allLinks, result)

 if(i == 10){
   ProcessEndTime = Sys.time()
   LoopTime = as.numeric(ProcessEndTime - ProcessStartTime, units="secs")
   ecTime = length(addr)*LoopTime/10

   cat(red(
        "\n\n Expect to complete at: ", as.character(ProcessStartTime + ecTime),"\n",
        "per cycle time: ", dhms(LoopTime/10),"\n",
        "Expected total time: ", dhms(ecTime),"\n\n"
      ))
 }
}

setwd("C:/Users/User/Pictures/sexpage/pohub")
templateHead = readLines("templateHeadPohub.txt")
templateTail = readLines("templateTailPohub.txt")
templateHead = gsub("dreamgirlsmembers", titleName, templateHead)
templateHead = gsub('<div><a href="https://www.pornhub.com/', '<div><a href="https://www.pornhub.com/embed/', templateHead)
templateTail = gsub("dreamgirlsmembers", titleName, templateTail)

sink(theFilename)
cat(templateHead, sep="\n")
cat(allLinks, sep="\n")
cat(templateTail, sep="\n")
sink()

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Task completed! loop time: ", dhms(LoopTime),"\n\n\n")
cat(theFilename, "created\n")
