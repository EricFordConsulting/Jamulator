/**
 * Copyright (c) 2017 Eric Ford Consulting
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
