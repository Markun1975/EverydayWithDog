//
//  CustomUITextField.swift
//  EverydayWithDog
//
//  Created by Masaki on 6/25/2 R.
//  Copyright © 2 Reiwa Sugita Masaki. All rights reserved.
//

import UIKit

@IBDesignable class CustomUITextField: UITextField {
    

override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
          return super.leftViewRect(forBounds: bounds)
      }

      @IBInspectable var leftImage: UIImage? {
          didSet {
              updateView()
          }
      }
      @IBInspectable var leftPadding: CGFloat = 0 {
          didSet {
              updateView()
          }
      }
      @IBInspectable var rightPadding: CGFloat = 0 {
          didSet {
              updateView()
          }
      }
      @IBInspectable var imageMaxHeight: CGFloat = 0 {
          didSet {
              updateView()
          }
      }

      @IBInspectable var color: UIColor = UIColor.lightGray {
          didSet {
              updateView()
          }
      }

      func updateView() {
          if let image = leftImage {
              leftViewMode = UITextField.ViewMode.always

              let containerSize = calculateContainerViewSize(for: image)
              let containerView = UIView(frame: CGRect(x: 0, y: 0, width: containerSize.width, height: containerSize.height))

              let imageView = UIImageView(frame: .zero)
              containerView.addSubview(imageView)
              setImageViewConstraints(imageView, in: containerView)

              setImageViewProperties(imageView, image: image)

              leftView = containerView
          } else {
              leftViewMode = UITextField.ViewMode.never
              leftView = nil
          }

          attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "",
                  attributes: [NSAttributedString.Key.foregroundColor: color])
      }

      private func calculateContainerViewSize(for image: UIImage) -> CGSize {
          let imageRatio = image.size.height / image.size.width
          let adjustedImageMaxHeight = imageMaxHeight > self.frame.height ? self.frame.height : imageMaxHeight

          var imageSize = CGSize()
          if image.size.height > adjustedImageMaxHeight {
              imageSize.height = adjustedImageMaxHeight
              imageSize.width = imageSize.height / imageRatio
          }

          let paddingWidth = leftPadding + rightPadding

          let containerSize = CGSize(width: imageSize.width + paddingWidth, height: imageSize.height)
          return containerSize
      }

      private func setImageViewConstraints(_ imageView: UIImageView, in containerView: UIView) {
          imageView.translatesAutoresizingMaskIntoConstraints = false
          imageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
          imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
          imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -rightPadding).isActive = true
          imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leftPadding).isActive = true
      }

      private func setImageViewProperties(_ imageView: UIImageView, image: UIImage) {
          imageView.contentMode = .scaleAspectFit
          imageView.image = image
          imageView.tintColor = color
      }
    
  }
