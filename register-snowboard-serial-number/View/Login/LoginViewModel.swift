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
    
    func googleSignIn(){
        GIDSignIn.sharedInstance().signIn()
    }
    func signIn(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!, completion: @escaping (SignInResponse)-> ()) {
        let auth = user.authentication
        if auth == nil {
            completion(.authNil)
        }
        
        if error != nil{
            completion(.signInFailure)
        }
        let credential = GoogleAuthProvider.credential(withIDToken: auth!.idToken, accessToken: auth!.accessToken)
        Auth.auth().signIn(with: credential) { authResult, error in
            if error != nil{
                self.generaterSetUp(generaterType: .error)
                completion(.AuthSignInFailure)
            }
            self.generaterSetUp(generaterType: .success)
            completion(.success)
        }
    }
    func generaterSetUp(generaterType:UINotificationFeedbackGenerator.FeedbackType) {
        let generater = UINotificationFeedbackGenerator()
        generater.notificationOccurred(generaterType)
    }
}
