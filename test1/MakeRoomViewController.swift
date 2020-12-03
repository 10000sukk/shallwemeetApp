//
//  MakeRoomViewController.swift
//  test1
//
//  Created by 김환석 on 2020/10/15.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire

class MakeRoomViewController: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate  {

    @IBOutlet weak var scrollView1: UIScrollView!
    @IBOutlet var imgForMeeting1: UIImageView!
    @IBOutlet var imgForMeeting2: UIImageView!
    @IBOutlet var imgForMeeting3: UIImageView!
    @IBOutlet var txtTitle: UITextField!
    @IBOutlet var btnLocation1: UIButton!
    @IBOutlet var btnLocation2: UIButton!
    @IBOutlet var lblAge: UILabel!
    @IBOutlet var slideAge: UISlider!
    @IBOutlet var btnTotal: UIButton!
    @IBOutlet var txtTag1: UITextField!
    @IBOutlet var txtTag2: UITextField!
    @IBOutlet var txtTag3: UITextField!
    
    //카메라 사용 변수
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var flagImageSave = false
    var imageUrl:URL?
    
    var keyboardShown:Bool = false // 키보드 상태 확인
    var originY:CGFloat? // 오브젝트의 기본 위치
    
    var isPhoto:[Bool] = [false, false, false]
    
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
        
        //스크롤뷰 터치 먹히기 위한 전처리
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView1.addGestureRecognizer(singleTapGestureRecognizer)
        
        //이미지 터치를 위한 전처리
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(touchImg1))
        imgForMeeting1.addGestureRecognizer(tapGesture1)
        imgForMeeting1.isUserInteractionEnabled = true
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(touchImg2))
        imgForMeeting2.addGestureRecognizer(tapGesture2)
        imgForMeeting2.isUserInteractionEnabled = true
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(touchImg3))
        imgForMeeting3.addGestureRecognizer(tapGesture3)
        imgForMeeting3.isUserInteractionEnabled = true
        
        
        
        


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    
    }
    

    //화면 터치시 키보드 내려가는 함수
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
            self.view.endEditing(true)
        }
    
    
    
    @objc func touchImg1(){
        isPhoto[0] = true
        touchToPickPhoto()
    }
    
    @objc func touchImg2(){
        isPhoto[1] = true
        touchToPickPhoto()
    
    }
    
    @objc func touchImg3(){
        isPhoto[2] = true
        touchToPickPhoto()
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
            for i in 0 ..< 3{
                print(isPhoto)
                if (self.isPhoto[i]){
                    if(i == 0){
                        imgForMeeting1.image = captureImage
                        isPhoto[i] = false
                    }
                    else if(i == 1){
                        imgForMeeting2.image = captureImage
                        isPhoto[i] = false
                    }
                    else if(i == 2){
                        imgForMeeting3.image = captureImage
                        isPhoto[i] = false
                    }
                    else{
                        print("what the fuck")
                    }
                }
            }
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
     
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         self.dismiss(animated: true, completion: nil)
     }
    
    
    

    @IBAction func btnBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btnLocation1(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Picker", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PickerLocation1ViewController") as? PickerLocation1ViewController else {return}
        controller.providesPresentationContextTransitionStyle = true
        controller.definesPresentationContext = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        controller.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        controller.beforeController = "MakeRoomViewController"
        self.present(controller, animated: false, completion: nil)
        
    }
    @IBAction func btnLocation2(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Picker", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PickerLocation2ViewController") as? PickerLocation2ViewController else {return}
        controller.providesPresentationContextTransitionStyle = true
        controller.definesPresentationContext = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        controller.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        controller.beforeController = "MakeRoomViewController"
        controller.location1 = self.btnLocation1.titleLabel?.text!
        self.present(controller, animated: false, completion: nil)
    }
    
    @IBAction func slideChange(_ sender: UISlider) {
        lblAge.text = "\(Int(sender.value))"
    }
    @IBAction func btnTotal(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Picker", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PickerTotalViewController") as? PickerTotalViewController else {return}
        controller.providesPresentationContextTransitionStyle = true
        controller.definesPresentationContext = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        controller.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        controller.beforeController = "MakeRoomViewController"
        self.present(controller, animated: false, completion: nil)
    }
    @IBAction func btnDate2(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Picker", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PickerDate2ViewController") as? PickerDateViewController else {return}
        controller.providesPresentationContextTransitionStyle = true
        controller.definesPresentationContext = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        controller.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        controller.beforeController = "MakeRoomViewController"
        self.present(controller, animated: false, completion: nil)
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        guard let title = self.txtTitle.text, !title.isEmpty else { myAlert("잠깐!", message: "방제목을 확인해 주세요"); return}
        guard let location1 = self.btnLocation1.titleLabel?.text, !location1.isEmpty else {return}
        guard let location2 = self.btnLocation2.titleLabel?.text, !location2.isEmpty else {return}
        guard let total = self.btnTotal.titleLabel?.text, !total.isEmpty else { return}
        let age = self.lblAge.text!
        guard let tag1 = self.txtTag1.text, !tag1.isEmpty else { myAlert("잠깐!", message: "자신에 대해서 어필을 입력해 주세요"); return}
        guard let tag2 = self.txtTag2.text, !tag2.isEmpty else { myAlert("잠깐!", message: "자신에 대해서 어필을 입력해 주세요"); return}
        guard let tag3 = self.txtTag3.text, !tag3.isEmpty else { myAlert("잠깐!", message: "자신에 대해서 어필을 입력해 주세요"); return}
        
        
        let url = Config.baseURL + "/api/boards"
        
        //gender 수정 필요함 *****
        let PARMS:Parameters = [
            "title":title,
            "tag1":tag1,
            "tag2":tag2,
            "tag3":tag3,
            "location1": location1,
            "location2" : location2,
            "num_type": total,
            "average_age":age,
            "gender":Config.userGender!,
            "user":"\(Config.userIdx!)"
        ]
        guard let imageData1 = self.imgForMeeting1.image!.jpegData(compressionQuality: 0.2) else {
            print("Could not get JPEG representation of UIImage")
            return
          }
        guard let imageData2 = self.imgForMeeting2.image!.jpegData(compressionQuality: 0.2) else {
            print("Could not get JPEG representation of UIImage")
            return
          }
        guard let imageData3 = self.imgForMeeting3.image!.jpegData(compressionQuality: 0.2) else {
            print("Could not get JPEG representation of UIImage")
            return
          }
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in PARMS {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key, mimeType: "text/plain")
            }
            multipartFormData.append(imageData1, withName: "img1",fileName: "postBoard1.jpg", mimeType: "image/jpeg")
            multipartFormData.append(imageData2, withName: "img2",fileName: "postBoard2.jpg", mimeType: "image/jpeg")
            multipartFormData.append(imageData3, withName: "img3",fileName: "postBoard3.jpg", mimeType: "image/jpeg")
        }, to: url, method: .post, headers: ["Content-Type": "multipart/form-data"]).validate(statusCode: 200..<300)
        .responseJSON{reponse in
            switch reponse.result{
            case .success(let json):
                do {
                    let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    let jsonParsing = try JSONDecoder().decode(CodeAndMessage.self, from: data)
                    if(jsonParsing.code == 200){
                        let alert = UIAlertController(title: "알림", message: "방 생성을 완료 하였습니다. 좋은 사람과 맺어지길 기원합니다.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {_ in 
                            self.dismiss(animated: true, completion: nil)
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        self.myAlert("알림", message: "방 생성을 실패 하였습니다.")
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
    
    
}
