# to collect other pinksmilfs pages, change allAlbumHeader and output
setwd("C:/Users/william/Desktop/scripts/R")
library(rvest)
library(crayon)


# note must end with /
allAlbumHeader = "http://www.pinksmilfs.com/"
# output file name
output = "pinksmilfsPhoto.html"
pageContainer = 1000
lastPageNum = 75

uniqueFlag = FALSE
Selection = readline(prompt=("require to check unique photos? 1/0 "))
if(Selection == "1"){uniqueFlag = TRUE}

cat(green("\n\nStart time:",format(Sys.time(), "%H:%M:%OS"), "\n"))
now_time <- unclass(as.POSIXlt(Sys.time()))
startTime <- now_time[3]$hour*60 + now_time[2]$min

allAlbumList = character()
allLinkList = character()
allPhotoList = character()

# support functions
# =================

# retrieveFile
  retrieveFile <- function(urlAddr){
    retryCounter = 1
    cat("retrieving urlAddr: ", urlAddr, "\n") 
    while(retryCounter < 5) {
      cat("...try ",retryCounter) 
      retriveFile <- tryCatch(read_html(urlAddr, warn=F, encoding = "UTF-8"), 
                        warning = function(w){
                         cat("code param error ");
                         return("code param error")
                        }, 
                        error = function(e) {
                          if(grepl("Error in open.connection", e)){
                            cat("Error in open.connection ")
                            return("Error in open.connection")
                          }else if(grepl("Error in doc_parse_raw", e)){
                            cat("Error in open.connection ")
                            return(read_html(urlAddr, warn=F))
                          }else{
                            cat("code param error ")
                            return("code param error")
                          }
                        }
                     )
      if (grepl("code param error", retriveFile)) {
        cat("Error in connection, try 5 secs later!\n")
        retryCounter <- retryCounter + 1
        retriveFile = ""  # if end of loop this will be returned
      }else if(grepl("Error in open.connection", retriveFile)){
        cat("unable to connect!\n")
        urlAddr = "http://news.rthk.hk/rthk/ch/latest-news.htm" # unable to connect, so use phantom url to bypass
        # return("")
      }else{
        retryCounter = 200  # to jump out of loop
      }
    }
    return(retriveFile)
  }

# collect imgs, all results stay in allPhotoList
collectImgs <- function(links){
    linkIndex = 0
    for (page in links){
      linkIndex = linkIndex + 1

      now_time <- unclass(as.POSIXlt(Sys.time()))
      collectStartTime <- now_time[3]$hour*3600 + now_time[2]$min*60 + now_time[1]$sec 

      cat(magenta("\ncollect image cabinet", linkIndex), "of", length(links), "\n")
      #cat(".. pageURL: ", page, "\n")

      pagesource <- retrieveFile(page)
      photoList <- html_nodes(pagesource, className)
      photoList <- as.character(photoList)

      cat(yellow("\nfound num of imgs:", length(photoList), "\n"))
       if(length(photoList)>0){
             allPhotoList <<- c(allPhotoList, photoList)
             cat("number of all collected imgs: ", blue(length(allPhotoList), " "))
             if(uniqueFlag == TRUE){
               allPhotoList <<- unique(allPhotoList)
               cat(green("unique number of all collected imgs: ", length(allPhotoList), " "))
             }
       }else{ cat(yellow("no imgs ")) }

       now_time <- unclass(as.POSIXlt(Sys.time()))
       collectEndTime <- now_time[3]$hour*3600 + now_time[2]$min*60 + now_time[1]$sec 
       timdDiff = collectEndTime - collectStartTime
       cat(green(" time lapse:", format2digit(timdDiff), "secs\n"))
    }

}

# collect links inside page and call collectImgs
collectLinks <- function(allPageHeader){
    linkIndex = 0
    allLinkLen = length(allPageHeader)
    for (urlAddr in allPageHeader){
      linkIndex = linkIndex + 1
      cat(magenta("\ncollect link info...", linkIndex, "of", allLinkLen, "\nurlAddr: ", urlAddr, "\n"))
      pagesource <- retrieveFile(urlAddr)
      className = ".below-pageform small"
      keywordList <- html_nodes(pagesource, className)
      links <- as.character(keywordList[1])

      if(length(links) != 0){
        lastLineNum = gsub("<small>of ", "", links)
        lastLineNum = gsub("</small>", "", lastLineNum)
        lastLineNum = as.numeric(lastLineNum)

        links = urlAddr
        for(num in 2:lastLineNum){
          newlinks = paste0(urlAddr, "page/",num)
          links = c(links, newlinks)
        }
      }else{
        links = urlAddr
      }

      cat("\n\nfound links: ",links, sep="\n")
      allLinkList <<- c(allLinkList, links)
      cat(red("total links: ", length(allLinkList), "\n"))
    }
}

# collect albums, all results stay in allAlbumList
collectAlbums <- function(links){
    for (page in links){
      cat(cyan("\nalbumURL: ", page, "\n"))
      pagesource <- retrieveFile(page)
      className = ".thumbBlock a"
      keywordList <- html_nodes(pagesource, className)
      albumList <- as.character(html_attr(keywordList, "href"))
      cat(blue("found albumList: ", length(albumList), "  "))
      allAlbumList <<- c(allAlbumList, albumList)
    }
    cat(red("total allAlbumList: ", length(allAlbumList),"\n"))
}

# format2digit
format2digit  = function(value){ sprintf(value, fmt = '%#.2f')}

# support function end
# ====================

# prepare all url
allLinkList = allAlbumHeader
if(lastPageNum>1){
    for(num in 2:lastPageNum){
        newlinks = paste0(allAlbumHeader, "page/",num)
        allLinkList = c(allLinkList, newlinks)
    }
}

albumIndex = 0
for(thelink in allLinkList){
   albumIndex = albumIndex + 1
   cat(blue("\ncollect album page URL: ", albumIndex, "of", length(allLinkList)))
   collectAlbums(thelink)
} # get all albums links

# the albums links are incomplete
allAlbumList = paste0(
   substr(allAlbumHeader,1,nchar(allAlbumHeader)-1), allAlbumList)

#allPageHeader = allAlbumList
allLinkList = character() # reset allLinkList

className = ".thumbBlock img"
collectImgs(allAlbumList) # collect images page

allPhotoList = gsub(
  '<img src="', '<img class="lazy" data-src="http://www.pinksmilfs.com', allPhotoList)
allPhotoList = gsub(' alt=".*', '>', allPhotoList)
allPhotoList = gsub('/pthumbs/', '/full/', allPhotoList)

#allPhotoList = paste0(allPhotoList, '">')


htmlHead = c('<base target="_blank"><html><head><title>pinkPhoto</title>\n',
  '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">\n',
  '<meta name="viewport" content="width=device-width, initial-scale=1" />\n',
  '<link rel="stylesheet" href="https://williamkpchan.github.io/maincss.css">\n',
  '<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.js"></script>\n',
  '<script src="https://williamkpchan.github.io/lazyload.min.js"></script>\n',
  '<script type="text/javascript" src="https://williamkpchan.github.io/mainscript.js"></script>\n',
  '<script src="D:/Dropbox/Public/commonfunctions.js"></script>\n',
  '<script src="https://d3js.org/d3.v4.min.js"></script>\n',
  '<script>\n',
  '  var showTopicNumber = true;\n',
  '  var bookid = "pinkPhoto"\n',
  '  var markerName = "img"\n',
  '</script>\n',
  '<style>\n',
  'body{width:100%;margin-left: 0%; font-size:22px;}\n',
  'h1, h2 {color: gold;}\n',
  'strong {color: orange;}\n',
  'pre{width:100%;}\n',
  '</style></head><body onkeypress="chkKey()"><center>\n',
  '<div id="toc"></div>\n',
  '<pre>\n'
)

htmlTail = c('<script src="https://williamkpchan.github.io/LibDocs/readbook.js"></script>\n',
  '<script>var lazyLoadInstance= new LazyLoad({elements_selector:".lazy"});$("img").click(function() { window.open(this.src)})</script>\n',
  '</pre></body></html>\n')

page = 0
while(length(allPhotoList) > 0){
	page = page + 1
     cat("\nallPhotoList num: ",length(allPhotoList), "\n")
	cat(blue("\npage num: ",page, "\n"))
	if(length(allPhotoList) > pageContainer){
		thispage = allPhotoList[1:pageContainer]
		allPhotoList = allPhotoList[-(1:pageContainer)]
		sink(paste0(output, " P ",page, ".html"))
	       cat(htmlHead)
	       cat(thispage, sep="\n")
	       cat(htmlTail)
		sink()
          cat("after saving, allPhotoList num: ",length(allPhotoList), "\n")
	}else{
		thispage = allPhotoList
		allPhotoList = allPhotoList[-(1:length(allPhotoList))]
		sink(paste0(output, " P ",page, ".html"))
	       cat(htmlHead)
	       cat(thispage, sep="\n")
	       cat(htmlTail)
		sink()
	}
}

cat(red("Job completed!\n"))

cat(green("end time:",format(Sys.time(), "%H:%M:%OS"), "\n"))
now_time <- unclass(as.POSIXlt(Sys.time()))
endTime <- now_time[3]$hour*60 + now_time[2]$min
timdDiff = endTime - startTime
cat(yellow("time lapse:",timdDiff, "minutes\n"))
