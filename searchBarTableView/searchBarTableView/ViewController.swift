//
//  ViewController.swift
//  searchBarTableView
//
//  Created by 남수김 on 05/08/2019.
//  Copyright © 2019 ns. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var items = [String]()
    let samples = ["서울", "부산", "온수", "건대", "온수", "부천", "송파", "가", "가나", "가나다", "가나다라", "가카타파하", "에이", "a", "ab", "abc", "apple", "mac", "azxy"]
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        input()
        
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: searchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath) as? searchTableViewCell else {fatalError()}
        cell.blueText.text = self.items[indexPath.row]
        
        return cell
    }
    
}

extension ViewController {
    private func input(){
        self.searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)   //0.5초 기다림
            .distinctUntilChanged()   // 같은 아이템을 받지 않는기능
            .subscribe(onNext: { t in
                self.items = self.samples.filter{ $0.hasPrefix(t) }
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}
