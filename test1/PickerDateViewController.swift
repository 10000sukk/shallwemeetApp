//
//  PickerDateViewController.swift
//  test1
//
//  Created by 김환석 on 2020/11/04.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit

class PickerDateViewController: UIViewController {

    @IBOutlet var viewPickerDate: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    
    var date:String?
    var beforeController:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPickerDate.clipsToBounds = true
        viewPickerDate.layer.cornerRadius = 50
        viewPickerDate.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        // Do any additional setup after loading the view.
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        date = formatter.string(from: currentDate as Date)
        
        datePicker?.minimumDate = currentDate
        
        datePicker?.maximumDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)
        
        let ud = UserDefaults.standard
        if let beforeController = ud.string(forKey: "beforeController"){
            self.beforeController = beforeController
        }
    }
    
    
    
    @IBAction func changeDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.date = formatter.string(from: datePickerView.date)
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        let preVC = self.presentingViewController
        if (beforeController! == "MakeRoomViewController"){
            guard let vc = preVC as? MakeRoomViewController else {return}
            vc.btnDate.setTitle(self.date, for: .normal)
            self.presentingViewController?.dismiss(animated: false, completion:nil)
        }
        else if (beforeController! == "FilterViewController"){
            guard let vc = preVC as? FilterViewController else {return}
            //vc.btnDate.setTitle(self.date, for: .normal)
            self.presentingViewController?.dismiss(animated: false, completion:nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view == self.view) {
                self.dismiss(animated: false, completion: nil)
            }
        }
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
