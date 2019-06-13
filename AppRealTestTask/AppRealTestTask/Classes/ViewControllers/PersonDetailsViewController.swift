//
//  PersonDetailsViewController.swift
//  AppRealTestTask
//
//  Created by Roman Rybachenko on 6/13/19.
//  Copyright © 2019 Roman Rybachenko. All rights reserved.
//

import UIKit

class PersonDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Properties
    var person: Person?
    
    private var isNameChanged: Bool {
        guard let pers = person else { return false }
        return pers.name != nameTextField.text
    }
    
    private var nameCanBeSaved: Bool {
        return isNameChanged && ValidationHelper.nameValid(nameTextField.text)
    }

    
    // MARK: Overriden funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setPerson()
    }
    
    
    // MARK: - Action funcs
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if nameCanBeSaved {
            saveChanges()
        }
    }
    
    
    // MARK: - Private funcs
    
    private func setupView() {
        self.title = "Person details"
        nameTextField.delegate = self
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.layer.masksToBounds = true
    }
    
    private func setPerson() {
        nameTextField.text = person?.name
        
        activityIndicator.startAnimating()
        ImageManager.shared.imageModel(with: person?.avatarName ?? "", completion: { [weak self] imgModel in
            self?.activityIndicator.stopAnimating()
            self?.avatarImageView.image = imgModel?.image
        })
    }
    
    private func saveChanges() {
        guard let context = person?.managedObjectContext else { return }
        person?.name = nameTextField.text
        CoreDataStack.shared.saveContext(context)
        self.navigationController?.popViewController(animated: true)
    }
    

}

// MARK: - UITextFieldDelegate
extension PersonDetailsViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == person?.name {
            return
        }
        
        if nameCanBeSaved {
            self.navigationItem.rightBarButtonItem = saveBarButtonItem
        } else {
            AlertManager.showNameIsNotCorrect(to: self)
            self.navigationItem.rightBarButtonItem = nil
            nameTextField.text = person?.name
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

