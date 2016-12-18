//
//  ModelProtocol.swift
//  HWMVPArticle
//
//  Created by Vansa Pha on 12/14/16.
//  Copyright © 2016 Vansa Pha. All rights reserved.
//

import Foundation

protocol ModelProtocol {
    func returnUploadedURLImage(urlImg:String)
    func success(_ article:[Article], method:String, index:Int)
    func error(method:String)
}
