//
//  RecievedRequestDetailViewController.swift
//  test1
//
//  Created by 김환석 on 2020/12/09.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit
import Alamofire

class RecievedRequestDetailViewController: UIViewController {

    @IBOutlet var viewOtherUserDetail: UIView!
    @IBOutlet var imgOtherUserPhoto: UIImageView!
    @IBOutlet var lblOtherUserNickName: UILabel!
    @IBOutlet var lblOtherUserAge: UILabel!
    
    var otherUserIdx:Int?
    var isPaid:Bool?
    var boardIdx:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewOtherUserDetail.clipsToBounds = true
        viewOtherUserDetail.layer.cornerRadius = 5
        viewOtherUserDetail.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        
        let url = Config.baseURL + "/api/users/\(otherUserIdx!)"
        
        AF.request(url, method: .get ,encoding: URLEncoding.default,headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
            .responseJSON(){response in
                switch response.result{
                case .success(let json):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let jsonParsing = try JSONDecoder().decode(UserParsing.self, from: data)
                        do{
                            let data = try Data(contentsOf: URL(string: jsonParsing.img)!)
                            self.imgOtherUserPhoto.image = UIImage(data: data)
                        }
                        catch{
                            self.imgOtherUserPhoto.image = nil
                        }
                        self.lblOtherUserNickName.text = "   " + jsonParsing.nickName
                        self.lblOtherUserAge.text = "   " + jsonParsing.age
                        
                    }catch let jsonError{
                        print("Error seriallizing json:",jsonError)
                    }
                    
                    //let response = json as! NSDictionary
                    
                case .failure(let error):
                    print("error: \(String(describing: error))")
                }
                
            }

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAceptRequest(_ sender: UIButton) {
        guard let isPaid = self.isPaid else{return}
        if(isPaid){
            let alertAcept = UIAlertController(title: "수락", message: "요청을 수락하시겠습니까? 이미 결제된 요청입니다.", preferredStyle: .alert)
            let actionAcept = UIAlertAction(title: "예", style: UIAlertAction.Style.default, handler: {action in
                let url = Config.baseURL + "/api/match"
                let PARMS:Parameters = [
                    "boardId":self.boardIdx!,
                    "senderId":self.otherUserIdx!
                ]
                AF.request(url, method: .patch , parameters: PARMS, encoding: JSONEncoding.default,headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
                    .responseJSON(){response in
                        switch response.result{
                        case .success(let json):
                            do {
                                let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                                let jsonParsing = try JSONDecoder().decode(CodeAndMsg.self, from: data)
                                
                                if(jsonParsing.code == 200){
                                    let alert = UIAlertController(title: "알림", message: "매칭이 성사되었습니다.", preferredStyle: .alert)
                                    let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {action in
                                        self.dismiss(animated: false, completion: nil)
                                    })
                                    alert.addAction(action)
                                    self.present(alert, animated: true, completion: nil)
                                }
                                else if(jsonParsing.code == 400){
                                    self.myAlert("실패", message: "이미 성사된 매칭이 있는 방입니다")
                                }
                                
                            }catch let jsonError{
                                print("Error seriallizing json:",jsonError)
                            }
                            
                            //let response = json as! NSDictionary
                            
                        case .failure(let error):
                            print("error: \(String(describing: error))")
                        }
                        
                    }
            })
            let actionNo = UIAlertAction(title: "아니요", style: UIAlertAction.Style.destructive, handler: nil)
            alertAcept.addAction(actionAcept)
            alertAcept.addAction(actionNo)
            self.present(alertAcept, animated: true, completion: nil)
            
            
        }
        else{
            let alertAcept = UIAlertController(title: "수락", message: "요청을 수락하시겠습니까? 결제에 1 포인트가 소진됩니다", preferredStyle: .alert)
            let actionAcept = UIAlertAction(title: "예", style: UIAlertAction.Style.default, handler: {action in
                let url = Config.baseURL + "/api/match/payment"
                let PARMS:Parameters = [
                    "boardId":self.boardIdx!,
                    "senderId":self.otherUserIdx!
                ]
                AF.request(url, method: .patch, parameters: PARMS, encoding: JSONEncoding.default,headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
                    .responseJSON(){response in
                        switch response.result{
                        case .success(let json):
                            do {
                                let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                                let jsonParsing = try JSONDecoder().decode(CodeAndMsg.self, from: data)
                                
                                if(jsonParsing.code == 200){
                                    let alert = UIAlertController(title: "알림", message: "매칭이 성사되었습니다.", preferredStyle: .alert)
                                    let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {action in
                                        self.dismiss(animated: false, completion: nil)
                                    })
                                    alert.addAction(action)
                                    self.present(alert, animated: true, completion: nil)
                                }
                                else if(jsonParsing.code == 400){
                                    self.myAlert("실패", message: "이미 결제된 요청입니다")
                                }
                                else if(jsonParsing.code == 401){
                                    self.myAlert("실패", message: "이미 성사된 게시판 입니다")
                                }
                                else if(jsonParsing.code == 402){
                                    self.myAlert("실패", message: "포인트가 부족합니다")
                                }
                                
                            }catch let jsonError{
                                print("Error seriallizing json:",jsonError)
                            }
                            
                            //let response = json as! NSDictionary
                            
                        case .failure(let error):
                            print("error: \(String(describing: error))")
                        }
                        
                    }
            })
            let actionNo = UIAlertAction(title: "아니요", style: UIAlertAction.Style.destructive, handler: nil)
            alertAcept.addAction(actionAcept)
            alertAcept.addAction(actionNo)
            self.present(alertAcept, animated: true, completion: nil)
        }
            
        
    }
    func myAlert(_ title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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

