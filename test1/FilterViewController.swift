//
//  FilterViewController.swift
//  test1
//
//  Created by 김환석 on 2020/10/17.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    
    @IBOutlet var btnLocation1: UIButton!
    @IBOutlet var btnLocation2: UIButton!
    @IBOutlet var lblAge: UILabel!
    @IBOutlet var sliderBar: UISlider!
    @IBOutlet var btnTotal: UIButton!
    @IBOutlet var btnDate: UIButton!
    
    var location1:String?
    var location2:String?
    var age:String?
    var date:String?
    var total:String?
    
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //backGround Color
        let backGroundColor = MyBackGroundColor()
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = self.view.bounds
        self.gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        self.gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.gradientLayer.colors = [UIColor(red: backGroundColor.startColorRed, green: backGroundColor.startColorGreen, blue: backGroundColor.startColorBlue , alpha: 1).cgColor, UIColor(red: backGroundColor.endColorRed , green: backGroundColor.endColorGreen, blue: backGroundColor.endColorBlue, alpha: 1).cgColor]
        self.view.layer.insertSublayer(self.gradientLayer, at: 0)
        
        if let location1 = self.location1{
            self.btnLocation1.setTitle(location1, for: .normal)
        }
        if let location2 = self.location2{
            self.btnLocation2.setTitle(location2, for: .normal)
        }
        if let age = self.age{
            self.lblAge.text = age
        }
        
        if let total = self.total{
            self.btnTotal.setTitle(total, for: .normal)
        }
        if let date = self.date{
            self.btnDate.setTitle(date, for: .normal)
        }
        
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        let preVC = self.presentingViewController
        guard let vc = preVC as? SearchRoomViewController else {return}
        vc.isClickedFilterButton = false
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnLocation1(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Picker", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PickerLocation1ViewController") as? PickerLocation1ViewController else {return}
        controller.providesPresentationContextTransitionStyle = true
        controller.definesPresentationContext = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        controller.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        controller.beforeController = "FilterViewController"
        self.present(controller, animated: false, completion: nil)
    }
    @IBAction func btnLocation2(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Picker", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PickerLocation2ViewController") as? PickerLocation2ViewController else {return}
        controller.providesPresentationContextTransitionStyle = true
        controller.definesPresentationContext = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        controller.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        controller.beforeController = "FilterViewController"
        controller.location1 = self.btnLocation1.titleLabel?.text!
        self.present(controller, animated: false, completion: nil)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.lblAge.text = "\(Int(sender.value))"
        if(Int(sender.value) == 19){
            self.lblAge.text = "상관없음"
        }
    }
    @IBAction func btnTotal(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Picker", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PickerTotalViewController") as? PickerTotalViewController else {return}
        controller.providesPresentationContextTransitionStyle = true
        controller.definesPresentationContext = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        controller.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        controller.beforeController = "FilterViewController"
        self.present(controller, animated: false, completion: nil)
    }
    
    
    @IBAction func btnDate(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Picker", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PickerDateViewController") as? PickerDateViewController else {return}
        controller.providesPresentationContextTransitionStyle = true
        controller.definesPresentationContext = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        controller.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        controller.beforeController = "FilterViewController"
        self.present(controller, animated: false, completion: nil)
    }
    
    
    @IBAction func btnDone(_ sender: UIButton) {
        
        
        let preVC = self.presentingViewController
        guard let vc = preVC as? SearchRoomViewController else {return}
        if let location1 = self.btnLocation1.titleLabel?.text{
            vc.meetingLocation1 = location1
        }
        if let location2 = self.btnLocation2.titleLabel?.text{
            vc.meetingLocation2 = location2
        }
        if let age = self.lblAge.text{
            vc.meetingAge = age
        }
        if let total = self.btnTotal.titleLabel?.text{
            vc.meetingTotal = total
        }
        vc.isClickedFilterButton = true
        
        dismiss(animated: true, completion: nil)
    }
    
    func myAlert(_ title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
