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
    var hmImagenesDescargadas:[String:UIImage]?=[:]
    var sEmail:String = ""
    var sPassword:String = ""
    var firDocumentRef: DocumentReference?
    var firStoreDB:Firestore?
    var patient:Patient = Patient()
    var doctor:Doctor = Doctor()
    var type: String?
    
    func initFireBase(){
        FirebaseApp.configure()
        firStoreDB=Firestore.firestore()
    }
    
    func loadData(){
        let props = UserDefaults.standard
        //sUsuario = props.string(forKey: "usuario_login")!
        //sPassword = props.string(forKey: "password_login")!
    }
    
    func saveData(){
        let props = UserDefaults.standard
        props.setValue(sEmail, forKey: "usuario_login")
        props.setValue(sPassword, forKey: "password_login")
        props.synchronize()
    }
    
    func executeLogin(sEmail:String, sContraseña:String, typeUser: String) {
        print("Esta en data holder")
        self.type = typeUser
        if let typeUser = type {
            switch typeUser {
            case "Doctor":
                Auth.auth().signIn(withEmail: sEmail, password: sContraseña) { (user, error) in
                    if user != nil {
                        print("Doctor logueado")
                        let ruta = Firebase.sharedInstance.firStoreDB?.collection("Doctores").document((user?.user.uid)!)
                        ruta?.getDocument{ (document, error) in
                            if document != nil{
                                Firebase.sharedInstance.doctor.setMap(valores:(document?.data())!)
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
            case "Patient":
                Auth.auth().signIn(withEmail: sEmail, password: sContraseña) { (user, error) in
                    if user != nil {
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
            default:
                break
            }
        }
    }
    func executeRegister(sEmail:String, sContraseña:String, typeUser: String) {
        print("Esta en data holder")
        self.type = typeUser
        if let typeUser = type {
            switch typeUser {
            case "Doctor":
                Auth.auth().createUser(withEmail: sEmail, password: sContraseña) { (user, error) in
                    if user != nil {
                    Firebase.sharedInstance.firStoreDB?.collection("Doctores").document((user?.user.uid)!).setData(Firebase.sharedInstance.doctor.getMap())
                        
                        print("Doctor registrado")
                    }
                    else {
                        print("ERROR EN LOGEO ", error!)
                    }
                }
            case "Patient":
                Auth.auth().createUser(withEmail: sEmail, password: sContraseña) { (user, error) in
                    if user != nil {
                    Firebase.sharedInstance.firStoreDB?.collection("Pacientes").document((user?.user.uid)!).setData(Firebase.sharedInstance.patient.getMap())
                        
                        print("Patient registrado")
                    }
                    else {
                        print("ERROR EN LOGEO ", error!)
                    }
                }
            default:
                break
            }
        }
    }
}
