//
//  HomeViewController.swift
//  Snapchat
//
//  Created by Cesar Augusto Acjota Merma on 10/29/21.
//  Copyright © 2021 deah. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

enum ProviderType: String {
    case basic
    case google
    case facebook
}

class HomeViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    
    private let email: String
    private let provider: ProviderType
    
    init(email: String, provider: ProviderType){
        self.email = email
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inicio"
        navigationItem.setHidesBackButton(true, animated: false)
        signOutButton.layer.cornerRadius = 10.0
        
        emailLabel.text = email
        providerLabel.text = provider.rawValue
        
        //guardar los datos
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue, forKey: "provider")
        defaults.synchronize()

    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
        
        switch provider {
        
        case .basic:
            firebaseLogout()
        case .google:
            
            GIDSignIn.sharedInstance()?.signOut()
            firebaseLogout()
            
        case .facebook:
            LoginManager().logOut()
            firebaseLogout()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func firebaseLogout(){
        do {
            try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
        } catch {
            // se ha producido error
        }
    }

}
