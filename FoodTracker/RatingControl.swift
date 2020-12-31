//
//  RatingControl.swift
//  FoodTracker
//
//  Created by takashimakenichi on 2020/12/30.
//  Copyright © 2020 takashimakenichi. All rights reserved.
//

import UIKit

// @IBDesignable属性により、intefaceBuilderがこのクラスを描画して反映する
@IBDesignable class RatingControl: UIStackView {
    
    // MARK: Properties
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        // ratingが変更されたらボタンの表示を変化させる
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    // @IBInspectalbe属性により、Attribute inspectorに反映させる
    @IBInspectable var starSize: CGSize = CGSize(width: 50.0, height: 50.0) {
        // property observer設定 -> プロパティの値変更後に{}内処理を実施
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    // required: サブクラスに初期化関数のオーバーライドを強制する（今回はUIStackViewが実装を強制）
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
//        print("Button pressed 👍")
        
        // タップしたボタンの添え字を取得、戻り値はInt?型のため、nilの場合はエラー処理
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        // 今回タップしたレーティング
        let selectedRating = index + 1
        
        // 現在のレーティングと同じボタンをタップした場合は、レーティングをリセット、違う場合は新しいレーティングを設定
        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
        
    }
    
    // MARK: Private Methods
    private func setupButtons() {
        // 複数回呼ばれるため、ボタン作成前にすでにあるボタンを削除しておく
        // Clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        // 配列初期化
        ratingButtons.removeAll()
        
        // Load Button Images
        // このクラスは@IBDesignable属性であり、interfaceBuilderから初期化され、interfaceBuilderから画像を取得するため、
        // メインバンドルではなく自身のバンドルを明示する
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        // ボタン作成
        for _ in 0 ..< starCount {
            // Create the button
            let button = UIButton()
//            button.backgroundColor = UIColor.red
            
            // Set the button images.
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            // ハイライト時かセレクト時かに関わらず一度タップした時に表示させるため
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            // ボタンサイズ　※位置はstackViewによって決定されるので設定する必要はない
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to rating button array.
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    // レーティングが設定されたらボタンの表示を変化させる
    private func updateButtonSelectionStates() {
        // enumerated()メソッドで配列の添え字と要素をタプルで取得
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            // ex)rating == 3 の場合、添え字0,1,2のボタンがisSelected(選択状態)となる
            button.isSelected = index < rating
        }
    }
    
    
}
