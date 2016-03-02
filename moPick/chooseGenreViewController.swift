//
//  chooseGenreViewController.swift
//  moPick
//
//  Created by dicrotect on 2016/02/18.
//  Copyright © 2016年 kensuke takakura. All rights reserved.
//

import UIKit

class chooseGenreViewController: UIViewController {

    
    @IBOutlet weak var loveIconBtn: UIButton!
    @IBOutlet weak var humanIconBtn: UIButton!
    @IBOutlet weak var adventureIconBtn: UIButton!
    @IBOutlet weak var funtasyIconBtn: UIButton!
    @IBOutlet weak var backGroundImage: UIImageView!
    
    @IBOutlet weak var userlabel: UILabel!
    var chooseGenre = Int()
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func chooseFantasy(sender: UIButton) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.chosenGenre = 0
       
    }
    @IBAction func chooseLove(sender: UIButton) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.chosenGenre = 1
    }
    @IBAction func chooseAdventure(sender: UIButton) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.chosenGenre = 2
    }
    @IBAction func chooseEmotion(sender: UIButton) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.chosenGenre = 3
    }
    
    @IBAction func chooseSuspense(sender: UIButton) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.chosenGenre = 4
    }
    @IBAction func chooseAnimal(sender: UIButton) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.chosenGenre = 5
    }
    
    

}
