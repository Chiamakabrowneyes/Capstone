//
//  ConversationsView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 9/30/23.
//

import SwiftUI

/**
 Conversation view contains and displays the collections of all users who are in current communication with the user in active session.
 */
struct ConversationsView: View {
    @State var user: User?
    @State var showChat = false
    @State var isShowingNewMessageView = false
    
    //observed instance of ConversationsViewModel, responsible for managing and fetching recent messages.
    @ObservedObject var viewModel = ConversationsViewModel()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            //Clicking on a user creates a segue for one-on-one interaction
            if let user = user {
                NavigationLink(destination: LazyView(ChatView(user: user)),
                               isActive: $showChat,
                               label: {} )
            }
            
            
            //The ScrollView loops over viewModel.recentMessages to display each recent message.
            
            ScrollView {
                VStack {
                    //Each message is rendered using a ConversationCell which takes in a MessageViewModel initialized with the current message.
                    ForEach(viewModel.recentMessages) { message in
                        if let user = message.user {
                            NavigationLink(
                                destination:
                                    LazyView(ChatView(user: user))
                                    .onDisappear(perform: {
                                        viewModel.fetchRecentMessages()
                                    }),
                                label: {
                                    ConversationCell(viewModel: MessageViewModel(message: message))
                                })
                        }
                    }
                }.padding()
            }
            
            HStack {
                Spacer()
                //creates FloatingButton that presents the NewMessageView starts a new chat.
                FloatingButton(show: $isShowingNewMessageView)
                    .sheet(isPresented: $isShowingNewMessageView, content: {
                        NewMessageView(show: $isShowingNewMessageView,
                                       startChat: $showChat,
                                       user: $user)
                    })
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsView()
    }
}

