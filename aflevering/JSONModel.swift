//
//  JSONModel.swift
//  aflevering
//
//  Created by dmu mac 07 on 20/04/2020.
//  Copyright © 2020 eaaa. All rights reserved.
//

import UIKit

struct Items: Codable {
    let items: [Item]
}

struct Item: Codable {
    let id: Int
    let name, description, url: String
    let created_at, updated_at: Date
    let owner: Owner
}
struct Owner: Codable {
    let avatar_url: String
}
