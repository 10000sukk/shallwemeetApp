//
//  ReviseProfileViewController.swift
//  test1
//
//  Created by 김환석 on 2020/11/19.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire

class ReviseProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imgProfilePhoto: UIImageView!
    @IBOutlet var txtNickName: UITextField!
    @IBOutlet var btnLocation1: UIButton!
    @IBOutlet var btnLocation2: UIButton!
    
    var location1:String?
    var location2:String?
    var nickName:String?
    var tmpImage:UIImage?

    //카메라 사용 변수
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var flagImageSave = false
    var imageUrl:URL?
    
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
        
        //탭시에 키보드 내리기 위한 전처리
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)

        //이미지 터치를 위한 전처리
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchToPickPhoto))
        imgProfilePhoto.addGestureRecognizer(tapGesture)
        imgProfilePhoto.isUserInteractionEnabled = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let location1 = self.location1{
            self.btnLocation1.setTitle(location1, for: .normal)
        }
        if let location2 = self.location2{
            self.btnLocation2.setTitle(location2, for: .normal)
        }
        if let nickName = self.nickName{
            self.txtNickName.insertText(nickName)
        }
        if let image = self.tmpImage{
            self.imgProfilePhoto.image = image
        }
        
    }
    
    @IBAction func btnLocation1(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Picker", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PickerLocation1ViewController") as? PickerLocation1ViewController else {return}
        controller.providesPresentationContextTransitionStyle = true
        controller.definesPresentationContext = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        controller.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        controller.beforeController = "ReviseProfileViewController"
        self.present(controller, animated: false, completion: nil)
    }
    @IBAction func btnLocation2(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Picker", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PickerLocation2ViewController") as? PickerLocation2ViewController else {return}
        controller.providesPresentationContextTransitionStyle = true
        controller.definesPresentationContext = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        controller.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        controller.beforeController = "ReviseProfileViewController"
        controller.location1 = self.btnLocation1.titleLabel?.text!
        self.present(controller, animated: false, completion: nil)
    }
    @IBAction func btnDone(_ sender: UIButton) {
        let alert = UIAlertController(title: "확인", message: "프로필을 수정 하시겠습니까?", preferredStyle: .alert)
        let action = UIAlertAction(title: "네, 수정하겠습니다", style: .default, handler: { action in
            
            guard self.txtNickName.text != nil else{
                self.myAlert("잠깐!", message: "닉네임을 입력해 주세요")
                return
            }
            
            let URL = Config.baseURL+"/api/users" + "/\(Config.userIdx!)"
        

            //전송할 파라미터 정보
            let PARAMS:Parameters = [
                "nickName":self.txtNickName.text!,
                "location1": self.btnLocation1.titleLabel!.text!,
                "location2": self.btnLocation2.titleLabel!.text!
            ]
            
            guard let imageData = self.imgProfilePhoto.image!.jpegData(compressionQuality: 0.2) else {
                print("Could not get JPEG representation of UIImage")
                return
              }
            
            AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in PARAMS {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key, mimeType: "text/plain")
                }
                multipartFormData.append(imageData, withName: "img",fileName: "edit.jpg", mimeType: "image/jpeg")
            }, to: URL, method: .patch, headers: ["Content-Type": "multipart/form-data"]).validate(statusCode: 200..<300)
            .responseJSON{reponse in
                switch reponse.result{
                case .success(let json):
                    let response = json as! NSDictionary
                    print(response)
                    
                    if (response.object(forKey: "code") as! Int == 200){
                        let alertSuccess = UIAlertController(title: "성공", message:"내 정보 수정을 완료하였습니다", preferredStyle: .alert)
                        let actionOK = UIAlertAction(title: "확인", style: .default, handler: {action in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alertSuccess.addAction(actionOK)
                        self.present(alertSuccess, animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    print("error: \(String(describing: error))")
                }
            }
        })
        let cancle = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        alert.addAction(action)
        alert.addAction(cancle)
        present(alert, animated: true, completion: nil)
       
        
    }
    @IBAction func btnBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //화면 터치시 키보드 내려가는 함수
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
            self.view.endEditing(true)
        }
    
    //사진
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
            imgProfilePhoto.image = captureImage
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
