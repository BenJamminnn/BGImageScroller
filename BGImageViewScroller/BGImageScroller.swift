//
//  BGImageScroller.swift
//  BGImageScroller
//
//  Created by Mac Admin on 9/8/15.
//  Copyright (c) 2015 BG. All rights reserved.
//

import UIKit

protocol hasSelectedDeleteDelegate : class {
    func hasDeletedImageView(imageView: BGImageView)
}

//Must have cancel image asset for delete function to work

class BGImageView : UIImageView {
    
    weak var delegate: hasSelectedDeleteDelegate?
    
    private let cancelImageName: String = "Cancel"
    private var cancelImage: UIImageView?
    private var imageWidth: CGFloat?
    
    override init(frame: CGRect) {
        self.imageWidth = frame.size.width
        
        super.init(frame: frame)
        
        addCancelImage()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.imageWidth = self.frame.size.width
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInView(self)
        
        if CGRectContainsPoint(cancelImage!.frame, location) {
            delegate?.hasDeletedImageView(self)
        }
    }
    
    private func addCancelImage() {
        let cancelImageView = UIImageView(image: UIImage(named: cancelImageName))
        let size = CGSize(width: frame.width/6, height: frame.height/6)
        let origin = CGPoint(x: frame.width - size.width, y: frame.height - size.height)
        cancelImageView.frame = CGRect(origin: origin, size: size)
        cancelImageView.alpha = 0.5
        cancelImage = cancelImageView
        addSubview(cancelImageView)
    }
}


public class BGImageScroller: UIView, UIScrollViewDelegate, hasSelectedDeleteDelegate {
    
    private var scrollView: UIScrollView!
    private var images: NSMutableArray!
    private var imageViews: NSMutableArray!
    
    //MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.images = NSMutableArray()
        setUp()
    }
    
    required public init(images: NSArray, frame: CGRect) {
        super.init(frame: frame)
        self.images = NSMutableArray(array: images)
        setUp()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Convenience
    
    private func setUp() {
        self.imageViews = NSMutableArray()
        self.backgroundColor = UIColor.whiteColor()
        self.setupScrollView()
        
        if images.count > 0 {
            addImageViews()
        }
    }
    
    private func setupScrollView() {
        self.scrollView = UIScrollView(frame: bounds)
        self.scrollView.scrollEnabled = true
        self.scrollView.maximumZoomScale = 1.0
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = true
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        self.addSubview(self.scrollView)
    }
    
    private func adjustImageViewTags() {
        if imageViews.count == 0 {
            return
        }
        
        for i in 0...self.imageViews.count - 1 {
            var imageView = self.imageViews[i] as! BGImageView
            imageView.tag = i
        }
    }
    
    private func addImageViews() {
        for image in self.images {
            addImage(image as! UIImage)
        }
    }
    
    //MARK: Public API
    
    public func removeAllImages() {
        if imageViews.count == 0 {
            return
        }
        
        for i in 0..<imageViews.count {
            removeImageAtIndex(i)
        }
    }
    
    public func removeImageAtIndex(index: Int) {
        
        if index > imageViews.count - 1 {
            println("Attempting to access out of bounds image")
            return
        }
        
        var hasFoundPhoto = false
        
        for i in 0..<imageViews.count {
            let imageView = (hasFoundPhoto) ? imageViews[i - 1] as! BGImageView : imageViews[i] as! BGImageView
            
            if hasFoundPhoto {
                let newOrigin = CGPoint(x: imageView.frame.origin.x - imageView.imageWidth!, y: 0)
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    imageView.frame = CGRect(origin: newOrigin, size: imageView.frame.size)
                    
                })
            }
            
            if imageView.tag == index { //we've found the imageView to remove
                hasFoundPhoto = true
                imageViews.removeObject(imageView)
                images.removeObject(imageView.image!)
                scrollView.contentSize = CGSize(width: self.frame.width * CGFloat(images.count), height: frame.height)
                imageView.removeFromSuperview()
                
                if imageView.tag == imageViews.count  { //we're the last element, break out of loop
                    break
                }
            }
        }
        
        adjustImageViewTags()
    }
    
    public func addImage(image: UIImage!) {
        self.images.addObject(image)
        let imageCount = self.images.count
        let origin = CGPoint(x: frame.size.width * CGFloat(imageCount - 1), y: 0)
        let imageView = BGImageView(frame:CGRect(origin: origin, size: frame.size))
        imageView.userInteractionEnabled = true
        imageView.contentMode = UIViewContentMode.ScaleToFill
        imageView.image = image
        imageView.delegate = self
        
        self.scrollView.addSubview(imageView)
        
        self.imageViews.addObject(imageView)
        
        let newWidth = Double(frame.width) * Double(imageCount)
        self.scrollView.contentSize = CGSizeMake(CGFloat(newWidth), bounds.height)
        
        adjustImageViewTags()
        
        scrollView.scrollRectToVisible(imageView.frame, animated: true) //scroll to newest imageView
    }
    
    //MARK: EZImage Delegate
    
    internal func hasDeletedImageView(imageView: BGImageView) {
        removeImageAtIndex(imageView.tag)
    }
}