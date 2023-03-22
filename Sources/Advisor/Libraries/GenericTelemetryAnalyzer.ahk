;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   Modular Simulator Controller System - Generic Telemetry Analyzer      ;;;
;;;                                                                         ;;;
;;;   Author:     Oliver Juwig (TheBigO)                                    ;;;
;;;   License:    (2023) Creative Commons - BY-NC-SA                        ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;-------------------------------------------------------------------------;;;
;;;                         Local Include Section                           ;;;
;;;-------------------------------------------------------------------------;;;

#Include ..\Libraries\Task.ahk
#Include ..\Libraries\Math.ahk
#Include ..\Database\Libraries\SessionDatabase.ahk


;;;-------------------------------------------------------------------------;;;
;;;                        Private Constant Section                         ;;;
;;;-------------------------------------------------------------------------;;;

global kClose := "close"

global kMinThreshold := -180
global kMaxThreshold := 180


;;;-------------------------------------------------------------------------;;;
;;;                          Public Classes Section                         ;;;
;;;-------------------------------------------------------------------------;;;

;;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;;
;;; GenericTelemetryAnalyzer                                                ;;;
;;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;;

class GenericTelemetryAnalyzer extends TelemetryAnalyzer {
	iCar := false
	iTrack := false

	iUndersteerThresholds := [40, 70, 100]
	iOversteerThresholds := [-40, -70, -100]
	iLowspeedThreshold := 120

	iSteerLock := 900
	iSteerRatio := 12

	iWheelBase := 270
	iTrackWidth := 150

	iAnalyzerPID := false

	Car {
		Get {
			return this.iCar
		}
	}

	Track {
		Get {
			return this.iTrack
		}
	}

	UndersteerThresholds[key := false] {
		Get {
			return (key ? this.iUndersteerThresholds[key] : this.iUndersteerThresholds)
		}

		Set {
			if key {
				this.iUndersteerThresholds[key] := value

				setAnalyzerSetting(this, "UndersteerThresholds", values2String(",", this.iUndersteerThresholds*))

				return value
			}
			else {
				setAnalyzerSetting(this, "UndersteerThresholds", values2String(",", value*))

				return (this.iUndersteerThresholds := value)
			}
		}
	}

	OversteerThresholds[key := false] {
		Get {
			return (key ? this.iOversteerThresholds[key] : this.iOversteerThresholds)
		}

		Set {
			if key {
				this.iOversteerThresholds[key] := value

				setAnalyzerSetting(this, "OversteerThresholds", values2String(",", this.iOversteerThresholds*))

				return value
			}
			else {
				setAnalyzerSetting(this, "OversteerThresholds", values2String(",", value*))

				return (this.iOversteerThresholds := value)
			}
		}
	}

	LowspeedThreshold {
		Get {
			return this.iLowspeedThreshold
		}

		Set {
			setAnalyzerSetting(this, "LowspeedThreshold", value)

			return (this.iLowspeedThreshold := value)
		}
	}

	SteerLock {
		Get {
			return this.iSteerLock
		}

		Set {
			setAnalyzerSetting(this, "SteerLock", value)

			return (this.iSteerLock := value)
		}
	}

	SteerRatio {
		Get {
			return this.iSteerRatio
		}

		Set {
			setAnalyzerSetting(this, "SteerRatio", value)

			return (this.iSteerRatio := value)
		}
	}

	Wheelbase {
		Get {
			return this.iWheelbase
		}

		Set {
			setAnalyzerSetting(this, "Wheelbase", value)

			return (this.iWheelbase := value)
		}
	}

	TrackWidth {
		Get {
			return this.iTrackWidth
		}

		Set {
			setAnalyzerSetting(this, "TrackWidth", value)

			return (this.iTrackWidth := value)
		}
	}

	__New(advisor, simulator) {
		local selectedCar := advisor.SelectedCar[false]
		local selectedTrack := advisor.SelectedTrack[false]
		local defaultUndersteerThresholds := getMultiMapValue(advisor.SimulatorDefinition, "Analyzer", "UndersteerThresholds", "40,70,100")
		local defaultOversteerThresholds := getMultiMapValue(advisor.SimulatorDefinition, "Analyzer", "OversteerThresholds", "-40,-70,-100")
		local defaultLowspeedThreshold := getMultiMapValue(advisor.SimulatorDefinition, "Analyzer", "LowspeedThreshold", 120)
		local fileName, configuration, settings, prefix

		simulator := SessionDatabase().getSimulatorName(simulator)

		if (selectedCar == true)
			selectedCar := false

		if (selectedTrack == true)
			selectedTrack := false

		this.iCar := selectedCar
		this.iTrack := selectedTrack

		this.iSteerLock := getMultiMapValue(advisor.SimulatorDefinition, "Analyzer", "SteerLock", 900)
		this.iSteerRatio := getMultiMapValue(advisor.SimulatorDefinition, "Analyzer", "SteerRatio", 12)
		this.iWheelbase := getMultiMapValue(advisor.SimulatorDefinition, "Analyzer", "Wheelbase", 270)
		this.iTrackWidth := getMultiMapValue(advisor.SimulatorDefinition, "Analyzer", "TrackWidth", 150)

		if selectedCar {
			fileName := getFileName("Advisor\Definitions\Cars\" . simulator . "." . selectedCar . ".ini", kResourcesDirectory, kUserHomeDirectory)

			if FileExist(fileName) {
				configuration := readMultiMap(fileName)

				this.iSteerLock := getMultiMapValue(configuration, "Setup.General", "SteerLock", this.SteerLock)
				this.iSteerRatio := getMultiMapValue(configuration, "Setup.General", "SteerRatio", this.SteerRatio)
				this.iWheelbase := getMultiMapValue(configuration, "Setup.General", "Wheelbase", this.Wheelbase)
				this.iTrackWidth := getMultiMapValue(configuration, "Setup.General", "TrackWidth", this.TrackWidth)

				defaultUndersteerThresholds := getMultiMapValue(configuration, "Analyzer", "UndersteerThresholds", defaultUndersteerThresholds)
				defaultOversteerThresholds := getMultiMapValue(configuration, "Analyzer", "OversteerThresholds", defaultOversteerThresholds)
				defaultLowspeedThreshold := getMultiMapValue(configuration, "Analyzer", "LowspeedThreshold", defaultLowspeedThreshold)
			}
		}

		settings := readMultiMap(kUserConfigDirectory . "Application Settings.ini")

		prefix := (simulator . "." . (selectedCar ? selectedCar : "*") . ".*.")

		this.iSteerLock := getMultiMapValue(settings, "Setup Advisor", prefix . "SteerLock", this.SteerLock)
		this.iSteerRatio := getMultiMapValue(settings, "Setup Advisor", prefix . "SteerRatio", this.SteerRatio)
		this.iWheelbase := getMultiMapValue(settings, "Setup Advisor", prefix . "Wheelbase", this.Wheelbase)
		this.iTrackWidth := getMultiMapValue(settings, "Setup Advisor", prefix . "TrackWidth", this.TrackWidth)

		defaultUndersteerThresholds := getMultiMapValue(settings, "Setup Advisor", prefix . "UndersteerThresholds", defaultUndersteerThresholds)
		defaultOversteerThresholds := getMultiMapValue(settings, "Setup Advisor", prefix . "OversteerThresholds", defaultOversteerThresholds)
		defaultLowspeedThreshold := getMultiMapValue(settings, "Setup Advisor", prefix . "LowspeedThreshold", defaultLowspeedThreshold)

		prefix := (simulator . "." . (selectedCar ? selectedCar : "*") . "." . (selectedTrack ? selectedTrack : "*") . ".")

		this.iSteerLock := getMultiMapValue(settings, "Setup Advisor", prefix . "SteerLock", this.SteerLock)
		this.iSteerRatio := getMultiMapValue(settings, "Setup Advisor", prefix . "SteerRatio", this.SteerRatio)
		this.iWheelbase := getMultiMapValue(settings, "Setup Advisor", prefix . "Wheelbase", this.Wheelbase)
		this.iTrackWidth := getMultiMapValue(settings, "Setup Advisor", prefix . "TrackWidth", this.TrackWidth)

		this.iUndersteerThresholds := string2Values(",", getMultiMapValue(settings, "Setup Advisor"
																					   , prefix . "UndersteerThresholds", defaultUndersteerThresholds))
		this.iOversteerThresholds := string2Values(",", getMultiMapValue(settings, "Setup Advisor"
																					  , prefix . "OversteerThresholds", defaultOversteerThresholds))
		this.iLowspeedThreshold := getMultiMapValue(settings, "Setup Advisor", prefix . "LowspeedThreshold", defaultLowspeedThreshold)

		super.__New(advisor, simulator)

		OnExit(ObjBindMethod(this, "stopTelemetryAnalyzer", true))
	}

	settingAvailable(setting) {
		return true
	}

	createCharacteristics(telemetry := false) {
		local advisor, severities, count, maxValue
		local characteristicLabels, characteristic, characteristics, ignore, type, severity, speed, key, value

		if telemetry {
			advisor := this.Advisor
			characteristicLabels := getMultiMapValues(advisor.Definition, "Setup.Characteristics.Labels")
			severities := {Light: 33, Medium: 50, Heavy: 66}
			characteristics := {}
			count := 0
			maxValue := 0

			advisor.clearCharacteristics()

			advisor.ProgressCount := 0

			showProgress({color: "Green", width: 350, title: translate("Creating Problems"), message: translate("Preparing Characteristics...")})

			for ignore, type in ["Oversteer", "Understeer"]
				for ignore, speed in ["Slow", "Fast"]
					for ignore, severity in ["Light", "Medium", "Heavy"]
						for ignore, key in ["Entry", "Apex", "Exit"]
							maxValue := Max(maxValue, getMultiMapValue(telemetry, type . "." . speed . "." . severity, key, 0))

			for ignore, type in ["Oversteer", "Understeer"]
				for ignore, speed in ["Slow", "Fast"]
					for ignore, severity in ["Light", "Medium", "Heavy"]
						for ignore, key in ["Entry", "Apex", "Exit"] {
							value := getMultiMapValue(telemetry, type . "." . speed . "." . severity, key, false)

							if value {
								characteristic := (type . ".Corner." . key . "." . speed)

								if !characteristics.HasKey(characteristic)
									characteristics[characteristic] := [Round(value / maxValue * 66), severities[severity]]
								else {
									characteristic := characteristics[characteristic]

									characteristic[1] := Max(characteristic[1], Round(value / maxValue * 66))
									characteristic[2] := Max(characteristic[2], severities[severity])
								}
							}
						}

			Sleep 500

			for characteristic, value in characteristics {
				if (A_Index > kMaxCharacteristics)
					break

				showProgress({progress: (advisor.ProgressCount += 10), message: translate("Create ") . characteristicLabels[characteristic] . translate("...")})

				advisor.addCharacteristic(characteristic, value[1], value[2], false)
			}

			advisor.updateRecommendations()

			advisor.updateState()

			showProgress({progress: 100, message: translate("Finished...")})

			Sleep 500

			hideProgress()
		}
		else {
			telemetry := runAnalyzer(this)

			if telemetry
				Task.startTask(ObjBindMethod(this, "createCharacteristics", telemetry), 100)
		}
	}

	startTelemetryAnalyzer(dataFile, calibrate := false) {
		local pid, options, code, message

		this.stopTelemetryAnalyzer()

		if !this.iAnalyzerPID {
			try {
				options := ((calibrate ? "-Calibrate """ : "-Analyze """) . dataFile . """")

				if !calibrate {
					if this.settingAvailable("UndersteerThresholds")
						options .= (A_Space . values2String(A_Space, this.UndersteerThresholds*))

					if this.settingAvailable("OversteerThresholds")
						options .= (A_Space . values2String(A_Space, this.OversteerThresholds*))
				}

				if this.settingAvailable("LowspeedThreshold")
					options .= (A_Space . this.LowspeedThreshold)

				if this.settingAvailable("SteerLock")
					options .= (A_Space . this.SteerLock)

				if this.settingAvailable("SteerRatio")
					options .= (A_Space . this.SteerRatio)

				if this.settingAvailable("Wheelbase")
					options .= (A_Space . this.Wheelbase)

				if this.settingAvailable("TrackWidth")
					options .= (A_Space . this.TrackWidth)

				code := SessionDatabase().getSimulatorCode(this.Simulator)

				Run %kBinariesDirectory%%code% SHM Spotter.exe %options%, %kBinariesDirectory%, UserErrorLevel Hide, pid
			}
			catch Any as exception {
				message := substituteVariables(translate("Cannot start %simulator% %protocol% Spotter (%exePath%) - please check the configuration...")
													   , {simulator: code, protocol: "SHM", exePath: kBinariesDirectory . code . " SHM Spotter.exe"})

				logMessage(kLogCritical, message)

				showMessage(message, translate("Modular Simulator Controller System"), "Alert.png", 5000, "Center", "Bottom", 800)

				pid := false
			}

			this.iAnalyzerPID := pid
		}
	}

	stopTelemetryAnalyzer() {
		local pid := this.iAnalyzerPID
		local tries

		if pid {
			tries := 5

			while (tries-- > 0) {
				Process Exist, %pid%

				if ErrorLevel {
					Process Close, %pid%

					Sleep 500
				}
				else
					break
			}

			this.iAnalyzerPID := false
		}

		return false
	}
}


;;;-------------------------------------------------------------------------;;;
;;;                        Private Function Section                         ;;;
;;;-------------------------------------------------------------------------;;;

setAnalyzerSetting(analyzer, key, value) {
	local car := analyzer.Car
	local track := analyzer.Track
	local prefix := (analyzer.Simulator . "." . (car ? car : "*") . "." . (track ? track : "*") . ".")
	local settings := readMultiMap(kUserConfigDirectory . "Application Settings.ini")

	setMultiMapValue(settings, "Setup Advisor", prefix . key, value)

	writeMultiMap(kUserConfigDirectory . "Application Settings.ini", settings)
}

runAnalyzer(commandOrAnalyzer := false, arguments*) {
	local window, aWindow, x, y, ignore, widget, advisor, row, include
	local tries, data, type, speed, severity, key, value, newValue, characteristic, characteristicLabels, fromEdit
	local calibration

	static activateButton
	static calibrateButton

	static steerLockEdit
	static steerRatioEdit
	static wheelbaseEdit
	static trackWidthEdit
	static lowspeedThresholdEdit
	static heavyOversteerThresholdSlider
	static mediumOversteerThresholdSlider
	static lightOversteerThresholdSlider
	static heavyUndersteerThresholdSlider
	static mediumUndersteerThresholdSlider
	static lightUndersteerThresholdSlider
	static heavyOversteerThresholdEdit
	static mediumOversteerThresholdEdit
	static lightOversteerThresholdEdit
	static heavyUndersteerThresholdEdit
	static mediumUndersteerThresholdEdit
	static lightUndersteerThresholdEdit

	static issuesListView

	static resultListView
	static applyThresholdSlider

	static result := false
	static analyzer := false
	static state := "Prepare"
	static dataFile := false

	static prepareWidgets := []
	static runWidgets := []
	static analyzeWidgets := []

	static updateTask := false

	if (commandOrAnalyzer == kCancel) {
		if updateTask
			updateTask.stop()

		analyzer.stopTelemetryAnalyzer()

		result := kCancel
	}
	else if (commandOrAnalyzer == "UpdateSlider") {
		Gui TAN:Default

		fromEdit := ((arguments.Length() > 0) && arguments[1])

		for ignore, type in ["Oversteer", "Understeer"]
			for ignore, severity in ["Light", "Medium", "Heavy"] {
				if fromEdit {
					GuiControlGet value, , %severity%%type%ThresholdEdit

					newValue := Min(Max(value, kMinThreshold), kMaxThreshold)

					GuiControl, , %severity%%type%ThresholdSlider, %newValue%

					if (newValue != value)
						GuiControl, , %severity%%type%ThresholdEdit, %newValue%
				}
				else {
					GuiControlGet value, , %severity%%type%ThresholdSlider

					GuiControl, , %severity%%type%ThresholdEdit, %value%
				}
			}
	}
	else if (commandOrAnalyzer == "Calibrate") {
		Gui TAN:+Disabled
		Gui CAN:+OwnerTAN

		try {
			calibration := runCalibrator(analyzer)

			if calibration {
				analyzer.UnderSteerThresholds := calibration[1]
				analyzer.OverSteerThresholds := calibration[2]

				Gui TAN:Default

				GuiControl, , heavyOversteerThresholdSlider, % analyzer.OversteerThresholds[3]
				GuiControl, , heavyOversteerThresholdEdit, % analyzer.OversteerThresholds[3]
				GuiControl, , mediumOversteerThresholdSlider, % analyzer.OversteerThresholds[2]
				GuiControl, , mediumOversteerThresholdEdit, % analyzer.OversteerThresholds[2]
				GuiControl, , lightOversteerThresholdSlider, % analyzer.OversteerThresholds[1]
				GuiControl, , lightOversteerThresholdEdit, % analyzer.OversteerThresholds[1]
				GuiControl, , lightUndersteerThresholdSlider, % analyzer.UndersteerThresholds[1]
				GuiControl, , lightUndersteerThresholdEdit, % analyzer.UndersteerThresholds[1]
				GuiControl, , mediumUndersteerThresholdSlider, % analyzer.UndersteerThresholds[2]
				GuiControl, , mediumUndersteerThresholdEdit, % analyzer.UndersteerThresholds[2]
				GuiControl, , heavyUndersteerThresholdSlider, % analyzer.UndersteerThresholds[3]
				GuiControl, , heavyUndersteerThresholdEdit, % analyzer.UndersteerThresholds[3]
			}
		}
		finally {
			Gui TAN:-Disabled
		}
	}
	else if ((commandOrAnalyzer == "Activate") && (state = "Prepare")) {
		GuiControlGet steerLockEdit
		GuiControlGet steerRatioEdit
		GuiControlGet wheelbaseEdit
		GuiControlGet trackWidthEdit
		GuiControlGet lowspeedThresholdEdit
		GuiControlGet heavyOversteerThresholdSlider
		GuiControlGet mediumOversteerThresholdSlider
		GuiControlGet lightOversteerThresholdSlider
		GuiControlGet heavyUndersteerThresholdSlider
		GuiControlGet mediumUndersteerThresholdSlider
		GuiControlGet lightUndersteerThresholdSlider

		GuiControl Disable, calibrateButton

		if analyzer.settingAvailable("SteerLock")
			analyzer.SteerLock := steerLockEdit

		if analyzer.settingAvailable("SteerRatio")
			analyzer.SteerRatio := steerRatioEdit

		if analyzer.settingAvailable("Wheelbase")
			analyzer.Wheelbase := wheelbaseEdit

		if analyzer.settingAvailable("TrackWidth")
			analyzer.TrackWidth := trackWidthEdit

		if analyzer.settingAvailable("LowspeedThreshold")
			analyzer.LowspeedThreshold := lowspeedThresholdEdit

		if analyzer.settingAvailable("OversteerThresholds")
			analyzer.OversteerThresholds := [lightOversteerThresholdSlider, mediumOversteerThresholdSlider, heavyOversteerThresholdSlider]

		if analyzer.settingAvailable("UndersteerThresholds")
			analyzer.UndersteerThresholds := [lightUndersteerThresholdSlider, mediumUndersteerThresholdSlider, heavyUndersteerThresholdSlider]

		dataFile := temporaryFileName("Analyzer", "data")

		for ignore, widget in prepareWidgets {
			GuiControl Disable, %widget%
			GuiControl Hide, %widget%
		}

		for ignore, widget in runWidgets
			GuiControl Show, %widget%

		GuiControl, , activateButton, % translate("Stop")

		state := "Run"

		analyzer.startTelemetryAnalyzer(dataFile)

		updateTask := PeriodicTask(Func("runAnalyzer").Bind("UpdateIssues"), 5000)

		updateTask.start()
	}
	else if ((commandOrAnalyzer == "Activate") && (state = "Run")) {
		updateTask.stop()

		updateTask := false

		analyzer.stopTelemetryAnalyzer()

		for ignore, widget in runWidgets {
			GuiControl Disable, %widget%
			GuiControl Hide, %widget%
		}

		for ignore, widget in analyzeWidgets
			GuiControl Show, %widget%

		GuiControl, , activateButton, % translate("Apply")

		state := "Analyze"

		runAnalyzer("UpdateTelemetry", runAnalyzer("FilterTelemetry"))
	}
	else if (commandOrAnalyzer == "Threshold")
		runAnalyzer("UpdateTelemetry", runAnalyzer("FilterTelemetry"))
	else if (commandOrAnalyzer == "UpdateIssues") {
		tries := 10

		while (tries-- > 0) {
			data := readMultiMap(dataFile)

			if (data.Count() > 0) {
				runAnalyzer("UpdateTelemetry", data)

				break
			}
			else
				Sleep 20
		}
	}
	else if (commandOrAnalyzer == "FilterTelemetry") {
		advisor := analyzer.Advisor
		characteristicLabels := getMultiMapValues(advisor.Definition, "Setup.Characteristics.Labels")
		final := ((arguments.Length() > 0) && arguments[1])

		Gui TAN:Default

		Gui ListView, % resultListView

		GuiControlGet applyThresholdSlider

		data := readMultiMap(dataFile)

		for ignore, type in ["Oversteer", "Understeer"]
			for ignore, speed in ["Slow", "Fast"]
				for ignore, severity in ["Light", "Medium", "Heavy"]
					for ignore, key in ["Entry", "Apex", "Exit"] {
						value := getMultiMapValue(data, type . "." . speed . "." . severity, key, kUndefined)

						include := ((value != kUndefined) && (value >= applyThresholdSlider))

						if (include && final) {
							include := false

							characteristic := characteristicLabels[type . ".Corner." . key . "." . speed]

							row := LV_GetNext(0, "C")

							while row {
								LV_GetText(value, row)

								if (value = characteristic) {
									include := true

									break
								}
								else
									row := LV_GetNext(row, "C")
							}
						}

						if !include
							setMultiMapValue(data, type . "." . speed . "." . severity, key, 0)
					}

		return data
	}
	else if (commandOrAnalyzer == "UpdateTelemetry") {
		advisor := analyzer.Advisor
		characteristicLabels := getMultiMapValues(advisor.Definition, "Setup.Characteristics.Labels")
		data := arguments[1]

		Gui TAN:Default

		Gui ListView, % ((state = "Run") ? issuesListView : resultListView)

		LV_Delete()

		for ignore, type in ["Oversteer", "Understeer"]
			for ignore, speed in ["Slow", "Fast"]
				for ignore, severity in ["Light", "Medium", "Heavy"]
					for ignore, key in ["Entry", "Apex", "Exit"] {
						value := getMultiMapValue(data, type . "." . speed . "." . severity, key, false)

						if value {
							characteristic := (type . ".Corner." . key . "." . speed)

							LV_Add((state = "Analyze") ? "Check" : "", characteristicLabels[characteristic], translate(severity), value)
						}
					}

		LV_ModifyCol()

		loop 3
			LV_ModifyCol(A_Index, "AutoHdr")
	}
	else if ((commandOrAnalyzer == "Activate") && (state = "Analyze"))
		result := runAnalyzer("FilterTelemetry", true)
	else {
		analyzer := commandOrAnalyzer
		updateTask := false

		state := "Prepare"
		dataFile := false
		result := false

		prepareWidgets := []
		runWidgets := []
		analyzeWidgets := []

		aWindow := SetupAdvisor.Instance.Window
		window := "TAN"

		Gui %window%:New

		Gui %window%:Default

		Gui %window%:-Border ; -Caption
		Gui %window%:Color, D0D0D0, D8D8D8

		Gui %window%:Font, s10 Bold, Arial

		Gui %window%:Add, Text, w324 Center gmoveAnalyzer, % translate("Modular Simulator Controller System")

		Gui %window%:Font, s9 Norm, Arial
		Gui %window%:Font, Italic Underline, Arial

		Gui %window%:Add, Text, x78 YP+20 w184 cBlue Center gopenAnalyzerDocumentation, % translate("Telemetry Analyzer")

		Gui %window%:Font, s8 Norm, Arial

		Gui %window%:Add, Text, x16 yp+30 w130 h23 +0x200, % translate("Simulator")
		Gui %window%:Add, Text, x158 yp w180 h23 +0x200, % analyzer.Simulator

		Gui %window%:Add, Text, x16 yp+24 w130 h23 +0x200, % translate("Car")
		Gui %window%:Add, Text, x158 yp w180 h23 +0x200, % (analyzer.Car ? analyzer.Car : translate("Unknown"))

		if analyzer.Track {
			Gui %window%:Add, Text, x16 yp+24 w130 h23 +0x200, % translate("Track")
			Gui %window%:Add, Text, x158 yp w180 h23 +0x200, % new SessionDatabase().getTrackName(analyzer.Simulator, analyzer.Track)
		}

		Gui %window%:Add, Text, x16 yp+30 w130 h23 +0x200 Section HWNDwidget1, % translate("Steering Lock / Ratio")
		Gui %window%:Add, Edit, x158 yp w45 h23 +0x200 HWNDwidget2 vsteerLockEdit, % analyzer.SteerLock
		Gui %window%:Add, Edit, x208 yp w45 h23 Limit2 Number HWNDwidget3 vsteerRatioEdit, % analyzer.SteerRatio
		Gui %window%:Add, UpDown, x238 yp w18 h23 Range1-99 HWNDwidget4, % analyzer.SteerRatio

		Gui %window%:Add, Text, x16 yp+30 w130 h23 +0x200 HWNDwidget27, % translate("Wheelbase / Track Width")
		Gui %window%:Add, Edit, x158 yp w45 h23 +0x200 HWNDwidget28 Number Limit3 vwheelbaseEdit, % analyzer.Wheelbase
		Gui %window%:Add, UpDown, x188 yp w18 h23 Range1-999 HWNDwidget29, % analyzer.Wheelbase
		Gui %window%:Add, Edit, x208 yp w45 h23 +0x200 HWNDwidget30 Number Limit3 vtrackWidthEdit, % analyzer.TrackWidth
		Gui %window%:Add, UpDown, x238 yp w18 h23 Range1-999 HWNDwidget31, % analyzer.TrackWidth
		Gui %window%:Add, Text, x257 yp w50 h23 +0x200 HWNDwidget32, % translate("cm")

		if !analyzer.settingAvailable("SteerLock") {
			GuiControl Disable, steerLockEdit
			GuiControl, , steerLockEdit, % ""
		}

		if !analyzer.settingAvailable("SteerRatio") {
			GuiControl Disable, steerRatioEdit
			GuiControl, , steerRatioEdit, % ""
		}

		if !analyzer.settingAvailable("Wheelbase") {
			GuiControl Disable, wheelbaseEdit
			GuiControl, , wheelbaseEdit, % ""
		}

		if !analyzer.settingAvailable("TrackWidth") {
			GuiControl Disable, trackWidthEdit
			GuiControl, , trackWidthEdit, % ""
		}

		Gui %window%:Font, Italic, Arial

		Gui %window%:Add, GroupBox, -Theme x16 yp+34 w320 h215 HWNDwidget5, % translate("Thresholds")

		Gui %window%:Font, Norm, Arial

		Gui %window%:Add, Text, x24 yp+21 w130 h23 +0x200 HWNDwidget6, % translate("Consider less than")
		Gui %window%:Add, Edit, x158 yp w45 h23 +0x200 Number Limit3 HWNDwidget7 vlowspeedThresholdEdit, % analyzer.LowspeedThreshold
		Gui %window%:Add, UpDown, x188 yp w18 h23 Range1-999 HWNDwidget33, % analyzer.LowspeedThreshold
		Gui %window%:Add, Text, x207 yp w120 h23 +0x200 HWNDwidget8, % translate("km/h as low speed")

		if !analyzer.settingAvailable("LowspeedThreshold") {
			GuiControl Disable, lowspeedThresholdEdit
			GuiControl, , lowspeedThresholdEdit, % ""
		}

		Gui %window%:Add, Text, x24 yp+30 w130 h20 +0x200 HWNDwidget9, % translate("Heavy Oversteer")
		Gui %window%:Add, Slider, Center Thick15 x158 yp+2 w132 0x10 Range%kMinThreshold%-%kMaxThreshold% ToolTip HWNDwidget10 vheavyOversteerThresholdSlider gupdateThresholdSlider, % analyzer.OversteerThresholds[3]
		Gui %window%:Add, Edit, x293 yp w35 +0x200 HWNDwidget21 vheavyOversteerThresholdEdit gupdateThresholdEdit, % analyzer.OversteerThresholds[3]

		Gui %window%:Add, Text, x24 yp+22 w130 h20 +0x200 HWNDwidget11, % translate("Medium Oversteer")
		Gui %window%:Add, Slider, Center Thick15 x158 yp+2 w132 0x10 Range%kMinThreshold%-%kMaxThreshold% ToolTip HWNDwidget12 vmediumOversteerThresholdSlider gupdateThresholdSlider, % analyzer.OversteerThresholds[2]
		Gui %window%:Add, Edit, x293 yp w35 +0x200 HWNDwidget22 vmediumOversteerThresholdEdit gupdateThresholdEdit, % analyzer.OversteerThresholds[2]

		Gui %window%:Add, Text, x24 yp+22 w130 h20 +0x200 HWNDwidget13, % translate("Light Oversteer")
		Gui %window%:Add, Slider, Center Thick15 x158 yp+2 w132 0x10 Range%kMinThreshold%-%kMaxThreshold% ToolTip HWNDwidget14 vlightOversteerThresholdSlider gupdateThresholdSlider, % analyzer.OversteerThresholds[1]
		Gui %window%:Add, Edit, x293 yp w35 +0x200 HWNDwidget23 vlightOversteerThresholdEdit gupdateThresholdEdit, % analyzer.OversteerThresholds[1]

		Gui %window%:Add, Text, x24 yp+30 w130 h20 +0x200 HWNDwidget15, % translate("Light Understeer")
		Gui %window%:Add, Slider, Center Thick15 x158 yp+2 w132 0x10 Range%kMinThreshold%-%kMaxThreshold% ToolTip HWNDwidget16 vlightUndersteerThresholdSlider gupdateThresholdSlider, % analyzer.UndersteerThresholds[1]
		Gui %window%:Add, Edit, x293 yp w35 +0x200 HWNDwidget24 vlightUndersteerThresholdEdit gupdateThresholdEdit, % analyzer.UndersteerThresholds[1]

		Gui %window%:Add, Text, x24 yp+22 w130 h20 +0x200 HWNDwidget17, % translate("Medium Understeer")
		Gui %window%:Add, Slider, Center Thick15 x158 yp+2 w132 0x10 Range%kMinThreshold%-%kMaxThreshold% ToolTip HWNDwidget18 vmediumUndersteerThresholdSlider gupdateThresholdSlider, % analyzer.UndersteerThresholds[2]
		Gui %window%:Add, Edit, x293 yp w35 +0x200 HWNDwidget25 vmediumUndersteerThresholdEdit gupdateThresholdEdit, % analyzer.UndersteerThresholds[2]

		Gui %window%:Add, Text, x24 yp+22 w130 h20 +0x200 HWNDwidget19, % translate("Heavy Understeer")
		Gui %window%:Add, Slider, Center Thick15 x158 yp+2 w132 0x10 Range%kMinThreshold%-%kMaxThreshold% ToolTip HWNDwidget20 vheavyUndersteerThresholdSlider gupdateThresholdSlider, % analyzer.UndersteerThresholds[3]
		Gui %window%:Add, Edit, x293 yp w35 +0x200 HWNDwidget26 vheavyUndersteerThresholdEdit gupdateThresholdEdit, % analyzer.UndersteerThresholds[3]

		if !analyzer.settingAvailable("OversteerThresholds") {
			GuiControl Disable, heavyOversteerThresholdSlider
			GuiControl, , heavyOversteerThresholdSlider, 0
			GuiControl Disable, mediumOversteerThresholdSlider
			GuiControl, , mediumOversteerThresholdSlider, 0
			GuiControl Disable, lightOversteerThresholdSlider
			GuiControl, , lightOversteerThresholdSlider, 0
		}

		if !analyzer.settingAvailable("UndersteerThresholds") {
			GuiControl Disable, heavyUndersteerThresholdSlider
			GuiControl, , heavyUndersteerThresholdSlider, 0
			GuiControl Disable, mediumUndersteerThresholdSlider
			GuiControl, , mediumUndersteerThresholdSlider, 0
			GuiControl Disable, lightUndersteerThresholdSlider
			GuiControl, , lightUndersteerThresholdSlider, 0
		}

		loop 33
			prepareWidgets.Push(widget%A_Index%)

		Gui %window%:Add, ListView, x16 ys w320 h190 -Multi -LV0x10 NoSort NoSortHdr HWNDwidget1 gnoSelect Hidden, % values2String("|", collect(["Characteristic", "Intensity", "Frequency (%)"], "translate")*)

		issuesListView := widget1

		Gui %window%:Font, s14, Arial

		Gui %window%:Add, Text, x16 ys+200 w320 h200 HWNDwidget2 Wrap Hidden, % translate("Go to the track and run some decent laps. Then click on ""Stop"" to analyze the telemetry data.")

		Gui %window%:Font, Norm s8, Arial

		loop 2
			runWidgets.Push(widget%A_Index%)

		Gui %window%:Add, ListView, x16 ys w320 h230 -Multi -LV0x10 Checked NoSort NoSortHdr HWNDwidget1 gnoSelect Hidden, % values2String("|", collect(["Characteristic", "Intensity", "Frequency (%)"], "translate")*)

		resultListView := widget1

		Gui %window%:Add, Text, x16 yp+238 w130 h23 +0x200 HWNDwidget2 Hidden, % translate("Threshold")
		Gui %window%:Add, Slider, x158 yp w60 0x10 Range0-25 ToolTip HWNDwidget3 vapplyThresholdSlider gupdateThreshold Hidden, 0
		Gui %window%:Add, Text, x220 yp+3 HWNDwidget4 Hidden, % translate("%")

		loop 4
			analyzeWidgets.Push(widget%A_Index%)

		Gui %window%:Add, Button, x16 ys+290 w80 h23 vcalibrateButton gcalibrateAnalyzer, % translate("Calibrate...")
		Gui %window%:Add, Button, x158 yp w80 h23 Default vactivateButton gactivateAnalyzer, % translate("Start")
		Gui %window%:Add, Button, xp+98 yp w80 h23 gcancelAnalyzer, % translate("Cancel")

		Gui %window%:+Owner%aWindow%
		Gui %aWindow%:+Disabled

		try {
			if getWindowPosition("Setup Advisor.Analyzer", x, y)
				Gui %window%:Show, AutoSize x%x% y%y%
			else
				Gui %window%:Show, AutoSize Center

			while !result
				Sleep 100
		}
		finally {
			Gui %aWindow%:-Disabled

			if dataFile
				deleteFile(dataFile)

			if updateTask
				updateTask.stop()

			updateTask := false

			analyzer.stopTelemetryAnalyzer()
		}

		Gui %window%:Destroy

		return ((result == kCancel) ? false : result)
	}
}

runCalibrator(commandOrAnalyzer) {
	local lightOversteerThreshold := 0
	local heavyOversteerThreshold := 0
	local lightUndersteerThreshold := 0
	local heavyUndersteerThreshold := 0
	local mediumOversteerThreshold, mediumUndersteerThreshold
	local window, x, y, ignore, type, speed, key, value, variable

	static activateButton
	static infoText

	static result := false
	static analyzer := false
	static state := "Start"
	static dataFile := false

	static cleanValues := {}
	static overValues := {}

	if (commandOrAnalyzer == kCancel) {
		analyzer.stopTelemetryAnalyzer()

		result := kCancel
	}
	else if ((commandOrAnalyzer == "Activate") && (state = "Start")) {
		GuiControl, , infoText, % translate("Drive at least two consecutive clean laps without under- or oversteering the car. Then press ""Next"".")
		GuiControl, , activateButton, % translate("Next")

		dataFile := temporaryFileName("Calibrator", "data")

		state := "Clean"

		analyzer.startTelemetryAnalyzer(dataFile, true)
	}
	else if ((commandOrAnalyzer == "Activate") && (state = "Clean")) {
		analyzer.stopTelemetryAnalyzer()

		cleanValues := readMultiMap(dataFile)

		GuiControl, , infoText, % translate("Drive at least two consecutive hard laps and provoke under- and oversteering to the max but stay on the track. Then press ""Finish"".")
		GuiControl, , activateButton, % translate("Finish")

		state := "Push"

		dataFile := temporaryFileName("Calibrator", "data")

		analyzer.startTelemetryAnalyzer(dataFile, true)
	}
	else if ((commandOrAnalyzer == "Activate") && (state = "Push")) {
		analyzer.stopTelemetryAnalyzer()

		overValues := readMultiMap(dataFile)

		result := [cleanValues, overValues]
	}
	else {
		analyzer := commandOrAnalyzer

		state := "Start"
		dataFile := false
		result := false

		cleanValues := {}
		overValues := {}
		window := "CAN"

		Gui %window%:New

		Gui %window%:Default

		Gui %window%:-Border ; -Caption
		Gui %window%:Color, D0D0D0, D8D8D8

		Gui %window%:Font, s10 Bold, Arial

		Gui %window%:Add, Text, w324 Center gmoveCalibrator, % translate("Modular Simulator Controller System")

		Gui %window%:Font, s9 Norm, Arial
		Gui %window%:Font, Italic Underline, Arial

		Gui %window%:Add, Text, x78 YP+20 w184 cBlue Center gopenAnalyzerDocumentation, % translate("Telemetry Analyzer")

		Gui %window%:Font, Norm s14, Arial

		Gui %window%:Add, Text, x16 yp+30 w320 h140 Wrap vinfoText, % translate("Start a practice session and prepare for a run. Then press ""Start"".")

		Gui %window%:Font, Norm s8, Arial

		Gui %window%:Add, Button, x92 yp+145 w80 h23 Default vactivateButton gactivateCalibrator, % translate("Start")
		Gui %window%:Add, Button, xp+100 yp w80 h23 gcancelCalibrator, % translate("Cancel")

		try {
			if getWindowPosition("Setup Advisor.Calibrator", x, y)
				Gui %window%:Show, AutoSize x%x% y%y%
			else
				Gui %window%:Show, AutoSize Center

			while !result
				Sleep 100
		}
		finally {
			; if dataFile
			; 	deleteFile(dataFile)

			analyzer.stopTelemetryAnalyzer()
		}

		Gui %window%:Destroy

		if (result != kCancel) {
			for ignore, type in ["Oversteer", "Understeer"] {
				variable := ("light" . type . "Threshold")

				for ignore, speed in ["Slow", "Fast"]
					for ignore, key in ["Entry", "Apex", "Exit"] {
						value := getMultiMapValue(result[1], type . "." . speed, key, kUndefined)

						if (value && (value != kUndefined))
							if (type = "Understeer")
								%variable% := Max(%variable%, value)
							else
								%variable% := Min(%variable%, value)
					}
			}

			for ignore, type in ["Oversteer", "Understeer"] {
				variable := ("heavy" . type . "Threshold")

				for ignore, speed in ["Slow", "Fast"]
					for ignore, key in ["Entry", "Apex", "Exit"] {
						value := getMultiMapValue(result[2], type . "." . speed, key, kUndefined)

						if (value && (value != kUndefined))
							if (type = "Understeer")
								%variable% := Max(%variable%, value)
							else
								%variable% := Min(%variable%, value)
					}
			}

			value := Max(lightOversteerThreshold, heavyOversteerThreshold, kMinThreshold)
			heavyOversteerThreshold := Min(lightOversteerThreshold, heavyOversteerThreshold, 0)
			lightOversteerThreshold := value

			value := Min(lightUndersteerThreshold, heavyUndersteerThreshold, kMaxThreshold)
			heavyUndersteerThreshold := Max(lightUndersteerThreshold, heavyUndersteerThreshold, 0)
			lightUndersteerThreshold := value

			heavyOversteerThreshold := Round(heavyOversteerThreshold * 0.9)
			heavyUndersteerThreshold := Round(heavyUndersteerThreshold * 0.9)
			mediumOversteerThreshold := Round(lightOversteerThreshold + (heavyOversteerThreshold - lightOversteerThreshold) / 2)
			mediumUndersteerThreshold := Round(lightUndersteerThreshold + (heavyUndersteerThreshold - lightUndersteerThreshold) / 2)

			return [[lightUndersteerThreshold, mediumUndersteerThreshold, heavyUndersteerThreshold]
				  , [lightOversteerThreshold, mediumOversteerThreshold, heavyOversteerThreshold]]
		}
		else
			return false
	}
}

noSelect() {
	loop % LV_GetCount()
		LV_Modify(A_Index, "-Select")
}

updateThresholdSlider() {
	runAnalyzer("UpdateSlider")
}

updateThresholdEdit() {
	runAnalyzer("UpdateSlider", true)
}

activateAnalyzer() {
	runAnalyzer("Activate")
}

calibrateAnalyzer() {
	runAnalyzer("Calibrate")
}

cancelAnalyzer() {
	runAnalyzer(kCancel)
}

updateThreshold() {
	runAnalyzer("Threshold")
}

moveAnalyzer() {
	moveByMouse("TAN", "Setup Advisor.Analyzer")
}

openAnalyzerDocumentation() {
	Run https://github.com/SeriousOldMan/Simulator-Controller/wiki/Setup-Advisor#real-time-telemetry-analyzer
}

moveCalibrator() {
	moveByMouse("CAN", "Setup Advisor.Calibrator")
}

activateCalibrator() {
	runCalibrator("Activate")
}

cancelCalibrator() {
	runCalibrator(kCancel)
}