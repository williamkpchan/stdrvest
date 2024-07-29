# check file exist and modify src addr

setwd("D:/Dropbox/MyDocs/R misc Jobs/ExtractFiles")
#url = readLines("checkFIleExist.txt")  # url addr to be verified
cat("\nread data list from clipboard!!\n\n")
url = readClipboard(raw= F)
cat("Total items: ", length(url), "\n")
url = gsub("564x|474x|236x|736x|140x140_RS", "originals", url)
  # 736x should be check
url = unique(url)

modifyTxt = character()
for (i in url) {
    tmp <- tryCatch(
             readLines(url(i), warn=F), silent = TRUE,
             error = function (e) NULL
           )
    if (is.null(tmp)) {
      cat("\n",paste(i, " doesn't exist"))
      modifyTxt = c(modifyTxt, i)
      next() # skip to the next url.
    }else(cat("."))
}

srcTxt = url
for (i in modifyTxt) {
    targetIdx = grep(i, srcTxt)
    cat("\nnot exist items: ",targetIdx, srcTxt[targetIdx], "\n")
    srcTxt[targetIdx] = gsub("originals", "564x", srcTxt[targetIdx])
}

srcTxt = paste0('\'<img src="', srcTxt, '">\',')

sink("modifyTxt.txt")
  cat(srcTxt, sep="\n")
sink()
shell("modifyTxt.txt")
