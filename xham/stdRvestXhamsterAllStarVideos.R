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

className = ".xh-paginator-button"

starName = "AllStars"
pageTail=""

  starHeader="https://xhamster.com/pornstars/"
  pageHeader = starHeader

theFilename = paste0("xhamster ", starName, ".html")
titleName = starName

wholePage = character()

url = pageHeader
cat(url, "\n")
pagesource <- read_html(url)
lastPageNum <- html_nodes(pagesource, className)
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
 url = paste0(pageHeader,addr[i],pageTail)

 cat("url:",url, "\n")
 pagesource <- read_html(url)
 className = "a.pornstar-thumb-container__image"

 itemList <- html_nodes(pagesource, className)
 links = html_attr(itemList, "href")

 images = html_nodes(itemList, "img")
 imgSrc = html_attr(images, "src")
 linksTxt = html_attr(images, "alt")

 videoNum <- html_nodes(pagesource, ".videos")
 videoNum <- as.character(videoNum)
 videoNum <- gsub("<div.*?</i> |</div>", "", videoNum)

 result = paste0('<div><a href="', links, '"><img class="lazy" data-src="', imgSrc, '"><br>', linksTxt, "<br>",videoNum, '</a></div>')

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
templateHead = readLines("templateHead.txt")
templateTail = readLines("templateTail.txt")
templateHead = gsub("mom50", paste0(titleName, length(wholePage)), templateHead)

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