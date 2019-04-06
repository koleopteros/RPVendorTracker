//  Student ID: 100530184
//  LoginViewController.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-15.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import UIKit
import SQLite3

class LoginViewController: UIViewController {
    
    //disgusting solution to the select from where clause issue (why doesnt it work?)
    var userList = [Users]()
    
    var usernameField: UITextField!
    var passwordField: UITextField!
    
    var db: OpaquePointer?
    
    let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    lazy var loginButton: UIButton = {
        let button = UIButton(frame: CGRect.init(x:UIScreen.main.bounds.width*0.1, y:CGFloat(UIScreen.main.bounds.height*0.3), width:UIScreen.main.bounds.width*0.8, height:CGFloat(45)))
        button.backgroundColor = UIColor.lightGray
        button.setTitle("Login", for: UIControlState.normal)
        button.showsTouchWhenHighlighted = true
        button.addTarget(self,action:
            #selector(LoginViewController.hasLoginButtonPressed), for: UIControlEvents.touchUpInside)
        
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(frame: CGRect.init(x:UIScreen.main.bounds.width*0.1, y:CGFloat(UIScreen.main.bounds.height*0.3)+60, width:UIScreen.main.bounds.width*0.8, height:CGFloat(45)))
        button.backgroundColor = UIColor.lightGray
        button.setTitle("Register", for: UIControlState.normal)
        button.showsTouchWhenHighlighted = true
        button.addTarget(self,action:
            #selector(LoginViewController.hasRegisterButtonPressed), for: UIControlEvents.touchUpInside)
        
        return button
    }()
    //button observers
    @objc private func hasLoginButtonPressed() {
        showLoginAlert(title: "Login", msg: "Enter your Credentials")
    }
    @objc private func hasRegisterButtonPressed(){
        showRegisterAlert(title: "Registration", msg: "Enter in some new credentials!")
    }
    //button alerts
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
            passwordTextField.isSecureTextEntry = true
            passwordTextField.keyboardType = UIKeyboardType.asciiCapable
        }
        alertCtrl.addAction(UIAlertAction(title: "Login",
                                          style: UIAlertActionStyle.default,
                                          handler: loginHandler))
        alertCtrl.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alertCtrl,animated:true,completion:nil)
    }
    private func showRegisterAlert(title:String, msg:String?){
        let alertCtrl = UIAlertController(title:title, message:msg, preferredStyle: UIAlertControllerStyle.alert)
        alertCtrl.addTextField{
            (newUsernameTextField) in
            self.usernameField = newUsernameTextField
            newUsernameTextField.placeholder = "New Username"
            newUsernameTextField.keyboardType=UIKeyboardType.emailAddress
        }
        alertCtrl.addTextField{ (newPasswordTextField) in
            self.passwordField = newPasswordTextField
            newPasswordTextField.placeholder = "New Password"
            newPasswordTextField.keyboardType = UIKeyboardType.asciiCapable
        }
        alertCtrl.addAction(UIAlertAction(title:"Register",
                                          style: UIAlertActionStyle.default,
                                          handler: registerHandler))
        alertCtrl.addAction(UIAlertAction(title:"Cancel",
                                          style:UIAlertActionStyle.cancel,
                                          handler:nil))
        self.present(alertCtrl,animated:true,completion:nil)
    }
    //button handlers
    private func loginHandler(action: UIAlertAction) -> Void{
        //Check credentials
        if validateUser(username: usernameField.text!, password: passwordField.text!) {
            print("Login success!")
            sqlite3_close(db)
            self.performSegue(withIdentifier: "MainViewSegue", sender: self)
        } else {
            self.showLoginAlert(title:"Please enter your 'credentials'", msg:nil)
        }
    }
    private func registerHandler(action:UIAlertAction) -> Void{
        let newUser = self.usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let newPasswd = self.passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(newUser?.isEmpty)!{
            usernameField.layer.borderColor = UIColor.red.cgColor
            return
        }
        if(newPasswd?.isEmpty)!{
            passwordField.layer.borderColor = UIColor.red.cgColor
            return
        }
        let user = findUser(name: newUser!)
        
        if user.id == -1 {
            insertNewUser(newUser: newUser!, newPasswd: newPasswd!)
        }
        else{
            showRegisterAlert(title: "Registration", msg: "Username has already been taken!\nTry again!")
        }
    }
    private func insertNewUser(newUser: String, newPasswd: String){
        var stmt: OpaquePointer?
        let insertQuery = "INSERT INTO users (name, password) VALUES (?,?)"
        
        if sqlite3_prepare_v2(db,insertQuery,-1,&stmt,nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error inserting new user: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, newUser, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failed to bind name: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 2, newPasswd, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failed to bind password: \(errmsg)")
            return
        }
        // execute query
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failed to insert new user: \(errmsg)")
            return
        }
        print("Inserting User: \(usernameField.text!)//\(passwordField.text!)")
        //clear fields
        usernameField.text = ""
        passwordField.text = ""
        
        //readValues()
        print("User saved, reloading userList")
        storeAllUsers()
    }
    //Shitty way to bypass my "unknown error" from doing a Select From Where statement
    private func storeAllUsers(){
        //clear array
        userList.removeAll()
        var stmt:OpaquePointer?
        
        let query = "SELECT * FROM users"
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = Int(sqlite3_column_int(stmt,0))
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let passwd = String(cString: sqlite3_column_text(stmt, 2))
            print("Storing... \(id). Username: \(name)\tPassword: \(passwd)")
            userList.append(Users(id: id, name: name, password: passwd))
        }
    }
    // Checks if user exists if check, returns only User with ID number (-1 for fail), else returns full user object
    private func findUser(name:String)->Users{
        for user in userList{
            print("Checking...\nInformation:\n\tID: \(user.id)\n\tName: \(user.name)\n\tPassword: \(user.password)")
            if name == user.name {
                print("match!")
                return user
            }
        }
        return Users(id: -1)
        
//        print("Checking if \(user) exists...")
//        var stmt:OpaquePointer?
//
//        let query = "SELECT id,name,password FROM users WHERE name LIKE ?"
//        if sqlite3_prepare_v2(db,query,-1,&stmt,nil) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error selecting user: \(errmsg)")
//            return Users(id: -1)
//        }
//        if sqlite3_bind_text(stmt, 1, user, -1, SQLITE_TRANSIENT) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("Failed to bind name: \(errmsg)")
//            return Users(id: -1)
//        }
//        if sqlite3_step(stmt) != SQLITE_DONE {
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("Failed to search for user: \(errmsg)")
//            return Users(id: -1)
//        }
//        if(sqlite3_step(stmt) == SQLITE_ROW) {
//            var user = Users(id: Int(sqlite3_column_int(stmt,0)))
//            if check {
//                user = Users(id: Int(sqlite3_column_int(stmt,0)), name: String(cString: sqlite3_column_text(stmt,1)), password: String(cString:sqlite3_column_text(stmt,2)))
//            }
//            return user
//        }
//        else{
//            return Users(id: -1, name: "", password: "")
//        }
    }
    private func validateUser(username: String, password: String)->Bool{
        print("Validating \(username)//\(password)")
        let user = findUser(name: username)
        print(user)
        if user.id == -1 {
            return false
        }
        else if user.password == password {
            UserDefaults.standard.set(user.id,forKey:"userID")
            return true
        }
        return false
    }
    
    // loads... db... its in the name.
    private func loadDB(){
        //SQL Scripts - Primary tables
        var sqlscripts = [String]()
        sqlscripts.append("CREATE TABLE IF NOT EXISTS users (id integer primary key autoincrement, name text unique, password text)")
        sqlscripts.append("CREATE TABLE IF NOT EXISTS vendors (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE, desc TEXT, weight REAL, race TEXT, age INTEGER, gender INTEGER)")
        sqlscripts.append("CREATE TABLE IF NOT EXISTS items (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE, desc TEXT, weight REAL, rarity INTEGER, category INTEGER)")
        
        //SQL Scripts Associative Tables
        sqlscripts.append("CREATE TABLE IF NOT EXISTS users_vendors (users_id INTEGER REFERENCES users(id), vendors_id INTEGER REFERENCES vendors(id), PRIMARY KEY (users_id, vendors_id))")
        sqlscripts.append("CREATE TABLE IF NOT EXISTS inventory (vendors_id INTEGER REFERENCES vendors(id), items_id INTEGER REFERENCES items(id), quantity INTEGER, PRIMARY KEY (vendors_id, items_id))")
        
        //Create DB if not exist
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("appDB.sqlite")
        
        // Open DB
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening db")
        }
        //Create Tables
        for query in sqlscripts{
            if sqlite3_exec(db, query, nil, nil, nil) == SQLITE_OK {
                print("QUERY:\n================\n\(query)\n=====SUCCESSFUL======")
            } else {
                print("error creating table: \(String(cString: sqlite3_errmsg(db)!))")
            }
        }
        //load up userList array
        storeAllUsers()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
        loadDB()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
