//
//  SirenViewModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 11/4/23.
//

import SwiftUI
import Firebase
import CoreLocation

class SirenViewModel: ObservableObject {
    let user: User
    @Published var messages = [TextMessage]()
    @Published var messageToSetVisible: String?
    @ObservedObject var locationViewModel: LocationViewModel
    @State private var geocoder = CLGeocoder()
    @State private var sirenMessage = ""
    @State private var allRiskTypes = [String]()
    
    init(user: User) {
        self.user = user
        self.locationViewModel = LocationViewModel(user: user)

    }
    
    func fetchSirenListForUser(userId: String, completion: @escaping ([String]?, Error?) -> Void) {
        COLLECTION_SIRENS.whereField("creator", isEqualTo: userId).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching siren list: \(error)")
                completion(nil, error)
            } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                // Assuming each user has only one siren list
                let sirenListDocument = documents.first!
                if let uids = sirenListDocument.data()["uids"] as? [String] {
                    completion(uids, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, nil)
            }
        }
    }
    
    func sendMessageToSirenList(riskDescription: String) {
        fetchSirenListForUser(userId: user.id ?? "unknown") { [weak self] uids, error in
            guard let self = self, let uids = uids, error == nil else {
                print("Error or no users in siren list: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Call constructSiren with a completion handler
            self.constructSiren(riskDescription) { messageText in
                // Now that you have the message text, send it to each user
                for uid in uids {
                    self.sendSirenMessage(messageText, receiverId: uid)
                }
            }
        }
    }
    
    func addRiskTypes(riskType: String) {
        allRiskTypes.append(riskType)
    }

    
    
    func constructSiren(_ riskDescription: String, completion: @escaping (String) -> Void) {
        guard let currentUserName = AuthSceneModel.shared.currentUser?.username else {
            completion("SIREN ALERT \n The risk is at a \(riskDescription). \n Please take necessary precautions.")
            return
        }

        // Retrieve coordinates
        self.getSirenCoordinates() { latitude, longitude in
            var messageText = "🚨  🚨  🚨  🚨  🚨  🚨  🚨  🚨  🚨\n\nSIREN ALERT FOR \(currentUserName.uppercased()).\nThe risk is described at a \(riskDescription).\n\(currentUserName) needs you to be aware of the current circumstances and to take necessary precautions."

            if let latitude = latitude, let longitude = longitude {
                self.reverseGeocode(latitude: latitude, longitude: longitude) { address in
                    if let address = address {
                        // Append location address to messageText
                        messageText += "\n\nCurrent Location: \n\(address)\n"
                    } else {
                        print("Unable to retrieve location address.")
                    }

                    // Call the completion handler with the updated messageText
                    messageText += "\n🚨  🚨  🚨  🚨  🚨  🚨  🚨  🚨  🚨"
                    
                    completion(messageText)
                }
            } else {
                // Call the completion handler without updating messageText
                messageText += "\n\n🚨  🚨  🚨  🚨  🚨  🚨  🚨  🚨  🚨"
                
                completion(messageText)
            }
        }
    }

    
    func reverseGeocode(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                completion(nil)
            } else if let placemark = placemarks?.first {
                // Extract address information from the placemark
                let address = "\(placemark.name ?? "") \(placemark.locality ?? "") \(placemark.administrativeArea ?? "") \(placemark.country ?? "")"
                completion(address)
            } else {
                completion(nil)
            }
        }
    }

    
    
    func getSirenCoordinates(completion: @escaping (Double?, Double?) -> Void) {
            locationViewModel.getCurrentLocation { [weak self] location in
                guard let self = self else { return }

                if let location = location {
                    let latitude = location.latitude
                    let longitude = location.longitude
                    completion(latitude, longitude)
                } else {
                    print("Failed to retrieve location.")
                    completion(nil, nil)
                }
            }
        }


    func sendSirenMessage(_ messageText: String, receiverId: String) {
        guard let currentUid = AuthSceneModel.shared.currentUser?.id else { return }
        
        let currentUserRef = COLLECTION_MESSAGES.document(currentUid).collection(receiverId).document()
        let receivingUserRef = COLLECTION_MESSAGES.document(receiverId).collection(currentUid)
        let receivingRecentRef = COLLECTION_MESSAGES.document(receiverId).collection("recent-messages")
        let currentRecentRef = COLLECTION_MESSAGES.document(currentUid).collection("recent-messages")
        
        let messageID = currentUserRef.documentID
        
        let data: [String: Any] = [
            "text": messageText,
            "id": messageID,
            "fromId": currentUid,
            "toId": receiverId,
            "read": false,
            "timestamp": Timestamp(date: Date())
        ]
        
        currentUserRef.setData(data)
        currentRecentRef.document(receiverId).setData(data)
        receivingUserRef.document(messageID).setData(data)
        receivingRecentRef.document(currentUid).setData(data)
    }
}
