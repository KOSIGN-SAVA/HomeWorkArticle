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
    
    func apiConfig(urlApi:String, methodType:String)->(URLSession, URLRequest){
        let url=URL(string: urlApi)
        var request=URLRequest(url: url!)
        request.addValue(HEADER, forHTTPHeaderField: ATHENTICATION)
        request.addValue("*/*", forHTTPHeaderField: "Accept")
        request.httpMethod=methodType
        let session=URLSession.shared
        return (session, request)
    }
    
    func fetchArticleDataFromAPI(page:Int, limit:Int) {
//        let url=URL(string: "\(ARTICLE_URL)?page=\(page)&limit=\(limit)")
//        var request=URLRequest(url: url!)
//        request.addValue(HEADER, forHTTPHeaderField: ATHENTICATION)
//        request.addValue("*/*", forHTTPHeaderField: "Accept")
//        let session=URLSession.shared
        let url="\(ARTICLE_URL)?page=\(page)&limit=\(limit)"
        let api=apiConfig(urlApi: url, methodType: "GET")
        api.0.dataTask(with: api.1, completionHandler: {(responseBody, httpResponse, error) in
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
    
    func deleteArticleDataFromAPI(id:Int){
        let delete=apiConfig(urlApi: "\(ARTICLE_URL)/\(id)", methodType: "DELETE")
        delete.0.dataTask(with: delete.1, completionHandler: {(responseBody, httpResponse, error) in
            print("Delete successfully: \(ARTICLE_URL)/\(id)")
        }).resume()
    }
    
}
