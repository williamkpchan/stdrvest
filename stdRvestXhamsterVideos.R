
# this must be added to setting chinese
#Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
setwd("C:/Users/User/Pictures/sexpage")

#library(audio)
library(rvest)
library(crayon)
 ligSilver <- make_style("#889988")

titleName = "faphouse"
totalPages = 2514
#classType = "pornstars"
classType = "channels"

pageHeader= paste0("https://xhamster.com/", classType, "/", titleName, "/")
pageTail=""
className = ".video-thumb__image-container"

theFilename = paste0("xhamster ", titleName, " video.html")
wholePage = character()

# remember to remove &#9;
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
 url = paste0(pageHeader,addr[i],pageTail)
 cat(url, "\n")
 pagesource <- read_html(url)

 itemList <- html_nodes(pagesource, className)
 itemList = as.character(itemList)

 itemList = gsub('\\n', '', itemList)
 itemList = gsub(' class="video-thumb.*?thumb-link"', '', itemList)
 itemList = gsub(' data-previewvideo.*?>', '>', itemList)
 itemList = gsub('<div class="thumb-image-container__sprite.*?>', '', itemList)
 itemList = gsub(' class="thumb-image-container.*? src', ' class="lazy" data-src', itemList)
 itemList = gsub(' alt="', '><br>', itemList)
 itemList = gsub('"></div>.*', '</a></div>', itemList)
 itemList = gsub('"<div.*', '</a></div>', itemList)
 itemList = gsub('<div.*', '</a></div>', itemList)
 itemList = gsub('<a', '<div><a', itemList)
 itemList = gsub('<span.*?</span>', '', itemList)

 wholePage = c(wholePage, itemList)

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
templateHead = gsub("mom50", paste0(titleName, " videos"), templateHead)
templateHead = gsub("font-size:24px", "font-size:16px", templateHead)

sink(theFilename)
cat(templateHead, sep="\n")
cat(wholePage, sep="\n")
cat(templateTail, sep="\n")
sink()

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Task completed! loop time: ", dhms(LoopTime),"\n\n\n")
cat(theFilename, "created\n")
