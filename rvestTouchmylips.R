# this download cannot download full page and reason unknown

# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
setwd("C:/Users/william/Desktop/scripts")

#library(audio)
library(rvest)

pageHeader="https://www.touchmylips.com"
pageTail=""

wholePage = character()
theFilename = "touchmylips.html"
# "list",

# remember to remove &#9;
#addr = 1:20
#addr = letters[1:26]
#addr = readLines("touchmylips.txt")
addr = readLines("touchmylipU.txt")

#className = ".tmbs a"
className = ".pics a"

lentocpage = length(addr)
cat("\nlentocpage: ",lentocpage,"\n")

ProcessStartTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")

for(i in 1:length(addr)){
 cat(i, "/", length(addr), " ")
 url = paste0(pageHeader,addr[i],pageTail)
 cat(url, "\n")
 pagesource <- read_html(url)

 itemList <- html_nodes(pagesource, className)

 itemList = html_attr(itemList, 'href')
 itemList = as.character(itemList)
 wholePage = c(wholePage, itemList)
 if(i == 10){
   ProcessEndTime = Sys.time()
   LoopTime = as.numeric(ProcessEndTime - ProcessStartTime, units="secs")
   ecTime = length(addr)*LoopTime/10
   cat("\n\nExpect to complete at: ", as.character(ProcessStartTime + ecTime),"\n\n")
 }
}

wholePage = paste0('<br><img class="lazy" data-src=', pageHeader, wholePage, '">')
sink(theFilename)
cat(wholePage, sep="\n")
sink()

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Task completed! loop time: ",LoopTime,"\n\n\n")
