import SwiftUI
import SDWebImageSwiftUI

struct MainView: View {
    @StateObject var profileService = ProfileViewModel()

    var body: some View {
        ScrollView {
            VStack {
                ForEach(self.profileService.posts, id:\.postId) { (post) in
                    PostCardImage(post: post)
                    PostCard(post: post)
                }
            }
        }
        .navigationTitle(Text("All Posts"))
        .onAppear {
            self.profileService.loadAllUsersPosts()
        }
    }
}
