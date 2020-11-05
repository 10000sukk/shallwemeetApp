//
//  LoginViewController.swift
//  test1
//
//  Created by 김환석 on 2020/10/03.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit
import SafariServices
import Alamofire
import KakaoSDKAuth
import KakaoSDKUser



class LoginViewController: UIViewController {

    
    
    @IBOutlet var txtID: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func btnLogin(_ sender: UIButton){
        guard let username = txtID.text, !username.isEmpty else { return } // 예외 처리 : Textfield가 빈문자열이 아니고, nil이 아닐 때
        guard let password = txtPassword.text, !password.isEmpty else { return }
        


        //접근하고자 하는 URL 정보
        let URL = Config.baseURL+"/users/login"
        //전송할 파라미터 정보
        let PARAM:Parameters = [
            "email":username,
            "password":password
        ]
        
        

        //위의 URL와 파라미터를 담아서 POST 방식으로 통신하며, statusCode가 200번대(정상적인 통신) 인지 유효성 검사 진행
        let alamo = AF.request(URL, method:.post, parameters: PARAM, encoding: JSONEncoding.default, headers:["Content-Type":"application/json"]).validate(statusCode: 200..<300)
        print(alamo)
        alamo.responseString(){response in
            print(response)
            switch response.result{
            case .success(let value):
                if value == "성공"{
                    let controller = self.storyboard?.instantiateViewController(identifier: "EditProfileController")
                    controller!.modalPresentationStyle = .fullScreen
                    self.present(controller!, animated: true, completion: nil)
                }
                else{
                    let alert = UIAlertController(title: "실패", message: "아이디 또는 비밀번호를 다시 확인해주세요.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "계속", style: .default, handler: nil)

                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            case .failure(let error):
                print("error: \(String(describing: error))")
            }
        }
    }
    
    @IBAction func btnLoginKakao(_ sender: UIButton) {
        
//        // 시뮬레이터에 카카오가 깔려 있어야 가능하다.
//        // 카카오톡 설치 여부 확인
//          if (AuthApi.isKakaoTalkLoginAvailable()) {
//            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
//            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
//                if let error = error {
//                    // 예외 처리 (로그인 취소 등)
//                    print(error)
//                }
//                else {
//                    print("loginWithKakaoTalk() success.")
//                   // do something
//                    _ = oauthToken
//                   // 어세스토큰
//                   let accessToken = oauthToken?.accessToken
//
//                    //카카오 로그인을 통해 사용자 토큰을 발급 받은후에 사용자 관리 API 호출
//                    self.setUserInfo()
//                }
//            }
//          }
        
        //시뮬레이터에 카카오가 없는 관걔로 대체 코드
        AuthApi.shared.loginWithKakaoAccount {(oauthToken, error) in
           if let error = error {
             print(error)
           }
           else {
            print("loginWithKakaoAccount() success!!!!!!!!!1.")
            
            //do something
            _ = oauthToken
            
            // 어세스토큰
            let accessToken = oauthToken?.accessToken
            print("엑세스 토큰")
            print(accessToken)
            
            //카카오 로그인을 통해 사용자 토큰을 발급 받은 후 사용자 관리 API 호출
            self.setUserInfo()
           }
        }
        
    }
    
    
    func setUserInfo(){
        //사용자 관리 api 호출
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
        //do something
                _ = user
                var kakaoEmail:String?
                var kakaoGender:String?
                
                if let email = user?.kakaoAccount?.email{
                    kakaoEmail = email
                }
                
                if let gender  = user?.kakaoAccount?.gender{
                    kakaoGender = gender.rawValue
                }
                print("email: \(kakaoEmail)")
                print("gender: \(kakaoGender)")
                
                let PARAM:Parameters = [
                    "email": kakaoEmail]
                
//                guard let url = URL(string: Config.baseURL+":8080/api/users/login") else{
//                    return
//                }
//
 
                let url = Config.baseURL+"/api/users/login"

                
                let alamo = AF.request(url, method: .post, parameters: PARAM, encoding: JSONEncoding.default, headers:["Content-Type":"application/json"]).validate(statusCode: 200..<300)
                print(alamo)
                alamo.responseJSON{reponse in
                    print("------response-----")
                    print(reponse)
                    switch reponse.result{
                    case .success(let json):
                        //let response = JSON as! NSDictionary
                        print("response 받아옴!!!!!!!!!")
                        let response = json as! NSDictionary
                        print(response)
                        
                        //신규 유저라면 프로필 만들기 화면으로
                        if(response.object(forKey: "_checked") as! Int == 0){
                            Config.userEmail = kakaoEmail
                            let controller = self.storyboard?.instantiateViewController(identifier: "EditProfileViewController")
                            controller!.modalPresentationStyle = .fullScreen
                            self.present(controller!, animated: true, completion: nil)
                        }
                        //이미 존재하는 유저일 경우 바로 홈으로
                        else{
                            Config.userIdx = response.object(forKey: "idx") as? Int
                            let controller = self.storyboard?.instantiateViewController(identifier: "MainTabBarViewController")
                            controller!.modalPresentationStyle = .fullScreen
                            self.present(controller!, animated: true, completion: nil)
                        }
                        
                        
                        
                        
                    case .failure(let error):
                        print("실패\n")
                        print("error: \(String(describing: error))")
                    }
                    
                }
                
                
                
                
                
                
            }
        }
    }
    
    //화면 터치시 키보드 내림
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
