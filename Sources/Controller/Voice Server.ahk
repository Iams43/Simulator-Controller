﻿;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   Modular Simulator Controller System - Voice Server                    ;;;
;;;                                                                         ;;;
;;;   Author:     Oliver Juwig (TheBigO)                                    ;;;
;;;   License:    (2023) Creative Commons - BY-NC-SA                        ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;-------------------------------------------------------------------------;;;
;;;                       Global Declaration Section                        ;;;
;;;-------------------------------------------------------------------------;;;

;@SC-IF %configuration% == Development
#Include "..\Framework\Development.ahk"
;@SC-EndIF

;@SC-If %configuration% == Production
;@SC #Include "..\Framework\Production.ahk"
;@SC-EndIf

;@Ahk2Exe-SetMainIcon ..\..\Resources\Icons\Microphon.ico
;@Ahk2Exe-ExeName Voice Server.exe


;;;-------------------------------------------------------------------------;;;
;;;                         Global Include Section                          ;;;
;;;-------------------------------------------------------------------------;;;

#Include "..\Framework\Process.ahk"


;;;-------------------------------------------------------------------------;;;
;;;                          Local Include Section                          ;;;
;;;-------------------------------------------------------------------------;;;

#Include "..\Libraries\Task.ahk"
#Include "..\Libraries\Messages.ahk"
#Include "..\Libraries\SpeechSynthesizer.ahk"
#Include "..\Libraries\SpeechRecognizer.ahk"


;;;-------------------------------------------------------------------------;;;
;;;                         Public Constant Section                         ;;;
;;;-------------------------------------------------------------------------;;;

global kDebugOff := 0
global kDebugGrammars := 1
global kDebugPhrases := 2
global kDebugRecognitions := 4


;;;-------------------------------------------------------------------------;;;
;;;                          Public Classes Section                         ;;;
;;;-------------------------------------------------------------------------;;;

class VoiceServer extends ConfigurationItem {
	iDebug := kDebugOff

	iVoiceClients := CaseInsenseMap()
	iActiveVoiceClient := false

	iLanguage := "en"
	iSynthesizer := "dotNET"
	iSpeaker := true
	iSpeakerVolume := 100
	iSpeakerPitch := 0
	iSpeakerSpeed := 0
	iRecognizer := "Desktop"
	iListener := false
	iPushToTalk := false

	iSpeechRecognizer := false

	iSpeaking := false
	iListening := false

	iPendingCommands := []
	iHasPendingActivation := false
	iLastCommand := A_TickCount

	class VoiceClient {
		iRouting := false

		iCounter := 1

		iVoiceServer := false
		iDescriptor := false
		iPID := 0

		iLanguage := "en"
		iSynthesizer := "dotNET"
		iSpeaker := true
		iSpeakerVolume := 100
		iSpeakerPitch := 0
		iSpeakerSpeed := 0
		iRecognizer := "Desktop"
		iListener := false

		iSpeechSynthesizer := false

		iMuted := false
		iInterrupted := false
		iInterruptable := true

		iSpeechRecognizer := false
		iSpeaking := false
		iListening := false

		iActivationCallback := false
		iDeactivationCallback := false
		iVoiceCommands := CaseInsenseMap()

		class ClientSpeechSynthesizer extends SpeechSynthesizer {
			iVoiceClient := false

			Routing {
				Get {
					return this.VoiceClient.Routing
				}
			}

			VoiceClient {
				Get {
					return this.iVoiceClient
				}
			}

			__New(voiceClient, arguments*) {
				this.iVoiceClient := voiceClient

				super.__New(arguments*)
			}
		}

		class ClientSpeechRecognizer extends SpeechRecognizer {
			iVoiceClient := false

			Routing {
				Get {
					return this.VoiceClient.Routing
				}
			}

			VoiceClient {
				Get {
					return this.iVoiceClient
				}
			}

			__New(voiceClient, arguments*) {
				this.iVoiceClient := voiceClient

				super.__New(arguments*)
			}
		}

		Routing {
			Get {
				return this.iRouting
			}
		}

		VoiceServer {
			Get {
				return this.iVoiceServer
			}
		}

		Descriptor {
			Get {
				return this.iDescriptor
			}
		}

		PID {
			Get {
				return this.iPID
			}
		}

		Language {
			Get {
				return this.iLanguage
			}
		}

		Synthesizer {
			Get {
				return this.iSynthesizer
			}
		}

		Speaker {
			Get {
				return this.iSpeaker
			}
		}

		Speaking {
			Get {
				return this.iSpeaking
			}
		}

		Recognizer {
			Get {
				return this.iRecognizer
			}
		}

		Listener {
			Get {
				return this.iListener
			}
		}

		Listening {
			Get {
				return this.iListening
			}
		}

		SpeakerVolume {
			Get {
				return this.iSpeakerVolume
			}
		}

		SpeakerPitch {
			Get {
				return this.iSpeakerPitch
			}
		}

		SpeakerSpeed {
			Get {
				return this.iSpeakerSpeed
			}
		}

		ActivationCallback {
			Get {
				return this.iActivationCallback
			}
		}

		DeactivationCallback {
			Get {
				return this.iDeactivationCallback
			}
		}

		VoiceCommands[key := kUndefined] {
			Get {
				if (key != kUndefined)
					return this.iVoiceCommands[key]
				else
					return this.iVoiceCommands
			}

			Set {
				if (key != kUndefined)
					return this.iVoiceCommands[key] := value
				else
					return this.iVoiceCommands := value
			}
		}

		SpeechSynthesizer[create := false] {
			Get {
				if (!this.iSpeechSynthesizer && create && this.Speaker) {
					this.iSpeechSynthesizer := VoiceServer.VoiceClient.ClientSpeechSynthesizer(this, this.Synthesizer, this.Speaker, this.Language)

					this.iSpeechSynthesizer.setVolume(this.SpeakerVolume)
					this.iSpeechSynthesizer.setPitch(this.SpeakerPitch)
					this.iSpeechSynthesizer.setRate(this.SpeakerSpeed)
				}

				return this.iSpeechSynthesizer
			}
		}

		Muted {
			Get {
				return this.iMuted
			}
		}

		Interrupted {
			Get {
				return this.iInterrupted
			}
		}

		Interruptable {
			Get {
				return this.iInterruptable
			}
		}

		SpeechRecognizer[create := false] {
			Get {
				if (!this.iSpeechRecognizer && create && this.Listener)
					this.iSpeechRecognizer := VoiceServer.VoiceClient.ClientSpeechRecognizer(this, this.Recognizer, this.Listener, this.Language)

				return this.iSpeechRecognizer
			}
		}

		__New(voiceServer, descriptor, routing, pid
			, language, synthesizer, speaker, recognizer, listener
			, speakerVolume, speakerPitch, speakerSpeed, activationCallback, deactivationCallback) {
			this.iVoiceServer := voiceServer
			this.iDescriptor := descriptor
			this.iRouting := routing
			this.iPID := pid
			this.iLanguage := language
			this.iSynthesizer := synthesizer
			this.iSpeaker := speaker
			this.iRecognizer := recognizer
			this.iListener := listener
			this.iSpeakerVolume := speakerVolume
			this.iSpeakerPitch := speakerPitch
			this.iSpeakerSpeed := speakerSpeed
			this.iActivationCallback := activationCallback
			this.iDeactivationCallback := deactivationCallback
		}

		speak(text) {
			local tries := 5
			local stopped, oldSpeaking, oldInterruptable

			while this.Muted
				Sleep(100)

			this.iInterrupted := false

			stopped := this.VoiceServer.stopListening()
			oldSpeaking := this.Speaking
			oldInterruptable := this.iInterruptable

			try {
				this.iSpeaking := true
				this.iInterruptable := true

				try {
					while (tries-- > 0) {
						if (tries == 0)
							this.SpeechSynthesizer[true].speak(text, true)
						else {
							if !this.Interrupted
								this.SpeechSynthesizer[true].speak(text, true)

							if this.Interrupted {
								Sleep(2000)

								while this.Muted
									Sleep(100)

								this.iInterrupted := false
							}
							else
								break
						}
					}
				}
				finally {
					this.iInterruptable := oldInterruptable
					this.iSpeaking := oldSpeaking
				}
			}
			finally {
				if stopped
					this.VoiceServer.startListening()
			}
		}

		startListening(retry := true) {
			static audioDevice := getMultiMapValue(readMultiMap(kUserConfigDirectory . "Audio Settings.ini"), "Output", "Activation.AudioDevice", false)

			if (this.SpeechRecognizer[true] && !this.Listening)
				if !this.SpeechRecognizer.startRecognizer() {
					if retry
						Task.startTask(ObjBindMethod(this, "startListening", true), 200)

					return false
				}
				else {
					if this.VoiceServer.PushToTalk
						playSound("VSSoundPlayer.exe", kResourcesDirectory . "Sounds\Talk.wav", audioDevice)

					this.iListening := true

					return true
				}
		}

		stopListening(retry := false) {
			if (this.SpeechRecognizer && this.Listening)
				if !this.SpeechRecognizer.stopRecognizer() {
					if retry
						Task.startTask(ObjBindMethod(this, "stopListening", true), 200)

					return false
				}
				else {
					this.iListening := false

					return true
				}
		}

		mute() {
			local synthesizer := this.SpeechSynthesizer

			if (synthesizer && this.Speaking && !this.Interrupted && this.Interruptable && synthesizer.Stoppable)
					this.iInterrupted := synthesizer.stop()

			if !this.Muted {
				this.iMuted := true

				if synthesizer
					synthesizer.mute()
			}
		}

		unmute() {
			local synthesizer

			if this.Muted {
				this.iMuted := false

				synthesizer := this.SpeechSynthesizer

				if synthesizer
					synthesizer.unmute()
			}
		}

		registerChoices(name, choices*) {
			local recognizer := this.SpeechRecognizer[true]

			recognizer.setChoices(name, values2String(",", choices*))
		}

		registerVoiceCommand(grammar, command, callback) {
			local recognizer := this.SpeechRecognizer[true]
			local key, descriptor, nextCharIndex

			if !grammar {
				for key, descriptor in this.iVoiceCommands
					if ((descriptor[1] = command) && (descriptor[2] = callback))
						return

				grammar := ("__Grammar." . this.iCounter++)
			}
			else if this.VoiceCommands.Has(grammar) {
				descriptor := this.VoiceCommands[grammar]

				if ((descriptor[1] = command) && (descriptor[2] = callback))
					return
			}

			if this.VoiceServer.Debug[kDebugGrammars] {
				nextCharIndex := 1

				showMessage("Register command phrase: " . GrammarCompiler(recognizer).readGrammar(&command, &nextCharIndex).toString())
			}

			try {
				if !recognizer.loadGrammar(grammar, recognizer.compileGrammar(command), ObjBindMethod(this.VoiceServer, "recognizeVoiceCommand", this))
					throw "Recognizer not running..."
			}
			catch Any as exception {
				logError(exception, true)

				logMessage(kLogCritical, translate("Error while registering voice command `"") . command . translate("`" - please check the configuration"))

				showMessage(substituteVariables(translate("Cannot register voice command `"%command%`" - please check the configuration..."), {command: command})
						  , translate("Modular Simulator Controller System"), "Alert.png", 5000, "Center", "Bottom", 800)
			}

			this.VoiceCommands[grammar] := Array(command, callback)
		}

		activate(words := false) {
			if this.ActivationCallback {
				if !words
					words := []

				messageSend(kFileMessage, "Voice", this.ActivationCallback . ":" . values2String(";", words*), this.PID)
			}
		}

		deactivate() {
			if this.DeactivationCallback
				messageSend(kFileMessage, "Voice", this.DeactivationCallback, this.PID)
		}

		recognizeVoiceCommand(grammar, words) {
			if this.VoiceCommands.Has(grammar)
				this.VoiceServer.recognizeVoiceCommand(this, grammar, words)
		}
	}

	class ActivationSpeechRecognizer extends SpeechRecognizer {
		Routing {
			Get {
				return "Activation"
			}
		}
	}

	Debug[option] {
		Get {
			return (this.iDebug & option)
		}
	}

	VoiceClients[key?] {
		Get {
			return (isSet(key) ? this.iVoiceClients[key] : this.iVoiceClients)
		}

		Set {
			return (isSet(key) ? (this.iVoiceClients[key] := value) : (this.iVoiceClients := value))
		}
	}

	ActiveVoiceClient {
		Get {
			return this.iActiveVoiceClient
		}
	}

	Language {
		Get {
			return this.iLanguage
		}
	}

	Synthesizer {
		Get {
			return this.iSynthesizer
		}
	}

	Speaker {
		Get {
			return this.iSpeaker
		}
	}

	Speaking {
		Get {
			return this.iSpeaking
		}
	}

	Recognizer {
		Get {
			return this.iRecognizer
		}
	}

	Listener {
		Get {
			return this.iListener
		}
	}

	Listening {
		Get {
			return this.iListening
		}
	}

	SpeakerVolume {
		Get {
			return this.iSpeakerVolume
		}
	}

	SpeakerPitch {
		Get {
			return this.iSpeakerPitch
		}
	}

	SpeakerSpeed {
		Get {
			return this.iSpeakerSpeed
		}
	}

	PushToTalk {
		Get {
			return this.iPushToTalk
		}
	}

	SpeechRecognizer[create := false] {
		Get {
			local settings

			if (create && this.Listener && !this.iSpeechRecognizer) {
				try {
					try {
						settings := readMultiMap(getFileName("Core Settings.ini", kUserConfigDirectory, kConfigDirectory))

						this.iSpeechRecognizer := VoiceServer.ActivationSpeechRecognizer(getMultiMapValue(settings, "Voice", "Activation Recognizer"
																										, getMultiMapValue(settings, "Voice", "ActivationRecognizer", "Server"))
																					   , true, this.Language, true)

						if (this.iSpeechRecognizer.Recognizers.Length = 0)
							throw "Server speech recognizer engine not installed..."
					}
					catch Any as exception {
						this.iSpeechRecognizer := VoiceServer.ActivationSpeechRecognizer("Desktop", true, this.Language, true)

						if (this.iSpeechRecognizer.Recognizers.Length = 0)
							throw "Desktop speech recognizer engine not installed..."
					}
				}
				catch Any as exception {
					this.iSpeechRecognizer := VoiceServer.ActivationSpeechRecognizer(this.Recognizer, this.Listener, this.Language)
				}

				if !this.PushToTalk
					this.startListening()
			}

			return this.iSpeechRecognizer
		}
	}

	__New(configuration := false) {
		super.__New(configuration)

		VoiceServer.Instance := this

		PeriodicTask(ObjBindMethod(this, "runPendingCommands"), 500).start()
		PeriodicTask(ObjBindMethod(this, "unregisterStaleVoiceClients"), 5000, kLowPriority).start()

		deleteFile(kTempDirectory . "Voice.mute")

		PeriodicTask(ObjBindMethod(this, "muteVoiceClients"), 50, kInterruptPriority).start()
	}

	loadFromConfiguration(configuration) {
		super.loadFromConfiguration(configuration)

		this.iLanguage := getMultiMapValue(configuration, "Voice Control", "Language", getLanguage())
		this.iSynthesizer := getMultiMapValue(configuration, "Voice Control", "Synthesizer"
											, getMultiMapValue(configuration, "Voice Control", "Service", "dotNET"))
		this.iSpeaker := getMultiMapValue(configuration, "Voice Control", "Speaker", true)
		this.iSpeakerVolume := getMultiMapValue(configuration, "Voice Control", "SpeakerVolume", 100)
		this.iSpeakerPitch := getMultiMapValue(configuration, "Voice Control", "SpeakerPitch", 0)
		this.iSpeakerSpeed := getMultiMapValue(configuration, "Voice Control", "SpeakerSpeed", 0)
		this.iRecognizer := getMultiMapValue(configuration, "Voice Control", "Recognizer", "Desktop")
		this.iListener := getMultiMapValue(configuration, "Voice Control", "Listener", false)
		this.iPushToTalk := getMultiMapValue(configuration, "Voice Control", "PushToTalk", false)

		this.initializePushToTalk()
	}

	initializePushToTalk() {
		local p2tHotkey := this.PushToTalk
		local toggle

		if p2tHotkey {
			if FileExist(kUserConfigDirectory . "Core Settings.ini")
				toggle := (getMultiMapValue(readMultiMap(kUserConfigDirectory . "Core Settings.ini"), "Voice", "Push-To-Talk", "Hold") = "Press")
			else
				toggle := false

			if toggle
				Hotkey(p2tHotkey, ObjBindMethod(this, "listen", true), "On")
			else
				PeriodicTask(ObjBindMethod(this, "listen", false), 50, kInterruptPriority).start()
		}
	}

	listen(toggle, down := true) {
		local listen := false
		local pressed := false

		static isPressed := false
		static lastDown := 0
		static lastUp := 0
		static clicks := 0
		static activation := false
		static listening := false

		static listenTask := false

		static speed := getMultiMapValue(readMultiMap(getFileName("Core Settings.ini", kUserConfigDirectory, kConfigDirectory))
									   , "Voice", "Activation Speed", DllCall("GetDoubleClickTime"))

		try
			pressed := toggle ? down : GetKeyState(this.PushToTalk, "P")

		if (pressed && !isPressed) {
			lastDown := A_TickCount
			isPressed := true

			if (((lastDown - lastUp) < speed) && (clicks == 1))
				activation := true
			else {
				clicks := 0

				activation := false
			}
		}
		else if (!pressed && isPressed) {
			lastUp := A_TickCount
			isPressed := false

			if ((lastUp - lastDown) < speed)
				clicks += 1
			else
				clicks := 0
		}

		if toggle {
			if pressed {
				if listenTask {
					listen := true

					listenTask.stop()

					listenTask := false
				}

				if listening {
					this.stopActivationListener()
					this.stopListening()

					if activation
						this.startActivationListener()
					else
						listening := false
				}
				else if activation {
					this.startActivationListener()

					listening := true
				}
				else if listen {
					this.startListening(false)

					listening := true
				}
				else {
					listenTask := Task(ObjBindMethod(this, "listen", true, true), speed, kInterruptPriority)

					Task.startTask(listenTask)
				}
			}

			if down
				this.listen(true, false)
		}
		else {
			if (((A_TickCount - lastDown) < (speed / 2)) && !activation)
				pressed := false

			if (!this.Speaking && pressed) {
				if activation
					this.startActivationListener()
				else
					this.startListening(false)

				listening := true
			}
			else if !pressed {
				this.stopActivationListener()
				this.stopListening()

				listening := false
			}
		}
	}

	setDebug(option, enabled, *) {
		local label := false

		if enabled
			this.iDebug := (this.iDebug | option)
		else if (this.Debug[option] == option)
			this.iDebug := (this.iDebug - option)

		switch option {
			case kDebugRecognitions:
				label := translate("Debug Recognitions")
			case kDebugGrammars:
				label := translate("Debug Grammars")
		}

		if label
			if enabled
				SupportMenu.Check(label)
			else
				SupportMenu.Uncheck(label)
	}

	toggleDebug(option, *) {
		this.setDebug(option, !this.Debug[option])
	}

	getVoiceClient(descriptor := false) {
		try {
			if descriptor
				return this.VoiceClients[descriptor]
			else
				return this.ActiveVoiceClient
		}
		catch Any {
			return this.ActiveVoiceClient
		}
	}

	activateVoiceClient(descriptor, words := false) {
		local activeVoiceClient

		if (this.ActiveVoiceClient && (this.ActiveVoiceClient.Descriptor = descriptor))
			this.ActiveVoiceClient.activate(words)
		else {
			if this.ActiveVoiceClient
				this.deactivateVoiceClient(this.ActiveVoiceClient.Descriptor)

			if this.VoiceClients.Has(descriptor) {
				activeVoiceClient := this.VoiceClients[descriptor]

				this.iActiveVoiceClient := activeVoiceClient

				activeVoiceClient.activate(words)

				if !this.PushToTalk
					this.startListening()
			}
		}
	}

	deactivateVoiceClient(descriptor) {
		local activeVoiceClient := this.ActiveVoiceClient

		if (activeVoiceClient && (activeVoiceClient.Descriptor = descriptor)) {
			activeVoiceClient.stopListening()

			this.iActiveVoiceClient := false

			activeVoiceClient.deactivate()
		}
	}

	startActivationListener(retry := false) {
		static audioDevice := getMultiMapValue(readMultiMap(kUserConfigDirectory . "Audio Settings.ini"), "Output", "Activation.AudioDevice", false)

		if (this.SpeechRecognizer && !this.Listening)
			if !this.SpeechRecognizer.startRecognizer() {
				if retry
					Task.startTask(ObjBindMethod(this, "startActivationListener", true), 200)

				return false
			}
			else {
				if this.PushToTalk
					playSound("VSSoundPlayer.exe", kResourcesDirectory . "Sounds\Talk.wav", audioDevice)

				this.iListening := true

				return true
			}
	}

	stopActivationListener(retry := false) {
		if (this.SpeechRecognizer && this.Listening)
			if !this.SpeechRecognizer.stopRecognizer() {
				if retry
					Task.startTask(ObjBindMethod(this, "stopActivationListener", true), 200)

				return false
			}
			else {
				this.iListening := false

				return true
			}
	}

	startListening(retry := true) {
		local activeClient := this.getVoiceClient()

		return (activeClient ? activeClient.startListening(retry) : false)
	}

	stopListening(retry := false) {
		local activeClient := this.getVoiceClient()

		return (activeClient ? activeClient.stopListening(retry) : false)
	}

	mute() {
		local ignore, client

		for ignore, client in this.VoiceClients
			client.mute()
	}

	unmute() {
		local ignore, client

		for ignore, client in this.VoiceClients
			client.unmute()
	}

	muteVoiceClients() {
		if FileExist(kTempDirectory . "Voice.mute")
			this.mute()
		else
			this.unmute()
	}

	speak(descriptor, text, activate := false) {
		local oldSpeaking := this.Speaking

		if this.Speaking
			Task.startTask(ObjBindMethod(this, "speak", descriptor, text, activate))
		else {
			this.iSpeaking := true

			try {
				this.getVoiceClient(descriptor).speak(text)

				if activate
					this.activateVoiceClient(descriptor)

			}
			catch Any as exception {
				logError(exception)
			}
			finally {
				this.iSpeaking := oldSpeaking
			}
		}
	}

	registerVoiceClient(descriptor, routing, pid
					  , activationCommand := false, activationCallback := false, deactivationCallback := false, language := false
					  , synthesizer := true, speaker := true, recognizer := false, listener := false
					  , speakerVolume := kUndefined, speakerPitch := kUndefined, speakerSpeed := kUndefined) {
		local grammar, client, nextCharIndex, command, theDescriptor, ignore

		static counter := 1

		if (speakerVolume = kUndefined)
			speakerVolume := this.SpeakerVolume

		if (speakerPitch = kUndefined)
			speakerPitch := this.SpeakerPitch

		if (speakerSpeed = kUndefined)
			speakerSpeed := this.SpeakerSpeed

		if (synthesizer == true)
			synthesizer := this.Synthesizer

		if (speaker == true)
			speaker := this.Speaker

		if (recognizer == true)
			recognizer := this.Recognizer

		if (listener == true)
			listener := this.Listener

		if (language == false)
			language := this.Language

		client := (this.VoiceClients.Has(descriptor) ? this.VoiceClients[descriptor] : false)

		if (client && (this.ActiveVoiceClient == client))
			this.deactivateVoiceClient(descriptor)

		client := VoiceServer.VoiceClient(this, descriptor, routing, pid, language, synthesizer, speaker, recognizer, listener, speakerVolume, speakerPitch, speakerSpeed, activationCallback, deactivationCallback)

		this.VoiceClients[descriptor] := client

		if (activationCommand && (StrLen(Trim(activationCommand)) > 0) && listener) {
			recognizer := this.SpeechRecognizer[true]

			grammar := (descriptor . "." . counter++)

			if this.Debug[kDebugGrammars] {
				nextCharIndex := 1

				showMessage("Register activation phrase: " . GrammarCompiler(recognizer).readGrammar(&activationCommand, &nextCharIndex).toString())
			}

			try {
				command := recognizer.compileGrammar(activationCommand)

				if !recognizer.loadGrammar(grammar, command, ObjBindMethod(this, "recognizeActivationCommand", client))
					throw "Recognizer not running..."
			}
			catch Any as exception {
				logError(exception, true)

				logMessage(kLogCritical, translate("Error while registering voice command `"") . activationCommand . translate("`" - please check the configuration"))

				showMessage(substituteVariables(translate("Cannot register voice command `"%command%`" - please check the configuration..."), {command: activationCommand})
						  , translate("Modular Simulator Controller System"), "Alert.png", 5000, "Center", "Bottom", 800)
			}
		}

		if (this.VoiceClients.Count = 1)
			this.activateVoiceClient(descriptor)
		else if (this.VoiceClients.Count > 1) {
			for theDescriptor, ignore in this.VoiceClients
				if (descriptor != theDescriptor)
					this.deactivateVoiceClient(theDescriptor)

			if !this.PushToTalk
				this.startActivationListener()
		}
	}

	unregisterVoiceClient(descriptor, pid) {
		local client := (this.VoiceClients.Has(descriptor) ? this.VoiceClients[descriptor] : false)
		local theDescriptor, ignore

		if (client && (this.ActiveVoiceClient == client))
			this.deactivateVoiceClient(descriptor)

		this.VoiceClients.Delete(descriptor)

		if (this.VoiceClients.Count = 1) {
			for theDescriptor, ignore in this.VoiceClients
				this.activateVoiceClient(theDescriptor)

			if !this.PushToTalk
				this.stopActivationListener()
		}
	}

	unregisterStaleVoiceClients() {
		local descriptor, voiceClient, pid

		protectionOn()

		try {
			for descriptor, voiceClient in this.VoiceClients {
				pid := voiceClient.PID

				if !ProcessExist(pid) {
					this.unregisterVoiceClient(descriptor, pid)

					this.unregisterStaleVoiceClients()

					break
				}
			}
		}
		finally {
			protectionOff()
		}
	}

	registerChoices(descriptor, name, choices*) {
		this.getVoiceClient(descriptor).registerChoices(name, choices*)
	}

	registerVoiceCommand(descriptor, grammar, command, callback) {
		this.getVoiceClient(descriptor).registerVoiceCommand(grammar, command, callback)
	}

	recognizeActivation(descriptor, grammar, words*) {
		try {
			local voiceClient := (this.VoiceClients.Has(descriptor) ? this.VoiceClients[descriptor] : false)

			if voiceClient
				this.recognizeActivationCommand(voiceClient, voiceClient.Descriptor, words)
		}
		catch Any as exception {
			logError(exception)
		}
	}

	recognizeCommand(grammar, words*) {
		local ignore, voiceClient

		for ignore, voiceClient in this.VoiceClients
			voiceClient.recognizeVoiceCommand(grammar, words)
	}

	recognizeActivationCommand(voiceClient, grammar, words) {
		this.addPendingCommand(ObjBindMethod(this, "activationCommandRecognized", voiceClient, grammar, words), voiceClient)
	}

	recognizeVoiceCommand(voiceClient, grammar, words) {
		this.addPendingCommand(ObjBindMethod(this, "voiceCommandRecognized", voiceClient, grammar, words))
	}

	addPendingCommand(command, activation := false) {
		if activation
			if (activation != this.ActiveVoiceClient)
				this.iPendingCommands := []
			else if (this.iPendingCommands.Length > 0)
				return

		this.iLastCommand := A_TickCount

		if !activation
			this.clearPendingActivations()

		this.iPendingCommands.Push(Array(activation, command))
	}

	clearPendingActivations() {
		local index, command

		for index, command in this.iPendingCommands
			if command[1] {
				this.iPendingCommands.RemoveAt(index)

				this.clearPendingActivations()

				break
			}
	}

	runPendingCommands() {
		local command

		if (A_TickCount < (this.iLastCommand + 1000))
			return

		protectionOn()

		try {
			if (this.iPendingCommands.Length == 0)
				return
			else {
				command := this.iPendingCommands.RemoveAt(1)

				if command {
					command := command[2]

					command.Call()
				}
			}
		}
		finally {
			protectionOff()
		}
	}

	activationCommandRecognized(voiceClient, grammar, words) {
		if this.Debug[kDebugRecognitions]
			showMessage("Activation phrase recognized: " . values2String(A_Space, words*))

		this.activateVoiceClient(ConfigurationItem.splitDescriptor(grammar)[1], words)
	}

	voiceCommandRecognized(voiceClient, grammar, words) {
		local descriptor := voiceClient.VoiceCommands[grammar]

		if this.Debug[kDebugRecognitions]
			showMessage("Command phrase recognized: " . grammar . " => " . values2String(A_Space, words*), false, "Information.png", 5000)

		messageSend(kFileMessage, "Voice", descriptor[2] . ":" . values2String(";", grammar, descriptor[1], words*), voiceClient.PID)
	}
}

;;;-------------------------------------------------------------------------;;;
;;;                   Private Function Declaration Section                  ;;;
;;;-------------------------------------------------------------------------;;;

startupVoiceServer() {
	local icon := kIconsDirectory . "Microphon.ico"
	local debug, index, server, label

	TraySetIcon(icon, "1")
	A_IconTip := "Voice Server"

	debug := false

	index := 1

	while (index < A_Args.Length) {
		switch A_Args[index], false {
			case "-Debug":
				debug := (((A_Args[index + 1] = kTrue) || (A_Args[index + 1] = true)) ? true : false)
				index += 2
			default:
				index += 1
		}
	}

	if debug
		setDebug(true)

	server := VoiceServer(kSimulatorConfiguration)

	SupportMenu.Insert("1&")

	label := translate("Debug Recognitions")

	SupportMenu.Insert("1&", label, ObjBindMethod(server, "toggleDebug", kDebugRecognitions))

	if server.Debug[kDebugRecognitions]
		SupportMenu.Check(label)

	label := translate("Debug Grammars")

	SupportMenu.Insert("1&", label, ObjBindMethod(server, "toggleDebug", kDebugGrammars))

	if server.Debug[kDebugGrammars]
		SupportMenu.Check(label)

	registerMessageHandler("Voice", handleVoiceMessage)

	return
}


;;;-------------------------------------------------------------------------;;;
;;;                         Message Handler Section                         ;;;
;;;-------------------------------------------------------------------------;;;

handleVoiceMessage(category, data) {
	if InStr(data, ":") {
		data := StrSplit(data, ":", , 2)

		if (data[1] = "Shutdown") {
			Sleep(30000)

			ExitApp(0)
		}

		return withProtection(ObjBindMethod(VoiceServer.Instance, data[1]), string2Values(";", data[2])*)
	}
	else if (data = "Shutdown") {
		Sleep(30000)

		ExitApp(0)
	}
	else
		return withProtection(ObjBindMethod(VoiceServer.Instance, data))
}


;;;-------------------------------------------------------------------------;;;
;;;                          Initialization Section                         ;;;
;;;-------------------------------------------------------------------------;;;

startupVoiceServer()