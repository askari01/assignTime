
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
    
    // create defaults
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        folder.text = defaults.string(forKey: "path")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
