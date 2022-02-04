//
//  LoginViewController.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/10.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

final class LoginViewController: UIViewController {
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray5
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
//MARK: @IBAction
    @IBAction private func googleSignInButton(_ sender: Any) {
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
                let storyboard: UIStoryboard = UIStoryboard(name: "MyList", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "MyListViewController")
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
        }
    }
}
