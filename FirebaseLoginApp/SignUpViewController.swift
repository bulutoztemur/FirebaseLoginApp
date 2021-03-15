//
//  SignUpViewController.swift
//  FirebaseLoginApp
//
//  Created by Alaattin Bulut Öztemur on 14.03.2021.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var firstNameValidationErrorLabel: UILabel!
    @IBOutlet weak var lastNameValidationErrorLabel: UILabel!
    @IBOutlet weak var emailValidationErrorLabel: UILabel!
    @IBOutlet weak var passwordValidationErrorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modifyComponents()
    }
    
    func modifyComponents(){
        modifyFirstNameTextField()
        modifyLastNameTextField()
        modifyEmailTextField()
        modifyPasswordTextField()
        modifySignUpButton()
    }
    
    func modifyFirstNameTextField() {
        self.firstNameTextField.becomeFirstResponder()
        self.firstNameTextField.delegate = self
        self.firstNameTextField.autocorrectionType = .no
        self.firstNameTextField.spellCheckingType = .no
        Utilities.styleTextField(firstNameTextField)
        self.firstNameValidationErrorLabel.isHidden = true
    }
    
    func modifyLastNameTextField() {
        self.lastNameTextField.delegate = self
        self.lastNameTextField.autocorrectionType = .no
        self.lastNameTextField.spellCheckingType = .no
        Utilities.styleTextField(lastNameTextField)
        self.lastNameValidationErrorLabel.isHidden = true
    }
    
    func modifyEmailTextField() {
        self.emailTextField.delegate = self
        self.emailTextField.autocorrectionType = .no
        self.emailTextField.spellCheckingType = .no
        Utilities.styleTextField(emailTextField)
        self.emailValidationErrorLabel.isHidden = true
    }

    func modifyPasswordTextField() {
        self.passwordTextField.delegate = self
        self.passwordTextField.returnKeyType = .done
        self.passwordTextField.isSecureTextEntry = true
        Utilities.styleTextField(passwordTextField)
        self.passwordValidationErrorLabel.isHidden = true
    }
    
    func modifySignUpButton() {
        Utilities.styleFilledButton(signUpButton)
    }
    
    func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        
        switch textField {
            case firstNameTextField:
                return (text.count > 0, "This field cannot be empty.")
            case lastNameTextField:
                return (text.count > 0, "This field cannot be empty.")
            case emailTextField:
                let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                return (emailTest.evaluate(with: emailTextField.text), "Please enter an valid email address.")
            case passwordTextField:
                let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#._])[A-Za-z\\dd$@$!%*?&#._]{8,}")
                return (passwordTest.evaluate(with: passwordTextField.text), "Please make sure your password is at least 8 characters, contains at least \n \u{2022} 1 Uppercase Alphabet \n \u{2022} 1 Lowercase Alphabet \n \u{2022} 1 Number \n \u{2022} 1 Special Character (! % * ? & # . _)")
            default:
                return (false, nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let _ = validateTextField(textField)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let _ = validateTextField(textField)
    }
                
    func validateTextField(_ textField: UITextField) -> Bool {
        let (valid, message) = validate(textField)
        switch textField {
            case firstNameTextField:
                if valid {
                    lastNameTextField.becomeFirstResponder()
                }
                self.firstNameValidationErrorLabel.text = message
                self.firstNameValidationErrorLabel.isHidden = valid
            case lastNameTextField:
                if valid {
                    emailTextField.becomeFirstResponder()
                }
                self.lastNameValidationErrorLabel.text = message
                self.lastNameValidationErrorLabel.isHidden = valid
            case emailTextField:
                if valid {
                    passwordTextField.becomeFirstResponder()
                }
                self.emailValidationErrorLabel.text = message
                self.emailValidationErrorLabel.isHidden = valid
            case passwordTextField:
                passwordTextField.resignFirstResponder()
                self.passwordValidationErrorLabel.text = message
                self.passwordValidationErrorLabel.isHidden = valid
            default:
                break
        }
        return valid
    }
    
    @objc func validateAllTextFields() -> Bool {
        // Iterate UITextFields in StackView that has Tag:1.
        var isFormValid = true
        let stackView:UIStackView = self.view.viewWithTag(1) as! UIStackView
        for v in stackView.subviews {
            if(v.isKind(of: UITextField.self)){
                isFormValid = validateTextField(v as! UITextField)
            }
        }
        return isFormValid
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        if(validateAllTextFields()){
            print("FORM IS VALID")
            //TODO: Operations
        } else {
            print("FORM IS NOT VALID")
        }
    }
}
