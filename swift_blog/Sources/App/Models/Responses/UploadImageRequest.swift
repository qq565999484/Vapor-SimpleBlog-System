//
//  UploadImageRequest.swift
//  App
//
//  Created by chenyh on 2018/11/19.
//

import Vapor
struct UploadImageRequest: Content {
    var file: File?
    
}
