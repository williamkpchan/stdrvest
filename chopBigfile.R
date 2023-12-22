# chop big file into small files
setwd("C:/Users/User/Pictures/sexpage")
fapHeader = readLines("fapHead.txt")
fapTail = readLines("fapTail.txt")
fapBody = readLines("xhamster faphouse video.html")

filenameHead = "xhamster faphouse "
filenameTail = " video.html"

allLines = length(fapBody)
totalPages = 10
eachPageLines = round(allLines/totalPages)


# the last page will be handled independently
 for(page in 1:(totalPages-1)){
  outputFileName = paste0(filenameHead, page, filenameTail)

  startLine = 1 + (page-1) * eachPageLines
  endLine = page * eachPageLines

  sink(outputFileName)
    cat(fapHeader, sep="\n")
    for(lines in startLine:endLine){
      cat(fapBody[lines], "\n")
    }
    cat(fapTail, sep="\n")
  sink()
 }

# lastly create last page
  outputFileName = paste0(filenameHead, totalPages, filenameTail)
  page = totalPages
  startLine = 1 + (page-1) * eachPageLines
  endLine = allLines

  sink(outputFileName)
    cat(fapHeader, sep="\n")
    for(lines in startLine:endLine){
      cat(fapBody[lines], "\n")
    }
    cat(fapTail, sep="\n")
  sink()

cat("Job completed\n")
