#nav
#<a title=" xxx" href="/xxx/atkgalleria"><i class="far fa-arrow-alt-circle-left"></i></a> <b>1</b> 
#<a title=" xxx 10" href="/xxx/atkgalleria/10">10</a> 
#<a title=" xxx 11" href="/xxx/atkgalleria/11">11</a> 
#<a title=" xxx" href="/xxx/atkgalleria/41">
#<i class="far fa-arrow-alt-circle-right"></i></a>

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

# collections of sites, change it
pageHeader="https://pornpics.photo/xxx/"
#pageTail="/"
pageTail=""
className = "li a" # pornpic

titleName = readline(prompt="enter titleName: ")
totalPages= readline(prompt="enter total pages: ") # total pages on top of pages
#titleName ="labia" 34pages
#Anilos 197
theFilename = paste0("pornpics.photo.", titleName, "Links.html")
wholePage = character()


addr = 1:totalPages

lentocpage = length(addr)
cat("\nlentocpage: ",lentocpage,"\n")

ProcessStartTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")

finishBeep <- function(rptCnt){ # beep count
    while(rptCnt>0){
        play(sin(1:6000/10))
        Sys.sleep(0.2)
     rptCnt = rptCnt-1
    }
}

dhms <- function(t){
    paste(t %/% (60*60*24), "day" 
         ,paste(formatC(t %/% (60*60) %% 24, width = 2, format = "d", flag = "0")
               ,formatC(t %/% 60 %% 60, width = 2, format = "d", flag = "0")
               ,formatC(t %% 60, width = 2, format = "d", flag = "0")
               ,sep = ":"
               )
         )
}

for(i in 1:length(addr)){
 cat(i, "/", length(addr), " ")
 #guess_encoding(pagesource)
 #pagesource <- read_html(paste0(pageHeader,addr[i],pageTail), encoding = "UTF-8")
 #url = paste0(pageHeader,addr[i],pageTail)

 url = paste0(pageHeader, titleName, "/",addr[i],pageTail)
 #url = paste0(pageHeader,addr[i],pageTail)
 cat(url, "\n")
 pagesource <- read_html(url)

 itemList <- html_nodes(pagesource, className)
 itemList = as.character(itemList)
 itemListIdx = grep(" title=", itemList)
 itemList = itemList[itemListIdx]
 itemList = gsub(' title=".*?"| alt=".*?"', '', itemList)
 itemList = gsub('href="', 'href="https://pornpics.photo/', itemList)
 itemList = gsub(' src="', ' class="lazy" data-src="https:', itemList)

 wholePage = c(wholePage, itemList)

 if(i == 10){
   ProcessEndTime = Sys.time()
   LoopTime = as.numeric(ProcessEndTime - ProcessStartTime, units="secs")
   ecTime = length(addr)*LoopTime/10

   cat(red(
        "\n\n Expect to complete at: ", as.character(ProcessStartTime + ecTime),"\n",
        "per cycle time: ", dhms(LoopTime/10),"\n",
        "Expected total time: ", dhms(ecTime),"\n\n"
      ))
 }
}

#writeClipboard(wholePage)
templateHead = readLines("templateHead.txt")
templateTail = readLines("templateTail.txt")
templateHead = gsub("mom50", titleName, templateHead)

sink(theFilename)
cat(templateHead, sep="\n")
cat(wholePage, sep="\n")
cat(templateTail, sep="\n")
sink()

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Task completed! loop time: ", dhms(LoopTime),"\n\n\n")
cat(theFilename, "created\n")
#finishBeep(1)
