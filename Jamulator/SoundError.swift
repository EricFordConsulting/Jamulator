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

import AudioToolbox

class SoundError {
  class func GetErrorMessage (_ osstatus:OSStatus) -> String {
    switch(osstatus)
    {
    case kAUGraphErr_NodeNotFound:
        return "AUGraph Node Not Found"
        
    case kAUGraphErr_OutputNodeErr:
        return "AUGraph Output Node Error"
        
    case kAUGraphErr_InvalidConnection:
        return "AUGraph Invalid Connection"
        
    case kAUGraphErr_CannotDoInCurrentContext:
        return "AUGraph Cannot Do In Current Context"
        
    case kAUGraphErr_InvalidAudioUnit:
        return "AUGraph Invalid Audio Unit"
        
    case kMIDIInvalidClient :
        return "MIDI Invalid Client"
        
    case kMIDIInvalidPort :
        return "MIDI Invalid Port"
        
    case kMIDIWrongEndpointType :
        return "MIDI Wrong Endpoint Type"
        
    case kMIDINoConnection :
        return "MIDI No Connection"
        
    case kMIDIUnknownEndpoint :
        return "MIDI Unknown Endpoint"
        
    case kMIDIUnknownProperty :
        return "MIDI Unknown Property"
        
    case kMIDIWrongPropertyType :
        return "MIDI Wrong Property Type"
        
    case kMIDINoCurrentSetup :
        return "MIDI No Current Setup"
        
    case kMIDIMessageSendErr :
        return "MIDI Message Send Error"
        
    case kMIDIServerStartErr :
        return "MIDI Server Start Error"
        
    case kMIDISetupFormatErr :
        return "MIDI Setup Format Error"
        
    case kMIDIWrongThread :
        return "MIDI Wrong Thread"
        
    case kMIDIObjectNotFound :
        return "MIDI Object Not Found"
        
    case kMIDIIDNotUnique :
        return "MIDI ID Not Unique"
                    
    case kAudioToolboxErr_InvalidSequenceType :
        return "AudioToolbox Invalid Sequence Type"
        
    case kAudioToolboxErr_TrackIndexError :
        return "AudioToolbox Track Index Error"
        
    case kAudioToolboxErr_TrackNotFound :
        return "AudioToolbox Track Not Found"
        
    case kAudioToolboxErr_EndOfTrack :
        return "AudioToolbox End Of Track"
        
    case kAudioToolboxErr_StartOfTrack :
        return "AudioToolbox Start Of Track"
        
    case kAudioToolboxErr_IllegalTrackDestination:
        return "AudioToolbox Illegal Track Destination"
        
    case kAudioToolboxErr_NoSequence :
        return "AudioToolbox No Sequence"
        
    case kAudioToolboxErr_InvalidEventType	:
        return "AudioToolbox Invalid Event Type"
        
    case kAudioToolboxErr_InvalidPlayerState:
        return "AudioToolbox Invalid Player State"
        
    case kAudioUnitErr_InvalidProperty	:
        return "AudioUnit Invalid Property"
        
    case kAudioUnitErr_InvalidParameter	:
        return "AudioUnit Invalid Parameter"
        
    case kAudioUnitErr_InvalidElement :
        return "AudioUnit Invalid Element"
        
    case kAudioUnitErr_NoConnection	:
        return "AudioUnit No Connection"
        
    case kAudioUnitErr_FailedInitialization	:
        return "AudioUnit Failed Initialization"

    case kAudioUnitErr_InvalidFile:
        return "AudioUnit Invalid File"
        
    case kAudioUnitErr_FormatNotSupported :
        return "AudioUnit Format Not Supported"
        
    case kAudioUnitErr_Uninitialized:
        return "AudioUnit Uninitialized"
        
    case kAudioUnitErr_InvalidScope :
        return "AudioUnit InvalidScope"
        
    case kAudioUnitErr_PropertyNotWritable :
        return "AudioUnit Property Not Writable"
        
    case kAudioUnitErr_InvalidPropertyValue :
        return "AudioUnitErr_InvalidPropertyValue"
        
    case kAudioUnitErr_PropertyNotInUse :
        return "kAudioUnit Property Not In Use"
        
    case kAudioUnitErr_Initialized :
        return "AudioUnitErr_Initialized"
        
    case kAudioUnitErr_InvalidOfflineRender :
        return "kAudioUnit Invalid Offline Render"
        
    case kAudioUnitErr_Unauthorized :
        return "AudioUnit Unauthorized"
        
    case kAudioUnitErr_CannotDoInCurrentContext:
        return "AudioUnit Cannot Do In Current Context"
        
    case kAudioUnitErr_FileNotSpecified:
        return "AudioUnit File Not Specified"
        
    case kAudioUnitErr_FormatNotSupported:
        return "AudioUnit Format Not Supported"
        
    case kAudioUnitErr_IllegalInstrument:
        return "AudioUnit Illegal Instrument"
        
    case kAudioUnitErr_Initialized:
        return "AudioUnit Initialized"
        
    case kAudioUnitErr_InstrumentTypeNotFound:
        return "AudioUnit Instrument Type Not Found"
        
    case kAudioUnitErr_InvalidFile:
        return "AudioUnit Invalid File"
        
    case kAudioUnitErr_InvalidOfflineRender:
        return "AudioUnit Invalid Offline Render"
        
    case kAudioUnitErr_InvalidScope:
        return "AudioUnit Invalid Scope"
        
    case kAudioUnitErr_PropertyNotInUse:
        return "AudioUnit Property Not In Use"
        
    case kAudioUnitErr_PropertyNotWritable:
        return "AudioUnit Property Not Writable"
        
    case kAudioUnitErr_TooManyFramesToProcess:
        return "AudioUnit Too Many Frames To Process"
        
    case kAudioUnitErr_UnknownFileType:
        return "AudioUnit Unknown File Type"
        
    case kAudioComponentErr_InstanceInvalidated:
        return "AudioComponent Instance Invalidated"
        
    case kAudioComponentErr_DuplicateDescription:
        return "AudioComponent Duplicate Description"
        
    case kAudioComponentErr_UnsupportedType:
        return "AudioComponent Unsupported Type"
        
    case kAudioComponentErr_TooManyInstances:
        return "AudioComponent Too Many Instances"
        
    case kAudioComponentErr_NotPermitted:
        return "AudioComponent Not Permitted "
        
    case kAudioComponentErr_InitializationTimedOut:
        return "AudioComponent Initialization Timed Out"
        
    case kAudioComponentErr_InvalidFormat:
        return "AudioComponent Invalid Format"
        
    case kAudio_UnimplementedError :
        return "Audio Unimplemented Error"
        
    case kAudio_FileNotFoundError :
        return "Audio File Not Found Error"
        
    case kAudio_FilePermissionError :
        return "Audio File Permission Error"
        
    case kAudio_TooManyFilesOpenError :
        return "Audio Too Many Files Open Error"
        
    case kAudio_BadFilePathError :
        return "Audio Bad File Path Error"
        
    case kAudio_ParamError :
        return "Audio Param Error"
        
    case kAudio_MemFullError :
        return "Audio Mem Full Error"
        
    default:
        return "Unknown Audio Error"
    }
  }
}
