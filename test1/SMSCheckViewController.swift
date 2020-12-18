//
//  SMSCheckViewController.swift
//  test1
//
//  Created by 김환석 on 2020/12/09.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit
import Alamofire

class SMSCheckViewController: UIViewController {

    @IBOutlet var txtPhoneNumber: UITextField!
    @IBOutlet var txtSMSNumber: UITextField!
    
    @IBOutlet var stackViewSMSNumber: UIStackView!
    @IBOutlet var btnCheckSMSNumber: UIButton!
    
    //폰넘버 인증메세지확인 버튼 누를시에 기존값과 확인을 위한것
    var phoneNumber:String?
    
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backGroundColor = MyBackGroundColor()
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = self.view.bounds
        self.gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        self.gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.gradientLayer.colors = [UIColor(red: backGroundColor.startColorRed, green: backGroundColor.startColorGreen, blue: backGroundColor.startColorBlue , alpha: 1).cgColor, UIColor(red: backGroundColor.middleColorRed, green: backGroundColor.middleColorGreen, blue: backGroundColor.middleColorBlue, alpha: 1).cgColor ,UIColor(red: backGroundColor.endColorRed , green: backGroundColor.endColorGreen, blue: backGroundColor.endColorBlue, alpha: 1).cgColor]
        //[UIColor(displayP3Red: 255/255, green: 222/255, blue: 220/255, alpha: 0) , UIColor(displayP3Red: 211/255, green: 238/255, blue: 249/255, alpha: 0)]
        self.view.layer.insertSublayer(self.gradientLayer, at: 0)
        
        
        self.stackViewSMSNumber.isHidden = true
        self.btnCheckSMSNumber.isHidden = true
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSendSMS(_ sender: UIButton) {
        guard let phoneNumber = self.txtPhoneNumber.text, !phoneNumber.isEmpty else{myAlert("잠깐", message: "전화번호를 확인해주세요"); return}
        
        let url = Config.baseURL + "/api/check/sendSMS"
        
        let PARMS:Parameters = [
            "phone": phoneNumber
        ]
        
        AF.request(url, method: .get, parameters: PARMS,encoding: URLEncoding.default, headers:["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
            .responseJSON(){ response in
                switch response.result{
                case .success(let json):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let jsonParsing = try JSONDecoder().decode(CodeAndMessage.self, from: data)
                        if(jsonParsing.code == 200){
                            self.myAlert("알림", message: "인증번호를 전송하였습니다. 아래에 입력 바랍니다")
                            self.stackViewSMSNumber.isHidden = false
                            self.btnCheckSMSNumber.isHidden = false
                            self.phoneNumber = phoneNumber
                        }
                        else{
                            self.myAlert("전송실패", message: "전화번호를 다시 확인하여 주세요")
                        }
                        
                    }catch let jsonError{
                        print("Error seriallizing json:",jsonError)
                    }
                case .failure(let error):
                    print("error: \(String(describing: error))")
                }
            
        }
    }
    
    @IBAction func btnCheckSMSNumber(_ sender: UIButton) {
        guard let smsNumber = self.txtSMSNumber.text, !smsNumber.isEmpty else{myAlert("잠깐", message: "인증번호를 확인하여 주세요"); return}
        let url = Config.baseURL + "/api/check/checkSMS"
        
        let PARMS:Parameters = [
            "token": smsNumber
        ]
        
        AF.request(url, method: .get, parameters: PARMS,encoding: URLEncoding.default, headers:["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
            .responseJSON(){ response in
                switch response.result{
                case .success(let json):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let jsonParsing = try JSONDecoder().decode(CodeAndMessage.self, from: data)
                        if(jsonParsing.code == 200){
                            let alert = UIAlertController(title: "인증성공", message: "프로필 입력 단계로 이동합니다", preferredStyle: .alert)
                            let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler:{action in
                                if let phoneNumber = self.phoneNumber{
                                    Config.phoneNumber = phoneNumber
                                }
                                let controller = self.storyboard?.instantiateViewController(identifier: "EditProfileViewController")
                                controller?.modalPresentationStyle = .fullScreen
                                self.present(controller!, animated: true, completion: nil)
                            })
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }catch let jsonError{
                        print("Error seriallizing json:",jsonError)
                    }
                case .failure(let error):
                    print("error: \(String(describing: error))")
                }
            
        }
        
    }
    
    
    
    func myAlert(_ title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //화면 터치시 키보드 내려가는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
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
