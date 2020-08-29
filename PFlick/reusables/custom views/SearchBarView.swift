//
//  SearchBarView.swift
//  PFlick
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa



class SearchBarView: UIView {

    let disposeBag = DisposeBag()
    var textToSearchFor = BehaviorRelay<String>(value: "")
    private lazy var searchBackgroundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 56))
        view.makeLayoutable()
        view.backgroundColor = .white
        return view
    }()
    
    private var hasText: Bool = false
    
    private lazy var searchTextField: UITextField = {
        let textfield = UITextField()
        textfield.textColor = .black
        textfield.attributedPlaceholder = NSAttributedString(string: "Search...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.delegate = self
        textfield.makeLayoutable()
        return textfield
    }()
    
    private lazy var cancelSearchImage: UIImageView = {
        let image = UIImageView()
        image.image = Constants.Images.CancelIcon
        image.makeLayoutable()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clearField))
        image.addGestureRecognizer(gesture)
        image.alpha = 0
        return image
    }()
    
    private lazy var searchStateIcon: UIImageView = {
        let imageView = UIImageView(image: Constants.Images.SearchIcon)
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

    
    @objc func clearField(){
        searchTextField.text = nil
        self.transitionToSearch()
    }
    
    func initialize(){
        addSubview(searchBackgroundView)
        searchBackgroundView.addGestureRecognizer(UITapGestureRecognizer())
        searchBackgroundView.addSubview(searchTextField)
        searchBackgroundView.addSubview(searchStateIcon)
        searchBackgroundView.addSubview(cancelSearchImage)
        setupConstraints()
        setupBindings()
    }
    
    func addNeumorphism(radius: CGFloat){
        backgroundColor = .offWhite
        layer.cornerRadius = radius
        let darkShadow = CALayer()
        let lightShadow = CALayer()
        darkShadow.frame = self.bounds
        darkShadow.cornerRadius = radius
        darkShadow.backgroundColor = UIColor.offWhite.cgColor
        darkShadow.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        darkShadow.shadowOffset = CGSize(width: 10, height: 10)
        darkShadow.shadowOpacity = 1
        darkShadow.shadowRadius = radius
        self.layer.insertSublayer(darkShadow, at: 0)
        lightShadow.frame = self.bounds
        lightShadow.cornerRadius = radius
        lightShadow.backgroundColor = UIColor.offWhite.cgColor
        lightShadow.shadowColor = UIColor.white.withAlphaComponent(0.9).cgColor
        lightShadow.shadowOffset = CGSize(width: -7, height: -5)
        lightShadow.shadowOpacity = 1
        lightShadow.shadowRadius = radius
        self.layer.insertSublayer(lightShadow, at: 0)
    }
    
    func setupBindings(){
        searchTextField.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self](text) in
            self?.hasText = text.count > 0
            if text.isEmpty || text == ""{
                self?.transitionToSearch()
            } else{
                self?.transitionToClearField()
                self?.textToSearchFor.accept(text)
            }
            }).disposed(by: disposeBag)
        
    }
    
    func transitionToClearField(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.transitionCrossDissolve], animations: {[weak self] in
            self?.cancelSearchImage.alpha = 1
            self?.searchStateIcon.alpha = 0
        })
        cancelSearchImage.isUserInteractionEnabled = true
    }
    
    func transitionToSearch(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.transitionCrossDissolve], animations: {[weak self] in
            self?.cancelSearchImage.alpha = 0
            self?.searchStateIcon.alpha = 1
        })
        cancelSearchImage.isUserInteractionEnabled = false
    }
    
    func setupConstraints(){
        let backgroundFrameHeight = frame.height > 56 ? 56 : max(20,frame.height)
        NSLayoutConstraint.activate([searchBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                    searchBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                    searchBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
                                    searchBackgroundView.heightAnchor.constraint(equalToConstant: backgroundFrameHeight),
        
        
        
                                    searchTextField.leadingAnchor.constraint(equalTo: searchBackgroundView.leadingAnchor, constant: 20),
                                    searchTextField.trailingAnchor.constraint(equalTo: searchStateIcon.leadingAnchor, constant: 4),
                                    searchTextField.heightAnchor.constraint(equalTo: searchBackgroundView.heightAnchor),
                                    searchTextField.centerYAnchor.constraint(equalTo: searchBackgroundView.centerYAnchor),
        
        
                                    searchStateIcon.trailingAnchor.constraint(equalTo: searchBackgroundView.trailingAnchor, constant: -16),
                                    searchStateIcon.centerYAnchor.constraint(equalTo: searchBackgroundView.centerYAnchor),
        
                                    cancelSearchImage.centerYAnchor.constraint(equalTo: searchStateIcon.centerYAnchor),
                                    cancelSearchImage.centerXAnchor.constraint(equalTo: searchStateIcon.centerXAnchor),
                                    cancelSearchImage.heightAnchor.constraint(equalToConstant: 16),
                                    cancelSearchImage.widthAnchor.constraint(equalToConstant: 16)])
        
        searchBackgroundView.layer.cornerRadius = backgroundFrameHeight / 2
        searchBackgroundView.clipsToBounds = true
        
        addNeumorphism(radius: backgroundFrameHeight / 2)
    }
}


extension SearchBarView: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.transitionToClearField()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == UIReturnKeyType.default{
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}
