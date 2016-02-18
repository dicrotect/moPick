//
//  chooseGenreViewController.swift
//  moPick
//
//  Created by dicrotect on 2016/02/18.
//  Copyright © 2016年 kensuke takakura. All rights reserved.
//

import UIKit

class chooseGenreViewController: UIViewController {

    @IBOutlet weak var userlabel: UILabel!
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        var userName = appDelegate.userName
        userlabel.text = userName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func chooseLove(sender: UIButton) {
    }
    @IBAction func chooseEmotion(sender: UIButton) {
    }
    
    @IBAction func chooseAdventure(sender: UIButton) {
    }
    @IBAction func chooseFantasy(sender: UIButton) {
    }
    

}
