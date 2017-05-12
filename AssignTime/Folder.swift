
//
//  Folder.swift
//  AssignTime
//
//  Created by Syed Askari on 12/05/2017.
//  Copyright © 2017 Okorana. All rights reserved.
//

import UIKit

class Folder: UIViewController {

    @IBOutlet weak var folder: UITextView!
    @IBOutlet weak var directory: UITextField!
    
    // create defaults
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        folder.text = defaults.string(forKey: "path")
        directory.layer.cornerRadius = 7
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Folder.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        // keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createFolder(_ sender: Any) {
        let fm = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(directory.text!)
        
        if !fm.fileExists(atPath: path) {
            try! fm.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            defaults.set(path, forKey: "path")
        } else {
            defaults.set(path, forKey: "path")
            print ("Already created directory")
            //            try! fm.removeItem(atPath: path)
        }
        defaults.set(directory.text!, forKey: "name")
        folder.text = defaults.string(forKey: "path")
        directory.text = ""
        dismissKeyboard()
    }

    @IBAction func deleteFolder(_ sender: Any) {
        directory.text = ""
        let fileManager = FileManager.default
        let paths = defaults.string(forKey: "path")!
        if fileManager.fileExists(atPath: paths){
            try! fileManager.removeItem(atPath: paths)
            print ("deleted")
        }else{
            print("Something went wrong.")
        }
        folder.text = "customDir"
        defaults.set("customDir", forKey: "path")
        defaults.set("customDir", forKey: "name")
        dismissKeyboard()
    }
    
    // Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // For Keyboard
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
