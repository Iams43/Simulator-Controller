;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   Modular Simulator Controller System - System Plugin (required)        ;;;
;;;                                                                         ;;;
;;;   Author:     Oliver Juwig (TheBigO)                                    ;;;
;;;   License:    (2023) Creative Commons - BY-NC-SA                        ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;-------------------------------------------------------------------------;;;
;;;                         Local Include Section                           ;;;
;;;-------------------------------------------------------------------------;;;

#Include ..\Libraries\Task.ahk
#Include ..\Libraries\Messages.ahk


;;;-------------------------------------------------------------------------;;;
;;;                         Public Constant Section                         ;;;
;;;-------------------------------------------------------------------------;;;

global kSystemPlugin := "System"
global kLaunchMode := "Launch"


;;;-------------------------------------------------------------------------;;;
;;;                          Public Classes Section                         ;;;
;;;-------------------------------------------------------------------------;;;

class SystemPlugin extends ControllerPlugin {
	iChildProcess := false
	iLaunchMode := false
	iMouseClicked := false
	iStartupSongIsPlaying := false
	iRunnableApplications := []
	iModeSelectors := []

	class RunnableApplication extends Application {
		iIsRunning := false
		iLaunchpadFunction := false
		iLaunchpadAction := false

		LaunchpadFunction[] {
			Get {
				return this.iLaunchpadFunction
			}
		}

		LaunchpadAction[] {
			Get {
				return this.iLaunchpadAction
			}
		}

		updateRunningState() {
			local isRunning := this.isRunning()
			local stateChange := false
			local transition := false
			local controller

			if (isRunning != this.iIsRunning) {
				this.iIsRunning := isRunning

				stateChange := true

				trayMessage(translate(kSystemPlugin), (isRunning ? translate("Start: ") : translate("Stop: ")) . this.Application)
			}

			if !stateChange {
				transition := (this.LaunchpadAction ? this.LaunchpadAction.Transition : false)

				if (transition && ((A_TickCount - transition) > 10000)) {
					transition := false
					stateChange := true

					this.LaunchpadAction.endTransition()
				}
			}
			else if this.LaunchpadAction
				this.LaunchpadAction.endTransition()

			if (this.LaunchpadFunction != false) {
				controller := SimulatorController.Instance

				if (inList(controller.ActiveModes, controller.findMode(kSystemPlugin, kLaunchMode))) {
					if transition
						this.LaunchpadFunction.setLabel(this.LaunchpadAction.Label, "Gray")
					else
						this.LaunchpadFunction.setLabel(this.LaunchpadAction.Label, isRunning ? "Green" : "Black")
				}
			}
		}

		connectAction(function, action) {
			this.iLaunchpadFunction := function
			this.iLaunchpadAction := action
		}
	}

	class LaunchMode extends ControllerMode {
		Mode[] {
			Get {
				return kLaunchMode
			}
		}
	}

	class ModeSelectorAction extends ControllerAction {
		Label[] {
			Get {
				local controller := this.Controller
				local mode := controller.ActiveMode[controller.findFunctionController(this.Function)]

				if mode
					return mode.Mode
				else
					return StrReplace(translate("Mode Selector"), A_Space, "`n")
			}
		}

		fireAction(function, trigger) {
			local controller := this.Controller

			controller.rotateMode(((trigger == "Off") || (trigger = kDecrease)) ? -1 : 1, Array(controller.findFunctionController(function)))

			this.Function.setLabel(controller.findPlugin(kSystemPlugin).actionLabel(this))
		}
	}

	class LaunchAction extends ControllerAction {
		iApplication := false
		iTransition := false

		Application[] {
			Get {
				return this.iApplication
			}
		}

		Transition[] {
			Get {
				return this.iTransition
			}
		}

		__New(function, label, icon, name) {
			this.iApplication := new Application(name, function.Controller.Configuration)

			base.__New(function, label, icon)
		}

		fireAction(function, trigger) {
			if !this.Transition {
				if (inList(function.Controller.ActiveModes, function.Controller.findMode(kSystemPlugin, kLaunchMode))) {
					this.beginTransition()

					function.setLabel(this.Label, "Gray")
				}

				if !this.Application.isRunning()
					this.Application.startup()
				else
					this.Application.shutdown()
			}
		}

		beginTransition() {
			this.iTransition := A_TickCount
		}

		endTransition() {
			this.iTransition := false
		}
	}

	class LogoToggleAction extends ControllerAction {
		iLogoIsVisible := false

		fireAction(function, trigger) {
			this.Controller.showLogo(this.iLogoIsVisible := !this.iLogoIsVisible)
		}
	}

	class SystemShutdownAction extends ControllerAction {
		fireAction(function, trigger) {
			shutdownSystem()
		}
	}

	ChildProcess[] {
		Get {
			return this.iChildProcess
		}
	}

	ModeSelectors[] {
		Get {
			return this.iModeSelectors
		}
	}

	RunnableApplications[] {
		Get {
			return this.iRunnableApplications
		}
	}

	MouseClicked[] {
		Get {
			return this.iMouseClicked
		}
	}

	__New(controller, name, configuration := false, register := true) {
		local function, action, ignore, descriptor, arguments

		if inList(A_Args, "-Startup")
			this.iChildProcess := true

		base.__New(controller, name, configuration, false)

		if (this.Active || isDebug()) {
			for ignore, descriptor in string2Values(A_Space, this.getArgumentValue("modeSelector", ""))
				if (descriptor != false) {
					function := controller.findFunction(descriptor)

					if (function != false) {
						action := new this.ModeSelectorAction(function, "", this.getIcon("ModeSelector.Activate"))

						this.iModeSelectors.Push(action)

						this.registerAction(action)
					}
					else
						this.logFunctionNotFound(descriptor)
				}

			for ignore, arguments in string2Values(",", this.getArgumentValue("launchApplications", ""))
				this.createLaunchAction(controller, this.parseValues(A_Space, arguments)*)

			descriptor := this.getArgumentValue("logo", false)

			if (descriptor != false) {
				function := controller.findFunction(descriptor)

				if (function != false) {
					if !this.iLaunchMode
						this.iLaunchMode := new this.LaunchMode(this)

					this.iLaunchMode.registerAction(new this.LogoToggleAction(function, ""))
				}
				else
					this.logFunctionNotFound(descriptor)
			}

			descriptor := this.getArgumentValue("shutdown", false)

			if (descriptor != false) {
				function := controller.findFunction(descriptor)

				if (function != false) {
					if !this.iLaunchMode
						this.iLaunchMode := new this.LaunchMode(this)

					this.iLaunchMode.registerAction(new this.SystemShutdownAction(function, "Shutdown"))
				}
				else
					this.logFunctionNotFound(descriptor)
			}

			if this.iLaunchMode
				this.registerMode(this.iLaunchMode)

			if register
				controller.registerPlugin(this)

			this.initializeBackgroundTasks()
		}
	}

	loadFromConfiguration(configuration) {
		local action, function, descriptor, name, appDescriptor, runnable

		base.loadFromConfiguration(configuration)

		for descriptor, name in getConfigurationSectionValues(configuration, "Applications", Object())
			this.RunnableApplications.Push(new this.RunnableApplication(name, configuration))

		for descriptor, appDescriptor in getConfigurationSectionValues(configuration, "Launchpad", Object()) {
			function := this.Controller.findFunction(descriptor)

			if (function != false) {
				appDescriptor := string2Values("|", appDescriptor)

				runnable := this.findRunnableApplication(appDescriptor[2])

				if (runnable != false) {
					action := new this.LaunchAction(function, appDescriptor[1], this.getIcon("Launch.Activate"), appDescriptor[2])

					if !this.iLaunchMode
						this.iLaunchMode := new this.LaunchMode(this)

					this.iLaunchMode.registerAction(action)

					runnable.connectAction(function, action)
				}
				else
					logMessage(kLogWarn, translate("Application ") . appDescriptor[2] . translate(" not found in plugin ") . translate(this.Plugin) . translate(" - please check the configuration"))
			}
			else
				this.logFunctionNotFound(descriptor)
		}
	}

	createLaunchAction(controller, label, application, function) {
		local runnable, action

		function := this.Controller.findFunction(function)

		if (function != false) {
			runnable := this.findRunnableApplication(application)

			if (runnable != false) {
				action := new this.LaunchAction(function, label, this.getIcon("Launch.Activate"), application)

				if !this.iLaunchMode
					this.iLaunchMode := new this.LaunchMode(this)

				this.iLaunchMode.registerAction(action)

				runnable.connectAction(function, action)
			}
		}
		else
			logMessage(kLogWarn, translate("Application ") . application . translate(" not found in plugin ") . translate(this.Plugin) . translate(" - please check the configuration"))
	}

	writePluginState(configuration) {
		if this.Active
			setConfigurationValue(configuration, this.Plugin, "State", "Active")
		else
			base.writePluginState(configuration)
	}

	simulatorStartup(simulator) {
		local fileName

		if this.ChildProcess {
			; Looks like we have recurring deadlock situations with bidirectional pipes in case of process exit situations...
			;
			; sendMessage(kPipeMessage, "Startup", "exitStartup")
			;
			; Using a sempahore file instead...

			fileName := (kTempDirectory . "Startup.semaphore")

			deleteFile(fileName)
		}

		base.simulatorStartup(simulator)
	}

	findRunnableApplication(name) {
		local ignore, candidate

		for ignore, candidate in this.RunnableApplications
			if (name == candidate.Application)
				return candidate

		return false
	}

	mouseClick(clicked := true) {
		this.iMouseClicked := clicked
	}

	playStartupSong(songFile) {
		if (!kSilentMode && !this.iStartupSongIsPlaying) {
			try {
				songFile := getFileName(songFile, kUserSplashMediaDirectory, kSplashMediaDirectory)

				if FileExist(songFile) {
					SoundPlay %songFile%

					this.iStartupSongIsPlaying := true
				}
			}
			catch exception {
				logError(exception)
			}
		}
	}

	stopStartupSong(callback := false) {
		local masterVolume

		if this.iStartupSongIsPlaying
			masterVolume := fadeOut()

		try {
			SoundPlay NonExistent.avi
		}
		catch exception {
			logError(exception)
		}

		if this.iStartupSongIsPlaying {
			if callback
				%callback%()

			fadeIn(masterVolume)
		}

		this.iStartupSongIsPlaying := false
	}

	initializeBackgroundTasks() {
		new PeriodicTask("updateApplicationStates", 5000, kLowPriority).start()
		new PeriodicTask("updateModeSelector", 500, kLowPriority).start()
	}
}


;;;-------------------------------------------------------------------------;;;
;;;                   Private Function Declaration Section                  ;;;
;;;-------------------------------------------------------------------------;;;

fadeOut() {
	local masterVolume, currentVolume

	SoundGet masterVolume, MASTER

	currentVolume := masterVolume

	loop {
		currentVolume -= 5

		if (currentVolume <= 0)
			break
		else {
			SoundSet %currentVolume%, MASTER

			Sleep 100
		}
	}

	return masterVolume
}

fadeIn(masterVolume) {
	local currentVolume := 0

	loop {
		currentVolume += 5

		if (currentVolume >= masterVolume)
			break
		else {
			SoundSet %currentVolume%, MASTER

			Sleep 100
		}
	}

	SoundSet %masterVolume%, MASTER
}

mouseClicked(clicked := true) {
	SimulatorController.Instance.findPlugin(kSystemPlugin).mouseClick(clicked)
}

restoreSimulatorVolume() {
	local pid, simulator

	if kNirCmd
		try {
			simulator := SimulatorController.Instance.ActiveSimulator

			if (simulator != false) {
				pid := (new Application(simulator, SimulatorController.Instance.Configuration)).CurrentPID

				Run "%kNirCmd%" setappvolume /%pid% 1.0
			}
		}
		catch exception {
			showMessage(substituteVariables(translate("Cannot start NirCmd (%kNirCmd%) - please check the configuration..."))
					  , translate("Modular Simulator Controller System"), "Alert.png", 5000, "Center", "Bottom", 800)
		}
}

muteSimulator() {
	local simulator := SimulatorController.Instance.ActiveSimulator
	local pid

	if (simulator != false) {
		SetTimer muteSimulator, Off

		Sleep 5000

		if kNirCmd
			try {
				pid := (new Application(simulator, SimulatorController.Instance.Configuration)).CurrentPID

				Run "%kNirCmd%" setappvolume /%pid% 0.0
			}
			catch exception {
				showMessage(substituteVariables(translate("Cannot start NirCmd (%kNirCmd%) - please check the configuration..."))
						  , translate("Modular Simulator Controller System"), "Alert.png", 5000, "Center", "Bottom", 800)
			}

		SetTimer unmuteSimulator, 500

		mouseClicked(false)

		HotKey Escape, mouseClicked
		HotKey ~LButton, mouseClicked
	}
}

unmuteSimulator() {
	local plugin := SimulatorController.Instance.findPlugin(kSystemPlugin)

	if (plugin.MouseClicked || GetKeyState("LButton") || GetKeyState("Escape")) {
		HotKey ~LButton, Off
		HotKey Escape, Off

		SetTimer unmuteSimulator, Off

		plugin.stopStartupSong("restoreSimulatorVolume")
	}
}

updateApplicationStates() {
	local ignore, runnable

	static plugin := false
	static controller := false
	static mode:= false

	if !plugin {
		controller := SimulatorController.Instance
		plugin := controller.findPlugin(kSystemPlugin)
		mode := plugin.findMode(kLaunchMode)
	}

	if inList(controller.ActiveModes, mode) {
		protectionOn()

		try {
			for ignore, runnable in plugin.RunnableApplications
				runnable.updateRunningState()
		}
		finally {
			protectionOff()
		}
	}
}

updateModeSelector() {
	local function, ignore, selector, currentMode, nextUpdate

	static modeSelectorMode := false
	static controller := false
	static plugin := false

	if !controller {
		controller := SimulatorController.Instance
		plugin := controller.findPlugin(kSystemPlugin)
	}

	protectionOn()

	try {
		for ignore, selector in plugin.ModeSelectors {
			function := selector.Function

			if modeSelectorMode {
				currentMode := controller.ActiveMode[controller.findFunctionController(function)]

				if currentMode
					currentMode := currentMode.Mode
				else
					currentMode := StrReplace(translate("Mode Selector"), A_Space, "`n")
			}
			else
				currentMode := StrReplace(translate("Mode Selector"), A_Space, "`n")

			if modeSelectorMode
				function.setLabel(translate(currentMode))
			else
				function.setLabel(currentMode, "Gray")
		}

		nextUpdate := (modeSelectorMode ? 2000 : 1000)

		modeSelectorMode := !modeSelectorMode
	}
	finally {
		protectionOff()
	}

	Task.CurrentTask.Sleep := nextUpdate
}

initializeSystemPlugin() {
	local controller := SimulatorController.Instance

	new SystemPlugin(controller, kSystemPlugin, controller.Configuration)

	registerMessageHandler("Startup", "functionMessageHandler")
}


;;;-------------------------------------------------------------------------;;;
;;;                         Message Handler Section                         ;;;
;;;-------------------------------------------------------------------------;;;

startupApplication(application, silent := true) {
	local runnable := SimulatorController.Instance.findPlugin(kSystemPlugin).findRunnableApplication(application)

	if (runnable != false)
		if runnable.isRunning()
			return true
		else
			return (runnable.startup(!silent) != 0)
	else
		return false
}

startupComponent(component) {
	startupApplication(component, false)
}

startupSimulator(simulator, silent := false) {
	startupApplication(simulator, silent)
}

shutdownSimulator(simulator) {
	local runnable := SimulatorController.Instance.findPlugin(kSystemPlugin).findRunnableApplication(simulator)

	if (runnable != false)
		runnable.shutdown()

	return false
}

playStartupSong(songFile) {
	SimulatorController.Instance.findPlugin(kSystemPlugin).playStartupSong(songFile)

	SetTimer muteSimulator, 1000
}

stopStartupSong() {
	SimulatorController.Instance.findPlugin(kSystemPlugin).stopStartupSong()

	SetTimer muteSimulator, Off
}

startupExited() {
	SimulatorController.Instance.findPlugin(kSystemPlugin).iChildProcess := false
}


;;;-------------------------------------------------------------------------;;;
;;;                        Controller Action Section                        ;;;
;;;-------------------------------------------------------------------------;;;

execute(command) {
	local thePlugin := false

	SimulatorController.Instance.runninSimulator(thePlugin)

	if thePlugin
		thePlugin.activateWindow()

	try {
		Run % substituteVariables(command)
	}
	catch exception {
		logMessage(kLogWarn, substituteVariables(translate("Cannot execute command (%command%) - please check the configuration"), {command: command}))
	}
}

hotkey(hotkeys, method := "Event") {
	local thePlugin := false
	local ignore, theHotkey

	SimulatorController.Instance.runninSimulator(thePlugin)

	if thePlugin
		thePlugin.activateWindow()

	for ignore, theHotkey in string2Values("|", hotkeys)
		try {
			switch method {
				case "Event":
					SendEvent %theHotkey%
				case "Input":
					SendInput %theHotkey%
				case "Play":
					SendPlay %theHotkey%
				case "Raw":
					SendRaw %theHotkey%
				default:
					Send %theHotkey%
			}
		}
		catch exception {
			logMessage(kLogWarn, substituteVariables(translate("Cannot send command (%hotkey%) - please check the configuration"), {command: theHotkey}))
		}
}

startSimulation(name := false) {
	local controller := SimulatorController.Instance
	local simulators

	if !(controller.ActiveSimulator != false) {
		if !name {
			simulators := string2Values("|", getConfigurationValue(controller.Configuration, "Configuration", "Simulators", ""))

			if (simulators.Length() > 0)
				name := simulators[1]
		}

		withProtection("startupSimulator", name)
	}
}

stopSimulation() {
	local simulator := SimulatorController.Instance.ActiveSimulator

	if (simulator != false)
		withProtection("shutdownSimulator", simulator)
}

shutdownSystem() {
	local title := translate("Shutdown")

	SoundPlay *32

	OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Yes", "No"]))
	MsgBox 262436, %title%, % translate("Shutdown Simulator?")
	OnMessage(0x44, "")

	IfMsgBox Yes
		Shutdown 1
}


;;;-------------------------------------------------------------------------;;;
;;;                         Initialization Section                          ;;;
;;;-------------------------------------------------------------------------;;;

initializeSystemPlugin()