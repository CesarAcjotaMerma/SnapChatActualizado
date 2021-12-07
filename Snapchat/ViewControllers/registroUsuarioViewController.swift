//
//  registroUsuarioViewController.swift
//  Snapchat
//
//  Created by Cesar Augusto Acjota Merma on 11/9/21.
//  Copyright © 2021 deah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class registroUsuarioViewController: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRegister.layer.cornerRadius = 35.0
        btnCancel.layer.cornerRadius = 35.0
    }
    
    @IBAction func btnRegisterTapped(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.emailTxt.text!, password: self.passwordTxt.text!, completion: { (user, error) in
            print("Intentando crear un usuario")
            if error != nil{
                let alerta = UIAlertController(title: "Creacion de Usuario", message: "Se creo el siguiente error al crear el usuario:\(String(describing: error))", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default)
                alerta.addAction(btnOK)
                self.present(alerta,animated: true,completion: nil)
                
            }else{
                print("El usuario fue creado exitosamente")
            Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                
                let alerta = UIAlertController(title: "Creacion de Usuario", message: "Usuario: \(self.emailTxt.text!) se creo correctamente.", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in
                    self.performSegue(withIdentifier: "registrousuariosegue", sender: nil)
                })
                alerta.addAction(btnOK)
                self.present(alerta,animated: true,completion: nil)
            }
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
