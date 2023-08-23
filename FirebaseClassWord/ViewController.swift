//
//  ViewController.swift
//  FirebaseClassWord
//
//  Created by Olzhas Zhakan on 23.08.2023.
//

import UIKit
import SnapKit
import FirebaseDatabase

class ViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let items: [String] = ["hello", "world"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .white
        setupView()
        makeConstriants()
    }


}

private extension ViewController {
    func setupView() {
        title = "Firebase"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
      

    }
    func makeConstriants() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    
}
