//
//  MyRoomDetailViewController.swift
//  test1
//
//  Created by 김환석 on 2020/11/17.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit
import Alamofire

class MyRoomDetailViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageControlMyMeetingImage: UIPageControl!
    
    
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblLocation1: UILabel!
    @IBOutlet var lblLocation2: UILabel!
    @IBOutlet var lblAge: UILabel!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var lbldate: UILabel!
    @IBOutlet var lblTag: UILabel!
    
    
    var images:[String] = []
    var boardIdx:Int?
    
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageControlMyMeetingImage.currentPage = 0
        // Do any additional setup after loading the view.
        
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
        AF.request(url, method: .get, encoding: URLEncoding.default, headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
            .responseJSON(){ response in
                switch response.result{
                case .success(let json):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let jsonParsing = try JSONDecoder().decode(DetailBoardParsing.self, from: data)
                        
                        self.lblTitle.text = jsonParsing.title
                        self.lblLocation1.text = jsonParsing.location1
                        self.lblLocation2.text = jsonParsing.location2
                        self.lblAge.text = "\(jsonParsing.age) 세"
                        self.lblTotal.text = jsonParsing.numType
                        self.lbldate.text = jsonParsing.date
                        self.lblTag.text = "#" + jsonParsing.tag1 + "#" + jsonParsing.tag2 + "#" + jsonParsing.tag3
                        //cell image info save
                        self.images.append(jsonParsing.img1)
                        self.images.append(jsonParsing.img2)
                        self.images.append(jsonParsing.img3)
                        
                        self.collectionView.reloadData()
                        self.pageControlMyMeetingImage.numberOfPages = self.images.count
                    }catch let jsonError{
                        print("Error seriallizing json:",jsonError)
                    }
                case .failure(let error):
                    print("error: \(String(describing: error))")
                }
            
            }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControlMyMeetingImage.currentPage = Int(pageNumber)
    }
    //셀의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    //셀 커스텀 수행
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyRoomDetailCustomCell", for: indexPath) as! MyRoomDetailCustomCell
        let url =  URL(string: self.images[indexPath.row])
        do{
            let data = try Data(contentsOf: url!)
            cell.imgMyMeetingImage.image = UIImage(data: data)
        }
        catch{
            cell.imgMyMeetingImage.image = nil
        }
        
        //cell 테두리
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0
        cell.layer.cornerRadius = 10
        return cell
    }
    
    //행당 1개씩 셀 출력을 위해서
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width1 = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        return CGSize(width: width1, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnRoomRemove(_ sender: UIButton) {
        let alert = UIAlertController(title: "확인", message: "방을 삭제 하시겠습니까?", preferredStyle: .alert)
        let actionRemove = UIAlertAction(title: "삭제", style: .destructive, handler: { action in
            let url  = Config.baseURL + "/api/boards" + "/\(self.boardIdx!)"
            AF.request(url, method: .delete, encoding: URLEncoding.default, headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300).responseJSON(){response in
                switch response.result{
                case .success(let json):
                    do{
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let jsonParsing = try JSONDecoder().decode(CodeAndMsg.self, from: data)
                        if(jsonParsing.code == 200){
                            let alertSuccess = UIAlertController(title: "알림", message: "삭제를 완료하였습니다", preferredStyle: .alert)
                            let actionOK = UIAlertAction(title: "확인", style: .default, handler: {action in
                                self.dismiss(animated: true, completion: nil)
                            })
                            alertSuccess.addAction(actionOK)
                            self.present(alertSuccess, animated: true, completion: nil)
                        }
                        
                        
                    }catch let jsonError{
                        print("Error seriallizing json:",jsonError)
                    }
                case .failure(let error):
                    print("error: \(String(describing: error))")
                    
                }
                
            }
            
        })
        let actionCancle = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        alert.addAction(actionRemove)
        alert.addAction(actionCancle)
        self.present(alert, animated: true, completion: nil)
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

class MyRoomDetailCustomCell:UICollectionViewCell{
    @IBOutlet var imgMyMeetingImage: UIImageView!
    
}
