import SwiftUI
import SDWebImageSwiftUI

struct MessageView: View {
    var user: User
    @StateObject var chatViewModel = ChatViewModel()
    @State private var message: String = ""
    @State private var isLoading: Bool = false
    @State private var imageData: Data = Data()

    var body: some View {
        VStack {
            ScrollView {
                ForEach(chatViewModel.chats, id: \.messageId) { chat in
                    if chat.isCurrentUser {
                        // own message
                        HStack {
                            Spacer()
                            Text(chat.textMessage)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }.padding(.horizontal)
                    } else {
                        // other user message
                        HStack {
                            Text(chat.textMessage)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                            Spacer()
                        }.padding(.horizontal)
                    }
                }
            }.padding(.bottom)


            HStack {
                TextField("Type your message here...", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

              Button(action: {
                  isLoading = true
                  // Send text message
                chatViewModel.sendMessage(message: message, recipientId: user.uid, recipientProfile: user.profileImageURL, recipientName: user.userName, onSuccess: {
                      message = ""
                      isLoading = false
                  }, onError: { error in
                      print("Error sending message: \(error)")
                      isLoading = false
                  })
              }) {
                  Image(systemName: "paperplane.fill")
                      .resizable()
                      .frame(width: 24, height: 24)
                      .foregroundColor(.blue)
              }
              .disabled(message.isEmpty || isLoading)


            }.padding()
        }
        .navigationBarTitle("Chat with \(user.userName)", displayMode: .inline)
        .onAppear {
          chatViewModel.recipientId = user.uid
          chatViewModel.loadChats()
        }
    }
}
