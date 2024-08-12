import LocalAuthentication

protocol FaceIDServiceable {
    func isFaceIDSupported() -> Bool
    func authenticateWithFaceID(completion: @escaping (Bool, Error?) -> Void)
    func toggleFaceID(enabled: Bool) -> Bool
}

class FaceIDServiceImplement: FaceIDServiceable {

    func isFaceIDSupported() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        && (context.biometryType == .faceID)
    }

    func authenticateWithFaceID(completion: @escaping (Bool, Error?) -> Void) {
        guard isFaceIDSupported() else {
            completion(false, nil)
            return
        }
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Face ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: completion)
        } else {
            completion(false, nil)
        }
    }

    func toggleFaceID(enabled: Bool) -> Bool {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error), context.biometryType == .faceID {
            return context.setCredential(enabled ? NSData() as Data : nil, type: .applicationPassword)
        }
        return false
    }
}


