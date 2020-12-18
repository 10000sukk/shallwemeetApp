//
//  ViewController.swift
//  test1
//
//  Created by 김환석 on 2020/10/03.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var lbl1: UILabel!
    @IBOutlet var lblUserID: UILabel!
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var lblUserPassword: UILabel!
    @IBOutlet var lbl3: UILabel!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnStart: UIButton!
    
    
    var userID: String?
    var userPassword: String?
    var islogined: Bool?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        islogined = false
    }
    
    
    @IBAction func btnLogin(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(identifier: "LoginViewController")
        controller?.modalPresentationStyle = .fullScreen
        self.present(controller!, animated: true, completion: nil)
    }
    

    @IBAction func btnStart(_ sender: UIButton) {
        if islogined!{
            let controller1 = self.storyboard?.instantiateViewController(identifier: "EditProfileViewController")
            self.present(controller1!, animated: true, completion: nil)
        }
        let controller2 = self.storyboard?.instantiateViewController(identifier: "EditProfileViewController") 
        controller2?.modalPresentationStyle = .fullScreen
        self.present(controller2!, animated: true, completion: nil)
    }
    
    
    
    
    
  
    
     
}

