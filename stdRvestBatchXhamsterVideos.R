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

cat(red("\n\nBATCH Process xhamsterTxt.txt\n"))
batchFIle = readLines("xhamsterBatchProcess.txt")
batchFIleHistory = readLines("xhamsterBatchProcessHistory.txt")

pageHeader ="https://xhamster.com/channels/"
className = ".page-list-container li"
pageTail=""
theFilename = paste0("xhamsterBatch.js")
wholePage = character()

for(k in batchFIle){
  historyIdx = grep(k, batchFIleHistory)
  if(length(historyIdx) ==0){
    tagName = gsub("^.*?com/", "", k)
    tagName = gsub("/.*", "", tagName)
    starName = gsub("^.*/", "", k)
    cat(red("\ntagName: ", tagName, " starName: ", starName, "\n"))

    if(tagName == "channels"){
      urlHeader = "https://xhamster.com/channels/"
      pageHeader = paste0(urlHeader, starName)
      className = ".page-button-link"
    }else if(tagName == "creators"){
      urlHeader="https://xhamster.com/creators/"
      pageHeader = paste0(urlHeader, starName)
    }else if(tagName == "users"){
      urlHeader=paste0("https://xhamster.com/users/", starName, "/videos")
      pageHeader = urlHeader
    }else if(tagName == "pornstars"){
      urlHeader="https://xhamster.com/pornstars/"
      pageHeader = paste0(urlHeader, starName)
    }else if(tagName == "search"){
      urlHeader=paste0("https://xhamster.com/search/", starName, "?quality=720p&sort=best&page=")
      pageHeader = urlHeader
    }else if(tagName == "tags"){
      urlHeader="https://xhamster.com/tags/"
      pageHeader = paste0(urlHeader, starName)
    }else if(tagName == "categories"){
      urlHeader="https://xhamster.com/categories/"
      pageHeader = paste0(urlHeader, starName)
    }

    titleName = starName

    url = pageHeader
    cat(url, "\n")

    pagesource <- read_html(paste0(url, "/hd/"))
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

    for(i in 1:length(addr)){
     cat(i, "of", length(addr), " ")

     url = paste0(pageHeader, "/hd/",addr[i],pageTail)
     if(tagName == "5"){
       url = paste0(pageHeader, addr[i])
     }
     cat("url:",url, "\n")
     pagesource <- read_html(url)
     className = "a.video-thumb__image-container"

     itemList <- html_nodes(pagesource, className)
     links = html_attr(itemList, "href")
     previewvideo = html_attr(itemList, "data-previewvideo")

     images = html_nodes(itemList, "noscript img")
     imgSrc = html_attr(images, "src")
     linksTxt = html_attr(images, "alt")
     linksTxt = paste0(starName,", " ,linksTxt)

     sprite <- html_nodes(pagesource, "div.thumb-image-container__sprite")
     sprite = html_attr(sprite, "data-sprite")
     spriteTxt = paste0('<br><img src="', sprite, '"><br>')

     videoTxt = paste0('<br><video controls loop autoplay><source src="', previewvideo, '"></video>')

     result = paste0('<div><a href="', links, '"><img src="', imgSrc, '"><br>', linksTxt, '</a>', videoTxt, spriteTxt, '</div>')

     wholePage = c(wholePage, result)
    }
  }else{
    cat(red("\nListed in History!: ", k, "\n"))
  }
}
    templateHead = readLines("templateHeadArray.txt")
    templateTail = readLines("templateTailArray.txt")
    templateHead = gsub("penny-barber", paste0(titleName, ": ",length(wholePage)), templateHead)
    templateTail = gsub("penny-barber", paste0(titleName, ": ",length(wholePage)), templateTail)
    wholePage = gsub("'", ".", wholePage)
    wholePage = gsub("<div>", "'", wholePage)
    wholePage = gsub("</div>", "',", wholePage)

    ProcessEndTime = Sys.time()
    cat(format(Sys.time(), "%H:%M:%OS"),"\n")
    LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
    cat(red("Task completed! loop time: ", dhms(LoopTime),"\n\n\n"))
    cat(theFilename, "created!", "Total links: ", length(wholePage), "\n")
    cat(red("remember to rename the html and js file and add to pstart"))

      mergeFile = readLines(theFilename)
      mergeFile = mergeFile[-length(mergeFile)]
      mergeFile = c(mergeFile, wholePage, "];")
      sink(theFilename)
        cat(mergeFile, sep="\n")
      sink()

      batchFIleHistory = c(batchFIleHistory, batchFIle)
      sink("xhamsterBatchProcessHistory.txt")
        cat(batchFIleHistory, sep="\n")
      sink()
      cat(yellow("\nxhamsterBatchProcessHistory.txt updated!\n"))
      shell("xhamsterBatch.html")

      cleanUP = readline(prompt="clean xhamsterBatchProcess.txt? (0/1): ")

      if(cleanUP == "1"){
        sink("xhamsterBatchProcess.txt")
          cat("")
        sink()
        cat(yellow("\nxhamsterBatchProcess.txt washed!\n"))
      }
