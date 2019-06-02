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
    var contact:Contact = Contact()
    var arrContacts:[Contact] = []
    //var message:Message = Message()
    var arrMessages:[Message] = []
    var userType: TypeUser?
    var user: User?
    
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
    
    func executeLogin(sEmail:String, sContraseña:String, typeUser: TypeUser, completion:@escaping (User)->Void) {
        print("Esta en data holder")
        self.userType = typeUser
        if let typeUser = userType {
            switch typeUser {
            case .doctor:
                Auth.auth().signIn(withEmail: sEmail, password: sContraseña) { (user, error) in
                    if user != nil {
                        Firebase.sharedInstance.user = Auth.auth().currentUser
                        print("Doctor logueado")
                        let ruta = Firebase.sharedInstance.firStoreDB?.collection("Doctores").document((user?.user.uid)!)
                        ruta?.getDocument{ (document, error) in
                            if document != nil{
                                Firebase.sharedInstance.doctor.setMap(valores:(document?.data())!)
                                if let userAuthDataResult = Firebase.sharedInstance.user {
                                    completion(userAuthDataResult)
                                }
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
                        Firebase.sharedInstance.user = Auth.auth().currentUser
                        print("Patient logueado")
                        let ruta = Firebase.sharedInstance.firStoreDB?.collection("Pacientes").document((user?.user.uid)!)
                        ruta?.getDocument{ (document, error) in
                            if document != nil{
                                Firebase.sharedInstance.patient.setMap(valores:(document?.data())!)
                                if let userAuthDataResult = Firebase.sharedInstance.user {
                                    completion(userAuthDataResult)
                                }
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
    
    func executeRegister(sEmail:String, sContraseña:String, typeUser: TypeUser, completion:@escaping (User)->Void) {
        print("Esta en data holder")
        self.userType = typeUser
        if let typeUser = userType {
            switch typeUser {
            case .doctor:
                Auth.auth().createUser(withEmail: sEmail, password: sContraseña) { (user, error) in
                    if user != nil {
                        Firebase.sharedInstance.user = Auth.auth().currentUser
                    Firebase.sharedInstance.firStoreDB?.collection("Doctores").document((user?.user.uid)!).setData(Firebase.sharedInstance.doctor.getMap())
                        
                        if let userAuthDataResult = Firebase.sharedInstance.user {
                            completion(userAuthDataResult)
                        }
                        print("Doctor registrado")
                    }
                    else {
                        print("ERROR EN LOGEO ", error!)
                    }
                }
            case .patient:
                Auth.auth().createUser(withEmail: sEmail, password: sContraseña) { (user, error) in
                    if user != nil {
                        Firebase.sharedInstance.user = Auth.auth().currentUser
                    Firebase.sharedInstance.firStoreDB?.collection("Pacientes").document((user?.user.uid)!).setData(Firebase.sharedInstance.patient.getMap())
                        
                        if let userAuthDataResult = Firebase.sharedInstance.user {
                            completion(userAuthDataResult)
                        }
                        print("Patient registrado")
                    }
                    else {
                        print("ERROR EN LOGEO ", error!)
                    }
                }
            }
        }
    }
    
    func getUserMeetings(completion:@escaping ([Meeting])->Void) -> ListenerRegistration? {
        var listenerMeeting: ListenerRegistration? = nil
        if let typeUser = ContainerNavigationController.userType {
            switch typeUser {
            case .doctor:
                if let userADR = user {
                    listenerMeeting =  (Firebase.sharedInstance.firStoreDB?.collection("Doctores").document(userADR.uid).collection("Citas").addSnapshotListener { querySnapshot, error in
                        if let documents = querySnapshot?.documents {
                            Firebase.sharedInstance.arrMeeting = []
                            for document in documents {
                                let value = document.data()
                                let descMeeting = value["Descripcion Cita"] as? String ?? ""
                                let nameDocMeeting = value["Nombre Doctor Completo"] as? String ?? ""
                                let namePatMeeting = value["Nombre Paciente Completo"] as? String ?? ""
                                let dateMeeting = value["Fecha Cita"] as? String ?? ""
                                let siteMeeting = value["Sala Cita"] as? String ?? ""
                                let meeting = Meeting()
                                meeting.sNombreDoctorCompleto = nameDocMeeting
                                meeting.sNombrePacienteCompleto = namePatMeeting
                                meeting.sDescripcionCita = descMeeting
                                meeting.sSalaCita = siteMeeting
                                meeting.sFechaCita = dateMeeting
                                Firebase.sharedInstance.arrMeeting.append(meeting)
                                
                                print("\(document.documentID) => \(document.data())")
                            }
                            completion(Firebase.sharedInstance.arrMeeting)
                        }
                        })!
                }
            case .patient:
                if let userADR = user {
                    listenerMeeting = (Firebase.sharedInstance.firStoreDB?.collection("Pacientes").document(userADR.uid).collection("Citas").addSnapshotListener { querySnapshot, error in
                        if let documents = querySnapshot?.documents {
                            Firebase.sharedInstance.arrMeeting = []
                            for document in documents {
                                let value = document.data()
                                let descMeeting = value["Descripcion Cita"] as? String ?? ""
                                let nameDocMeeting = value["Nombre Doctor Completo"] as? String ?? ""
                                let namePatMeeting = value["Nombre Paciente Completo"] as? String ?? ""
                                let dateMeeting = value["Fecha Cita"] as? String ?? ""
                                let siteMeeting = value["Sala Cita"] as? String ?? ""
                                let meeting = Meeting()
                                meeting.sNombreDoctorCompleto = nameDocMeeting
                                meeting.sNombrePacienteCompleto = namePatMeeting
                                meeting.sDescripcionCita = descMeeting
                                meeting.sSalaCita = siteMeeting
                                meeting.sFechaCita = dateMeeting
                                Firebase.sharedInstance.arrMeeting.append(meeting)
                                
                                print("\(document.documentID) => \(document.data())")
                            }
                            completion(Firebase.sharedInstance.arrMeeting)
                        }
                        })!
                }
            }
        }
        return listenerMeeting
    }
    
    func knowTypeOfUserAutoLogging(completion:@escaping (TypeUser)->Void) {
        Firebase.sharedInstance.firStoreDB?.collection("Doctores").addSnapshotListener { querySnapshot, error in
            if let documents = querySnapshot?.documents {
                for document in documents {
                    if document.documentID == Auth.auth().currentUser?.uid {
                        Firebase.sharedInstance.doctor.setMap(valores:(document.data()))
                        ContainerNavigationController.userType = .doctor
                        if let typeUser = ContainerNavigationController.userType {
                            completion(typeUser)
                        }
                    }
                }
            }
        }
        Firebase.sharedInstance.firStoreDB?.collection("Pacientes").addSnapshotListener { querySnapshot, error in
            if let documents = querySnapshot?.documents {
                for document in documents {
                    if document.documentID == Auth.auth().currentUser?.uid {
                        Firebase.sharedInstance.patient.setMap(valores:(document.data()))
                        ContainerNavigationController.userType = .patient
                        if let typeUser = ContainerNavigationController.userType {
                            completion(typeUser)
                        }
                    }
                }
            }
        }
    }
    
    
    
    func getNameDoctorsOrPatients(completion:@escaping ([String])->Void) {
        var arrNameDorP: [String] = []
        if let typeUser = ContainerNavigationController.userType {
            switch typeUser {
            case .doctor:
                Firebase.sharedInstance.firStoreDB?.collection("Pacientes").addSnapshotListener { querySnapshot, error in
                    if let documents = querySnapshot?.documents {
                        for document in documents {
                            let value = document.data()
                            let namePatMeeting = value["Nombre Completo"] as? String ?? ""
                            arrNameDorP.append(namePatMeeting)
                                
                            print("\(document.documentID) => \(document.data())")
                        }
                        completion(arrNameDorP)
                    }
                }
            case .patient:
                Firebase.sharedInstance.firStoreDB?.collection("Doctores").addSnapshotListener { querySnapshot, error in
                    if let documents = querySnapshot?.documents {
                        for document in documents {
                            let value = document.data()
                            let nameDocMeeting = value["Nombre Completo"] as? String ?? ""
                            arrNameDorP.append(nameDocMeeting)
                            
                            print("\(document.documentID) => \(document.data())")
                        }
                        completion(arrNameDorP)
                    }
                }
            }
        }
    }
    
    func addMeeting() {
        if let typeUser = ContainerNavigationController.userType {
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            switch typeUser {
            case .doctor:
                if let userADR = user {
                    Firebase.sharedInstance.firStoreDB?.collection("Doctores").document(userADR.uid).collection("Citas").document(format.string(from: date)).setData(Firebase.sharedInstance.meeting.getMap())
                    print("Añade cita en doctor " + userADR.email!)
                    Firebase.sharedInstance.firStoreDB?.collection("Pacientes").addSnapshotListener { querySnapshot, error in
                        if let documents = querySnapshot?.documents {
                            for document in documents {
                                let value = document.data()
                                let namePat = value["Nombre Completo"] as? String ?? ""
                                if namePat == Firebase.sharedInstance.meeting.sNombrePacienteCompleto{
                                    Firebase.sharedInstance.firStoreDB?.collection("Pacientes").document(document.documentID).collection("Citas").document(format.string(from: date)).setData(Firebase.sharedInstance.meeting.getMap())
                                }
                                
                                print("\(document.documentID) => \(document.data())")
                            }
                        }
                    }
                }
            case .patient:
                if let userADR = user {
                    Firebase.sharedInstance.firStoreDB?.collection("Pacientes").document(userADR.uid).collection("Citas").document(format.string(from: date)).setData(Firebase.sharedInstance.meeting.getMap())
                    print("Añade cita en paciente " + userADR.email!)
                    Firebase.sharedInstance.firStoreDB?.collection("Doctores").addSnapshotListener { querySnapshot, error in
                        if let documents = querySnapshot?.documents {
                            for document in documents {
                                let value = document.data()
                                let nameDoc = value["Nombre Completo"] as? String ?? ""
                                if nameDoc == Firebase.sharedInstance.meeting.sNombreDoctorCompleto{
                                    Firebase.sharedInstance.firStoreDB?.collection("Doctores").document(document.documentID).collection("Citas").document(format.string(from: date)).setData(Firebase.sharedInstance.meeting.getMap())
                                }
                                print("\(document.documentID) => \(document.data())")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addContact() {
        if let typeUser = ContainerNavigationController.userType {
            let idColection:String = UUID().uuidString
            switch typeUser {
            case .doctor:
                if let userADR = user {
                Firebase.sharedInstance.firStoreDB?.collection("Doctores").document(userADR.uid).collection("Contactos").document(idColection).setData(Firebase.sharedInstance.contact.getMap())
                    print("Añade contacto en doctor " + userADR.email!)
                    Firebase.sharedInstance.firStoreDB?.collection("Pacientes").addSnapshotListener { querySnapshot, error in
                        if let documents = querySnapshot?.documents {
                            for document in documents {
                                let value = document.data()
                                let gmailCont = value["Gmail"] as? String ?? ""
                                if gmailCont == Firebase.sharedInstance.contact.sGmailContacto {
                                    let uidContact = self.checkUidOfGmail()
                                    //Firebase.sharedInstance.contact.sContactoID = uidContact
                                    Firebase.sharedInstance.contact.sContactoID = userADR.uid
                                    Firebase.sharedInstance.contact.sGmailContacto = userADR.email
                                Firebase.sharedInstance.firStoreDB?.collection("Pacientes").document(uidContact).collection("Contactos").document(idColection).setData(Firebase.sharedInstance.contact.getMap())
                                }
                                
                                print("\(document.documentID) => \(document.data())")
                            }
                        }
                    }
                }
            case .patient:
                if let userADR = user {
                Firebase.sharedInstance.firStoreDB?.collection("Pacientes").document(userADR.uid).collection("Contactos").document(idColection).setData(Firebase.sharedInstance.contact.getMap())
                    print("Añade contacto en paciente " + userADR.email!)
                    Firebase.sharedInstance.firStoreDB?.collection("Doctores").addSnapshotListener { querySnapshot, error in
                        if let documents = querySnapshot?.documents {
                            for document in documents {
                                let value = document.data()
                                let gmailCont = value["Gmail"] as? String ?? ""
                                if gmailCont == Firebase.sharedInstance.contact.sGmailContacto {
                                    let uidContact = self.checkUidOfGmail()
                                    //Firebase.sharedInstance.contact.sContactoID = uidContact
                                    Firebase.sharedInstance.contact.sContactoID = userADR.uid
                                    Firebase.sharedInstance.contact.sGmailContacto = userADR.email
                                Firebase.sharedInstance.firStoreDB?.collection("Doctores").document(uidContact).collection("Contactos").document(idColection).setData(Firebase.sharedInstance.contact.getMap())
                                }
                                
                                print("\(document.documentID) => \(document.data())")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getGmailDoctorsOrPatients(completion:@escaping ([String])->Void) {
        var arrGmailDorPat: [String] = []
        if let typeUser = ContainerNavigationController.userType {
            switch typeUser {
            case .doctor:
                Firebase.sharedInstance.firStoreDB?.collection("Pacientes").addSnapshotListener { querySnapshot, error in
                    if let documents = querySnapshot?.documents {
                        for document in documents {
                            let value = document.data()
                            let gmailPat = value["Gmail"] as? String ?? ""
                            arrGmailDorPat.append(gmailPat)
                            
                            print("\(document.documentID) => \(document.data())")
                        }
                        completion(arrGmailDorPat)
                    }
                }
            case .patient:
                Firebase.sharedInstance.firStoreDB?.collection("Doctores").addSnapshotListener { querySnapshot, error in
                    if let documents = querySnapshot?.documents {
                        for document in documents {
                            let value = document.data()
                            let gmailDoc = value["Gmail"] as? String ?? ""
                            arrGmailDorPat.append(gmailDoc)
                            
                            print("\(document.documentID) => \(document.data())")
                        }
                        completion(arrGmailDorPat)
                    }
                }
            }
        }
    }
    
    func checkUidOfGmail() -> String {
        var uidContact = ""
        if let typeUser = ContainerNavigationController.userType {
            switch typeUser {
                case .doctor:
                    Firebase.sharedInstance.firStoreDB?.collection("Pacientes").addSnapshotListener { querySnapshot, error in
                        if let documents = querySnapshot?.documents {
                            for document in documents {
                                let value = document.data()
                                if value["Gmail"] as? String ?? "" == Firebase.sharedInstance.contact.sGmailContacto {
                                    uidContact = document.documentID
                                }
                            }
                        }
                    }
                case .patient:
                    Firebase.sharedInstance.firStoreDB?.collection("Doctores").addSnapshotListener { querySnapshot, error in
                        if let documents = querySnapshot?.documents {
                            for document in documents {
                                let value = document.data()
                                if value["Gmail"] as? String ?? "" == Firebase.sharedInstance.contact.sGmailContacto {
                                    uidContact = document.documentID
                                }
                            }
                        }
                    }
            }
        }
        return uidContact
    }
    
    func getContacts(completion:@escaping ([Contact])->Void) -> ListenerRegistration? {
        var listenerContact: ListenerRegistration? = nil
        if let typeUser = ContainerNavigationController.userType {
            switch typeUser {
            case .doctor:
                if let userADR = user {
                    listenerContact =  (Firebase.sharedInstance.firStoreDB?.collection("Doctores").document(userADR.uid).collection("Contactos").addSnapshotListener { querySnapshot, error in
                        if let documents = querySnapshot?.documents {
                            Firebase.sharedInstance.arrContacts = []
                            for document in documents {
                                let value = document.data()
                                let idContact = value["ID Contacto"] as? String ?? ""
                                let gmailContact = value["Gmail Contacto"] as? String ?? ""
                                let contact = Contact()
                                contact.sContactoID = idContact
                                contact.sGmailContacto = gmailContact
                                Firebase.sharedInstance.arrContacts.append(contact)
                                
                                print("\(document.documentID) => \(document.data())")
                            }
                            completion(Firebase.sharedInstance.arrContacts)
                        }
                        })!
                }
            case .patient:
                if let userADR = user {
                    listenerContact = (Firebase.sharedInstance.firStoreDB?.collection("Pacientes").document(userADR.uid).collection("Contactos").addSnapshotListener { querySnapshot, error in
                        if let documents = querySnapshot?.documents {
                            Firebase.sharedInstance.arrContacts = []
                            for document in documents {
                                let value = document.data()
                                let idContact = value["ID Contacto"] as? String ?? ""
                                let gmailContact = value["Gmail Contacto"] as? String ?? ""
                                let contact = Contact()
                                contact.sContactoID = idContact
                                contact.sGmailContacto = gmailContact
                                Firebase.sharedInstance.arrContacts.append(contact)
                                
                                print("\(document.documentID) => \(document.data())")
                            }
                            completion(Firebase.sharedInstance.arrContacts)
                        }
                        })!
                }
            }
        }
        return listenerContact
    }
}
