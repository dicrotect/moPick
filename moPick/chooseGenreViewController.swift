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
    var chooseGenre = Int()
    
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

    @IBAction func chooseFantasy(sender: UIButton) {
        chooseGenre = 0
    }
    @IBAction func chooseLove(sender: UIButton) {
        chooseGenre = 1
    }
    @IBAction func chooseAdventure(sender: UIButton) {
        chooseGenre = 2
    }
    @IBAction func chooseEmotion(sender: UIButton) {
        chooseGenre = 3
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var sendData = segue.destinationViewController as! swipeMovieViewController
        sendData.chosenGenre = chooseGenre
    }
    
    

}
