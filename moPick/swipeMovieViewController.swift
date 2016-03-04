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

    @IBOutlet weak var charaCommentLabel: LTMorphingLabel!
    
    @IBOutlet weak var charaImage: UIImageView!
    var imageList = ["funtasy.png","love.png","adventure.png","human.png","suspense.png","anumals.png"]
    
    
    
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
        options.likedColor = UIColor.greenColor()
        options.nopeText = "Later"
        options.nopeColor = UIColor.lightGrayColor()
        
        var view = MDCSwipeToChooseView(frame: CGRectMake(10,200,300,300), options: options)
        return view
    }
    
    func createViewPage()-> Void {
    
        let targetFirstInt = (arc4random() % 9)
        let targetFirstString:String = String(targetFirstInt)
        let targetSecondInt = (arc4random() % 5)
        let targetSecondString:String = String(targetSecondInt)
        let targetString = targetSecondString + targetFirstString
        let targetInt:Int = Int(targetString)!
        let offsetInt = (arc4random() % 2)
        print(targetInt)
        print(offsetInt)
        
        //ファンタジー/恋愛/冒険/感動/サスペンス/自然
        var chosenGenre = appDelegate.chosenGenre
        swipeView.hidden = true
        SwiftSpinner.show("Connecting to satellite...")
        var genreURL =
        ["%E9%AD%94%E6%B3%95", "%E5%88%9D%E6%81%8B", "%E5%A4%A7%E5%86%92%E9%99%BA","%E6%84%9F%E5%8B%95","%E6%8E%A2%E5%81%B5","%E8%87%AA%E7%84%B6" ]
        let jsonURL = "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch?term=\(genreURL[chosenGenre])&media=movie&entity=movie&attribute=descriptionTerm&offset=\(offsetInt)&country=jp"
        
        Alamofire.request(.GET, jsonURL,parameters: nil, encoding: .JSON ).responseJSON{(response) in
            if(response.result.isSuccess){
                let json = JSON(response.result.value!)
                let movieImageURL:String = String(json["results"][targetInt]["artworkUrl100"])
                let movieTitle:String = String(json["results"][targetInt]["trackName"])
                let imageURL = NSURL(string:movieImageURL as! String)
                let imageData = NSData(contentsOfURL:imageURL!)
                let image = UIImage(data: imageData!)
                var title = String(json["results"][targetInt]["trackName"])
                var story = String(json["results"][targetInt]["longDescription"])
                
                
                self.readJsonDataDict = [
                    "num":self.swipeListCount,
                    "name":movieTitle,
                    "image":movieImageURL
                ]
                let imageView1 = UIImageView(image:image)
                let titleView = UILabel()
                titleView.text = title
                titleView.backgroundColor = UIColor.greenColor()
                titleView.frame = CGRectMake(0,0, 300, 50)
                
                let storyView = UITextView()
                storyView.text = story
                storyView.backgroundColor = UIColor.whiteColor()
                storyView.frame = CGRectMake(0, 120, 300, 200)
               
                
                let swipeView1 = self.createSwipeView()
                imageView1.frame = CGRectMake(120, 50, 80, 80)
                
                swipeView1.tag = self.swipeListCount
                swipeView1.addSubview(imageView1)
                swipeView1.addSubview(titleView)
                swipeView1.addSubview(storyView)
                self.view.addSubview(swipeView1)
                print(self.swipeListCount)
                //この番号とnumが一致するものを探す
                self.swipeListCount++
                
                self.readJsonDataArray.append(self.readJsonDataDict)
            }
            self.swipeView.hidden = false
            SwiftSpinner.hide()
        }
        dispatch_resume(self.queue)
    }
    
    @IBAction func tapBtn(sender: UIButton) {
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
    
    
    func moveMovieList() {
        self.performSegueWithIdentifier("showMovieList", sender: nil)
    }
    func backToCooseGenre() {
        self.performSegueWithIdentifier("backToChooseGenre", sender: nil)
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
