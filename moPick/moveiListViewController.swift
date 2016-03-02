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
import SwiftSpinner


class moveiListViewController: UIViewController {
    
    
    @IBOutlet weak var movieLIstTable: UITableView!
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    var userName:String = ""
    var entityName = "MuchMovie"
    var movie = "movie"
    var flag = "flag"
    var url = "imgURL"
    
   
    var getList:[NSDictionary] = []
    var getCoreData:[NSDictionary] = []
   
    var dataList:[NSDictionary] = []
    
    var checkMarks:[Bool]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.leftBarButtonItem = editButtonItem()
        
        self.dataList = self.readData() as! [NSDictionary]
        for var i = 0; i < dataList.count; i++ {
            checkMarks.append(false)
        }
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
        var cell = UITableViewCell(style: .Default,reuseIdentifier: "myCell")
        var movieTitle = self.dataList[indexPath.row]["title"] as! String
        var checkeFlag = self.dataList[indexPath.row]["flag"] as!  Int
        cell.textLabel?.text = movieTitle
        cell.textLabel?.textColor = UIColor.blueColor()
        if checkeFlag == 1 {
            cell.accessoryType = .Checkmark
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.whiteColor()
        cell.selectedBackgroundView = backgroundView

    
        let jsonURL = self.dataList[indexPath.row]["image"] as! String
        let imageURL = NSURL(string:jsonURL as! String)
        let imageData = NSData(contentsOfURL:imageURL!)
        let image = UIImage(data: imageData!)
        cell.imageView?.image = image
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "myCell")
        var num = self.dataList[indexPath.row]["num"] as! Int
        editWrite(num)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .None {
                cell.accessoryType = .Checkmark
                cell.textLabel?.font = UIFont.boldSystemFontOfSize(17)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        //tableView.editing = editing
    }
    
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        var num = self.dataList[indexPath.row]["num"] as! Int
//        // 先にデータを更新する
//        editWrite(num)
//        // それからテーブルの更新
//        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)],
//            withRowAnimation: UITableViewRowAnimation.Fade)
//    }
//    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
//        var cell = UITableViewCell(style: .Default,reuseIdentifier: "myCell")
//        var movieTitle = self.dataList[sourceIndexPath.row]["title"] as! String
//        let targetTitle = movieTitle[sourceIndexPath.row]
//        if let index = titles.indexOf(targetTitle) {
//            titles.removeAtIndex(index)
//            titles.insert(targetTitle, atIndex: destinationIndexPath.row)
//        }
//    }
//    
    
    
    
    
    
    
    
    
    //coreData

    func readData() -> NSArray {
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: entityName)
        request.returnsObjectsAsFaults = false
        
        do {
            let results : Array = try context.executeFetchRequest(request)
            if (results.count > 0 ) {
                for i in 0..<results.count {
                    let obj = results[i] as! NSManagedObject
                    let flag = obj.valueForKey("flag") as! Int
                    let movieName = obj.valueForKey(self.movie) as! String
                    let imgURL = obj.valueForKey(self.url) as! String
                    let checkFlag = obj.valueForKey(self.flag) as! Int
                    
                    if flag == 0 {
                    var readCoreData:NSDictionary = [
                        "title":movieName,
                        "image":imgURL,
                        "flag":checkFlag,
                        "num":i
                    ]
                    getList.append(readCoreData)
                    }
                    if flag == 1 {
                        var readCoreData01:NSDictionary = [
                            "title":movieName,
                            "image":imgURL,
                            "flag":checkFlag,
                            "num":i
                        ]
                        getList.insert(readCoreData01, atIndex: 0)
                    }
                    getCoreData = getList.reverse()
                }
            }
        } catch let error as NSError {
            print("READ ERROR:\(error.localizedDescription)")
        }
        return getCoreData
    }
    
    func editWrite(num: Int) -> Bool{
        var ret = false
        
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: entityName)
        request.returnsObjectsAsFaults = false
        
        do {
            let results: Array = try context.executeFetchRequest(request)
            let obj = results[num] as! NSManagedObject
            let index = obj.valueForKey(flag) as! Int
            obj.setValue(1, forKey: flag)
            appDelegate.saveContext()
            ret = true
        } catch let error as NSError {
            // エラー処理
            print("FETCH ERROR:\(error.localizedDescription)")
        }
        return ret
    }
    
    
    func deleteData(num: Int) -> Bool {
        var ret = false
        
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: entityName)
        request.returnsObjectsAsFaults = false
        
        do {
            let results : Array = try context.executeFetchRequest(request)
            if (results.count > 0 ) {
                // 見つかったら削除
                let obj = results[num] as! NSManagedObject
                let txt = obj.valueForKey(movie) as! String
                print("DELETE \(txt)")
                context.deleteObject(obj)
                appDelegate.saveContext()
            }
            ret = true
        } catch let error as NSError {
            // エラー処理
            print("FETCH ERROR:\(error.localizedDescription)")
        }
        return ret
    }
    
    func prpareCore() {
        
    }

}
