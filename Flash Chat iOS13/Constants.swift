enum K {
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCellTableViewCell"
    static let userCellIdentifier = "ReusableUserCell"
    
    static let registerSegue = "RegisterToUserList"
    static let loginSegue = "LoginToUserList"
    static let sendOtpSegue = "SendOtp"
    static let otpToUserListSegue = "OtpToUserList"
    static let chatSegue = "NavigateToChat"
    
    static let appName = "⚡️FlashChat"
    static let email = "email"
    static let phoneNumber = "phoneNumber"
    static let uid = "uid"
    static let users = "Users"
    
    enum BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    enum FStore {
        static let messagesCollectionName = "messages"
        static let usersCollectionName = "users"
        static let chatsCollectionName = "chats"
        
        static let messageBody = "messageBody"
        static let sendersId = "sendersId"
        static let receiversId = "receiversId"
        static let fileUrl = "fileUrl"
        static let fileType = "fileType"
        static let extensionString = "extensionString"
        static let replyMessageBody = "replyMessageBody"
        static let replyMessageSenderId = "replyMessageSenderId"
        static let isDeleted = "isDeleted"
        static let random = "random"
        static let sentAt = "sentAt"
        static let userIds = "userIds"
    }
}
