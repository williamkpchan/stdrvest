# load all html files to search for text sig

setwd("C:/Users/User/Pictures/sexpage/pornpic")

#schkey = readline(prompt="enter schkey:")
schkey = "https://sexhd.pics/gallery"

allFile = list.files(pattern = "\\.html$")
cat("length(allFile): ", length(allFile),"\n")

Wholepage = character()
for(i in 1:length(allFile)){
  cat("\n",allFile[i], " ")
  tempFile = readLines(allFile[i])
  lengthTempFile = length(tempFile)
  lastLine = lengthTempFile-30
  tempFile = tempFile[-(1:lastLine)]
  idx = grep(schkey, tempFile)
  if(length(idx)>0){
    Wholepage = c(Wholepage, allFile[i])
    cat(length(Wholepage), " ")
  }
}
cat("\ntotal: ",length(Wholepage), "\n")
outFilename = paste0("record.txt")
sink(outFilename)
  cat(Wholepage, sep="\n")
sink()
cat(outFilename, " created!\n")
