import SwiftUI
import SDWebImageSwiftUI

struct UsersProfileView: View {
    @State var selection = 1
    var user: User
    @StateObject var profileService = ProfileService()
    let threeColumns = [GridItem(), GridItem(), GridItem()]

    @State private var showMessageView: Bool = false

    var body: some View {
        ScrollView {
            ProfileHeader(user: user, postsCount: profileService.posts.count, following: $profileService.following, followers: $profileService.followers)

            HStack {
                FollowButton(user: user, followCheck: $profileService.followCheck, followingCount: $profileService.following, followersCount: $profileService.followers)
            }.padding(.horizontal)

            Picker("", selection: $selection) {
                Image(systemName: "circle.grid.2x2.fill").tag(0)
                Image(systemName: "person.circle").tag(1)
            }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal)

            if selection == 0 {
                LazyVGrid(columns: threeColumns) {
                    ForEach(self.profileService.posts, id:\.postId) { (post) in
                        WebImage(url: URL(string: post.mediaUrl)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/3).clipped()
                    }
                }
            } else {
                ScrollView {
                    VStack {
                        ForEach(self.profileService.posts, id:\.postId) { (post) in
                            PostCardImage(post: post)
                            PostCard(post: post)
                        }
                    }
                }
            }
        }
        .navigationTitle(Text(self.user.userName))
        .navigationBarItems(trailing: NavigationLink(destination: MessageView(user: user), isActive: $showMessageView) {
            Button(action: {
                showMessageView = true
            }) {
                MessageButton()
            }
        })
        .onAppear {
            self.profileService.loadUserPosts(userId: self.user.uid)
        }
    }
}



