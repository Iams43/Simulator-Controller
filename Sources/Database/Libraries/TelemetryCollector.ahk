﻿;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   Modular Simulator Controller System - Telemetry Collector             ;;;
;;;                                                                         ;;;
;;;   Author:     Oliver Juwig (TheBigO)                                    ;;;
;;;   License:    (2025) Creative Commons - BY-NC-SA                        ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;-------------------------------------------------------------------------;;;
;;;                         Local Include Section                           ;;;
;;;-------------------------------------------------------------------------;;;

#Include "SessionDatabase.ahk"


;;;-------------------------------------------------------------------------;;;
;;;                       Public Constants Section                          ;;;
;;;-------------------------------------------------------------------------;;;

global kTelemetryChannels := [{Name: "Distance", Indices: [1], Channels: []}
							, {Name: "Speed", Indices: [7], Size: 1, Channels: ["Speed"], Converter: [(s) => isNumber(s) ? convertUnit("Speed", s) : kNull]}
							, {Name: "Throttle", Indices: [2], Size: 0.5, Channels: ["Throttle"]}
							, {Name: "Brake", Indices: [3], Size: 0.5, Channels: ["Brake"]}
							, {Name: "Throttle/Brake", Indices: [2, 3], Size: 0.5, Channels: ["Throttle", "Brake"]}
							, {Name: "Steering", Indices: [4], Size: 0.8, Channels: ["Steering"]}
							, {Name: "TC", Indices: [8], Size: 0.3, Channels: ["TC"]}
							, {Name: "ABS", Indices: [9], Size: 0.3, Channels: ["ABS"]}
							, {Name: "TC/ABS", Indices: [8, 9], Size: 0.3, Channels: ["TC", "ABS"]}
							, {Name: "RPM", Indices: [6], Size: 0.5, Channels: ["RPM"]}
							, {Name: "Gear", Indices: [5], Size: 0.5, Channels: ["Gear"]}
							, {Name: "Long G", Indices: [10], Size: 1, Channels: ["Long G"]}
							, {Name: "Lat G", Indices: [11], Size: 1, Channels: ["Lat G"]}
							, {Name: "Long G/Lat G", Indices: [10, 11], Size: 1, Channels: ["Long G", "Lat G"]}
							, {Name: "Curvature", Function: computeCurvature, Indices: [false], Size: 1, Channels: ["Curvature"]}
							, {Name: "Time", Indices: [14], Size: 1, Channels: ["Time"], Converter: [(t) => isNumber(t) ? (t / 1000) : kNull]}
							, {Name: "PosX", Indices: [12], Channels: []}
							, {Name: "PosY", Indices: [13], Channels: []}]


;;;-------------------------------------------------------------------------;;;
;;;                          Public Classes Section                         ;;;
;;;-------------------------------------------------------------------------;;;

class TelemetryCollector {
	iSimulator := false
	iTrack := false
	iTrackLength := false

	iTelemetryDirectory := false
	iTelemetryCollectorPID := false

	iExitCallback := false

	iCollecting := false

	class SectionCollector {
		iTelemetryCollector := false
		iFileName := false

		iCollected := false

		TelemetryCollector {
			Get {
				return this.iTelemetryCollector
			}
		}

		FileName {
			Get {
				if !this.iCollected
					this.stop()

				return this.iFileName
			}
		}

		__New(collector) {
			this.iTelemetryCollector := collector
			this.iFileName := temporaryFileName(normalizeDirectoryPath(collector.TelemetryDirectory) . "Telemetry", "section")

			this.iCorner := corner

			if collector.iCollecting
				throw "Partial telemetry collection still running in TelemetryCollector.SectionCollector.__New..."

			FileAppend("", normalizeDirectoryPath(collector.TelemetryDirectory) . "Section.tmp")

			collector.iCollecting := true
		}

		dispose() {
			deleteFile(this.FileName)
		}

		stop() {
			local fileName := (normalizeDirectoryPath(this.TelemetryDirectory) . "Section.tmp")

			if !this.iCollected {
				if !FileExist(fileName)
					throw "No partial telemetry collection running in TelemetryCollector.SectionCollector.shutdown..."

				loop
					try {
						FileMove(fileName, this.FileName, 1)

						break
					}
					catch Any {
						Sleep(1)
					}

				this.iCollected := true
			}
		}
	}

	Simulator {
		Get {
			return this.iSimulator
		}
	}

	Track {
		Get {
			return this.iTrack
		}
	}

	TrackLength {
		Get {
			return this.iTrackLength
		}
	}

	TelemetryDirectory {
		Get {
			return this.iTelemetryDirectory
		}
	}

	__New(telemetryDirectory, simulator, track, trackLength) {
		this.iTelemetryDirectory := telemetryDirectory

		this.initialize(simulator, track, trackLength)
	}

	initialize(simulator, track, trackLength) {
		this.iSimulator := simulator
		this.iTrack := track
		this.iTrackLength := trackLength
	}

	startup(restart := false) {
		local sessionDB := SessionDatabase()
		local code, exePath, pid, trackData

		if (this.iTelemetryCollectorPID && restart)
			this.shutdown(true)

		if (this.iTelemetryCollectorPID && !ProcessExist(this.iTelemetryCollectorPID))
			this.iTelemetryCollectorPID := false

		if !this.iTelemetryCollectorPID {
			code := sessionDB.getSimulatorCode(this.iSimulator)
			exePath := (kBinariesDirectory . "Providers\" . code . " SHM Spotter.exe")
			pid := false

			try {
				if !FileExist(exePath)
					throw "File not found..."

				DirCreate(this.TelemetryDirectory)

				trackData := sessionDB.getTrackData(code, this.Track)

				Run("`"" . exePath . "`" -Telemetry " . this.iTrackLength
				  . " `"" . normalizeDirectoryPath(this.TelemetryDirectory) . "`"" . (trackData ? (" `"" . trackData . "`"") : "")
				  , kBinariesDirectory, "Hide", &pid)
			}
			catch Any as exception {
				logError(exception, true)

				logMessage(kLogCritical, substituteVariables(translate("Cannot start %simulator% %protocol% Spotter (")
														   , {simulator: code, protocol: "SHM"})
									   . exePath . translate(") - please rebuild the applications in the binaries folder (")
									   . kBinariesDirectory . translate(")"))

				if !kSilentMode
					showMessage(substituteVariables(translate("Cannot start %simulator% %protocol% Spotter (%exePath%) - please check the configuration...")
												  , {exePath: exePath, simulator: code, protocol: "SHM"})
							  , translate("Modular Simulator Controller System"), "Alert.png", 5000, "Center", "Bottom", 800)
			}

			if pid {
				this.iTelemetryCollectorPID := pid
				this.iCollecting := false

				if !this.iExitCallback {
					this.iExitCallback := ObjBindMethod(this, "shutdown", true)

					OnExit(this.iExitCallback)
				}

				return true
			}
			else
				return false
		}
		else
			return true
	}

	shutdown(force := false, arguments*) {
		local pid := this.iTelemetryCollectorPID
		local tries

		if ((arguments.Length > 0) && inList(["Logoff", "Shutdown"], arguments[1]))
			return false

		if pid {
			ProcessClose(pid)

			if (force && ProcessExist(pid)) {
				Sleep(500)

				tries := 5

				while (tries-- > 0) {
					pid := ProcessExist(pid)

					if pid {
						ProcessClose(pid)

						Sleep(500)
					}
					else
						break
				}
			}

			this.iTelemetryCollectorPID := false
			this.iCollecting := false
		}

		return false
	}

	collect() {
		return TelemetryCollector.SectionCollector(this)
	}
}


;;;-------------------------------------------------------------------------;;;
;;;                      Private Functions Section                          ;;;
;;;-------------------------------------------------------------------------;;;

computeCurvature(data) {
	local absG

	if data.Has(11) {
		absG := Abs(data[11])

		if (absG > 0.1)
			return - Log(((data[7] / 3.6) ** 2) / absG)
		else
			return kNull
	}
	else
		return kNull
}