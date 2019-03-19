//
//  Doctor.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 21/02/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit

class Doctor: NSObject {
    let IDNombreCompleto = "Nombre Completo"
    let IDGmail = "Gmail"
    let IDHospTrabaj = "Hospital donde trabaja"
    let IDRegisNacTitu = "Registro Nacional de titulos"
    
    var sNombreCompleto:String?
    var sGmail:String?
    var sHospTrabaj:String?
    var sRegisNacTitu:String?
    var meetingDoctor: [Meeting] = []
    
    func setMap (valores:[String:Any]) {
        sNombreCompleto = valores[IDNombreCompleto] as? String
        sGmail = valores[IDGmail] as? String
        sHospTrabaj = valores[IDHospTrabaj] as? String
        sRegisNacTitu = valores[IDRegisNacTitu] as? String
    }
    
    func getMap () -> [String:Any]{
        var mapTemp:[String:Any] = [:]
        mapTemp [IDGmail] = sGmail as Any
        mapTemp [IDNombreCompleto] = sNombreCompleto as Any
        mapTemp [IDHospTrabaj] = sHospTrabaj as Any
        mapTemp [IDRegisNacTitu] = sRegisNacTitu as Any
        return mapTemp
    }
}
