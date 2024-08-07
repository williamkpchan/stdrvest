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

starHeader="https://xhamster.com/channels/"
className = ".page-list-container li"

typeArr = c("1 Channel", "2 creators", "3 users", "4 Star", "5 search", "6 tags", "7 categories")
typeArrStr = paste(typeArr, collapse = ', ')

typeName = readline(prompt=paste0("select ", typeArrStr, "(1/2/3/4/5/6/7): "))
starName = readline(prompt="enter Keyword: ")
mergeMode = readline(prompt="merge mode? n/y(0/1) ")
#cat("selected: ", typeArr[as.numeric(mergeMode)], "\n")
cat("selected: ", as.numeric(mergeMode), "\n")

pageTail=""
    if(typeName == "1"){
      starHeader="https://xhamster.com/channels/"
      pageHeader = paste0(starHeader, starName)
      className = ".page-button-link"
    
    }else if(typeName == "2"){
      starHeader="https://xhamster.com/creators/"
      pageHeader = paste0(starHeader, starName)
    }else if(typeName == "3"){
      starHeader=paste0("https://xhamster.com/users/", starName, "/videos")
      pageHeader = starHeader
    }else if(typeName == "4"){
      starHeader="https://xhamster.com/pornstars/"
      pageHeader = paste0(starHeader, starName)
    }else if(typeName == "5"){
      starHeader=paste0("https://xhamster.com/search/", starName, "?quality=720p&sort=best&page=")
      pageHeader = starHeader
    }else if(typeName == "6"){
      starHeader="https://xhamster.com/tags/"
      pageHeader = paste0(starHeader, starName)
    }else if(typeName == "7"){
      urlHeader="https://xhamster.com/categories/"
      pageHeader = paste0(urlHeader, starName)
    }

if(mergeMode == "0"){
  theFilename = paste0("xhamster ", starName, ".htm")
}else{
  theFilename = paste0("mergeLists.js")
}

titleName = starName

wholePage = character()

# remember to remove &#9;

url = paste0(pageHeader, "/hd/")

batchFIleHistory = readLines("xhamsterBatchProcessHistory.txt")
historyIdx = grep(url, batchFIleHistory)
if(length(historyIdx) !=0){
    stop(red("\nAlready Listed in xhamsterBatchProcessHistory.txt History!: ", historyIdx, "\n"))
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

for(i in 1:length(addr)){
 cat(i, "of", length(addr), " ")

 url = paste0(pageHeader, "/hd/",addr[i],pageTail)
 if(typeName == "5"){
   url = paste0(pageHeader, addr[i])
 }
 cat("url:",url, "\n")
 pagesource <- read_html(url)
 className = "a.video-thumb__image-container"

 itemList <- html_nodes(pagesource, className)
 links = html_attr(itemList, "href")
 previewvideo = html_attr(itemList, "data-previewvideo")

 images = html_nodes(itemList, ".thumb-image-container__image")
 imgSrc = html_attr(images, "src")
 linksTxt = html_attr(images, "alt")
 linksTxt = gsub("'", "\'", linksTxt)

 if(mergeMode != "0"){
   linksTxt = paste0(starName,", " ,linksTxt)
 }

 sprite <- html_nodes(pagesource, "div.thumb-image-container__sprite")
 sprite = html_attr(sprite, "data-sprite")
 spriteTxt = paste0('<br><img src="', sprite)
 spriteTxt = gsub('.jpg', '', spriteTxt)

 videoTxt = paste0('<br><video controls loop autoplay><source src="', previewvideo, '"></video>')

 result = paste0('<div><a href="', links, '"><img src="', imgSrc, '"><br>', linksTxt, '</a>', videoTxt, spriteTxt, '</div>')
 #rmid = grep('Friends only', result)s
 #result = result[-rmid]

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
templateHead = gsub("penny-barber", paste0(titleName, ": ",length(wholePage)), templateHead)
templateTail = gsub("penny-barber", paste0(titleName, ": ",length(wholePage)), templateTail)
wholePage = gsub("'", ".", wholePage)
wholePage = gsub("<div>", "'", wholePage)
wholePage = gsub("</div>", "',", wholePage)

if(mergeMode == "0"){
  sink(theFilename)
  cat(templateHead, sep="\n")
  cat(wholePage, sep="\n")
  cat(templateTail, sep="\n")
  sink()
}else{
  mergeFile = readLines(theFilename)
  mergeFile = mergeFile[-length(mergeFile)]
  mergeFile = c(mergeFile, wholePage, "];")
  sink(theFilename)
  cat(mergeFile, sep="\n")
  sink()
}

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Task completed! loop time: ", dhms(LoopTime),"\n\n\n")
cat(theFilename, "created!", "Total links: ", length(wholePage), "\n")
theFilename = paste0('"',theFilename,'"')

if(mergeMode == "0"){
  shell(theFilename)
}else{
  shell("mergeLists.html")
}

      write(url, file="xhamsterBatchProcessHistory.txt", append=TRUE)
      cat(yellow("\nxhamsterBatchProcessHistory.txt updated!\n"))
