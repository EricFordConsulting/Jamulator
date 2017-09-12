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
import AudioToolbox
import CoreAudio

enum SequencerMode: Int {
  case off = 0, recording, playing
}

final class Sequencer : AudioCommon {
//  var storedPatch     = UInt32(0)
  var musicSequence: MusicSequence?
  var musicPlayer: MusicPlayer?
  let sequencerMidiChannel = UInt8(1)
  var midiVelocity = UInt8(127)
  
  var sequencerMode = 0
  var sequenceStartTime: Date?
  var track: MusicTrack?
  
  var noteOnTimes = [Date] (repeating: Date(), count:128)
  
  static let shared = Sequencer()
  private override init()
  {
    super.init()
    initAudio()
    setUpSequencer()
    loadSoundFont()
    loadPatch(patchNo: 0)
  }
  
  func setSequencerMode(mode: Int) {
    sequencerMode = mode
    switch(sequencerMode) {
    case SequencerMode.off.rawValue:
      checkError(osstatus: MusicPlayerStop(musicPlayer!))
    case SequencerMode.recording.rawValue:
      startRecording()
    case SequencerMode.playing.rawValue:
      musicPlayerPlay()
    default:
      break
    }
  }
  
  func noteOn(note: UInt8) {
    if sequencerMode == SequencerMode.recording.rawValue {
      noteOnTimes[Int(note)] = Date()
    }
  }
  
  func noteOff(note: UInt8) {
    if sequencerMode == SequencerMode.recording.rawValue {
      let duration: Double = Date().timeIntervalSince(noteOnTimes[Int(note)])
      let onset: Double = noteOnTimes[Int(note)].timeIntervalSince(sequenceStartTime!)
      var beat: MusicTimeStamp = 0
      checkError(osstatus: MusicSequenceGetBeatsForSeconds(musicSequence!, onset, &beat))
      var mess = MIDINoteMessage(channel: sequencerMidiChannel,
                                 note: note,
                                 velocity: midiVelocity,
                                 releaseVelocity: 0,
                                 duration: Float(duration) )
      checkError(osstatus: MusicTrackNewMIDINoteEvent(track!, beat, &mess))
    }
  }
  
  func musicPlayerPlay() {
    var status = noErr
    var playing:DarwinBoolean = false
    checkError(osstatus: MusicPlayerIsPlaying(musicPlayer!, &playing))
    if playing != false {
      status = MusicPlayerStop(musicPlayer!)
      if status != noErr {
        print("Error stopping \(status)")
        checkError(osstatus: status)
        return
      }
    }
    
    checkError(osstatus: MusicPlayerSetTime(musicPlayer!, 0))
    checkError(osstatus: MusicPlayerStart(musicPlayer!))
  }
  
  func startRecording() {
    sequenceStartTime = Date()
    setUpSequencer()
  }
  
  private func setUpSequencer() {
    // set the sequencer voice to storedPatch so we can play along with it using patch
    var status = NewMusicSequence(&musicSequence)
    if status != noErr {
      print("\(#line) bad status \(status) creating sequence")
    }
    
    status = MusicSequenceNewTrack(musicSequence!, &track)
    if status != noErr {
      print("error creating track \(status)")
    }
    
    // 0xB0 = bank select, first we do the most significant byte
    var chanmess = MIDIChannelMessage(status: 0xB0 | sequencerMidiChannel, data1: 0, data2: 0, reserved: 0)
    status = MusicTrackNewMIDIChannelEvent(track!, 0, &chanmess)
    if status != noErr {
      print("creating bank select event \(status)")
    }
    // then the least significant byte
    chanmess = MIDIChannelMessage(status: 0xB0 | sequencerMidiChannel, data1: 32, data2: 0, reserved: 0)
    status = MusicTrackNewMIDIChannelEvent(track!, 0, &chanmess)
    if status != noErr {
      print("creating bank select event \(status)")
    }
    
    // set the voice
    chanmess = MIDIChannelMessage(status: 0xC0 | sequencerMidiChannel, data1: UInt8(patch), data2: 0, reserved: 0)
    status = MusicTrackNewMIDIChannelEvent(track!, 0, &chanmess)
    if status != noErr {
      print("creating program change event \(status)")
    }
    
    checkError(osstatus: MusicSequenceSetAUGraph(musicSequence!, audioGraph))
    checkError(osstatus: NewMusicPlayer(&musicPlayer))
    checkError(osstatus: MusicPlayerSetSequence(musicPlayer!, musicSequence))
    checkError(osstatus: MusicPlayerPreroll(musicPlayer!))
  }
}



