//
//  Contact.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 28/05/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit

class Contact: NSObject {
    let IDContacto = "ID Contacto"
    let IDGmailContacto = "Gmail Contacto"
    
    var sContactoID:String?
    var sGmailContacto:String?
    
    func setMap (valores:[String:Any]) {
        sContactoID = valores[IDContacto] as? String
        sGmailContacto = valores[IDGmailContacto] as? String
    }
    
    func getMap () -> [String:Any]{
        var mapTemp:[String:Any] = [:]
        mapTemp [IDContacto] = sContactoID as Any
        mapTemp [IDGmailContacto] = sGmailContacto as Any
        return mapTemp
    }
}

