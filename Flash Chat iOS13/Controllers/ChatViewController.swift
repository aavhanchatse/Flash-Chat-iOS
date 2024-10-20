//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

class ChatViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageTextfield: UITextField!

    var currentUser: User?
    var selectedUser: UserModel?
    var chatId: String = ""

    let db = Firestore.firestore()

    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)

        title = selectedUser?.phoneNumber != nil ? selectedUser?.phoneNumber : selectedUser?.email != nil ? selectedUser?.email : selectedUser?.uid

        setCurrentUser()
        setChatId()
        loadChats()
    }

    func setCurrentUser() {
        if let user = Auth.auth().currentUser {
            currentUser = user
        }
    }

    func setChatId() {
        let currentUserId = currentUser?.uid.hash
        let selectedUserId = selectedUser?.uid.hash

        let smallest = min(currentUserId ?? 0, selectedUserId ?? 0)
        let largest = max(currentUserId ?? 0, selectedUserId ?? 0)

        chatId = "\(smallest)_\(largest)"
    }

    func loadChats() {
        do {
            db.collection(K.FStore.chatsCollectionName)
                .document(chatId)
                .collection(K.FStore.messagesCollectionName)
                .order(by: K.FStore.sentAt, descending: false)
                .addSnapshotListener { snapshot, error in
                    self.messages = []

                    if let e = error {
                        print("Error getting documents: \(e)")
                    } else {
                        if let snapshotDocuments = snapshot?.documents {
                            print("snapshotDocs length : \(snapshotDocuments.count)")

                            for doc in snapshotDocuments {
                                let data = doc.data()

                                let message = Message(messageBody: data[K.FStore.messageBody] as? String, sendersId: data[K.FStore.sendersId] as! String, receiversId: data[K.FStore.receiversId] as! String, fileUrl: data[K.FStore.fileUrl] as? String, fileType: data[K.FStore.fileType] as? String, extensionString: data[K.FStore.extensionString] as? String, replyMessageBody: data[K.FStore.replyMessageBody] as? String, replyMessageSenderId: data[K.FStore.replyMessageSenderId] as? String, isDeleted: data[K.FStore.isDeleted] as? Bool, random: data[K.FStore.random] as! String, sentAt: data[K.FStore.sentAt] as! String)

                                self.messages.append(message)

                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }

        } catch {
            print("Error getting documents: \(error)")
        }
    }

    @IBAction func sendPressed(_ sender: UIButton) {
        let m = messageTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        if m!.isEmpty {
            return
        }

        let currentDateTime = Date()

        let message = Message(messageBody: messageTextfield.text, sendersId: currentUser!.uid, receiversId: selectedUser!.uid, fileUrl: nil, fileType: nil, extensionString: nil, replyMessageBody: nil, replyMessageSenderId: nil, isDeleted: nil, random: randomString(length: 8), sentAt: currentDateTime.description)

        do {
            try db.collection(K.FStore.chatsCollectionName).document(chatId).collection(K.FStore.messagesCollectionName)
                .document(message.sentAt)
                .setData([
                    K.FStore.messageBody: message.messageBody,
                    K.FStore.sendersId: message.sendersId,
                    K.FStore.receiversId: message.receiversId,
                    K.FStore.fileUrl: message.fileUrl,
                    K.FStore.fileType: message.fileType,
                    K.FStore.extensionString: message.extensionString,
                    K.FStore.replyMessageBody: message.replyMessageBody,
                    K.FStore.replyMessageSenderId: message.replyMessageSenderId,
                    K.FStore.isDeleted: message.isDeleted,
                    K.FStore.random: message.random,
                    K.FStore.sentAt: message.sentAt,
                ])

        } catch {
            print("Error adding document: \(error)")
        }

        do {
            let sUser = selectedUser?.phoneNumber != nil ? selectedUser?.phoneNumber : selectedUser?.email != nil ? selectedUser?.email : selectedUser?.uid

            let cUser = currentUser?.phoneNumber != nil ? currentUser?.phoneNumber : currentUser?.email != nil ? currentUser?.email : currentUser?.uid

            try db.collection(K.FStore.chatsCollectionName).document(chatId)
                .setData([
                    K.FStore.messageBody: message.messageBody,
                    K.FStore.sendersId: message.sendersId,
                    K.FStore.receiversId: message.receiversId,
                    K.FStore.fileUrl: message.fileUrl,
                    K.FStore.fileType: message.fileType,
                    K.FStore.extensionString: message.extensionString,
                    K.FStore.replyMessageBody: message.replyMessageBody,
                    K.FStore.replyMessageSenderId: message.replyMessageSenderId,
                    K.FStore.isDeleted: message.isDeleted,
                    K.FStore.random: message.random,
                    K.FStore.sentAt: message.sentAt,
                    K.FStore.userIds: [sUser, cUser],

                ])

        } catch {
            print("Error adding document: \(error)")
        }

        messageTextfield.text = ""
    }

    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).map { _ in letters.randomElement()! })
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]

        let cell: MessageCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCellTableViewCell

        cell.label?.text = message.messageBody

        if message.sendersId == currentUser?.uid {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }

        return cell
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
