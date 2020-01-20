//
//  ViewController.swift
//  prac_rxTableView
//
//  Created by 남수김 on 2020/01/20.
//  Copyright © 2020 ns. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

struct MySection {
    var header: String
    var items: [Item]
}

// section binding
extension MySection: AnimatableSectionModelType {
    typealias Item = Int
    
    init(original: MySection, items: [Int]) {
        self = original
        self.items = items
    }
    
    var identity: String {
        return header
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var random: UIButton!
    
    let disposeBag = DisposeBag()
    var dataSource: RxTableViewSectionedReloadDataSource<MySection>!
    var sections = [
        MySection(header: "First Section", items: [1, 2, 3]),
        MySection(header: "Second Section", items: [4, 5])
    ]
    let subject = PublishSubject<[MySection]>()
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        //        var sections = [
        //            MySection(header: "First Section", items: [1, 2, 3]),
        //            MySection(header: "Second Section", items: [4, 5])
        //        ]
        
        let nib = UINib(nibName: "TestTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TestCell")
        let dataSource = RxTableViewSectionedReloadDataSource<MySection>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as! TestTableViewCell
                cell.selectionStyle = .none
                cell.testLabel?.text = "Item \(item)"
                return cell
        })
        dataSource.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].header
        }
        self.dataSource = dataSource
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        subject.observeOn(MainScheduler.instance)
            .subscribe(onNext: { items in
                print(items)
                self.sections = items
                
            //datasource refresh?
                
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        
    }
    @IBAction func randomAction(_ sender: Any) {
        sections = [
            MySection(header: "First Section", items: [6, 7, 8]),
            MySection(header: "Second Section", items: [4, 5])
        ]
        
        subject.onNext(sections)
        
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = dataSource?[indexPath], dataSource?[indexPath.section] != nil else { return 0.0 }
        
        return CGFloat(40 + item * 10)
    }
}
