//
//  Images.swift
//  AssignTime
//
//  Created by Syed Askari on 08/05/2017.
//  Copyright © 2017 Okorana. All rights reserved.
//

import UIKit

class Images: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var emptyLogo: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    // create defaults
    let defaults = UserDefaults.standard
    var refreshControl: UIRefreshControl!
    
    // path to pics
    var pics = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        
        // for table pull down to refresh
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        table.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject) {
        //  your code to refresh tableView
        table.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh(sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Get Count
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString)
        if fileManager.fileExists(atPath: imagePAth as String){
//            let dirContents = try? fileManager.contentsOfDirectory(atPath: imagePAth as String).first?.appending("customDir")
            let path = defaults.string(forKey: "path")!
            let dirContents = try? fileManager.contentsOfDirectory(atPath: path as String)
            let count = dirContents?.count
            
            // check for empty folder
            emptyCheck(count: count!)
            
            return count!
            
        }else{
            print("No Image")
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return screenWidth - 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "ImageCell")
        cell?.imageView?.image = getImage(index: indexPath.row)
        return cell!
    }
    
    // Edit Row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Delete the cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            // calling delete
            deleteFile(index: indexPath.row)
            print (indexPath.row)
            self.table.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)!
        let image = currentCell.imageView?.image
        shareImage(image!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Get Directory Path
    
    func getDirectoryPath() -> String {
        let paths = defaults.string(forKey: "path")!

//        let documentsDirectory = paths[0]
        return paths
    }
    
    // Get Image
    
    func getImage(index: Int) -> UIImage {
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString)
        if fileManager.fileExists(atPath: imagePAth as String){
            let dirContents = try? fileManager.contentsOfDirectory(atPath: imagePAth as String)
            let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent((dirContents?[index])!)
            if fileManager.fileExists(atPath: imagePAth){
                print("index\(index): ",imagePAth)
                pics.insert(imagePAth, at: index)
                return UIImage(contentsOfFile: imagePAth)!
            }else{
                print("No Image")
            }
        }
        return UIImage(named: "assigntime")!
    }

    // delete file
    func deleteFile(index: Int){
        print("index\(index): ",pics[index])
        let fileManager = FileManager.default
        
        let imagePAth = (self.getDirectoryPath() as NSString)
        if fileManager.fileExists(atPath: imagePAth as String){
            let imagePAth = pics[index]
            if fileManager.fileExists(atPath: imagePAth){
                try! fileManager.removeItem(atPath: imagePAth)
                print ("deleted")
                refresh(sender: self)
            }else{
                print("Something went wrong.")
            }
        }
    }
    
    // share Image
    func shareImage(_ image: UIImage) {
        
        // image to share
//        let image = UIImage(named: "Image")
        
        // set up activity view controller
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // show table & hide
    func emptyCheck(count: Int) {
        if count > 0 {
            // show table
            // show empty view
            emptyLogo.isHidden = true
            emptyLabel.isHidden = true
            table.isHidden = false
        } else {
            // show empty view
            emptyLogo.isHidden = false
            emptyLabel.isHidden = false
            table.isHidden = true
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
