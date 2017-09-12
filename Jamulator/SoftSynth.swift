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

