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
library(jsonlite)
 ligSilver <- make_style("#889988")

source("stdRvestXhamsterUserGrpPhotos.R")
titleName = userName
urls = wholePage
urls = gsub('^.*?href="','',urls)
urls = gsub('">.*','',urls)



wholePage = character()
historyFile = "xhamsterFotoHistory.txt"
batchFIleHistory = readLines(historyFile)

historyIdx = grep(url, batchFIleHistory)
if(length(historyIdx) !=0){
    stop(red("\nAlready Listed in xhamsterBatchProcessHistory.txt History!: ", historyIdx, "\n"))
}
cat(url, "\n")
pagesource <- read_html(url)
lastPageclassName = ".test-pager li, .page-button-link"
lastPageNum <- html_nodes(pagesource, lastPageclassName)
lastPageIdx = length(lastPageNum) -1
thelastLine = html_nodes(lastPageNum[lastPageIdx], "a")
lastPageNum = as.numeric(html_attr(thelastLine, "data-page"))

#if(length(lastPageNum)==0){
#  lastPageNum = 1
#}else{
#  lastPageNum = as.numeric(html_text(lastPageNum))
#}

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

 if(i!=1){
    url = paste0(url, "/",i)
 }

 cat("url:",url, "\n")

 pagesource <- readLines(url)
 targetLineIdx = grep("photoModel", pagesource)
 targetLine = pagesource[targetLineIdx]
 targetLine = gsub('^.*,"photos":', '', targetLine )
 targetLine = gsub(',"editable.*', '', targetLine)
 # writeClipboard(targetLine)
 targetLineDf = fromJSON(targetLine)

 imgSrc = unlist(targetLineDf["imageURL"])

 result = paste0('<div><img src="', imgSrc, '"></div>')
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
templateHead = readLines("templateHeadArrayXhamFoto.txt")
templateTail = readLines("templateTailArrayXhamFoto.txt")
templateHead = gsub("penny-barber", paste0(titleName, ": ",length(wholePage)), templateHead)
templateTail = gsub("penny-barber", paste0(titleName, ": ",length(wholePage)), templateTail)


wholePage = gsub("'", ".", wholePage)
wholePage = gsub("<div>", "'", wholePage)
wholePage = gsub("</div>", "',", wholePage)

theFilename = paste0("xhamFoto ",titleName, ".html")
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

      write(url, file=historyFile, append=TRUE)
      cat(yellow("\n", historyFile, "updated!\n"))
