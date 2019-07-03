//
//  ViewController.swift
//  NYCSchoolChallenge
//
//  Created by Hudson Mcashan on 7/1/19.
//  Copyright © 2019 Guardian Angel. All rights reserved.
//

import UIKit
import RxSwift

class SchoolsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewModel: SchoolViewModel = SchoolViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Schools"
        bindTableView()
        bindLoadingView()
        bindError()
    }
    
    private func bindTableView() {
        tableView.dataSource = nil
        tableView.delegate = nil
        
        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: SchoolCell.identifier, cellType: SchoolCell.self)) { _,model,cell in
                cell.configure(with: model.schoolName)
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] (index) in
            self?.tableView.deselectRow(at: index, animated: true)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SchoolDetailViewController") as? SchoolDetailViewController, let schools = self?.viewModel.schools {
                vc.school = schools[index.row]
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
        }).disposed(by: disposeBag)
    }

    private func bindLoadingView() {
        viewModel.loading.subscribe(onNext: { [weak self] (isLoading) in
            guard let strongSelf = self else { return }
            isLoading ? showLoadingView(presenter: strongSelf) : removeLoadingView(remover: strongSelf)
        }).disposed(by: disposeBag)
    }
    
    private func bindError() {
        viewModel.error.subscribe(onNext: { [weak self] (error) in
            self?.showRetryError()
        }).disposed(by: disposeBag)
    }
    
    private func showRetryError() {
        let alert = UIAlertController(title: "Error", message: "There was a problem retrieving School Data", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action: UIAlertAction!) in
            self.viewModel.refresh()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

func showLoadingView(presenter: UIViewController) {
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.style = UIActivityIndicatorView.Style.gray
    loadingIndicator.startAnimating();

    alert.view.addSubview(loadingIndicator)
    presenter.present(alert, animated: true, completion: nil)
}

func removeLoadingView(remover: UIViewController) {
    remover.dismiss(animated: false, completion: nil)
}


