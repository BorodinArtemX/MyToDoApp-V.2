//
//  DetailViewController.swift
//  MyToDoApp
//
//  Created by Артем Бородин on 02/05/2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    lazy var addingText = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        navigationItem.title = "Task"
        view.backgroundColor = .white
    
    }
    
    func setupLayout(){
        
        view.addSubview(addingText)
        
        addingText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addingText.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            addingText.widthAnchor.constraint(equalTo: view.widthAnchor),
            addingText.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
}
