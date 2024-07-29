# this must be added to setting chinese
# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
srcDir = "C:/Users/User/Pictures/sexpage/pohub/R"
outDir = "C:/Users/User/Pictures/sexpage/pohub/"
setwd(srcDir)

#library(audio)
library(rvest)
library(crayon)
 ligSilver <- make_style("#889988")

cat(red("\n\nextract PHub models in Process.txt\n"))
batchFIle = readLines("PHubBatchProcess.txt")
batchFIleHistoryName = "PHubBatchProcessHistory.txt"
batchFIleHistory = readLines(batchFIleHistoryName)
cat(orange("length of PHubBatchProcess: ", length(batchFIle), "\n\n"))
ProcessTime = Sys.time()

outputFilename = readline(prompt="enter outputFilename or enter for default: ")
if(outputFilename == ""){
  outputFilename = paste0("pohubModel", format(ProcessTime, "%H%M"), ".html")
}else{
  outputFilename = paste0("pohubModel", outputFilename, ".html")
}
cat("outputFilename: ",outputFilename, "\n\n")

cat("\n\n")
pageHeader ="https://www.pornhub.com/"
className = ".phimage a"
pageTail="?page="
theFilename = outputFilename
wholePage = character()

    dhms <- function(t){
        paste(t %/% (60*60*24), "day" 
             ,paste(formatC(t %/% (60*60) %% 24, width = 2, format = "d", flag = "0")
                   ,formatC(t %/% 60 %% 60, width = 2, format = "d", flag = "0")
                   ,formatC(t %% 60, width = 2, format = "d", flag = "0")
                   ,sep = ":"
                   )
             )
    }

for(k in batchFIle){
  cat(yellow(k))
  historyIdx = grep(k, batchFIleHistory)
  urlAdr = unlist(strsplit(k, ","))
  adrUrl = urlAdr[1]
  lastPageNum = ceiling(as.numeric(urlAdr[2])/40)

  if(length(historyIdx) ==0){
    tagName = gsub("^.*?com/", "", adrUrl)
    tagName = gsub("/.*", "", tagName)
    starName = gsub("^.*/", "", adrUrl)
    cat(red("\ntagName: ", tagName, " starName: ", starName, "\n"))

    if(tagName == "model"){
      urlHeader = "https://www.pornhub.com/model/"
      pageHeader = paste0(urlHeader, starName, "/videos")
      className = ".phimage a"

    }else if(tagName == "channels"){
      urlHeader = "https://www.pornhub.com/channels/"
      pageHeader = paste0(urlHeader, starName, "/videos")
      className = ".phimage a"
      lastPageNum = ceiling(as.numeric(urlAdr[2])/36)

    }else if(tagName == "pornstar"){
      urlHeader = "https://www.pornhub.com/pornstar/"

      if(is.na(urlAdr[3])){
        pageHeader = paste0(urlHeader, starName, "/videos")
      }else{
        pageHeader = paste0(urlHeader, starName)
      }
      className = ".phimage a"
    }

    titleName = starName
    url = pageHeader
    addr=1:lastPageNum
    lentocpage = lastPageNum
    cat("\ntotal pages: ",lentocpage,"\n")

    ProcessStartTime = Sys.time()
    cat(format(Sys.time(), "%H:%M:%OS"),"\n")

    for(i in 1:length(addr)){
     cat(i, "of", length(addr), " ")

     url = paste0(pageHeader,pageTail, addr[i])
     cat("url:",url, "\n")
     pagesource <- read_html(url)
     className = ".phimage a"

     itemList <- html_nodes(pagesource, className)
     links = html_attr(itemList, "href")
     #links = paste0("https://www.pornhub.com", links)
     links = gsub("\\/view_video.php\\?viewkey=", "https://www.pornhub.com/embed/", links)
     rmlinks = grep("javascript", links)
     if(length(rmlinks)>0){
       links = links[-rmlinks]
     }

     previewvideo = html_attr(itemList, "data-previewvideo")
     # writeClipboard(as.character(itemList[1]))
     images = html_nodes(itemList, "img")
     imgSrc = html_attr(images, "src")
     linksTxt = html_attr(images, "alt")
     linksTxt = paste0(starName,", " ,linksTxt)

     result = paste0('<div><a href="', links, '"><img src="', imgSrc, '"><br>', linksTxt, '</a></div>')
     result = gsub("'", ".", result)

     wholePage = c(wholePage, result)
    }
  }else{
    cat(red("\nListed in History!: ", k, "\n"))
  }
}

    ProcessEndTime = Sys.time()
    cat(format(Sys.time(), "%H:%M:%OS"),"\n")
    LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
    cat(red("Task completed! loop time: ", dhms(LoopTime),"\n\n\n"))
    cat(theFilename, "created!", "Total links: ", length(wholePage), "\n")

setwd(outDir)
templateHead = readLines("templateHeadPohub.txt")
templateTail = readLines("templateTailPohub.txt")
templateHead = gsub("dreamgirlsmembers", gsub("\\.html","",outputFilename), templateHead)
templateTail = gsub("dreamgirlsmembers", gsub("\\.html","",outputFilename), templateTail)
wholePage = gsub("/view_video.php\\?viewkey=", "", wholePage)
cat(red("length(wholePage) before unique: ",length(wholePage), "\n"))
wholePage = unique(wholePage)
cat(green("length(wholePage) after unique: ",length(wholePage), "\n"))

privateIdx = grep("private-video",wholePage)
if(length(privateIdx)!=0){
  wholePage = wholePage[-privateIdx]
  cat(red("removed privateIdx: ", length(privateIdx), "\n"))
}

wholePage = gsub('<div><a href=\"https://www.pornhub.com/embed/', "'", wholePage)
wholePage = gsub('</a></div>', "',", wholePage)

sink(outputFilename)
cat(templateHead, sep="\n")
cat(wholePage, sep="\n")
cat(templateTail, sep="\n")
sink()

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Task completed! loop time: ", dhms(LoopTime),"\n\n\n")
cat(theFilename, "created\n")

shell(outputFilename)

setwd(srcDir)
      batchFIleHistory = c(batchFIleHistory, batchFIle)
      sink(batchFIleHistoryName)
        cat(batchFIleHistory, sep="\n")
      sink()
      cat(yellow("\n",batchFIleHistoryName, "updated!\n"))


      cleanUP = readline(prompt="clean PHubBatchProcess.txt? (0/1): ")

      if(cleanUP == "1"){
        sink("PHubBatchProcess.txt")
          cat("")
        sink()
        cat(yellow("\nPHubBatchProcess.txt washed!\n"))
      }

