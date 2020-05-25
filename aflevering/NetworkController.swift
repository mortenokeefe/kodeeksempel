//
//  NetworkController.swift
//  aflevering
//
//  Created by dmu mac 07 on 20/04/2020.
//  Copyright © 2020 eaaa. All rights reserved.
//

import Foundation

enum DataError: Error {
    case invalidResponse
    case invalidData
    case decodingError
    case serverError
}

class NetworkController {
    
    // typeAlias er som typeAlias S = String .ie. let navn: S
    // Result is A value that represents either a success or a failure, including an associated value in each case.
    typealias result<T> = (Result<T, Error>)->Void
    
    /*
    init(){
        fetchData()
    }
    */
    
    // USAGE: fetchData(of: RandomUser.self, from: "someURL", decoder: JSONDecoder) {(result) in }
    
    func fetchData<T: Decodable>(of type:T.Type, from url: URL, decoder: JSONDecoder, completion: @escaping result<T>) {
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        // Er der fejl i forbindelse med download så ...
        if let error = error {
            completion(.failure(error))
        }
        
        // Er der response fejl (ie. en fejlkode der ikke er korrekt så...
        // og her giver det ikke mening at fortsætte så derfor guard og ikke if let
        guard let response = response as? HTTPURLResponse else {
            completion(.failure(DataError.invalidResponse))
            return
        }
        
        if 200 ... 299 ~= response.statusCode {
            if let data = data {
                do {
                    let decodedData: T = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decodedData))
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        completion(.failure(DataError.decodingError))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(DataError.invalidData))
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(.failure(DataError.serverError))
            }
        }
    }.resume()
        
    }
}
