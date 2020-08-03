//
//  LoginViewController.swift
//  onTheMapProject
//
//  Created by Ivan Jovany Arellano Gaspar on 6/16/20.
//  Copyright © 2020 Ivan Jovany Arellano Gaspar. All rights reserved.
//

import UIKit
class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    let signUpUrl = UdacityClient.Endpoints.udacitySignUp.url
    
    var emailTextFieldIsEmpty = true
    var passwordTextFieldIsEmpty = true
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = ""
        passwordTextField.text = ""
        emailTextField.delegate = self
        passwordTextField.delegate = self
        buttonEnabled(false, button: loginButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    //MARK: LOG IN
    
    @IBAction func login(_ sender: UIButton) { //request helpers
        setLogginIn(true)
        UdacityClient.login(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "",
                            completion: handleLoginResponse(success:error:))
    }
    
    //MARK:SIGN UP
    
    @IBAction func signUp(_ sender: Any) {
        setLogginIn(true)
        UIApplication.shared.open(signUpUrl, options: [:], completionHandler: nil)
        
    }
    
    //MARK: HANDLE LOGIN RESPONSE
    func handleLoginResponse(success: Bool, error: Error?) {
        setLogginIn(false)
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: nil)
            }
        } else {
            showAlert(message: "Please enter valid credentials.", tittle: "Login Error")
        }
    }

    //MARK: Loading State

    func setLogginIn(_ logginIn:Bool) {
        if logginIn {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.buttonEnabled(true, button: self.loginButton)
            }
        }
             else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.buttonEnabled(false, button: self.loginButton)
            }
        }
        DispatchQueue.main.async {
            self.emailTextField.isEnabled = !logginIn
            self.passwordTextField.isEnabled = !logginIn
            self.loginButton.isEnabled = !logginIn
            self.signUpButton.isEnabled = !logginIn
        }
}

//MARK: WILL ENABLED AND DISABLE BUTTONS AND TEXT FIELDS

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string:  String) -> Bool {
      if textField == emailTextField {
            let currenText = emailTextField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else {return false}
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
    
        if updatedText.isEmpty && updatedText == "" {
            emailTextFieldIsEmpty = true
        }
            else {
            emailTextFieldIsEmpty = false
    } }
        if textField == passwordTextField {
        let currenText = passwordTextField.text ?? ""
        guard let stringRange = Range(range, in: currenText) else { return false }
        let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
    
        if updatedText.isEmpty && updatedText == "" {
            passwordTextFieldIsEmpty = true
        }
            else{
                    passwordTextFieldIsEmpty = false
                 }
    
        if emailTextFieldIsEmpty == false && passwordTextFieldIsEmpty == false {
            buttonEnabled(true, button: loginButton)
        }
            else {
            buttonEnabled(false, button: loginButton)
        }
          return true
    }
    
    //MARK: TEXT FIELDS
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
    
    buttonEnabled(false, button: loginButton)
    if textField == emailTextField {
        emailTextFieldIsEmpty = true
    }
    if textField == passwordTextField {
        passwordTextFieldIsEmpty = true
    }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as?  UITextField {
        nextField.becomeFirstResponder()
    } else {
        textField.resignFirstResponder()
        login(loginButton)
    }
        return true
    
}
        return true
    }
  

}
