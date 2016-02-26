//
//  swipeMovieViewController.swift
//  moPick
//
//  Created by dicrotect on 2016/02/18.
//  Copyright © 2016年 kensuke takakura. All rights reserved.
//
//TinderUIの実装
//5個映画を選んだらmovieListControllerへ
//Likeの方には見たい属性に1を入れてcoreデータに追加

import UIKit
import MDCSwipeToChoose
import Alamofire
import SwiftyJSON
import CoreData



class swipeMovieViewController: UIViewController, MDCSwipeToChooseDelegate {
    
    
    
    var swipeCount = 0
    var swipeListCount = 0
    var photoURL = "theater.jpg"
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var entityName = "MuchMovie"
    var user = "user"
    var movie =  "movie"
    var flag = "flag"
    var url = "imgURL"
    var readJsonDataDict:NSDictionary = ["":""]
    var readJsonDataArray:[NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        let swipeView1 = createSwipeView(photoURL)
        self.view.addSubview(swipeView1)
        let swipeView2 = createSwipeView(photoURL)
        self.view.insertSubview(swipeView2, aboveSubview: swipeView1)
        let swipeView3 = createSwipeView(photoURL)
        self.view.insertSubview(swipeView3, aboveSubview: swipeView2)
        let swipeView4 = createSwipeView(photoURL)
        self.view.insertSubview(swipeView4, aboveSubview: swipeView3)
        let swipeView5 = createSwipeView(photoURL)
        self.view.insertSubview(swipeView5, aboveSubview: swipeView4)
        
       
    }
    @IBAction func moreMovie(sender: UIButton) {
        let swipeView1 = createSwipeView(photoURL)
        self.view.addSubview(swipeView1)
        let swipeView2 = createSwipeView(photoURL)
        self.view.insertSubview(swipeView2, aboveSubview: swipeView1)
        let swipeView3 = createSwipeView(photoURL)
        self.view.insertSubview(swipeView3, aboveSubview: swipeView2)
        let swipeView4 = createSwipeView(photoURL)
        self.view.insertSubview(swipeView4, aboveSubview: swipeView3)
        let swipeView5 = createSwipeView(photoURL)
        self.view.insertSubview(swipeView5, aboveSubview: swipeView4)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createSwipeView(url: String) -> UIView {
        let options = MDCSwipeToChooseViewOptions()
        options.delegate = self
        options.likedText = "Like"
        options.likedColor = UIColor.greenColor()
        options.nopeText = "Later"
        options.nopeColor = UIColor.lightGrayColor()
        
        let swipeView = MDCSwipeToChooseView(
            frame: CGRect(
                x: 90,
                y: 170,
                width: 140,
                height: 140
            ),
            options: options
        )
        
        let targetFirstInt = (arc4random() % 9)
        let targetFirstString:String = String(targetFirstInt)
        let targetSecondInt = (arc4random() % 5)
        let targetSecondString:String = String(targetSecondInt)
        let targetString = targetSecondString + targetFirstString
        let targetInt:Int = Int(targetString)!
        let offsetInt = (arc4random() % 4)
        
        //取得したいjsonデータを指定
        //ファンタジー/恋愛/冒険/感動
        var chosenGenre = appDelegate.chosenGenre
        
        var genreURL =
        ["%E9%AD%94%E6%B3%95", "%E5%88%9D%E6%81%8B", "%E5%A4%A7%E5%86%92%E9%99%BA","%E6%84%9F%E5%8B%95" ]
        let jsonURL = "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch?term=\(genreURL[chosenGenre])&media=movie&entity=movie&attribute=descriptionTerm&offset=\(offsetInt)&country=jp"
        
        
        Alamofire.request(.GET, jsonURL,parameters: nil, encoding: .JSON ).responseJSON{(response) in
            if(response.result.isSuccess){
                let json = JSON(response.result.value!)
                let movieImageURL:String = String(json["results"][targetInt]["artworkUrl100"])
                let movieTitle:String = String(json["results"][targetInt]["trackName"])
                let imageURL = NSURL(string:movieImageURL as! String)
                let imageData = NSData(contentsOfURL:imageURL!)
                let image = UIImage(data: imageData!)
                swipeView.imageView.image = UIImage(data: NSData(contentsOfURL: imageURL!)!)
                swipeView.tag = self.swipeListCount
                
                self.readJsonDataDict = [
                    "num":self.swipeListCount,
                    "name":movieTitle,
                    "image":movieImageURL
                ]
                
                //この番号とnumが一致するものを探す
                self.swipeListCount++
                self.readJsonDataArray.append(self.readJsonDataDict)
                
                
            }
        }
        
        return swipeView
    }
    
    @IBAction func tapBtn(sender: UIButton) {
        alertUp()
    }
    
    
    func view(view: UIView!, wasChosenWithDirection direction: MDCSwipeDirection) {
        
        
        if (direction == MDCSwipeDirection.Left) {
            print("Later")
            for var i = 0; i < self.readJsonDataArray.count; i++ {
                if view.tag == self.readJsonDataArray[i]["num"] as! Int {
                    print(self.readJsonDataArray[i])
                }
            }

        } else {
            print("Like")
            var userName = appDelegate.userName
            print("Later")
            for var i = 0; i < self.readJsonDataArray.count; i++ {
                if view.tag == self.readJsonDataArray[i]["num"] as! Int {
                    var movieTitle = self.readJsonDataArray[i]["name"] as! String
                    var movieImgURL = self.readJsonDataArray[i]["image"] as! String
                    writeData(userName, txtMovie: movieTitle, txtURL: movieImgURL )
                }
            }
            
        }
        swipeCount++
    }
    
    func alertUp() {
        
        let alert = UIAlertController(
            title: "選んだ映画はこちらです",
            message: "映画を選びました!",
            preferredStyle: .Alert
        )
        
        alert.addAction(UIAlertAction(
            title: "ジャンルを変更",
            style: .Default,
            handler: {action in self.backToCooseGenre()}
            ))
        
        alert.addAction(UIAlertAction(
            title: "リストで確認",
            style: .Default,
            handler: {action in self.moveMovieList()}
            ))
        
        presentViewController(alert, animated: true,completion:nil)
        
    }
    
    func moveMovieList() {
        self.performSegueWithIdentifier("showMovieList", sender: nil)
    }
    func backToCooseGenre() {
        self.performSegueWithIdentifier("backToChooseGenre", sender: nil)
    }
    
    func writeData(txtUser: String , txtMovie: String, txtURL: String) -> Bool{
        //txtUser デリゲートで保存している名前
        //txtMovie いいねにした映画タイトル
        var ret = false
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: entityName)
        request.returnsObjectsAsFaults = false
        
        do {
            let results: Array = try context.executeFetchRequest(request)
            let entity: NSEntityDescription! = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
            
            let obj = muchMovie(entity: entity, insertIntoManagedObjectContext: context)
            obj.setValue(txtUser, forKey: user)
            obj.setValue(txtMovie, forKey: movie)
            obj.setValue(txtURL, forKey: url)
            obj.setValue(0, forKey: flag)
            do {
                try context.save()
            } catch let error as NSError {
                print("INSERT ERROR:\(error.localizedDescription)")
            }
            ret = true
            
        } catch let error as NSError {
            print("FETCH ERROR:\(error.localizedDescription)")
        }
        return ret
    }
    
}
