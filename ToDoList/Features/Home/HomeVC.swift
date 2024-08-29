//
//  ViewController.swift
//  ToDoList
//
//  Created by Metehan Gürgentepe on 28.08.2024.
//

import UIKit

class HomeVC: UIViewController {
    let tableView = UITableView()
    
    lazy var viewModel = {
        HomeViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
        title = "To Do List"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getReminders()
    }
    
    func initView() {
        view.backgroundColor = .systemBackground
        setupAddBarButton()
        setupTableView()
    }
    
    func initViewModel() {
        viewModel.getReminders()
        
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.showError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: errorMessage)
            }
        }
    }
    
    func setupAddBarButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAdd))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = view.frame
        view.addSubview(tableView)
        tableView.register(ReminderCell.self, forCellReuseIdentifier: ReminderCell.identifier)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func goToAdd() {
        let vc = AddToDoVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.reminderCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReminderCell.identifier, for: indexPath) as! ReminderCell
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddToDoVC()
        vc.selectedToDoID = viewModel.reminders[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let reminderToDelete = viewModel.reminderCellViewModels[indexPath.row]
            viewModel.deleteReminder(reminderToDelete)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

