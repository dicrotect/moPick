//
//  ViewController.swift
//  moPick
//
//  Created by dicrotect on 2016/02/16.
//  Copyright © 2016年 kensuke takakura. All rights reserved.
//

//ユーザーデフォルトでユーザー名を保存
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var nameArea: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        var myDefault = NSUserDefaults.standardUserDefaults()
        var myStr = myDefault.stringForKey("myString")
        if let tmpStr = myStr {
            nameArea.text = tmpStr
        }
    }
    
    @IBAction func resiterName(sender: UIButton) {
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.userName = nameArea.text!
        
        var myDefault = NSUserDefaults.standardUserDefaults()
        myDefault.setObject(nameArea.text, forKey: "myString")
        myDefault.synchronize()
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func returnText(sender: UITextField) {
        nameArea.resignFirstResponder()

    }
    
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        nameArea.resignFirstResponder()
    }

}

