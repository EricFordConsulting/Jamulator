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
import AudioKit

class MIDIInstrumentViewController: UIViewController {

  let chooseOctaveControl = UISegmentedControl(items: ["1", "2", "3", "4", "5", "6"])
  let sequencerControl = UISegmentedControl(items: ["Off", "Record", "Play"])

  let synth = SoftSynth()
  let sequencer = Sequencer.shared
  // a custom control for choosing from the 128 general MIDI voices
  var voiceSelectorView: VoiceSelectorView?
  let backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.8, alpha: 1.0)
  let keyOnColor = UIColor(red: 0.4, green: 0.4, blue: 0.9, alpha: 1.0)
  let whiteKeyOffColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)
  let blackKeyOffColor = UIColor(red: 0.2, green: 0.2, blue: 0.9, alpha: 1.0)
  let labelTextColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = backgroundColor
    voiceSelectorView = VoiceSelectorView(frame:
      ScreenUtils.resizeRect(rect: CGRect(x: 40, y: 200, width: 640, height: 160)), synth: synth)
    setSpeakersAsDefaultAudioOutput()
    setUpPianoKeyboard()

    // cover up garbage on the right side of AKKeyboardView
    let coverUp = UIView(frame: ScreenUtils.resizeRect(rect: CGRect(x: 679, y: 0, width: 100, height: 150)))
    coverUp.backgroundColor = self.view.backgroundColor
    self.view.addSubview(coverUp)
    
    setUpOctaveControl()
  
    view.addSubview(voiceSelectorView!)

    loadVoices()
    // show the names of the voices while they are loading
    // one every second or so
    // probably only relevant in the simulator, but just in case...
    voiceSelectorView?.setTimer()
  }
  
  // MARK: - utility methods used in viewDidLoad
  
  // work around for when some devices only play through the headphone jack
  func setSpeakersAsDefaultAudioOutput() {
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
    }
    catch {
      // hard to imagine how we'll get this exception
      let alertController = UIAlertController(title: "Speaker Problem", message: "You may be able to hear sound using headphones.", preferredStyle: UIAlertControllerStyle.alert)
      let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
        (result: UIAlertAction) -> Void in
      }
      
      alertController.addAction(okAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
  // the piano keyboard is provided by Audio Kit
  // the protocol extension is at the bottom of this file
  // all we have to provide is a noteOn method and a noteOff method
  func setUpPianoKeyboard() {
    let keyboard = AKKeyboardView(frame: ScreenUtils.resizeRect(
      rect: CGRect(x: 40, y: 0, width: 687, height: 150)))
    keyboard.delegate = self
    keyboard.polyphonicMode = true // allow more than one note at a time
    keyboard.keyOnColor = keyOnColor
    keyboard.whiteKeyOff = whiteKeyOffColor
    keyboard.blackKeyOff = blackKeyOffColor
    self.view.addSubview(keyboard)
  }
  
  func setUpOctaveControl() {
    let octaveLabel = UILabel(frame: ScreenUtils.resizeRect(rect: CGRect(x: 345, y: 152, width: 60, height: 20)))
    octaveLabel.text = "Octave"
    octaveLabel.textColor = labelTextColor
    octaveLabel.font = ScreenUtils.getAdjustedFont()
    self.view.addSubview(octaveLabel)
    chooseOctaveControl.selectedSegmentIndex = synth.octave - 1
    chooseOctaveControl.frame = ScreenUtils.resizeRect(rect: CGRect(x: 200, y: 170, width: 320, height: 20))
    chooseOctaveControl.layer.cornerRadius = 5.0
    chooseOctaveControl.backgroundColor = labelTextColor
    chooseOctaveControl.tintColor = blackKeyOffColor
    chooseOctaveControl.addTarget(self, action: #selector(MIDIInstrumentViewController.changeOctave(_:)), for: .valueChanged)
    self.view.addSubview(chooseOctaveControl)
  }
  
  // a sequencer can record what you play, then play it back
  func setUpSequencer() {
    let sequencerLabel = UILabel(frame: ScreenUtils.resizeRect(rect: CGRect(x: 338, y: 362, width: 100, height: 20)))
    sequencerLabel.text = "Sequencer"
    sequencerLabel.textColor = labelTextColor
    sequencerLabel.font = ScreenUtils.getAdjustedFont()
    self.view.addSubview(sequencerLabel)

    sequencerControl.selectedSegmentIndex = 0 // off
    sequencerControl.frame = ScreenUtils.resizeRect(rect: CGRect(x: 200, y: 380, width: 320, height: 20))
    sequencerControl.layer.cornerRadius = 5.0
    sequencerControl.backgroundColor = labelTextColor
    sequencerControl.tintColor = blackKeyOffColor
    sequencerControl.addTarget(self, action: #selector(MIDIInstrumentViewController.changeSequencerMode(_:)), for: .valueChanged)
    sequencerControl.setEnabled(false, forSegmentAt: 2)
    self.view.addSubview(sequencerControl)
 }
  
  // load the voices in a background thread
  // on completion, tell the voice selector so it can display them
  // again, might only matter in the simulator
  func loadVoices() {
    DispatchQueue.global(qos: .background).async {
      self.synth.loadSoundFont()
      self.synth.loadPatch(patchNo: 0)
      DispatchQueue.main.async {
        // don't let the user choose a voice until they finish loading
        self.voiceSelectorView?.setShowVoices(show: true)
        // don't let the user use the sequencer until the voices are loaded
        self.setUpSequencer()
      }
    }
  }
  
  // MARK: - methods for responding to UISegmentedControls change events
  
  @objc func changeOctave(_ sender: UISegmentedControl) {
    synth.octave = sender.selectedSegmentIndex + 1
  }
  
  // the synth owns the sequencer
  // tell it to record, play, or stop
  // enable the play button when the record button is clicked
  // when recording, turn everything reddish
  @objc func changeSequencerMode(_ sender: UISegmentedControl) {
    sequencer.setSequencerMode(mode: sender.selectedSegmentIndex)
    if sender.selectedSegmentIndex == SequencerMode.recording.rawValue {
      sender.setEnabled(true, forSegmentAt: 2)
      sender.tintColor = .red
    } else {
      sender.tintColor = blackKeyOffColor
    }
  }
}

// MARK: - AKKeyboardDelegate
// the protocol for the piano keyboard needs methods to turn notes on and off
extension MIDIInstrumentViewController: AKKeyboardDelegate {
  
  func noteOn(note: MIDINoteNumber) {
    synth.playNoteOn(channel: 0, note: note, midiVelocity: 127)
  }
  
  func noteOff(note: MIDINoteNumber) {
    synth.playNoteOff(channel: 0, note: UInt32(note), midiVelocity: 127)
  }
}
