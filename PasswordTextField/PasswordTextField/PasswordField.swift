//
//  PasswordField.swift
//  PasswordTextField
//
//  Created by Ben Gohlke on 6/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class PasswordField: UIControl {
    
    // Public API - these properties are used to fetch the final password and strength values
    private (set) var password: String = ""
    
    private let standardMargin: CGFloat = 8.0
    private let textFieldContainerHeight: CGFloat = 50.0
    private let textFieldMargin: CGFloat = 6.0
    private let colorViewSize: CGSize = CGSize(width: 60.0, height: 5.0)
    
    private let labelTextColor = UIColor(hue: 233.0/360.0, saturation: 16/100.0, brightness: 41/100.0, alpha: 1)
    private let labelFont = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    
    private let textFieldBorderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
    private let bgColor = UIColor(hue: 0, saturation: 0, brightness: 97/100.0, alpha: 1)
    
    // States of the password strength indicators
    private let unusedColor = UIColor(hue: 210/360.0, saturation: 5/100.0, brightness: 86/100.0, alpha: 1)
    private let weakColor = UIColor(hue: 0/360, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let mediumColor = UIColor(hue: 39/360.0, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let strongColor = UIColor(hue: 132/360.0, saturation: 60/100.0, brightness: 75/100.0, alpha: 1)
    //view
    private var titleLabel: UILabel = UILabel()
    //view
    private var textField: UITextField = UITextField()
    private var showHideButton: UIButton = UIButton()
    //view
    
    private var weakView: UIView = UIView()
    private var mediumView: UIView = UIView()
    private var strongView: UIView = UIView()
    //view
    
    private var strengthDescriptionLabel: UILabel = UILabel()
    
    //all views
    
    func setupViews() {
        // Lay out your subviews here
        self.backgroundColor = bgColor
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Enter Password"
        titleLabel.textColor = .black
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: standardMargin)
        ])
        
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type password here"
        //textField.isHidden = true
        textField.layer.borderColor = textFieldBorderColor.cgColor
        textField.layer.borderWidth = 1
        textField.isSecureTextEntry = true
        //textField.isUserInteractionEnabled
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: textFieldMargin),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: textFieldMargin),
            textField.heightAnchor.constraint(equalToConstant: textFieldContainerHeight)
        ])
        
        showHideButton.translatesAutoresizingMaskIntoConstraints = false
        showHideButton.setImage(UIImage(named: "eyes-open.png"), for: .normal)
        showHideButton.addTarget(self, action: #selector(showHideButtonTapped), for: .touchUpInside)
        
        
        addSubview(showHideButton)
        
        NSLayoutConstraint.activate([
            showHideButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -8),
            showHideButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor, constant: 0)
        ])
        
        showHideButton.isUserInteractionEnabled = true
        
        weakView.translatesAutoresizingMaskIntoConstraints = false
        weakView.layer.cornerRadius = 12
        weakView.backgroundColor = unusedColor
        
        addSubview(weakView)
        
        NSLayoutConstraint.activate([
            weakView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            weakView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin),
            weakView.heightAnchor.constraint(equalToConstant: colorViewSize.height),
            weakView.widthAnchor.constraint(equalToConstant: colorViewSize.width)
        ])
        
        mediumView.translatesAutoresizingMaskIntoConstraints = false
        mediumView.layer.cornerRadius = 12
        mediumView.backgroundColor = unusedColor
        
        addSubview(mediumView)
        
        NSLayoutConstraint.activate([
            mediumView.leadingAnchor.constraint(equalTo: weakView.trailingAnchor, constant: 0),
            mediumView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin),
            mediumView.heightAnchor.constraint(equalToConstant: colorViewSize.height),
            mediumView.widthAnchor.constraint(equalToConstant: colorViewSize.width)
        ])
        
        strongView.translatesAutoresizingMaskIntoConstraints = false
        strongView.layer.cornerRadius = 12
        strongView.backgroundColor = unusedColor
        
        addSubview(strongView)
        
        NSLayoutConstraint.activate([
            strongView.leadingAnchor.constraint(equalTo: mediumView.trailingAnchor, constant: 0),
            strongView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin),
            strongView.heightAnchor.constraint(equalToConstant: colorViewSize.height),
            strongView.widthAnchor.constraint(equalToConstant: colorViewSize.width)
        ])
        
        strengthDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        strengthDescriptionLabel.text = ""
        strengthDescriptionLabel.adjustsFontSizeToFitWidth = true
        strengthDescriptionLabel.font = labelFont
        strengthDescriptionLabel.textColor = labelTextColor
        strengthDescriptionLabel.textAlignment = .right
        
        addSubview(strengthDescriptionLabel)
        
        NSLayoutConstraint.activate([
            strengthDescriptionLabel.leadingAnchor.constraint(equalTo: strongView.trailingAnchor, constant: 8),
            strengthDescriptionLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4)
            
        ])
        
    }
    // done with constraints
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}

//password change and animations

extension PasswordField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        updatePassword(newText)
        
        // TODO: send new text to the determine strength method
        //        if newText = newText {
        //
        //           } else if {
        //
        //           } else if {
        //
        //           }
        //
        
        
        return true
    }
    
    //password strength
    
    private func updatePassword(_ password: String) {
        if password.count < 8 {
            strengthDescriptionLabel.text = "Too Weak"
            weakView.backgroundColor = weakColor
            mediumView.backgroundColor = unusedColor
            strongView.backgroundColor = unusedColor
            animateWeakColorLabel()
        } else if password.count < 12 {
            strengthDescriptionLabel.text = "Average"
            weakView.backgroundColor = weakColor
            mediumView.backgroundColor = mediumColor
            strongView.backgroundColor = unusedColor
            animateMediumColorLabel()
        } else if password.count >= 15 {
            strengthDescriptionLabel.text = "Strong"
            weakView.backgroundColor = weakColor
            mediumView.backgroundColor = mediumColor
            strongView.backgroundColor = strongColor
            animateStrongColorLabel()
        }
    }
    
    //animations
    
    //color change animation
    @objc private func animateWeakColorLabel() {
        
        let animBlock = {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
                self.weakView.center = self.weakView.center
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.2) {
                self.weakView.transform = CGAffineTransform(scaleX: 2.7, y: 0.6)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.2) {
                self.weakView.transform = CGAffineTransform(scaleX: 0.6, y: 2.7)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.15) {
                self.weakView.transform = CGAffineTransform(scaleX: 1.11, y: 0.9)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.15) {
                self.weakView.transform = .identity
            }
        }
        
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [], animations: animBlock, completion: nil)
    }
    
    @objc private func animateMediumColorLabel() {
           
           let animBlock = {
               UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
                   self.weakView.center = self.weakView.center
               }
               
               UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.2) {
                   self.mediumView.transform = CGAffineTransform(scaleX: 2.7, y: 0.6)
               }
               
               UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.2) {
                   self.mediumView.transform = CGAffineTransform(scaleX: 0.6, y: 2.7)
               }
               
               UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.15) {
                   self.mediumView.transform = CGAffineTransform(scaleX: 1.11, y: 0.9)
               }
               
               UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.15) {
                   self.mediumView.transform = .identity
               }
           }
           
           UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [], animations: animBlock, completion: nil)
       }
    
    @objc private func animateStrongColorLabel() {
           
           let animBlock = {
               UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
                   self.weakView.center = self.weakView.center
               }
               
               UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.2) {
                   self.strongView.transform = CGAffineTransform(scaleX: 2.7, y: 0.6)
               }
               
               UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.2) {
                   self.strongView.transform = CGAffineTransform(scaleX: 0.6, y: 2.7)
               }
               
               UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.15) {
                   self.strongView.transform = CGAffineTransform(scaleX: 1.11, y: 0.9)
               }
               
               UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.15) {
                   self.strongView.transform = .identity
               }
           }
           
           UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [], animations: animBlock, completion: nil)
       }
    
    @objc private func showHideButtonTapped() {
        
        let toggled = textField.isSecureTextEntry
        if toggled {
            textField.isSecureTextEntry = false
            showHideButton.setImage(UIImage(named: "eyes-open.png"), for: .normal)
        } else {
            textField.isSecureTextEntry = true
            showHideButton.setImage(UIImage(named: "eyes-closed.png"), for: .normal)
        }
        
        //        let fade = {
        //            UIView.animate(withDuration: 0.25, delay: 0.15, usingSpringWithDamping: 1.0, initialSpringVelocity: 5, options: [], animations: {
        //                self.showHideButton.alpha = 0
        //            })
        //            let eyesAppear = {
        //                UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 5, options: [], animations: {
        //                    self.showHideButton.alpha = 1
        //                })
        //            }
        //            UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: eyesAppear, completion: nil)
        //        }
        //        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: fade, completion: nil)
    }
    private func strengthDescriptionAnimate(_view: UIView) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {return false}
        password = text
        sendActions(for: .valueChanged)
        textField.resignFirstResponder()
        return false
    }
    
}
/*
 
 let squashButton = UIButton(type: .system)
 squashButton.translatesAutoresizingMaskIntoConstraints = false
 squashButton.setTitle("Squash", for: .normal)
 squashButton.addTarget(self, action: #selector(squashButtonTapped), for: .touchUpInside)
 
 @objc private func squashButtonTapped() {
 label.center = CGPoint(x: view.center.x, y: -label.bounds.size.height)
 
 let animBlock = {
 UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
 self.label.center = self.view.center
 }
 
 UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.2) {
 self.label.transform = CGAffineTransform(scaleX: 2.7, y: 0.6)
 }
 
 UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.2) {
 self.label.transform = CGAffineTransform(scaleX: 0.6, y: 2.7)
 }
 
 UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.15) {
 self.label.transform = CGAffineTransform(scaleX: 1.11, y: 0.9)
 }
 
 UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.15) {
 self.label.transform = .identity
 }
 }
 
 UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [], animations: animBlock, completion: nil)
 }
 */


