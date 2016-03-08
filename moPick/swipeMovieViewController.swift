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
import SwiftSpinner
import LTMorphingLabel
import AsyncKit


class swipeMovieViewController: UIViewController, MDCSwipeToChooseDelegate, LTMorphingLabelDelegate {
    
    var swipeCount = 0
    var swipeListCount = 0
    var photoURL = "theater.jpg"
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    var entityName = "MuchMovie"
    var movie =  "movie"
    var flag = "flag"
    var url = "imgURL"
    var readJsonDataDict:NSDictionary = ["":""]
    var readJsonDataArray:[NSDictionary] = []
    var swipeView = UIView()
    
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var topBtn: UIButton!
    
    @IBOutlet weak var charaCommentLabel: LTMorphingLabel!
    
    @IBOutlet weak var charaImage: UIImageView!
    var imageList = ["funtasy.png","love.png","adventure.png","human.png","suspense.png","animal.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        var chosenGenre = appDelegate.chosenGenre
        for var i = 0; i<5; i++ {
            createViewPage()
        }
        charaImage.image = UIImage(named: imageList[chosenGenre])
    }
    @IBAction func moreMovie(sender: UIButton) {
        for var i = 0; i<5; i++ {
            createViewPage()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createSwipeView() -> UIView {
        
        let options = MDCSwipeToChooseViewOptions()
        
        options.delegate = self
        options.likedText = "Like"
        options.likedColor = UIColor.redColor()
        options.nopeText = "Later"
        options.nopeColor = UIColor.lightGrayColor()
        
        let aView = MDCSwipeToChooseView(frame: self.view.frame, options : options)
        aView.translatesAutoresizingMaskIntoConstraints = false
        // 制約をつける前にaddしなければならない
        self.view.addSubview(aView)
        
        // width の制約
        let constraintWidth = NSLayoutConstraint(
            item: aView,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Width,
            multiplier: 1.0 / 3.0,
            constant: 160
        )
        // height の制約
        let constraintHeight = NSLayoutConstraint(
            item: aView,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Height,
            multiplier: 1.0 / 4.0,
            constant: 160
        )
        // X中央寄せ
        let constraintHorizontal = NSLayoutConstraint(
            item: aView,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0
        )
        // Y中央寄せ
        let constraintVertical = NSLayoutConstraint(
            item: aView,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0
        )
        
        let constraints = [constraintWidth, constraintHeight, constraintHorizontal, constraintVertical]
        // 制約をつける
        self.view.addConstraints(constraints)
        swipeView.bringSubviewToFront(aView)
        
        return aView
    }
    
    func createViewPage()-> Void {
        
        let targetFirstInt = (arc4random() % 9)
        let targetFirstString:String = String(targetFirstInt)
        let targetSecondInt = (arc4random() % 4)
        let targetSecondString:String = String(targetSecondInt)
        let targetString = targetSecondString + targetFirstString
        let targetInt:Int = Int(targetString)!
        
        
        //ファンタジー/恋愛/冒険/感動/サスペンス/自然
        var chosenGenre = appDelegate.chosenGenre
        swipeView.hidden = true
        SwiftSpinner.show("Connecting to satellite...")
        var genreURL =
        ["%E9%AD%94%E6%B3%95", "%E5%88%9D%E6%81%8B", "%E5%A4%A7%E5%86%92%E9%99%BA","%E6%84%9F%E5%8B%95","%E3%82%B5%E3%82%B9%E3%83%9A%E3%83%B3%E3%82%B9","%E5%A4%A7%E8%87%AA%E7%84%B6" ]
        let jsonURL = "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch?term=\(genreURL[chosenGenre])&media=movie&entity=movie&attribute=descriptionTerm&country=jp"
        
        
        
        Alamofire.request(.GET, jsonURL,parameters: nil, encoding: .JSON ).responseJSON{(response) in
            if(response.result.isSuccess) {
                self.topBtn.hidden = true
                let json = JSON(response.result.value!)
                let movieImageURL:String = String(json["results"][targetInt]["artworkUrl100"])
                let movieTitle:String = String(json["results"][targetInt]["trackCensoredName"])
                let imageURL = NSURL(string:movieImageURL as! String)
                let imageData = NSData(contentsOfURL:imageURL!)
                if imageData != nil {
                    let image = UIImage(data: imageData!)
                    var title = String(json["results"][targetInt]["trackCensoredName"])
                    var story = String(json["results"][targetInt]["longDescription"])
                    
                    self.readJsonDataDict = [
                        "num":self.swipeListCount,
                        "name":movieTitle,
                        "image":movieImageURL
                    ]
                    
                    let titleView = UILabel()
                    titleView.text = title
                    titleView.textAlignment = NSTextAlignment.Center
                    titleView.textColor = UIColor.whiteColor()
                    titleView.backgroundColor = UIColor.redColor()
                    titleView.frame = CGRectMake(0,0, 300, 50)
                    
                    let imageView1 = UIImageView(image:image)
                    imageView1.frame = CGRectMake(80, 50, 110, 110)
                    let storyView = UITextView()
                    
                    storyView.text = story
                    storyView.editable = false
                    storyView.backgroundColor = UIColor.whiteColor()
                    storyView.frame = CGRectMake(0, 160, 300, 200)
                    
                    let swipeView1 = self.createSwipeView()
                    swipeView1.tag = self.swipeListCount
                    swipeView1.addSubview(imageView1)
                    swipeView1.addSubview(titleView)
                    swipeView1.addSubview(storyView)
                    self.view.addSubview(swipeView1)
                    //この番号とnumが一致するものを探す
                    self.swipeListCount++
                    self.readJsonDataArray.append(self.readJsonDataDict)
                    self.swipeView.hidden = false
                    SwiftSpinner.hide()
                } else {
                    self.charaCommentLabel.text = "予期せぬエラーが発生しました"
                    self.moreBtn.hidden = true
                    self.topBtn.hidden = false
                    SwiftSpinner.hide()
                }
            } else {
                self.charaCommentLabel.text = "インターネットに接続ください"
                self.moreBtn.hidden = true
                self.topBtn.hidden = false
                SwiftSpinner.hide()
                
            }
            
        }
        dispatch_resume(self.queue)
    }
    
    
    func view(view: UIView!, wasChosenWithDirection direction: MDCSwipeDirection) {
        
        if (direction == MDCSwipeDirection.Left) {
            print("Later")
            charaCommentLabel.text = "これはどうかな？"
        } else {
            print("Like")
            charaCommentLabel.text = "つぎはこれがオススメ!"
            for var i = 0; i < self.readJsonDataArray.count; i++ {
                if view.tag == self.readJsonDataArray[i]["num"] as! Int {
                    var movieTitle = self.readJsonDataArray[i]["name"] as! String
                    var movieImgURL = self.readJsonDataArray[i]["image"] as! String
                    writeData( movieTitle, txtURL: movieImgURL )
                }
            }
        }
        swipeCount++
    }
    
    
    @IBAction func moveToMovieList(sender: UIButton) {
        AsyncKit<String, NSError>().parallel([
            { done in
                SwiftSpinner.show("Connecting to satellite...")
                done(.Success("one"))
            }, { done in
                
                self.performSegueWithIdentifier("goToList", sender: nil)
                done(.Success("two"))
            }
            ]) { result in
                switch result {
                case .Success(let objects):
                    SwiftSpinner.hide()
                case .Failure(let error):
                    print(error)
                }
        }
        
    }
    
    func writeData(txtMovie: String, txtURL: String) -> Bool{
        //txtUser デリゲートで保存している名前
        //txtMovie いいねにした映画タイトル
        var ret = false
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: entityName)
        request.returnsObjectsAsFaults = false
        
        do {
            let results: Array = try context.executeFetchRequest(request)
            let entity: NSEntityDescription! = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
            let obj = muchMovie(entity: entity, insertIntoManagedObjectContext: context)
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
