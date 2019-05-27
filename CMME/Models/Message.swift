import Foundation
import UIKit
import MessageKit

/*class Message: NSObject {
 let IDcontent = "Content"
 let IDcreated = "Created"
 let IDSender = "SenderID"
 let IDReceiver = "ReceiverID"
 let IDSenderName = "SenderName"
 
 var sContent:String?
 var sCreated:String?
 var sSenderID:String?
 var sReceiverID:String?
 var sSenderName:String?
 
 func setMap (valores:[String:Any]) {
 sContent = valores[IDcontent] as? String
 sCreated = valores[IDcreated] as? String
 sSenderID = valores[IDSender] as? String
 sReceiverID = valores[IDReceiver] as? String
 sSenderName = valores[IDSenderName] as? String
 }
 
 func getMap () -> [String:Any]{
 var mapTemp:[String:Any] = [:]
 mapTemp [IDcontent] = sContent as Any
 mapTemp [IDcreated] = sCreated as Any
 mapTemp [IDSender] = sSenderID as Any
 mapTemp [IDReceiver] = sReceiverID as Any
 mapTemp [IDSenderName] = sSenderName as Any
 return mapTemp
 }
 }*/

//Esto de abajo tengo que comprobar que hace

struct Member {
    let name: String
    let color: UIColor
}

struct Message {
    let member: Member
    let text: String
    let messageId: String
}

extension Message: MessageType {
    var sender: Sender {
        return Sender(id: member.name, displayName: member.name)
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}
