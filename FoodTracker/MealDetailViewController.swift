//
//  ViewController.swift
//  FoodTracker
//
//  Created by takashimakenichi on 2020/12/30.
//  Copyright © 2020 takashimakenichi. All rights reserved.
//

import UIKit

class MealDetailViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
    }


    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        // imageViewタップ前にtextField編集中だった場合にキーボードが出ているため
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        // 右辺は列挙型:UIImagePickerControllerSourceType.photoLibraryの省略
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        // ユーザーが画像選択時に通知を受ける
        imagePickerController.delegate = self
        // viewControllerのメソッド
        // 第一引数のviewControllerを現在のviewControllerの上に被せる（モーダル）
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
}

// MARK: UITextFieldDelefate
extension MealDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    // First Responderが解除された後に呼ばれる
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

// MARK: UIImagePickerControllerDelegate+UINavigationControllerDelegate
extension MealDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 画像選択をキャンセル時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        // モーダルのviewControllerを閉じる
        dismiss(animated: true, completion: nil)
    }
    
    // 画像を選択し終わった後に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set the photoImageView to display the selected Image.
        photoImageView.image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
    }
}

