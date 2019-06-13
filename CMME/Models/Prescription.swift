//
//  Prescription.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 09/06/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit

class Prescription: NSObject {
    let IDURLPrescription = "URL Receta"
    let IDGmailPaciente = "Gmail Paciente"
    let IDGmailDoctor = "Gmail Doctor"
    
    var sURLPrescription:String?
    var sGmailPaciente:String?
    var sGmailDoctor:String?
    
    func setMap (valores:[String:Any]) {
        sURLPrescription = valores[IDURLPrescription] as? String
        sGmailPaciente = valores[IDGmailPaciente] as? String
        sGmailDoctor = valores[IDGmailDoctor] as? String
    }
    
    func getMap () -> [String:Any]{
        var mapTemp:[String:Any] = [:]
        mapTemp [IDURLPrescription] = sURLPrescription as Any
        mapTemp [IDGmailPaciente] = sGmailPaciente as Any
        mapTemp [IDGmailDoctor] = sGmailDoctor as Any
        return mapTemp
    }
}
