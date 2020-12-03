//
//  MyListViewController.swift
//  test1
//
//  Created by 김환석 on 2020/10/10.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit
import Alamofire

class MyListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    

   
    @IBOutlet var segControlShowType: UISegmentedControl!
    
    @IBOutlet var parentScrollView: UIScrollView!
    
    @IBOutlet var collectionViewSendRequestParent: UICollectionView!
  
    
    @IBOutlet var scrollViewRecieveRequest: UIScrollView!
    @IBOutlet var pageControlRecieveRequestMyRoom: UIPageControl!
    

    @IBOutlet var collectionViewRecieveRequestMyRoom: UICollectionView!
    @IBOutlet var collectionViewRecieveRequest: UICollectionView!
    
    var gradientLayer: CAGradientLayer!
    
    //받은요청 나의 방에 대한 정보 배열
    //내 방에 대한 정보
    var myRoomIdx:[Int] = []
    var myRoomImage:[String] = []
    var myRoomTitle:[String] = []
    var myRoomLocation1:[String] = []
    var myRoomLocation2:[String] = []
    var myRoomAge:[Int] = []
    var myRoomTotal:[String] = []
    
    //내가 받은 요청
    var recievedRequestUserIdx:[[Int]] = []
    var recievedRequestUserNickName:[[String]] = []
    var recievedRequestUserImage:[[String]] = []
    var recievedRequestUserAge:[[String]] = []
    var recievedRequestStatus:[[Bool]] = []
    
    //보낸요청
    var sendRequestDate:[String] = []
    var sendRequestCollectionViewTag:[Int] = []
    var sendRequestRoomIdx:[[Int]] = []
    var sendRequestRoomImage:[[String]] = []
    var sendRequestRoomTitle:[[String]] = []
    var sendRequestRoomLocation1:[[String]] = []
    var sendRequestRoomLocation2:[[String]] = []
    var sendReqeustRoomAge:[[Int]] = []
    var sendRequestRoomTotal:[[String]] = []
    
    var collectionViewSendRequstChildTag:Int = 0
    var pageControlCurrentNumberRecievedRequest:Int = 0
    var pageControlCurrentNumberSendRequestCell:[Int] = []
    
    var goingUp: Bool? //to track is scrollView is going up or down
    var childScrollingDownDueToParent = false // track if child scrollView is scrolling due to scroll in parent or itself
    
    
    
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
        
        
        //받은요청 페이지의 스크롤뷰
        scrollViewRecieveRequest.delegate = self
        //collectionViewRecieveRequest.delegate = self
        
        //collectionView의 태그를 달아주기
        collectionViewRecieveRequestMyRoom.tag = 10
        collectionViewRecieveRequest.tag = 20
        collectionViewSendRequestParent.tag = 30
        
        pageControlRecieveRequestMyRoom.currentPage = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        /*배열 초기화*/
        myRoomIdx = []
        myRoomImage = []
        myRoomTitle = []
        myRoomLocation1 = []
        myRoomLocation2 = []
        myRoomAge = []
        myRoomTotal = []
        
        //내가 받은 요청
        recievedRequestUserIdx = []
        recievedRequestUserNickName = []
        recievedRequestUserImage = []
        recievedRequestUserAge = []
        recievedRequestStatus = []
        
        //보낸요청
        sendRequestDate = []
        sendRequestCollectionViewTag = []
        sendRequestRoomIdx = []
        sendRequestRoomImage = []
        sendRequestRoomTitle = []
        sendRequestRoomLocation1 = []
        sendRequestRoomLocation2 = []
        sendReqeustRoomAge = []
        sendRequestRoomTotal = []
        
        collectionViewSendRequstChildTag = 0
        
        let URLRecievedRequest = Config.baseURL + "/api/match/maker/\(String(describing: Config.userIdx!))"
        let URLSendRequest = Config.baseURL + "/api/match/sender/\(String(describing: Config.userIdx!))"
        
        //받은 요청 화면은 구성하기 위한 api 통신
        AF.request(URLRecievedRequest, method: .get ,encoding: URLEncoding.default,headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
            .responseJSON(){response in
                switch response.result{
                case .success(let json):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let jsonParsing = try JSONDecoder().decode(RecievedRequestParse.self, from: data)
                        
                        for i in 0 ..< jsonParsing.count{
                            self.myRoomIdx.append(jsonParsing[i].idx)
                            self.myRoomTitle.append(jsonParsing[i].title)
                            self.myRoomImage.append(jsonParsing[i].img1)
                            self.myRoomAge.append(jsonParsing[i].age)
                            self.myRoomLocation1.append(jsonParsing[i].location1)
                            self.myRoomLocation2.append(jsonParsing[i].location2)
                            self.myRoomTotal.append(jsonParsing[i].numType)
                            
                            self.recievedRequestUserIdx.append([])
                            self.recievedRequestUserNickName.append([])
                            self.recievedRequestUserImage.append([])
                            self.recievedRequestUserAge.append([])
                            self.recievedRequestStatus.append([])
                            
                            for j in 0 ..< jsonParsing[i].senders.count{
                                self.recievedRequestUserIdx[i].append(jsonParsing[i].senders[j].idx)
                                self.recievedRequestUserNickName[i].append(jsonParsing[i].senders[j].nickName)
                                self.recievedRequestUserImage[i].append(jsonParsing[i].senders[j].img)
                                self.recievedRequestUserAge[i].append(jsonParsing[i].senders[j].age)
                                self.recievedRequestStatus[i].append(jsonParsing[i].senders[j].status)
                            }
                        }
                       
                        self.pageControlRecieveRequestMyRoom.numberOfPages = self.myRoomIdx.count
                        self.collectionViewRecieveRequestMyRoom.reloadData()
                        self.collectionViewRecieveRequest.reloadData()
                        
                    }catch let jsonError{
                        print("Error seriallizing json:",jsonError)
                    }
                    
                    //let response = json as! NSDictionary
                    
                case .failure(let error):
                    print("error: \(String(describing: error))")
                }
                
            }
        
        AF.request(URLSendRequest, method: .get ,encoding: URLEncoding.default,headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
            .responseJSON(){response in
                switch response.result{
                case .success(let json):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let jsonParsing = try JSONDecoder().decode(SendRequestParse.self, from: data)
                        
                        for i in 0 ..< jsonParsing.count{
                            self.sendRequestDate.append(jsonParsing[i].date)
                            self.sendRequestCollectionViewTag.append(self.collectionViewSendRequstChildTag)
                            self.collectionViewSendRequstChildTag += 1
                            self.pageControlCurrentNumberSendRequestCell.append(0)
                            
                            self.sendRequestRoomIdx.append([])
                            self.sendRequestRoomImage.append([])
                            self.sendRequestRoomTitle.append([])
                            self.sendRequestRoomLocation1.append([])
                            self.sendRequestRoomLocation2.append([])
                            self.sendRequestRoomTotal.append([])
                            self.sendReqeustRoomAge.append([])
                            
                            for j in 0 ..< jsonParsing[i].matched.count{
                                self.sendRequestRoomIdx[i].append(jsonParsing[i].matched[j].board.idx)
                                self.sendRequestRoomImage[i].append(jsonParsing[i].matched[j].board.img1)
                                self.sendRequestRoomTitle[i].append(jsonParsing[i].matched[j].board.title)
                                self.sendRequestRoomLocation1[i].append(jsonParsing[i].matched[j].board.location1)
                                self.sendRequestRoomLocation2[i].append(jsonParsing[i].matched[j].board.location2)
                                self.sendReqeustRoomAge[i].append(jsonParsing[i].matched[j].board.age)
                                self.sendRequestRoomTotal[i].append(jsonParsing[i].matched[j].board.numType)
                            }
                        }
                       
                        self.collectionViewSendRequestParent.reloadData()
                        
                    }catch let jsonError{
                        print("Error seriallizing json:",jsonError)
                    }
                    
                    //let response = json as! NSDictionary
                    
                case .failure(let error):
                    print("error: \(String(describing: error))")
                }
                
            }
        
        
    }
    
    @IBAction func pageControlRecievedRequestChange(_ sender: UIPageControl) {
        
    }
    
    @IBAction func pageControlSendRequestChange(_ sender: UIPageControl) {
        
    }
    
    @IBAction func segControlShowType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        //받은요청
        case 0:
            self.parentScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated:true)
        //보낸요청
        case 1:
            self.parentScrollView.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated:true)
        default:
            self.parentScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated:true)
        }
    }
    
    //스크롤시에 page control 조정
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        switch scrollView.tag{
        case self.collectionViewRecieveRequestMyRoom.tag:
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            self.pageControlRecieveRequestMyRoom.currentPage = Int(pageNumber)
            self.collectionViewRecieveRequest.reloadData()
        default:
            if(self.sendRequestCollectionViewTag.contains(scrollView.tag)){
                let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
                self.pageControlCurrentNumberSendRequestCell[scrollView.tag] = Int(pageNumber)
                let myIndexPath = IndexPath(row: 0, section: scrollView.tag)
                let cell = self.collectionViewSendRequestParent.cellForItem(at: myIndexPath) as! SendRequestParentCell
                cell.pageControlSendRequest.currentPage = Int(pageNumber)
                
            }

        }
    }
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//
//        switch collectionView.tag{
//        case self.collectionViewRecieveRequestMyRoom.tag:
//            self.pageControlRecieveRequestMyRoom.currentPage = indexPath.row
//            self.pageControlCurrentNumberRecievedRequest = indexPath.row
//            self.collectionViewRecieveRequest.reloadData()
//        default:
//            if(self.sendRequestCollectionViewTag.contains(collectionView.tag)){
//                self.pageControlCurrentNumberSendRequestCell[collectionView.tag] = indexPath.row
//                print("indexPath: \(indexPath)")
//                let myIndexPath = IndexPath(row: 0, section: collectionView.tag)
//                self.collectionViewSendRequestParent.reloadItems(at: [myIndexPath])
//            }
//
//        }
//    }
    
    //섹션의 갯수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView.tag{
        
        case self.collectionViewRecieveRequestMyRoom.tag:
            return 1
            
        case self.collectionViewRecieveRequest.tag:
            return 1
            
        case self.collectionViewSendRequestParent.tag:
            return self.sendRequestDate.count
            
        default:
            return 1
        }
    }
    
    //header custom 수행
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if(collectionView.tag == self.collectionViewSendRequestParent.tag){
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SendRequestParentCellHeader", for: indexPath) as! SendRequestParentCellHeader
            headerView.lblRequestDate.text = self.sendRequestDate[indexPath.section]
            
            //cell 테두리
            headerView.layer.borderColor = UIColor.black.cgColor
            headerView.layer.borderWidth = 2
            headerView.layer.cornerRadius = 10
            
            return headerView
        }
        else{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SendRequestParentCellHeader", for: indexPath) as! SendRequestParentCellHeader
            return headerView
        }
    }
    //셀의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case self.collectionViewRecieveRequestMyRoom.tag:
            return self.myRoomIdx.count
            
        case self.collectionViewRecieveRequest.tag:
            if(self.recievedRequestUserIdx == []){
                return 0
            }
            else{
                return self.recievedRequestUserIdx[self.pageControlRecieveRequestMyRoom.currentPage].count
            }
                
        case self.collectionViewSendRequestParent.tag:
            return 1
            
        default:
            if(self.sendRequestCollectionViewTag.contains(collectionView.tag)){
                return self.sendRequestRoomIdx[collectionView.tag].count
            }
        }
        return 0
    }
    
    //셀 커스텀 수행
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
        case self.collectionViewRecieveRequestMyRoom.tag:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecieveRequestMyRoomCell", for: indexPath)
                as! RecieveRequestMyRoomCell
            let url =  URL(string: self.myRoomImage[indexPath.row])
            do{
                let data = try Data(contentsOf: url!)
                cell.imgMyRoomPhoto.image = UIImage(data: data)
            }
            catch{
                cell.imgMyRoomPhoto.image = nil
            }
            cell.lblMyRoomTitle.text = self.myRoomTitle[indexPath.row]
            cell.lblMyRoomLocation1.text = self.myRoomLocation1[indexPath.row] + " " + self.myRoomLocation2[indexPath.row]
            //cell.lblMyRoomLocation2.text = self.myRoomLocation2[indexPath.row]
            cell.lblMyRoomTotal.text = self.myRoomTotal[indexPath.row]
            
            //cell 테두리
            cell.shadowDecorate()
            
            return cell
            
        case self.collectionViewRecieveRequest.tag:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecieveRequestCell", for: indexPath)
                as! RecieveRequestCell
            let url =  URL(string: self.recievedRequestUserImage[self.pageControlRecieveRequestMyRoom.currentPage][indexPath.row])
            do{
                let data = try Data(contentsOf: url!)
                cell.imgOtherUserPhoto.image = UIImage(data: data)
            }
            catch{
                cell.imgOtherUserPhoto.image = nil
            }
            cell.lblOtherUserNickName.text = self.recievedRequestUserNickName[self.pageControlRecieveRequestMyRoom.currentPage][indexPath.row]
            cell.lblOtherUserAge.text = self.recievedRequestUserAge[self.pageControlRecieveRequestMyRoom.currentPage][indexPath.row]
            if(self.recievedRequestStatus[pageControlRecieveRequestMyRoom.currentPage][indexPath.row]){
                cell.lblPayStatus.text = "상대방이 결제완료"
            }
            else{
                cell.lblPayStatus.text = "결제 안됨"
            }
            //cell 테두리
            cell.shadowDecorate()
            
            
            return cell
            
        case self.collectionViewSendRequestParent.tag:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SendRequestParentCell", for: indexPath)
                as! SendRequestParentCell
            print(self.pageControlCurrentNumberSendRequestCell)
            cell.pageControlSendRequest.numberOfPages = self.sendRequestRoomIdx[indexPath.section].count
            cell.pageControlSendRequest.currentPage = self.pageControlCurrentNumberSendRequestCell[indexPath.section]
            cell.collectionViewSendRequestChild.tag = self.sendRequestCollectionViewTag[indexPath.section]
            cell.collectionViewSendRequestChild.reloadData()
            //cell 테두리
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 2
            cell.layer.cornerRadius = 10
            
            return cell
            
        default:
            if(self.sendRequestCollectionViewTag.contains(collectionView.tag)){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SendRequestChildCell", for: indexPath)
                    as! SendRequestChildCell
                print(self.sendRequestRoomImage)
                print(indexPath)
                let url =  URL(string: self.sendRequestRoomImage[collectionView.tag][indexPath.row])
                do{
                    let data = try Data(contentsOf: url!)
                    cell.imgSendRequestRoomPhoto.image = UIImage(data: data)
                }
                catch{
                    cell.imgSendRequestRoomPhoto.image = nil
                }
                cell.lblSendRequestRoomTitle.text = self.sendRequestRoomTitle[collectionView.tag][indexPath.row]
                cell.lblSendRequestRoomLocation1.text = self.sendRequestRoomLocation1[collectionView.tag][indexPath.row] + " " + self.sendRequestRoomLocation2[collectionView.tag][indexPath.row]
                //cell.lblSendRequestRoomLocation2.text = self.sendRequestRoomLocation2[collectionView.tag][indexPath.row]
                cell.lblSendRequestRoomTotal.text = self.sendRequestRoomTotal[collectionView.tag][indexPath.row]
                
                //cell 테두리
                cell.shadowDecorate()
                
                return cell
            }
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecieveRequestMyRoomCell", for: indexPath)
            as! RecieveRequestMyRoomCell
        return cell
    
    }
    
    //section header margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView.tag{
        case self.collectionViewSendRequestParent.tag:
            return UIEdgeInsets(top: 10, left: 0, bottom: 80, right: 0)
            
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
    }
    
    //행당 1개씩 셀 출력을 위해서
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        switch collectionView.tag{
        case self.collectionViewRecieveRequestMyRoom.tag:
            return CGSize(width: width * 1, height: width * 0.9)
            
        case self.collectionViewRecieveRequest.tag:
            return CGSize(width: width * 0.8, height: 100)
            
        case self.collectionViewSendRequestParent.tag:
            return CGSize(width: width * 1, height: width * 1.1)
            
        default:
            return CGSize(width: width * 1, height: width * 0.9)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView.tag{
        case self.collectionViewRecieveRequest.tag:
            return 10
            
        default:
            return 0
        
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1: determining whether scrollview is scrolling up or down
        goingUp = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        
        // 2: maximum contentOffset y that parent scrollView can have
        let parentViewMaxContentYOffset = scrollViewRecieveRequest.contentSize.height - scrollViewRecieveRequest.frame.height
        
        // 3: if scrollView is going upwards
        if goingUp! {
            // 4:  if scrollView is a child scrollView
            
            if (scrollView.tag == self.collectionViewRecieveRequest.tag) {
                // 5:  if parent scroll view is't scrolled maximum (i.e. menu isn't sticked on top yet)
                if scrollViewRecieveRequest.contentOffset.y < parentViewMaxContentYOffset && !childScrollingDownDueToParent {
                    
                    // 6: change parent scrollView contentOffset y which is equal to minimum between maximum y offset that parent scrollView can have and sum of parentScrollView's content's y offset and child's y content offset. Because, we don't want parent scrollView go above sticked menu.
                    // Scroll parent scrollview upwards as much as child scrollView is scrolled
                    scrollViewRecieveRequest.contentOffset.y = min(scrollViewRecieveRequest.contentOffset.y + collectionViewRecieveRequest.contentOffset.y, parentViewMaxContentYOffset)
                    
                    // 7: change child scrollView's content's y offset to 0 because we are scrolling parent scrollView instead with same content offset change.
                    collectionViewRecieveRequest.contentOffset.y = 0
                }
            }
        }
            // 8: Scrollview is going downwards
        else {
            
            if (scrollView.tag == self.collectionViewRecieveRequest.tag) {
                // 9: when child view scrolls down. if childScrollView is scrolled to y offset 0 (child scrollView is completely scrolled down) then scroll parent scrollview instead
                // if childScrollView's content's y offset is less than 0 and parent's content's y offset is greater than 0
                if collectionViewRecieveRequest.contentOffset.y < 0 && scrollViewRecieveRequest.contentOffset.y > 0 {
                    
                    // 10: set parent scrollView's content's y offset to be the maximum between 0 and difference of parentScrollView's content's y offset and absolute value of childScrollView's content's y offset
                    // we don't want parent to scroll more that 0 i.e. more downwards so we use max of 0.
                    scrollViewRecieveRequest.contentOffset.y = max(scrollViewRecieveRequest.contentOffset.y - abs(collectionViewRecieveRequest.contentOffset.y), 0)
                }
            }
            
            // 11: if downward scrolling view is parent scrollView
            if scrollView == scrollViewRecieveRequest {
                // 12: if child scrollView's content's y offset is greater than 0. i.e. child is scrolled up and content is hiding up
                // and parent scrollView's content's y offset is less than parentView's maximum y offset
                // i.e. if child view's content is hiding up and parent scrollView is scrolled down than we need to scroll content of childScrollView first
                if collectionViewRecieveRequest.contentOffset.y > 0 && scrollViewRecieveRequest.contentOffset.y < parentViewMaxContentYOffset {
                    // 13:  set if scrolling is due to parent scrolled
                    childScrollingDownDueToParent = true
                    // 14:  assign the scrolled offset of parent to child not exceding the offset 0 for child scroll view
                    collectionViewRecieveRequest.contentOffset.y = max(collectionViewRecieveRequest.contentOffset.y - (parentViewMaxContentYOffset - scrollViewRecieveRequest.contentOffset.y), 0)
                    // 15:  stick parent view to top coz it's scrolled offset is assigned to child
                    scrollViewRecieveRequest.contentOffset.y = parentViewMaxContentYOffset
                    childScrollingDownDueToParent = false
                }
            }
        }
    }
    //cell 이 터치시 수행하는 함수
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case self.collectionViewRecieveRequestMyRoom.tag:
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "MyRoomDetailViewController") as?
                MyRoomDetailViewController else { return}
            controller.boardIdx = self.myRoomIdx[indexPath.row]
            controller.modalPresentationStyle = .fullScreen
            present(controller,animated: true, completion: nil)
        
        case self.collectionViewRecieveRequest.tag:
//            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailRoomViewController") as?
//                DetailRoomViewController else { return}
//
//            controller.modalPresentationStyle = .fullScreen
//            present(controller,animated: true, completion: nil)
            return
        default:
            if(self.sendRequestCollectionViewTag.contains(collectionView.tag)){
                guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailRoomViewController") as?
                        DetailRoomViewController else { return}
                controller.boardIdx = self.sendRequestRoomIdx[collectionView.tag][indexPath.row]
                controller.beforeController = "MyListViewController"
                controller.modalPresentationStyle = .fullScreen
                present(controller, animated: true, completion: nil)
            }
        }

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
protocol CustomCellDelegate: class {
    func cellDidSetScrolling(enabled: Bool)
}

class RecieveRequestMyRoomCell:UICollectionViewCell{
    
    @IBOutlet var imgMyRoomPhoto: UIImageView!
    @IBOutlet var lblMyRoomTitle: UILabel!
    @IBOutlet var lblMyRoomLocation1: UILabel!
    @IBOutlet var lblMyRoomTotal: UILabel!
}

class RecieveRequestCell:UICollectionViewCell{
    
    @IBOutlet var imgOtherUserPhoto: UIImageView!
    @IBOutlet var lblOtherUserNickName: UILabel!
    @IBOutlet var lblOtherUserAge: UILabel!
    @IBOutlet var lblPayStatus: UILabel!
}

class SendRequestParentCellHeader:UICollectionReusableView{
    
    @IBOutlet var lblRequestDate: UILabel!
}

class SendRequestParentCell:UICollectionViewCell{
    @IBOutlet var pageControlSendRequest: UIPageControl!
    @IBOutlet var collectionViewSendRequestChild: UICollectionView!
    
}

class SendRequestChildCell:UICollectionViewCell{
    @IBOutlet var imgSendRequestRoomPhoto: UIImageView!
    @IBOutlet var lblSendRequestRoomTitle: UILabel!
    @IBOutlet var lblSendRequestRoomLocation1: UILabel!
    @IBOutlet var lblSendRequestRoomTotal: UILabel!
    
}


