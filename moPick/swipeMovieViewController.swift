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

class swipeMovieViewController: UIViewController {

    
    var userName:String = ""
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        var userName = appDelegate.userName
        print(userName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  }
