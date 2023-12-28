# this download cannot download full page and reason unknown

# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
setwd("C:/Users/User/Pictures/sexpage")

library(rvest)

pageHeader="https://www.sexhd.pics/gallery/"
pageTail="/"

wholePage = character()
theFilename = "sexhd.picsBig.html"

className = "div.relativetop a"

addr = readLines("sexhd.picsTOC.html")

lentocpage = length(addr)
cat("\nlentocpage: ",lentocpage,"\n")

ProcessStartTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")

for(i in 1:length(addr)){
 cat(i, "/", length(addr), " ")

 url = paste0(pageHeader,addr[i],pageTail)
 cat(url, "\n")
 pagesource <- read_html(url)

 itemList <- html_nodes(pagesource, className)

 itemList = html_attr(itemList, 'href')
 itemList = as.character(itemList)

 wholePage = c(wholePage, itemList)
}

sink(theFilename)
cat(wholePage)
sink()

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Task completed! loop time: ",LoopTime,"\n\n\n")

# https://sexhd.pics/gallery/angelina-stoli-jenner
# https://sexhd.pics/gallery/antea-iveta
# https://sexhd.pics/gallery/babygotboobs
# https://sexhd.pics/gallery/babygotboobs/rachel-roxxx/year-ass-fucking-xxx-sex
# https://sexhd.pics/gallery/cathy-heaven-clarke-kent
# https://sexhd.pics/gallery/chlo
# https://sexhd.pics/gallery/christina-carter-vendetta
# https://sexhd.pics/gallery/daringsex
# https://sexhd.pics/gallery/daringsex/cathy-heaven-clarke-kent/pornpicturicom-stockings-sexnude
# https://sexhd.pics/gallery/ddfbusty
# https://sexhd.pics/gallery/ddfbusty/chlo/clips-threesome-doll-pornex
# https://sexhd.pics/gallery/erroticaarchives
# https://sexhd.pics/gallery/erroticaarchives/antea-iveta/superb-babe-bluefilm-sex
# https://sexhd.pics/gallery/evilangel
# https://sexhd.pics/gallery/evilangel/stacy-bloom-yanick-shaft/skinny-ass-fucking-sexo-vids
# https://sexhd.pics/gallery/famedigital
# https://sexhd.pics/gallery/famedigital/angelina-stoli-jenner/ppoto-milf-sexx-hapy
# https://sexhd.pics/gallery/gloryholeinitiations
# https://sexhd.pics/gallery/gloryholeinitiations/megan-pryce/pornfidelity-ebony-allsw-pega1
# https://sexhd.pics/gallery/hungarianhoneys
# https://sexhd.pics/gallery/hungarianhoneys/ilona/freak-european-faces
# https://sexhd.pics/gallery/ilona
# https://sexhd.pics/gallery/inna
# https://sexhd.pics/gallery/megan-pryce
# https://sexhd.pics/gallery/metart
# https://sexhd.pics/gallery/metart/nana/gifs-nude-model-boobpedia
# https://sexhd.pics/gallery/mplstudios
# https://sexhd.pics/gallery/mplstudios-model
# https://sexhd.pics/gallery/mplstudios/mplstudios-model/ms-asshole-sexstar
# https://sexhd.pics/gallery/nana
# https://sexhd.pics/gallery/nicki-blue
# https://sexhd.pics/gallery/nickiblue
# https://sexhd.pics/gallery/nickiblue/nicki-blue/jamey-redhead-sexy-nue
# https://sexhd.pics/gallery/rachel-roxxx
# https://sexhd.pics/gallery/stacy-bloom-yanick-shaft
# https://sexhd.pics/gallery/theartporn
# https://sexhd.pics/gallery/theartporn/inna/uncensored-brunette-adorable
# https://sexhd.pics/gallery/ultimatesurrender
# https://sexhd.pics/gallery/ultimatesurrender/christina-carter-vendetta/fantasy-brunette-sexo-porn
