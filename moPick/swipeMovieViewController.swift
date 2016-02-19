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

    
    var chosenGenre = Int()
    var swipeCount = 0
    var photoURL = [
        "http://up.gc-img.net/post_img_web/2013/03/a3a43755438b42d881929eefc7161191_0.jpeg",
        "http://pic.prepics-cdn.com/pib1298076039/5731792_218x291.gif",
        "http://omosoku.com/wp-content/uploads/misawa-225x300.gif"
    ]

    var userName:String = ""
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        print(chosenGenre)
        
        var userName = appDelegate.userName
        print(userName)
        
        let swipeView1 = createSwipeView(photoURL[0])
        self.view.addSubview(swipeView1)
        
        let swipeView2 = createSwipeView(photoURL[1])
        self.view.insertSubview(swipeView2, belowSubview: swipeView1)
        
        let swipeView3 = createSwipeView(photoURL[2])
        self.view.insertSubview(swipeView3, belowSubview: swipeView2)
        
        let swipeView4 = createSwipeView(photoURL[2])
        self.view.insertSubview(swipeView4, belowSubview: swipeView2)
        
        let swipeView5 = createSwipeView(photoURL[2])
        self.view.insertSubview(swipeView5, belowSubview: swipeView2)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createSwipeView(url: String) -> UIView {
        let options = MDCSwipeToChooseViewOptions()
        options.likedText = "Like"
        options.likedColor = UIColor.greenColor()
        options.nopeText = "Later"
        options.nopeColor = UIColor.lightGrayColor()
        
        let swipeView = MDCSwipeToChooseView(
            frame: CGRect(
                x: 100,
                y: 130,
                width: 100,
                height: 100
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
    
    func view(view: UIView!, wasChosenWithDirection direction: MDCSwipeDirection) {
        if (direction == MDCSwipeDirection.Left) {
            print("Later")
        } else {
            print("Like")
        }
        swipeCount++
    }

    

  }
