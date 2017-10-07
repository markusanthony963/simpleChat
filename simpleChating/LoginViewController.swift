//
//  LoginViewController.swift
//  simpleChating
//
//  Created by iosdev on 9/30/17.
//  Copyright © 2017 ios3-umn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var nameTxtField: UITextField!
    
    
    @IBOutlet weak var signUpEmailTxtField: UITextField!
    @IBOutlet weak var signUpRePasswordTxtField: UITextField!
    @IBOutlet weak var signUpPasswordTxtField: UITextField!
    
    
    @IBOutlet weak var loginEmailTxtField: UITextField!
    @IBOutlet weak var loginPasswordTxtField: UITextField!
   
    
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var anonView: UIView!
    
    
    
    
    
    @IBAction func forgotPasswordBtn(_ sender: Any) {
        if self.loginEmailTxtField.text == "" {
            let alertController = UIAlertController(title: "oooops", message: "enter email", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true , completion: nil)
        }else{
            Auth.auth().sendPasswordReset(withEmail: self.loginEmailTxtField.text!, completion: {(error) in
            var title = ""
            var message = ""
                if error != nil {
                title = "error"
                    message = (error?.localizedDescription)!
                }else {
                title = "sukses"
                message = "pass reset email sent"
                    self.loginEmailTxtField.text = ""
                    
                }
                let alertController = UIAlertController(title : title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
            })
        }
        
    }
    
    @IBAction func loginEmailAnon(_ sender: Any) {
        signUpView.isHidden = true
        loginView.isHidden = false
        anonView.isHidden = true
    }
    @IBAction func signinAnon(_ sender: Any) {
        signUpView.isHidden = false
        loginView.isHidden = true
        anonView.isHidden = true
    }
    @IBAction func loginEmailSignup(_ sender: Any) {
        signUpView.isHidden = true
        loginView.isHidden = false
        anonView.isHidden = true
    }
    @IBAction func anonSignup(_ sender: Any) {
        signUpView.isHidden = true
        loginView.isHidden = true
        anonView.isHidden = false
    }
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
    signUpView.isHidden = false
    loginView.isHidden = true
    anonView.isHidden = true
    }
    
    @IBAction func anonBtnTapped(_ sender: Any) {
        signUpView.isHidden = true
        loginView.isHidden = true
        anonView.isHidden = false
        
    }
    @IBAction func createAccountAction(_ sender: Any) {
        
        if signUpEmailTxtField.text == "" || signUpPasswordTxtField.text == "" {
            let alertController =  UIAlertController(title: "Elor" , message: "email/pass kosong gblk", preferredStyle : .alert )
            
            let defaultAction = UIAlertAction(title: "OK" , style : .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }else{
            Auth.auth().createUser(withEmail: signUpEmailTxtField.text! , password: signUpPasswordTxtField.text!){(user, error)in
                if error == nil{
                print("berhasil")
                    self.performSegue(withIdentifier: "loginToChatSegue", sender: nil)

                    
                }else{
                let alertController = UIAlertController(title: "Elor" , message: error?.localizedDescription , preferredStyle : .alert)
                
                let defaultAction = UIAlertAction(title: "OK" , style : .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated:true, completion: nil)
                    
                
                }
                
            
            }
        }
        
    }
    
    
    
    @IBAction func loginAction(_ sender: Any) {
        if self.loginEmailTxtField.text == "" || self.loginPasswordTxtField.text == "" {
            let alertController = UIAlertController(title: "Elor" , message: "email/pass kosong gblk", preferredStyle : .alert )
            
            let defaultAction = UIAlertAction(title: "OK" , style : .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated:true, completion: nil)
            

        }else{
            Auth.auth().signIn(withEmail: self.loginEmailTxtField.text!, password: self.loginPasswordTxtField.text!){(user, error) in
                
                if error == nil{
                print("berhasil berhasil berhasil hore")
                    self.performSegue(withIdentifier: "loginToChatSegue", sender: nil)

                
                    
                }else{
                    let alertController = UIAlertController(title: "Elor" , message: error?.localizedDescription , preferredStyle : .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK" , style : .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated:true, completion: nil)
                }
            
            }
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        
        if nameTxtField.text != ""{
            Auth.auth().signInAnonymously(completion: {(user,error)in
                if let err = error {
                print(err.localizedDescription)
                    return
                }
                self.performSegue(withIdentifier: "loginToChatSegue", sender: nil)
            })
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let navVc = segue.destination as! UINavigationController
        let channelVC = navVc.viewControllers.first as! ChannelListViewController
        
        channelVC.senderDisplayName = nameTxtField?.text
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.isHidden = true
        loginView.isHidden = false
        anonView.isHidden = true
        
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
