# collect pornpics.com/galleries
# read pornpicBatch.txt
rm(list = ls())

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

pageHeader="https://www.pornpics.com/galleries/"
#pageTail="/"
pageTail=""
className = ".thumbwook a" # pornpic

#### look for XHR
urlHeader = "https://www.pornpics.com/search/srch.php?q="

schkeyList = readLines("pornpicBatch.txt")
schkeyList = gsub(" |-", "+", schkeyList) # different on diff sites
schkeyList = gsub("/", "", schkeyList) # different on diff sites
cat(red("\nlength(schkeyList): ",length(schkeyList), "\n"))

schkeyHistory = readLines("pornpicHistory.txt")
  commons = unique(schkeyList[schkeyList %in% schkeyHistory])
  for(item in commons){schkeyList = schkeyList[-(which(schkeyList == item))]}

cat(green("after unique, length(schkeyList): ",length(schkeyList), "\n"))

limitKey = "&lang=en&limit="
#limitNum = as.numeric(readline(prompt="enter limitNum:"))
limitNum = 100
offsetkey = "&offset="
offset = limitNum

dhms <- function(t){
    paste(t %/% (60*60*24), "day" 
         ,paste(formatC(t %/% (60*60) %% 24, width = 2, format = "d", flag = "0")
               ,formatC(t %/% 60 %% 60, width = 2, format = "d", flag = "0")
               ,formatC(t %% 60, width = 2, format = "d", flag = "0")
               ,sep = ":"
               )
         )
}

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


doBatchjob <- function(schkey){
  cat(green("\n\nrequest XHR:\n"))
  for(i in 1:1000){
    url = paste0(urlHeader, schkey, limitKey, limitNum, offsetkey, offset*(i-1))
    cat("\n",url, " ")
    pagesource <- readLines(url)
    itemList = unlist(strsplit(pagesource, '","'))
    itemListIdx = grep("g_url", itemList)
    itemList = itemList[itemListIdx]
    itemList = gsub('^.*?galleries', '', itemList)

    addr = gsub("\\\\/", "", addr)
    addr = c(addr, itemList)
    cat(length(addr), " ")
  
    if(length(itemList)<(limitNum-3)){break}
  }

  cat(green("\n\ntotal: ", length(addr), "\n"))
  outFilename = paste0(schkey, ".txt")
    addr = gsub("\\\\/", "", addr)
    addr = sort(addr)

    cat(pink("\nremove useless keyword links!\n"))
    rmIdx = grep("nofollow|g_url|blacksonblondes|naughtyamerica|payserve|PA=|purecfnm|index.php|coupon=", addr) # some url have pictures included
    if(length(rmIdx)>0){ addr = addr[-rmIdx] }
    cat(pink("\nremove dot links!\n"))
    rmIdx = grep("^\\.", addr) # some url have pictures included
    if(length(rmIdx)>0){ addr = addr[-rmIdx] }

  cat(yellow("\nafter rmIdx, total: ",length(addr), "\n"))

  cat(red(outFilename, "\n"))
  sink(outFilename)
    cat(addr, sep="\n")
  sink()
  cat(red(outFilename, " created!\n"))
  ####
  
  cat(green("\nrequest for imgs\n"))
  wholePage = character()

  # addr = readLines(paste0(titleName, ".txt"))
    addr = gsub("\\\\/", "", addr)
  
  titleName = schkey
  lentocpage = length(addr)
  cat("\nlentocpage: ",lentocpage,"\n")
  
  ProcessStartTime = Sys.time()
  cat(format(Sys.time(), "%H:%M:%OS"),"\n")
  
  for(i in 1:length(addr)){
   if(length(addr)==0){break}
   cat(i, "/", length(addr), " ")
   #guess_encoding(pagesource)
   #pagesource <- read_html(paste0(pageHeader,addr[i],pageTail), encoding = "UTF-8")
   #url = paste0(pageHeader,addr[i],pageTail)
   url = paste0(pageHeader,addr[i],pageTail)
   cat(url, "\n")
   pagesource <- retrieveFile(url)
  
   itemList <- html_nodes(pagesource, className)
  
   itemList = html_attr(itemList, 'href')
   itemList = as.character(itemList)
   itemList = gsub('https://cdni.pornpics.com/1280/', '\'', itemList)
   itemList = gsub('\\.jpg', '\',', itemList)
  
   wholePage = c(wholePage, itemList)
  
   if(i == 10){
     ProcessEndTime = Sys.time()
     LoopTime = as.numeric(ProcessEndTime - ProcessStartTime, units="secs")
     ecTime = length(addr)*LoopTime/10
  
     cat(red(
          "\n\n Expect to complete at: ", as.character(ProcessStartTime + ecTime),"\n",
          "per cycle time: ", dhms(LoopTime/10),"\n",
          "Expected total time: ", dhms(ecTime),"\n\n"
        ))
   }
  }
  
  templateHead = readLines("templateHeadArray.txt")
  templateTail = readLines("templateTailArray.txt")
  templateHead = gsub("penny-barber", titleName, templateHead)
  templateTail = gsub("penny-barber", titleName, templateTail)
  
  theFilename = paste0("pornpics", titleName, ".html")
  
  sink(theFilename)
  cat(templateHead, sep="\n")
  cat(wholePage, sep="\n")
  cat(templateTail, sep="\n")
  sink()
  
  ProcessEndTime = Sys.time()
  cat(format(Sys.time(), "%H:%M:%OS"),"\n")
  LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
  cat("Task completed! loop time: ", dhms(LoopTime),"\n\n\n")
  cat(red(theFilename, "created\n"))
  # update history
  sink("pornpicHistory.txt", append = TRUE)
    cat(titleName, sep="\n")
  sink()
}

# main loop
for(key in schkeyList){
  addr = character()
  cat(yellow("\nNumber", match(key,schkeyList), "of",length(schkeyList), "schkey: ", key))
  doBatchjob(key)
}


