//
//  chooseGenreViewController.swift
//  moPick
//
//  Created by dicrotect on 2016/02/18.
//  Copyright © 2016年 kensuke takakura. All rights reserved.
//

import UIKit
import LTMorphingLabel
import SwiftSpinner
import AsyncKit

class chooseGenreViewController: UIViewController, LTMorphingLabelDelegate {

    
    @IBOutlet weak var loveIconBtn: UIButton!
    @IBOutlet weak var humanIconBtn: UIButton!
    @IBOutlet weak var adventureIconBtn: UIButton!
    @IBOutlet weak var funtasyIconBtn: UIButton!
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var subLabel: LTMorphingLabel!
    
    @IBOutlet weak var mopickTitle: LTMorphingLabel!
    
    var chooseGenre = Int()
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mopickTitle.text = "MOPICK"
        mopickTitle.backgroundColor = UIColor.blackColor()
    }
    
    
    @IBAction func topToList(sender: UIButton) {
        
        AsyncKit<String, NSError>().parallel([
            { done in
                SwiftSpinner.show("Connecting to satellite...")
                done(.Success("one"))
            }, { done in
                 self.performSegueWithIdentifier("showList", sender: nil)
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
    
    override func viewWillAppear(animated: Bool) {
        subLabel.text = "気になるキャラクターをタップ!"
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
