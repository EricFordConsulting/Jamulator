/**
 * Copyright (c) 2017 Eric Ford Consulting
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
