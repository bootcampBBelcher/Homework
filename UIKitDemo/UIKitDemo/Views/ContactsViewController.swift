//
//  ContactsViewController.swift
//  UIKitDemo
//
//  Created by user302134 on 9/8/26.
//

import UIKit

class ContactsViewController: UIViewController {

    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let button = UIButton()
    private let contactContainer = UIStackView()
    
    private var  name = ""{
        didSet {
            self.nameLabel.text = name
        }
    }
    private var email = "" {
        didSet {
            self.emailLabel.text = email
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        name = "Steve Smith"
        email = "steve@example.com"
    }
    private func buttopTapped() {
                
        // create new details screen
        let detailsVC = ContactDetailsViewController()
        
        // navigate to (open up) the details view
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }

}

private extension ContactsViewController {
    
    
    
    func setup() {
        self.view.backgroundColor = .white
        
        // configure our label
        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        emailLabel.text = email
        
        // configure our button
        button.configuration = .filled()
        button.configuration?.title = "View Details"
        button.addAction(UIAction { [weak self] _ in
            self?.buttopTapped()
        }, for: .touchUpInside)
        
        
        // add the UIViews to container
        contactContainer.addArrangedSubview(nameLabel)
        contactContainer.addArrangedSubview(emailLabel)
        contactContainer.addArrangedSubview(button)
        
        // configure the container element
        contactContainer.backgroundColor = .gray.withAlphaComponent(0.1)
        contactContainer.axis = .vertical
        contactContainer.spacing = 8
        contactContainer.alignment = .leading
        
        // add padding
        contactContainer.isLayoutMarginsRelativeArrangement = true
        contactContainer.layoutMargins = UIEdgeInsets(top: 8, left:8, bottom: 8, right: 8)
        
        // rounded corners
        contactContainer.layer.cornerRadius = 8
        contactContainer.clipsToBounds = true // wont let text spill out of rounded corners
        
        // disable the auto creation of contraints for this labe
        contactContainer.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(contactContainer)
        
        NSLayoutConstraint.activate([
            contactContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            contactContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contactContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16 )
        ])
        
    }
}
