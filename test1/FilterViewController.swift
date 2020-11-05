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
    
    
    var location1:String = "서울"
    var location2:String = "상관없음"
    var age:String  = "25"
    var total:String = "3"
    var date:String?
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let ud = UserDefaults.standard
        ud.set("상관없음", forKey: "FilterLocation1")
        ud.set("상관없음", forKey: "FilterLocation2")
        ud.set("2 대 2", forKey: "FilterTotal")
        ud.set("25", forKey: "FilterAge")
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        let ud = UserDefaults.standard
        ud.set("false", forKey: "isClickedFilterButton")
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
        let ud = UserDefaults.standard
        let storyboard = UIStoryboard(name: "Picker", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PickerLocation2ViewController") as? PickerLocation2ViewController else {return}
        controller.providesPresentationContextTransitionStyle = true
        controller.definesPresentationContext = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        controller.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        controller.beforeController = "FilterViewController"
        controller.location1 = ud.string(forKey: "filterLocation1")!
        self.present(controller, animated: false, completion: nil)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let ud = UserDefaults.standard
        lblAge.text = "\(Int(sender.value))"
        ud.set(Int(sender.value), forKey:"filterAge")
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
        
        /* UserDefault 저장소를 이용햔 객체 저장 */
        //UserDefault 객체의 인스턴스를 가져온다.
        let ud = UserDefaults.standard
        ud.set(self.age, forKey: "filterAge")
        ud.set(self.location1, forKey: "filterLocaion1")
        ud.set(self.location2, forKey: "filterLocaion2")
        ud.set(self.total, forKey: "filterTotal")
        guard let date  = self.date else{ myAlert("잠깐!", message: "날짜를 설정해 주세요."); return}
        ud.set(date, forKey: "filterDate")
        ud.set("true", forKey: "isClickedFilterButton")
        
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
