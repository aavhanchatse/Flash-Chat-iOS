//
//  Message.swift
//  Flash Chat iOS13
//
//  Created by Aavhan Chatse on 11/09/24.
//  Copyright © 2024 Angela Yu. All rights reserved.
//
import UIKit

struct Message {
    let messageBody: String?
    let sendersId: String
    let receiversId: String
    let fileUrl: String?
    let fileType: String?
    let extensionString: String?
    let replyMessageBody: String?
    let replyMessageSenderId: String?
    let isDeleted: Bool?
    let random: String
    let sentAt: String
}
