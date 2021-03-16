//
//  LoginViewController.swift
//  FirebaseLoginApp
//
//  Created by Alaattin Bulut Öztemur on 14.03.2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modifyComponents()
    }
    
    func modifyComponents() {
        modifyEmailTextField()
        modifyPasswordTextField()
        modifyLoginButton()
    }
    
    func modifyEmailTextField() {
        self.emailTextField.delegate = self
        self.emailTextField.autocorrectionType = .no
        self.emailTextField.spellCheckingType = .no
        Utilities.styleTextField(emailTextField)
        self.emailErrorLabel.isHidden = true
    }

    func modifyPasswordTextField() {
        self.passwordTextField.delegate = self
        self.passwordTextField.returnKeyType = .done
        self.passwordTextField.isSecureTextEntry = true
        Utilities.styleTextField(passwordTextField)
        self.passwordErrorLabel.isHidden = true
    }
    
    func modifyLoginButton() {
        Utilities.styleFilledButton(loginButton)
    }

    func validateEmail() -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        let valid = emailTest.evaluate(with: emailTextField.text)
        if valid {
            passwordTextField.becomeFirstResponder()
        }
        self.emailErrorLabel.text = "Please enter an valid email address."
        self.emailErrorLabel.isHidden = valid
        return valid
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            let _ = validateEmail()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == emailTextField) {
            let _ = validateEmail()
        }
    }

    
    func showAuthError(_ error: String) {
        self.passwordErrorLabel.text = error
        self.passwordErrorLabel.isHidden = false
    }

    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if(validateEmail()){
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let error = error {
                    self?.showAuthError(error.localizedDescription)
                } else {
                    self?.transitionToHome()
                }
            }
        }
    }
    
}
