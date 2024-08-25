Sys.setlocale(category = 'LC_ALL', 'Chinese')
setwd("C:/Users/User/Pictures/sexpage/babe.today")

library(rvest)
library(crayon)
 ligSilver <- make_style("#889988")

urlHeader = "https://babe.today/pics/abigailfraser"
pageTail = ""
totalPages = 1
linkClassName = ".jpeg"
wholePage = character()
outFile = "babe.today.abigailfraser.html"

targetLinkSig = '<a href="/pics/abigailfraser'

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


addr = 1:totalPages
      for(i in 1:length(addr)){
       cat(i, "/", length(addr), " ")

       url = paste0(urlHeader,addr[i],pageTail)
       cat(url, "\n")
       pagesource <- read_html(url)

       if(length(pagesource)==1){
         cat(red("connection error!\n"))
         next
       }

       itemList <- html_nodes(pagesource, linkClassName)
       targetIdx = grep(targetLinkSig, itemList)
       itemList = itemList[targetIdx]

       #itemList = html_attr(itemList, 'href')
       itemList = as.character(itemList)

       removeTxt = 'href="/'
       replaceTxt = 'href="/https://babe.today/'

       itemList = gsub(removeTxt, replaceTxt, itemList)

       #itemList = unique(sort(itemList))
       cat("length(itemList) ", length(itemList))

       #itemListIdx = grep('gallery/',itemList)
       #itemList = itemList[itemListIdx]
       #cat(" after filter: ", length(itemList))

       wholePage = c(wholePage, itemList)
       wholePage = unique(wholePage)

       cat(green(" length(wholePage): ", length(wholePage)),"\n")
      }

      sink(outFile)
      cat(wholePage, sep="\n")
      sink()
      cat(red(outFile, " updated!\n\n"))

cat(red("Job complete!\n"))
