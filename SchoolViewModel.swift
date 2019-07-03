//
//  SchoolViewModel.swift
//  NYCSchoolChallenge
//
//  Created by Hudson Mcashan on 7/1/19.
//  Copyright © 2019 Guardian Angel. All rights reserved.
//

import Foundation
import RxSwift

class SchoolViewModel {
    private let dataFetcher = DataFetcher()
    private let disposeBag = DisposeBag()
    var schools: [School]? = nil
    let data: BehaviorSubject<[School]> = BehaviorSubject<[School]>(value: [])
    let loading: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)
    let error: PublishSubject<String> = PublishSubject<String>()
    
    init() {
        refresh()
    }
    
    func refresh() {
        loading.onNext(true)
        dataFetcher.getSchools { [weak self] (schools, error) in
            if error != "" {
                self?.loading.onNext(false)
                self?.error.onNext("\(error)")
            }
            if let schools = schools {
                self?.schools = schools
                self?.loading.onNext(false)
                self?.data.onNext(schools)
            }
        }
    }
}
