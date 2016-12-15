//
//  ArticleService.swift
//  HWMVPArticle
//
//  Created by Vansa Pha on 12/14/16.
//  Copyright © 2016 Vansa Pha. All rights reserved.
//

import Foundation

class ArticleService{
    
    var delegate:ModelProtocol?
    
    func fetchArticleDataFromAPI() {
        let url=URL(string: ARTICLE_URL)
        var request=URLRequest(url: url!)
        request.addValue(HEADER, forHTTPHeaderField: ATHENTICATION)
        request.addValue("*/*", forHTTPHeaderField: "Accept")
        let session=URLSession.shared
        session.dataTask(with: request, completionHandler: {(responseBody, httpResponse, error) in
            if error==nil {
                let json=try! JSONSerialization.jsonObject(with: responseBody!, options: .allowFragments) as! [String:AnyObject]
                let arrData=json["DATA"] as! [AnyObject]
                var arrArticle:[Article]=[]
                for data in arrData {
                    var art=Article()
                    art.id=data["ID"] as! Int
                    art.title=data["TITLE"] as! String
                    art.createDate=data["CREATED_DATE"] as! String
                    art.description=data["DESCRIPTION"] as! String
                    art.image=data["IMAGE"] as! String
                    arrArticle.append(art)
                }
                self.delegate?.success(arrArticle)
            }else{
                self.delegate?.error()
            }
        }).resume()
    }
    
}
