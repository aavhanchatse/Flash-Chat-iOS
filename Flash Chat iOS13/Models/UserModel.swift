struct UserModel {
    let phoneNumber, email: String?
    let uid: String

    init(phoneNumber: String?, email: String?, uid: String) {
        self.phoneNumber = phoneNumber
        self.email = email
        self.uid = uid
    }
}
