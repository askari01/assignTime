//
//  ViewController.swift
//  AssignTime
//
//  Created by Syed Askari on 03/05/2017.
//  Copyright © 2017 Okorana. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var cameraButtonOutlet: UIButton!
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var timePicked: UILabel!
    
    let picker = UIImagePickerController()
    var pickerData: [String] = [String]()
    
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        print("Inside Camera Button Call")
        takeImage()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // time intervals
        timePicker.delegate = self
        timePicker.dataSource = self
        
        // input to timePicker
        pickerData = ["1 Hour", "2 Hours", "4 Hours", "8 Hours", "12 Hours", "24 Hours"]
        
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

    // Picker View
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print (row)
        
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "Assign Time"
        //        notificationContent.subtitle = "Local Notifications"
        notificationContent.body = "Do you want to take a picture ?"
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(row), repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "calllight", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
        
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

