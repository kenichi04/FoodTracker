//
//  Meal.swift
//  FoodTracker
//
//  Created by takashimakenichi on 2021/01/01.
//  Copyright © 2021 takashimakenichi. All rights reserved.
//

import UIKit
import os.log

// NSSecureCodingを継承するために、NSObjectのサブクラスである必要がある
class Meal: NSObject, NSSecureCoding {
    
    // MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    
    // MARK: Archiving Paths
    /* エンコードしたデータの保存場所 */
    // アプリのドキュメントがあるディレクトリ. そのためアプリごとに独立した記憶領域に保存される
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    // 上にmealsというパスを加える
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    
    // MARK: Types
    struct PropertyKey {
        // NCCodingで使用するキー
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    // MARK: Initialization
    init?(name: String, photo: UIImage?, rating: Int) {
        // Initialization should fail if there is no name or if the rating is negative.
//        if name.isEmpty || rating < 0 {
//            return nil
//        }
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        // The rating must be between 0 and 5 inclusively
        guard rating >= 0 && rating <= 5 else {
            return nil
        }
        
        // Initialize stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    // MARK: NDCoding
    
    // クラスの情報をデータ化する
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    // 保存されたデータからクラスを作成する初期化関数
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cact.
        // photoはnil許容
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        // Intを返すため、ダウンキャスト発生せず、guard文の必要なし
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designed initializer.
        self.init(name: name, photo: photo, rating: rating)
    }
    
    // MARK: NSSecureCoding
    static var supportsSecureCoding: Bool = true
    
}
