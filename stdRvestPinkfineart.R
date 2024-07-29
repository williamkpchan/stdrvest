# this download cannot download full page and reason unknown

# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
setwd("C:/Users/User/Pictures/sexpage")

library(rvest)
library(crayon)

serverName = "https://www.pinkfineart.com/"
titleName = readline("enter titleName: ")
titleName = gsub(" ", "-", titleName)

lastPageNum = as.numeric(readline("enter lastPageNum: "))

#pageHeader="https://www.pinkfineart.com/als-angels/page/"
linkPageHeader = paste0(serverName, titleName, "/page/")

pageTail=""

wholePage = character()
allLinks = character()
theFilename = paste0("pinkfineart", titleName, ".html")

linkClassName = ".card-link" # pinkfineart links
imgClassName = ".card a" # pinkfineart

# remember to remove &#9;
linkAddr = 1:lastPageNum
imgAddr = character()

lentocpage = length(linkAddr)
cat("\nLink pages number: ",lentocpage,"\n")

ProcessStartTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")

finishBeep <- function(rptCnt){ # beep count
    while(rptCnt>0){
        play(sin(1:6000/10))
        Sys.sleep(0.2)
     rptCnt = rptCnt-1
    }
}

dhms <- function(t){
    paste(t %/% (60*60*24), "day" 
         ,paste(formatC(t %/% (60*60) %% 24, width = 2, format = "d", flag = "0")
               ,formatC(t %/% 60 %% 60, width = 2, format = "d", flag = "0")
               ,formatC(t %% 60, width = 2, format = "d", flag = "0")
               ,sep = ":"
               )
         )
}

for(i in 1:length(linkAddr)){
 cat(i, "/", length(linkAddr), " ")
 #guess_encoding(pagesource)
 #pagesource <- read_html(paste0(pageHeader,addr[i],pageTail), encoding = "UTF-8")

 url = paste0(linkPageHeader, linkAddr[i],pageTail)
 cat(url, "\n")
 pagesource <- read_html(url)

 itemList <- html_nodes(pagesource, linkClassName)

 itemList = html_attr(itemList, 'href')
 itemList = as.character(itemList)
 allLinks = c(allLinks, itemList)
 cat(green("length(itemList): ", length(itemList)), yellow(" length(allLinks): ", length(allLinks), "\n"))
}

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Link Task completed! loop time: ",LoopTime," secs\n\n")

allLinks = sort(allLinks)
allLinks = unique(allLinks)
cat(red("unique(allLinks): ", length(allLinks)), "\n")

modServerName = substring(serverName, 1, nchar(serverName)-1)

for(i in 1:length(allLinks)){
 cat(i, "/", length(allLinks), " ")

 url = paste0(modServerName, allLinks[i],pageTail)
 cat(url, "\n")
 pagesource <- read_html(url)
 itemList <- html_nodes(pagesource, imgClassName)

 itemList = html_attr(itemList, 'href')
 itemList = as.character(itemList)
 wholePage = c(wholePage, itemList)
 cat(brown("length(itemList): ", length(itemList)), orange(" length(wholePage): ", length(wholePage), "\n"))
}
wholePage = paste0(modServerName, wholePage)
rplLine = paste0("^.*?", titleName, "/")
wholePage = gsub(rplLine, "'", wholePage)
wholePage = gsub('\\.jpg.*', "',", wholePage)

#writeClipboard(wholePage)

templateHead = readLines("templateHeadArray.txt")
templateTail = readLines("templateTailArray.txt")
templateHead = gsub("penny-barber", titleName, templateHead)
templateTail = gsub("penny-barber", titleName, templateTail)
headLine = paste0("https://www.pinkfineart.com/galleries/", titleName, "/")
templateTail = gsub("https://cdni.pornpics.com/1280/", headLine, templateTail)

theFilename = paste0("./pinkfineart/", theFilename)
sink(theFilename)
cat(templateHead, sep="\n")
cat(wholePage, sep="\n")
cat(templateTail, sep="\n")
sink()

ProcessEndTime = Sys.time()
cat("task complete time: ",format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Task completed! loop time: ", dhms(LoopTime),"\n\n\n")
cat(theFilename, "created\n")
finishBeep(1)
