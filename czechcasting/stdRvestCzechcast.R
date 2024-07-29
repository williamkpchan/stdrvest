rm(list = ls())

# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
setwd("C:/Users/User/Pictures/sexpage/czechcasting/")

#library(audio)
library(rvest)
library(crayon)
 ligSilver <- make_style("#889988")

pageHeader="https://czechcasting.com/tour/models/page-"
# https://czechcasting.com/tour/models/page-170/
#pageTail="/"
pageTail=""
className = ".photo a"

collectUrl <- function(url){
    tmp <- tryCatch(
             read_html(url, warn=F), silent = TRUE,
             error = function (e) NULL
           )
    if (is.null(tmp)) {
      cat("\n doesn't exist\n")
      return("<html></html>")
    }else{
      return(tmp)
    }
}


cat(green("\nrequest for imgs\n"))
wholePage = character()
addr = 1:170
lentocpage = 170
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

 pagesource <- collectUrl(url)
 itemList <- html_nodes(pagesource, className)
 itemList = itemList[-(1:3)]
 itemListHref = html_attr(itemList, 'href')
 itemListHref = as.character(itemListHref)

 itemListImg = html_nodes(itemList, 'img')
 itemListImg = as.character(itemListImg)
 itemListImg = gsub('jpg.*?"','jpg"',itemListImg)

 itemLink = paste0("<a href='",itemListHref, "'><img src='",itemListImg, "'></a>")
 wholePage = c(wholePage, itemLink)

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

#writeClipboard(wholePage)
templateHead = readLines("templateHead.txt")
templateTail = readLines("templateTail.txt")
templateHead = gsub("mom50", titleName, templateHead)
templateTail = gsub("mom50", titleName, templateTail)

theFilename = paste0("czechcasting models.html")

sink(theFilename)
cat(templateHead, sep="\n")
cat(wholePage, sep="\n")
cat(templateTail, sep="\n")
sink()

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Task completed! loop time: ", dhms(LoopTime),"\n\n\n")
cat(red(theFilename, "created\n"))
#finishBeep(1)
