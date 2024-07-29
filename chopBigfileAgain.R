# to chop pornpicskarups+private+collection
setwd("C:/Users/User/Pictures/sexpage")

fileName = "pornpicskarups+private+collection"

toChopFile = readLines(paste0(fileName, ".html"))
fileHead = toChopFile[1:41]
fileTail = toChopFile[555168:length(toChopFile)]

toChopFile = toChopFile[-(555168:length(toChopFile))] # cut tail first
toChopFile = toChopFile[-(1:41)]
sectionLen = round(length(toChopFile) / 8,0)

for(i in 1:8){
  sectionFileName = paste0(fileName, i,".html")

  if(length(toChopFile)< sectionLen){
    sectionLen = length(toChopFile)
  }

  sectionContent = c(fileHead, toChopFile[1:sectionLen], fileTail)
  sink(sectionFileName)
    cat(sectionContent, sep="\n")
  sink()
  toChopFile = toChopFile[-(1:sectionLen)]
}

cat("job completed!")
