//
//  SearchRoomViewController.swift
//  test1
//
//  Created by 김환석 on 2020/10/15.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit
import Alamofire


class SearchRoomViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
 
    @IBOutlet var collectionView: UICollectionView!
   
    
    var meetingLocation1:String?
    var meetingLocation2:String?
    var meetingAge:String?
    var meetingTotal:String?
    var meetingDate:String?
    var meetingDefault = "상관없음"
    
    var boardIdx:[Int?] = []
    var boardTitle:[String?] = []
    var boardimg1:[String?] = []
    var boardTag1:[String?] = []
    var boardTag2:[String?] = []
    var boardTag3:[String?] = []
    var boardLocation1:[String] = []
    var boardLocation2:[String] = []
    var boardAge:[Int] = []
    var boardTotal:[String] = []
    var boardDate:[String] = []
    var boardUserIdx:[Int?] = []
    var boardUserNickName:[String?] = []
    var boardUserImg:[String?] = []
    var boardChecked: [Bool?] = []
    
    var isClickedFilterButton:Bool = true
    
    var pageCount:Int = 1
    
    var scrollReloadPossible = true
    
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //backGround Color
        let backGroundColor = MyBackGroundColor()
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = self.view.bounds
        self.gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        self.gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.gradientLayer.colors = [UIColor(red: backGroundColor.startColorRed, green: backGroundColor.startColorGreen, blue: backGroundColor.startColorBlue , alpha: 1).cgColor, UIColor(red: backGroundColor.endColorRed , green: backGroundColor.endColorGreen, blue: backGroundColor.endColorBlue, alpha: 1).cgColor]
        self.view.layer.insertSublayer(self.gradientLayer, at: 0)
        
        self.meetingLocation1 = self.meetingDefault
        self.meetingLocation2 = self.meetingDefault
        self.meetingAge = self.meetingDefault
        self.meetingTotal = self.meetingDefault
        self.meetingDate = self.meetingDefault
    
    }
    
    
    
    //필터 수정후 해당 작업 수행
    //만일 back 버튼으로 돌아 왔을 경우는 수행하지 않도록 한다.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //필터 내용 적용
        
        
        //처음이나 필터가 눌렷을 경우에만 이를 수행
        if(self.isClickedFilterButton){
            self.boardIdx = []
            self.boardTitle = []
            self.boardimg1 = []
            self.boardTag1 = []
            self.boardTag2 = []
            self.boardTag3 = []
            self.boardLocation1 = []
            self.boardLocation2 = []
            self.boardAge = []
            self.boardTotal = []
            self.boardDate = []
            self.boardUserIdx = []
            self.boardUserNickName = []
            self.boardUserImg = []
            self.boardChecked = []
            self.pageCount = 1
        }
        else{
            return
        }
        //게시판 정보 불러옴
        let url = Config.baseURL + "/api/boards"
        let PARMS:Parameters = [
            "userId": Config.userIdx!,
            "location1":meetingLocation1!,
            "location2":meetingLocation2!,
            "age":meetingAge!,
            "num_type":meetingTotal!,
            "date":meetingDate!,
            "gender":Config.userGender!
        ]
        
        AF.request(url, method: .get,parameters: PARMS ,encoding: URLEncoding.default,headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
            .responseJSON(){response in
                switch response.result{
                case .success(let json):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let jsonParsing = try JSONDecoder().decode(BoardsParse.self, from: data)
                        for i in 0 ..< jsonParsing.count{
                            self.boardIdx.append(jsonParsing[i].idx)
                            self.boardimg1.append(jsonParsing[i].img1)
                            self.boardTitle.append(jsonParsing[i].title)
                            self.boardTag1.append(jsonParsing[i].tag1)
                            self.boardTag2.append(jsonParsing[i].tag2)
                            self.boardTag3.append(jsonParsing[i].tag3)
                            self.boardLocation1.append(jsonParsing[i].location1)
                            self.boardLocation2.append(jsonParsing[i].location2)
                            self.boardAge.append(jsonParsing[i].age)
                            self.boardTotal.append(jsonParsing[i].numType)
                            self.boardDate.append(jsonParsing[i].date)
                            self.boardUserIdx.append(jsonParsing[i].user.idx)
                            self.boardUserNickName.append(jsonParsing[i].user.nickName)
                            self.boardUserImg.append(jsonParsing[i].user.img)
                            self.boardChecked.append(jsonParsing[i].check)
                        
                            //reload collectionView
                        }
                        self.collectionView.reloadData()
                        
                    }catch let jsonError{
                        print("Error seriallizing json:",jsonError)
                    }
                    
                    //let response = json as! NSDictionary
                    
                case .failure(let error):
                    print("error: \(String(describing: error))")
                }
                
            }
    }
    
    
    @objc func touchImgBoard(){
        print("이미지 터치 했어염..")
    }

    
    @IBAction func btnFilter(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController else {
            //아니면 종료
            return
        }
        controller.location1 = self.meetingLocation1
        controller.location2 = self.meetingLocation2
        controller.date = self.meetingDate
        controller.age = self.meetingAge
        controller.total = self.meetingTotal
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    
    
    
   //스크롤이 끝일 경우 수행
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(!scrollReloadPossible){
            return
        }
        else{
            scrollReloadPossible = false
        }
        let url = Config.baseURL + "/api/boards"
        let nextPageCount = self.pageCount+1
        
        let PARMS:Parameters = [
            "page": nextPageCount,
            "userId": Config.userIdx!,
            "location1":meetingLocation1!,
            "location2":meetingLocation2!,
            "age":meetingAge!,
            "num_type":meetingTotal!,
            "date":meetingDate!,
            "gender":Config.userGender!
        ]
        AF.request(url, method: .get, parameters: PARMS,encoding: URLEncoding.default ,headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
            .responseJSON(){response in
                switch response.result{
                case .success(let json):
                    do {
                        let boardNum = self.boardIdx.count
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let jsonParsing = try JSONDecoder().decode(BoardsParse.self, from: data)
                        for i in 0 ..< jsonParsing.count{
                            self.boardIdx.append(jsonParsing[i].idx)
                            self.boardimg1.append(jsonParsing[i].img1)
                            self.boardTitle.append(jsonParsing[i].title)
                            self.boardTag1.append(jsonParsing[i].tag1)
                            self.boardTag2.append(jsonParsing[i].tag2)
                            self.boardTag3.append(jsonParsing[i].tag3)
                            self.boardLocation1.append(jsonParsing[i].location1)
                            self.boardLocation2.append(jsonParsing[i].location2)
                            self.boardDate.append(jsonParsing[i].date)
                            self.boardAge.append(jsonParsing[i].age)
                            self.boardTotal.append(jsonParsing[i].numType)
                            self.boardUserIdx.append(jsonParsing[i].user.idx)
                            self.boardUserNickName.append(jsonParsing[i].user.nickName)
                            self.boardUserImg.append(jsonParsing[i].user.img)
                            self.boardChecked.append(jsonParsing[i].check)
                            
                            self.collectionView?.performBatchUpdates({
                                let indexPath = IndexPath(row: i+boardNum, section: 0)
                                self.collectionView?.insertItems(at: [indexPath])
                            }, completion: nil)
                            //reload collectionView
                            //self.collectionView.reloadData()
                        }
                        self.pageCount += 1
                    }catch let jsonError{
                        print("Error seriallizing json:",jsonError)
                    }
                    
                    //let response = json as! NSDictionary
                    
                case .failure(let error):
                    print("error: \(String(describing: error))")
                }
                self.scrollReloadPossible = true
            }
    }
    
    
    //셀의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boardIdx.count
    }
    
    //셀 커스텀 수행
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowCell", for: indexPath) as! CustomCell
        let url =  URL(string: boardimg1[indexPath.row]!)
        do{
            let data = try Data(contentsOf: url!)
            cell.imgCellPhoto.image = UIImage(data: data)
        }
        catch{
            cell.imgCellPhoto.image = nil
        }
        cell.lblCellLocation1.text = boardLocation1[indexPath.row]
        cell.lblCellLocation2.text = boardLocation2[indexPath.row]
        cell.lblCellTotal.text = boardTotal[indexPath.row]
        cell.lblCellAge.text = "\(String(describing: boardAge[indexPath.row]))"
        
        let tmpDateArr = boardDate[indexPath.row].components(separatedBy: "-")
        cell.lblCellDate.text = tmpDateArr[1] + "월 " + tmpDateArr[2] + "일"
        
        if (boardChecked[indexPath.row]!){
            cell.btnStar.setImage(UIImage(named: "./images/star_fill.png"), for: .normal)
        }
        else{
            cell.btnStar.setImage(UIImage(named: "./images/star_empty.png"), for: .normal)
        }
        
        cell.viewTranslucent.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        //cell.shadowDecorate()
        
        return cell
    }
    
    //행당 2개씩 셀 출력을 위해서
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width1 = collectionView.frame.size.width / 2
        return CGSize(width: width1 - 8, height: (width1 - 8) * 0.9)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //cell 이 터치시 수행하는 함수
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailRoomViewController") as?
            DetailRoomViewController else { return}
        controller.boardIdx = self.boardIdx[indexPath.row]
        controller.cellIndexPath = indexPath
        controller.beforeController = "SearchRoomViewController"
        controller.modalPresentationStyle = .fullScreen
        present(controller,animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnStar(_ sender: UIButton) {
        let contentView = sender.superview
        let cell = contentView?.superview as! UICollectionViewCell
        guard let index = collectionView.indexPath(for: cell) else {return;}
        //즐겨찾기 추가
        if (!boardChecked[index.row]!){
            let url  = Config.baseURL + "/api/bookmark"
            let PARMS = [
                "userId":Config.userIdx!,
                "boardId":self.boardIdx[index.row]!
            ]
            AF.request(url, method: .post ,parameters: PARMS , encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
                .responseJSON(){response in
                    switch response.result{
                    case .success(let json):
                        do {
                            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            let jsonParsing = try JSONDecoder().decode(CodeAndMsg.self, from: data)
                            if (jsonParsing.code == 200){
                                self.boardChecked[index.row] = true
                                self.collectionView.reloadItems(at: [index])
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
            let url  = Config.baseURL + "/api/bookmark/\(Config.userIdx!)/\(self.boardIdx[index.row]!)"
            AF.request(url, method: .delete , encoding: URLEncoding.default, headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
                .responseJSON(){response in
                    switch response.result{
                    case .success(let json):
                        do {
                            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            let jsonParsing = try JSONDecoder().decode(CodeAndMsg.self, from: data)
                            if (jsonParsing.code == 200){
                                self.boardChecked[index.row] = false
                                self.collectionView.reloadItems(at: [index])
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
    
    @IBAction func btnToHome(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

//셀의 커스텀 형태
class CustomCell:UICollectionViewCell {
    
    @IBOutlet var imgCellPhoto: UIImageView!
    @IBOutlet var lblCellLocation1: UILabel!
    @IBOutlet var lblCellLocation2: UILabel!
    @IBOutlet var lblCellTotal: UILabel!
    @IBOutlet var lblCellAge: UILabel!
    @IBOutlet var lblCellDate: UILabel!
    @IBOutlet var btnStar: UIButton!
    @IBOutlet var viewTranslucent: UIView!
    
}
