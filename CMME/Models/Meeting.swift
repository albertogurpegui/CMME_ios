//
//  Meeting.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 06/03/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import UIKit

class Meeting: NSObject {
    let IDNombreDoctorCompleto = "Nombre Doctor Completo"
    let IDNombrePacienteCompleto = "Nombre Paciente Completo"
    let IDDescripcionCita = "Descripcion Cita"
    let IDSalaCita = "Sala Cita"
    let IDFechaCita = "Fecha Cita"
    
    var sNombreDoctorCompleto:String?
    var sNombrePacienteCompleto:String?
    var sDescripcionCita:String?
    var sSalaCita:String?
    var sFechaCita:String?
    
    func setMap (valores:[String:Any]) {
        sNombreDoctorCompleto = valores[IDNombreDoctorCompleto] as? String
        sNombrePacienteCompleto = valores[IDNombrePacienteCompleto] as? String
        sDescripcionCita = valores[IDDescripcionCita] as? String
        sSalaCita = valores[IDSalaCita] as? String
        sFechaCita = valores[IDFechaCita] as? String
    }
    
    func getMap () -> [String:Any]{
        var mapTemp:[String:Any] = [:]
        mapTemp [IDNombreDoctorCompleto] = sNombreDoctorCompleto as Any
        mapTemp [IDNombrePacienteCompleto] = sNombrePacienteCompleto as Any
        mapTemp [IDDescripcionCita] = sDescripcionCita as Any
        mapTemp [IDSalaCita] = sSalaCita as Any
        mapTemp [IDFechaCita] = sFechaCita as Any
        return mapTemp
    }
}
