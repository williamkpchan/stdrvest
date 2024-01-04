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

batchFIle = readLines("a.txt")

for(k in batchFIle){
    cat(k, "\n")
    targetFileName = paste0("xhamster ", k, ".html")
    pagesource <- readLines(targetFileName)
    pagesource = gsub("xhamsterBatch", k, pagesource)
    pagesource = gsub(" - Copy", "", pagesource)
      sink(targetFileName)
        cat(pagesource, sep="\n")
      sink()
}
cat(red("Job completed!\n"))
