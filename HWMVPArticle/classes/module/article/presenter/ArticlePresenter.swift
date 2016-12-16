//
//  ArticlePresenter.swift
//  HWMVPArticle
//
//  Created by Vansa Pha on 12/14/16.
//  Copyright © 2016 Vansa Pha. All rights reserved.
//

import Foundation

class ArticlePresenter:ModelProtocol{
    
    var data:ArticleService?
    var delegate:ArticlePresenterProtocol?
    
    init() {
        data=ArticleService()
        data?.delegate=self
    }
    
    func fetchArticle(page:Int, limit:Int) {
        delegate?.startFetchArticle()
        data?.fetchArticleDataFromAPI(page: page, limit: limit)
    }
    
    func deleteArticle(id:Int, index:Int){
        data?.deleteArticleDataFromAPI(id: id, index: index)
    }
    
    func postArticle(titleArt:String, descriptionArt:String, imgLink:String){
        data?.postArticleDataToAPI(titleArticle: titleArt, descriptionArticle: descriptionArt, imageLink: imgLink)
    }
    
    func success(_ article: [Article], method: String, index: Int) {
        switch method {
        case "GET":
            delegate?.responseData(article, method: method, index: index)
        case "DELETE":
            delegate?.responseData([], method: method, index: index)
        case "POST":
            delegate?.responseData([], method: method, index: index)
        default: break
        }
    }
    
    func error(method:String) {
        delegate?.responseDataError()
    }
    
}
