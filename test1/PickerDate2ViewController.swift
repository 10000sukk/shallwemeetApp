//
//  PickerDate2ViewController.swift
//  test1
//
//  Created by 김환석 on 2020/11/15.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit

class PickerDate2ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    @IBOutlet var viewPickerDate2: UIView!
    let PICKER_VIEW_COLUMN = 1
    let date2_arr = ["상관없음", "3시 즈음", "5시 즈음", "7시 즈음", "9시 즈음"]
    var date2:String = "상관없음"
    var beforeController:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewPickerDate2.clipsToBounds = true
        viewPickerDate2.layer.cornerRadius = 50
        viewPickerDate2.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        
        let ud = UserDefaults.standard
        if let beforeController = ud.string(forKey: "beforeController"){
            self.beforeController = beforeController
        }
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return PICKER_VIEW_COLUMN
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return date2_arr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return date2_arr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        date2 = date2_arr[row]
    }


    @IBAction func btnDone(_ sender: UIButton) {
        let preVC = self.presentingViewController
        if (beforeController! == "MakeRoomViewController"){
            guard let vc = preVC as? MakeRoomViewController else {return}
            vc.btnTotal.setTitle(self.date2, for: .normal)
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
