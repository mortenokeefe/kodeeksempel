//
//  UIImage+load.swift
//  aflevering
//
//  Created by dmu mac 07 on 21/04/2020.
//  Copyright © 2020 eaaa. All rights reserved.
//

 import UIKit

 extension UIImageView {
     func load(url: URL, completion: @escaping (UIImage)-> Void) {
         DispatchQueue.global().async { [weak self] in
             if let data = try? Data(contentsOf: url) {
                 if let image = UIImage(data: data) {
                     DispatchQueue.main.async {
                         self?.image = image
                         
                         // min completionhandler skal have adgang til det hentede billede
                         // så det kan gemmes i cachen.
                         completion(image)
                     }
                 }
             }
         }
     }
 }

