//
//  FavoriteListViewController.swift
//  test1
//
//  Created by 김환석 on 2020/10/10.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit
import Alamofire

class FavoriteListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionViewMyFavorite: UICollectionView!
    
    var boardIdx:[Int] = []
    var boardimg1:[String] = []
    var boardLocation1:[String] = []
    var boardLocation2:[String] = []
    var boardAge:[Int] = []
    var boardTotal:[String] = []
   
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.boardIdx = []
        self.boardimg1 = []
        self.boardLocation1 = []
        self.boardLocation2 = []
        self.boardAge = []
        self.boardTotal = []
        
        let url = Config.baseURL + "/api/bookmark" + "/\(Config.userIdx!)"

        AF.request(url, method: .get ,encoding: URLEncoding.default,headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
            .responseJSON(){response in
                switch response.result{
                case .success(let json):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let jsonParsing = try JSONDecoder().decode(FavoriteParse.self, from: data)
                        for i in 0 ..< jsonParsing.count{
                            self.boardIdx.append(jsonParsing[i].board.idx)
                            self.boardimg1.append(jsonParsing[i].board.img1)
                            self.boardLocation1.append(jsonParsing[i].board.location1)
                            self.boardLocation2.append(jsonParsing[i].board.location2)
                            self.boardAge.append(jsonParsing[i].board.age)
                            self.boardTotal.append(jsonParsing[i].board.numType)
                            
                        
                            //reload collectionView
                        }
                        self.collectionViewMyFavorite.reloadData()
                        
                    }catch let jsonError{
                        print("Error seriallizing json:",jsonError)
                    }
                    
                    //let response = json as! NSDictionary
                    
                case .failure(let error):
                    print("error: \(String(describing: error))")
                }
                
            }
        
    }
    //star click -> remove cell
    @IBAction func btnCellFavoriteStar(_ sender: UIButton) {
        let contentView = sender.superview
        let cell = contentView?.superview as! UICollectionViewCell
        let index = collectionViewMyFavorite.indexPath(for: cell)
        let url  = Config.baseURL + "/api/bookmark/\(Config.userIdx!)/\(self.boardIdx[index!.row])"
        print(url)
        AF.request(url, method: .delete , encoding: URLEncoding.default, headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300)
            .responseJSON(){response in
                switch response.result{
                case .success(let json):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let jsonParsing = try JSONDecoder().decode(CodeAndMessage.self, from: data)
                        if (jsonParsing.code == 200){
                            self.boardIdx.remove(at: index!.row)
                            self.boardimg1.remove(at: index!.row)
                            self.boardLocation1.remove(at: index!.row)
                            self.boardLocation2.remove(at: index!.row)
                            self.boardTotal.remove(at: index!.row)
                            self.boardAge.remove(at: index!.row)
                            self.collectionViewMyFavorite.deleteItems(at: [index!])
                        }
                    }catch let jsonError{
                        print("Error seriallizing json:",jsonError)
                    }
                case .failure(let error):
                    print("error: \(String(describing: error))")
                }
        }
    }
    
    
    
    //셀의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boardIdx.count
    }
    
    //셀 커스텀 수행
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyFavoriteCell", for: indexPath) as! MyFavoriteCustomCell
        let url =  URL(string: boardimg1[indexPath.row])
        do{
            let data = try Data(contentsOf: url!)
            cell.imgCellFavoritePhoto.image = UIImage(data: data)
        }
        catch{
            cell.imgCellFavoritePhoto.image = nil
        }
        cell.lblCellFavoriteLocation1.text = boardLocation1[indexPath.row] + " " + boardLocation2[indexPath.row]
        cell.lblCellFavoriteAge.text = "\(String(describing: boardAge[indexPath.row]))"
        cell.lblCellFavoriteTotal.text = boardTotal[indexPath.row]
        
        //cell 테두리
        cell.shadowDecorate()
        
        return cell
    }
    
    //행당 2개씩 셀 출력을 위해서
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width1 = collectionView.frame.size.width / 2.4
        return CGSize(width: width1, height: width1 * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    //cell 이 터치시 수행하는 함수
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailRoomViewController") as?
            DetailRoomViewController else { return}
        controller.boardIdx = self.boardIdx[indexPath.row]
        controller.cellIndexPath = indexPath
        controller.beforeController = "FavoriteListViewController"
        controller.modalPresentationStyle = .fullScreen
        present(controller,animated: true, completion: nil)
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

class MyFavoriteCustomCell:UICollectionViewCell{
    
    @IBOutlet var imgCellFavoritePhoto: UIImageView!
    @IBOutlet var btnCellFavoriteStar: UIButton!
    @IBOutlet var lblCellFavoriteLocation1: UILabel!
    @IBOutlet var lblCellFavoriteAge: UILabel!
    @IBOutlet var lblCellFavoriteTotal: UILabel!
    
}
