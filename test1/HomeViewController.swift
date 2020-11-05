//
//  HomeViewController.swift
//  test1
//
//  Created by 김환석 on 2020/10/10.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class HomeViewController: UIViewController {



    
    var imageUrl:[NSURL]?
    var imageData:[NSData]?
    
    var hotmeetingImageArray:[UIImage] = []
    var hotmeetingLocationArray:[String] = []
    var hotmeetingtotalArray:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //따끈따끈한 미팅 사진 5장 받아오기
        let url = Config.baseURL + "/"
        AF.request(url, method:.get).validate(statusCode: 200..<300)
            .responseJSON{ reponse in
                print(reponse)
//                switch reponse.result{
//                case .success(let value):
//                    //받아온 이이지 배열에 넣기
//
//
//                case .failure(let error):
//
//                }
            
        }
//        pageControl.numberOfPages = 5
//        pageControl.currentPage = 0
//        pageControl.pageIndicatorTintColor = UIColor.green
//        pageControl.currentPageIndicatorTintColor = UIColor.red
        
        
    }
    
   
   
    
  
    @IBAction func btnMakeMeeting(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(identifier: "MakeRoomViewController")
        controller?.modalPresentationStyle = .fullScreen
        self.present(controller!, animated: true, completion: nil)
    }
    
    @IBAction func btnSearchMeeting(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(identifier: "SearchRoomViewController")
        controller?.modalPresentationStyle = .fullScreen
        self.present(controller!, animated: true, completion: nil)
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
