# this interpret the cmdFile and clean the target file
rm(list = ls())

# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
#setwd("C:/Users/User/Pictures/sexpage/pornpic/")
setwd("C:/Users/User/Pictures/sexpage/pornpic")

#library(audio)
library(rvest)
library(crayon)
 ligSilver <- make_style("#889988")

# ask for cmdFileName
cmdFileName = ""
cmdFileName = readline(prompt="enter cmdFile short name:")
if(cmdFileName ==""){ break}
#cmdFileName ="cmdseq"
cmdFileName = paste0(cmdFileName, ".txt")
# choose.files(default = "", caption = "Select cmdFile")

# read both files
cmdFile = readLines(cmdFileName)
targetFileName = cmdFile[1]  # first line is the target gile
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

file.rename(cmdFileName, paste0(cmdFileName, "0"))
cat(yellow(cmdFileName, "was renamed\n"))
