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
    
    func deleteArticle(id:Int){
        data?.deleteArticleDataFromAPI(id: id)
    }
    
    func success(_ article: [Article]) {
        print("Our data from presenter: \(article)")
        delegate?.responseData(article)
    }
    
    func error() {
        print("error get data")
        delegate?.responseDataError()
    }
    
}
