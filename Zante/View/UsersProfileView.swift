import SwiftUI
import SDWebImageSwiftUI

struct UsersProfileView: View {
    @State var selection = 1
    var user: User
    @StateObject var profileViewModel = ProfileViewModel()
    let threeColumns = [GridItem(), GridItem(), GridItem()]

    @State private var showMessageView: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                ProfileHeader(user: user, postsCount: profileViewModel.posts.count, following: $profileViewModel.following, followers: $profileViewModel.followers)

                HStack {
                    Follow(user: user, followCheck: $profileViewModel.followCheck, followingCount: $profileViewModel.following, followersCount: $profileViewModel.followers)
                }.padding(.horizontal)

                Picker("", selection: $selection) {
                    Image(systemName: "circle.grid.2x2.fill").tag(0)
                    Image(systemName: "person.circle").tag(1)
                }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal)

                if selection == 0 {
                    LazyVGrid(columns: threeColumns) {
                        ForEach(self.profileViewModel.posts, id:\.postId) { (post) in
                            WebImage(url: URL(string: post.mediaUrl)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/3).clipped()
                        }
                    }
                } else {
                    ScrollView {
                        VStack {
                            ForEach(self.profileViewModel.posts, id:\.postId) { (post) in
                                PostCardImage(post: post)
                            }
                        }
                    }
                }
            }
            .navigationTitle(Text(self.user.userName))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showMessageView = true }) {
                        MessageButton()
                    }
                }
            }
            .sheet(isPresented: $showMessageView) {
                NavigationView {
                    MessageView(user: user)
                }
            }
            .onAppear {
                self.profileViewModel.loadUserPosts(userId: self.user.uid)
            }
        }
    }
}
