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



class swipeMovieViewController: UIViewController {

    
   
    var swipeCount = 0
    var photoURL = "theater.jpg"

    var userName:String = ""
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        var userName = appDelegate.userName
        let swipeView1 = createSwipeView(photoURL)
        self.view.addSubview(swipeView1)
        let swipeView2 = createSwipeView(photoURL)
        self.view.addSubview(swipeView2)
        let swipeView3 = createSwipeView(photoURL)
        self.view.addSubview(swipeView3)
        let swipeView4 = createSwipeView(photoURL)
        self.view.addSubview(swipeView4)
        let swipeView5 = createSwipeView(photoURL)
        self.view.addSubview(swipeView5)
    }
    @IBAction func moreMovie(sender: UIButton) {
        var userName = appDelegate.userName
        let swipeView1 = createSwipeView(photoURL)
        self.view.addSubview(swipeView1)
        let swipeView2 = createSwipeView(photoURL)
        self.view.addSubview(swipeView2)
        let swipeView3 = createSwipeView(photoURL)
        self.view.addSubview(swipeView3)
        let swipeView4 = createSwipeView(photoURL)
        self.view.addSubview(swipeView4)
        let swipeView5 = createSwipeView(photoURL)
        self.view.addSubview(swipeView5)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createSwipeView(url: String) -> UIView {
        let options = MDCSwipeToChooseViewOptions()
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
        
        let targetFirstInt = (arc4random() % 10)
        let targetFirstString:String = String(targetFirstInt)
        let targetSecondInt = (arc4random() % 5)
        let targetSecondString:String = String(targetSecondInt)
        let targetString = targetSecondString + targetFirstString
        let targetInt:Int = Int(targetString)!
        
        //取得したいjsonデータを指定
        //ファンタジー/恋愛/冒険/感動
        var chosenGenre = appDelegate.chosenGenre
        
        var genreURL =
        ["%E9%AD%94%E6%B3%95", "%E5%88%9D%E6%81%8B", "%E5%A4%A7%E5%86%92%E9%99%BA","%E6%84%9F%E5%8B%95" ]
        let jsonURL = "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch?term=\(genreURL[chosenGenre])&media=movie&entity=movie&attribute=descriptionTerm&country=jp"
        
        
        Alamofire.request(.GET, jsonURL,parameters: nil, encoding: .JSON ).responseJSON{(response) in
            if(response.result.isSuccess){
                let json = JSON(response.result.value!)
                let movieImageURL:String = String(json["results"][targetInt]["artworkUrl100"])
                let imageURL = NSURL(string:movieImageURL as! String)
                let imageData = NSData(contentsOfURL:imageURL!)
                let image = UIImage(data: imageData!)
                
                swipeView.imageView.image = UIImage(data: NSData(contentsOfURL: imageURL!)!)
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
        } else {
            print("Like")
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

  

    

  }
