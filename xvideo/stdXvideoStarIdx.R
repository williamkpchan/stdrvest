# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
setwd("C:/Users/User/Pictures/sexpage/xvideo/")

#library(audio)
library(rvest)
library(crayon)
 ligSilver <- make_style("#889988")

pageHeader="https://www.xvideos.com/pornstars-index/"
className = "div.thumb a"

# https://www.xvideos.com/pornstars-index/689

pageTail=""

theFilename = paste0("xvideo stars-index.html")

wholePage = character()
lastPageNum = 689
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
 cat(i, "of", length(addr))

 url = paste0(pageHeader, addr[i])
 cat(" ",url, "\n")
 pagesource <- read_html(url)

 itemList <- html_nodes(pagesource, className)
 links = html_attr(itemList, "href")

#writeClipboard(as.character(images))
 itemListTxt = as.character(itemList)
 imgSrc = gsub('^.*?src=\\"','', itemListTxt)
 imgSrc = gsub('\\" id=".*','', images)

 linksTxt = gsub("^.*?models/",'', itemListTxt)
 linksTxt = gsub('\\\".*','', linksTxt)

 result = paste0('\'', links, '"><img src="', imgSrc, '"><br>', linksTxt, '\',')
wholePage = c(wholePage, result)
 cat(red("length(result):", length(result), "length(wholePage):", length(wholePage), "\n") )

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
templateHead = gsub("penny-barber", paste0("xvideos stars", length(wholePage)), templateHead)
templateTail = gsub("penny-barber", paste0("xvideos stars", length(wholePage)), templateTail)
templateTail = gsub("https://cdni.pornpics.com/1280/", '<div><a href="https://www.xvideos.com'), templateTail)
templateTail = gsub(".jpg\">", '</a></div>'), templateTail)


wholePage = unique(sort(wholePage))
sink(theFilename)
cat(templateHead, sep="\n")
cat(wholePage, sep="\n")
cat(templateTail, sep="\n")
sink()

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Task completed! loop time: ", dhms(LoopTime),"\n\n\n")
cat(theFilename, "created\n", "links: ", length(wholePage), "\n")
theFilename = paste0('"',theFilename,'"')
shell(theFilename)