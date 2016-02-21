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

class moveiListViewController: UIViewController {

    
    @IBOutlet weak var movieLIstTable: UITableView!
    var testText = ["キックアス2","チャッピー","なんちゃって家族","インターステラー","リトルミスサンシャイン"]
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var userName:String = ""
    var entityName = "MuchMovie"
    var user = "user"
    var movie = "movie"
    var flag = "flag"
    override func viewDidLoad() {
        var userName = appDelegate.userName
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        var userName = appDelegate.userName
        readData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func returnGenreBtn(sender: UIButton) {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testText.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "myCell")
        cell.textLabel?.text = testText[indexPath.row]
        cell.textLabel?.textColor = UIColor.blueColor()
        return cell
    }
    
    func readData() -> NSArray{
        var ret:[String] = []
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: entityName)
        request.returnsObjectsAsFaults = false
        
        do {
            let results : Array = try context.executeFetchRequest(request)
            if (results.count > 0 ) {
                for i in 0..<results.count {
                    let obj = results[i] as! NSManagedObject
                    let userName = obj.valueForKey(user) as! String
                    //ユーザネーム指定してそのユーザの選んだ映画タイトルを取得
                    if userName == "kkkkk"{
                        let movieName = obj.valueForKey(movie) as! String
                        let setFlag = obj.valueForKey(flag) as! Int
                        ret.append(movieName)
                    }
                }
                print(ret)
                //myTexField.text = ret[0] as! String
            }
        } catch let error as NSError {
            // エラー処理
            print("READ ERROR:\(error.localizedDescription)")
        }
        return ret
    }

    
    

}
