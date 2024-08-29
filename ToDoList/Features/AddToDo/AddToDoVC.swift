//
//  AddToDoVC.swift
//  ToDoList
//
//  Created by Metehan Gürgentepe on 28.08.2024.
//

import UIKit
import SnapKit

class AddToDoVC: UIViewController, UITextViewDelegate {
    lazy var textField = UITextField()
    lazy var datePicker = UIDatePicker()
    lazy var notesText = UITextView()
    var selectedToDoID: String?
    
    lazy var viewModel = {
        AddToDoViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    
    func initView() {
        view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        setupBarButton()
        setupTextField()
        setupDatePicker()
        setupNotes()
    }
    
    func initViewModel() {
        viewModel.successSaving = { [weak self] success in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: "", success: "Saved Successfully")
            }
        }
        
        viewModel.showError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: errorMessage, success: nil)
            }
        }
        
        viewModel.showReminder = { [weak self] reminder in
            DispatchQueue.main.async {
                self?.textField.text = reminder.title
                self?.datePicker.date = reminder.date ?? Date()
                self?.notesText.text = reminder.notes
            }
        }
        
        if let id = selectedToDoID {
            viewModel.getReminder(id: id)
        }
    }
    
    func setupBarButton() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveReminder))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func setupTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Title"
        view.addSubview(textField)
        
        textField.layer.cornerRadius = 10
        textField.layer.backgroundColor = UIColor.white.cgColor
        textField.layoutMargins = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(44)
        }
    }
    
    func setupDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        datePicker.preferredDatePickerStyle = .inline
        datePicker.layer.backgroundColor = UIColor.white.cgColor
        datePicker.layer.cornerRadius = 10
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func setupNotes() {
        view.addSubview(notesText)
        
        notesText.delegate = self
        
        notesText.backgroundColor = .white
        notesText.layer.cornerRadius = 10
        
        textViewDidBeginEditing(notesText)
        textViewDidEndEditing(notesText)
        
        notesText.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func saveReminder() {
        if let text = textField.text{
            let reminder = Reminder(id:viewModel.selectedId ?? "", title: text, date: datePicker.date, notes: notesText.text)
            viewModel.saveReminder(reminder: reminder )
        }
    }
    
    func showErrorAlert(message: String,success: String?) {
        let alert = UIAlertController(title: success ?? "Error", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default){ _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter notes"
            textView.textColor = UIColor.lightGray
        }
    }
}
