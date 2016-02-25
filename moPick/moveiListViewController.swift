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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func returnGenreBtn(sender: UIButton) {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readData().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var movieTitle = readData()[indexPath.row] as! String
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "myCell")
        cell.textLabel?.text = movieTitle
        cell.textLabel?.textColor = UIColor.blueColor()
        cell.imageView?.image = UIImage(named: ("theater.jpg" as? String)!)
        print(getJson())
        return cell
    }
    
    func readData() -> NSArray{
        var movieDataList:[String] = []
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
                        movieDataList.append(movieName)
                    }
                }
            }
        } catch let error as NSError {
            print("READ ERROR:\(error.localizedDescription)")
        }
        return movieDataList
    }
    
    func  getJson()->String {
        
        var movieImageURL = String()
        let jsonURL = "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch?term=%E3%83%81%E3%83%A3%E3%83%83%E3%83%94%E3%83%BC&media=movie&entity=movie&attribute=movieTerm&country=jp"
       
        Alamofire.request(.GET, jsonURL,parameters: nil, encoding: .JSON ).responseJSON{(response) in
            if(response.result.isSuccess){
                let json = JSON(response.result.value!)
                movieImageURL = String(json["results"][0]["artworkUrl30"])
                //print(movieImageURL+"だよ")
            }
        }
        print(movieImageURL+"かな")
        return movieImageURL
        
    }
    
}
