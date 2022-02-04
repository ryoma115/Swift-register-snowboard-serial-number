//
//  LoginViewModel.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/28.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

final class LoginViewModel{
    
    enum SignInResponse {
        case signInFailure
        case authNil
        case AuthSignInFailure
        case success
    }
    
    func googleSignIn() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signIn(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!, completion: @escaping (SignInResponse)-> ()) {
        
        guard let auth = user.authentication else { completion(.authNil); return }
        if error != nil {
            completion(.signInFailure)
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credential) { authResult, error in
            if error != nil{
                completion(.AuthSignInFailure)
                return
            }
            completion(.success)
        }
    }
}
