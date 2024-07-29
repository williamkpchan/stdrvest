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


readkey = function(){
	key = ""
	while(is.na(suppressWarnings(as.numeric(key)))){
		key = readline(prompt="Enter your choice: ")
		if(key == "as.raw(27)") {break}
	}

	return(strtoi(key))
}

#AChoice = "C:/Users/user/Desktop"
AChoice = "C:/Users/User/Pictures/sexpage"
setwd(AChoice)
mainMenuDir= "C:/Users/User/Pictures/sexpage"
Select = "a"

Sys.setlocale(category = 'LC_ALL', 'Chinese')	# this must be added to script to show chinese
mainMenuName = "Rsexdir.txt"
mainMenu <- readLines(mainMenuName)

cat("\n\nAvailable R scripts.\n\n")

for(scriptNo in 1:length(mainMenu)){
	remainder = scriptNo %% 4
	if(remainder==0){
		cat(scriptNo, puzzle(mainMenu[scriptNo], "\n"))
	}else if(remainder==1){
		cat(scriptNo, paleYel(mainMenu[scriptNo], "\n"))
	}else if(remainder==2){
		cat(scriptNo, cyan(mainMenu[scriptNo], "\n"))
	}else{
		cat(scriptNo, brown(mainMenu[scriptNo], "\n"))
	}
}

keyin <- length(mainMenu) +1

while(keyin >length(mainMenu) | keyin<1){
	cat("\nSelect the script you want to try: \n")
	keyin <- readkey()
}

cat("\n\nSelected: ", mainMenu[keyin],"\n\n")
theSeleted = mainMenu[keyin]
theSeleted = gsub("\\\\", "/", theSeleted)
theSeleted = gsub("\\t", "", theSeleted)
cat("\n",theSeleted, "\n")
source(theSeleted, encoding = "UTF-8")
