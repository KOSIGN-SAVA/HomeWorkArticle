//
//  ArticlePresenterProtocol.swift
//  HWMVPArticle
//
//  Created by Vansa Pha on 12/14/16.
//  Copyright © 2016 Vansa Pha. All rights reserved.
//

import Foundation

protocol ArticlePresenterProtocol {
    func startFetchArticle()
    func responseData(_ data:[Article])
    func responseDataError()
}
