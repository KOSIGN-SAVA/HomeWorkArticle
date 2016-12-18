//
//  ArticleService.swift
//  HWMVPArticle
//
//  Created by Vansa Pha on 12/14/16.
//  Copyright © 2016 Vansa Pha. All rights reserved.
//

import Foundation
import UIKit

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
                    
                    if data["TITLE"] is NSNull{
                        art.title=""
                    }else{
                        art.title=data["TITLE"] as! String
                    }
                    
                    if data["DESCRIPTION"] is NSNull{
                        art.createDate=""
                    }else{
                        art.createDate=data["CREATED_DATE"] as! String
                    }
                    
                    if data["DESCRIPTION"] is NSNull{
                        art.description=""
                    }else{
                        art.description=data["DESCRIPTION"] as! String
                    }
                    
                    if data["IMAGE"] is NSNull{
                        art.image=""
                    }else{
                        art.image=data["IMAGE"] as! String
                    }
                    
                    arrArticle.append(art)
                }
                self.delegate?.success(arrArticle, method: "GET", index: 0)
            }else{
                self.delegate?.error(method: "GET")
            }
        }).resume()
    }
    
    func fetchArticleDataFromAPIByID(id:Int) {
        let url="\(ARTICLE_URL)/\(id)"
        let api=apiConfig(urlApi: url, methodType: "GET")
        api.0.dataTask(with: api.1, completionHandler: {(responseBody, httpResponse, error) in
            if error==nil {
                let json=try! JSONSerialization.jsonObject(with: responseBody!, options: .allowFragments) as! [String:AnyObject]
                let arrData=json["DATA"] as AnyObject
                var arrArticle:[Article]=[]
                var art=Article()
                art.id=arrData["ID"] as! Int
                art.title=arrData["TITLE"] as! String
                art.createDate=arrData["CREATED_DATE"] as! String
                art.description=arrData["DESCRIPTION"] as! String
                if arrData["IMAGE"] is NSNull{
                    art.image=""
                }else{
                    art.image=arrData["IMAGE"] as! String
                arrArticle.append(art)
                }
                self.delegate?.success(arrArticle, method: "GET", index: 0)
            }else{
                self.delegate?.error(method: "GET")
            }
        }).resume()
    }
    
    func deleteArticleDataFromAPI(id:Int, index:Int){
        let delete=apiConfig(urlApi: "\(ARTICLE_URL)/\(id)", methodType: "DELETE")
        delete.0.dataTask(with: delete.1, completionHandler: {(responseBody, httpResponse, error) in
            if error==nil{
                self.delegate?.success([], method: "DELETE", index: index)
            }else{
                self.delegate?.error(method: "DELETE")
            }
        }).resume()
    }
    
    func uploadSingleImage(image:UIImageView){
        let data = UIImagePNGRepresentation(image.image!)
        let url = URL(string: "http://120.136.24.174:1301/v1/api/uploadfile/single")
        var request = URLRequest(url: url!)
        request.httpMethod="POST"
        request.addValue(HEADER, forHTTPHeaderField: ATHENTICATION)
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var formData = Data()
        let mimeType = "image/png"
        formData.append("--\(boundary)\r\n".data(using: .utf8)!)
        formData.append("Content-Disposition: form-data; name=\"FILE\"; filename=\"Image.png\"\r\n".data(using: .utf8)!)
        formData.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        formData.append(data!)
        formData.append("\r\n".data(using: .utf8)!)
        formData.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = formData
        let uploadTask = URLSession.shared.dataTask(with: request){ data, response, error in
            var imageResponse: String?
            if error == nil{
                print("Success : \(response)")
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                    imageResponse = json["DATA"] as? String
                    print("Image url: \(imageResponse!)")
                    self.delegate?.returnUploadedURLImage(urlImg: imageResponse!)
                }catch let error{
                    print("Error : \(error.localizedDescription)")
                }
            }else{
                print("\(error?.localizedDescription)")
            }
        }
        uploadTask.resume()
    }
    
    func postArticleDataToAPI(titleArticle:String, descriptionArticle:String, imageLink:String){
        let data=[
            "TITLE":titleArticle,
            "DESCRIPTION":descriptionArticle,
            "AUTHOR": 0,
            "CATEGORY_ID": 0,
            "STATUS": "active",
            "IMAGE": imageLink
        ] as [String:Any]
        var post=apiConfig(urlApi: ARTICLE_URL, methodType: "POST")
        post.1.addValue("application/json", forHTTPHeaderField: "Content-Type")
        post.1.httpBody=try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        post.0.dataTask(with: post.1, completionHandler: {(responseBody, httpResponse, error) in
            if error==nil {
                self.delegate?.success([], method: "POST", index: 0)
            }else{
                self.delegate?.error(method: "POST")
            }
        }).resume()
    }
    
    func updateArticleDataToAPI(titleArticle:String, descriptionArticle:String, imageLink:String, id:Int){
        let data=[
            "TITLE":titleArticle,
            "DESCRIPTION":descriptionArticle,
            "AUTHOR": 0,
            "CATEGORY_ID": 0,
            "STATUS": "active",
            "IMAGE": imageLink
            ] as [String:Any]
        var post=apiConfig(urlApi: "\(ARTICLE_URL)/\(id)", methodType: "PUT")
        post.1.addValue("application/json", forHTTPHeaderField: "Content-Type")
        post.1.httpBody=try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        post.0.dataTask(with: post.1, completionHandler: {(responseBody, httpResponse, error) in
            if error==nil {
                self.delegate?.success([], method: "PUT", index: 0)
            }else{
                self.delegate?.error(method: "PUT")
            }
        }).resume()
    }
    
}

















