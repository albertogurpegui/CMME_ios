//
//  Firebase.swift
//  CMME
//
//  Created by Alberto Gurpegui Ramon on 21/02/2019.
//  Copyright © 2019 Alberto Gurpegui Ramon. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class Firebase: NSObject {
    
    static let sharedInstance:Firebase=Firebase()
    var sEmail:String = ""
    var sPassword:String = ""
    var firDocumentRef: DocumentReference?
    var firStoreDB:Firestore?
    var patient:Patient = Patient()
    var doctor:Doctor = Doctor()
    var meeting:Meeting = Meeting()
    var arrMeeting:[Meeting] = []
    var userType: TypeUser?
    var user: AuthDataResult?
    
    func initFireBase(){
        FirebaseApp.configure()
        firStoreDB=Firestore.firestore()
    }
    
    func saveData(){
        let props = UserDefaults.standard
        props.setValue(sEmail, forKey: "usuario_login")
        props.setValue(sPassword, forKey: "password_login")
        props.synchronize()
    }
    
    func executeLogin(sEmail:String, sContraseña:String, typeUser: TypeUser) {
        print("Esta en data holder")
        self.userType = typeUser
        if let typeUser = userType {
            switch typeUser {
            case .doctor:
                Auth.auth().signIn(withEmail: sEmail, password: sContraseña) { (user, error) in
                    if user != nil {
                        self.user = user
                        print("Doctor logueado")
                        let ruta = Firebase.sharedInstance.firStoreDB?.collection("Doctores").document((user?.user.uid)!)
                        ruta?.getDocument{ (document, error) in
                            if document != nil{
                                Firebase.sharedInstance.doctor.setMap(valores:(document?.data())!)
                            }
                            else{
                                print("ERROR EN LOGEO ", error!)
                            }
                        }
                    }
                    else {
                        print("ERROR EN LOGEO ", error!)
                    }
                }
            case .patient:
                Auth.auth().signIn(withEmail: sEmail, password: sContraseña) { (user, error) in
                    if user != nil {
                        self.user = user
                        print("Patient logueado")
                        let ruta = Firebase.sharedInstance.firStoreDB?.collection("Pacientes").document((user?.user.uid)!)
                        ruta?.getDocument{ (document, error) in
                            if document != nil{
                                Firebase.sharedInstance.patient.setMap(valores:(document?.data())!)
                            }
                            else{
                                print(error!)
                            }
                        }
                    }
                    else {
                        print("ERROR EN LOGEO ", error!)
                    }
                }
            }
        }
    }
    
    func executeRegister(sEmail:String, sContraseña:String, typeUser: TypeUser) {
        print("Esta en data holder")
        self.userType = typeUser
        if let typeUser = userType {
            switch typeUser {
            case .doctor:
                Auth.auth().createUser(withEmail: sEmail, password: sContraseña) { (user, error) in
                    if user != nil {
                        self.user = user
                    Firebase.sharedInstance.firStoreDB?.collection("Doctores").document((user?.user.uid)!).setData(Firebase.sharedInstance.doctor.getMap())
                        
                        print("Doctor registrado")
                    }
                    else {
                        print("ERROR EN LOGEO ", error!)
                    }
                }
            case .patient:
                Auth.auth().createUser(withEmail: sEmail, password: sContraseña) { (user, error) in
                    if user != nil {
                        self.user = user
                    Firebase.sharedInstance.firStoreDB?.collection("Pacientes").document((user?.user.uid)!).setData(Firebase.sharedInstance.patient.getMap())
                        print("Patient registrado")
                    }
                    else {
                        print("ERROR EN LOGEO ", error!)
                    }
                }
            }
        }
    }
    
    func addMeeting() {
        if let typeUser = ContainerNavigationController.userType {
            switch typeUser {
            case .doctor:
                if let userADR = user {
                    Firebase.sharedInstance.firStoreDB?.collection("Doctores").document(userADR.user.uid).collection("Citas").document(UUID().uuidString).setData(Firebase.sharedInstance.meeting.getMap())
                    print("Añade cita en doctor " + userADR.user.email!)
                }
            case .patient:
                if let userADR = user {
                    Firebase.sharedInstance.firStoreDB?.collection("Pacientes").document(userADR.user.uid).collection("Citas").document(UUID().uuidString).setData(Firebase.sharedInstance.meeting.getMap())
                    print("Añade cita en paciente " + userADR.user.email!)
                }
            }
        }
    }
    
    func getUserMeetings() {
        
        if let typeUser = ContainerNavigationController.userType {
            switch typeUser {
            case .doctor:
                if let userADR = user {
                    let ruta = Firebase.sharedInstance.firStoreDB?.collection("Doctores").document(userADR.user.uid).collection("Citas")
                    ruta?.getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                
                                print("\(document.documentID) => \(document.data())")
                            }
                        }
                    }
                }
            case .patient:
                if let userADR = user {
                    let ruta = Firebase.sharedInstance.firStoreDB?.collection("Pacientes").document(userADR.user.uid).collection("Citas")
                    ruta?.getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            Firebase.sharedInstance.arrMeeting = []
                            for document in querySnapshot!.documents {
                                let value = document.data()
                                let descMeeting = value["Descripcion Cita"] as? String ?? ""
                                let nameDocMeeting = value["Nombre Doctor Completo"] as? String ?? ""
                                let namePatMeeting = value["Nombre Paciente Completo"] as? String ?? ""
                                let meeting = Meeting()
                                meeting.sNombreDoctorCompleto = nameDocMeeting
                                meeting.sNombrePacienteCompleto = namePatMeeting
                                meeting.sDescripcionCita = descMeeting
                                Firebase.sharedInstance.arrMeeting.append(meeting)
                                
                                print("\(document.documentID) => \(document.data())")
                            }
                        }
                    }
                }
            }
        }
    }
}
