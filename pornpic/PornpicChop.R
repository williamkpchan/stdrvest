# this interpret the cmdFile and clean the target file
rm(list = ls())

# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
setwd("C:/Users/User/Pictures/sexpage/pornpic/")
#setwd("C:/Users/william/Desktop/scripts/pornpics")

#library(audio)
library(rvest)
library(crayon)
 ligSilver <- make_style("#889988")

# ask for cmdFileName
choosefile = file.choose("select command file")
path = dirname(choosefile)

# read both files
cmdFile = readLines(choosefile)

targetFileName = paste0(path,"/",cmdFile[1])  # first line is the target gile
targetFile = readLines(targetFileName)
emptyIdx = grep("^$", targetFile)
targetFile = targetFile[-emptyIdx] # remove empty lines

#### cleanup cmds
cmdFile = cmdFile[-1]
cmdFile = gsub('https://cdni.pornpics.com/1280/', '', cmdFile)
cmdFile = gsub('.jpg', '', cmdFile)

allLines = 1:length(cmdFile)
oddNum <- function(x) subset(x, x %% 2 == 1)
oddLines = allLines[oddNum(allLines)]
imgLines = cmdFile[oddLines]
cmdLines = cmdFile[-oddLines]

# run the rest loop
startLine = 0
for(i in 1:length(imgLines)){
  # find the first line idx
  mark = imgLines[i]
  cat("\n",mark,": ")
  markIdx = grep(mark, targetFile)
  action = cmdLines[i]

  if(action == "+"){
    startLine = markIdx
    cat("startLine: ", startLine, " ")
  }else{
    endLine = markIdx
    if(startLine == 0){ # first line is last line
      startLine = endLine
    }

    cat("startLine: ", startLine, " ")
    cat("endLine: ", endLine, "")
    if(startLine <endLine){  # make sure endLine> startLine
      for(k in startLine:endLine){
        targetFile[k] = ""
      }
    }
    startLine = 0
  }
}
outFilename = paste0(targetFileName, " cleaned.txt")
sink(outFilename)
  cat(targetFile, sep="\n")
sink()
cat(red("\n",outFilename, " created!\n"))
####

file.rename(choosefile, paste0(choosefile, "0"))
cat(yellow(choosefile, "was renamed\n"))
