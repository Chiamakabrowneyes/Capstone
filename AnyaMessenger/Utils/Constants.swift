//
//  Constants.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/14/23.
//

import Firebase

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_MESSAGES = Firestore.firestore().collection("messages")
let COLLECTION_CHANNELS = Firestore.firestore().collection("channels")
let COLLECTION_SIRENS = Firestore.firestore().collection("sirens")
let COLLECTION_ALERTS = Firestore.firestore().collection("alerts")
let COLLECTION_REPORTS = Firestore.firestore().collection("reports")

let OPENAI_API_KEY = "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"
