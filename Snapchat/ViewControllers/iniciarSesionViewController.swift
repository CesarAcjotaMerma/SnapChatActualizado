
import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FacebookLogin
import FirebaseDatabase

class iniciarSesionViewController: UIViewController {
    
    @IBOutlet weak var authStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Design
        signUpButton.layer.cornerRadius = 35.0
        signUpButton.layer.shadowColor = UIColor.gray.cgColor
        signUpButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        signUpButton.layer.shadowRadius = 6.0
        signUpButton.layer.shadowOpacity = 0.9
        
        logInButton.layer.cornerRadius = 35.0
        logInButton.layer.shadowColor = UIColor.gray.cgColor
        signUpButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        signUpButton.layer.shadowRadius = 6.0
        logInButton.layer.shadowOpacity = 0.9
        
        googleButton.layer.cornerRadius = 38.0
        googleButton.layer.shadowColor = UIColor.gray.cgColor
        googleButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        googleButton.layer.shadowRadius = 6.0
        googleButton.layer.shadowOpacity = 0.9
        
        facebookButton.layer.cornerRadius = 38.0
        facebookButton.layer.shadowColor = UIColor.gray.cgColor
        facebookButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        facebookButton.layer.shadowRadius = 6.0
        facebookButton.layer.shadowOpacity = 0.9
        
        //Analitycs Event
        title = "Autenticacion"
        Analytics.logEvent("initScreen", parameters: ["message" : "Integracion de firebase Completa"])
        //Comprobar la autenticacion
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String,
            let provider = defaults.value(forKey: "provider") as? String {
            authStackView.isHidden = true
            navigationController?.pushViewController(HomeViewController(email: email, provider: ProviderType.init(rawValue: provider)!), animated: false)
        }
        //Google Auth
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authStackView.isHidden = false
    }

    //@IBAction func sigUpButtonAction(_ sender: Any) {
        //if let email = emailTextField.text, let password = passwordTextField.text {
          //  Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            //    self.showHome(result: result, error: error, provider: .basic)
          //  }
       // }
  //  }
    
    @IBAction func iniciarSessionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
            print("Intentando Iniciar Sesion")
            if error != nil{
                let alerta = UIAlertController(title: "Error al Iniciar Sesion", message: "Usuario: \(self.emailTextField.text!) No esta registrado.", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Cancelar", style: .default)
                let btnCrear = UIAlertAction(title: "Crear", style: .default, handler: { (UIAlertAction) in
                    self.performSegue(withIdentifier: "registrousuario", sender: nil)
                })
                alerta.addAction(btnOK)
                alerta.addAction(btnCrear)
                self.present(alerta,animated: true,completion: nil)
            }else{
                print("Inico de Sesion Exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
        
//        if let email = emailTextField.text, let password = passwordTextField.text {
//              Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//                  if let result = result, error == nil {
//                    self.navigationController?.pushViewController(HomeViewController(email: result.user.email!, provider: .basic), animated: true)
//                  }else{
//                      let alertController = UIAlertController(title: "Error", message: "Se ha producido error al intentar iniciar Sesion el usuario", preferredStyle: .alert)
//                      alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
//                      self.present(alertController, animated: true, completion: nil)
//                  }
//              }
//          }
    }
    
    @IBAction func googleButtonTapped(_ sender: Any) {
        
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
        
        
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.email], viewController: self){ (result) in
            switch result {
            case .success(granted: let granted, declined: let declined, token: let token):
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                Auth.auth().signIn(with: credential) { (result, error) in
                self.showHome(result: result, error: error, provider: .facebook)
                }
            case .cancelled:
                break
            case .failed(_):
                break
            }
    }
}
    
    
    private func showHome(result: AuthDataResult?, error: Error?, provider: ProviderType){
        if let result = result, error == nil {
          self.navigationController?.pushViewController(HomeViewController(email: result.user.email!, provider: provider), animated: true)
        }else{
            let alertController = UIAlertController(title: "Error", message: "Se ha producido error al intentar iniciar Sesion el usuario \(provider.rawValue)", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

extension iniciarSesionViewController: GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil && user.authentication != nil {
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { (result, error) in
                self.showHome(result: result, error: error, provider: .google)

            }
            
        }
    }
    
    
}
