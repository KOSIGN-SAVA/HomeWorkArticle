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
    
    func fetchArticle() {
        delegate?.startFetchArticle()
        data?.fetchArticleDataFromAPI()
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
