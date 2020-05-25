//
//  StateController.swift
//  aflevering
//
//  Created by dmu mac 07 on 20/04/2020.
//  Copyright © 2020 eaaa. All rights reserved.
//

import UIKit

class StateController {
    
    var onComplete: (()->())?
    
    let networkController = NetworkController()
    
    var items: [Item]?
    
    var selectedUserIndex: Int?
    
    let imageCache = NSCache<NSString, UIImage>()
    
    let defaults = UserDefaults.standard
    
    init() {
        
        let url = URL(string: "https://api.github.com/search/repositories?q=language:swift&sort=stars&order=desc")!
        let decoder = JSONDecoder()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 3600)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        networkController.fetchData(of: Items.self, from: url, decoder: decoder) { [weak self] (result) in
            switch result {
            case .failure(let error):
                if error is DataError {
                    print(error)
                } else {
                    print(error.localizedDescription)
                }
            case .success(let items):
                self?.didComplete(items: items.items)
            }
        }
        
    }
    
    func setAsFavorite(id: Int) {
        if var values = defaults.value(forKey: "favorites") as? [Int] {
            if !values.contains(id) {
                values.append(id)
                defaults.set(values, forKey: "favorites")
                print("id \(id) er tilføjet til favorites")
            }
        }
    }
    
    func removeAsFavorite(id: Int) {
        if var values = defaults.value(forKey: "favorites") as? [Int] {
            if let index = values.firstIndex(where: { $0 == id}) {
                values.remove(at: index)
                defaults.set(values, forKey: "favorites")
                print("id \(id) er fjernet fra favorites")
            }
        }
    }
    
    func isFavorite(id: Int) -> Bool {
        if let values = defaults.value(forKey: "favorites") as? [Int] {
            if values.contains(id) {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
}
//statecontrolleren uddelegerer vel hvad der skal ske når den er færdig med fetchdata (oncomplete metoden) til userlistviewcontroller da den ikke kender userlistviewcontroller men userlistviewcontroller ved hvad der skal ske (altså reloaddata()) og den kender til statecontrolleren
extension StateController {
    func didComplete(items: [Item]) {
        self.items = items
        if let onComplete = onComplete {
            onComplete()
        }
    }
}
