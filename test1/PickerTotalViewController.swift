//
//  PickerTotalViewController.swift
//  test1
//
//  Created by 김환석 on 2020/11/04.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit

class PickerTotalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet var viewPickerTotal: UIView!
    
    let PICKER_VIEW_COLUMN = 1
    let total_arr = ["2 대 2", "3 대 3", "4 대 4", "5 대 5", "6 대 6"]
    var total:String = "2 대 2"
    var beforeController:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPickerTotal.clipsToBounds = true
        viewPickerTotal.layer.cornerRadius = 50
        viewPickerTotal.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        
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
        return total_arr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return total_arr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        total = total_arr[row]
    }
    @IBAction func btnDone(_ sender: UIButton) {
        let preVC = self.presentingViewController
        if (beforeController! == "MakeRoomViewController"){
            let ud = UserDefaults.standard
            ud.set(self.total, forKey: "makeRoomTotal")
            guard let vc = preVC as? MakeRoomViewController else {return}
            vc.btnTotal.setTitle(self.total, for: .normal)
            self.presentingViewController?.dismiss(animated: false, completion:nil)
        }
        else if (beforeController! == "FilterViewController"){
            let ud = UserDefaults.standard
            ud.set(self.total, forKey: "filterTotal")
            guard let vc = preVC as? FilterViewController else {return}
            vc.btnTotal.setTitle(self.total, for: .normal)
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
