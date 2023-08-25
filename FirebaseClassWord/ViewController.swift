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
    lazy var ref = Database.database().reference()
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var items: [String] = []
    var keys: [String] = []
    let noteDetailVC = NoteDetailViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupView()
        makeConstriants()
        observe()
    }


}

private extension ViewController {
    func observe() {
        ref.child("items").observe(.value) { snapshot in
            if  let itemsDictonary = snapshot.value as? [String: String] {
                self.items = itemsDictonary.map {$0.value}
                self.keys = itemsDictonary.map {$0.key}
                self.tableView.reloadData()
            }
            
        }
    }
    func setupView() {
        title = "Notes"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
      
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add)
        navigationItem.rightBarButtonItem?.primaryAction = UIAction { _ in
            self.addItem()
            
        }

    }
    func addItem() {
            let alertController = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
            alertController.addTextField()
            
            let action = UIAlertAction(title: "Add", style: .default) { _ in
                guard let itemName = alertController.textFields?[0].text else { return }
                self.ref.child("items").childByAutoId().setValue(itemName)
            }
            
            alertController.addAction(action)
            self.present(alertController, animated: true)
        }
    func makeConstriants() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let key = keys[indexPath.row]
        ref.child("items").child(key).removeValue()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = items[indexPath.row]
        let key = keys[indexPath.row]
        
        
      
        
       noteDetailVC.noteValue = value
     noteDetailVC.noteKey = key
        noteDetailVC.createTextView()
        
        navigationController?.pushViewController(noteDetailVC, animated: true)
    }
}


class NoteDetailViewController: UIViewController, UITextViewDelegate {
    var noteValue: String?
    var noteKey: String?
    private var textView:  UITextView!
    lazy var ref = Database.database().reference()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    
    }
    
    
    func createTextView() {
        textView = UITextView()
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(textView)
        textView.delegate = self
        textView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
                        $0.centerX.equalToSuperview()
                        $0.left.right.equalToSuperview().inset(25)
                        $0.height.equalToSuperview()
        }
        textView.text = noteValue ?? ""
    }
    
    func updateNote(newValue: String) {
        guard let noteKey = noteKey else {
            return
        }
        let noteRef = ref.child("items").child(noteKey)
        noteRef.setValue(newValue)  { error, reference in
            if let error = error {
                print(error)
            } else {
                print("l")
            }
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if let updatedText = textView.text {
            updateNote(newValue: updatedText)
        }
    }
}
