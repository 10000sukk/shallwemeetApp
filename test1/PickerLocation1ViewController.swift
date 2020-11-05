//
//  PickerLocation1ViewController.swift
//  test1
//
//  Created by 김환석 on 2020/11/04.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit

class PickerLocation1ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var viewPickerLocation1: UIView!
    
    
    let MAX_ARRAY_NUM = 2
    let PICKER_VIEW_COLUMN = 1
    let location1_arr = ["상관없음","서울특별시", "광주광역시"]
    var location1:String = "상관없음"
    
    var beforeController:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPickerLocation1.clipsToBounds = true
        viewPickerLocation1.layer.cornerRadius = 50
        viewPickerLocation1.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner)

        // Do any additional setup after loading the view.
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return PICKER_VIEW_COLUMN
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return location1_arr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return location1_arr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        location1 = location1_arr[row]
    }
    
    
    
    @IBAction func btnDone(_ sender: UIButton) {
        
        let preVC = self.presentingViewController
        
        if (beforeController! == "MakeRoomViewController"){
            let ud = UserDefaults.standard
            ud.set(self.location1, forKey: "makeRoomLocation1")
            ud.set("상관없음", forKey: "makeRoomLocation2")
            guard let vc = preVC as? MakeRoomViewController else {return}
            vc.btnLocation1.setTitle(self.location1, for: .normal)
            vc.btnLocation2.setTitle("상관없음", for: .normal)
            self.presentingViewController?.dismiss(animated: false, completion:nil)
        }
        else if(beforeController! == "FilterViewController"){
            let ud = UserDefaults.standard
            ud.set(self.location1, forKey: "filterLocation1")
            ud.set("상관없음", forKey: "filterLocation2")
            guard let vc = preVC as? FilterViewController else {return}
            vc.btnLocation1.setTitle(self.location1, for: .normal)
            vc.btnLocation2.setTitle("상관없음", for: .normal)
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
