//
//  AlertData.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 1/13/24.
//

import FirebaseFirestoreSwift
import Firebase


//TODO: Create a struct for siren calls. which would contain the same data as a text message including some more unique info; eg location data.

struct SirenData: Identifiable, Decodable {
    let id: String
    let fromId: String
    var riskTypes: [String]
    var latitude: Double?
    var longitude:Double?
    let timestamp: Timestamp
}
