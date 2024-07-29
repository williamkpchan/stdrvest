# to extract user group photos

Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
#setwd("C:/Users/william/Desktop/scripts")
setwd("C:/Users/User/Pictures/sexpage")

#library(audio)
library(rvest)
library(crayon)
library(jsonlite)
 ligSilver <- make_style("#889988")

userHeader="https://xhamster.com/users/"
lineSignature = "window.initials="

userName = "olderwomanfun"
userName = readline(prompt="enter userName: ")
wholePage = character()
theFilename = paste0("xhamFoto", userName, ".html")
url = paste0(userHeader, userName, "/photos/")

batchFIleHistory = readLines("xhamFotoBatHist.txt")
historyIdx = grep(userName, batchFIleHistory)
if(length(historyIdx) !=0){
    stop(red("\nAlready Listed in xhamFotoBatHist.txt History!: ", historyIdx, "\n"))
}

cat(url, "\n")
pagesource <- read_html(url)
lastPageclassName = ".xh-paginator-button, .page-button-link"
lastPageNum <- html_nodes(pagesource, lastPageclassName)
lastPageNum = lastPageNum[length(lastPageNum)]
if(length(lastPageNum)==0){
  lastPageNum = 1
}else{
  lastPageNum = as.numeric(html_text(lastPageNum))
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

for(i in addr){
 cat(i, "of", length(addr), " ")
 if(i==1){
   url = paste0(userHeader, userName, "/photos/")
 }else{
   url = paste0(userHeader, userName, "/photos/", i)
 }

 cat("url:",url, "\n")
 pagesource <- readLines(url)
 targetLineIdx = grep(lineSignature, pagesource)
 targetLine = pagesource[targetLineIdx]
 targetLine = gsub('^.*userGalleriesCollection":', '', targetLine )
 targetLine = gsub(',"favoritesGalleryCollection.*', '', targetLine)
 # writeClipboard(targetLine)
 targetLineMat = as.matrix(fromJSON(targetLine))

 cat("nrow(targetLineMat)bf: ", nrow(targetLineMat), " ")
 # "icon":"friends", "privacy":1,
 privacy = targetLineMat[, "icon"]
 rmIdx = grep("friends", privacy)
 cat("length(rmIdx): ", length(rmIdx), " ")
 if(length(rmIdx)>0){
   targetLineMat = targetLineMat[-rmIdx, ]
 }

 if(is.matrix(targetLineMat)){
   cat("nrow(targetLineMat)af: ", nrow(targetLineMat), " ")
   links = targetLineMat[, "pageURL"]
   imgSrc = targetLineMat[, "thumbURL"]
   linksTxt = targetLineMat[, "title"]
   linksTxt = gsub("'", "\'", linksTxt)
   imgCount = targetLineMat[, "imgCount"]
 }else{
   cat("nrow(targetLineMat)af: ", "1 ")
   links = targetLineMat["pageURL"]
   imgSrc = targetLineMat["thumbURL"]
   linksTxt = targetLineMat["title"]
   linksTxt = gsub("'", "\'", linksTxt)
   imgCount = targetLineMat["imgCount"]
 }

 result = paste0('000',imgCount,'<div><a href="', links, '"><img src="', imgSrc, '"><br>', linksTxt, '</a> ', imgCount, '</div>')
 cat("length(resut): ", length(result), "\n")
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
templateHead = readLines("templateHeadXham.txt")
templateTail = readLines("templateTailXham.txt")
templateHead = gsub("mom50", userName, templateHead)
templateTail = gsub("mom50", userName, templateTail)

wholePage = gsub("'", ".", wholePage)
wholePage = gsub("</div>", "',", wholePage)
wholePage = sort(wholePage, decreasing=TRUE)
wholePage = gsub("^.*?<div>", "'", wholePage)

  sink(theFilename)
  cat(templateHead, sep="\n")
  cat(wholePage, sep="\n")
  cat(templateTail, sep="\n")
  sink()

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Task completed! loop time: ", dhms(LoopTime),"\n\n\n")
cat(red(theFilename, "created!", "Total links: ", length(wholePage), "\n"))
