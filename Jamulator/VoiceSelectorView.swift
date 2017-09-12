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

class VoiceSelectorView : UIView {
  var voiceCategoryButtons: [VoiceCategoryButton]
  var voiceSelectorButtons: [VoiceSelectorButton]
  var synth: SoftSynth?
  var voiceNowPlaying: Int
  var categorySelected: Int
  let loadingTextColor = UIColor(red: 0.2, green: 0.2, blue: 0.9, alpha: 1.0)
  let categoryBackgroundColor = UIColor(red: 0.9, green: 0.9, blue: 1.0, alpha: 1.0)
  let categoryTextColor = UIColor(red: 0.4, green: 0.4, blue: 1.0, alpha: 1.0)
  let voiceBackgroundColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)
  let voiceTextColor = UIColor(red: 0.2, green: 0.2, blue: 0.9, alpha: 1.0)
  var showVoices = false
  var loadingDisplayIndex = 0
  var timer: Timer?
  
  let voiceCategoryNames = ["Pianos", "Mallets", "Organs", "Guitars", "Basses", "Strings", "Ensmbles", "Brass",
                            "Reeds", "Pipes", "Synth Leads", "Synth Pads", "Synth Effects", "Ethnic", "Percussive", "Sound Effects"]
  
  let voices = [
    // pianos
    "Grand Piano", "Bright Piano", "Electric Grand", "Honky-Tonk",
    "Electric Piano 1", "Electric Piano 2", "Harpsichord", "Clavinet",
    // mallets
    "Celesta", "Glockenspiel", "Music Box", "Vibraphone",
    "Marimba", "Xylophone", "Tubular Bells", "Dulcimer",
    // organs
    "Drawbar Organ", "Percussive Organ", "Rock Organ", "Church Organ",
    "Reed Organ", "Accordion", "Harmonica", "Tango Accordion",
    // guitars
    "Nylon Guitar", "Steel Guitar", "Jazz Guitar", "Clean Guitar",
    "Muted Guitar", "Overdriven Guitar", "Distortion Guitar", "Guitar Harmonics",
    // basses
    "Acoustic Bass", "Finger Bass", "Pick Bass", "Fretless Bass",
    "Slap Bass 1", "Slap Bass 2", "Synth Bass 1", "Synth Bass 2",
    // strings
    "Violin", "Viola", "Cello", "Contrabass",
    "Tremolo Strings", "Pizzicato Strings", "Orchestral Harp", "Timpani",
    // ensembles
    "String Ensemble 1", "String Ensemble 2", "Synth Strings 1", "Synth Strings 2",
    "Choir Aahs", "Voice Oohs", "Synth Choir", "Orchestra Hit",
    // brass
    "Trumpet", "Trombone", "Tuba", "Muted Trumpet",
    "French Horn", "Brass Section", "Synth Brass 1", "Synth Brass 2",
    // reeds
    "Soprano Sax", "Alto Sax", "Tenor Sax", "Baritone Sax",
    "Oboe", "English Horn", "Bassoon", "Clarinet",
    // pipes
    "Piccolo", "Flute", "Recorder", "Pan Flute",
    "Blown bottle", "Shakuhachi", "Whistle", "Ocarina",
    // synth leads
    "Square", "Sawtooth", "Calliope", "Chiff",
    "Charang", "Voice", "Fifths", "Bass + Lead",
    // synth pads
    "New Age", "Warm", "Polysynth", "Choir",
    "Bowed", "Metallic", "Halo", "Sweep",
    // synth effects
    "Rain", "Soundtrack", "Crystal", "Atmosphere",
    "Brightness", "Goblins", "Echoes", "Sci-fi",
    // ethnic
    "Sitar", "Banjo", "Shamisen", "Koto",
    "Kalimba", "Bagpipe", "Fiddle", "Shanai",
    // percussive
    "Tinkle Bell", "Agogo", "Steel Drums", "Woodblock",
    "Taiko Drum", "Melodic Tom", "Synth Drum", "Reverse Cymbal",
    // sound effects
    "Guitar Fret Noise", "Breath Noise", "Seashore", "Bird Tweet",
    "Telephone Ring", "Helicopter", "Applause", "Gunshot"
  ]

  convenience init (frame: CGRect, synth: SoftSynth) {
    self.init(frame: frame)
    self.synth = synth
  }
  
  override init(frame: CGRect) {
    voiceCategoryButtons = []
    voiceSelectorButtons = []
    voiceNowPlaying = 0
    categorySelected = 0
    
    for (index, name) in voiceCategoryNames.enumerated() {
      let row = CGFloat(index / 4)
      let column = CGFloat(index % 4)
      let width = frame.width / 4
      let height = frame.height / 8
      voiceCategoryButtons.append(VoiceCategoryButton(
        name: name, number: index + 1, x: column * width, y: row * height,
        width: width, height: height, color: categoryBackgroundColor, hiliteColor: categoryTextColor
      ))
    }
    voiceCategoryButtons[categorySelected].selected = true    

    for (index, voice) in voices.enumerated() {
      let row = CGFloat((index / 4) % 2)
      let column = CGFloat(index % 4)
      let top = (frame.height / 2) + (row * (frame.height / 4))
      let width = frame.width / 4
      let height = (frame.height / 4)
      voiceSelectorButtons.append(VoiceSelectorButton(
        voiceName: voice, voiceNumber: index + 1, channel: 0, x: column * width, y: top,
        width: width, height: height, color: voiceBackgroundColor, hiliteColor: voiceTextColor))
    }
    voiceSelectorButtons[voiceNowPlaying].selected = true
    
    super.init(frame: frame)
    backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)
    setNeedsDisplay()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    voiceCategoryButtons = []
    voiceSelectorButtons = []
    voiceNowPlaying = 0
    categorySelected = 0
   super.init(coder: aDecoder)
  }
  
  override func draw(_ rect: CGRect) {
    if showVoices {
      for button: VoiceCategoryButton in voiceCategoryButtons {
        drawCategoryButton(button: button, rect: rect)
      }
      for button: VoiceSelectorButton in voiceSelectorButtons {
        if button.voiceNumber >= ((8 * categorySelected) + 1) && button.voiceNumber <= ((8 * (categorySelected + 1))) {
          drawVoiceButton(button: button, rect: rect)
        }
      }
    } else {
      drawLoadingMessage(rect: rect)
    }
  }

  // MARK: - methods used in draw()
  
  func getTextAttributes(fontSize: CGFloat, textColor: UIColor) -> [NSAttributedStringKey: Any] {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    var textAttributes: [NSAttributedStringKey: Any] = [
      NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): textColor,
      NSAttributedStringKey(rawValue: NSAttributedStringKey.paragraphStyle.rawValue): paragraphStyle
    ]
    if let font = UIFont(name: "MarkerFelt-Thin", size: fontSize) {
      textAttributes[NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue)] = font
    }
    return textAttributes
  }
  
  func drawButtonName(name: String, fontSize: CGFloat, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
    let textRect = CGRect(x: x, y: y + ScreenUtils.getAdjustedTextYOffset(), width: width, height: height)
    String(name).draw(in: textRect, withAttributes: getTextAttributes(fontSize: fontSize, textColor: color))
  }
  
  func drawCategoryButton(button: VoiceCategoryButton, rect: CGRect) {
    var textColor: UIColor
    button.path.lineWidth = 4
    button.path.stroke()
    if button.selected {
      button.hiliteColor.set()
      textColor = button.color
    } else {
      button.color.set()
      textColor = button.hiliteColor
    }
    button.path.fill()
    drawButtonName(name: button.name, fontSize: ScreenUtils.getAdjustedFontSize() * 1.5, x: button.x, y: button.y, width: rect.width / 4, height: rect.height / 8, color: textColor)
  }
  
  func drawVoiceButton(button: VoiceSelectorButton, rect: CGRect) {
    let fudgeFactor = UIScreen.main.bounds.width / 60
    var textColor: UIColor
    if button.selected {
      button.hiliteColor.set()
      textColor = button.color
    } else {
      button.color.set()
      textColor = button.hiliteColor
    }
    button.path.fill()
    drawButtonName(name: button.name, fontSize: ScreenUtils.getAdjustedFontSize() * 1.9, x: button.x, y: button.y + fudgeFactor, width: rect.width / 4, height: rect.height / 4, color: textColor)
  }
  
  // The voice file is 140 meg. The simulator loads it very slowly.
  // We'll show one voice name per second until the file is loaded.
  // On device hardware this may never actually get seen.
  // The completion routine in the controller sets showVoices to true.
  @objc func incrementDisplayIndex() {
    if showVoices {
      timer?.invalidate()
    } else {
      if loadingDisplayIndex + 1 < voices.count {
        loadingDisplayIndex += 1
      } else {
        loadingDisplayIndex = 0
      }
    }
    setNeedsDisplay()
  }
  
  func drawLoadingMessage(rect: CGRect) {
    let textRect = CGRect(x: rect.origin.x, y: rect.height / 6, width: rect.width, height: rect.height / 2)
    drawLoadingString(text: "Loading Voice " + String(loadingDisplayIndex) + " of " + String(voices.count), rect: textRect, fontSize: ScreenUtils.getAdjustedFontSize() * 3)
    let subtextRect = CGRect(x: rect.origin.x, y: rect.origin.y + rect.height / 2, width: rect.width, height: rect.height / 4)
    drawLoadingString(text: voices[loadingDisplayIndex], rect: subtextRect, fontSize: ScreenUtils.getAdjustedFontSize() * 2)
    let subsubtextRect = CGRect(x: rect.origin.x, y: rect.origin.y + (rect.height / 4) * 3, width: rect.width, height: rect.height / 4)
    drawLoadingString(text: "You can play the piano while you wait, but there's only one voice", rect: subsubtextRect, fontSize: ScreenUtils.getAdjustedFontSize() * 1.5)
  }
  
  func drawLoadingString(text: String, rect: CGRect, fontSize: CGFloat) {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    var textAttributes: [NSAttributedStringKey: Any]
    textAttributes = [
      NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): loadingTextColor,
      NSAttributedStringKey(rawValue: NSAttributedStringKey.paragraphStyle.rawValue): paragraphStyle
    ]
    if let font = UIFont(name: "MarkerFelt-Thin", size: fontSize) {
      textAttributes[NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue)] = font
    }
    text.draw(in: rect, withAttributes: textAttributes)
  }
  
  // MARK: - handle touches
  
  // UIBezierPath has a contains() method
  // Very handy for drawing touchable shapes
  func categoryIndexFromTouch(_ touch: UITouch) -> Int {
    var result = -1
    let location = touch.location(in: self)
    for (index, button) in voiceCategoryButtons.enumerated() {
      if(button.path.contains(location)) {
        result = index
        break
      }
    }
    return result
  }
  
  // This is similar to categoryIndexFromTouch.
  // Each category of voices has 8 instruments.
  // So we just check to make sure it's in the selected category
  //  before drawing it.
  func buttonIndexFromTouch(_ touch: UITouch) -> Int {
    var result = -1
    let location = touch.location(in: self)
    for (index, button) in voiceSelectorButtons.enumerated() {
      if button.voiceNumber >= ((8 * categorySelected) + 1) && button.voiceNumber <= ((8 * (categorySelected + 1)) + 1) {
        if(button.path.contains(location)) {
            result = index
            break
        }
      }
    }
    return result
  }
  
  // Notice that we are only allowing one touch at a time.
  // We could check all of the touches, but in this case the
  //  upper buttons change the lower ones, so it wouldn't be
  //  very intuitive.
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let categoryIndex = categoryIndexFromTouch(touches.first!)
    if categoryIndex != -1 {
      voiceCategoryButtons[categoryIndex].selected = true
      voiceCategoryButtons[categorySelected].selected = false
      categorySelected = categoryIndex
    }
    
    let buttonIndex = buttonIndexFromTouch(touches.first!)
    if buttonIndex != -1 {
        voiceSelectorButtons[buttonIndex].selected = true
        voiceSelectorButtons[voiceNowPlaying].selected = false
        voiceNowPlaying = buttonIndex
        synth?.loadPatch(patchNo: voiceNowPlaying)
        Sequencer.shared.patch = UInt32(voiceNowPlaying)
    }
    setNeedsDisplay()
  }
  
  // MARK: - methods called from the controller
  func setTimer() {
    timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(incrementDisplayIndex), userInfo: nil, repeats: true)
  }
  
  // called when the voices are available
  func setShowVoices(show: Bool) {
    showVoices = show
    setNeedsDisplay()
  }
}
