# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
setwd("C:/Users/User/Pictures/sexpage/freematuresgallery")

library(rvest)
library(crayon)
 ligSilver <- make_style("#889988")


batchListHist = read.table("batchListHist.txt", sep="\t")

batchList = read.table("batchList.txt", sep="\t")
colnames(batchList) = c("titleName", "totalPages")

for(row in 1:nrow(batchList)){
   key = batchList[row, 2]

   for(hrow in 1:nrow(batchListHist)){
      hkey = batchListHist[hrow, 2]
      if(key == hkey){
         cat(key, " already in history record and will be omitted.\n")
         batchList = batchList[-row,]
         break
      }
   }
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



fetchTitle <- function(tName, tPages){
      titleName = tName
      totalPages = as.numeric(tPages)

      pageHeader = paste0("http://freematuresgallery.com/niche/", tName, "/?page=")
      pageTail=""

      wholePage = character()
      wholefmgList = character()

      #collectLinks
      addr = 1:totalPages

      linkClassName = ".th a"

      lentocpage = length(addr)
      cat("\nlentocpage: ",lentocpage,"\n")

      ProcessStartTime = Sys.time()
      cat(format(Sys.time(), "%H:%M:%OS"),"\n")


      for(i in 1:length(addr)){
       cat(i, "/", length(addr), " ")

       url = paste0(pageHeader,addr[i],pageTail)
       cat(url, "\n")
       pagesource <- read_html(url)

       if(length(pagesource)==1){
         cat(red("connection error!\n"))
         next
       }

       itemList <- html_nodes(pagesource, linkClassName)

       itemList = html_attr(itemList, 'href')
       itemList = as.character(itemList)
       itemList = gsub("\\?.*","",itemList)
       itemList = unique(sort(itemList))
       cat("length(itemList) ", length(itemList))

       itemListIdx = grep("freematuresgallery",itemList)
       fmgList = itemList[itemListIdx]

       wholePage = c(wholePage, itemList)
       wholefmgList = c(wholefmgList, fmgList)
       cat(green("length(itemList): ", length(itemList)), red("length(fmgList): ", length(fmgList)), brown("length(wholePage): ", length(wholePage)),pink("length(wholefmgList): ", length(wholefmgList)),"\n")
      }

      allLinks = readLines("allLinks.txt")
      allLinks = c(allLinks, wholePage)
      allLinks = unique(sort(allLinks))
      #nicheIdx = grep("\\niche")
      #allLinks = allLinks[-nicheIdx]

      sink("allLinks.txt")
      cat(allLinks, sep="\n")
      sink()
      cat(orange("allLinks.txt updated!\n\n"))

      # collectImgs
      imgClassName = ".thumb a, .th a, td a"

      wholePage = character()
      addr = wholefmgList

      cat(orange("collecting imgs!\n"))
      for(i in 1:length(addr)){
       cat(i, "/", length(addr), " ")

       #url = paste0(pageHeader,addr[i],pageTail)
       url = paste0(addr[i],pageTail)
       cat(url, "\n")
       pagesource <- read_html(url)
       if(length(pagesource)==1){
         cat(red("connection error!\n"))
         next
       }

       itemList <- html_nodes(pagesource, imgClassName)

       itemList = html_attr(itemList, 'href')
       itemList = as.character(itemList)
       cat(green("length(itemList) ", length(itemList)))

       itemListIdx = grep("jpg",itemList)
       itemList = itemList[itemListIdx]

       urlFolder = gsub("index.php", "", url)
       itemList = paste0(urlFolder, itemList)
       cat(red(" useful length(itemList): ", length(itemList)))

       wholePage = c(wholePage, itemList)
       cat(yellow(" total length(wholePage) ", length(wholePage)),"\n")

      }

      templateHead = readLines("../templateHeadArray.txt")
      templateTail = readLines("../templateTailArray.txt")
      templateHead = gsub("penny-barber", titleName, templateHead)
      templateTail = gsub("penny-barber", titleName, templateTail)
      templateTail = gsub("https://cdni.pornpics.com/1280/", "http://freematuresgallery.com/pics/", templateTail)
      templateTail = gsub("showLongTips.js", "\\.\\./showLongTips.js", templateTail)

      wholePage = gsub("http://freematuresgallery.com/pics/", "'",wholePage)
      wholePage = gsub("\\.jpg", "',",wholePage)

      theFilename = paste0("FMG", titleName, ".html")
      sink(theFilename)
      cat(templateHead, sep="\n")
      cat(wholePage, sep="\n")
      cat(templateTail, sep="\n")
      sink()
      cat(red("file created! ", theFilename),"\n")
}

for(row in 1:nrow(batchList)){
  fetchTitle(batchList[row, 2], batchList[row, 1])
}

cat(red("Job complete!\n"))
