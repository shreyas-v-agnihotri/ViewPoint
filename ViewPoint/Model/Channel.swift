/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import FirebaseFirestore
import FirebaseAuth
import Kingfisher

struct Channel {
  
    let id: String
    let topic: String
    let currentUser: ChatParticipant
    let opponent: ChatParticipant
  
    init(document: QueryDocumentSnapshot) {
        let data = document.data()
    
        self.topic = data["topic"] as! String
        self.id = document.documentID
        
        let user = Auth.auth().currentUser!
        let users = data["users"] as! [String]
        
        var currentUserIndex = -1
        for index in 0...(users.count-1) {
            if users[index] == user.uid {
                currentUserIndex = index
            }
        }
        let opponentIndex = users.count - 1 - currentUserIndex
        
        self.currentUser = ChatParticipant(
            index: currentUserIndex,
            ids: data["users"] as! [String],
            names: data["userNames"] as! [String],
            imageURLs: data["userPhotoURLs"] as! [String]
        )
        
        self.opponent = ChatParticipant(
            index: opponentIndex,
            ids: data["users"] as! [String],
            names: data["userNames"] as! [String],
            imageURLs: data["userPhotoURLs"] as! [String]
        )
    }
  
}

class ChatParticipant {
    let id: String
    let name: String
    var imageURL: String
    
    init(index: Int, ids: [String], names: [String], imageURLs: [String]) {
        self.id = ids[index]
        self.name = names[index]
        self.imageURL = imageURLs[index]

    }
}

//extension Channel: DatabaseRepresentation {
extension Channel {

  var representation: [String : Any] {
    return ["topic": topic, "id": id]
  }
  
}

extension Channel: Comparable {
  
  static func == (lhs: Channel, rhs: Channel) -> Bool {
    return lhs.id == rhs.id
  }
  
  static func < (lhs: Channel, rhs: Channel) -> Bool {
    return lhs.topic < rhs.topic
  }

}
