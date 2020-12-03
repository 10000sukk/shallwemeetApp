//
//  MyPageViewController.swift
//  test1
//
//  Created by 김환석 on 2020/10/10.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit
import Alamofire

class MyPageViewController: UIViewController {

    
    @IBOutlet var imgProfilePhoto: UIImageView!
    @IBOutlet var lblNickName: UILabel!
    @IBOutlet var lblKakaoID: UILabel!
    @IBOutlet var lblAge: UILabel!
    @IBOutlet var lblGender: UILabel!
    @IBOutlet var lblMyLocation1: UILabel!
    @IBOutlet var lblMyLocation2: UILabel!
    @IBOutlet var lblMyPoint: UILabel!
    
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
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let url = Config.baseURL + "/api/users/\(Config.userIdx!)"
        
        AF.request(url, method: .get ,encoding: URLEncoding.default,headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
            .responseJSON(){response in
                switch response.result{
                case .success(let json):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let jsonParsing = try JSONDecoder().decode(UserParsing.self, from: data)
                        do{
                            let data = try Data(contentsOf: URL(string: jsonParsing.img)!)
                            self.imgProfilePhoto.image = UIImage(data: data)
                        }
                        catch{
                            self.imgProfilePhoto.image = nil
                        }
                        self.lblNickName.text = jsonParsing.nickName
                        self.lblKakaoID.text = jsonParsing.kakaoID
                        self.lblAge.text = jsonParsing.age
                        self.lblGender.text = jsonParsing.gender
                        self.lblMyLocation1.text = jsonParsing.location1
                        self.lblMyLocation2.text = jsonParsing.location2
                        self.lblMyPoint.text = "\(jsonParsing.point)"
                        
                    }catch let jsonError{
                        print("Error seriallizing json:",jsonError)
                    }
                    
                    //let response = json as! NSDictionary
                    
                case .failure(let error):
                    print("error: \(String(describing: error))")
                }
                
            }
    }
    

    @IBAction func btnChargingPoint(_ sender: UIButton) {
    }
    
    @IBAction func btnReviseProfile(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(identifier: "ReviseProfileViewController") as?
                ReviseProfileViewController else{ return}
        if let imgProfilePhoto = self.imgProfilePhoto.image{
            controller.tmpImage = imgProfilePhoto
        }
        if let nickName = self.lblNickName.text{
            controller.nickName = nickName
        }
        if let location1 = self.lblMyLocation1.text{
            controller.location1 = location1
        }
        if let location2 = self.lblMyLocation2.text{
            controller.location2 = location2
        }
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
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
