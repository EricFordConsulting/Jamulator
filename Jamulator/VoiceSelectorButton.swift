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

import Foundation
import UIKit

class VoiceSelectorButton {
  var name: String
  var voiceNumber: Int
  var channel: Int
  var x, y, width, height: CGFloat
  var color: UIColor
  var hiliteColor: UIColor
  var path: UIBezierPath
  var selected: Bool = false
  var alpha: CGFloat
  
  init (voiceName: String, voiceNumber: Int, channel: Int, x: CGFloat, y: CGFloat,
        width: CGFloat, height: CGFloat, color: UIColor, hiliteColor: UIColor) {
    self.name = voiceName
    self.voiceNumber = voiceNumber
    self.channel = channel
    self.x = CGFloat(x)
    self.y = CGFloat(y)
    self.width = CGFloat(width)
    self.height = CGFloat(height)
    self.color = color
    self.hiliteColor = hiliteColor
    self.path = UIBezierPath()
    self.alpha = 1.0
    
    resetPath()
  }
  
  func resetPath() {
    path = UIBezierPath()
    self.path.move(to: CGPoint(x: self.x, y: self.y))
    self.path.addLine(to: CGPoint(x: self.x + self.width, y: self.y))
    self.path.addLine(to: CGPoint(x: self.x + self.width, y: self.y + self.height))
    self.path.addLine(to: CGPoint(x: self.x, y: self.y + self.height))
    self.path.addLine(to: CGPoint(x: self.x, y: self.y))
    self.path.lineWidth = 1.0
  }
}
