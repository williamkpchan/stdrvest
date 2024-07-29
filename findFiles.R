rm(list = ls())

library(crayon)
  ligSilver <- make_style("#889988")
  lime <- make_style("#10ff10")
  purple <- make_style("#9400D3")
  deeppink <- make_style("#FF1493")
  darkgreen <- make_style("#004000")
  magenta  <- make_style("#800080")
  orange  <- make_style("#E6971E")
  pink  <- make_style("#FFB6C1")
  brown  <- make_style("#DF7E43")
  gray  <- make_style("#8F8F8F")
  cyan  <- make_style("#42A783")
  puzzle  <- make_style("#CFCE90")
  paleYel  <- make_style("#E7D9A5")

# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
#basedir = "C:/Users/william/Desktop/scripts"
basedir = "C:/Users/User/Pictures/sexpage/"
setwd(basedir)

#library(audio)
library(rvest)
library(crayon)
 ligSilver <- make_style("#889988")

cat(yellow("look for files\n"))

filename = "."
while(filename!=""){
  filename = readline("Enter keyword:")
  if(filename ==""){break}
  setwd(basedir)

  dirlist = c(
'archivegalleries', 'czechcasting', 'freematuresgallery', 'historyFiles', 'movies', 'nudexxx', 'pictoa', 'pinkfineart', 'pohub', 'pornpic', 'sexhd', 'xham', 'xvideo', 'youx'
)

  dirlist = paste0(basedir, dirlist)
  
  for(dir in dirlist){
    setwd(dir)
    filelist = list.files()
    targetIdx = grep(filename, filelist, ignore.case = TRUE)
        if(length(targetIdx)>0){
          cat(yellow("\n", dir,"\n"))
          cat(filelist[targetIdx], sep="\n")
        }
  }
}
