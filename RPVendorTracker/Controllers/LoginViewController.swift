//
//  LoginViewController.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-15.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var usernameField: UITextField!
    var passwordField: UITextField!
    
    lazy var loginButton: UIButton = {
        let button = UIButton(frame: CGRect.init(x:UIScreen.main.bounds.width*0.1, y:CGFloat(UIScreen.main.bounds.height*0.3), width:UIScreen.main.bounds.width*0.8, height:CGFloat(45)))
        button.backgroundColor = UIColor.lightGray
        button.setTitle("Login", for: UIControlState.normal)
        button.showsTouchWhenHighlighted = true
        button.addTarget(self,action:
            #selector(LoginViewController.hasLoginButtonPressed), for: UIControlEvents.touchUpInside)
        
        return button
    }()
    @objc private func hasLoginButtonPressed() {
        showLoginAlert(title: "Login", msg: "Enter your Credentials")
    }
    private func showLoginAlert(title: String, msg: String?){
        let alertCtrl = UIAlertController(title:title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alertCtrl.addTextField{ (usernameTextField) in
            self.usernameField = usernameTextField
            usernameTextField.placeholder="Username"
            usernameTextField.keyboardType=UIKeyboardType.emailAddress
        }
        alertCtrl.addTextField{(passwordTextField) in
            self.passwordField = passwordTextField
            passwordTextField.placeholder = "password"
            passwordTextField.keyboardType = UIKeyboardType.asciiCapable
        }
        alertCtrl.addAction(UIAlertAction(title: "Login",
                                          style: UIAlertActionStyle.default,
                                          handler: loginHandler))
        alertCtrl.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alertCtrl,animated:true,completion:nil)
    }
    
    private func loginHandler(action: UIAlertAction) -> Void{
        //Check credentials
        if self.usernameField.text != "" && self.passwordField.text != "" {
            print("Login success!")
            self.performSegue(withIdentifier: "MainViewSegue", sender: self)
        } else {
            self.showLoginAlert(title:"Please enter your 'credentials'", msg:nil)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(loginButton)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
