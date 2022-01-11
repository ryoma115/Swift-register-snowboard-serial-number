//
//  photoCheckModel.swift
//  register-snowboard-serial-number
//
//  Created by N. Ryoma on 2022/01/11.
//

import UIKit
import Photos

class PhotoCheckModel{
    
    func showCheckPermission(){
           PHPhotoLibrary.requestAuthorization { (status) in
               switch(status){
               case .authorized:
                   print("Camera usage permission status: allow")
               case .denied:
                   print("Camera usage permission status: reject")
               case .notDetermined:
                   print("Camera usage permission status: notDetermined")
               case .restricted:
                   print("Camera usage permission status: restricted")
               case .limited:
                   print("Camera usage permission status: limited")
               @unknown default: break
                   
               }
               
           }
       }
    
}
