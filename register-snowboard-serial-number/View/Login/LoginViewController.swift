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
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray5
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        self.navigationController?.isToolbarHidden = true
    }
    
    @IBAction func googleSignInButton(_ sender: Any) {
        viewModel.googleSignIn()
    }
}

//MARK: GIDSignInDelegate
extension LoginViewController: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        viewModel.signIn(signIn, didSignInFor: user, withError: error) { response in
            switch response {
            case .signInFailure:
                print("signInFailure")
            case .authNil:
                print("authNil")
            case .AuthSignInFailure:
                print("AuthSignInFailure")
            case .success:
                print("Google SignIn Success!")
                let nextStoryboard:UIStoryboard = UIStoryboard(name: "TabBar",bundle: nil)
                guard let nextViewController = nextStoryboard.instantiateInitialViewController() as? TabBarViewController else { return }
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: true)
            }
        }
    }
}
