# statistics on freematuresgalleryLinks.txt
# .com, .ni, .net
library(rvest)
library(crayon)
 ligSilver <- make_style("#889988")

setwd("C:/Users/User/Pictures/sexpage")

fileData = readLines("freematuresgalleryLinks.txt")
cat("length(fileData) ", length(fileData), "\n")

dataIdx = grep("\\.com|\\.ni|\\.net", fileData)
cat("length(dataIdx) ", length(dataIdx), "\n")

targetData = fileData[dataIdx]
cat("length(targetData) ", length(targetData), "\n")

targetData = gsub("^.*?//","",targetData)
targetData = gsub("\\.com.*|\\.ni.*|\\.net.*","",targetData)

targetGrps = unique(targetData)
targetGrps = sort(targetGrps)
# targetGrps = gsub("www\\.|secure\\.|join\\.|affiliates\\.","",targetGrps)
# targetGrps = sort(targetGrps)

cat("length(targetGrps) ", length(targetGrps), "\n")
cat("targetGrps: ", targetGrps, sep="\n")

cntResult = as.numeric()
for(i in targetGrps){
  cnt = grep(i, targetData)
  cat(i, ": length(cnt): ", red(length(cnt)), "\n")
  cntResult = c(cntResult, length(cnt))
}

combinedMat = cbind(targetGrps, cntResult)
combinedMat[order(as.numeric(combinedMat[,2]), decreasing=TRUE),]

