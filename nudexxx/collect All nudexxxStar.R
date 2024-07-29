# collect nudexxx.pics
# this download cannot download full page and reason unknown
rm(list = ls())

# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
setwd("C:/Users/User/Pictures/sexpage/")

#library(audio)
library(rvest)
library(crayon)
 ligSilver <- make_style("#889988")

pageHeader="https://www.nudexxx.pics/load.php?scroll=1&p="

#pageTail="/"
pageTail=""
#className = ".thumbwook a"

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


#### look for all page list
urlHeader = "https://www.nudexxx.pics/load.php?scroll=1&p="

#schkey = readline(prompt="enter schkey:")
#schkey = gsub(" |-", "+", schkey)
schKey = "pornstars"
pageTail = "&pornstars=1"

limitNum = 30

addr = character()
cat(green("\nrequest all lists:\n"))

for(i in 1:1000){
  url = paste0(urlHeader, i, pageTail)
  cat("\n",url, " ")
  pagesource <- readLines(url)
  itemList = unlist(strsplit(pagesource, 'class="msg"'))
  itemListIdx = grep("<a target", itemList)
  itemList = itemList[itemListIdx]
  itemList = gsub('^.*?<a', '<a', itemList)

  rmIdx = grep("nofollow|g_url", itemList) # some url have pictures included
  if(length(rmIdx)>0){ itemList = itemList[-rmIdx] }

  itemList = gsub(' target="a_self"|<div.*?>| width="100%"|</div>', '', itemList)
  itemList = gsub('<div.*', '', itemList)
  addr = c(addr, itemList)
  cat(length(addr), " ")

  if(length(itemList)<29){break}
}
cat("\ntotal: ",length(addr), "\n")

  addr = sort(addr)
  addr = unique(addr)

outFilename = "./nudexxx/nudexxxPornstars.html"
sink(outFilename)
  cat(addr, sep="\n")
sink()
cat(red(outFilename, " created!\n"))

