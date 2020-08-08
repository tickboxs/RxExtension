//
//  ViewController.swift
//  RxExtension
//
//  Created by Charlie Cai on 8/8/20.
//  Copyright © 2020 tickboxs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewControllerCell:UITableViewCell {
    
    static let identifier = "ViewControllerCell"
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    var title:String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: 10, y: 10, width: 300, height: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(ViewControllerCell.self, forCellReuseIdentifier: ViewControllerCell.identifier)
        tableView.rowHeight = 55
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "RxExtension Example"
        
        let screen_width = UIScreen.main.bounds.width
        let screen_height = UIScreen.main.bounds.height
        
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        
        Observable.just(["UIAlertController","AppleLogin","WKWebView Loading Progress"])
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                cellIdentifier: ViewControllerCell.identifier,
                cellType: ViewControllerCell.self)) {
                    (index, title, cell) in
                    cell.title = title
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self](indexPath) in
            switch indexPath.row {
            case 0:
                UIAlertController(title:"Alert Title", message: "Alet Message", preferredStyle: .alert).rx.show(vc: self, actions: [("Confirm",.default),("Cancel",.cancel)]).subscribe(onNext: { (index) in
                        print(index)
                }).disposed(by: self.disposeBag)
            case 1:
                Apple.shared.rx.login().subscribe(onNext: { (credential) in
                    print(credential)
                }, onError: { (error) in
                    print(error)
                }).disposed(by: self.disposeBag)
            case 2:
                print("create a webView and subscribe to estimatedProgress property to see its loading progress")
            default:
                break
            }
        }).disposed(by: disposeBag)
        
    }
}


