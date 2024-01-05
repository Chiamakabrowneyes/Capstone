//
//  SirenViewModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 11/4/23.
//

import SwiftUI
import Firebase

class SirenViewModel: ObservableObject {
    let user: User
    
    @Published var messages = [TextMessage]()
    @Published var messageToSetVisible: String?
    
    init(user: User) {
        self.user = user
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

            for uid in uids {
                let messageText = self.constructSiren(riskDescription)
                self.sendSirenMessage(messageText, receiverId: uid)
        
            }
        }
    }
    
    func constructSiren(_ riskDescription: String) -> String {
        guard let currentUserName = AuthSceneModel.shared.currentUser?.username else {
            return "SIREN ALERT \n The risk is at a \(riskDescription). \n Please take necessary precautions."
        }
        
        let messageText = "🚨  🚨  🚨  🚨  🚨  🚨  🚨  🚨  🚨\n\nSIREN ALERT FOR \(currentUserName.uppercased()).\nThe risk is described at a \(riskDescription).\n\(currentUserName) needs you to be aware of the current circumstances and to take necessary precautions.\n\n🚨  🚨  🚨  🚨  🚨  🚨  🚨  🚨  🚨"
        return messageText
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
