//
//  Extensions.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/1/23.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
