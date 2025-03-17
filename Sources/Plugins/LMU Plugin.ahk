﻿;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   Modular Simulator Controller System - LMU Plugin                      ;;;
;;;                                                                         ;;;
;;;   Author:     Oliver Juwig (TheBigO)                                    ;;;
;;;   License:    (2025) Creative Commons - BY-NC-SA                        ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;-------------------------------------------------------------------------;;;
;;;                         Local Include Section                           ;;;
;;;-------------------------------------------------------------------------;;;

#Include "..\Framework\Extensions\Math.ahk"
#Include "..\Database\Libraries\SessionDatabase.ahk"
#Include "Libraries\SimulatorPlugin.ahk"
#Include "Libraries\LMURESTProvider.ahk"
#Include "RF2 Plugin.ahk"


;;;-------------------------------------------------------------------------;;;
;;;                         Public Constant Section                         ;;;
;;;-------------------------------------------------------------------------;;;

global kLMUApplication := "Le Mans Ultimate"

global kLMUPlugin := "LMU"


;;;-------------------------------------------------------------------------;;;
;;;                          Public Classes Section                         ;;;
;;;-------------------------------------------------------------------------;;;

class LMUPlugin extends Sector397Plugin {
	iTrackData := false
	iTeamData := false
	iGridData := false

	iStandingsData := false
	iStandingsTimeout := 0

	iLastFuelAmount := 0
	iRemainingFuelAmount := 0

	iFuelRatio := 1

	iFuelLevels := []
	iVirtualEnergyLevels := []

	iAdjustRefuelAmount := false

	TeamData {
		Get {
			if !this.iTeamData
				this.iTeamData := LMURESTProvider.TeamData()

			return this.iTeamData
		}
	}

	TrackData {
		Get {
			if !this.iTrackData
				this.iTrackData := LMURESTProvider.TrackData()

			return this.iTrackData
		}
	}

	GridData {
		Get {
			if !this.iGridData
				this.iGridData := LMURESTProvider.GridData()

			return this.iGridData
		}
	}

	StandingsData {
		Get {
			if (A_TickCount > this.iStandingsTimeout)
				this.iStandingsData := false

			if !this.iStandingsData {
				this.iStandingsData := LMURESTProvider.StandingsData()

				this.iStandingsTimeout := (A_TickCount + 20000)
			}

			return this.iStandingsData
		}
	}

	getPitstopActions(&allActions, &selectActions) {
		allActions := CaseInsenseMap("NoRefuel", "No Refuel", "Refuel", "Refuel"
								   , "TyreCompound", "Tyre Compound"
								   , "TyreCompoundFrontLeft", "Tyre Compound Front Left", "TyreCompoundFrontRight", "Tyre Compound Front Right"
								   , "TyreCompoundRearLeft", "Tyre Compound Rear Left", "TyreCompoundRearRight", "Tyre Compound Rear Right"
								   , "TyreAllAround", "All Around"
								   , "TyreFrontLeft", "Front Left", "TyreFrontRight", "Front Right", "TyreRearLeft", "Rear Left", "TyreRearRight", "Rear Right"
								   , "BodyworkRepair", "Repair Bodywork", "SuspensionRepair", "Repair Suspension"
								   , "BrakeChange", "Change Brakes", "DriverSelect", "Driver", "PitstopRequest", "RequestPitstop")

		selectActions := []
	}

	updateRaceAssistantActions(session) {
		local ignore, theAction

		super.updateRaceAssistantActions(session)

		for ignore, theAction in this.Actions
			if (isInstance(theAction, RaceAssistantPlugin.RaceAssistantAction) && (theAction.Action = "FuelRatioOptimize")) {
			 	theAction.Function.enable(kAllTrigger, theAction)
				theAction.Function.setLabel(this.actionLabel(theAction))
			}
	}

	supportsSetupImport() {
		return true
	}

	getOptionHandler(option) {
		return (operation, value?, pitstop := false, initial := true) {
			local simulator := this.Simulator[true]
			local car := this.Car
			local track := this.Track
			local code, tyre, found, tyreCompound, tyreCompoundColor, cTyreCompound, cTyreCompoundColor

			if !pitstop
				pitstop := LMURESTProvider.PitstopData(simulator, car, track)

			switch option, false {
				case "Refuel":
					switch operation, false {
						case "Get":
							return (pitstop.getRefuelLevel() - this.iRemainingFuelAmount)
						case "Set":
							if initial
								this.iRemainingFuelAmount := this.iLastFuelAmount

							pitstop.setRefuelLevel(value + this.iRemainingFuelAmount)
						case "Change":
							pitstop.changeRefuelLevel(value)
					}
				case "Tyre Compound", "Tyre Compound Front Left", "Tyre Compound Front Right"
									, "Tyre Compound Rear Left", "Tyre Compound Rear Right":
					if (option = "Tyre Compound")
						tyre := "All"
					else
						tyre := StrReplace(option, "Tyre Compound ", "")

					switch operation, false {
						case "Get":
							tyreCompound := pitstop.getTyreCompound(tyre)

							if tyreCompound
								tyreCompound := SessionDatabase.getTyreCompoundName(this.Simulator[true]
																				  , this.Car, this.Track
																				  , tyreCompound, kUndefined)

							return ((tyreCompound = kUndefined) ? normalizeCompound("Dry") : tyreCompound)
						case "Set":
							if value {
								code := SessionDatabase.getTyreCompoundCode(this.Simulator[true]
																		  , this.Car, this.Track, value, kUndefined)
								found := false

								if (code = kUndefined)
									try
										code := SessionDatabase.getTyreCompounds(this.Simulator[true]
																			   , this.Car, this.Track, true)[1]

								if !pitstop.setTyreCompound(tyre, code) {
									splitCompound(value, &tyreCompound, &tyreCompoundColor)

									for ignore, candidate in SessionDatabase.getTyreCompounds(this.Simulator[true]
																							, this.Car, this.Track) {
										splitCompound(candidate, &cTyreCompound, &cTyreCompoundColor)

										if (tyreCompound = cTyreCompound) {
											code := SessionDatabase.getTyreCompoundCode(this.Simulator[true]
																					  , this.Car, this.Track, candidate)

											if pitstop.setTyreCompound(tyre, code) {
												found := true

												break
											}
										}
									}

									if !found {
										try
											code := SessionDatabase.getTyreCompounds(this.Simulator[true]
																				   , this.Car, this.Track, true)[1]

										pitstop.setTyreCompound(tyre, code)
									}
								}
							}
							else
								pitstop.setTyreCompound(tyre, false)
						case "Change":
							pitstop.changeTyreCompound(tyre, value)
					}
				case "Front Left", "Front Right", "Rear Left", "Rear Right":
					switch operation, false {
						case "Get":
							return pitstop.getTyrePressure(option)
						case "Set":
							pitstop.setTyrePressure(option, value)
						case "Change":
							pitstop.changeTyrePressure(option, value)
					}
				case "Repair Bodywork":
					switch operation, false {
						case "Get":
							pitstop.getRepairs(&value, &ignore, &ignore)

							return value
						case "Set":
							pitstop.setRepairs(value, pitstop.RepairSuspension, pitstop.RepairEngine)
						case "Change":
							if (value < 0)
								pitstop.setRepairs(false, pitstop.RepairSuspension, pitstop.RepairEngine)
							else if (value < 0)
								pitstop.setRepairs(true, pitstop.RepairSuspension, pitstop.RepairEngine)
					}
				case "Repair Bodywork":
					switch operation, false {
						case "Get":
							pitstop.getRepairs(&ignore, &value, &ignore)

							return value
						case "Set":
							pitstop.setRepairs(pitstop.RepairBodywork, value, pitstop.RepairEngine)
						case "Change":
							if (value < 0)
								pitstop.setRepairs(pitstop.RepairBodywork, false, pitstop.RepairEngine)
							else if (value < 0)
								pitstop.setRepairs(pitstop.RepairBodywork, true, pitstop.RepairEngine)
					}
				case "Repair Engine":
					if pitstop.supportsEngineRepair()
						switch operation, false {
							case "Get":
								pitstop.getRepairs(&ignore, &ignore, &value)

								return value
							case "Set":
								pitstop.setRepairs(pitstop.RepairBodywork, pitstop.RepairSuspension, value)
							case "Change":
								if (value < 0)
									pitstop.setRepairs(pitstop.RepairBodywork, pitstop.RepairSuspension, false)
								else if (value < 0)
									pitstop.setRepairs(pitstop.RepairBodywork, pitstop.RepairSuspension, true)
						}
					else
						return false
				case "Change Brakes":
					switch operation, false {
						case "Get":
							return pitstop.getBrakeChange()
						case "Set":
							pitstop.setBrakeChange(value)
						case "Change":
							if (value < 0)
								pitstop.setBrakeChange(false)
							else if (value > 0)
								pitstop.setBrakeChange(true)
					}
				case "Driver":
					if pitstop.supportsDriverSwap() {
						switch operation, false {
							case "Get":
								return pitstop.getDriver()
							case "Set":
								pitstop.setDriver(value)
							case "Change":
								pitstop.changeDriver(value)
						}
					}
					else
						return SessionDatabase.getDriverName(this.Simulator[true], SessionDatabase.ID)
			}

			if (operation != "Get")
				pitstop.write()
		}
	}

	getPitstopOptionValues(option) {
		local data, compound, compoundColor

		if (this.OpenPitstopMFDHotkey != "Off") {
			switch option, false {
				case "Refuel":
					return [this.getOptionHandler(option).Call("Get")]
				case "Tyre Pressures":
					return [this.getOptionHandler("Front Left").Call("Get"), this.getOptionHandler("Front Right").Call("Get")
						  , this.getOptionHandler("Rear Left").Call("Get"), this.getOptionHandler("Rear Right").Call("Get")]
				case "Tyre Compound", "TyreCompound":
					compound := this.getOptionHandler("Tyre Compound").Call("Get")
					compoundColor := false

					if compound
						splitCompound(compound, &compound, &compoundColor)

					return [compound, compoundColor]
				case "Repair Suspension", "Repair Bodywork", "Repair Engine":
					return [this.getOptionHandler(option).Call("Get")]
				case "Change Brakes":
					return [this.getOptionHandler(option).Call("Get")]
				case "Driver":
					return [this.getOptionHandler(option).Call("Get")]
				default:
					return super.getPitstopOptionValues(option)
			}
		}
		else
			return false
	}

	notifyPitstopChanged(option) {
		super.notifyPitstopChanged((option = "No Refuel") ? "Refuel" : option)
	}

	dialPitstopOption(option, action, steps := 1) {
		if (this.OpenPitstopMFDHotkey != "Off")
			if (action = "Increase")
				this.getOptionHandler(option).Call("Change", steps)
			else if (action = "Decrease")
				this.getOptionHandler(option).Call("Change", - steps)
			else
				throw "Unsupported change operation `"" . action . "`" detected in LMUPlugin.dialPitstopOption..."
	}

	setPitstopOption(option, value) {
		if (this.OpenPitstopMFDHotkey != "Off")
			this.getOptionHandler(option).Call("Set", value)
	}

	changePitstopOption(option, action := "Increase", steps := 1) {
		if (this.OpenPitstopMFDHotkey != "Off") {
			switch option, false {
				case "RequestPitstop":
					if (this.RequestPitstopHotKey && (steps > 0)) {
						this.activateWindow()

						this.sendCommand(this.RequestPitstopHotKey)
					}
				case "Refuel":
					this.dialPitstopOption(option, action, steps)
				case "No Refuel":
					this.dialPitstopOption("Refuel", "Decrease", 250)
				case "Tyre Compound", "Tyre Compound Front Left", "Tyre Compound Front Right"
									, "Tyre Compound Rear Left", "Tyre Compound Rear Right":
					this.dialPitstopOption(option, action, steps)
				case "All Around":
					this.dialPitstopOption("Front Left", action, steps)
					this.dialPitstopOption("Front Right", action, steps)
					this.dialPitstopOption("Rear Left", action, steps)
					this.dialPitstopOption("Rear Right", action, steps)
				case "Front Left", "Front Right", "Rear Left", "Rear Right":
					this.dialPitstopOption(option, action, steps)
				case "Repair Bodywork", "Repair Suspension", "Repair Engine":
					this.dialPitstopOption(option, action, steps)
				case "Change Brakes":
					this.dialPitstopOption("Change Brakes", action, steps)
				case "Driver":
					this.dialPitstopOption("Driver", action, steps)
				default:
					throw "Unsupported change operation `"" . action . "`" detected in LMUPlugin.changePitstopOption..."
			}
		}
	}

	getConsumptions(&virtualEnergy, &fuel) {
		computeConsumption(series) {
			local values := []

			loop series.Length
				if (A_Index > 1)
					values.Push(series[A_Index - 1] - series[A_Index])

			return average(values)
		}

		virtualEnergy := computeConsumption(this.iVirtualEnergyLevels)
		fuel := computeConsumption(this.iFuelLevels)
	}

	addLap(lap, data) {
		super.addLap(lap, data)

		this.iLastFuelAmount := getMultiMapValue(data, "Car Data", "FuelRemaining", 0)

		this.iFuelLevels.Push(this.iLastFuelAmount)
		this.iVirtualEnergyLevels.Push(LMURESTProvider.EnergyData(this.Simulator[true], this.Car, this.Track).RemainingVirtualEnergy)

		while (this.iFuelLevels.Length > 10) {
			this.iFuelLevels.RemoveAt(1)
			this.iVirtualEnergyLevels.RemoveAt(1)
		}

		if (this.iAdjustRefuelAmount && !getMultiMapValue(data, "Stint Data", "InPitLane", false)
									 && !getMultiMapValue(data, "Stint Data", "InPit", false))
			Task.startTask(() {
				local handler := this.getOptionHandler("Refuel")
				local ignore, fuelConsumption

				this.getConsumptions(&ignore, &fuelConsumption)

				handler.Call("Set", handler.Call("Get") - fuelConsumption, false, false)
			}, 1000, kLowPriority)

		if getMultiMapValue(this.Settings, "Simulator.Le Mans Ultimate", "Pitstop.Fuel.Ratio", false)
			Task.startTask(ObjBindMethod(this, "optimizeFuelRatio"), 2000, kLowPriority)
	}

	optimizeFuelRatio(safetyFuel?) {
		local pitstop, energyConsumption, fuelConsumption

		this.getConsumptions(&energyConsumption, &fuelConsumption)

		if !isSet(safetyFuel)
			safetyFuel := getMultiMapValue(this.Settings, "Session Settings", "Fuel.SafetyMargin", 4)

		if (energyConsumption && fuelConsumption) {
			pitstop := LMURESTProvider.PitstopData(this.Simulator[true], this.Car, this.Track)

			pitstop.setFuelRatio(((100 / energyConsumption * fuelConsumption) + safetyFuel) / 100)

			pitstop.write()
		}
	}

	performPitstop(lapNumber, options) {
		super.performPitstop(lapNumber, options)

		this.iLastFuelAmount := 0

		this.iFuelLevels := []
		this.iVirtualEnergyLevels := []

		this.iAdjustRefuelAmount := false
	}

	setPitstopRefuelAmount(pitstopNumber, liters, fillUp) {
		super.setPitstopRefuelAmount(pitstopNumber, liters, fillUp)

		if (this.OpenPitstopMFDHotkey != "Off") {
			if !fillUp
				this.iAdjustRefuelAmount := getMultiMapValue(this.Settings, "Simulator.Le Mans Ultimate", "Pitstop.Energy.Adjust", false)

			this.setPitstopOption("Refuel", liters)
		}
	}

	setPitstopTyreSet(pitstopNumber, tyreCompound, tyreCompoundColor := false, set := false) {
		super.setPitstopTyreSet(pitstopNumber, tyreCompound, tyreCompoundColor, set)

		if (this.OpenPitstopMFDHotkey != "Off")
			this.setPitstopOption("Tyre Compound", compound ? compound(tyreCompound, tyreCompoundColor) : false)
	}

	setPitstopTyrePressures(pitstopNumber, pressureFL, pressureFR, pressureRL, pressureRR) {
		local pressures, pressureFLIncrement, pressureFRIncrement, pressureRLIncrement, pressureRRIncrement, finished

		super.setPitstopTyrePressures(pitstopNumber, pressureFL, pressureFR, pressureRL, pressureRR)

		if (this.OpenPitstopMFDHotkey != "Off") {
			this.setPitstopOption("Front Left", pressureFL)
			this.setPitstopOption("Front Right", pressureFR)
			this.setPitstopOption("Rear Left", pressureRL)
			this.setPitstopOption("Rear Right", pressureRR)
		}
	}

	requestPitstopRepairs(pitstopNumber, repairSuspension, repairBodywork, repairEngine := false) {
		super.requestPitstopRepairs(pitstopNumber, repairSuspension, repairBodywork, repairEngine)

		if (this.OpenPitstopMFDHotkey != "Off") {
			this.setPitstopOption("Repair Suspension", repairSuspension)
			this.setPitstopOption("Repair Bodywork", repairBodywork)
			this.setPitstopOption("Repair Engine", repairEngine)
		}
	}

	requestPitstopDriver(pitstopNumber, driver) {
		if (this.OpenPitstopMFDHotkey != "Off")
			this.setPitstopOption("Driver", driver)
	}

	finishPitstopSetup(pitstopNumber) {
		super.finishPitstopSetup(pitstopNumber)

		if getMultiMapValue(this.Settings, "Simulator.Le Mans Ultimate", "Pitstop.Request", false)
			this.changePitstopOption("RequestPitstop")
	}

	parseCategory(candidate, &rest) {
		super.parseCategory(candidate, &rest)

		return false
	}

	parseCarName(carID, carName, &model?, &nr?, &category?, &team?) {
		local standingsData := (carID ? this.StandingsData : false)
		local gridData := this.GridData
		local driver := gridData.Drivers[carName][1]

		model := gridData.Car[carName]
		team := gridData.Team[carName]

		if ((carName != "") && isNumber(SubStr(carName, 1, 1)))
			nr := this.parseNr(carName, &carName)
		else
			super.parseCarName(carID, carName, , &nr)

		try {
			if (!standingsData || (standingsData.Driver[carID] = driver.Name))
				category := driver.Category
			else
				category := false
		}
		catch Any {
			category := false
		}
	}

	parseDriverName(carID, carName, forName, surName, nickName) {
		local standingsData := this.StandingsData
		local driver

		try {
			if standingsData {
				driver := standingsData.Driver[carID]

				if driver
					return driver
			}

			driver := this.GridData.Drivers[carName][1]

			if driver
				return driver.Name
		}
		catch Any as exception {
			logError(exception)
		}

		return super.parseDriverName(carID, carName, forName, surName, nickName)
	}

	updateSession(session, force := false) {
		super.updateSession(session, force)

		if (session == kSessionFinished) {
			this.iTrackData := false
			this.iTeamData := false
			this.iGridData := false

			this.iLastFuelAmount := 0
			this.iRemainingFuelAmount := 0

			this.iFuelLevels := []
			this.iVirtualEnergyLevels := []
			this.iFuelRatio := 1

			this.iAdjustRefuelAmount := false
		}
	}

	acquirePositionsData(telemetryData, finished := false) {
		this.iStandingsData := LMURESTProvider.StandingsData()

		try {
			return super.acquirePositionsData(telemetryData, finished)
		}
		finally {
			this.iStandingsData := false
		}
	}

	readSessionData(options := "", protocol?) {
		local simulator := this.Simulator[true]
		local car, track, data, setupData, tyreCompound, tyreCompoundColor, key, postFix, fuelAmount
		local weatherData, lap, weather, time, session, remainingTime

		static keys := Map("All", "", "Front Left", "FrontLeft", "Front Right", "FrontRight"
									, "Rear Left", "RearLeft", "Rear Right", "RearRight")

		static lastLap := 0
		static duration := 0
		static lastWeather := false
		static lastWeather10Min := false
		static lastWeather30Min := false

		if InStr(options, "Setup=true") {
			car := this.Car
			track := this.Track

			setupData := LMURESTProvider.PitstopData(simulator, car, track)
			data := newMultiMap()

			setMultiMapValue(data, "Setup Data", "FuelAmount", this.getOptionHandler("Refuel").Call("Get", , setupData))

			for key, postFix in keys {
				tyreCompound := setupData.TyreCompound[key]

				if tyreCompound {
					tyreCompound := SessionDatabase.getTyreCompoundName(simulator, car, track, tyreCompound, false)

					if tyreCompound {
						splitCompound(tyreCompound, &tyreCompound, &tyreCompoundColor)

						setMultiMapValue(data, "Setup Data", "TyreCompound" . postFix, tyreCompound)
						setMultiMapValue(data, "Setup Data", "TyreCompoundColor" . postFix, tyreCompoundColor)
					}
				}
				else {
					setMultiMapValue(data, "Setup Data", "TyreCompound" . postFix, false)
					setMultiMapValue(data, "Setup Data", "TyreCompoundColor" . postFix, false)
				}
			}

			setMultiMapValue(data, "Setup Data", "TyrePressureFL", setupData.TyrePressure["Front Left"])
			setMultiMapValue(data, "Setup Data", "TyrePressureFR", setupData.TyrePressure["Front Right"])
			setMultiMapValue(data, "Setup Data", "TyrePressureRL", setupData.TyrePressure["Rear Left"])
			setMultiMapValue(data, "Setup Data", "TyrePressureRR", setupData.TyrePressure["Rear Right"])

			setMultiMapValue(data, "Setup Data", "RepairBodywork", setupData.RepairBodywork)
			setMultiMapValue(data, "Setup Data", "RepairSuspension", setupData.RepairSuspension)
			setMultiMapValue(data, "Setup Data", "RepairEngine", setupData.RepairEngine)

			this.iFuelRatio := setupData.FuelRatio

			setMultiMapValue(data, "Setup Data", "ServiceTime", LMURESTProvider.ServiceData().ServiceTime)
		}
		else {
			data := super.readSessionData(options, protocol?)

			car := this.TeamData.Car
			track := this.TrackData.Track

			if data.Has("Weather Data") {
				lap := getMultiMapValue(data, "Stint Data", "Laps", 0)

				if ((lap < lastLap) || (lap = 0) || (lap > (lastLap + 1)) || (duration = 0)) {
					lastLap := 0

					lastWeather := getMultiMapValue(data, "Weather Data", "Weather", "Dry")
					lastWeather10Min := getMultiMapValue(data, "Weather Data", "Weather10Min", "Dry")
					lastWeather30Min := getMultiMapValue(data, "Weather Data", "Weather30Min", "Dry")

					duration := (LMURESTProvider.SessionData().Duration[getMultiMapValue(data, "Session Data"
																							 , "Session", "Race")] * 1000)
				}

				if (lap != lastLap) {
					lastLap := lap

					session := getMultiMapValue(data, "Session Data", "Session", "Race")
					remainingTime := getMultiMapValue(data, "Session Data", "SessionTimeRemaining", 0)
					weatherData := LMURestProvider.WeatherData()
					weather := weatherData.Weather["Now"]

					if weather
						lastWeather := weather

					time := ((duration > 0) ? Round(100 - (Max(0, remainingTime - 600000) / duration * 100)) : 0)
					weather := weatherData.Weather[session, time]

					if weather
						lastWeather10Min := weather

					time := ((duration > 0) ? Round(100 - (Max(0, remainingTime - 1800000) / duration * 100)) : 0)
					weather := weatherData.Weather[session, time]

					if weather
						lastWeather30Min := weather
				}

				setMultiMapValue(data, "Weather Data", "Weather", lastWeather)
				setMultiMapValue(data, "Weather Data", "Weather10Min", lastWeather10Min)
				setMultiMapValue(data, "Weather Data", "Weather30Min", lastWeather30Min)
			}

			if car
				setMultiMapValue(data, "Session Data", "Car", car)
			else
				car := this.Car

			if track
				setMultiMapValue(data, "Session Data", "Track", track)
			else
				track := this.Track

			if data.Has("Car Data") {
				fuelAmount := getMultiMapValue(data, "Session Data", "FuelAmount", false)

				if (fuelAmount && this.iFuelRatio)
					setMultiMapValue(data, "Session Data", "FuelAmount", Round(this.iFuelRatio * 100, 1))
				else if !fuelAmount
					setMultiMapValue(data, "Session Data", "FuelAmount", LMURESTProvider.EnergyData(simulator, car, track).MaxFuelAmount)
			}

			for key, postFix in keys {
				tyreCompound := getMultiMapValue(data, "Car Data", "TyreCompound" . postFix, kUndefined)

				if (tyreCompound = kUndefined) {
					tyreCompound := getMultiMapValue(data, "Car Data", "TyreCompoundRaw" . postFix, kUndefined)

					if ((tyreCompound != kUndefined) && tyreCompound) {
						tyreCompound := SessionDatabase.getTyreCompoundName(simulator, car, track, tyreCompound, false)

						if tyreCompound {
							splitCompound(tyreCompound, &tyreCompound, &tyreCompoundColor)

							setMultiMapValue(data, "Car Data", "TyreCompound" . postFix, tyreCompound)
							setMultiMapValue(data, "Car Data", "TyreCompoundColor" . postFix, tyreCompoundColor)

							if (postfix = "Front") {
								setMultiMapValue(data, "Car Data", "TyreCompoundFrontLeft" . postFix, tyreCompound)
								setMultiMapValue(data, "Car Data", "TyreCompoundColorFrontLeft" . postFix, tyreCompoundColor)
								setMultiMapValue(data, "Car Data", "TyreCompoundFrontRight" . postFix, tyreCompound)
								setMultiMapValue(data, "Car Data", "TyreCompoundColorFrontRight" . postFix, tyreCompoundColor)
							}
							else if (postfix = "Rear") {
								setMultiMapValue(data, "Car Data", "TyreCompoundRearLeft" . postFix, tyreCompound)
								setMultiMapValue(data, "Car Data", "TyreCompoundColorRearLeft" . postFix, tyreCompoundColor)
								setMultiMapValue(data, "Car Data", "TyreCompoundRearRight" . postFix, tyreCompound)
								setMultiMapValue(data, "Car Data", "TyreCompoundColorRearRight" . postFix, tyreCompoundColor)
							}
						}
					}
				}
			}
		}

		return data
	}
}


;;;-------------------------------------------------------------------------;;;
;;;                     Function Hook Declaration Section                   ;;;
;;;-------------------------------------------------------------------------;;;

startLMU() {
	return SimulatorController.Instance.startSimulator(SimulatorController.Instance.findPlugin(kLMUPlugin).Simulator
													 , "Simulator Splash Images\LMU Splash.jpg")
}


;;;-------------------------------------------------------------------------;;;
;;;                   Private Function Declaration Section                  ;;;
;;;-------------------------------------------------------------------------;;;

initializeLMUPlugin() {
	local controller := SimulatorController.Instance

	LMUPlugin(controller, kLMUPlugin, kLMUApplication, controller.Configuration)
}


;;;-------------------------------------------------------------------------;;;
;;;                         Initialization Section                          ;;;
;;;-------------------------------------------------------------------------;;;

initializeLMUPlugin()
