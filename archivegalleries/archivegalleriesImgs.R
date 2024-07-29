# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
setwd("C:/Users/User/Pictures/sexpage/archivegalleries")
library(rvest)
library(crayon)
 ligSilver <- make_style("#889988")

pageHeader = ""
pageTail=""

wholePage = character()
theFilenameHead = "archivegalleriesImgsMOdi"

chopLimit = 3000
className = ".link a, td a"

#addr = readLines("archivegalleriesLinks.txt")
addr = readLines("archivegalleriesLinksLongList.txt")

lentocpage = length(addr)
cat("\nlentocpage: ",lentocpage,"\n")

ProcessStartTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")


templateHead = readLines("templateArchieHead.txt")
templateTail = readLines("templateArchieTail.txt")

  retrieveFile <- function(urlAddr){
    retryCounter = 1
    while(retryCounter < 5) {
      cat("...try ",retryCounter, "\n") 
      retriveFile <- tryCatch(read_html(urlAddr, warn=F, encoding = "UTF-8"), 
                        warning = function(w){
                         cat(silver("code param error "));
                         return(" code param error ")
                        }, 
                        error = function(e) {
                          if(grepl("Error in open.connection", e)){
                            cat(silver(" Error in open.connection "))
                            return("Error in open.connection")
                          }else if(grepl("Error in doc_parse_raw", e)){
                            cat(silver(" Error in doc_parse_raw, "))
                            return(read_html(urlAddr, warn=F))
                          }else{
                            cat(red(" unknown error "))
                            return("unknown error")
                          }
                        }
                     )
      if (grepl("code param error", retriveFile)) {
        cat(red(" Error in connection, try 5 secs later!\n"))
        retryCounter <- retryCounter + 1
        retriveFile = "<html></html>"  # if end of loop this will be returned
        retryCounter = 200  # to jump out of loop
      }else if(grepl("Error in open.connection", retriveFile)){
        cat(red("unable to connect! \n"), urlAddr,"\n")
        retryCounter <- retryCounter + 1
        retriveFile = "<html></html>"  # if end of loop this will be returned
        retryCounter = 200  # to jump out of loop
      }else if(grepl("unknown error", retriveFile)){
        retriveFile = "<html></html>"  # if end of loop this will be returned
        retryCounter = 200  # to jump out of loop
      }else{
        #cat(green(" \tseems OK! "))
        retryCounter = 200  # to jump out of loop
      }
    }
    #cat(green(" loop end retry counts: ", retryCounter, "\n"))
    return(retriveFile)
  }

for(i in 12001:length(addr)){
 cat(i, "/", length(addr), " ")

 url = paste0(pageHeader,addr[i],pageTail)
 cat(url, "\n")
 pagesource <- retrieveFile(url)
 if(length(pagesource)==1){
   cat(red("connection error!\n"))
   next
 }

 itemList <- html_nodes(pagesource, className)

 itemList = html_attr(itemList, 'href')
 itemList = as.character(itemList)
 itemList = paste0(url,itemList)
 itemList = gsub("http://archivegalleries.net/collection/","'",itemList)
 itemList = gsub("\\.jpg","',",itemList)

 rvIdx = grep("join.allover30.com",itemList)
 if(length(rvIdx)>0){
   itemList = itemList[-rvIdx]
 }

 wholePage = c(wholePage, itemList)
 cat(yellow("length(itemList): ", length(itemList)), green("length(wholePage): ", length(wholePage)), "\n")

 if((i %% chopLimit) == 0){
   quotiient = i %/% chopLimit
   quotiient = formatC(quotiient, width = 2, format = "d", flag = "0")

   theFilename = paste0(theFilenameHead, quotiient, ".html")
   sink(theFilename)
   cat(templateHead, sep="\n")
   cat(wholePage, sep="\n")
   cat(templateTail, sep="\n")
   sink()
   wholePage = character()
   cat(red(theFilename, " created!\n\n"))
 }

}

   quotiient = i %/% chopLimit + 1 # last remaining page
   quotiient = formatC(quotiient, width = 2, format = "d", flag = "0")

   theFilename = paste0(theFilenameHead, quotiient, ".html")
   sink(theFilename)
   cat(templateHead, sep="\n")
   cat(wholePage, sep="\n")
   cat(templateTail, sep="\n")
   sink()
   wholePage = character()
   cat(red(theFilename, " created!\n\n"))

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Task completed! loop time: ",LoopTime,"\n\n\n")

