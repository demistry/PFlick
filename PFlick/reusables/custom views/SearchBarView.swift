//
//  SearchBarView.swift
//  PFlick
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import UIKit

class SearchBarView: UIView {

    
    private lazy var searchBackgroundView: UIView = {
        let view = UIView()
        view.makeLayoutable()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var searchTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Search..."
        textfield.makeLayoutable()
        return textfield
    }()
    
    private lazy var cancelSearchButton: UIButton = {
        let button = UIButton()
        button.makeLayoutable()
        button.alpha = 0
        return button
    }()
    
    private lazy var searchStateIcon: UIImageView = {
        let imageView = UIImageView(image: Constants.Images.CancelIcon)
        imageView.makeLayoutable()
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    
    func initialize(){
        addSubview(searchBackgroundView)
        searchBackgroundView.addSubview(searchTextField)
        searchBackgroundView.addSubview(searchStateIcon)
        searchBackgroundView.addSubview(cancelSearchButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([searchBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                    searchBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                    searchBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
                                    searchBackgroundView.heightAnchor.constraint(equalToConstant: frame.height > 56 ? 56 : max(20,frame.height)),
        
        
        
                                    searchTextField.leadingAnchor.constraint(equalTo: searchBackgroundView.leadingAnchor, constant: 16),
                                    searchTextField.trailingAnchor.constraint(equalTo: searchStateIcon.leadingAnchor, constant: 4)])
    }
}
