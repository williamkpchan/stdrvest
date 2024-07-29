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

pageHeader="https://xhamster.com/channels/"
pageTail=""
className = "a.image-02a1b"

titleName = "Channels"
theFilename = paste0("xhamster", titleName, ".html")
wholePage = character()

# remember to remove &#9;
addr = 1:69

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
 itemHref = html_attr(itemList, "href")
 itemHref = gsub("https://xhamster.com/channels/", "", itemHref)

 images = html_nodes(itemList, "img")
 imgSrc = html_attr(images, "src")

 linksTxt = html_attr(images, "alt")
 linksTxt = gsub("\\'", "\\\\'", linksTxt)

 videoNum = html_nodes(pagesource, ".count-02a1b")
 videoNum = gsub("<.*?>| videos", "", videoNum)
 videoNum = gsub(" video", "", videoNum)
 videoNumKIdx = grep("K|k", videoNum)
 videoNum = gsub("K|k", "", videoNum)

 videoNum[videoNumKIdx] = as.numeric(videoNum[videoNumKIdx]) *1000

 result = paste0('\'', itemHref, '"><img src="', imgSrc, '"><br>',videoNum, " ",linksTxt, '\',')

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
templateHead = readLines("templateHeadArray.txt")
templateTail = readLines("templateTailArray.txt")
templateHead = gsub("penny-barber", "xhamster channels", templateHead)
templateTail = gsub("lineHeader =.*", "lineHeader = '<div><a href=\"https://xhamster.com/channels/'", templateTail)
templateTail = gsub("lineTail = .*", "lineTail = '</a></div>'", templateTail)
templateTail = gsub("penny-barber", "xhamster channels", templateTail)

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
