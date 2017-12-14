//
//  ViewController.swift
//  UserTracker
//
//  Created by Carlos Cortés Sánchez on 14/12/2017.
//  Copyright © 2017 Carlos Cortés Sánchez. All rights reserved.
//

import UIKit
import ObjectMapper
import RxAlamofire
import RxCocoa
import RxSwift

class RepositoriesViewController: UIViewController {

    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var repositoryNetworkModel: RepositoryNetworkModel!
    
    var rx_searchBarText: Observable<String> {
        return searchBar.rx.text
            .filter { $0 != nil }
            .map { $0! }
            .filter { $0.count > 0 }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }
    
    func setupRx() {
        repositoryNetworkModel = RepositoryNetworkModel.init(withNameObservable: rx_searchBarText)
        
        repositoryNetworkModel
            .rx_respositories
            .drive(tableView.rx.items) { (tv,i,repository) in
                let cell = tv.dequeueReusableCell(withIdentifier: "repositoryCell", for: IndexPath(row: i, section: 0))
                cell.textLabel?.text = repository.name
                
                return cell
        }
            .disposed(by: disposeBag)
        
        repositoryNetworkModel
            .rx_respositories.drive(onNext: { repositories in
                if repositories.count == 0 {
                    let alert = UIAlertController(title: ":(", message: "No repositories found for this user", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    if self.navigationController?.visibleViewController?.isMember(of: UIAlertController.self) != true {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
        })
            .disposed(by: disposeBag)
    }
    
}

