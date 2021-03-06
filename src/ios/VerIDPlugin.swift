import UIKit
import VerIDCore
import VerIDUI

@objc(VerIDPlugin) public class VerIDPlugin: CDVPlugin, VerIDFactoryDelegate, VerIDSessionDelegate {
    
    private var veridSessionCallbackId: String?
    private var verid: VerID?
    
    @objc public func load(_ command: CDVInvokedUrlCommand) {
        self.loadVerID(command) { _ in
            self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
        }
    }
    
    @objc public func unload(_ command: CDVInvokedUrlCommand) {
        self.verid = nil
        self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
    }
    
    @objc public func registerUser(_ command: CDVInvokedUrlCommand) {
        do {
            let settings: RegistrationSessionSettings = try self.createSettings(command.arguments)
            self.startSession(command: command, settings: settings)
        } catch {
            self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
        }
    }
    
    @objc public func authenticate(_ command: CDVInvokedUrlCommand) {
        do {
            let settings: AuthenticationSessionSettings = try self.createSettings(command.arguments)
            self.startSession(command: command, settings: settings)
        } catch {
            self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
        }
    }
    
    @objc public func captureLiveFace(_ command: CDVInvokedUrlCommand) {
        do {
            let settings: LivenessDetectionSessionSettings = try self.createSettings(command.arguments)
            self.startSession(command: command, settings: settings)
        } catch {
            self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
        }
    }
    
    @objc public func getRegisteredUsers(_ command: CDVInvokedUrlCommand) {
        self.loadVerID(command) { verid in
            var err: String = "Unknown error"
            do {
                let users = try verid.userManagement.users()
                if let usersString = String(data: try JSONEncoder().encode(users), encoding: .utf8) {
                    let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: usersString)
                    self.commandDelegate.send(result, callbackId: command.callbackId)
                    return
                } else {
                    err = "Failed to encode JSON as UTF-8 string"
                }
            } catch {
                err = error.localizedDescription
            }
            self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: err), callbackId: command.callbackId)
        }
    }
    
    @objc public func deleteUser(_ command: CDVInvokedUrlCommand) {
        if let userId = command.arguments?.compactMap({ ($0 as? [String:String])?["userId"] }).first {
            self.loadVerID(command) { verid in
                verid.userManagement.deleteUsers([userId]) { error in
                    if let err = error {
                        self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: err.localizedDescription), callbackId: command.callbackId)
                        return
                    }
                    let result = CDVPluginResult(status: CDVCommandStatus_OK)
                    self.commandDelegate.send(result, callbackId: command.callbackId)
                }
            }
        } else {
            self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Unable to parse userId argument"), callbackId: command.callbackId)
        }
    }

    @objc public func compareFaces(_ command: CDVInvokedUrlCommand) {
        if let t1 = command.arguments?.compactMap({ ($0 as? [String:String])?["face1"] }).first?.data(using: .utf8), let t2 = command.arguments?.compactMap({ ($0 as? [String:String])?["face2"] }).first?.data(using: .utf8) {
            self.loadVerID(command) { verid in
                self.commandDelegate.run {
                    do {
                        let template1 = try JSONDecoder().decode(RecognitionFace.self, from: t1)
                        let template2 = try JSONDecoder().decode(RecognitionFace.self, from: t2)
                        let score = try verid.faceRecognition.compareSubjectFaces([template1], toFaces: [template2]).floatValue
                        DispatchQueue.main.async {
                            let message: [String:Any] = ["score":score,"threshold":verid.faceRecognition.authenticationScoreThreshold.floatValue,"max":verid.faceRecognition.maxAuthenticationScore.floatValue];
                            self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_OK, messageAs: message), callbackId: command.callbackId)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Unable to parse template1 and/or template2 arguments"), callbackId: command.callbackId)
            }
        }
    }
    
    @objc public func detectFaceInImage(_ command: CDVInvokedUrlCommand) {
        self.loadVerID(command) { verid in
            self.commandDelegate.run(inBackground: {
                do {
                    guard let imageString = command.arguments?.compactMap({ ($0 as? [String:String])?["image"] }).first else {
                        throw VerIDPluginError.invalidArgument
                    }
                    guard imageString.starts(with: "data:image/"), let mimeTypeEndIndex = imageString.firstIndex(of: ";"), let commaIndex = imageString.firstIndex(of: ",") else {
                        throw VerIDPluginError.invalidArgument
                    }
                    let dataIndex = imageString.index(commaIndex, offsetBy: 1)
                    guard String(imageString[mimeTypeEndIndex..<imageString.index(mimeTypeEndIndex, offsetBy: 7)]) == ";base64" else {
                        throw VerIDPluginError.invalidArgument
                    }
                    guard let data = Data(base64Encoded: String(imageString[dataIndex...])) else {
                        throw VerIDPluginError.invalidArgument
                    }
                    guard let image = UIImage(data: data), let cgImage = image.cgImage else {
                        throw VerIDPluginError.invalidArgument
                    }
                    let orientation: CGImagePropertyOrientation
                    switch image.imageOrientation {
                    case .up:
                        orientation = .up
                    case .down:
                        orientation = .down
                    case .left:
                        orientation = .left
                    case .right:
                        orientation = .right
                    case .upMirrored:
                        orientation = .upMirrored
                    case .downMirrored:
                        orientation = .downMirrored
                    case .leftMirrored:
                        orientation = .leftMirrored
                    case .rightMirrored:
                        orientation = .rightMirrored
                    @unknown default:
                        orientation = .up
                    }
                    let veridImage = VerIDImage(cgImage: cgImage, orientation: orientation)
                    let faces = try verid.faceDetection.detectFacesInImage(veridImage, limit: 1, options: 0)
                    guard let recognizableFace = try verid.faceRecognition.createRecognizableFacesFromFaces(faces, inImage: veridImage).first else {
                        throw VerIDPluginError.faceTemplateExtractionError
                    }
                    let recognitionFace = RecognitionFace(recognitionData: recognizableFace.recognitionData)
                    guard let encodedFace = String(data: try JSONEncoder().encode(recognitionFace), encoding: .utf8) else {
                        throw VerIDPluginError.encodingError
                    }
                    DispatchQueue.main.async {
                        self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_OK, messageAs: encodedFace), callbackId: command.callbackId)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
                    }
                }
            })
        }
    }
    
    // MARK: - VerID Session Delegate
    
    public func session(_ session: VerIDSession, didFinishWithResult result: VerIDSessionResult) {
        guard let callbackId = self.veridSessionCallbackId, !callbackId.isEmpty else {
            return
        }
        self.veridSessionCallbackId = nil
        self.commandDelegate.run {
            var err = "Unknown error"
            do {
                if let message = String(data: try JSONEncoder().encode(result), encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_OK, messageAs: message), callbackId: callbackId)
                    }
                    return
                } else {
                    err = "Unabe to encode JSON as UTF-8 string"
                }
            } catch {
                err = error.localizedDescription
            }
            DispatchQueue.main.async {
                self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: err), callbackId: callbackId)
            }
        }
    }
    
    public func sessionWasCanceled(_ session: VerIDSession) {
        guard let callbackId = self.veridSessionCallbackId else {
            return
        }
        self.veridSessionCallbackId = nil
        self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: callbackId)
    }
    
    
    // MARK: - Session helpers
    
    private func createSettings<T: VerIDSessionSettings>(_ args: [Any]?) throws -> T {
        guard let string = args?.compactMap({ ($0 as? [String:String])?["settings"] }).first, let data = string.data(using: .utf8) else {
            NSLog("Unable to parse settings")
            throw VerIDPluginError.parsingError
        }
        let settings: T = try JSONDecoder().decode(T.self, from: data)
        NSLog("Decoded settings %@ from %@", String(describing: T.self), string)
        return settings
    }
    
    private func defaultSettings<T: VerIDSessionSettings>() -> T {
        switch T.self {
        case is RegistrationSessionSettings.Type:
            return RegistrationSessionSettings(userId: "default") as! T
        case is AuthenticationSessionSettings.Type:
            return AuthenticationSessionSettings(userId: "default") as! T
        case is LivenessDetectionSessionSettings.Type:
            return LivenessDetectionSessionSettings() as! T
        default:
            return VerIDSessionSettings() as! T
        }
    }
    
    private func startSession<T: VerIDSessionSettings>(command: CDVInvokedUrlCommand, settings: T) {
        guard self.veridSessionCallbackId == nil || self.veridSessionCallbackId!.isEmpty else {
            self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_ERROR), callbackId: command.callbackId)
            return
        }
        self.loadVerID(command) { verid in
            self.veridSessionCallbackId = command.callbackId
            let session = VerIDSession(environment: verid, settings: settings)
            session.delegate = self
            session.start()
        }
    }
    
    func loadVerID(_ command: CDVInvokedUrlCommand, callback: @escaping (VerID) -> Void) {
        if let verid = self.verid {
            callback(verid)
            return
        }
        self.veridSessionCallbackId = command.callbackId
        let veridFactory = VerIDFactory()
        if let apiSecret = command.arguments?.compactMap({ ($0 as? [String:String])?["apiSecret"] }).first {
            let detRecLibFactory = VerIDFaceDetectionRecognitionFactory(apiSecret: apiSecret)
            veridFactory.faceDetectionFactory = detRecLibFactory
            veridFactory.faceRecognitionFactory = detRecLibFactory
        }
        veridFactory.delegate = self
        veridFactory.createVerID { instance in
            self.veridSessionCallbackId = nil
            self.verid = instance
            callback(instance)
        }
    }
    
    public func veridFactory(_ factory: VerIDFactory, didFailWithError error: Error) {
        if let callbackId = self.veridSessionCallbackId {
            self.veridSessionCallbackId = nil
            self.verid = nil
            self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: callbackId)
        }
    }
}

public enum VerIDPluginError: Int, Error {
    case parsingError, invalidArgument, encodingError, faceTemplateExtractionError
}