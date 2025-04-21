//
//  AppDelegate.swift
//  Artbook
//
//  Created by Esra Arı on 15.04.2025.
//

import UIKit
import CoreData

class detailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var commentText: UITextView!
    
    var chosenPaintingId : UUID?
    var chosenPainting : Paintings?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImg))
        imgView.addGestureRecognizer(gestureRecognizer)
        //Navigation Bar a save butonu ekleyelim
        if chosenPaintingId == nil{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.done, target: self, action: #selector(saveButtonClicked))
            
        }
        // formu doldurmadan save etme
        navigationItem.rightBarButtonItem?.isEnabled = false
        nameText.addTarget(self, action: #selector(textFieldsDidChange), for: UIControl.Event.editingChanged)
        artistText.addTarget(self, action: #selector(textFieldsDidChange), for: UIControl.Event.editingChanged)
     
        if let painting = chosenPainting {
            nameText.text = painting.name
            artistText.text = painting.artist
            commentText.text = painting.comment
            if let imgData = painting.img{
                imgView.image = UIImage(data: imgData)
            }
            
            //ayrıntıları gösterirken save butonunu gizle
            navigationItem.rightBarButtonItem = nil
            imgView.isUserInteractionEnabled = false
            nameText.isUserInteractionEnabled = false
            artistText.isUserInteractionEnabled = false
            commentText.isEditable = false
        }
        
    }
    @objc func selectImg(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker,animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imgView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    @objc func textFieldsDidChange(){
        let isFormValid = !(nameText.text?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty ?? true) && !(artistText.text?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty ?? true)
        navigationItem.rightBarButtonItem?.isEnabled  = isFormValid
    }
    @objc func saveButtonClicked(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        newPainting.setValue(nameText.text, forKey: "name")
        newPainting.setValue(artistText.text, forKey: "artist")
        newPainting.setValue(commentText.text, forKey: "comment")
        newPainting.setValue(UUID(), forKey: "id")
        if let imgData = imgView.image?.jpegData(compressionQuality: 0.5){
            newPainting.setValue(imgData, forKey: "img")
        }
        do{
            try context.save()
            print("Success")
        }catch{
            print("Error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        navigationController?.popViewController(animated: true)
        
        
    }
}
