//
//  Contact.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 28/05/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit

class Contact: NSObject {
    let IDGmailContacto = "Gmail Contacto"
    
    var sGmailContacto:String?
    
    func setMap (valores:[String:Any]) {
        sGmailContacto = valores[IDGmailContacto] as? String
    }
    
    func getMap () -> [String:Any]{
        var mapTemp:[String:Any] = [:]
        mapTemp [IDGmailContacto] = sGmailContacto as Any
        return mapTemp
    }
}

