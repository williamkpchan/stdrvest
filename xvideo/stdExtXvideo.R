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
className = ".xh-paginator-button"

typeName = readline(prompt="select Channel, creators, users, Star or search (1/2/3/4/5): ")
starName = readline(prompt="enter Keyword: ")
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
}

theFilename = paste0("xhamster ", starName, ".html")
titleName = starName

wholePage = character()

# remember to remove &#9;

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

 url = paste0(pageHeader,'/',addr[i],pageTail)
 if(typeName == "5"){
   url = paste0(pageHeader, addr[i])
 }
 cat("url:",url, "\n")
 pagesource <- read_html(url)
 className = "a.video-thumb__image-container"

 itemList <- html_nodes(pagesource, className)
 links = html_attr(itemList, "href")

 images = html_nodes(itemList, "img")
 imgSrc = html_attr(images, "src")
 linksTxt = html_attr(images, "alt")

 result = paste0('<div><a href="', links, '"><img class="lazy" data-src="', imgSrc, '"><br>', linksTxt, '</a></div>')
 
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