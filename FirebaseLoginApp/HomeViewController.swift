//
//  HomeViewController.swift
//  FirebaseLoginApp
//
//  Created by Alaattin Bulut Öztemur on 14.03.2021.
//

import UIKit
import FirebaseFirestore
import Firebase


class HomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = "Welcome, \(Auth.auth().currentUser?.email ?? "")"
    }
}
