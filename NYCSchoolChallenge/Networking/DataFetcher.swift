//
//  DataFetcher.swift
//  NYCSchoolChallenge
//
//  Created by Hudson Mcashan on 7/1/19.
//  Copyright © 2019 Guardian Angel. All rights reserved.
//

import Foundation

class DataFetcher {
    typealias SchoolResult = ([School]?, String) -> ()
    typealias SATScoresResult = ([SATScore]?, String) -> ()
    var errorMessage = ""
    var schools = [School]()
    var scores = [SATScore]()
    private let baseURL = URLSettings().url
    private let appToken = "q0PYN8tb6ePysPjXE6ylZcA2B"
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func getSchools(completion: @escaping SchoolResult) {
        dataTask?.cancel()
        guard let url = URL(string: "\(baseURL)") else {
            print("Invalid URL string, could not convert to URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //urlRequest.setValue(appToken, forHTTPHeaderField: "X-App-Token")
        
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer { self.dataTask = nil }
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                self.parseData(data, completion: completion)
            }
        }
        dataTask?.resume()
    }
    
    private func parseData(_ data: Data, completion: @escaping SchoolResult) {
        schools.removeAll()
        
        let response = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any]
        guard let unwrappedResponse = response else {
            print("Response was not serialized properly")
            return
        }
        for dict in unwrappedResponse {
            guard let dict = dict as? [String:Any],
                let schoolName = dict["school_name"] as? String,
                let boro = dict["boro"] as? String,
                let location = dict["location"] as? String,
                let phoneNumber = dict["phone_number"] as? String,
                let totalStudents = dict["total_students"] as? String,
                let numStudents = Int(totalStudents) else {
                    print("response was not parsed properly")
                    errorMessage += "Dictionary does not contain schools key\n"
                    return
                }
            var school: School
            if let satScores = dict["requirement2_1"] as? String {
               school = School(schoolName: schoolName, boro: boro, location: location, phoneNumber: phoneNumber, totalStudents: numStudents, satScores: satScores)
            } else {
                school = School(schoolName: schoolName, boro: boro, location: location, phoneNumber: phoneNumber, totalStudents: numStudents, satScores: nil)
            }
            
            schools.append(school)
        }
        DispatchQueue.main.async {
            completion(self.schools, self.errorMessage)
        }
    }
}
