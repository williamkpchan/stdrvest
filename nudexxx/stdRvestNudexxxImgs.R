# all-over-30, karups-older-women, scoreland
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
#setwd("C:/Users/User/Pictures/sexpage")
#setwd("C:/Users/william/Desktop/scripts")
setwd("C:/Users/User/Pictures/sexpage/nudexxx/")

#library(audio)
library(rvest)
library(crayon)
 ligSilver <- make_style("#889988")
# https://www.pornhub.com/channels/dreamgirlsmembers/videos?page=1
# 2269

#titleName = "dreamgirlsmembers"
# https://www.nudexxx.pics/channels/all-over-30/
cat("\n")
titleName = readline(prompt="enter title name: ")
titleName = gsub(" |\\+", "-", titleName)
totalPages = 1000

  typeName = ""
  while(typeName == ""){
    typeName = readline(prompt="1 categories, 2 star, 3 search, 4 channels, 5 batch Job (1,2,3,4,5):")
  }

  if(typeName=="1"){
    pageHeader="https://www.nudexxx.pics/categories/"
    pageTail="/"
  }else if(typeName=="2"){
    pageHeader="https://www.nudexxx.pics/pornstars/"
    pageTail="/"
  }else if(typeName=="3"){
    pageHeader="https://www.nudexxx.pics/load.php?scroll=1&opc=&search="
    pageTail="&p="
  }else if(typeName=="4"){
  # https://www.nudexxx.pics/load.php?p=8&pre=1&opc=&search=&pornstars=&pornstar=&category=&categories=&channel=all-over-30&favorites=&likes=&album=&albumid=
  # https://www.nudexxx.pics/load.php?&channel=all-over-30&p=9
    pageHeader="https://www.nudexxx.pics/load.php?"
    pageHeader= paste0(pageHeader, "&channel=")
    pageTail="&p="
  }else if(typeName=="5"){
    # ask for address src file
    srcFileName = readline(prompt="enter src file name: ")
    srcFile = readLines(srcFileName)
    addrIdx = grep('<div><a href="', srcFile)
    addr = srcFile[addrIdx]
    addr = gsub('\\.html.*', '', addr)
    addr = gsub('^.*?(\\d{5})', "\\1", addr)  # v.imp!!!
    addr = paste0("https://www.nudexxx.pics/gallery.php?id=", addr)
    totalPages = length(addr)
  }

className = ".item a"

theFilename = paste0('nudexxx ',titleName, ".html")
allLinks = character()
wholePage = character()

totalResults = 0

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



for(i in 1:totalPages){
    cat(i, "of ", totalPages)
    if(typeName==3){
      url = paste0(pageHeader, titleName, pageTail, i )
    }else if(typeName==4){
      url = paste0(pageHeader, titleName, pageTail, i )
    }else if(typeName==5){
      url = addr[i]
    }else{
      url = paste0(pageHeader, titleName, pageTail )
    }

    #url = paste0(pageHeader, i,pageTail)
    cat(url, "\n")
    pagesource <- read_html(url)
    itemList <- html_nodes(pagesource, className)

    # print(as.character(itemList))
    #itemList <- html_nodes(itemList, "a")  # note may need modify

    itemHref = html_attr(itemList, "href")

    if(typeName==4){
      itemHref = gsub("^.*?url=", "", itemHref)

      linksTxt <- html_nodes(pagesource, '.title')
      linksTxt = html_text(linksTxt, "href")

      images = html_nodes(itemList, "img")
      imgSrc = html_attr(images, "src")
   }else if(typeName==5){  # fullimg
      itemHrefIdx = grep("full", itemHref)
      itemHref = itemHref[itemHrefIdx]
   }
 
   if(typeName==5){
      result = paste0('<img class="lazy" data-src="', itemHref, '"><br>')
   }else{
      result = paste0('<div><a href="', itemHref, '"><img class="lazy" data-src="', imgSrc, '"><br>', linksTxt, '</a></div>')
   }

   cat(yellow("length(result): ",length(result), "  "))
   totalResults = totalResults + length(result)
   cat(blue("totalResults: ", totalResults, "  "))

   allLinks = c(allLinks, result)
   allLinks = unique(allLinks)
   cat(white("allLinks: ", length(allLinks), "\n"))
 
  # if(length(allLinks)>=totalVideos){break}

   if((typeName==4) && (length(result)<30)){break}  # channel break

   if(i == 10){
     ProcessEndTime = Sys.time()
     LoopTime = as.numeric(ProcessEndTime - ProcessStartTime, units="secs")
     ecTime = totalPages*LoopTime/10

     cat(red(
        "\n\n Expect to complete at: ", as.character(ProcessStartTime + ecTime),"\n",
        "per cycle time: ", dhms(LoopTime/10),"\n",
        "Expected total time: ", dhms(ecTime),"\n\n"
     ))
   }
}

templateHead = readLines("templateHeadNudexxx.txt")
templateTail = readLines("templateTailNudexxx.txt")
templateHead = gsub("all-over-30", titleName, templateHead)

cat(red("length(allLinks) before unique: ",length(allLinks), "\n"))
allLinks = unique(allLinks)
cat(green("length(allLinks) after unique: ",length(allLinks), "\n"))
allLinks = sort(allLinks)

setwd("C:/Users/User/Pictures/sexpage/nudexxx/")

sink(theFilename)
cat(templateHead, sep="\n")
cat(allLinks, sep="\n")
cat(templateTail, sep="\n")
sink()

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Task completed! loop time: ", dhms(LoopTime),"\n\n\n")
cat(theFilename, "created\n")
