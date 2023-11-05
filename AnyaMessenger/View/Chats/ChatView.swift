//
//  ChatsView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 9/30/23.
//

import SwiftUI

/**
 The ChatView struct represents a SwiftUI view designed for displaying a chat interface where users can send and receive messages
 */
struct ChatView: View {
    let user: User
    @ObservedObject var viewModel: ChatViewModel
    @State private var messageText: String = ""
    @State private var selectedImage: UIImage?
    
    //initializes the required parameters for Chat view
    init(user: User) {
        self.user = user
        self.viewModel = ChatViewModel(user: user)
    }
    
    var body: some View {
        VStack {
            //display a list of chat messages.
            ScrollViewReader { value in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageView(viewModel: MessageViewModel(message: message))
                                .id(message.id)
                        }
                    }.padding(.top)
                }
                .onReceive(viewModel.$messageToSetVisible, perform: { id in
                    value.scrollTo(id)
                })
            }
            //creates entry point for user to write new messages
            CustomInputView(inputText: $messageText,
                            selectedImage: $selectedImage,
                            action: sendMessage)
                .padding()
        }
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    //creates a system for adding new messages to chatview
    func sendMessage() {
        if let image = selectedImage {
            viewModel.send(type: .image(image))
            selectedImage = nil
        } else {
            viewModel.send(type: .text(messageText))
            messageText = ""
        }
    }
}
