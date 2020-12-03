//
//  MatchedListViewController.swift
//  test1
//
//  Created by 김환석 on 2020/10/10.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit
import Alamofire

class MatchedListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    
    var boardIdx:[[Int]] = [[],[]]
    var images:[[String]] = [[],[]]
    var nickNames:[[String]] = [[],[]]
    var titles:[[String]] = [[],[]]
    var ages:[[String]] = [[],[]]
    var totals:[[String]] = [[],[]]
    var kakaoId:[[String]] = [[],[]]
    var location1:[[String]] = [[],[]]
    var location2:[[String]] = [[],[]]
    
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
        
        self.boardIdx = [[],[]]
        self.images = [[],[]]
        self.nickNames = [[],[]]
        self.titles = [[],[]]
        self.ages = [[],[]]
        self.totals = [[],[]]
        self.kakaoId = [[],[]]
        self.location1 = [[],[]]
        self.location2 = [[],[]]
        
        
        let url = Config.baseURL + "/api/match/matched" + "/\(Config.userIdx!)"

        AF.request(url, method: .get ,encoding: URLEncoding.default,headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
            .responseJSON(){response in
                switch response.result{
                case .success(let json):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let jsonParsing = try JSONDecoder().decode(MatchedListParsing.self, from: data)
                        
                        for i in 0 ..< jsonParsing.isMakers.count{
                            self.boardIdx[0].append(jsonParsing.isMakers[i].board.idx)
                            self.images[0].append(jsonParsing.isMakers[i].sender.img)
                            self.nickNames[0].append(jsonParsing.isMakers[i].sender.nickName)
                            self.titles[0].append(jsonParsing.isMakers[i].board.title)
                            self.ages[0].append(jsonParsing.isMakers[i].sender.age)
                            self.totals[0].append(jsonParsing.isMakers[i].board.numType)
                            self.location1[0].append(jsonParsing.isMakers[i].board.location1)
                            self.location2[0].append(jsonParsing.isMakers[i].board.location2)
                            self.kakaoId[0].append(jsonParsing.isMakers[i].sender.kakaoID)
                        }
                        for i in 0 ..< jsonParsing.isSenders.count{
                            self.boardIdx[1].append(jsonParsing.isSenders[i].board.idx)
                            self.images[1].append(jsonParsing.isSenders[i].board.img1)
                            self.nickNames[1].append(jsonParsing.isSenders[i].board.user.nickName)
                            self.titles[1].append(jsonParsing.isSenders[i].board.title)
                            self.ages[1].append("\(jsonParsing.isSenders[i].board.age)")
                            self.totals[1].append(jsonParsing.isSenders[i].board.numType)
                            self.location1[1].append(jsonParsing.isSenders[i].board.location1)
                            self.location2[1].append(jsonParsing.isSenders[i].board.location2)
                            self.kakaoId[1].append(jsonParsing.isSenders[i].board.user.kakaoID)
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return boardIdx.count
    }
    
    //header custom 수행
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MatchedListCellHeader", for: indexPath) as! MatchedListCellHeader
        switch indexPath.section{
        case 0:
            headerView.lblCase.text = "내 방에 대한 매칭"
        case 1:
            headerView.lblCase.text = "내가 보낸 요청의 매칭"
        default:
            print("error")
        }
        
        //cell 테두리
        headerView.layer.borderColor = UIColor.black.cgColor
        headerView.layer.borderWidth = 2
        headerView.layer.cornerRadius = 10
        
        return headerView
    }
    
    //셀의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boardIdx[section].count
    }
    
    //셀 커스텀 수행
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchedListCustomCell", for: indexPath) as! MatchedListCustomCell
        
        cell.lblNickName.text = self.nickNames[indexPath.section][indexPath.row]
        cell.lblAge.text = self.ages[indexPath.section][indexPath.row] + "세"
        cell.lblLocation1.text = self.location1[indexPath.section][indexPath.row]
        cell.lblLocation2.text = self.location2[indexPath.section][indexPath.row]
        cell.lblTitle.text = self.titles[indexPath.section][indexPath.row]
        cell.lblTotal.text = self.totals[indexPath.section][indexPath.row]
        cell.lblKakaoID.text = self.kakaoId[indexPath.section][indexPath.row]
        
        let url =  URL(string: self.images[indexPath.section][indexPath.row])
        do{
            let data = try Data(contentsOf: url!)
            cell.imgOtherInfo.image = UIImage(data: data)
        }
        catch{
            cell.imgOtherInfo.image = nil
        }
        //cell 테두리
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    //section header margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 80, right: 20)
    }
    
    //행당 1개씩 셀 출력을 위해서
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        return CGSize(width: width * 0.9, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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

class MatchedListCellHeader:UICollectionReusableView{
    @IBOutlet var lblCase: UILabel!
    
}
class MatchedListCustomCell:UICollectionViewCell{
    @IBOutlet var imgOtherInfo: UIImageView!
    @IBOutlet var lblNickName: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblLocation1: UILabel!
    @IBOutlet var lblLocation2: UILabel!
    @IBOutlet var lblAge: UILabel!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var lblKakaoID: UILabel!
    
}
