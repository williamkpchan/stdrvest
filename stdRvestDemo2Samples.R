# this download cannot download full page and reason unknown

# this must be added to setting chinese
Sys.setlocale(category = 'LC_ALL', 'Chinese')
#Sys.setlocale(, 'English')  

#options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
setwd("C:/Users/User/Pictures/sexpage")

library(audio)
library(rvest)

pageHeader="https://www.demo2s.com/javascript/"
#pageHeader="https://www.pinkfineart.com/als-angels/page/"
#pageHeader="https://www.pinkfineart.com/mpl-studios/page/"
#pageHeader="https://www.pinkfineart.com/als-angels/"
#pageTail="/"
pageTail=""

wholePage = character()
theFilename = "demo2sHtmlSamples.html"
# "list",

# remember to remove &#9;
#addr = 1:20
addr = c(
"css-button-hover-effect-sliding-background.html",
"location-assign-method.html",
"location-reload-method.html",
"location-replace-method.html",
"location-hash-property.html",
"location-host-property.html",
"location-hostname-property.html",
"location-href-property.html",
"location-origin-property.html",
"location-pathname-property.html",
"location-port-property.html",
"location-protocol-property.html",
"location-search-property.html",
"navigator-appcodename-property.html",
"navigator-appname-property.html",
"navigator-appversion-property.html",
"navigator-cookieenabled-property.html",
"navigator-geolocation-property.html",
"navigator-language-property.html",
"navigator-online-property.html",
"navigator-platform-property.html",
"navigator-product-property.html",
"navigator-useragent-property.html",
"navigator-javaenabled-method.html",
"navigator-taintenabled-method.html",
"screen-availwidth-property.html",
"screen-colordepth-property.html",
"screen-height-property.html",
"screen-pixeldepth-property.html",
"screen-width-property.html",
"html-getting-started-with-the-canvas-element-demo-cdc89.htm",
"html-getting-a-canvas-context-demo-b3059.htm",
"html-canvas-2d-rendering-context-demo-47463.htm",
"html-canvas-coordinate-system-demo-ed6fb.htm",
"html-canvas-drawing-rectangles-demo-5c7d5.htm",
"html-canvas-drawing-rectangles-demo-3d666.htm",
"html-setting-the-canvas-drawing-state-demo-42400.htm",
"html-setting-the-canvas-drawing-state-demo-311e6.htm",
"html-canvas-using-gradients-demo-a210f.htm",
"html-canvas-using-gradients-demo-11db2.htm",
"html-canvas-using-gradients-demo-8d5e6.htm",
"html-canvas-using-gradients-demo-c22e9.htm",
"html-canvas-using-gradients-demo-63f47.htm",
"html-canvas-using-gradients-demo-782a4.htm",
"html-canvas-using-gradients-demo-25d28.htm",
"html-canvas-using-a-radial-gradient-demo-49dba.htm",
"html-canvas-using-a-radial-gradient-demo-7084d.htm",
"html-canvas-using-patterns-demo-192c2.htm",
"html-canvas-using-patterns-demo-93172.htm",
"html-canvas-saving-and-restoring-drawing-state-demo-7a712.htm",
"html-canvas-saving-and-restoring-drawing-state-demo-48c9a.htm",
"html-canvas-using-paths-demo-b520d.htm",
"html-canvas-drawing-paths-with-lines-demo-8c206.htm",
"html-canvas-drawing-paths-with-lines-demo-ee50a.htm",
"html-canvas-drawing-lines-demo-5cbe7.htm",
"html-canvas-drawing-lines-demo-96dfd.htm",
"html-canvas-changing-line-width-demo-2b8ce.htm",
"html-canvas-changing-line-width-demo-10399.htm",
"html-canvas-drawing-rectangles-in-path-demo-bedae.htm",
"html-canvas-drawing-rectangles-in-path-demo-84714.htm",
"html-canvas-drawing-arcs-demo-945f2.htm",
"html-canvas-drawing-arcs-demo-01ad9.htm",
"html-canvas-drawing-arcs-demo-866aa.htm",
"html-canvas-drawing-circles-demo-950cf.htm",
"html-canvas-drawing-circles-demo-89ac8.htm",
"html-canvas-bezier-curves-concept-demo-fbb4d.htm",
"html-canvas-bezier-curves-concept-demo-a9cc2.htm",
"html-canvas-drawing-bezier-curves-demo-8e604.htm",
"html-canvas-drawing-bezier-curves-demo-f8871.htm",
"html-canvas-drawing-text-demo-ae5fb.htm",
"html-canvas-drawing-text-demo-5e8d7.htm",
"html-canvas-drawing-text-demo-8b4aa.htm",
"html-canvas-drawing-text-demo-7b37d.htm",
"html-canvas-drawing-text-demo-91908.htm",
"html-canvas-drawing-images-demo-2ebc9.htm",
"html-canvas-using-canvas-images-demo-bdb84.htm",
"html-canvas-exporting-the-canvas-as-an-image-demo-9f4b0.htm",
"html-canvas-loading-an-image-into-canvas-demo-561de.htm",
"html-canvas-loading-an-image-into-canvas-demo-3e68f.htm",
"html-canvas-resizing-images-demo-35710.htm",
"html-canvas-cropping-images-demo-6ca8c.htm",
"html-canvas-transforming-images-demo-4d0a5.htm",
"html-canvas-transforming-images-demo-3887c.htm",
"html-canvas-transforming-images-demo-4889c.htm",
"html-canvas-reverse-the-color-values-of-an-image-demo-4ad17.htm",
"html-canvas-image-grayscale-demo-6d968.htm",
"html-canvas-image-pixelation-demo-c5f25.htm",
"html-canvas-using-video-images-demo-fb7e4.htm",
"html-canvas-using-video-images-demo-70aff.htm",
"html-canvas-manipulating-video-demo-8813c.htm",
"html-canvas-accessing-pixel-values-demo-63fc2.htm",
"html-canvas-accessing-pixel-values-demo-657ff.htm",
"html-canvas-create-an-image-from-scratch-using-pixel-data-demo-c04cb.htm",
"html-canvas-randomizing-pixels-on-image-demo-59d7e.htm",
"html-canvas-creating-a-mosaic-effect-for-image-demo-0df3f.htm",
"html-canvas-coordinate-translation-demo-574b6.htm",
"html-canvas-coordinate-translation-demo-e2421.htm",
"html-canvas-scaling-demo-b584c.htm",
"html-canvas-scaling-demo-e06be.htm",
"html-canvas-scaling-demo-1b850.htm",
"html-canvas-rotation-demo-b6778.htm",
"html-canvas-rotation-demo-9dc1d.htm",
"html-canvas-transformation-matrix-demo-107e7.htm",
"html-canvas-transformation-matrix-demo-dc8b2.htm",
"html-canvas-creating-a-clipping-region-demo-ea5aa.htm",
"html-canvas-using-shadows-demo-756a5.htm",
"html-canvas-using-shadows-demo-b1a12.htm",
"html-canvas-using-shadows-demo-5b1a0.htm",
"html-canvas-using-shadows-demo-2c204.htm",
"html-canvas-using-transparency-demo-d06a0.htm",
"html-canvas-global-alpha-demo-31aa4.htm",
"html-canvas-using-composition-demo-1aee9.htm",
"html-canvas-using-a-transformation-demo-10393.htm",
"html-canvas-change-color-demo-1cedd.htm",
"html-canvas-change-color-demo-613cc.htm",
"html-canvas-change-color-demo-d7eed.htm",
"html-canvas-change-color-demo-a3683.htm",
"html-erasing-the-canvas-demo-e55ca.htm",
"html-erasing-the-canvas-demo-85e20.htm",
"html-erasing-the-canvas-demo-8723c.htm",
"html-canvas-building-an-animation-loop-demo-208b9.htm",
"html-canvas-animation-remembering-shapes-to-draw-demo-51238.htm",
"html-canvas-animating-a-shape-in-a-circular-orbit-demo-f63c7.htm",
"html-canvas-animation-bouncing-objects-off-a-boundary-demo-b94de.htm",
"html-canvas-animating-with-physics-demo-c4e9d.htm",
"html-using-web-storage-demo-25ca8.htm",
"html-listening-for-storage-events-demo-0edc5.htm",
"html-using-session-storage-demo-0b0ed.htm",
"html-using-geolocation-demo-c3fcd.htm",
"html-handling-geolocation-errors-demo-51d2b.htm",
"html-specifying-geolocation-options-demo-26617.htm",
"html-geolocation-monitoring-the-position-demo-daa04.htm",
"html-using-drag-and-drop-demo-32834.htm",
"html-using-drag-and-drop-demo-cf317.htm",
"html-using-drag-and-drop-demo-f13e6.htm",
"html-drag-and-drop-working-with-the-datatransfer-object-demo-9fe3f.htm",
"html-dragging-and-dropping-files-demo-9df79.htm"

)

#className = "#sidebar a" # demo2 sidebar
className = ".col-12, .col-md-9, .col-lg-9" # demo2 detail
#className = "h1, #content"
#className = ".card-link" # pinkfineart links
#className = ".card a" # pinkfineart

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

for(i in 1:length(addr)){
 cat(i, "/", length(addr), " ")
 #guess_encoding(pagesource)
 #pagesource <- read_html(paste0(pageHeader,addr[i],pageTail), encoding = "UTF-8")
 #url = paste0(pageHeader,addr[i],pageTail)
 url = paste0(pageHeader,addr[i],pageTail)
 cat(url, "\n")
 pagesource <- read_html(url)

 itemList <- html_nodes(pagesource, className)

 itemList = as.character(itemList)

 wholePage = c(wholePage, itemList)
}

#writeClipboard(wholePage)
 rmIdx = grep("<script|</script>|adsbygoogle|<button|^\\n|<li><h6|</a></h6></li>|<li><a href", wholePage)
 wholePage = wholePage[-rmIdx]
 wholePage = gsub("<li.*?>|</li>|</ul>|<ul.*?>|<div.*?>|</div>| style=\".*?\"|<p.*?>|</p.*?>|<span.*?>|</span>", "", wholePage)

sink(theFilename)
cat(wholePage)
sink()

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("Task completed! loop time: ",LoopTime,"\n\n\n")
finishBeep(1)
