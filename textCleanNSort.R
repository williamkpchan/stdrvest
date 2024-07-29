# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
options("encoding" = "UTF-8")
setwd("C:/Users/User/Pictures/sexpage")

#library(audio)
library(rvest)
library(crayon)
 ligSilver <- make_style("#889988")
# https://www.pornhub.com/channels/dreamgirlsmembers/videos?page=1
# 2269
srcTxt = readLines("pohubFemaleStarList.html")

alterTxtIdx = grep("'/m|'/p", srcTxt)
alterTxt = srcTxt[alterTxtIdx]
grepTxt = gsub("^.*?<br>\\d{1,} ", "", alterTxt)
alterTxt = paste0(grepTxt, alterTxt)
alterTxt = gsub('^-|^"|^#\\d{1,}- |^\\(.*?\\)|^ ', "", alterTxt)
alterTxt = gsub('^#\\d{1,}', "", alterTxt)
alterTxt = gsub('^＃\\d{1,}', "", alterTxt)
alterTxt = gsub('^\\(.*?\\)', "", alterTxt)
alterTxt = gsub('^（.*?）', "", alterTxt)
alterTxt = gsub('^\\?{1,}', "", alterTxt)
alterTxt = gsub('^ {1,}', "", alterTxt)
alterTxt = gsub('^\\[.*?\\] ', "", alterTxt)
alterTxt = gsub('^\\[', "", alterTxt)
alterTxt = gsub('^_', "", alterTxt)
alterTxt = gsub('^「.*?“', "", alterTxt)
alterTxt = gsub('^【.*?】', "", alterTxt)
alterTxt = gsub('^ {1,}', "", alterTxt)
alterTxt = gsub('^<.*?>', "", alterTxt)
alterTxt = gsub('^- {1,}', "", alterTxt)
alterTxt = gsub('^ {1,}', "", alterTxt)
alterTxt = gsub('<U\\+.*?>', "", alterTxt)
alterTxt = gsub('^ {1,}', "", alterTxt)
alterTxt = gsub('^0.*?\'', "'", alterTxt)
alterTxt = sort(alterTxt)
head(alterTxt, 2)

alterTxt = gsub("^','", "'", alterTxt)
tail(alterTxt, 6)
alterTxt = gsub("^.*?','", "'", alterTxt)

sink("pohubFemaleStarList.txt")
cat(alterTxt, sep="\n")
sink()
