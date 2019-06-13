//
//  HomeViewController.swift
//  AppRealTestTask
//
//  Created by Roman Rybachenko on 6/13/19.
//  Copyright © 2019 Roman Rybachenko. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var persons: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        persons = Person.allPersons(in: CoreDataStack.shared.mainContext)
        setupTableView()
    }
    

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let frame = CGRect(x: 0, y: 0, width: 0.1, height: 0.1)
        tableView.tableFooterView = UIView(frame: frame)
        
        let pNib = UINib(nibName: "PersonTableViewCell", bundle: nil)
        tableView.register(pNib, forCellReuseIdentifier: PersonTableViewCell.reuseIdentifier)
    }
    
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(forIndexPath: indexPath) as PersonTableViewCell
        cell.person = persons[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pf()
        // TODO: - show details vc
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PersonTableViewCell.height()
    }
}
