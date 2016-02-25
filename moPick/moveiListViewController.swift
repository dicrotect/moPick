//
//  moveiListViewController.swift
//  moPick
//
//  Created by dicrotect on 2016/02/18.
//  Copyright © 2016年 kensuke takakura. All rights reserved.
//

//テーブルview
//見たいリストと見たリストを分ける
//coreデータから表示する映画タイトル,見たフラグを取得

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class moveiListViewController: UIViewController {

    
    @IBOutlet weak var movieLIstTable: UITableView!
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var userName:String = ""
    var entityName = "MuchMovie"
    var user = "user"
    var movie = "movie"
    var flag = "flag"
    var url = "imgURL"
    var getCoreData:[NSDictionary] = []
    var dataList:[NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
       dataList = readData() as! [NSDictionary]
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func returnGenreBtn(sender: UIButton) {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var movieTitle = dataList[indexPath.row]["title"] as! String
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "myCell")
        cell.textLabel?.text = movieTitle
        cell.textLabel?.textColor = UIColor.blueColor()
        let jsonURL = dataList[indexPath.row]["image"] as! String
        let imageURL = NSURL(string:jsonURL as! String)
        let imageData = NSData(contentsOfURL:imageURL!)
        let image = UIImage(data: imageData!)
        cell.imageView?.image = image
    
        return cell
    }
    
    func readData() -> NSArray{
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var thisUserName = appDelegate.userName
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: entityName)
        request.returnsObjectsAsFaults = false
        
        do {
            let results : Array = try context.executeFetchRequest(request)
            if (results.count > 0 ) {
                for i in 0..<results.count {
                    let obj = results[i] as! NSManagedObject
                    let userName = obj.valueForKey(user) as! String
                    if userName == thisUserName{
                        let movieName = obj.valueForKey(movie) as! String
                        let imgURL = obj.valueForKey(url) as! String
                        var readCoreData:NSDictionary = [
                            "title":movieName,
                            "image":imgURL
                        ]
                        getCoreData.append(readCoreData)
                    }
                    
                }
            }
        } catch let error as NSError {
            print("READ ERROR:\(error.localizedDescription)")
        }
        return getCoreData
    }
    
    
}
