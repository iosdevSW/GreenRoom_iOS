//
//  UIImageView+.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/22.
//

import UIKit

extension UIImageView {
    func setImageStack(images: [UIImage]) {
        let spacing = 20
        
        let count = images.count
        
        let size = CGSize(width: 30 + 20 * (count-1), height: 40)
        UIGraphicsBeginImageContext(size)
        
        images.enumerated().forEach { (index, image) in
            image.draw(at: CGPoint(x: index * spacing, y: 0))
        }
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.image = mergedImage
    }

}
