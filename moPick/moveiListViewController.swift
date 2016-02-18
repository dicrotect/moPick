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

class moveiListViewController: UIViewController {

    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var userName:String = ""
    override func viewDidLoad() {
        var userName = appDelegate.userName
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        var userName = appDelegate.userName
        print(userName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func returnGenreBtn(sender: UIButton) {
    }
    
    


}
