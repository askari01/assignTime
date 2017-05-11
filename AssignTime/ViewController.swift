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
    @IBOutlet weak var notifSwitch: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    
    
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
        
        // image
        picker.delegate = self
        
        // input to timePicker
        pickerData = ["1 Hour", "2 Hours", "4 Hours", "8 Hours", "12 Hours", "24 Hours"]
        
        // switch
        notifSwitch.addTarget(self, action: #selector(switchIsChanged), for: UIControlEvents.valueChanged)
        
        // Directory Creation & Check for Image storage
        let fm = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDir")
        
        if !fm.fileExists(atPath: path) {
            try! fm.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } else {
            print ("Already created directory")
//            try! fm.removeItem(atPath: path)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Switch
    func switchIsChanged(mySwitch: UISwitch) {
        if mySwitch.isOn {
            print("UISwitch is ON")
            timePicker.isHidden = false
            timePicked.text = "1:00"
        } else {
            print("UISwitch is OFF")
            
            // Clear Previous Notifications
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            timePicked.text = "0:00"
            timePicker.isHidden = true
        }
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
        var time: Int = 0
        
        switch row {
        case 0:
            time = 60 * 60
            timePicked.text = "1:00"
            break
        case 1:
            time = 60 * 60 * 2
            timePicked.text = "2:00"
            break
        case 2:
            time = 60 * 60 * 4
            timePicked.text = "4:00"
            break
        case 3:
            time = 60 * 60 * 8
            timePicked.text = "8:00"
            break
        case 4:
            time = 60 * 60 * 12
            timePicked.text = "12:00"
            break
        case 5:
            time = 60 * 60 * 24
            timePicked.text = "24:00"
            break
        default:
            time = 60 * 60
            timePicked.text = "1:00"
            break
        }
        
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Clear Previous Notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Configure Notification Content
        notificationContent.title = "Assign Time"
       
//      notificationContent.subtitle = "Local Notifications"
        notificationContent.body = "Do you want to take a picture ?"
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time), repeats: true)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "assignTime", content: notificationContent, trigger: notificationTrigger)
        
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
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.cameraCaptureMode = .photo
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    // camera
    func takeImage() {
        print("hello take Image")
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
//            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(picker, animated: true, completion: nil)
        } else {
            print ("no camera device found")
            noCamera()
        }
    }
    
    // No Camera
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    // picker handler
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage: UIImage? = info[UIImagePickerControllerEditedImage] as! UIImage?
        UIImageWriteToSavedPhotosAlbum(chosenImage!, self, nil, nil)
        
        // Saving Image to Photos
        saveImageDocumentDirectory(image: chosenImage!)
        // For debugging
//        getImage()
        picker.dismiss(animated: true, completion: nil)
    }
    
    // picker did cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Add image to Library
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func saveImageDocumentDirectory(image: UIImage){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDir/\(Date.init()).jpg")
//        let image = UIImage(named: "apple.jpg")
        print(paths)
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImage(){
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("apple.jpg")
        if fileManager.fileExists(atPath: imagePAth){
            self.imageView.image = UIImage(contentsOfFile: imagePAth)
        }else{
            print("No Image")
        }
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

