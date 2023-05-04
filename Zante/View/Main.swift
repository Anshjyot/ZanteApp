import SwiftUI
import SDWebImageSwiftUI

struct Main: View {
    @StateObject var profileService = ProfileService()

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
