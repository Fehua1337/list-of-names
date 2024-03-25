//
//  Country.swift
//  DataBase Realm
//
//  Created by Alisher Tulembekov on 18.03.2024.
//

import Foundation
import RealmSwift

class fullName: Object {
    @Persisted var name: String
    @Persisted var surname: String
    @Persisted var pasword: String

}
