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

class AudioCommon
{
  var audioGraph:     AUGraph?
  var synthNode       = AUNode()
  var outputNode      = AUNode()
  var synthUnit:      AudioUnit?
  var patch           = UInt32(0)
  
  func initAudio() {
    checkError(osstatus: NewAUGraph(&audioGraph))
    createOutputNode(audioGraph: audioGraph!, outputNode: &outputNode)
    createSynthNode()
    checkError(osstatus: AUGraphOpen(audioGraph!))
    // get the synth unit
    checkError(osstatus: AUGraphNodeInfo(audioGraph!, synthNode, nil, &synthUnit))
    let synthOutputElement: AudioUnitElement = 0
    let ioUnitInputElement: AudioUnitElement = 0
    checkError(osstatus:
      AUGraphConnectNodeInput(audioGraph!, synthNode, synthOutputElement,
                              outputNode, ioUnitInputElement))
    checkError(osstatus: AUGraphInitialize(audioGraph!))
    checkError(osstatus: AUGraphStart(audioGraph!))
    loadSoundFont()
    loadPatch(patchNo: 0)
  }
  
  // Mark: - Audio Init Utility Methods
  func createOutputNode(audioGraph: AUGraph, outputNode: UnsafeMutablePointer<AUNode>) {
    var cd = AudioComponentDescription(
      componentType: OSType(kAudioUnitType_Output),
      componentSubType: OSType(kAudioUnitSubType_RemoteIO),
      componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
      componentFlags: 0,componentFlagsMask: 0)
    checkError(osstatus: AUGraphAddNode(audioGraph, &cd, outputNode))
  }
  
  func createSynthNode() {
    var cd = AudioComponentDescription(
      componentType: OSType(kAudioUnitType_MusicDevice),
      componentSubType: OSType(kAudioUnitSubType_MIDISynth),
      componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
      componentFlags: 0,componentFlagsMask: 0)
    checkError(osstatus: AUGraphAddNode(audioGraph!, &cd, &synthNode))
  }
  
  // In the simulator this takes a long time, so we
  //  call it in a background thread in the controller
  func loadSoundFont() {
    var bankURL = Bundle.main.url(forResource: "FluidR3_GM", withExtension: "sf2")
    checkError(osstatus: AudioUnitSetProperty(synthUnit!, AudioUnitPropertyID(kMusicDeviceProperty_SoundBankURL), AudioUnitScope(kAudioUnitScope_Global), 0, &bankURL, UInt32(MemoryLayout<URL>.size)))
  }
  
  func loadPatch(patchNo: Int) {
    let channel = UInt32(0)
    var enabled = UInt32(1)
    var disabled = UInt32(0)
    patch = UInt32(patchNo)
    
    checkError(osstatus: AudioUnitSetProperty(
      synthUnit!,
      AudioUnitPropertyID(kAUMIDISynthProperty_EnablePreload),
      AudioUnitScope(kAudioUnitScope_Global),
      0,
      &enabled,
      UInt32(MemoryLayout<UInt32>.size)))
    
    let programChangeCommand = UInt32(0xC0 | channel)
    checkError(osstatus: MusicDeviceMIDIEvent(self.synthUnit!, programChangeCommand, patch, 0, 0))
    
    checkError(osstatus: AudioUnitSetProperty(
      synthUnit!,
      AudioUnitPropertyID(kAUMIDISynthProperty_EnablePreload),
      AudioUnitScope(kAudioUnitScope_Global),
      0,
      &disabled,
      UInt32(MemoryLayout<UInt32>.size)))
    
    // the previous programChangeCommand just triggered a preload
    // this one actually changes to the new voice
    checkError(osstatus: MusicDeviceMIDIEvent(synthUnit!, programChangeCommand, patch, 0, 0))
  }
  
  func checkError(osstatus: OSStatus) {
    if osstatus != noErr {
      print(SoundError.GetErrorMessage(osstatus))
    }
  }
}
