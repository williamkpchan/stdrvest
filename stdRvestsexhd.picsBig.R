# this download cannot download full page and reason unknown

# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
setwd("C:/Users/User/Pictures/sexpage")

library(rvest)

pageHeader="https://www.sexhd.pics/gallery/"
pageTail="/"

wholePage = character()
theFilename = "sexhd.picsBig3.html"

className = "div.relativetop a"

addr = readLines("sexhd.picsTOC.html")

lentocpage = length(addr)
cat("\nlentocpage: ",lentocpage,"\n")

ProcessStartTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")


# length(addr)
for(i in 55193:length(addr)){
 cat(i, "/", length(addr), " ")

 url = paste0(pageHeader,addr[i],pageTail)
 cat(url)
 pagesource <- tryCatch(read_html(url, warn=F, encoding = "UTF-8"), 
      error = function(e) { return("Error in open.connection") } )

 if(length(pagesource) ==1){next}
 itemList <- html_nodes(pagesource, className)

 itemList = html_attr(itemList, 'href')
 itemList = as.character(itemList)
 itemList = gsub("/gallery/","",itemList)
 rmIdx = grep("/direct/", itemList)
 if(length(rmIdx)>0){ itemList = itemList[-rmIdx]}
 cat("",length(itemList), "\n")
 wholePage = c(wholePage, paste0(itemList[1], ",",length(itemList)))
}

sink(theFilename)
cat(wholePage, sep="\n")
sink()

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Task completed! loop time: ",LoopTime,"\n\n\n")

