//
//  RecordViewController.swift
//  HydroSoft
//
//  Created by Filip Kment on 01.06.18.
//  Copyright © 2018 Filip Kment. All rights reserved.
//

import UIKit
import ImagePicker


enum Showing: Int { case new, record}

enum RecordCellsEnum: Int { case name, date, note, image,save, success}
enum NewRecordCellsEnum: Int { case name, date, note, takeImage, save }

var PostToSend = Post(name: "...", imageName: "", note: "...", image: #imageLiteral(resourceName: "image"), uploaded: false)

protocol RecordVCProtocol {
    func saved(post: Post)
    func edited(post: Post)
    func saveAndSend(post: Post)
}

class RecordViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var post : Post?
    
    var dataSource = [Any]()
    
    var showing : Showing = .record
    
    var expandingCellHeight: CGFloat = 27

    var delegate : RecordVCProtocol?
    
    var imagePickerController = ImagePickerController()
    
    var selectedImage : UIImage?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        if post == nil {
            setupNewRecord()
            PostToSend = Post(name: "...", imageName: "", note: "...", image: #imageLiteral(resourceName: "image"), uploaded: false)
        } else {
            PostToSend = post!
            setupRecord()
            title = post!.name
        }
        
    }
    
    
    
    func setupNewRecord() {
        showing = .new
        tableView.reloadData()
    }
    
    func setupRecord() {
        showing = .record
        tableView.reloadData()
        
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        
        tableView.register(BasicCell.self)
        tableView.register(ImageCell.self)
        tableView.register(SelectImageCell.self)
        tableView.register(SaveCells.self)
        tableView.register(SaveSendCell.self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    

}
    extension RecordViewController: UITableViewDelegate,UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            switch showing {
            case .new:
                return 5
            case .record:
                return 6
            }
            
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            switch showing {
            case .new:
                if let section = NewRecordCellsEnum(rawValue: indexPath.section) {
                    switch section {
                    case .name:
                        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BasicCell
                        cell.configureCell(title: "Name", value: PostToSend.name, indexPath: indexPath)
                        cell.delegate = self
                        return cell
                    case .date:
                        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BasicCell
                        cell.configureCell(title: "Datum", value: Date().toString(), indexPath: indexPath)
                        cell.delegate = self
                        return cell
                    case .note:
                        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BasicCell
                        cell.configureCell(title: "Poznámka", value: PostToSend.note, indexPath: indexPath)
                        cell.delegate = self
                        return cell
                    case .takeImage:
                        if selectedImage != nil {
                            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ImageCell
                            cell.configureCell(post: PostToSend)
                            return cell
                        } else {
                            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SelectImageCell
                            cell.delegate = self
                            return cell
                        }
                           case .save:
                        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SaveCells
                        return cell
                    }
                }
            case .record:
                if let post = post {
                    if let section = RecordCellsEnum(rawValue: indexPath.section) {
                        switch section {
                        case .name:
                            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BasicCell
                            cell.configureCell(title: "Name", value: post.name, indexPath: indexPath)
                            return cell
                        case .date:
                            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BasicCell
                            cell.configureCell(title: "Datum", value: post.stringDate, indexPath: indexPath)
                            return cell
                        case .note:
                            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BasicCell
                            cell.configureCell(title: "Poznámka", value: post.note, indexPath: indexPath)
                            return cell
                        case .image:
                            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ImageCell
                            cell.configureCell(post: post)
                            return cell
                        case .save:
                            if post.uploaded {
                                return UITableViewCell()
                            } else {
                                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SaveCells
                                return cell
                            }
                        case .success:
                            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SaveSendCell
                            cell.confgiureCell(post: post)
                            return cell
                        }
                    }
                }
            }
            return UITableViewCell()
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch showing {
            case .new:
                if let section = NewRecordCellsEnum(rawValue: indexPath.section) {
                    switch section {
                    case .takeImage:
                        //                return self.view.frame.size.width
                        return 120
                    default:
                        return UITableViewAutomaticDimension
                    }
                } else {
                    return 0
                }
            case .record:
                if let section = RecordCellsEnum(rawValue: indexPath.section) {
                    switch section {
                    case .image:
//                        return self.view.frame.size.width
                        return 250.0
                    case .success:
                        if let post = post {
                            if post.uploaded {
                                return 100
                            } else {
                                return 45
                            }
                        } else {
                            return 0
                        }
                    case .save:
                        if let post = post {
                            if !post.uploaded {
                                return UITableViewAutomaticDimension
                            } else {
                                return 0
                            }
                        } else {
                            return 0
                        }
                    default:
                        return UITableViewAutomaticDimension
                    }
                } else {
                    return 0
                }
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if tableView.cellForRow(at: indexPath) is SaveCells {
                if let post = post {
                    post.name = "\(PostToSend.name).jpg"
                    post.note = PostToSend.note
                    delegate?.edited(post: post)
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    let toSend = Post(name: "\(PostToSend.name).jpg", imageName: PostToSend.imageName, note: PostToSend.note, image: PostToSend.image, uploaded: false)
                    delegate?.saved(post: toSend)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            
            if tableView.cellForRow(at: indexPath) is SaveSendCell {
                if let post = post {
                    post.name = PostToSend.name
                    post.note = PostToSend.note
                    delegate?.saveAndSend(post: post)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }

}

extension RecordViewController : ImageCellProtocol {
    func takePhoto() {
        var configuration = Configuration()
        configuration.doneButtonTitle = "Finish"
        configuration.noImagesTitle = "Sorry! There are no images here!"
        configuration.recordLocation = false
        
        imagePickerController = ImagePickerController(configuration: configuration)

        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension RecordViewController : ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.expandGalleryView()
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        if let first = images.first {
            PostToSend.image = first
            selectedImage = first
            tableView.reloadData()
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)

    }
    
    
}

extension RecordViewController: ExpandingCellDelegate {
    func updated(height: CGFloat, indexPath: IndexPath) {
        expandingCellHeight = height
        
        // Disabling animations gives us our desired behaviour
        UIView.setAnimationsEnabled(false)
        /* These will causes table cell heights to be recaluclated,
         without reloading the entire cell */
        tableView.beginUpdates()
        tableView.endUpdates()
        // Re-enable animations
        UIView.setAnimationsEnabled(true)
        
        
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
}

fileprivate extension RecordViewController {
    
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo,
            let keyBoardValueBegin = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let keyBoardValueEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, keyBoardValueBegin != keyBoardValueEnd else {
                return
        }
        
        let keyboardHeight = keyBoardValueEnd.height
        
        tableView.contentInset.bottom = keyboardHeight
    }
}




