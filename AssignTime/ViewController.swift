//
//  ViewController.swift
//  AssignTime
//
//  Created by Syed Askari on 03/05/2017.
//  Copyright © 2017 Okorana. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    @IBOutlet weak var cameraButtonOutlet: UIButton!
    let picker = UIImagePickerController()
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        print("Inside Camera Button Call")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        picker.dismiss(animated: true, completion: { _ in })
    }
    
    // picker did cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: { _ in })
    }


}

