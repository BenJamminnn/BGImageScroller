//
//  OpenNewIssueViewController.swift
//  EZMaint
//
//  Created by Mac Admin on 9/3/15.
//  Copyright (c) 2015 EZM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var pickerController: UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        
        return picker
    }
    
    var scroller: BGImageScroller?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        scroller = imageScroller()
        view.addSubview(scroller!)
        
        addUploadImageButton()
    }
    
    func imageScroller() -> BGImageScroller {
        let width = view.frame.width - 50
        
        let size = CGSize(width: width, height: view.frame.size.height/3)
        
        let origin = CGPoint(x: view.center.x - size.width/2, y: 100)
        let frame = CGRect(origin: origin, size: size)
        let imageScroller = BGImageScroller(images:[] , frame: frame)
        return imageScroller
    }
    
    func addUploadImageButton() {
        let size = CGSize(width: 50, height: 50)
        let originY = CGRectGetMaxY(scroller!.frame) + 20
        let originX = view.center.x - size.width/2
        let origin = CGPoint(x: originX, y: originY)
        
        let button = UIButton(frame: CGRect(origin: origin, size: size))
        button.setImage(UIImage(named: "CameraImage"), forState: UIControlState.Normal)
        button.addTarget(self, action: Selector("presentPhotoPicker:"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
    }
    
    func presentPhotoPicker(sender: AnyObject) {
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        scroller?.addImage(image)
        dismissViewControllerAnimated(true, completion: nil)
    }
}
