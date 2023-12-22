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

toProcessFileName = readline(prompt="enter filename with ext: ")
toProcessFile = readLines(toProcessFileName)

 targetIdx = grep('<div><a href="https://xhamster', toProcessFile)
 cat("Initial length:", length(targetIdx), "\n")

 targetIdxLink = gsub('"><.*', '',toProcessFile[targetIdx])

 duplicatedLink = duplicated(targetIdxLink)
 cat("duplicated length:", length(targetIdx[duplicatedLink]), "\n")

 newFile = toProcessFile[-targetIdx[duplicatedLink]]
 cat("final length:", length(targetIdx) - length(targetIdx[duplicatedLink]), "\n")

theFilename = toProcessFileName

sink(theFilename)
cat(newFile, sep="\n")
sink()

cat("Task completed! \n\n\n")
cat(theFilename, "created\n")
