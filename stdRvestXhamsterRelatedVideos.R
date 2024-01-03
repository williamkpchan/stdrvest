# this download cannot download full page and reason unknown

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

className = ".page-list-container li"

geturl = readline(prompt="enter url: ")
titleName = readline(prompt="enter titleName: ")
mergeMode = "1"

pageTail=""
pageHeader = geturl
theFilename = paste0("mergeLists.js")

wholePage = character()

# remember to remove &#9;

url = pageHeader

 cat("url:",url, "\n")
  batchFIleHistory = readLines("xhamsterBatchProcessHistory.txt")
  historyIdx = grep(k, batchFIleHistory)
  if(length(historyIdx) !=0){
    stop(red("\nListed in History!: ", k, "\n"))
  }

 pagesource <- read_html(url)
 className = "a.video-thumb__image-container"

 itemList <- html_nodes(pagesource, className)
 links = html_attr(itemList, "href")
 previewvideo = html_attr(itemList, "data-previewvideo")

 images = html_nodes(itemList, "noscript img")
 imgSrc = html_attr(images, "src")
 linksTxt = html_attr(images, "alt")
 linksTxt = paste0(titleName,", " ,linksTxt)

 sprite <- html_nodes(pagesource, "div.thumb-image-container__sprite")
 sprite = html_attr(sprite, "data-sprite")
 spriteTxt = paste0('<br><img src="', sprite, '"><br>')

 videoTxt = paste0('<br><video controls loop autoplay><source src="', previewvideo, '"></video>')

 result = paste0('<div><a href="', links, '"><img src="', imgSrc, '"><br>', linksTxt, '</a>', videoTxt, spriteTxt, '</div>')
 #rmid = grep('Friends only', result)s
 #result = result[-rmid]

 className = "div.xp-preload-image"
 itemImg <- html_nodes(pagesource, className)

 imgLink = html_attr(itemImg, "style")
 imgLink = gsub("^.*?http", "http",imgLink)
 imgLink = gsub("jpg.*", "jpg",imgLink)
 headerLink = paste0("<div><a href=\"", pageHeader, '"><img src="', imgLink, '"><br>', titleName, '</div>')

  wholePage = c(wholePage, headerLink, result)
  wholePage = gsub("'", ".", wholePage)
  wholePage = gsub("<div>", "'", wholePage)
  wholePage = gsub("</div>", "',", wholePage)

  mergeFile = readLines(theFilename)
  mergeFile = mergeFile[-length(mergeFile)]
  mergeFile = c(mergeFile, wholePage, "];")

  sink(theFilename)
  cat(mergeFile, sep="\n")
  sink()

cat(theFilename, "created!", "Total links: ", length(wholePage), "\n")
theFilename = paste0('"',theFilename,'"')
shell("mergeLists.html")

      write(url, file="xhamsterBatchProcessHistory.txt", append=TRUE)
      cat(yellow("\nxhamsterBatchProcessHistory.txt updated!\n"))
