# <div class="logo-container" style="background-image: url(https://pornstar-thumb.xhcdn.com/000/030/505/avatar1.jpg.v1532597344);"></div>
# https://xhamster.com/pornstars/sara-may

Sys.setlocale(category = 'LC_ALL', 'Chinese')	# this must be added to script to show chinese

setwd("D:/Dropbox/MyDocs/R misc Jobs/Extracts by R")

pageHeader="https://xhamster.com/pornstars/"
pageTail=""
keyword = '<div class="logo-container" style="background-image: url('

# head: <p class="large">
# tail: <div class="pager-section">

addr = readLines("xhamStar.txt")

theWholepage = ""
theFilename = "xhamStar.html"

lentocpage = length(addr)
cat("\nlentocpage: ",lentocpage,"\n")
pageHead = '<div class="letter-blocks page">'
pageEnd = '<div class="search">'
theWholepage = ""

breakArticle <- function(thepage, pageHead, pageEnd){
	thepage = gsub(pageHead , paste0('breakey',pageHead), thepage) 
	thepage = gsub(pageEnd , paste0(pageEnd,'breakey'), thepage) 
	thepage = unlist(strsplit(thepage,'breakey'))
	return(thepage)
}

chopHead <- function(thepage, pageHead){
	headlinenum = grep(pageHead, thepage)
	cat(" ", headlinenum)
	return(thepage[-(1:(headlinenum-1))])
}

chopTail <- function(thepage, pageTail){
	taillinenum = grep(pageTail, thepage)  # chop tail
	cat( " ", taillinenum[1], "\n")
	if(length(taillinenum) != 0){
		return(thepage[-((taillinenum[1]+1):length(thepage))])
	} else {
		return("")
	}
}

extractLogo <- function(thepage){
	theLine = thepage[grep('<div class="logo-container" style="background-image', thepage)]
	theLine = gsub('^.*url.', "", theLine)
	theLine = gsub('jpg.*', "jpg", theLine)
	return(theLine)
}
for (page in 1:length(addr)){
	cat(" ", page)
	thepage=readLines(paste0(pageHeader, addr[page], pageTail))

#	thepage=breakArticle(thepage, pageHead, pageEnd)
	thepage = c(addr[page], paste0(pageHeader, addr[page]), extractLogo(thepage))
	theWholepage = c(theWholepage , thepage)
}


sink(theFilename)
cat(theWholepage, sep = "\n")
sink()



