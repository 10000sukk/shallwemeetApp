//
//  EditProfileViewController.swift
//  test1
//
//  Created by 김환석 on 2020/10/08.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate {

    @IBOutlet var imgProfileImage: UIImageView!
    @IBOutlet var lblProfiletext: UILabel!
    @IBOutlet var txtNickname: UITextField!
    @IBOutlet var txtUserAge: UITextField!
    @IBOutlet var segGender: UISegmentedControl!
    @IBOutlet var btnLocation1: UIButton!
    @IBOutlet var btnLocation2: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    //유저정보
    var userID:String?
    var userPw:String?
    
    //확인용도
    var isPhoto:Bool?
    var isfinished:Bool?
    
    //카메라 사용 변수
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var flagImageSave = false
    var imageUrl:URL?
    
    var keyboardShown:Bool = false // 키보드 상태 확인
    var originY:CGFloat? // 오브젝트의 기본 위치
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isfinished = false
        
        //탭시에 키보드 내리기 위한 전처리
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
        //이미지 터치를 위한 전처리
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchToPickPhoto))
        imgProfileImage.addGestureRecognizer(tapGesture)
        imgProfileImage.isUserInteractionEnabled = true

        //txtUserpwcheck.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    
    
    //화면 터치시 키보드 내려가는 함수
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
            self.view.endEditing(true)
        }
    
    // Move view 150 points upward
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -100
       }

    
    // Move view to original position
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
        }

    
    
    @IBAction func btnLocation1(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Picker", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PickerLocation1ViewController") as? PickerLocation1ViewController else {return}
        controller.providesPresentationContextTransitionStyle = true
        controller.definesPresentationContext = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        controller.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        controller.beforeController = "EditProfileViewController"
        self.present(controller, animated: false, completion: nil)
    }
    
    @IBAction func btnLocation2(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Picker", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PickerLocation2ViewController") as? PickerLocation2ViewController else {return}
        controller.providesPresentationContextTransitionStyle = true
        controller.definesPresentationContext = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        controller.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        controller.beforeController = "EditProfileViewController"
        controller.location1 = self.btnLocation1.titleLabel?.text!
        self.present(controller, animated: false, completion: nil)
    }
    
    
    @IBAction func btnDone(_ sender: UIButton) {
        if (isPhoto != true){
            myAlert("확인", message: "사진을 올려 주세요")
            return
        }
        guard let userNickname = txtNickname.text, !userNickname.isEmpty else { myAlert("확인", message: "닉네임을 입력해 주세요!"); return }
        guard let userAge = txtUserAge.text, !userAge.isEmpty else { myAlert("확인", message: "나이를 입력해 주세요!"); return }
        guard let location1 = btnLocation1.titleLabel?.text, !location1.isEmpty else{return}
        guard let location2 = btnLocation2.titleLabel?.text, !location2.isEmpty else{return}
        // 예외 처리 : Textfield가 빈문자열이 아니고, nil이 아닐 때
        var gender:String?
        if(self.segGender.selectedSegmentIndex == 0){
            gender = "female"
        }
        else{
            gender = "male"
        }
        
//        //탭바로 이동
//        let tb = self.storyboard?.instantiateViewController(identifier: "MainTabBarViewController")
//        tb?.modalPresentationStyle = .fullScreen
//        present(tb!, animated: true, completion: nil)
        
        let URL = Config.baseURL+"/api/users"
    

        //전송할 파라미터 정보
        let parameters:Parameters = [
            "nickName":userNickname,
            "age":userAge as String ,
            "email":Config.userEmail!,
            "location1": location1,
            "location2": location2,
            "token": Config.fcmToken!,
            "phone":Config.phoneNumber!,
            "gender":gender!
        ]
        
        
        guard let imageData = captureImage!.jpegData(compressionQuality: 0.2) else {
            print("Could not get JPEG representation of UIImage")
            return
          }
        print(imageData)
        
       
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key, mimeType: "text/plain")
            }
            multipartFormData.append(imageData, withName: "img",fileName: "edit.jpg", mimeType: "image/jpeg")
        }, to: URL, method: .post, headers: ["Content-Type": "multipart/form-data"]).validate(statusCode: 200..<300)
        .responseJSON{reponse in
            switch reponse.result{
            case .success(let json):
                let response = json as! NSDictionary
                print(response)
                
                if (response.object(forKey: "code") as! Int == 200){
                    Config.userIdx = (response.object(forKey: "idx") as! Int)
                    let tb = self.storyboard?.instantiateViewController(identifier: "MainTabBarViewController")
                    tb?.modalPresentationStyle = .fullScreen
                    self.present(tb!, animated: true, completion: nil)
                }
                
            case .failure(let error):
                print("error: \(String(describing: error))")
            }
        }
        
        
        
        
        
        
        
        
    }
    
    @objc func touchToPickPhoto(){
        let alert = UIAlertController(title: nil, message: "choose option", preferredStyle: UIAlertController.Style.actionSheet)
        let action1 = UIAlertAction(title: "사진 촬영", style: .default, handler: { ACTION in
            if (UIImagePickerController.isSourceTypeAvailable(.camera)){
                self.flagImageSave = true
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.imagePicker.mediaTypes = [kUTTypeImage as String]
                self.imagePicker.allowsEditing = false
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            else{
                self.myAlert("카메라를 열 수 없습니다.", message: "어플에 권한이 없습니다.")
            }
        })
        
        let action2 = UIAlertAction(title: "라이브러리에서 선택", style: .default, handler: { ACTION in
            if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                self.flagImageSave = false
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.mediaTypes = [kUTTypeImage as String]
                self.imagePicker.allowsEditing = true
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            else{
                self.myAlert("앨범을 열수가 없습니다.", message: "어플에 권한이 없습니다.")
            }
        })
        
        let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
        if mediaType.isEqual(to: kUTTypeImage as NSString as String){
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            if self.flagImageSave {
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
            }
            //imageUrl = info[UIImagePickerController.InfoKey.imageURL] as! URL
            imgProfileImage.image = captureImage
            isPhoto = true
            lblProfiletext.text = "닉네임과 나이를 입력후 완료를 눌러 주세요."
            print("isPhoto: ", isPhoto!)
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
     
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         self.dismiss(animated: true, completion: nil)
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
