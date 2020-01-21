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

// section Model
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
        MySection(header: "A", items: [1, 2, 3]),
        MySection(header: "B", items: [4, 5])
    ]
    private var subject: BehaviorRelay<[MySection]> = BehaviorRelay(value: [])
    override func viewDidLoad() {
        super.viewDidLoad()

        // tableView 정의
        let nib = UINib(nibName: "TestTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TestCell")
        
        // dataSource 정의
        let dataSource = RxTableViewSectionedReloadDataSource<MySection>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as! TestTableViewCell
                cell.selectionStyle = .none
                cell.testLabel?.text = "Item \(item)"
                return cell
        })
        
        // 처음값 초기화
        subject.accept(sections)
        
        //섹션 문자
        dataSource.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].header
        }
        
        //오른쪽 인디케이터 문자
        dataSource.sectionIndexTitles = { ds in
            return ds.sectionModels.map { $0.header }
        }
        
        //오른쪽 인디케이터 문자와 인덱스참조가능
        dataSource.sectionForSectionIndexTitle = { ds, title, index in
            print(title)
            print(index)
            return ds.sectionModels.map { $0.header }.firstIndex(of: title) ?? 0
        }
        
        self.dataSource = dataSource
        
        // delegate 사용을 위한 선언
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // binding
        subject
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
    @IBAction func randomAction(_ sender: Any) {
        sections.append(MySection(header: "C", items: [6, 7, 8]))
        sections.append(MySection(header: "D", items: [4, 5]))
        subject.accept(sections)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = dataSource?[indexPath], dataSource?[indexPath.section] != nil else { return 0.0 }
        
        return CGFloat(40 + item * 10)
    }
}
