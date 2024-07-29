# collect pornpics.com/galleries
# this download cannot download full page and reason unknown
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
schkey = readline(prompt="enter schkey:")
schkey = gsub(" |-", "+", schkey)

limitKey = "&lang=en&limit="
#limitNum = as.numeric(readline(prompt="enter limitNum:"))
limitNum = 100
offsetkey = "&offset="
offset = limitNum
addr = character()
cat(green("nrequest XHR:\n"))

for(i in 1:1000){
  url = paste0(urlHeader, schkey, limitKey, limitNum, offsetkey, offset*(i-1))
  cat("\n",url, " ")
  pagesource <- readLines(url)
  itemList = unlist(strsplit(pagesource, '","'))
  itemListIdx = grep("g_url", itemList)
  itemList = itemList[itemListIdx]
  itemList = gsub('^.*?galleries', '', itemList)

  rmIdx = grep("nofollow", itemList) # some url have pictures included
  if(length(rmIdx)>0){ itemList = itemList[-rmIdx] }

  addr = gsub("\\\\/", "", addr)
  addr = c(addr, itemList)
  cat(length(addr), " ")

  if(length(itemList)<97){break}
}
cat("\ntotal: ",length(addr), "\n")
outFilename = paste0(schkey, ".txt")
  addr = gsub("\\\\/", "", addr)

sink(outFilename)
  cat(addr, sep="\n")
sink()
cat(red(outFilename, " created!\n"))
####

cat(green("\nrequest for imgs\n"))

rmIdx = grep("nofollow|g_url|blacksonblondes|naughtyamerica|payserve|PA=|purecfnm|index.php|coupon=", addr) # some url have pictures included

if(length(rmIdx)>0){ addr = addr[-rmIdx] }
  cat(yellow("\nafter rmIdx, total: ",length(addr), "\n"))

wholePage = character()

# remember to remove &#9;
# addr = readLines(paste0(titleName, ".txt"))
  addr = gsub("\\\\/", "", addr)

titleName = schkey
lentocpage = length(addr)
cat("\nlentocpage: ",lentocpage,"\n")

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

for(i in 1:length(addr)){
 cat(i, "/", length(addr), " ")
 #guess_encoding(pagesource)
 #pagesource <- read_html(paste0(pageHeader,addr[i],pageTail), encoding = "UTF-8")
 #url = paste0(pageHeader,addr[i],pageTail)
 url = paste0(pageHeader,addr[i],pageTail)
 cat(url, "\n")
 pagesource <- read_html(url)

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

#writeClipboard(wholePage)
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
#finishBeep(1)
