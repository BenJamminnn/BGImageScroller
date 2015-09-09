# BGImageScroller

An image scrolling view

![scrolldemoshort](https://cloud.githubusercontent.com/assets/5061628/9752239/ae2ca364-5662-11e5-97e2-394e21213449.gif)


Very simple and extensible APIs

Instantiate as any `UIView` or with an array of images

```
let frame = ...

let imageScroller = BGImageScroller(frame: frame)
let imageScroller = BGImageScroller(images:[], frame: frame)
```

Add or remove images with 

```
imageScroller.addImage(YourImage)

imageScroller.removeImageAtIndex(YourIndex)
```

