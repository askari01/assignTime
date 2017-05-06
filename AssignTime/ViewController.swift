//
//  ViewController.swift
//  AssignTime
//
//  Created by Syed Askari on 03/05/2017.
//  Copyright © 2017 Okorana. All rights reserved.
//

import UIKit

// for image saving in file
//func getDocumentsURL() -> NSURL {
//    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//    return documentsURL as NSURL
//}
//
//func fileInDocumentsDirectory(filename: String) -> String {
//    
//    let fileURL = getDocumentsURL().appendingPathComponent(filename)
//    return fileURL!.path
//    
//}


class ViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    @IBOutlet weak var cameraButtonOutlet: UIButton!
    let picker = UIImagePickerController()
    
//    let myImageName = "image.png"
//    let imagePath = fileInDocumentsDirectory(filename: myImageName)
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        print("Inside Camera Button Call")
        takeImage()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let fm = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDir")
        
        if !fm.fileExists(atPath: path) {
            try! fm.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } else {
            print ("Already created directory")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Camera Call
    
    // library
    func pickImage() {
        print("hello pick Image")
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    // camera
    func takeImage() {
        print("hello take Image")
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    // picker handler
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [AnyHashable: Any]) {
        let chosenImage: UIImage? = info[UIImagePickerControllerEditedImage] as! UIImage?
        UIImageWriteToSavedPhotosAlbum(chosenImage!, self, nil, nil)
        
        let fileManager = FileManager.default
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDir")
        let image = UIImage(named: "apple.jpg")
        print(paths)
        let imageData = UIImageJPEGRepresentation(chosenImage!, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        
        picker.dismiss(animated: true, completion: { _ in })
    }
    
    // picker did cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: { _ in })
    }

    // error occured
    
//    func saveImage (image: UIImage, path: String ) -> Bool{
//        
//        let pngImageData = UIImagePNGRepresentation(image)
//        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
//        let result = pngImageData!.writeToFile(path, atomically: true)
//        
//        return result
//        
//    }
    
//    func loadImageFromPath(path: String) -> UIImage? {
//        
//        let image = UIImage(contentsOfFile: path)
//        
//        if image == nil {
//            
//            print("missing image at: \(path)")
//        }
//        print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
//        return image
//        
//    }

}

