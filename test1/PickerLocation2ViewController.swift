//
//  PickerLocation2ViewController.swift
//  test1
//
//  Created by 김환석 on 2020/11/04.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit

class PickerLocation2ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet var viewPickerLocation2: UIView!
    

    let PICKER_VIEW_COLUMN = 1
    let location2_arr = [
        ["상관없음","건대입구","홍대입구","신촌","강남역","이태원","인사동","종로"],
        ["상관없음","상무지구","구시청","전대후문"]
    ]
    var location2:String?
    
    var location1:String?
    var beforeController:String?
    var statusNum:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPickerLocation2.clipsToBounds = true
        viewPickerLocation2.layer.cornerRadius = 50
        viewPickerLocation2.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        location2 = "상관없음"
        
        
        // Do any additional setup after loading the view.
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let location1 = location1{
            switch location1 {
            case "서울":
                statusNum = 0
            case "광주":
                statusNum = 1
            default:
                statusNum = 0
            }
        }
        else{
            statusNum = 0
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return PICKER_VIEW_COLUMN
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return location2_arr[statusNum!].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return location2_arr[statusNum!][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        location2 = location2_arr[statusNum!][row]
    }
    
    
    
    @IBAction func btnDone(_ sender: UIButton) {
        
        let preVC = self.presentingViewController
        if (beforeController! == "MakeRoomViewController"){
            guard let vc = preVC as? MakeRoomViewController else {return}
            vc.btnLocation2.setTitle(self.location2, for: .normal)
            self.presentingViewController?.dismiss(animated: false, completion:nil)
        }
        else if(beforeController! == "FilterViewController"){
            guard let vc = preVC as? FilterViewController else {return}
            vc.btnLocation2.setTitle(self.location2, for: .normal)
            self.presentingViewController?.dismiss(animated: false, completion:nil)
        }
        else if(beforeController! == "ReviseProfileViewController"){
            guard let vc = preVC as? ReviseProfileViewController else {return}
            vc.btnLocation2.setTitle(self.location2, for: .normal)
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
