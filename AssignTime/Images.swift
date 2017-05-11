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
    
    var refreshControl: UIRefreshControl!
    
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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Get Count
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString)
        if fileManager.fileExists(atPath: imagePAth as String){
//            let dirContents = try? fileManager.contentsOfDirectory(atPath: imagePAth as String).first?.appending("customDir")
            let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDir")
            let dirContents = try? fileManager.contentsOfDirectory(atPath: path as String)
            let count = dirContents?.count
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
            deleteDirectory()
            self.table.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Get Directory Path
    
    func getDirectoryPath() -> String {
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDir")

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
                return UIImage(contentsOfFile: imagePAth)!
            }else{
                print("No Image")
            }
        }
        return UIImage(named: "assigntime")!
    }

    func deleteDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDir")
        if fileManager.fileExists(atPath: paths){
            try! fileManager.removeItem(atPath: paths)
            print ("deleted")
        }else{
            print("Something went wrong.")
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
