﻿;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   Modular Simulator Controller System - Voice Control Plugin            ;;;
;;;                                                                         ;;;
;;;   Author:     Oliver Juwig (TheBigO)                                    ;;;
;;;   License:    (2025) Creative Commons - BY-NC-SA                        ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;-------------------------------------------------------------------------;;;
;;;                        Controller Action Section                        ;;;
;;;-------------------------------------------------------------------------;;;

targetListener(target) {
	while FileExist(kTempDirectory . "Voice.cmd")
		deleteFile(kTempDirectory . "Voice.cmd")

	FileAppend("Target:" . target, kTempDirectory . "Voice.cmd")
}

startActivation() {
	while FileExist(kTempDirectory . "Voice.cmd")
		deleteFile(kTempDirectory . "Voice.cmd")

	FileAppend("Activation", kTempDirectory . "Voice.cmd")
}

startListen() {
	while FileExist(kTempDirectory . "Voice.cmd")
		deleteFile(kTempDirectory . "Voice.cmd")

	FileAppend("Listen", kTempDirectory . "Voice.cmd")
}

stopListen() {
	while FileExist(kTempDirectory . "Voice.cmd")
		deleteFile(kTempDirectory . "Voice.cmd")

	FileAppend("Stop", kTempDirectory . "Voice.cmd")
}

enableVoiceRecognition() {
	while FileExist(kTempDirectory . "Voice.cmd")
		deleteFile(kTempDirectory . "Voice.cmd")

	FileAppend("Enable", kTempDirectory . "Voice.cmd")
}

disableVoiceRecognition() {
	while FileExist(kTempDirectory . "Voice.cmd")
		deleteFile(kTempDirectory . "Voice.cmd")

	FileAppend("Disable", kTempDirectory . "Voice.cmd")
}