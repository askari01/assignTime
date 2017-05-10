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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString)
        if fileManager.fileExists(atPath: imagePAth as String){
            print("Image Path: ", imagePAth)
            let dirContents = try? fileManager.contentsOfDirectory(atPath: imagePAth as String)
            let count = dirContents?.count
            print (count)
            
        }else{
            print("No Image")
        }
        
        table.delegate = self
        table.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "ImageCell")
        
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString)
        if fileManager.fileExists(atPath: imagePAth as String){
            if fileManager.fileExists(atPath: imagePAth as String){
                print(imagePAth)
                do{
                    let titles = try FileManager.default.contentsOfDirectory(atPath: imagePAth as String)
                    for image in titles{
//                        print (image)
//                        try fileManager.removeItem(atPath: imagePAth as String)
                        if (image.range(of: ".jpg")  != nil) {
                            print (image)
//                            let data = try? FileManager.default.contents(atPath:imagePAth.appending("customPic.jpg"))
//                        let image1 = UIImage(data: data as! Data)
//                            print (image1!)
//                            cell?.imageView?.image = UIImage(contentsOfFile: imagePAth as String)
                        }
                    }
                }catch{
                    print("Error")
                }
                
            }else{
                print("No Image")
            }
            
        }else{
            print("No Image")
        }
        
//        cell?.imageView =
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDirectoryPath() -> String {
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
        let dirPath = paths[0]
        return dirPath
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
