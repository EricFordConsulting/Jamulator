/**
 * Copyright (c) 2017 Eric Ford Consulting
 */

import CoreAudio
import AudioKit

final class SoftSynth : AudioCommon {
  override init()
  {
    super.init()
    initAudio()
    loadSoundFont()
    loadPatch(patchNo: 0)
  }
  
  var octave                = 4
  let midiChannel           = 0
  var midiVelocity          = UInt8(127)
  
  func playNoteOn(channel: Int, note: UInt8, midiVelocity: Int) {
    let noteCommand = UInt32(0x90 | channel)
    let base = note - 48
    let octaveAdjust = (UInt8(octave) * 12) + base
    let pitch = UInt32(octaveAdjust)
    checkError(osstatus: MusicDeviceMIDIEvent(synthUnit!, noteCommand, pitch, UInt32(midiVelocity), 0))
    Sequencer.shared.noteOn(note: UInt8(pitch))
  }
  
  func playNoteOff(channel: Int, note: UInt32, midiVelocity: Int) {
    let noteCommand = UInt32(0x80 | channel)
    let base = UInt8(note - 48)
    let octaveAdjust = (UInt8(octave) * 12) + base
    let pitch = UInt32(octaveAdjust)
    checkError(osstatus: MusicDeviceMIDIEvent(synthUnit!, noteCommand, pitch, 0, 0))
    Sequencer.shared.noteOff(note: UInt8(pitch))
  }
}

