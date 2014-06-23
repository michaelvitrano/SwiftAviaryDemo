//
//  AviaryDemoViewController.swift
//  SwiftAviaryDemo
//
//  Created by Michael Vitrano on 6/22/14.
//  Copyright (c) 2014 Vitrano. All rights reserved.
//

import UIKit

let AviaryDemoControllerImageMargin = 20.0

class AviaryDemoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AFPhotoEditorControllerDelegate {
    var imageView: UIImageView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.29, green: 0.32, blue: 0.38, alpha: 1.0)
        
        imageView = UIImageView()
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.contentMode = .ScaleAspectFit
        view.addSubview(imageView)
        
        let buttonContainerView = UIView()
        buttonContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(buttonContainerView)
        
        let cameraButton = UIButton.buttonWithType(.System) as UIButton
        cameraButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        cameraButton.setTitle("Camera", forState: .Normal)
        cameraButton.titleLabel.font = UIFont.boldSystemFontOfSize(16)
        buttonContainerView.addSubview(cameraButton)
        
        // There should be an [unowned self] here but there is some Swift
        // bug that causes a crash
        cameraButton.on(.TouchUpInside) { _ in
            self.launchImagePickerWithSourceType(.Camera)
        }
        
        let galleryButton = UIButton.buttonWithType(.System) as UIButton
        galleryButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        galleryButton.setTitle("Gallery", forState: .Normal)
        galleryButton.titleLabel.font = UIFont.boldSystemFontOfSize(16)
        buttonContainerView.addSubview(galleryButton)
        
        // The same bug above applies here as well
        galleryButton.on(.TouchUpInside) { _ in
            self.launchImagePickerWithSourceType(.PhotoLibrary)
        }
        
        let bindings = ["imageView" : imageView,
                        "container" : buttonContainerView,
                        "camera"    : cameraButton,
                        "gallery"   : galleryButton,
                        "top"       : topLayoutGuide] as Dictionary<String, UIView>
        
        let metrics =  ["imageMargin" : AviaryDemoControllerImageMargin] as Dictionary<String, Float>
        let formats =  ["V:[top]-(imageMargin)-[imageView]-(imageMargin)-[container]|",
                        "|-(imageMargin)-[imageView]-(imageMargin)-|",
                        "|[container]|",
                        "|[camera(==gallery)]-[gallery]|",
                        "V:|[camera]|",
                        "V:|[gallery]|"]
        
        view.addConstraints(constraintsWithBindings(bindings, metrics: metrics, formats: formats))
    }
    
    func launchImagePickerWithSourceType(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
        let image = info[UIImagePickerControllerOriginalImage] as UIImage
        
        AFPhotoEditorController.setAPIKey("YourAviaryAPIKey", secret: "YourAviarySecret")
        
        let editor = AFPhotoEditorController(image: image)
        editor.delegate = self
        
        dismissViewControllerAnimated(true) {
            self.presentViewController(editor, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func photoEditor(photoEditor: AFPhotoEditorController, finishedWithImage image: UIImage) {
        imageView.image = image
        
        dismissViewControllerAnimated(true) { self.reportImageSize(image) }
    }
    
    func photoEditorCanceled(photoEditor: AFPhotoEditorController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func reportImageSize(image: UIImage) {

        dispatch_async(.PriorityHigh) {
            let data = UIImageJPEGRepresentation(image, 1.0)
            
            dispatch_main_async {
                let sizeString = NSByteCountFormatter.stringFromByteCount(Int64(data.length), countStyle:.File)
                let message = "The image you just edited is \(sizeString) as a JPEG."
                
                let alert = UIAlertController(title: "Hello!", message: message, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
        }

    }
}
