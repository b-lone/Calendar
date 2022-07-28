//
//  BaseApi.swift
//  YCalendar
//
//  Created by 尤坤 on 2022/7/27.
//

import UIKit
import AFNetworking

class BaseApi: NSObject {
    override init() {
        super.init()
        
        let configuration = URLSessionConfiguration.default
        let manager = AFURLSessionManager(sessionConfiguration: configuration)
        
        let url = URL(string: "https://9d85bbbd-d86f-49b3-a927-b519a90f8b11.mock.pstmn.io/1")
        
    }
}
