//
//  LoginViewController.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/10.
//

import UIKit
import GoogleSignIn

final class LoginViewController: UIViewController {
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray5
        navigationController?.setNavigationBarHidden(true, animated: false)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
// MARK: @IBAction
    
    @IBAction private func googleSignInButton(_ sender: Any) {
        viewModel.googleSignIn()
    }
}

// MARK: GIDSignInDelegate

extension LoginViewController: GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        viewModel.signIn(signIn, didSignInFor: user, withError: error) { response in
            switch response {
            case .signInFailure:
                print("signInFailure")
                self.generaterSetUp(generaterType: .error)
            case .authNil:
                print("authNil")
                self.generaterSetUp(generaterType: .error)
            case .AuthSignInFailure:
                print("AuthSignInFailure")
                self.generaterSetUp(generaterType: .error)
            case .success:
                print("Google SignIn Success!")
                self.generaterSetUp(generaterType: .success)
                let storyboard: UIStoryboard = UIStoryboard(name: "MyList", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "MyListViewController")
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}

extension LoginViewController {
    
    func generaterSetUp(generaterType:UINotificationFeedbackGenerator.FeedbackType) {
            let generater = UINotificationFeedbackGenerator()
            generater.notificationOccurred(generaterType)
        }
}
