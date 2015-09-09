# BGImageScroller

An image scrolling view


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

