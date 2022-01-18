//
//  LoginViewController.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/10.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class LoginViewController: UIViewController {    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    @IBAction func googleSignInButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
}

extension LoginViewController: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let auth = user.authentication else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error{
                print(error.localizedDescription)
                return
            } else {
                let tabBarContoroller = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                self.navigationController?.pushViewController(tabBarContoroller, animated: true)
                print("Google SignIn Success!")
            }
        }
    }
    
    
}
