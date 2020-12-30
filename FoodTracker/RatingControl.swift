//
//  RatingControl.swift
//  FoodTracker
//
//  Created by takashimakenichi on 2020/12/30.
//  Copyright © 2020 takashimakenichi. All rights reserved.
//

import UIKit

class RatingControl: UIStackView {
    
    // MARK: Properties
    private var ratingButtons = [UIButton]()
    
    var rating = 0
    
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
        print("Button pressed 👍")
    }
    
    // MARK: Private Methods
    private func setupButtons() {
        
        for _ in 0 ..< 5 {
            // Create the button
            let button = UIButton()
            button.backgroundColor = UIColor.red
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            // ボタンサイズ　※位置はstackViewによって決定されるので設定する必要はない
            button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to rating button array.
            ratingButtons.append(button)
        }
        
    }
}
