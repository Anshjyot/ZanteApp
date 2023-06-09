import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI
import FirebaseStorage

struct Profile: View {
  @State var selection = 1
  @State private var isProfileActive = false
  @EnvironmentObject var session: SessionViewModel
  @StateObject var profileService = ProfileViewModel()
  @State private var isLinkActive = false

  //array
  let threeColumns = [GridItem(), GridItem(), GridItem()]

  var body: some View {
    ScrollView {
      VStack {
        ProfileHeader(user: self.session.session, postsCount: profileService.posts.count, following: $profileService.following, followers: $profileService.followers)

        VStack(alignment: .leading) {
          Text(session.session?.bio ?? "").font(.headline).lineLimit(1)
        }
        NavigationLink(destination: EditProfile(session: self.session.session), isActive: $isLinkActive) {
          Button(action: {self.isLinkActive = true}){
            Text("Edit Profile")
                  .foregroundColor(.white)
                  .padding(.horizontal, 120)
                  .padding(.vertical, 5)
          }
          .background(Color.blue)
          .cornerRadius(10)
          .padding(.horizontal)
        }
        Picker("", selection: $selection) {
          Image(systemName: "circle.grid.2x2.fill").tag(0)
          Image(systemName: "person.circle").tag(1)
        }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal)
        
        if selection == 0 {
          LazyVGrid(columns: threeColumns) {
            ForEach(self.profileService.posts, id:\.postId) {
              (post) in
              WebImage(url: URL(string: post.mediaUrl)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/3).clipped()
            }
          }
        }
        else
        if(self.session.session == nil){
          Text("") }
        else {
          ScrollView{
            VStack {
              ForEach(self.profileService.posts, id:\.postId) {
                (post) in
                PostCardImage(post: post)
                PostCard(post: post)
                
              }
            }
          }
        }
      }
    }
    .toolbar {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
        Button(action: {
          self.session.logout()
        }) {
          Image(systemName: "arrow.right.circle.fill")
        }.onAppear{
          if let currentUser = Auth.auth().currentUser {
              self.profileService.loadUserPosts(userId: currentUser.uid)
          }

        }
      }
    }
  }

}
