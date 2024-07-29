# this download cannot download full page and reason unknown
#fleshlight
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

pageHeader="https://www.xvideos.com/?k="
className = "div.thumb a, p.title"

typeName = readline(prompt="select Channel, Star or search (1/2/3): ")
starName = readline(prompt="enter Keyword: ")

pageTail=""

if(typeName == "1"){
  starHeader="https://www.xvideos.com/channels/"
  pageHeader = paste0(starHeader, starName)

}else if(typeName == "2"){
  starHeader="https://www.xvideos.com/pornstars/"
  pageHeader = paste0(starHeader, starName)
}else if(typeName == "3"){
  starHeader="https://www.xvideos.com/?k="
  pageHeader = paste0(starHeader, starName)
}

theFilename = paste0("xvideos ", starName, ".html")
titleName = starName
wholePage = character()



url = pageHeader
cat(url, "\n")
pagesource <- read_html(url)
lastPageNum <- html_nodes(pagesource, '.last-page')
lastPageNum = html_text(lastPageNum)
lastPageNum = as.numeric(unique(lastPageNum))

if(length(lastPageNum)==0){
  lastPageNum = 1
}

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
 url = paste0(pageHeader,'&p=',addr[i])

 cat("url:",url, "\n")
 pagesource <- read_html(url)
 itemList <- html_nodes(pagesource, className)
 itemList <- as.character(itemList)
 itemList <- gsub(' src=.*?data-src', ' src', itemList)
 itemList <- gsub(' data-idcd.*?</a>', '><br>', itemList)
 itemList <- gsub('<a href="', '<div><a href="https://www.xvideos.com', itemList)

 itemList <- gsub('<p class=.*?title=.*?[">|\'>]', '', itemList) # imp mod to satisfy spec cond
 itemList <- gsub(' <span class.*?$', '</a></div>', itemList)

 #writeClipboard(itemList)
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
cat(theFilename, "created\n", "links: ", length(wholePage), "\n")
theFilename = paste0('"',theFilename,'"')
shell(theFilename)