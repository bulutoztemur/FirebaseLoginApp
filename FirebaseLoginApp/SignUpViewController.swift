//
//  SignUpViewController.swift
//  FirebaseLoginApp
//
//  Created by Alaattin Bulut Öztemur on 14.03.2021.
//

import UIKit
import Firebase
import FirebaseFirestore

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
        
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    let defaultStackviewTopConstraint: CGFloat = 20
    var totalSafeAreaHeight: CGFloat = 0
    var myKeyboardHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculateSafeAreaHeight()
        self.modifyComponents()
        self.addObserversForKeyboard()
    }
    
    func addObserversForKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDisapper),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func animationOnFormForKeyboard(clickOnPasswordTextField swipePasswordField:Bool) {
        if(swipePasswordField) {
            let viewHeight = self.view.frame.maxY - (self.navigationController?.navigationBar.frame.height)! - self.totalSafeAreaHeight
            self.stackViewTopConstraint.constant = viewHeight - self.signUpButton.frame.maxY - self.myKeyboardHeight! - self.defaultStackviewTopConstraint
        }
        else {
            self.stackViewTopConstraint.constant = defaultStackviewTopConstraint
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func calculateSafeAreaHeight() {
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        let bottomPadding = window.safeAreaInsets.bottom
        self.totalSafeAreaHeight = topPadding + bottomPadding
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.myKeyboardHeight = keyboardHeight
        }
    }
    
    @objc func keyboardWillDisapper(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.animationOnFormForKeyboard(clickOnPasswordTextField: false)
        }
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
            case firstNameTextField, lastNameTextField, emailTextField:
                self.animationOnFormForKeyboard(clickOnPasswordTextField: false)
            case passwordTextField:
                self.animationOnFormForKeyboard(clickOnPasswordTextField: true)
            default:
                break
        }
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
    
    func showAuthError(_ error: String) {
        self.passwordValidationErrorLabel.text = error
        self.passwordValidationErrorLabel.isHidden = false
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        if(validateAllTextFields()){
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                
                if let error = error {
                    self?.showAuthError(error.localizedDescription)
                    return
                }
                
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["firstname": firstName!, "lastname": lastName!, "uid": authResult!.user.uid]) { (error) in
                    if let error = error {
                        self?.showAuthError(error.localizedDescription)
                    }
                }
                self?.transitionToHome()
            }
        }
    }
    
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
