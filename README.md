# BGImageScroller

An image scrolling view

![imagescrollerdemo](https://cloud.githubusercontent.com/assets/5061628/9751825/5106aa80-565e-11e5-9c65-65dbf19e6444.gif)

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

