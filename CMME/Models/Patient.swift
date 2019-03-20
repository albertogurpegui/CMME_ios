//
//  Patient.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 21/02/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit

class Patient: NSObject {
    let IDNombreCompleto = "Nombre Completo"
    let IDGmail = "Gmail"
    let IDNumMovil = "Nº Movil"
    let IDNumNIF = "Nº NIF"
    let IDTarjSani = "Nº Tarjeta Sanitaria"
    let IDTlfContact = "Nº Telefono Contacto"
    
    var sNombreCompleto:String?
    var sGmail:String?
    var sNumMovil:String?
    var sNumNIF:String?
    var sTarjSani:String?
    var sTlfContact:String?
    var meetingsPatient: [Meeting] = []

    func setMap (valores:[String:Any]) {
        sNombreCompleto = valores[IDNombreCompleto] as? String
        sGmail = valores[IDGmail] as? String
        sNumMovil = valores[IDNumMovil] as? String
        sNumNIF = valores[IDNumNIF] as? String
        sTarjSani = valores[IDTarjSani] as? String
        sTlfContact = valores[IDTlfContact] as? String
    }
    
    func getMap () -> [String:Any]{
        var mapTemp:[String:Any] = [:]
        mapTemp [IDGmail] = sGmail as Any
        mapTemp [IDNombreCompleto] = sNombreCompleto as Any
        mapTemp [IDNumMovil] = sNumMovil as Any
        mapTemp [IDNumNIF] = sNumNIF as Any
        mapTemp [IDTarjSani] = sTarjSani as Any
        mapTemp [IDTlfContact] = sTlfContact as Any
        return mapTemp
    }
}
