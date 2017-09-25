/**
 * Copyright (c) 2017 Eric Ford Consulting
 */

import UIKit

class ScreenUtils {
  // MARK: - handle different screen sizes
  
  // base screen size is iPhone 6 plus or 7 plus, 736 x 414 landscape
  static let widthRatio = UIScreen.main.bounds.width / 736
  static let heightRatio = UIScreen.main.bounds.height / 414
  
  // scale a rectangle up or down proportional to the screen size of the device
  static func resizeRect(rect: CGRect) -> CGRect {
    return CGRect(x: rect.origin.x * widthRatio, y: rect.origin.y * heightRatio,
                  width: rect.width * widthRatio, height: rect.height * heightRatio)
  }
  
  // get a font with a size proportional to the screen size
  static func getAdjustedFont() -> UIFont? {
    return UIFont(name: "MarkerFelt-Thin", size: getAdjustedFontSize())
  }
  
  // get a font size proportional to the screen size
  static func getAdjustedFontSize() -> CGFloat {
    return UIScreen.main.bounds.width / 80
  }
  
  static func getAdjustedTextYOffset() -> CGFloat {
    if UIScreen.main.bounds.width < 736 {
      return 0
    }
    return UIScreen.main.bounds.width / 200
  }
}

extension UIColor {
  
  convenience init(hex: Int, alpha: Double = 1.0) {
    self.init(red: CGFloat((hex>>16)&0xFF)/255.0, green:CGFloat((hex>>8)&0xFF)/255.0, blue: CGFloat((hex)&0xFF)/255.0, alpha:  CGFloat(255 * alpha) / 255)
  }
  
}
