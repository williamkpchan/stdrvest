# this download cannot download full page and reason unknown

# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
# setwd("C:/Users/User/Pictures/sexpage")
setwd("C:/Users/User/Pictures/sexpage")

#library(audio)
library(rvest)
library(crayon)
library(jsonlite)
 ligSilver <- make_style("#889988")

assembly = character()
historyFile = "xhamsterFotoHistory.txt"
batchFIleHistory = readLines(historyFile)

dhms <- function(t){
    paste(t %/% (60*60*24), "day" 
         ,paste(formatC(t %/% (60*60) %% 24, width = 2, format = "d", flag = "0")
               ,formatC(t %/% 60 %% 60, width = 2, format = "d", flag = "0")
               ,formatC(t %% 60, width = 2, format = "d", flag = "0")
               ,sep = ":"
               )
         )
}

chkRepeatUrl <- function(urls){
  rmIdx = numeric()
  for(i in length(urls)){
    url = urls[i]
    historyIdx = grep(url, batchFIleHistory)
    if(length(historyIdx) !=0){
        cat(red("\n", urls[i],"\nAlready Listed in xhamsterBatchProcessHistory.txt History!: ", historyIdx, "\n"))
        rmIdx = c(rmIdx, i)
    }
  }
  urls = urls[-rmIdx]
  cat(red("Total urls: "), length(urls), "\n")
}

collectImages <- function(url){
    cat(red(url, "\n"))
    pagesource <- read_html(url)
    lastPageclassName = ".test-pager li, .page-button-link"
    lastPageNum <- html_nodes(pagesource, lastPageclassName)

    if(length(lastPageNum)==0){
      lastPageNum = 1
    }else{
      lastPageIdx = length(lastPageNum) -1
      thelastLine = html_nodes(lastPageNum[lastPageIdx], "a")
      lastPageNum = as.numeric(html_attr(thelastLine, "data-page"))
    }
    
    #if(length(lastPageNum)==0){
    #  lastPageNum = 1
    #}else{
    #  lastPageNum = as.numeric(html_text(lastPageNum))
    #}
    
    addr=1:lastPageNum
    lentocpage = lastPageNum
    cat("\ntotal pages: ",lentocpage,"\n")
    
    for(i in 1:length(addr)){
     cat(i, "of", length(addr), " ")
    
     pageUrl = url
     if(i!=1){
        pageUrl = paste0(url, "/",i)
     }
    
     cat("url:",pageUrl, "\n")
    
     pagesource <- readLines(pageUrl)
     targetLineIdx = grep("photoModel", pagesource)
     targetLine = pagesource[targetLineIdx]
     targetLine = gsub('^.*,"photos":', '', targetLine )
     targetLine = gsub(',"editable.*', '', targetLine)
     # writeClipboard(targetLine)
     targetLineDf = fromJSON(targetLine)

     removeIdx = grep("friends",targetLineDf["icon"])
     targetLineDf = targetLineDf[-removeIdx, ]

     imgSrc = unlist(targetLineDf["imageURL"])
    
     result = paste0('<div><img src="', imgSrc, '"></div>')
     cat(yellow("length(resut): ", length(result), " "))
     urlStr = paste0("<k>", url, "</k>")
     assembly <<- c(assembly, urlStr, result)
     cat(green("length(TotalLines): ", length(assembly), "\n"))

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
}

# main
 urlSrc = readline("read urls from file or user site 0/1: ")
 titleName = "batch file"

 if(urlSrc=="0"){
  # read urls from file
  cat("read urls from batchurl.txt\n")
  urls = readLines("batchurl.txt")
 }else{
  # read urls from user site
  source("stdRvestXhamsterUserGrpPhotos.R")
  urls = wholePage
  urls = gsub('^.*?href="','',urls)
  urls = gsub('">.*','',urls)
  rmIdx = grep('^$', urls)
  if(length(rmIdx)!=0){
    urls = urls[-rmIdx]
  }
 }

chkRepeatUrl(urls)

ProcessStartTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")

counter = 0
urlslength = length(urls)
for(i in urls){
  counter = counter +1
  cat(blue("album no: ",counter, " of ", urlslength, " "))
  collectImages(i)
}

    
#writeClipboard(assembly)
templateHead = readLines("templateHeadArrayXhamFoto.txt")
templateTail = readLines("templateTailArrayXhamFoto.txt")
templateHead = gsub("penny-barber", paste0(titleName, ": ",length(assembly)), templateHead)
templateTail = gsub("penny-barber", paste0(titleName, ": ",length(assembly)), templateTail)


assembly = gsub("'", ".", assembly)
assembly = gsub("<div>", "'", assembly)
assembly = gsub("</div>", "',", assembly)
assembly = gsub("<k>", "'<k>", assembly)
assembly = gsub("</k>", "</k>',", assembly)

theFilename = paste0("xhamFoto ",titleName, length(assembly), ".html")
  sink(theFilename)
  cat(templateHead, sep="\n")
  cat(assembly, sep="\n")
  cat(templateTail, sep="\n")
  sink()


ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Task completed! loop time: ", dhms(LoopTime),"\n\n\n")
cat(theFilename, "created!", "Total links: ", length(assembly), "\n")
theFilename = paste0('"',theFilename,'"')

      write(urls, file=historyFile, append=TRUE)
      cat(yellow("\n", historyFile, "updated!\n"))
