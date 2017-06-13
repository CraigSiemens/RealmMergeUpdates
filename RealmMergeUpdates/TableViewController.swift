//
//  TableViewController.swift
//  RealmMergeUpdates
//
//  Created by Craig Siemens on 2017-06-06.
//  Copyright © 2017 Craig Siemens. All rights reserved.
//

import RealmSwift
import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet weak var animatedSwitch: UISwitch!
    
    let realm = try! Realm()
    
    var results: [Results<Model>] = []
    var tokens: [NotificationToken] = []
    
    var movingModel: Model!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! realm.write {
            realm.deleteAll()
            
            // Create on opject that will move between sections
            movingModel = Model(number: 5)
            realm.add(movingModel)
            
            // Create 3 objects for the first section
            (1...3)
                .map(Model.init(number: ))
                .forEach { realm.add($0) }
            
            // Create 3 objects for the second section
            (17...19)
                .map(Model.init(number: ))
                .forEach { realm.add($0) }
        }
        
        results = [
            realm.objects(Model.self).sorted(byKeyPath: "number").filter("number < 10"),
            realm.objects(Model.self).sorted(byKeyPath: "number").filter("number >= 10")
        ]
        
        tokens = results
            .enumerated()
            .map { createToken(for: $1, at: $0) }
    }
    
    func createToken(for results: Results<Model>, at section: Int) -> NotificationToken {
        return results.addNotificationBlock { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                if self?.animatedSwitch.isOn ?? false {
                    tableView.beginUpdates()
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: section) }),
                                         with: .automatic)
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: section)}),
                                         with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: section) }),
                                         with: .automatic)
                    tableView.endUpdates()
                } else {
                    tableView.reloadData()
                }
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        try! realm.write {
            movingModel.number = (movingModel.number + 10) % 20
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(results[indexPath.section][indexPath.row].number)"
        return cell
    }
}

