/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
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
