//
//  URLSettings.swift
//  NYCSchoolChallenge
//
//  Created by Hudson Mcashan on 11/21/19.
//  Copyright © 2019 Guardian Angel. All rights reserved.
//

import Foundation

struct URLSettings {
    
    private var baseURL: String {
        get {
            if ProcessInfo.processInfo.arguments.contains("TESTING") {
                return "http://localhost:8080/test"
            } else {
                return "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
            }
        }
    }
    
    var url: String {
        get {
            return baseURL
        }
    }
    
}
