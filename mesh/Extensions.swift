//
//  Constraints.swift
//  mesh
//
//  Created by Victor Chien on 4/23/17.
//  Copyright © 2017 Victor Chien. All rights reserved.
//

import UIKit

extension UIColor {
    static let pinkNeon = UIColor(red: 241/255.0, green: 81/255.0, blue: 188/255.0, alpha: 1)
    static let purpleNeon = UIColor(red: 112/255.0, green: 48/255.0, blue: 160/255.0, alpha: 1)
    static let ultraLightGray = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
    static let mediumGray = UIColor(red: 240/255, green: 236/255, blue: 233/255, alpha: 1.0)
    static let translucentWhite = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.4)
    static let translucentWhiteStrong = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.8)
}

extension CAGradientLayer{
    func neonGradient() -> CAGradientLayer{
        let topColor = UIColor.pinkNeon
        let bottomColor = UIColor.purpleNeon
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.2, 0.9] //controls the position of the gradient. X and Y
        let start = CGPoint(x: 1, y: 0)
        let end = CGPoint(x: 0, y: 1)
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        gradientLayer.startPoint = start
        gradientLayer.endPoint = end
        
        return gradientLayer
    }
}

extension UIImage {
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
    //creates an UIImage from UIView
    class func imageWithView(view: UIView) -> UIImage {
        //must set opaque parameter to false in order to display clear elements in view
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

//for setting contraints that are relative to screen size
extension NSLayoutXAxisAnchor {
    func constraint(equalTo: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat, relative: Bool) -> NSLayoutConstraint {
        if relative {
            let screenConstant: CGFloat = 667.0
            let newConstant = constant/screenConstant * UIScreen.main.bounds.height
            return self.constraint(equalTo: equalTo, constant: newConstant)
        } else {
            return self.constraint(equalTo: equalTo, constant: constant)
        }
    }
}

extension NSLayoutYAxisAnchor {
    func constraint(equalTo: NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat, relative: Bool) -> NSLayoutConstraint {
        if relative {
            let screenConstant: CGFloat = 667.0
            let newConstant = constant/screenConstant * UIScreen.main.bounds.height
            return self.constraint(equalTo: equalTo, constant: newConstant)
        } else {
            return self.constraint(equalTo: equalTo, constant: constant)
        }
    }
}

extension NSLayoutDimension {
    func constraint(equalToConstant: CGFloat, relative: Bool) -> NSLayoutConstraint {
        if relative {
            let screenConstant: CGFloat = 667.0
            let newConstant = equalToConstant/screenConstant * UIScreen.main.bounds.height
            return self.constraint(equalToConstant: newConstant)
        } else {
            return self.constraint(equalToConstant: equalToConstant)
        }
    }
}



