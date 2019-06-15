//
//  HomeViewController.swift
//  AppRealTestTask
//
//  Created by Roman Rybachenko on 6/13/19.
//  Copyright © 2019 Roman Rybachenko. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var fetchResController: NSFetchedResultsController<Person> = {
        let sortDescr = NSSortDescriptor(key: "name", ascending: true)
        let fRequest = NSFetchRequest<Person>(entityName: Person.entityName)
        fRequest.sortDescriptors = [sortDescr]
        let frc = NSFetchedResultsController(fetchRequest: fRequest,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        performFetchRequest()
    }
    
    
    private func performFetchRequest() {
        do {
            try fetchResController.performFetch()
        } catch let fetchError {
            pf()
            pl("\(fetchError),\n \(fetchError.localizedDescription)")
        }
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let frame = CGRect(x: 0, y: 0, width: 0.1, height: 0.1)
        tableView.tableFooterView = UIView(frame: frame)
        
        let pNib = UINib(nibName: "PersonTableViewCell", bundle: nil)
        tableView.register(pNib, forCellReuseIdentifier: PersonTableViewCell.reuseIdentifier)
    }
    
    private func configureCell(_ cell: PersonTableViewCell, at indexPath: IndexPath) {
        let pers = fetchResController.object(at: indexPath)
        cell.nameLabel.text = pers.name
        
        cell.activityIndicator.startAnimating()
        ImageManager.shared.imageModel(with: pers.avatarName ?? "", completion: { imageObj in
            cell.activityIndicator.stopAnimating()
            if imageObj?.name == pers.avatarName {
                cell.avatarImageView.image = imageObj?.image
            }
        })
    }
    
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchResController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(forIndexPath: indexPath) as PersonTableViewCell
        configureCell(cell, at: indexPath)
        return cell
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detaisVc = PersonDetailsViewController.storyboardInstance(.main)
        detaisVc.person = fetchResController.object(at: indexPath)
        self.navigationController?.show(detaisVc, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PersonTableViewCell.height()
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension HomeViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert,
             .delete,
             .move:
            pl("This feature isn't implemented")
        case .update:
            if let ip = indexPath,
                let cell = tableView.cellForRow(at: ip) as? PersonTableViewCell {
                configureCell(cell, at: ip)
            }
        @unknown default:
            fatalError("add logic for new change type")
        }
        
    }
    
    
}
