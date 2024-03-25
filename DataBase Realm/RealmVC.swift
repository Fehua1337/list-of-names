//
//  ViewController.swift
//  DataBase Realm
//
//  Created by Alisher Tulembekov on 18.03.2024.
//

import UIKit
import RealmSwift
import SnapKit

class RealmVc: UIViewController {
    
    let realm = try! Realm()
    
    var fullnnames = [fullName]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "insert name"
        return textfield
    }()
    
    lazy var surnameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "insert surname"
        return textfield
    }()
    
    lazy var paswordTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "insert password"
        return textfield
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "some text"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("tap me", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(setName), for: .touchDragInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        //        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getCountries()
    }
    
    private func setupViews() {
        view.addSubview(nameTextField)
        view.addSubview(surnameTextField)
        view.addSubview(paswordTextField)
        view.addSubview(label)
        view.addSubview(button)
        view.addSubview(tableView)
        view.backgroundColor = .white
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        surnameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        paswordTextField.snp.makeConstraints { make in
            make.top.equalTo(surnameTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(paswordTextField.snp.bottom).offset(12)
            
        }
        
        button.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(button.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func buttonTapped() {
        //        print(textField.text)
        var fullnames = fullName()
        fullnames.name = nameTextField.text ?? ""
        fullnames.surname = surnameTextField.text ?? ""
        fullnames.pasword = paswordTextField.text ?? ""
        nameTextField.text = ""
        surnameTextField.text = ""
        paswordTextField.text = ""
        try! realm.write {
            realm.add(fullnames)
        }
        getCountries()
    }
    
    @objc func setName() {
        getCountries()
    }
    
    
    private func getCountries() {
        let fullnames = realm.objects(fullName.self)
        
        self.fullnnames = fullnames.map({ fullname in
            fullname
        })
    }
    
    private func deleteCountry(_ fullname: fullName) {
        try! realm.write {
            realm.delete(fullname)
        }
    }
    
    private func updateCountryName(name: String?, surname: String?, password: String?, at index: Int) {
        
        let country = realm.objects(fullName.self)[index]
        
        try! realm.write({
            if let name = name, !name.isEmpty {
                country.name = name
            }
            if let surname = surname, !surname.isEmpty {
                country.surname = surname
            }
            if let password = password, !password.isEmpty {
                country.pasword = password
            }
        })
    }
    
    
    
}


extension RealmVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fullnnames.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = fullnnames[indexPath.row].name + " " + fullnnames[indexPath.row].surname + " " + fullnnames[indexPath.row].pasword
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
            // Handle edit action
            self?.editCountry(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            // Handle delete action
            self?.deleteCountry(at: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    private func editCountry(at indexPath: IndexPath) {
        updateCountryName(name: nameTextField.text, surname: surnameTextField.text, password: paswordTextField.text, at: indexPath.row)
        nameTextField.text = ""
        paswordTextField.text = ""
        surnameTextField.text = ""
        getCountries()
        
    }
    
    private func deleteCountry(at indexPath: IndexPath) {
        let fullname = fullnnames[indexPath.row]
        deleteCountry(fullname)
        getCountries()
        
    }
}
