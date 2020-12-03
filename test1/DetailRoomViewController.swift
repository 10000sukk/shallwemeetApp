//
//  DetailRoomViewController.swift
//  test1
//
//  Created by 김환석 on 2020/10/17.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit
import Alamofire

class DetailRoomViewController: UIViewController {

    
    @IBOutlet var imgBoard1: UIImageView!
    @IBOutlet var imgBoard2: UIImageView!
    @IBOutlet var imgBoard3: UIImageView!
    @IBOutlet var txtTitle: UILabel!
    @IBOutlet var txtLocation: UILabel!
    @IBOutlet var txtTotal: UILabel!
    @IBOutlet var txtTag: UILabel!
    @IBOutlet var btnStar: UIButton!
    
    var boardIdx:Int?
    var starChecked:Bool?
    var cellIndexPath:IndexPath?
    var beforeController:String?
    
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //backGround Color
        let backGroundColor = MyBackGroundColor()
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = self.view.bounds
        self.gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        self.gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.gradientLayer.colors = [UIColor(red: backGroundColor.startColorRed, green: backGroundColor.startColorGreen, blue: backGroundColor.startColorBlue , alpha: 1).cgColor, UIColor(red: backGroundColor.endColorRed , green: backGroundColor.endColorGreen, blue: backGroundColor.endColorBlue, alpha: 1).cgColor]
        self.view.layer.insertSublayer(self.gradientLayer, at: 0)
        
                
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let url = Config.baseURL + "/api/boards/\(self.boardIdx!)/\(Config.userIdx!)"
        print(url)
        
        AF.request(url, method: .get,encoding: URLEncoding.default,headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
            .responseJSON(){ response in
                switch response.result{
                case .success(let json):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let jsonParsing = try JSONDecoder().decode(DetailBoardParsing.self, from: data)
                        do{
                            let data = try Data(contentsOf: URL(string: jsonParsing.img1)!)
                            self.imgBoard1.image = UIImage(data: data)
                        }
                        catch{
                            self.imgBoard1.image = nil
                        }
                        do{
                            let data = try Data(contentsOf: URL(string: jsonParsing.img2)!)
                            self.imgBoard2.image = UIImage(data: data)
                        }
                        catch{
                            self.imgBoard2.image = nil
                        }
                        do{
                            let data = try Data(contentsOf: URL(string: jsonParsing.img3)!)
                            self.imgBoard3.image = UIImage(data: data)
                        }
                        catch{
                            self.imgBoard3.image = nil
                        }
                        if (jsonParsing.check){
                            self.btnStar.setImage(UIImage(named: "./images/star_fill.png"), for: .normal)
                            self.starChecked = true
                        }else{
                            self.btnStar.setImage(UIImage(named: "./images/star_empty.png"), for: .normal)
                            self.starChecked = false
                        }
                
                        self.txtTitle.text = jsonParsing.title
                        self.txtLocation.text = jsonParsing.location1 + " " + jsonParsing.location2
                        self.txtTag.text = "#\(jsonParsing.tag1) #\(jsonParsing.tag2) #\(jsonParsing.tag3)"
                        self.txtTotal.text = jsonParsing.numType
                        
                    }catch let jsonError{
                        print("Error seriallizing json:",jsonError)
                    }
                    
                    //let response = json as! NSDictionary
                    
                case .failure(let error):
                    print("error: \(String(describing: error))")
                }
                
            }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        let ud = UserDefaults.standard
        if(beforeController == "SearchRoomViewController"){
            ud.set("false", forKey: "isClickedFilterButton")
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btnStar(_ sender: UIButton) {
        //즐겨찾기 추가
        if (!starChecked!){
            let url  = Config.baseURL + "/api/bookmark"
            let PARMS = [
                "userId":Config.userIdx!,
                "boardId":self.boardIdx!
            ]
            AF.request(url, method: .post ,parameters: PARMS , encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
                .responseJSON(){response in
                    switch response.result{
                    case .success(let json):
                        do {
                            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            let jsonParsing = try JSONDecoder().decode(CodeAndMessage.self, from: data)
                            if (jsonParsing.code == 200){
                                self.starChecked = true
                                self.btnStar.setImage(UIImage(named: "./images/star_fill.png"), for: .normal)
                                let preVC = self.presentingViewController
                                if let beforeController = self.beforeController{
                                    if(beforeController == "SearchRoomViewController"){
                                        //이전 게시판에서도 변경사항 적용
                                        guard let vc = preVC as? SearchRoomViewController else {return}
                                        vc.boardChecked[self.cellIndexPath!.row] = true
                                        vc.collectionView.reloadItems(at: [self.cellIndexPath!])
                                    }
                                }
                                
                            }
                        }catch let jsonError{
                            print("Error seriallizing json:",jsonError)
                        }
                    case .failure(let error):
                        print("error: \(String(describing: error))")
                    }
            }
        }
        //즐겨찾기 제거
        else{
            let url  = Config.baseURL + "/api/bookmark/\(Config.userIdx!)/\(boardIdx!)"
            AF.request(url, method: .delete , encoding: URLEncoding.default, headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
                .responseJSON(){response in
                    switch response.result{
                    case .success(let json):
                        do {
                            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            let jsonParsing = try JSONDecoder().decode(CodeAndMessage.self, from: data)
                            if (jsonParsing.code == 200){
                                self.starChecked = false
                                self.btnStar.setImage(UIImage(named: "./images/star_empty.png"), for: .normal)
                                let preVC = self.presentingViewController
                                if let beforeController = self.beforeController{
                                    if(beforeController == "SearchRoomViewController"){
                                        //이전 게시판에서도 변경사항 적용
                                        guard let vc = preVC as? SearchRoomViewController else {return}
                                        vc.boardChecked[self.cellIndexPath!.row] = false
                                        vc.collectionView.reloadItems(at: [self.cellIndexPath!])
                                    }
                                }
                                
                            }
                        }catch let jsonError{
                            print("Error seriallizing json:",jsonError)
                        }
                    case .failure(let error):
                        print("error: \(String(describing: error))")
                    }
            }
            
        }
    }
    
    
    @IBAction func btnRequestMeeting(_ sender: UIButton) {
        
        let url = Config.baseURL + "/api/match"
        var PARMS:Parameters = [
            "boardId":boardIdx!,
            "senderId":Config.userIdx!
        ]
        let alert = UIAlertController(title: "잠깐!", message:"미팅 비용을 지불 하시겠습니까? 비용은 코인 5개 입니다." , preferredStyle: .alert)
        let action1 = UIAlertAction(title: "내가 지불할래요", style: UIAlertAction.Style.default, handler: {action in
            PARMS["status"] = true
            AF.request(url, method: .post, parameters: PARMS, encoding: JSONEncoding.default, headers:["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
                .responseJSON(){response in
                    switch response.result{
                    case .success(let json):
                        do {
                            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            let jsonParsing = try JSONDecoder().decode(CodeAndMessage.self, from: data)
                            if (jsonParsing.code == 200){
                                self.myAlert("알림", message: "요청을 완료 하였습니다! 상대방에게 알림을 성공적으로 보냈습니다")
                            }
                            //이미 신청한 게시판
                            else if(jsonParsing.code == 401){
                                self.myAlert("알림", message: "이미 신청한 게시판 입니다")
                            }
                            //포인트 부족
                            else if (jsonParsing.code == 402){
                                self.myAlert("알림", message: "포인트가 부족하시군요")
                            }
                            //내가 만든 게시판 일 경우에
                            else if (jsonParsing.code == 403){
                                self.myAlert("알림", message: "자신의 게시판 입니다")
                            }
                        }catch let jsonError{
                            print("Error seriallizing json:",jsonError)
                        }
                    case .failure(let error):
                        print("error: \(String(describing: error))")
                    }
                    
                }
        })
        let action2 = UIAlertAction(title: "아니요, 상대방이 내는게 좋겠어요", style: UIAlertAction.Style.default, handler: {action in
            PARMS["status"] = false
            AF.request(url, method: .post, parameters: PARMS, encoding: JSONEncoding.default, headers:["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
                .responseJSON(){response in
                    switch response.result{
                    case .success(let json):
                        do {
                            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            let jsonParsing = try JSONDecoder().decode(CodeAndMessage.self, from: data)
                            if (jsonParsing.code == 200){
                                self.myAlert("알림", message: "요청을 완료 하였습니다! 상대방에게 지불요청을 보냈습니다.")
                            }
                            //이미 신청한 게시판
                            else if(jsonParsing.code == 401){
                                self.myAlert("알림", message: "이미 신청한 게시판 입니다")
                            }
                            //포인트 부족
                            else if (jsonParsing.code == 402){
                                self.myAlert("알림", message: "포인트가 부족하시군요")
                            }
                            //내가 만든 게시판 일 경우에
                            else if (jsonParsing.code == 403){
                                self.myAlert("알림", message: "자신의 게시판 입니다")
                            }
                        }catch let jsonError{
                            print("Error seriallizing json:",jsonError)
                        }
                    case .failure(let error):
                        print("error: \(String(describing: error))")
                    }
                    
                }
        })
        let action3 = UIAlertAction(title: "취소", style: UIAlertAction.Style.destructive, handler: {action in
            return
        })
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        self.present(alert, animated: true, completion: {
            print(PARMS)
        })
        
        
        
        
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
