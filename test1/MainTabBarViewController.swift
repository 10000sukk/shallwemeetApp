//
//  MainTabBarViewController.swift
//  test1
//
//  Created by 김환석 on 2020/10/11.
//  Copyright © 2020 김환석. All rights reserved.
//

import UIKit
import Alamofire

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let url = Config.baseURL + "/api/users/\(Config.userIdx!)"
        
        AF.request(url, method: .get, encoding: URLEncoding.default, headers: ["Content-Type":"application/json"]).validate(statusCode: 200 ..< 300).responseJSON(){response in
            switch(response.result){
            case .success(let json):
                do {
                    let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    let jsonParsing = try JSONDecoder().decode(UserParsing.self, from: data)
                    
                    Config.userGender = jsonParsing.gender
                        //reload collectionView
                    }catch let jsonError{
                        print("Error seriallizing json:",jsonError)
                    }
                
            case .failure(let error):
                print("error: \(String(describing: error))")
            }
            
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
extension UICollectionViewCell {
func shadowDecorate() {
    let radius: CGFloat = 10
    contentView.layer.cornerRadius = radius
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = UIColor.clear.cgColor
    contentView.layer.masksToBounds = true

    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 2.0)
    layer.shadowRadius = 6
    layer.shadowOpacity = 0.5
    layer.masksToBounds = false
    layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
    layer.cornerRadius = radius
    }
}
