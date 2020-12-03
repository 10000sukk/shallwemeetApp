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

class HomeViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {



    
    @IBOutlet var scrollViewMain: UIScrollView!
    
    @IBOutlet var collectionViewLatestMeeting: UICollectionView!
    @IBOutlet var pageControlLatestMeeting: UIPageControl!
    
    @IBOutlet var collectionViewRecoByLocation: UICollectionView!
    @IBOutlet var pageControlRecoByLocation: UIPageControl!
    
    @IBOutlet var lblHot: UILabel!
    
    var latestMeetingIdx:[Int] = []
    var latestMeetingimg1:[String] = []
    var latestMeetingLocation1:[String] = []
    var latestMeetingLocation2:[String] = []
    var latestMeetingAge:[Int] = []
    var latestMeetingTotal:[String] = []
    
    var recoByLocationMeetingIdx:[Int] = []
    var recoByLocationMeetingimg1:[String] = []
    var recoByLocationMeetingLocation1:[String] = []
    var recoByLocationMeetingLocation2:[String] = []
    var recoByLocationMeetingAge:[Int] = []
    var recoByLocationMeetingTotal:[String] = []
    
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
        
        // Do any additional setup after loading the view.
        self.collectionViewLatestMeeting.tag = 0
        self.collectionViewRecoByLocation.tag = 1
        
        //현재페이지를 0페이지로 지정
        self.pageControlLatestMeeting.currentPage = 0
        self.pageControlRecoByLocation.currentPage = 0
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print(lblHot.font.fontName)
        //배열을 비운 후에 받아온 값을 배열에 넣어서 cell 로 표현한다.
        self.latestMeetingIdx = []
        self.latestMeetingimg1 = []
        self.latestMeetingLocation1 = []
        self.latestMeetingLocation2 = []
        self.latestMeetingAge = []
        self.latestMeetingTotal = []
        
        let url1 = Config.baseURL + "/api/boards/rec/time" + "/\(Config.userIdx!)"

        AF.request(url1, method: .get ,encoding: URLEncoding.default,headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
            .responseJSON(){response in
                switch response.result{
                case .success(let json):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let jsonParsing = try JSONDecoder().decode(LatestMeetingListParsing.self, from: data)
                        for i in 0 ..< jsonParsing.count{
                            self.latestMeetingIdx.append(jsonParsing[i].idx)
                            self.latestMeetingimg1.append(jsonParsing[i].img1)
                            self.latestMeetingLocation1.append(jsonParsing[i].location1)
                            self.latestMeetingLocation2.append(jsonParsing[i].location2)
                            self.latestMeetingAge.append(jsonParsing[i].age)
                            self.latestMeetingTotal.append(jsonParsing[i].numType)
                          
                            
                        
                            //reload collectionView
                        }
                        self.collectionViewLatestMeeting.reloadData()
                        self.pageControlLatestMeeting.numberOfPages = jsonParsing.count
                        
                        
                    }catch let jsonError{
                        print("Error seriallizing json:",jsonError)
                    }
                    
                    //let response = json as! NSDictionary
                    
                case .failure(let error):
                    print("error: \(String(describing: error))")
                }
                
            }
        
        //지역기반 미팅 추천 받아오기
        self.recoByLocationMeetingIdx = []
        self.recoByLocationMeetingimg1 = []
        self.recoByLocationMeetingLocation1 = []
        self.recoByLocationMeetingLocation2 = []
        self.recoByLocationMeetingAge = []
        self.recoByLocationMeetingTotal = []
        
        let url2 = Config.baseURL + "/api/boards/rec/location" + "/\(Config.userIdx!)"

        AF.request(url2, method: .get ,encoding: URLEncoding.default,headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
            .responseJSON(){response in
                switch response.result{
                case .success(let json):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let jsonParsing = try JSONDecoder().decode(LatestMeetingListParsing.self, from: data)
                        for i in 0 ..< jsonParsing.count{
                            self.recoByLocationMeetingIdx.append(jsonParsing[i].idx)
                            self.recoByLocationMeetingimg1.append(jsonParsing[i].img1)
                            self.recoByLocationMeetingLocation1.append(jsonParsing[i].location1)
                            self.recoByLocationMeetingLocation2.append(jsonParsing[i].location2)
                            self.recoByLocationMeetingAge.append(jsonParsing[i].age)
                            self.recoByLocationMeetingTotal.append(jsonParsing[i].numType)
                        
                            //reload collectionView
                        }
                        self.collectionViewRecoByLocation.reloadData()
                        self.pageControlRecoByLocation.numberOfPages = jsonParsing.count
                        
                        
                    }catch let jsonError{
                        print("Error seriallizing json:",jsonError)
                    }
                    
                    //let response = json as! NSDictionary
                    
                case .failure(let error):
                    print("error: \(String(describing: error))")
                }
                
            }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollView.tag {
        case collectionViewLatestMeeting.tag:
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControlLatestMeeting.currentPage = Int(pageNumber)
            
        case collectionViewRecoByLocation.tag:
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControlRecoByLocation.currentPage = Int(pageNumber)
            
        default:
            return
        }
        
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
    
    //셀의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case collectionViewLatestMeeting.tag:
            return latestMeetingIdx.count
            
        case collectionViewRecoByLocation.tag:
            return recoByLocationMeetingIdx.count
        default:
            return 0
        }
        
    }
    
    //셀 커스텀 수행
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case collectionViewLatestMeeting.tag:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestMeetingCustomCell", for: indexPath) as! LatestMeetingCustomCell
            let url =  URL(string: latestMeetingimg1[indexPath.row])
            do{
                let data = try Data(contentsOf: url!)
                cell.imgLastestMeeting.image = UIImage(data: data)
            }
            catch{
                cell.imgLastestMeeting.image = nil
            }
            cell.lblLatestMeetingLocation1.text = latestMeetingLocation1[indexPath.row]
            cell.lblLatestMeetingLocation2.text = latestMeetingLocation2[indexPath.row]
            cell.lblLatestMeetingTotal.text = latestMeetingTotal[indexPath.row]
            cell.lblLatestMeetingAge.text = "평균나이 \(String(describing: latestMeetingAge[indexPath.row]))"
            
            //cell 테두리
            cell.shadowDecorate()
            //cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            return cell
            
        case collectionViewRecoByLocation.tag:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecoByLocationCustomCell", for: indexPath) as! RecoByLocationCustomCell
            let url =  URL(string: recoByLocationMeetingimg1[indexPath.row])
            do{
                let data = try Data(contentsOf: url!)
                cell.imgRecoByLocation.image = UIImage(data: data)
            }
            catch{
                cell.imgRecoByLocation.image = nil
            }
            cell.lblLocation1.text = recoByLocationMeetingLocation1[indexPath.row]
            cell.lblLocation2.text = recoByLocationMeetingLocation2[indexPath.row]
            cell.lblTotal.text = recoByLocationMeetingTotal[indexPath.row]
            cell.lblAge.text = "평균나이 \(String(describing: recoByLocationMeetingAge[indexPath.row]))"
            
            //cell 테두리
            cell.shadowDecorate()
            
            
            
            return cell
        //dummy code
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestMeetingCustomCell", for: indexPath) as! LatestMeetingCustomCell
            return cell
        }
        
    }
    
    //행당 1개씩 셀 출력을 위해서
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case collectionViewLatestMeeting.tag:
            let width1 = collectionView.frame.size.width
            let height = collectionView.frame.size.height
            return CGSize(width: width1 , height: height * 0.9)
            
        case collectionViewRecoByLocation.tag:
            let width1 = collectionView.frame.size.width
            let height = collectionView.frame.size.height
            return CGSize(width: width1, height: height * 0.9)
        //dummy code
        default:
            return CGSize(width:0,height:0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //cell 이 터치시 수행하는 함수
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case collectionViewLatestMeeting.tag:
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailRoomViewController") as?
                DetailRoomViewController else { return}
            controller.boardIdx = self.latestMeetingIdx[indexPath.row]
            controller.cellIndexPath = indexPath
            controller.beforeController = "HomeViewController"
            controller.modalPresentationStyle = .fullScreen
            present(controller,animated: true, completion: nil)
        
        case collectionViewRecoByLocation.tag:
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailRoomViewController") as?
                DetailRoomViewController else { return}
            controller.boardIdx = self.recoByLocationMeetingIdx[indexPath.row]
            controller.cellIndexPath = indexPath
            controller.beforeController = "HomeViewController"
            controller.modalPresentationStyle = .fullScreen
            present(controller,animated: true, completion: nil)
        default:
            return
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
class LatestMeetingCustomCell:UICollectionViewCell{
    
    @IBOutlet var imgLastestMeeting: UIImageView!
    @IBOutlet var lblLatestMeetingLocation1: UILabel!
    @IBOutlet var lblLatestMeetingLocation2: UILabel!
    @IBOutlet var lblLatestMeetingAge: UILabel!
    @IBOutlet var lblLatestMeetingTotal: UILabel!
    
}

class RecoByLocationCustomCell:UICollectionViewCell{
    
    @IBOutlet var imgRecoByLocation: UIImageView!
    @IBOutlet var lblLocation1: UILabel!
    @IBOutlet var lblLocation2: UILabel!
    @IBOutlet var lblAge: UILabel!
    @IBOutlet var lblTotal: UILabel!
}
