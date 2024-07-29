# collect pictoa.com/galleries
# https://www.pictoa.com/c/big-clit-160/page51.html # cat
# https://www.pictoa.com/s/big-clit/ # search
# https://www.pictoa.com/s/big-clit/page8.html
# pageNum
rm(list = ls())

# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
#setwd("C:/Users/william/Desktop/scripts/pornpics/")
setwd("C:/Users/User/Pictures/sexpage/pictoa")

#library(audio)
library(rvest)
library(crayon)
 ligSilver <- make_style("#889988")
pageTail=""
className = "a.gallery-title" # pictoa
wholePage = character()

collectUrl <- function(url){
    tmp <- tryCatch(
             read_html(url, warn=F), silent = TRUE,
             error = function (e) NULL
           )
    if (is.null(tmp)) {
      cat("\n doesn't exist\n")
      return("<html></html>")
    }else{
      return(tmp)
    }
}

#### look for XHR
urlHeader = "https://www.pictoa.com/s/"

schkey = readline(prompt="enter schkey:")
schkey = gsub(" ", "-", schkey)

pageNum = as.numeric(readline(prompt="enter number of pages:"))
addr = 1:pageNum
cat(green("\nrequest URLs:\n"))

for(i in addr){
  url = paste0(urlHeader, schkey, "/page", i, ".html")
  cat("\n",url, " ")
  pagesource <- collectUrl(url)
  # pagesource <- readLines("https://www.pictoa.com/s/big-clit/page7.html")
  itemList <- html_nodes(pagesource, className)
  itemList = html_attr(itemList, 'href')
  itemList = as.character(itemList)

  wholePage = c(wholePage, itemList)
  cat(green("length(itemList): ", length(itemList)), red("length(wholePage): ", length(wholePage)))
}

cat(yellow("\ntotal: ",length(wholePage), "\n"))

  wholePage = sort(wholePage)
  wholePageIdx = grep("shemale|trans|gay",wholePage)
  if(length(wholePageIdx)>0){
    wholePage = wholePage[-wholePageIdx]
  }

  wholePageAddr = wholePage

cat(green("\nrequest for imgs\n"))
wholePage = character()

titleName = schkey
lentocpage = length(wholePageAddr)
cat("\nlentocpage: ",lentocpage,"\n")

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

# collect urls
className = ".cover-box img"
for(i in 1:length(wholePageAddr)){
 cat("\n",i, "/", length(wholePageAddr), " ")

 url = wholePageAddr[i]
 cat(url, "\n")

 pagesource <- collectUrl(url)
 itemList <- html_nodes(pagesource, className)

 itemList = as.character(itemList)
 itemListIdx = grep('jpg">', itemList)
 itemList = itemList[itemListIdx]
 itemList = gsub('^.*?-lazy-src="', '', itemList)
 itemList = gsub('//t1', '//s1', itemList)
 itemList = gsub('">', '', itemList)

 wholePage = c(wholePage, itemList)
 cat(green("length(itemList): ", length(itemList)), red("length(wholePage): ", length(wholePage)))

 if(i == 10){
   ProcessEndTime = Sys.time()
   LoopTime = as.numeric(ProcessEndTime - ProcessStartTime, units="secs")
   ecTime = length(wholePageAddr)*LoopTime/10

   cat(red(
        "\n\n Expect to complete at: ", as.character(ProcessStartTime + ecTime),"\n",
        "per cycle time: ", dhms(LoopTime/10),"\n",
        "Expected total time: ", dhms(ecTime),"\n\n"
      ))
 }
}


 wholePage = gsub('\\.jpg.*', "',", wholePage)

#writeClipboard(wholePage)
templateHead = readLines("templateHead.txt")
templateTail = readLines("templateTail.txt")
templateHead = gsub("mom50", titleName, templateHead)
templateTail = gsub("mom50", titleName, templateTail)
wholePage = gsub("https://s1.pictoa.com/media/galleries/", "'", wholePage)
templateTail = gsub("https://cdni.pornpics.com/1280/", "https://s1.pictoa.com/media/galleries/", templateTail)
theFilename = paste0("pictoa ", titleName, ".html")

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
