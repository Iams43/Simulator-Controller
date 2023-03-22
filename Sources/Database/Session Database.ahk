﻿;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   Modular Simulator Controller System - Session Database Tool           ;;;
;;;                                                                         ;;;
;;;   Author:     Oliver Juwig (TheBigO)                                    ;;;
;;;   License:    (2023) Creative Commons - BY-NC-SA                        ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;-------------------------------------------------------------------------;;;
;;;                       Global Declaration Section                        ;;;
;;;-------------------------------------------------------------------------;;;

;@SC-IF %configuration% == Development
#Include ..\Framework\Development.ahk
;@SC-EndIF

;@SC-If %configuration% == Production
;@SC #Include ..\Framework\Production.ahk
;@SC-EndIf

;@Ahk2Exe-SetMainIcon ..\..\Resources\Icons\Session Database.ico
;@Ahk2Exe-ExeName Session Database.exe


;;;-------------------------------------------------------------------------;;;
;;;                         Global Include Section                          ;;;
;;;-------------------------------------------------------------------------;;;

#Include ..\Framework\Application.ahk


;;;-------------------------------------------------------------------------;;;
;;;                         Local Include Section                           ;;;
;;;-------------------------------------------------------------------------;;;

#Include ..\Libraries\Task.ahk
#Include ..\Libraries\GDIP.ahk
#Include ..\Libraries\CLR.ahk
#Include ..\Database\Libraries\SettingsDatabase.ahk
#Include ..\Database\Libraries\TelemetryDatabase.ahk
#Include ..\Database\Libraries\TyresDatabase.ahk
#Include ..\Assistants\Libraries\PressuresEditor.ahk


;;;-------------------------------------------------------------------------;;;
;;;                   Private Constant Declaration Section                  ;;;
;;;-------------------------------------------------------------------------;;;

global kOk := "Ok"
global kCancel := "Cancel"
global kClose := "Close"

global kSetupNames := {DQ: "Qualifying (Dry)", DR: "Race (Dry)", WQ: "Qualifying (Wet)", WR: "Race (Wet)"}


;;;-------------------------------------------------------------------------;;;
;;;                         Public Classes Section                          ;;;
;;;-------------------------------------------------------------------------;;;

global databaseScopeDropDown

global simulatorDropDown
global carDropDown
global trackDropDown
global weatherDropDown

global notesEdit

global settingsTab

global settingsImg1
global settingsImg2
global settingsImg3
global settingsImg4
global settingsImg5
global settingsImg6
global settingsTab1
global settingsTab2
global settingsTab3
global settingsTab4
global settingsTab5
global settingsTab6

global settingDropDown
global settingValueDropDown
global settingValueEdit
global settingValueText
global settingValueCheck

global addSettingButton
global deleteSettingButton

global dataSelectCheck

global exportDataButton
global importDataButton
global deleteDataButton

global trackDisplay

global trackAutomationNameEdit
global trackAutomationNameHandle
global trackAutomationInfoEdit
global addTrackAutomationButton
global deleteTrackAutomationButton
global saveTrackAutomationButton

global uploadStrategyButton
global downloadStrategyButton
global renameStrategyButton
global deleteStrategyButton

global shareStrategyWithCommunityCheck
global shareStrategyWithTeamServerCheck

global setupTypeDropDown
global uploadSetupButton
global downloadSetupButton
global renameSetupButton
global deleteSetupButton

global shareSetupWithCommunityCheck
global shareSetupWithTeamServerCheck

global dryQualificationDropDown
global uploadDryQualificationButton
global downloadDryQualificationButton
global deleteDryQualificationButton
global dryRaceDropDown
global uploadDryRaceButton
global downloadDryRaceButton
global deleteDryRaceButton
global wetQualificationDropDown
global uploadWetQualificationButton
global downloadWetQualificationButton
global deleteWetQualificationButton
global wetRaceDropDown
global uploadWetRaceButton
global downloadWetRaceButton
global deleteWetRaceButton

global driverDropDown
global editPressuresButton
global tyreCompoundDropDown
global airTemperatureEdit
global trackTemperatureEdit

global flPressure1
global flPressure2
global flPressure3
global flPressure4
global flPressure5

global frPressure1
global frPressure2
global frPressure3
global frPressure4
global frPressure5

global rlPressure1
global rlPressure2
global rlPressure3
global rlPressure4
global rlPressure5

global rrPressure1
global rrPressure2
global rrPressure3
global rrPressure4
global rrPressure5

global transferPressuresButton

class SessionDatabaseEditor extends ConfigurationItem {
	iRequestorPID := false
	iSettingDescriptors := newMultiMap()

	iSessionDatabase := SessionDatabase()

	iSelectedSimulator := false
	iSelectedCar := true
	iSelectedTrack := true
	iSelectedWeather := true

	iAllTracks := []

	iAirTemperature := 23
	iTrackTemperature := 27
	iTyreCompound := false
	iTyreCompoundColor := false

	iAvailableModules := {Settings: false, Setups: false, Pressures: false}
	iSelectedModule := false

	iSelectedSetupType := false

	iDataListView := false
	iSettingsListView := false
	iStrategyListView := false
	iSetupListView := false
	iAdministrationListView := false
	iTrackAutomationsListView := false

	iTrackAutomations := []
	iSelectedTrackAutomation := false

	iTrackMap := false
	iTrackImage := false

	iTrackDisplay := false
	iTrackDisplayArea := false

	iSettings := []

	class EditorTyresDatabase extends TyresDatabase {
		__New(controllerState := false) {
			super.__New()

			this.UseCommunity[false] := SessionDatabaseEditor.Instance.UseCommunity
		}
	}

	Window {
		Get {
			return "SDE"
		}
	}

	RequestorPID {
		Get {
			return this.iRequestorPID
		}
	}

	SettingDescriptors {
		Get {
			return this.iSettingDescriptors
		}
	}

	UseCommunity[persistent := false] {
		Get {
			return this.SessionDatabase.UseCommunity
		}

		Set {
			return (this.SessionDatabase.UseCommunity[persistent] := value)
		}
	}

	SessionDatabase {
		Get {
			return this.iSessionDatabase
		}
	}

	SelectedSimulator[label := false] {
		Get {
			if (label = "*")
				return ((this.iSelectedSimulator == true) ? "*" : this.iSelectedSimulator)
			else if label
				return this.iSelectedSimulator
			else
				return this.iSelectedSimulator
		}
	}

	SelectedCar[label := false] {
		Get {
			if ((label = "*") && (this.iSelectedCar == true))
				return "*"
			else if (label && (this.iSelectedCar == true))
				return translate("All")
			else
				return this.iSelectedCar
		}
	}

	SelectedTrack[label := false] {
		Get {
			if ((label = "*") && (this.iSelectedTrack == true))
				return "*"
			else if (label && (this.iSelectedTrack == true))
				return translate("All")
			else
				return this.iSelectedTrack
		}
	}

	SelectedWeather[label := false] {
		Get {
			if ((label = "*") && (this.iSelectedWeather == true))
				return "*"
			else if (label && (this.iSelectedWeather == true))
				return translate("All")
			else
				return this.iSelectedWeather
		}
	}

	SelectedModule {
		Get {
			return this.iSelectedModule
		}
	}

	SelectedSetupType {
		Get {
			return this.iSelectedSetupType
		}
	}

	DataListView {
		Get {
			return this.iDataListView
		}
	}

	SettingsListView {
		Get {
			return this.iSettingsListView
		}
	}

	StrategyListView {
		Get {
			return this.iStrategyListView
		}
	}

	SetupListView {
		Get {
			return this.iSetupListView
		}
	}

	AdministrationListView {
		Get {
			return this.iAdministrationListView
		}
	}

	TrackAutomations[key := false] {
		Get {
			return (key ? this.iTrackAutomations[key] : this.iTrackAutomations)
		}

		Set {
			return (key ? (this.iTrackAutomations[key] := value) : (this.iTrackAutomations := value))
		}
	}

	SelectedTrackAutomation {
		Get {
			return this.iSelectedTrackAutomation
		}
	}

	TrackMap {
		Get {
			return this.iTrackMap
		}
	}

	TrackImage {
		Get {
			return this.iTrackImage
		}
	}

	TrackAutomationsListView {
		Get {
			return this.iTrackAutomationsListView
		}
	}

	__New(simulator := false, car := false, track := false
		, weather := false, airTemperature := false, trackTemperature := false
		, compound := false, compoundColor := false, requestorPID := false) {
		if simulator {
			this.iSelectedSimulator := this.SessionDatabase.getSimulatorName(simulator)
			this.iSelectedCar := car
			this.iSelectedTrack := track
			this.iSelectedWeather := weather
			this.iAirTemperature := airTemperature
			this.iTrackTemperature := trackTemperature
			this.iTyreCompound := compound
			this.iTyreCompoundColor := compoundColor
		}

		this.iRequestorPID := requestorPID

		super.__New(kSimulatorConfiguration)

		SessionDatabaseEditor.Instance := this

		OnMessage(0x0200, "WM_MOUSEMOVE")
	}

	createGui(configuration) {
		local window := this.Window
		local x, y, car, track, weather, simulators, simulator, choices, chosen, tabs

		Gui %window%:Default

		Gui %window%:-Border ; -Caption
		Gui %window%:Color, D0D0D0, D8D8D8

		Gui %window%:Font, s10 Bold, Arial

		Gui %window%:Add, Text, w664 Center gmoveSessionDatabaseEditor, % translate("Modular Simulator Controller System")

		Gui %window%:Font, s9 Norm, Arial
		Gui %window%:Font, Italic Underline, Arial

		Gui %window%:Add, Text, x258 YP+20 w164 cBlue Center gopenSessionDatabaseEditorDocumentation, % translate("Session Database")

		Gui %window%:Add, Text, x8 yp+30 w670 0x10

		Gui %window%:Font, Norm
		Gui %window%:Font, s10 Bold, Arial

		Gui %window%:Add, Picture, x16 yp+12 w30 h30 Section, %kIconsDirectory%Road.ico
		Gui %window%:Add, Text, x50 yp+5 w120 h26, % translate("Selection")

		Gui %window%:Font, s8 Norm, Arial

		Gui %window%:Add, Text, x16 yp+32 w80 h23 +0x200, % translate("Simulator")

		car := this.SelectedCar
		track := this.SelectedTrack
		weather := this.SelectedWeather

		simulators := this.getSimulators()
		simulator := 0

		if (simulators.Length() > 0) {
			if this.SelectedSimulator
				simulator := inList(simulators, this.SelectedSimulator)

			if (simulator == 0)
				simulator := 1
		}

		Gui %window%:Add, DropDownList, x100 yp w160 Choose%simulator% vsimulatorDropDown gchooseSimulator, % values2String("|", simulators*)

		if (simulator > 0)
			simulator := simulators[simulator]
		else
			simulator := false

		Gui %window%:Add, Text, x16 yp+24 w80 h23 +0x200, % translate("Car")
		Gui %window%:Add, DropDownList, x100 yp w160 Choose1 vcarDropDown gchooseCar, % translate("All")

		Gui %window%:Add, Text, x16 yp+24 w80 h23 +0x200, % translate("Track")
		Gui %window%:Add, DropDownList, x100 yp w160 Choose1 vtrackDropDown gchooseTrack, % translate("All")

		Gui %window%:Add, Text, x16 yp+24 w80 h23 +0x200, % translate("Weather")

		choices := collect(kWeatherConditions, "translate")
		choices.InsertAt(1, translate("All"))
		chosen := inList(kWeatherConditions, weather)

		if (!chosen && (choices.Length() > 0)) {
			weather := true
			chosen := 1
		}

		Gui %window%:Add, DropDownList, x100 yp w160 AltSubmit Choose%chosen% gchooseWeather vweatherDropDown, % values2String("|", choices*)

		Gui %window%:Font, Norm
		Gui %window%:Font, s10 Bold, Arial

		Gui %window%:Add, Picture, x280 ys w30 h30 Section, %kIconsDirectory%Report.ico
		Gui %window%:Add, Text, xp+34 yp+5 w120 h26, % translate("Notes")

		Gui %window%:Add, Button, x647 yp w23 h23 HwndgeneralSettingsButtonHandle gshowSettings
		setButtonIcon(generalSettingsButtonHandle, kIconsDirectory . "General Settings.ico", 1)

		Gui %window%:Font, s8 Norm, Arial

		Gui %window%:Add, Edit, x280 yp+32 w390 h94 -Background gupdateNotes vnotesEdit

		Gui %window%:Add, Text, x16 yp+104 w654 0x10

		Gui %window%:Font, Norm
		Gui %window%:Font, s10 Bold, Arial

		Gui %window%:Add, Picture, x16 yp+12 w30 h30 Section vsettingsImg1 gchooseTab1, %kIconsDirectory%General Settings.ico
		Gui %window%:Add, Text, x50 yp+5 w220 h26 vsettingsTab1 gchooseTab1, % translate("Race Settings")

		Gui %window%:Add, Text, x16 yp+32 w267 0x10

		Gui %window%:Font, Norm
		Gui %window%:Font, s10 Bold cGray, Arial

		Gui %window%:Add, Picture, x16 yp+10 w30 h30 vsettingsImg2 gchooseTab2, %kIconsDirectory%Strategy.ico
		Gui %window%:Add, Text, x50 yp+5 w220 h26 vsettingsTab2 gchooseTab2, % translate("Strategies")

		Gui %window%:Add, Text, x16 yp+32 w267 0x10

		Gui %window%:Font, Norm
		Gui %window%:Font, s10 Bold cGray, Arial

		Gui %window%:Add, Picture, x16 yp+10 w30 h30 vsettingsImg3 gchooseTab3, %kIconsDirectory%Tools BW.ico
		Gui %window%:Add, Text, x50 yp+5 w220 h26 vsettingsTab3 gchooseTab3, % translate("Setups")

		Gui %window%:Add, Text, x16 yp+32 w267 0x10

		Gui %window%:Font, Norm
		Gui %window%:Font, s10 Bold cGray, Arial

		Gui %window%:Add, Picture, x16 yp+10 w30 h30 vsettingsImg4 gchooseTab4, %kIconsDirectory%Pressure.ico
		Gui %window%:Add, Text, x50 yp+5 w220 h26 vsettingsTab4 gchooseTab4, % translate("Tyre Pressures")

		Gui %window%:Add, Text, x16 yp+32 w267 0x10

		Gui %window%:Font, Norm
		Gui %window%:Font, s10 Bold cGray, Arial

		Gui %window%:Add, Picture, x16 yp+10 w30 h30 vsettingsImg5 gchooseTab5, %kIconsDirectory%Road.ico
		Gui %window%:Add, Text, x50 yp+5 w220 h26 vsettingsTab5 gchooseTab5, % translate("Automations")

		Gui %window%:Add, Text, x16 yp+32 w267 0x10

		Gui %window%:Font, Norm
		Gui %window%:Font, s10 Bold cGray, Arial

		Gui %window%:Add, Picture, x16 yp+10 w30 h30 vsettingsImg6 gchooseTab6, %kIconsDirectory%Sensor.ico
		Gui %window%:Add, Text, x50 yp+5 w220 h26 vsettingsTab6 gchooseTab6, % translate("Administration")

		Gui %window%:Add, Text, x16 yp+32 w267 0x10

		Gui %window%:Font, s8 Norm cBlack, Arial

		Gui %window%:Add, GroupBox, x280 ys-8 w390 h476

		tabs := collect(["Settings", "Stratgies", "Setups", "Pressures", "Automation", "Data"], "translate")

		Gui %window%:Add, Tab2, x296 ys+16 w0 h0 -Wrap vsettingsTab Section, % values2String("|", tabs*)

		Gui Tab, 1

		Gui %window%:Add, ListView, x296 ys w360 h326 -Multi -LV0x10 AltSubmit NoSort NoSortHdr HwndsettingsListViewHandle gchooseSetting, % values2String("|", collect(["Setting", "Value"], "translate")*)

		this.iSettingsListView := settingsListViewHandle

		Gui %window%:Add, Text, x296 yp+332 w80 h23 +0x200, % translate("Setting")
		Gui %window%:Add, DropDownList, xp+90 yp w270 vsettingDropDown gselectSetting

		Gui %window%:Add, Text, x296 yp+24 w80 h23 +0x200, % translate("Value")
		Gui %window%:Add, DropDownList, xp+90 yp w180 vsettingValueDropDown gchangeSetting
		Gui %window%:Add, Edit, xp yp w50 vsettingValueEdit gchangeSetting
		Gui %window%:Add, Edit, xp yp w210 h57 vsettingValueText gchangeSetting
		Gui %window%:Add, CheckBox, xp yp+4 vsettingValueCheck gchangeSetting

		Gui %window%:Add, Button, x606 yp+30 w23 h23 HWNDaddSettingButtonHandle gaddSetting vaddSettingButton
		Gui %window%:Add, Button, xp+25 yp w23 h23 HwnddeleteSettingButtonHandle gdeleteSetting vdeleteSettingButton
		setButtonIcon(addSettingButtonHandle, kIconsDirectory . "Plus.ico", 1)
		setButtonIcon(deleteSettingButtonHandle, kIconsDirectory . "Minus.ico", 1)

		Gui %window%:Add, Button, x440 yp+30 w80 h23 gtestSettings, % translate("Test...")

		Gui Tab, 2

		Gui %window%:Add, ListView, x296 ys w360 h326 -Multi -LV0x10 AltSubmit NoSort NoSortHdr HWNDlistViewHandle gchooseStrategy, % values2String("|", collect(["Source", "Name"], "translate")*)

		this.iStrategyListView := listViewHandle

		Gui %window%:Add, Button, xp+260 yp+328 w23 h23 HwnduploadStrategyButtonHandle guploadStrategy vuploadStrategyButton
		Gui %window%:Add, Button, xp+25 yp w23 h23 HwnddownloadStrategyButtonHandle gdownloadStrategy vdownloadStrategyButton
		Gui %window%:Add, Button, xp+25 yp w23 h23 HwndrenameStrategyButtonHandle grenameStrategy vrenameStrategyButton
		Gui %window%:Add, Button, xp+25 yp w23 h23 HwnddeleteStrategyButtonHandle gdeleteStrategy vdeleteStrategyButton
		setButtonIcon(uploadStrategyButtonHandle, kIconsDirectory . "Upload.ico", 1)
		setButtonIcon(downloadStrategyButtonHandle, kIconsDirectory . "Download.ico", 1)
		setButtonIcon(renameStrategyButtonHandle, kIconsDirectory . "Pencil.ico", 1)
		setButtonIcon(deleteStrategyButtonHandle, kIconsDirectory . "Minus.ico", 1)

		Gui %window%:Add, Text, x296 yp w80 h23 +0x200, % translate("Share")
		Gui %window%:Add, CheckBox, xp+90 yp+4 w140 vshareStrategyWithCommunityCheck gupdateStrategyAccess, % translate("with Community") ; -Theme
		Gui %window%:Add, CheckBox, xp yp+24 w140 vshareStrategyWithTeamServerCheck gupdateStrategyAccess, % translate("on Team Server") ; -Theme

		Gui Tab, 3

		Gui %window%:Add, Text, x296 ys w80 h23 +0x200, % translate("Purpose")
		Gui %window%:Add, DropDownList, xp+90 yp w270 AltSubmit Choose2 vsetupTypeDropDown gchooseSetupType, % values2String("|", collect(["Qualifying (Dry)", "Race (Dry)", "Qualifying (Wet)", "Race (Wet)"], "translate")*)

		Gui %window%:Add, ListView, x296 yp+24 w360 h302 -Multi -LV0x10 AltSubmit NoSort NoSortHdr HWNDlistViewHandle gchooseSetup, % values2String("|", collect(["Source", "Name"], "translate")*)

		this.iSetupListView := listViewHandle
		this.iSelectedSetupType := kDryRaceSetup

		Gui %window%:Add, Button, xp+260 yp+304 w23 h23 HwnduploadSetupButtonHandle guploadSetup vuploadSetupButton
		Gui %window%:Add, Button, xp+25 yp w23 h23 HwnddownloadSetupButtonHandle gdownloadSetup vdownloadSetupButton
		Gui %window%:Add, Button, xp+25 yp w23 h23 HwndrenameSetupButtonHandle grenameSetup vrenameSetupButton
		Gui %window%:Add, Button, xp+25 yp w23 h23 HwnddeleteSetupButtonHandle gdeleteSetup vdeleteSetupButton
		setButtonIcon(uploadSetupButtonHandle, kIconsDirectory . "Upload.ico", 1)
		setButtonIcon(downloadSetupButtonHandle, kIconsDirectory . "Download.ico", 1)
		setButtonIcon(renameSetupButtonHandle, kIconsDirectory . "Pencil.ico", 1)
		setButtonIcon(deleteSetupButtonHandle, kIconsDirectory . "Minus.ico", 1)

		Gui %window%:Add, Text, x296 yp w80 h23 +0x200, % translate("Share")
		Gui %window%:Add, CheckBox, xp+90 yp+4 w140 vshareSetupWithCommunityCheck gupdateSetupAccess, % translate("with Community") ; -Theme
		Gui %window%:Add, CheckBox, xp yp+24 w140 vshareSetupWithTeamServerCheck gupdateSetupAccess, % translate("on Team Server") ; -Theme

		Gui Tab, 4

		Gui %window%:Add, Text, x296 ys w85 h23 +0x200, % translate("Driver")
		Gui %window%:Add, DropDownList, x386 yp w100 vdriverDropDown gloadPressures

		Gui %window%:Add, Button, x494 yp w22 h22 HWNDeditPressuresButtonHandle veditPressuresButton geditPressures
		setButtonIcon(editPressuresButtonHandle, kIconsDirectory . "Pencil.ico", 1, "L2 T2 R2 B2")

		Gui %window%:Add, Text, x296 yp+24 w85 h23 +0x200, % translate("Compound")
		Gui %window%:Add, DropDownList, x386 yp w100 AltSubmit gloadPressures vtyreCompoundDropDown

		Gui %window%:Add, Edit, x494 yp w40 -Background Number Limit2 gloadPressures vairTemperatureEdit, % Round(convertUnit("Temperature", this.iAirTemperature))
		Gui %window%:Add, UpDown, xp+32 yp-2 w18 h20 Range0-99, % Round(convertUnit("Temperature", this.iAirTemperature))
		Gui %window%:Add, Text, xp+42 yp+2 w120 h23 +0x200, % substituteVariables(translate("Temp. Air (%unit%)"), {unit: getUnit("Temperature", true)})

		Gui %window%:Add, Edit, x494 yp+24 w40 -Background Number Limit2 gloadPressures vtrackTemperatureEdit, % Round(convertUnit("Temperature", this.iTrackTemperature))
		Gui %window%:Add, UpDown, xp+32 yp-2 w18 h20 Range0-99, % Round(convertUnit("Temperature", this.iTrackTemperature))
		Gui %window%:Add, Text, xp+42 yp+2 w120 h23 +0x200, % substituteVariables(translate("Temp. Track (%unit%)"), {unit: getUnit("Temperature", true)})

		Gui %window%:Font, Norm, Arial
		Gui %window%:Font, Bold Italic, Arial

		Gui %window%:Add, Text, x342 yp+30 w267 0x10
		Gui %window%:Add, Text, x296 yp+10 w370 h20 Center BackgroundTrans, % substituteVariables(translate("Pressures (%unit%)"), {unit: getUnit("Pressure")})

		Gui %window%:Font, Norm, Arial

		Gui %window%:Add, Text, x296 yp+30 w85 h23 +0x200, % translate("Front Left")
		Gui %window%:Add, Edit, xp+90 yp w50 Disabled Center vflPressure1, % displayValue("Float", 0.0)
		Gui %window%:Add, Edit, xp+54 yp w50 Disabled Center vflPressure2, % displayValue("Float", 0.0)
		Gui %window%:Add, Edit, xp+54 yp w50 Center +Background vflPressure3, % displayValue("Float", 0.0)
		Gui %window%:Add, Edit, xp+54 yp w50 Disabled Center vflPressure4, % displayValue("Float", 0.0)
		Gui %window%:Add, Edit, xp+54 yp w50 Disabled Center vflPressure5, % displayValue("Float", 0.0)

		Gui %window%:Add, Text, x296 yp+30 w85 h23 +0x200, % translate("Front Right")
		Gui %window%:Add, Edit, xp+90 yp w50 Disabled Center vfrPressure1, % displayValue("Float", 0.0)
		Gui %window%:Add, Edit, xp+54 yp w50 Disabled Center vfrPressure2, % displayValue("Float", 0.0)
		Gui %window%:Add, Edit, xp+54 yp w50 Center +Background vfrPressure3, % displayValue("Float", 0.0)
		Gui %window%:Add, Edit, xp+54 yp w50 Disabled Center vfrPressure4, % displayValue("Float", 0.0)
		Gui %window%:Add, Edit, xp+54 yp w50 Disabled Center vfrPressure5, % displayValue("Float", 0.0)

		Gui %window%:Add, Text, x296 yp+30 w85 h23 +0x200, % translate("Rear Left")
		Gui %window%:Add, Edit, xp+90 yp w50 Disabled Center vrlPressure1, % displayValue("Float", 0.0)
		Gui %window%:Add, Edit, xp+54 yp w50 Disabled Center vrlPressure2, % displayValue("Float", 0.0)
		Gui %window%:Add, Edit, xp+54 yp w50 Center +Background vrlPressure3, % displayValue("Float", 0.0)
		Gui %window%:Add, Edit, xp+54 yp w50 Disabled Center vrlPressure4, % displayValue("Float", 0.0)
		Gui %window%:Add, Edit, xp+54 yp w50 Disabled Center vrlPressure5, % displayValue("Float", 0.0)

		Gui %window%:Add, Text, x296 yp+30 w85 h23 +0x200, % translate("Rear Right")
		Gui %window%:Add, Edit, xp+90 yp w50 Disabled Center vrrPressure1, % displayValue("Float", 0.0)
		Gui %window%:Add, Edit, xp+54 yp w50 Disabled Center vrrPressure2, % displayValue("Float", 0.0)
		Gui %window%:Add, Edit, xp+54 yp w50 Center +Background vrrPressure3, % displayValue("Float", 0.0)
		Gui %window%:Add, Edit, xp+54 yp w50 Disabled Center vrrPressure4, % displayValue("Float", 0.0)
		Gui %window%:Add, Edit, xp+54 yp w50 Disabled Center vrrPressure5, % displayValue("Float", 0.0)

		if this.RequestorPID
			Gui %window%:Add, Button, x440 yp+50 w80 h23 gtransferPressures vtransferPressuresButton, % translate("Load")

		Gui Tab, 5

		this.iTrackDisplayArea := [297, 239, 358, 350, 0, 0]

		Gui %window%:Add, Picture, x296 y238 w360 h352 Border
		Gui %window%:Add, Picture, x297 y239 w358 h350 HWNDtrackDisplay vtrackDisplay gselectTrackAction

		this.iTrackDisplay := trackDisplay

		Gui %window%:Add, ListView, x296 y597 w110 h85 -Multi -LV0x10 Checked AltSubmit NoSort NoSortHdr HWNDtrackAutomationsListViewHandle gselectTrackAutomation, % values2String("|", collect(["Name", "#"], "translate")*)

		this.iTrackAutomationsListView := trackAutomationsListViewHandle

		Gui %window%:Add, Text, x415 yp w60 h23 +0x200, % translate("Name")
		Gui %window%:Add, Edit, xp+60 yp w109 HWNDtrackAutomationNameHandle vtrackAutomationNameEdit

		Gui %window%:Add, Button, x584 yp w23 h23 HWNDaddTrackAutomationButtonHandle vaddTrackAutomationButton gaddTrackAutomation
		Gui %window%:Add, Button, xp+25 yp w23 h23 HwnddeleteTrackAutomationButtonHandle vdeleteTrackAutomationButton gdeleteTrackAutomation
		Gui %window%:Add, Button, xp+25 yp w23 h23 Center +0x200 HWNDsaveTrackAutomationButtonHandle vsaveTrackAutomationButton gsaveTrackAutomation
		setButtonIcon(addTrackAutomationButtonHandle, kIconsDirectory . "Plus.ico", 1)
		setButtonIcon(deleteTrackAutomationButtonHandle, kIconsDirectory . "Minus.ico", 1)
		setButtonIcon(saveTrackAutomationButtonHandle, kIconsDirectory . "Save.ico", 1, "L5 T5 R5 B5")

		Gui %window%:Add, Text, x415 yp+24 w60 h23 +0x200, % translate("Actions")
		Gui %window%:Add, Edit, xp+60 yp w181 h61 ReadOnly -Wrap vtrackAutomationInfoEdit

		Gui Tab, 6

		Gui %window%:Add, CheckBox, +Theme Check3 x296 ys+2 w15 h23 vdataSelectCheck gselectAllData

		Gui %window%:Add, ListView, x314 ys w342 h404 -Multi -LV0x10 Checked AltSubmit HwndadministrationListViewHandle gselectData, % values2String("|", collect(["Type", "Car / Track", "Driver", "#"], "translate")*) ; NoSort NoSortHdr

		this.iAdministrationListView := administrationListViewHandle

		Gui %window%:Add, Button, x314 yp+419 w90 h23 vexportDataButton gexportData, % translate("Export...")
		Gui %window%:Add, Button, xp+95 yp w90 h23 vimportDataButton gimportData, % translate("Import...")

		Gui %window%:Add, Button, x566 yp w90 h23 vdeleteDataButton gdeleteData, % translate("Delete...")

		Gui Tab

		Gui %window%:Add, Text, x16 ys+277 w100 h23 +0x200, % translate("Available Data")

		choices := ["User", "User & Community"]
		chosen := (this.UseCommunity ? 2 : 1)

		Gui %window%:Add, DropDownList, x120 yp w140 AltSubmit Choose%chosen% gchooseDatabaseScope vdatabaseScopeDropDown, % values2String("|", collect(choices, "translate")*)

		Gui %window%:Add, ListView, x16 ys+301 w244 h151 -Multi -LV0x10 AltSubmit NoSort NoSortHdr HWNDlistViewHandle gnoSelect, % values2String("|", collect(["Source", "Type", "#"], "translate")*)

		this.iDataListView := listViewHandle

		Gui %window%:Add, Text, x8 y700 w670 0x10

		/*
		choices := ["User", "User & Community"]
		chosen := (this.UseCommunity ? 2 : 1)

		Gui %window%:Add, Text, x16 y661 w55 h23 +0x200, % translate("Scope")
		Gui %window%:Add, DropDownList, x100 yp w160 AltSubmit Choose%chosen% gchooseDatabaseScope vdatabaseScopeDropDown, % values2String("|", collect(choices, "translate")*)
		*/


		Gui %window%:Add, Button, x304 y708 w80 h23 GcloseSessionDatabaseEditor, % translate("Close")

		this.loadSimulator(simulator, true)
		this.loadCar(car, true)
		this.loadTrack(track, true)
		this.loadWeather(weather, true)

		this.updateState()

		if (this.RequestorPID && this.moduleAvailable("Pressures"))
			this.selectModule("Pressures")
		else
			this.selectModule("Settings")
	}

	show() {
		local window := this.Window
		local x, y

		if getWindowPosition("Session Database", x, y)
			Gui %window%:Show, x%x% y%y%
		else
			Gui %window%:Show
	}

	getSimulators() {
		return this.SessionDatabase.getSimulators()
	}

	getCars(simulator) {
		return this.SessionDatabase.getCars(simulator)
	}

	getTracks(simulator, car := false) {
		local tracks, ignore, track

		if !car
			return []
		else if ((car == true) || (car = "*")) {
			if (this.iAllTracks.Length() > 0)
				return this.iAllTracks
			else {
				tracks := []

				for ignore, car in this.getCars(simulator)
					for ignore, track in this.getTracks(simulator, car)
						if !inList(tracks, track)
							tracks.Push(track)

				this.iAllTracks := tracks

				return tracks
			}
		}
		else
			return this.SessionDatabase.getTracks(simulator, car)
	}

	getCarName(simulator, car) {
		return this.SessionDatabase.getCarName(simulator, car)
	}

	getCarCode(simulator, car) {
		return this.SessionDatabase.getCarCode(simulator, car)
	}

	getTrackName(simulator, track) {
		return this.SessionDatabase.getTrackName(simulator, track, false)
	}

	getTrackCode(simulator, track) {
		return this.SessionDatabase.getTrackCode(simulator, track)
	}

	updateState() {
		local window := this.Window
		local sessionDB := this.SessionDatabase
		local simulator, car, track, defaultListView, selected, selectedEntries, row, type
		local name, info, index, driver

		Gui %window%:Default

		simulator := this.SelectedSimulator
		car := this.SelectedCar
		track := this.SelectedTrack

		if simulator {
			if !((car && (car != true)) && (track && (track != true)))
				if ((this.SelectedModule = "Strategies") || (this.SelectedModule = "Setups") || (this.SelectedModule = "Pressures"))
					this.selectModule("Settings")
		}

		if this.moduleAvailable("Settings") {
			GuiControl Enable, settingsImg1
			GuiControl, , settingsImg1, %kIconsDirectory%General Settings.ico
			Gui Font, s10 Bold cGray, Arial
		}
		else {
			GuiControl Disable, settingsImg1
			GuiControl, , settingsImg1, %kIconsDirectory%General Settings Gray.ico
			Gui Font, s10 Bold cSilver, Arial
		}

		GuiControl Font, settingsTab1

		if this.moduleAvailable("Strategies") {
			GuiControl Enable, settingsImg2
			GuiControl, , settingsImg2, %kIconsDirectory%Strategy.ico
			Gui Font, s10 Bold cGray, Arial
		}
		else {
			GuiControl Disable, settingsImg3
			GuiControl, , settingsImg2, %kIconsDirectory%Strategy Gray.ico
			Gui Font, s10 Bold cSilver, Arial
		}

		GuiControl Font, settingsTab2

		if this.moduleAvailable("Setups") {
			GuiControl Enable, settingsImg3
			GuiControl, , settingsImg3, %kIconsDirectory%Tools BW.ico
			Gui Font, s10 Bold cGray, Arial
		}
		else {
			GuiControl Disable, settingsImg3
			GuiControl, , settingsImg3, %kIconsDirectory%Tools Gray.ico
			Gui Font, s10 Bold cSilver, Arial
		}

		GuiControl Font, settingsTab3

		if this.moduleAvailable("Pressures") {
			GuiControl Enable, settingsImg4
			GuiControl, , settingsImg4, %kIconsDirectory%Pressure.ico
			Gui Font, s10 Bold cGray, Arial
		}
		else {
			GuiControl Disable, settingsImg4
			GuiControl, , settingsImg4, %kIconsDirectory%Pressure Gray.ico
			Gui Font, s10 Bold cSilver, Arial
		}

		GuiControl Font, settingsTab4

		if this.moduleAvailable("Automation") {
			GuiControl Enable, settingsImg5
			GuiControl, , settingsImg5, %kIconsDirectory%Road.ico
			Gui Font, s10 Bold cGray, Arial
		}
		else {
			GuiControl Disable, settingsImg5
			GuiControl, , settingsImg5, %kIconsDirectory%Road Gray.ico
			Gui Font, s10 Bold cSilver, Arial
		}

		GuiControl Font, settingsTab5

		if this.moduleAvailable("Data") {
			GuiControl Enable, settingsImg6
			GuiControl, , settingsImg6, %kIconsDirectory%Sensor.ico
			Gui Font, s10 Bold cGray, Arial
		}
		else {
			GuiControl Disable, settingsImg6
			GuiControl, , settingsImg6, %kIconsDirectory%Sensor Gray.ico
			Gui Font, s10 Bold cSilver, Arial
		}

		GuiControl Font, settingsTab6

		Gui Font, s10 Bold cBlack, Arial

		switch this.SelectedModule {
			case "Settings":
				GuiControl Font, settingsTab1
				GuiControl Choose, settingsTab, 1
			case "Strategies":
				GuiControl Font, settingsTab2
				GuiControl Choose, settingsTab, 2
			case "Setups":
				GuiControl Font, settingsTab3
				GuiControl Choose, settingsTab, 3
			case "Pressures":
				GuiControl Font, settingsTab4
				GuiControl Choose, settingsTab, 4
				GuiControl Disable, editPressuresButton

				if ((this.SelectedWeather != true) && !this.UseCommunity)
					for index, driver in sessionDB.getAllDrivers(this.SelectedSimulator)
						if (driver = sessionDB.ID) {
							GuiControlGet driverDropDown

							if (driverDropDown = sessionDB.getDriverName(this.SelectedSimulator, driver))
								GuiControl Enable, editPressuresButton

							break
						}
			case "Automation":
				GuiControl Font, settingsTab5
				GuiControl Choose, settingsTab, 5
			case "Data":
				GuiControl Font, settingsTab6
				GuiControl Choose, settingsTab, 6
		}

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % this.StrategyListView

			selected := LV_GetNext(0)

			if selected {
				LV_GetText(type, selected, 1)
				LV_GetText(name, selected, 2)

				GuiControl Enable, downloadStrategyButton

				if (type != translate("Community")) {
					info := this.SessionDatabase.readStrategyInfo(simulator, car, track, name)

					GuiControl Enable, deleteStrategyButton

					if (!info || (getMultiMapValue(info, "Origin", "Driver", false) = this.SessionDatabase.ID)) {
						GuiControl Enable, renameStrategyButton
						GuiControl Enable, shareStrategyWithCommunityCheck
						GuiControl Enable, shareStrategyWithTeamServerCheck
					}
					else {
						GuiControl Disable, renameStrategyButton
						GuiControl Disable, shareStrategyWithCommunityCheck
						GuiControl Disable, shareStrategyWithTeamServerCheck

						GuiControl, , shareStrategyWithCommunityCheck, 0
						GuiControl, , shareStrategyWithTeamServerCheck, 0
					}
				}
				else {
					GuiControl Disable, deleteStrategyButton
					GuiControl Disable, renameStrategyButton
					GuiControl Disable, shareStrategyWithCommunityCheck
					GuiControl Disable, shareStrategyWithTeamServerCheck

					GuiControl, , shareStrategyWithCommunityCheck, 0
					GuiControl, , shareStrategyWithTeamServerCheck, 0
				}
			}
			else {
				GuiControl Disable, downloadStrategyButton
				GuiControl Disable, deleteStrategyButton
				GuiControl Disable, renameStrategyButton
				GuiControl Disable, shareStrategyWithCommunityCheck
				GuiControl Disable, shareStrategyWithTeamServerCheck

				GuiControl, , shareStrategyWithCommunityCheck, 0
				GuiControl, , shareStrategyWithTeamServerCheck, 0
			}

			Gui ListView, % this.SetupListView

			selected := LV_GetNext(0)

			if selected {
				LV_GetText(type, selected, 1)
				LV_GetText(name, selected, 2)

				GuiControl Enable, downloadSetupButton

				if (type != translate("Community")) {
					GuiControlGet setupTypeDropDown

					info := this.SessionDatabase.readSetupInfo(simulator, car, track, kSetupTypes[setupTypeDropDown], name)

					GuiControl Enable, deleteSetupButton

					if (!info || (getMultiMapValue(info, "Origin", "Driver", false) = this.SessionDatabase.ID)) {
						GuiControl Enable, renameSetupButton
						GuiControl Enable, shareSetupWithCommunityCheck
						GuiControl Enable, shareSetupWithTeamServerCheck
					}
					else {
						GuiControl Disable, renameSetupButton
						GuiControl Disable, shareSetupWithCommunityCheck
						GuiControl Disable, shareSetupWithTeamServerCheck

						GuiControl, , shareSetupWithCommunityCheck, 0
						GuiControl, , shareSetupWithTeamServerCheck, 0
					}
				}
				else {
					GuiControl Disable, deleteSetupButton
					GuiControl Disable, renameSetupButton
					GuiControl Disable, shareSetupWithCommunityCheck
					GuiControl Disable, shareSetupWithTeamServerCheck

					GuiControl, , shareSetupWithCommunityCheck, 0
					GuiControl, , shareSetupWithTeamServerCheck, 0
				}
			}
			else {
				GuiControl Disable, downloadSetupButton
				GuiControl Disable, deleteSetupButton
				GuiControl Disable, renameSetupButton
				GuiControl Disable, shareSetupWithCommunityCheck
				GuiControl Disable, shareSetupWithTeamServerCheck

				GuiControl, , shareSetupWithCommunityCheck, 0
				GuiControl, , shareSetupWithTeamServerCheck, 0
			}

			Gui ListView, % this.SettingsListView

			selected := LV_GetNext(0)

			if selected {
				GuiControl Enable, deleteSettingButton
				GuiControl Enable, settingDropDown
				GuiControl Enable, settingValueDropDown
				GuiControl Enable, settingValueEdit
				GuiControl Enable, settingValueText
				GuiControl Enable, settingValueCheck
			}
			else {
				GuiControl Disable, deleteSettingButton
				GuiControl Disable, settingDropDown
				GuiControl Hide, settingValueDropDown
				GuiControl Disable, settingValueDropDown
				GuiControl Hide, settingValueCheck
				GuiControl Disable, settingValueCheck
				GuiControl Hide, settingValueText
				GuiControl Disable, settingValueText
				GuiControl Show, settingValueEdit
				GuiControl Disable, settingValueEdit

				GuiControl Choose, settingDropDown, 0
				GuiControl Choose, settingValueDropDown, 0

				settingValueEdit := ""
				GuiControl, , settingValueEdit, %settingValueEdit%
			}

			if (this.getAvailableSettings().Length() == 0)
				GuiControl Disable, addSettingButton
			else
				GuiControl Enable, addSettingButton

			Gui ListView, % this.AdministrationListView

			selectedEntries := 0

			row := LV_GetNext(0, "C")

			while row {
				selectedEntries += 1

				row := LV_GetNext(row, "C")
			}

			GuiControl Enable, importDataButton

			if (selectedEntries > 0) {
				GuiControl Enable, exportDataButton
				GuiControl Enable, deleteDataButton
			}
			else {
				GuiControl Disable, exportDataButton
				GuiControl Disable, deleteDataButton
			}

			if (selectedEntries = LV_GetCount())
				GuiControl, , dataSelectCheck, 1
			else if (selectedEntries > 0)
				GuiControl, , dataSelectCheck, -1
			else
				GuiControl, , dataSelectCheck, 0

			GuiControl Enable, addTrackAutomationButton

			if this.SelectedTrackAutomation {
				GuiControl Enable, trackAutomationNameEdit
				GuiControl Enable, deleteTrackAutomationButton
				GuiControl Enable, saveTrackAutomationButton
			}
			else {
				GuiControl Disable, trackAutomationNameEdit
				GuiControl Disable, deleteTrackAutomationButton
				GuiControl Disable, saveTrackAutomationButton
			}
		}
		finally {
			Gui ListView, %defaultListView%
		}
	}

	loadSimulator(simulator, force := false) {
		local window, choices, index, car, settings

		if (force || (simulator != this.SelectedSimulator)) {
			window := this.Window

			Gui %window%:Default

			this.iSelectedSimulator := simulator

			settings := readMultiMap(kUserConfigDirectory . "Application Settings.ini")

			setMultiMapValue(settings, "Session Database", "Simulator", simulator)

			writeMultiMap(kUserConfigDirectory . "Application Settings.ini", settings)

			this.iAllTracks := []

			GuiControl Choose, simulatorDropDown, % inList(this.getSimulators(), simulator)

			choices := this.getCars(simulator)

			for index, car in choices
				choices[index] := this.getCarName(simulator, car)

			choices.InsertAt(1, translate("All"))

			GuiControl, , carDropDown, % "|" . values2String("|", choices*)

			this.loadCar(true, true)
		}
	}

	loadCar(car, force := false) {
		local window, tracks, trackNames, settings

		if (force || (car != this.SelectedCar)) {
			this.iSelectedCar := car

			settings := readMultiMap(kUserConfigDirectory . "Application Settings.ini")

			setMultiMapValue(settings, "Session Database", "Car", car)

			writeMultiMap(kUserConfigDirectory . "Application Settings.ini", settings)

			window := this.Window

			Gui %window%:Default

			if (car == true)
				GuiControl Choose, carDropDown, 1
			else
				GuiControl Choose, carDropDown, % inList(this.getCars(this.SelectedSimulator), car) + 1

			tracks := this.getTracks(this.SelectedSimulator, car).Clone()
			trackNames := collect(tracks, ObjBindMethod(this, "getTrackName", this.SelectedSimulator))

			tracks.InsertAt(1, true)
			trackNames.InsertAt(1, translate("All"))

			GuiControl, , trackDropDown, % "|" . values2String("|", trackNames*)

			this.loadTrack(true, true)
		}
	}

	loadTrack(track, force := false) {
		local window, settings

		if (force || (track != this.SelectedTrack)) {
			this.iSelectedTrack := track

			settings := readMultiMap(kUserConfigDirectory . "Application Settings.ini")

			setMultiMapValue(settings, "Session Database", "Track", track)

			writeMultiMap(kUserConfigDirectory . "Application Settings.ini", settings)

			window := this.Window

			Gui %window%:Default

			if (track == true) {
				this.iSelectedTrack := true

				GuiControl Choose, trackDropDown, 1
			}
			else
				GuiControl Choose, trackDropDown, % (inList(this.getTracks(this.SelectedSimulator, this.SelectedCar), track) + 1)

			this.updateModules()
		}
	}

	loadWeather(weather, force := false) {
		local window

		if (force || (weather != this.SelectedWeather)) {
			this.iSelectedWeather := weather

			window := this.Window

			Gui %window%:Default

			if (weather == true)
				GuiControl Choose, weatherDropDown, 1
			else
				GuiControl Choose, weatherDropDown, % inList(kWeatherConditions, weather) + 1

			this.updateModules()
		}
	}

	loadStrategies(select := false) {
		local window, defaultListView, userStrategies, communityStrategies, ignore, name, info, origin

		window := this.Window

		Gui %window%:Default

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % this.StrategyListView

			LV_Delete()

			userStrategies := true
			communityStrategies := this.UseCommunity

			this.SessionDatabase.getStrategyNames(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, &userStrategies, &communityStrategies)

			Gui ListView, % this.StrategyListView

			for ignore, name in userStrategies {
				info := this.SessionDatabase.readStrategyInfo(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, name)

				if !info
					origin := translate("User")
				else {
					origin := getMultiMapValue(info, "Origin", "Driver", this.SessionDatabase.ID)

					origin := this.SessionDatabase.getDriverName(this.SelectedSimulator, origin)
				}

				if (select = name) {
					LV_Add("Select Vis", origin, name)

					select := LV_GetCount()
				}
				else
					LV_Add("", origin, name)
			}

			if communityStrategies
				for ignore, name in communityStrategies
					if !inList(userStrategies, name)
						LV_Add("", translate("Community"), name)

			LV_ModifyCol()

			loop 2
				LV_ModifyCol(A_Index, "AutoHdr")

			if select
				this.selectStrategy(select)
			else
				this.updateState()
		}
		finally {
			Gui ListView, %defaultListView%
		}
	}

	loadSetups(setupType, force := false, select := false) {
		local window, defaultListView, userSetups, communitySetups, ignore, name, info, origin

		if (force || (setupType != this.SelectedSetupType)) {
			window := this.Window

			Gui %window%:Default

			defaultListView := A_DefaultListView

			try {
				Gui ListView, % this.SetupListView

				LV_Delete()

				this.iSelectedSetupType := setupType

				GuiControl Choose, setupTypeDropDown, % inList(kSetupTypes, setupType)

				userSetups := true
				communitySetups := this.UseCommunity

				this.SessionDatabase.getSetupNames(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, &userSetups, &communitySetups)

				userSetups := userSetups[setupType]

				Gui ListView, % this.SetupListView

				for ignore, name in userSetups {
					info := this.SessionDatabase.readSetupInfo(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, setupType, name)

					if !info
						origin := translate("User")
					else {
						origin := getMultiMapValue(info, "Origin", "Driver", this.SessionDatabase.ID)

						origin := this.SessionDatabase.getDriverName(this.SelectedSimulator, origin)
					}

					if (select = name) {
						LV_Add("Select Vis", origin, name)

						select := LV_GetCount()
					}
					else
						LV_Add("", origin, name)
				}

				if communitySetups
					for ignore, name in communitySetups[setupType]
						if !inList(userSetups, name)
							LV_Add("", translate("Community"), name)

				LV_ModifyCol()

				loop 2
					LV_ModifyCol(A_Index, "AutoHdr")

				if select
					this.selectSetup(select)
				else
					this.updateState()
			}
			finally {
				Gui ListView, %defaultListView%
			}
		}
	}

	loadSettings() {
		local window := this.Window
		local defaultListView, ignore, setting, type, value

		Gui %window%:Default

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % this.SettingsListView

			LV_Delete()

			this.iSettings := []

			for ignore, setting in new SettingsDatabase().readSettings(this.SelectedSimulator, this.SelectedCar["*"]
																	 , this.SelectedTrack["*"], this.SelectedWeather["*"]
																	 , false, false) {
				type := this.getSettingType(setting.Section, setting.Key, ignore)

				if type {
					if IsObject(type)
						value := translate(setting.Value)
					else if (type = "Boolean")
						value := (setting.Value ? "x" : "")
					else if (type = "Float")
						value := displayValue("Float", setting.Value)
					else
						value := setting.Value

					this.iSettings.Push(Array(setting.Section, setting.Key))

					Gui ListView, % this.SettingsListView

					LV_Add("", this.getSettingLabel(setting.Section, setting.Key), value)
				}
			}

			LV_ModifyCol()

			loop 3
				LV_ModifyCol(A_Index, "AutoHdr")

			this.updateState()
		}
		finally {
			Gui ListView, %defaultListView%
		}
	}

	selectSettings(load := true) {
		local window := this.Window
		local defaultListView, ignore, column, references, setting, reference, count

		Gui %window%:Default

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % this.DataListView

			LV_Delete()

			while LV_DeleteCol(1)
				ignore := 1

			for ignore, column in collect(["Reference", "#"], "translate") {
				Gui ListView, % this.DataListView

				LV_InsertCol(A_Index, "", column)
			}

			references := {Car: 0, AllCar: 0, Track: 0, AllTrack: 0, Weather: 0, AllWeather: 0}

			for ignore, setting in new SettingsDatabase().readSettings(this.SelectedSimulator, this.SelectedCar["*"]
																	 , this.SelectedTrack["*"], this.SelectedWeather["*"]
																	 , true, false) {
				if (setting.Car != "*")
					references.Car += 1
				else
					references.AllCar += 1

				if (setting.Track != "*")
					references.Track += 1
				else
					references.AllTrack += 1

				if (setting.Weather != "*")
					references.Weather += 1
				else
					references.AllWeather += 1
			}

			for reference, count in references
				if (count > 0) {
					switch reference {
						case "AllCar":
							reference := (translate("Car: ") . translate("All"))
						case "AllTrack":
							reference := (translate("Track: ") . translate("All"))
						case "AllWeather":
							reference := (translate("Weather: ") . translate("All"))
						case "Car":
							reference := (translate("Car: ") . this.getCarName(this.SelectedSimulator, this.SelectedCar))
						case "Track":
							reference := (translate("Track: ") . this.getTrackName(this.SelectedSimulator, this.SelectedTrack))
						case "Weather":
							reference := (translate("Weather: ") . translate(this.SelectedWeather))
					}

					Gui ListView, % this.DataListView

					LV_Add("", reference, count)
				}

			LV_ModifyCol()

			loop 2
				LV_ModifyCol(A_Index, "AutoHdr")

			if load
				this.loadSettings()
		}
		finally {
			Gui ListView, %defaultListView%
		}
	}

	findTrackCoordinate(x, y, ByRef coordinateX, ByRef coordinateY, threshold := 40) {
		local trackMap := this.TrackMap
		local trackImage := this.TrackImage
		local scale, offsetX, offsetY, marginX, marginY, width, height, imgWidth, imgHeight, imgScale
		local candidateX, candidateY, deltaX, deltaY, coordX, coordY, dX, dY

		if (this.SelectedTrackAutomation && trackMap && trackImage) {
			scale := getMultiMapValue(trackMap, "Map", "Scale")

			offsetX := getMultiMapValue(trackMap, "Map", "Offset.X")
			offsetY := getMultiMapValue(trackMap, "Map", "Offset.Y")

			marginX := getMultiMapValue(trackMap, "Map", "Margin.X")
			marginY := getMultiMapValue(trackMap, "Map", "Margin.Y")

			width := this.iTrackDisplayArea[3]
			height := this.iTrackDisplayArea[4]

			imgWidth := ((getMultiMapValue(trackMap, "Map", "Width") + (2 * marginX)) * scale)
			imgHeight := ((getMultiMapValue(trackMap, "Map", "Height") + (2 * marginY)) * scale)

			imgScale := Min(width / imgWidth, height / imgHeight)

			x := (x / imgScale)
			y := (y / imgScale)

			x := ((x / scale) - offsetX - marginX)
			y := ((y / scale) - offsetY - marginY)

			candidateX := kUndefined
			candidateY := false
			deltaX := false
			deltaY := false

			threshold := (threshold / scale)

			loop % getMultiMapValue(trackMap, "Map", "Points")
			{
				coordX := getMultiMapValue(trackMap, "Points", A_Index . ".X")
				coordY := getMultiMapValue(trackMap, "Points", A_Index . ".Y")

				dX := Abs(coordX - x)
				dY := Abs(coordY - y)

				if ((dX <= threshold) && (dY <= threshold) && ((candidateX == kUndefined) || ((dx + dy) < (deltaX + deltaY)))) {
					candidateX := coordX
					candidateY := coordY
					deltaX := dX
					deltaY := dY
				}
			}

			if (candidateX != kUndefined) {
				coordinateX := candidateX
				coordinateY := candidateY

				return true
			}
			else
				return false
		}
		else
			return false
	}

	findTrackAction(coordinateX, coordinateY, threshold := 40) {
		local trackMap := this.TrackMap
		local trackImage := this.TrackImage
		local candidate, deltaX, deltaY, dX, dY
		local index, action

		if (this.SelectedTrackAutomation && trackMap && trackImage) {
			candidate := false
			deltaX := false
			deltaY := false

			threshold := (threshold / getMultiMapValue(trackMap, "Map", "Scale"))

			for index, action in this.SelectedTrackAutomation.Actions {
				dX := Abs(coordinateX - action.X)
				dY := Abs(coordinateY - action.Y)

				if ((dX <= threshold) && (dY <= threshold) && (!candidate || ((dX + dy) < (deltaX + deltaY)))) {
					candidate := action

					deltaX := dx
					deltaY := dy
				}
			}

			return candidate
		}
		else
			return false
	}

	trackClicked(coordinateX, coordinateY) {
		local oldCoordMode := A_CoordModeMouse
		local x, y, action

		CoordMode Mouse, Screen

		MouseGetPos x, y

		CoordMode Mouse, %oldCoordMode%

		action := actionDialog(x, y)

		if action {
			action.X := coordinateX
			action.Y := coordinateY

			this.addTrackAction(action)
		}
	}

	actionClicked(coordinateX, coordinateY, action) {
		local oldCoordMode := A_CoordModeMouse
		local x, y

		CoordMode Mouse, Screen

		MouseGetPos x, y

		CoordMode Mouse, %oldCoordMode%

		action := actionDialog(x, y, action)

		if action
			this.updateTrackAction(action)
	}

	addTrackAction(action) {
		this.SelectedTrackAutomation.Actions.Push(action)

		this.updateTrackMap()
		this.updateTrackAutomationInfo()
	}

	updateTrackAction(action) {
		local index, candidate

		for index, candidate in this.SelectedTrackAutomation.Actions
			if ((action.X = candidate.X) && (action.Y = candidate.Y)) {
				this.SelectedTrackAutomation.Actions[index] := action

				this.updateTrackMap()
				this.updateTrackAutomationInfo()

				break
			}
	}

	deleteTrackAction(action) {
		local index, candidate

		for index, candidate in this.SelectedTrackAutomation.Actions
			if ((action.X = candidate.X) && (action.Y = candidate.Y)) {
				this.SelectedTrackAutomation.Actions.RemoveAt(index)

				this.updateTrackMap()
				this.updateTrackAutomationInfo()

				break
			}
	}

	addTrackAutomation() {
		local window := this.Window

		this.readTrackAutomations()

		this.iSelectedTrackAutomation := {Name: "...", Actions: []}

		this.updateState()

		Gui %window%:Default

		GuiControl, , trackAutomationNameEdit, % ""

		ControlFocus, , ahk_id %trackAutomationNameHandle%
	}

	deleteTrackAutomation() {
		if this.SelectedTrackAutomation.HasKey("Origin") {
			this.TrackAutomations.RemoveAt(inList(this.TrackAutomations, this.SelectedTrackAutomation.Origin))

			this.writeTrackAutomations()
		}
		else {
			this.clearTrackAutomationEditor()

			this.iSelectedTrackAutomation := false

			this.createTrackMap()

			this.updateState()
		}
	}

	saveTrackAutomation() {
		local window := this.Window
		local trackAutomation, origin, defaultListView, newTrackAutomation

		Gui %window%:Default

		GuiControlGet trackAutomationNameEdit

		trackAutomation := this.SelectedTrackAutomation

		trackAutomation.Name := trackAutomationNameEdit

		if trackAutomation.HasKey("Origin") {
			origin := this.SelectedTrackAutomation.Origin

			origin.Name := trackAutomationNameEdit
			origin.Actions := trackAutomation.Actions.Clone()

			defaultListView := A_DefaultListView

			try {
				Gui ListView, % this.TrackAutomationsListView

				LV_Modify(LV_GetNext(0), "", trackAutomationNameEdit, trackAutomation.Actions.Length())

				loop 2
					LV_ModifyCol(A_Index, "AutoHdr")
			}
			finally {
				Gui ListView, %defaultListView%
			}
		}
		else {
			newTrackAutomation := trackAutomation.Clone()
			newTrackAutomation.Actions := trackAutomation.Actions.Clone()

			trackAutomation.Origin := newTrackAutomation

			this.TrackAutomations.Push(newTrackAutomation)

			defaultListView := A_DefaultListView

			try {
				Gui ListView, % this.TrackAutomationsListView

				LV_Modify(LV_Add("Select", trackAutomationNameEdit, trackAutomation.Actions.Length()), "Vis")

				loop 2
					LV_ModifyCol(A_Index, "AutoHdr")
			}
			finally {
				Gui ListView, %defaultListView%
			}
		}

		this.writeTrackAutomations(false)
	}

	clearTrackAutomationEditor() {
		local window := this.Window

		Gui %window%:Default

		GuiControl, , trackAutomationNameEdit, % ""
		GuiControl, , trackAutomationInfoEdit, % ""
	}

	readTrackAutomations() {
		local defaultListView, trackAutomations, ignore, trackAutomation, option

		this.clearTrackAutomationEditor()

		this.TrackAutomations := []
		this.iSelectedTrackAutomation := false

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % this.TrackAutomationsListView

			LV_Delete()

			trackAutomations := this.SessionDatabase.getTrackAutomations(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack)

			this.iTrackAutomations := trackAutomations

			for ignore, trackAutomation in trackAutomations {
				option := (trackAutomation.Active ? "Check" : "")

				LV_Add(option, trackAutomation.Name, trackAutomation.Actions.Length())
			}

			LV_ModifyCol()

			loop 2
				LV_ModifyCol(A_Index, "AutoHdr")
		}
		finally {
			Gui ListView, %defaultListView%
		}

		this.loadTrackMap(this.SessionDatabase.getTrackMap(this.SelectedSimulator, this.SelectedTrack)
						, this.SessionDatabase.getTrackImage(this.SelectedSimulator, this.SelectedTrack))

		this.updateState()
	}

	writeTrackAutomations(read := true) {
		this.SessionDatabase.setTrackAutomations(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, this.TrackAutomations)

		if read
			this.readTrackAutomations()
	}

	createTrackMap(actions := false) {
		local trackMap := this.TrackMap
		local trackImage := this.TrackImage
		local scale := getMultiMapValue(trackMap, "Map", "Scale")
		local width := this.iTrackDisplayArea[3]
		local height := this.iTrackDisplayArea[4]
		local offsetX := getMultiMapValue(trackMap, "Map", "Offset.X")
		local offsetY := getMultiMapValue(trackMap, "Map", "Offset.Y")
		local marginX := getMultiMapValue(trackMap, "Map", "Margin.X")
		local marginY := getMultiMapValue(trackMap, "Map", "Margin.Y")
		local imgWidth := ((getMultiMapValue(trackMap, "Map", "Width") + (2 * marginX)) * scale)
		local imgHeight := ((getMultiMapValue(trackMap, "Map", "Height") + (2 * marginY)) * scale)
		local imgScale := Min(width / imgWidth, height / imgHeight)
		local token, bitmap, graphics, brushHotkey, brushCommand, r, ignore, action, x, y, trackImage, trackDisplay
		local pictureX, pictureY, pictureW, pictureH, deltaX, deltaY, window

		if actions {
			token := Gdip_Startup()

			bitmap := Gdip_CreateBitmapFromFile(trackImage)

			graphics := Gdip_GraphicsFromImage(bitmap)

			Gdip_SetSmoothingMode(graphics, 4)

			brushHotkey := Gdip_BrushCreateSolid(0xff00ff00)
			brushCommand := Gdip_BrushCreateSolid(0xffff0000)

			r := Round(15 / (imgScale * 3))

			for ignore, action in actions {
				x := Round((marginX + offsetX + action.X) * scale)
				y := Round((marginX + offsetY + action.Y) * scale)

				Gdip_FillEllipse(graphics, (action.Type = "Hotkey") ? brushHotkey : brushCommand, x - r, y - r, r * 2, r * 2)
			}

			Gdip_DeleteBrush(brushHotkey)
			Gdip_DeleteBrush(brushCommand)

			trackImage := temporaryFileName("Track Images\TrackMap", "png")

			Gdip_SaveBitmapToFile(bitmap, trackImage)

			Gdip_DisposeImage(bitmap)

			Gdip_DeleteGraphics(graphics)

			Gdip_Shutdown(token)
		}

		imgWidth *= imgScale
		imgHeight *= imgScale

		trackDisplay := this.iTrackDisplay

		window := this.Window

		Gui %window%:Default

		pictureX := this.iTrackDisplayArea[1]
		pictureY := this.iTrackDisplayArea[2]
		pictureW := this.iTrackDisplayArea[3]
		pictureH := this.iTrackDisplayArea[4]

		deltaX := ((this.iTrackDisplayArea[3] - imgWidth) / 2)
		deltaY := ((this.iTrackDisplayArea[4] - imgHeight) / 2)

		pictureX := Round(pictureX + deltaX)
		pictureY := Round(pictureY + deltaY)

		this.iTrackDisplayArea[5] := deltaX
		this.iTrackDisplayArea[6] := deltaY

		GuiControl Move, trackDisplay, x%pictureX%, y%pictureY%
		GuiControl, , %trackDisplay%, *w%imgWidth% *h%imgHeight% %trackImage%
	}

	updateTrackMap() {
		this.createTrackMap(this.SelectedTrackAutomation.Actions)
	}

	updateTrackAutomationInfo() {
		local window := this.Window
		local info := ""
		local index, action

		Gui %window%:Default

		for index, action in this.SelectedTrackAutomation.Actions {
			if (index > 1)
				info .= "`n"

			info .= (index . translate(" -> ")
				   . translate((action.Type = "Hotkey") ? (InStr(action.Action, "|") ? "Hotkey(s): " : "Hotkey: ") : "Command: ")
				   . action.Action)
		}

		GuiControl, , trackAutomationInfoEdit, %info%
	}

	loadTrackMap(trackMap, trackImage) {
		local directory := kTempDirectory . "Track Images"

		deleteDirectory(directory)

		FileCreateDir %directory%

		this.iTrackMap := trackMap
		this.iTrackImage := trackImage

		this.createTrackMap()
	}

	unloadTrackMap() {
		local display :=  this.iTrackDisplay

		GuiControl, , %display%, % (kIconsDirectory . "Empty.png")

		this.iTrackMap := false
		this.iTrackImage := false
	}

	selectAutomation() {
		local window := this.Window
		local defaultListView, ignore, column

		if this.TrackMap
			this.unloadTrackMap()

		this.readTrackAutomations()

		Gui %window%:Default

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % this.DataListView

			while LV_DeleteCol(1)
				ignore := 1

			for ignore, column in collect(["Type", "#"], "translate")
				LV_InsertCol(A_Index, "", column)

			LV_Delete()

			LV_Add("", translate("Track: "), 1)
			LV_Add("", translate("Automations: "), this.TrackAutomations.Length())

			LV_ModifyCol()

			loop 2
				LV_ModifyCol(A_Index, "AutoHdr")
		}
		finally {
			Gui ListView, %defaultListView%
		}
	}

	deleteEntries(connectors, database, localTable, serverTable, driver) {
		local ignore, connector, row

		database.lock(localTable)

		try {
			if (driver = this.SessionDatabase.ID)
				for ignore, connector in connectors
					try {
						for ignore, row in database.query(localTable, {Where: {Driver: driver}})
							if (row.Identifier != kNull)
								connector.DeleteData(serverTable, row.Identifier)
					}
					catch Any as exception {
						logError(exception, true)
					}

			database.remove(localTable, {Driver: driver}, Func("always").Bind(true))
		}
		finally {
			database.unlock(localTable)
		}
	}

	deleteData() {
		local connectors := this.SessionDatabase.Connectors
		local window := this.Window
		local progressWindow, defaultListView, simulator, count, row, type, data, car, track
		local driver, telemetryDB, tyresDB, code, candidate, progress
		local ignore, identifier, identifiers, name, extension

		Gui %window%:Default

		progressWindow := showProgress({color: "Green", title: translate("Deleting Data")})

		Gui %progressWindow%:+Owner%window%
		Gui %window%:Default
		Gui %window%:+Disabled

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % this.AdministrationListView

			simulator := this.SelectedSimulator

			count := 1

			row := LV_GetNext(0, "C")

			while (row := LV_GetNext(row, "C"))
				count += 1

			row := LV_GetNext(0, "C")
			progress := 0

			while row {
				progress += 1

				LV_GetText(type, row, 1)
				LV_GetText(data, row, 2)

				if InStr(data, " / ") {
					data := string2Values(" / ", data)

					car := data[1]
					track := data[2]
				}
				else if (type = translate("Tracks")) {
					car := "-"
					track := data
				}
				else {
					car := "-"
					track := "-"
				}

				LV_GetText(driver, row, 3)

				showProgress({progress: Round((progress / count) * 100)
							, message: translate("Car: ") . car . translate(", Track: ") . track})

				driver := this.SessionDatabase.getDriverID(simulator, driver)
				car := this.getCarCode(simulator, car)
				track := this.getTrackCode(simulator, track)

				switch type {
					case translate("Telemetry"):
						telemetryDB := TelemetryDatabase(simulator, car, track).Database

						this.deleteEntries(connectors, telemetryDB, "Electronics", "Electronics", driver)
						this.deleteEntries(connectors, telemetryDB, "Tyres", "Tyres", driver)
					case translate("Pressures"):
						tyresDB := TyresDatabase().getTyresDatabase(simulator, car, track)

						this.deleteEntries(connectors, tyresDB, "Tyres.Pressures", "TyresPressures", driver)
						this.deleteEntries(connectors, tyresDB, "Tyres.Pressures.Distribution", "TyresPressuresDistribution", driver)
					case translate("Strategies"):
						code := this.SessionDatabase.getSimulatorCode(simulator)

						loop Files, %kDatabaseDirectory%User\%code%\%car%\%track%\Race Strategies\*.strategy, F
							this.SessionDatabase.removeStrategy(simulator, car, track, A_LoopFileName)
					case translate("Setups"):
						code := this.SessionDatabase.getSimulatorCode(simulator)

						for ignore, type in kSetupTypes
							loop Files, %kDatabaseDirectory%User\%code%\%car%\%track%\Car Setups\%type%\*.*, F
							{
								SplitPath A_LoopFileName, name, , extension

								if (extension != "info")
									this.SessionDatabase.removeSetup(simulator, car, track, type, name)
							}
					case translate("Tracks"):
						code := this.SessionDatabase.getSimulatorCode(simulator)

						loop Files, %kDatabaseDirectory%User\Tracks\%code%\*.*, F
						{
							SplitPath A_LoopFileName, , , , candidate

							if (candidate = track)
								deleteFile(A_LoopFileLongPath)
						}
					case translate("Automations"):
						if this.SessionDatabase.hasTrackAutomations(simulator, car, track)
							this.SessionDatabase.setTrackAutomations(simulator, car, track, [])
				}

				Gui %window%:Default
				Gui ListView, % this.AdministrationListView

				row := LV_GetNext(row, "C")
			}
		}
		finally {
			Gui ListView, %defaultListView%
			Gui %window%:-Disabled

			hideProgress()
		}

		this.selectData()
	}

	exportData(directory) {
		local window := this.Window
		local progressWindow := showProgress({color: "Green", title: translate("Exporting Data")})
		local defaultListView, simulator, count, row, drivers, schemas, progress, type, data, car, track, driver, id
		local targetDirectory, sourceDB, targetDB, ignore, type, entry, code, candidate
		local trackAutomations, info, id, name, schema, fields

		directory := normalizeDirectoryPath(directory)

		Gui %progressWindow%:+Owner%window%
		Gui %window%:Default
		Gui %window%:+Disabled

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % this.AdministrationListView

			simulator := this.SelectedSimulator

			count := 1

			row := LV_GetNext(0, "C")

			while (row := LV_GetNext(row, "C"))
				count += 1

			row := LV_GetNext(0, "C")

			drivers := {}
			schemas := {}
			progress := 0

			while row {
				progress += 1

				LV_GetText(type, row, 1)
				LV_GetText(data, row, 2)

				if InStr(data, " / ") {
					data := string2Values(" / ", data)

					car := data[1]
					track := data[2]
				}
				else if (type = translate("Tracks")) {
					car := "-"
					track := data
				}
				else {
					car := "-"
					track := "-"
				}

				LV_GetText(driver, row, 3)

				id := this.SessionDatabase.getDriverID(simulator, driver)

				showProgress({progress: Round((progress / count) * 100)
							, message: translate("Car: ") . car . translate(", Track: ") . track})

				if id {
					drivers[id] := driver

					driver := id
				}

				car := this.getCarCode(simulator, car)
				track := this.getTrackCode(simulator, track)

				targetDirectory := (directory . "\" . car . "\" . track . "\")

				switch type {
					case translate("Telemetry"):
						sourceDB := TelemetryDatabase(simulator, car, track).Database
						targetDB := Database(targetDirectory, kTelemetrySchemas)

						schemas["Electronics"] := kTelemetrySchemas["ELectronics"]
						schemas["Tyres"] := kTelemetrySchemas["Tyres"]

						for ignore, entry in sourceDB.query("Electronics", {Where: {Driver: driver}})
							targetDB.add("Electronics", entry, true)

						for ignore, entry in sourceDB.query("Tyres", {Where: {Driver: driver}})
							targetDB.add("Tyres", entry, true)
					case translate("Pressures"):
						sourceDB := TyresDatabase().getTyresDatabase(simulator, car, track)
						targetDB := Database(targetDirectory, kTyresSchemas)

						schemas["Tyres.Pressures"] := kTyresSchemas["Tyres.Pressures"]
						schemas["Tyres.Pressures.Distribution"] := kTyresSchemas["Tyres.Pressures.Distribution"]

						for ignore, entry in sourceDB.query("Tyres.Pressures", {Where: {Driver: driver}})
							targetDB.add("Tyres.Pressures", entry, true)

						for ignore, entry in sourceDB.query("Tyres.Pressures.Distribution", {Where: {Driver: driver}})
							targetDB.add("Tyres.Pressures.Distribution", entry, true)
					case translate("Strategies"):
						code := this.SessionDatabase.getSimulatorCode(simulator)

						FileCreateDir %targetDirectory%Race Strategies

						loop Files, %kDatabaseDirectory%User\%code%\%car%\%track%\Race Strategies\*.*, F
							try {
								FileCopy %A_LoopFileLongPath%, %targetDirectory%Race Strategies\%A_LoopFileName%
							}
							catch Any as exception {
								logError(exception)
							}
					case translate("Setups"):
						code := this.SessionDatabase.getSimulatorCode(simulator)

						for ignore, type in kSetupTypes
							loop Files, %kDatabaseDirectory%User\%code%\%car%\%track%\Car Setups\%type%\*.*, F
							{
								FileCreateDir %targetDirectory%Car Setups\%type%

								try {
									FileCopy %A_LoopFileLongPath%, %targetDirectory%Car Setups\%type%\%A_LoopFileName%
								}
								catch Any as exception {
									logError(exception)
								}
							}
					case translate("Tracks"):
						code := this.SessionDatabase.getSimulatorCode(simulator)

						FileCreateDir %directory%\.Tracks

						loop Files, %kDatabaseDirectory%User\Tracks\%code%\*.*, F
						{
							SplitPath A_LoopFileName, , , , candidate

							if (candidate = track)
								try {
									FileCopy %A_LoopFileLongPath%, %directory%\.Tracks\%A_LoopFileName%
								}
								catch Any as exception {
									logError(exception)
								}
						}
					case translate("Automations"):
						trackAutomations := this.SessionDatabase.getTrackAutomations(simulator, car, track)

						this.SessionDatabase.saveTrackAutomations(trackAutomations, targetDirectory . "Track.automations")
				}

				Gui %window%:Default
				Gui ListView, % this.AdministrationListView

				row := LV_GetNext(row, "C")
			}

			info := newMultiMap()

			setMultiMapValue(info, "General", "Simulator", simulator)
			setMultiMapValue(info, "General", "Creator", this.SessionDatabase.ID)
			setMultiMapValue(info, "General", "Origin", this.SessionDatabase.DatabaseID)

			for id, name in drivers
				setMultiMapValue(info, "Driver", id, name)

			for schema, fields in schemas
				setMultiMapValue(info, "Schema", schema, values2String(",", fields*))

			writeMultiMap(directory . "\Export.info", info)
		}
		catch Any as exception {
			logError(exception)
		}
		finally {
			Gui ListView, %defaultListView%
			Gui %window%:-Disabled

			hideProgress()
		}
	}

	importData(directory, selection) {
		local window := this.Window
		local simulator := this.SelectedSimulator
		local info := readMultiMap(directory . "\Export.info")
		local progressWindow, schemas, schema, fields, id, name, progress, tracks, code, ignore, row, field
		local targetDirectory, car, carName, track, trackName, key, sourceDirectory, driver, sourceDB, targetDB
		local tyresDB, data, targetName, name, fileName, automations, automation, trackAutomations, trackName, extension

		directory := normalizeDirectoryPath(directory)

		if (this.SessionDatabase.getSimulatorName(getMultiMapValue(info, "General", "Simulator", "")) = simulator) {
			progressWindow := showProgress({color: "Green", title: translate("Importing Data")})

			Gui %progressWindow%:+Owner%window%
			Gui %window%:Default
			Gui %window%:+Disabled

			schemas := {}

			schemas["Electronics"] := kTelemetrySchemas["Electronics"]
			schemas["Tyres"] := kTelemetrySchemas["Tyres"]
			schemas["Tyres.Pressures"] := kTyresSchemas["Tyres.Pressures"]
			schemas["Tyres.Pressures.Distribution"] := kTyresSchemas["Tyres.Pressures.Distribution"]

			for schema, fields in getMultiMapValues(info, "Schema")
				schemas[schema] := string2Values(",", fields)

			try {
				for id, name in getMultiMapValues(info, "Driver")
					this.SessionDatabase.registerDriver(simulator, id, name)

				progress := 0

				if FileExist(directory . "\.Tracks") {
					tracks := []

					code := this.SessionDatabase.getSimulatorCode(simulator)

					loop Files, %directory%\.Tracks\*.*, F	; Track
					{
						SplitPath A_LoopFileName, , , , track

						if !inList(tracks, track)
							tracks.Push(track)
					}

					for ignore, track in tracks
						if selection.HasKey("-." . track . ".Tracks") {
							targetDirectory := (kDatabaseDirectory . "User\Tracks\" . code)

							FileCreateDir %targetDirectory%

							FileCopy %directory%\.Tracks\%track%.*, %targetDirectory%, 1
						}
				}

				loop Files, %directory%\*.*, D	; Car
					if (InStr(A_LoopFileName, ".") != 1) {
						car := A_LoopFileName
						carName := this.getCarName(simulator, car)

						loop Files, %directory%\%car%\*.*, D	; Track
						{
							track := A_LoopFileName
							trackName := this.getTrackName(simulator, track)

							key := (car . "." . track . ".")

							showProgress({progress: ++progress
										, message: translate("Car: ") . carName . translate(", Track: ") . trackName})

							if (progress >= 100)
								progress := 0

							sourceDirectory := (A_LoopFileDir . "\" . track)

							if selection.HasKey(key . "Telemetry") {
								driver := selection[key . "Telemetry"]

								sourceDB := Database(sourceDirectory . "\", schemas)
								targetDB := TelemetryDatabase(simulator, car, track).Database

								targetDB.lock("Electronics")

								try {
									for ignore, row in sourceDB.query("Electronics", {Where: {Driver: driver}}) {
										data := Object()

										for ignore, field in schemas["Electronics"]
											data[field] := row[field]

										targetDB.add("Electronics", data, true)
									}
								}
								finally {
									targetDB.unlock("Electronics")
								}

								targetDB.lock("Tyres")

								try {
									for ignore, row in sourceDB.query("Tyres", {Where: {Driver: driver}}) {
										data := Object()

										for ignore, field in schemas["Tyres"]
											data[field] := row[field]

										targetDB.add("Tyres", data, true)
									}
								}
								finally {
									targetDB.unlock("Tyres")
								}
							}

							if selection.HasKey(key . "Pressures") {
								driver := selection[key . "Pressures"]

								tyresDB := TyresDatabase()
								sourceDB := Database(sourceDirectory . "\", schemas)
								targetDB := tyresDB.lock(simulator, car, track)

								try {
									for ignore, row in sourceDB.query("Tyres.Pressures", {Where: {Driver: driver}}) {
										data := Object()

										for ignore, field in schemas["Tyres.Pressures"]
											data[field] := row[field]

										targetDB.add("Tyres.Pressures", data, true)
									}

									for ignore, row in sourceDB.query("Tyres.Pressures.Distribution", {Where: {Driver: driver}}) {
										tyresDB.updatePressure(simulator, car, track
															 , row.Weather, row["Temperature.Air"], row["Temperature.Track"]
															 , row.Compound, row["Compound.Color"]
															 , row.Type, row.Tyre, row.Pressure, row.Count
															 , false, true, "User", driver)
									}
								}
								finally {
									tyresDB.unlock()
								}
							}

							if (selection.HasKey(key . "Strategies") && FileExist(sourceDirectory . "\Race Strategies")) {
								code := this.SessionDatabase.getSimulatorCode(simulator)

								targetDirectory := (kDatabaseDirectory . "User\" . code . "\" . car . "\" . track . "\Race Strategies")

								FileCreateDir %targetDirectory%

								loop Files, %sourceDirectory%\Race Strategies\*.strategy, F
								{
									fileName := A_LoopFileName
									targetName := fileName

									while FileExist(targetDirectory . "\" . targetName) {
										SplitPath targetName, , , , name

										targetName := (name . " (" . (A_Index + 1) . ").strategy")
									}

									FileCopy %A_LoopFilePath%, %targetDirectory%\%targetName%

									if FileExist(A_LoopFilePath . ".info")
										FileCopy %A_LoopFilePath%.info, %targetDirectory%\%targetName%.info
								}
							}

							if (selection.HasKey(key . "Setups") && FileExist(sourceDirectory . "\Car Setups")) {
								code := this.SessionDatabase.getSimulatorCode(simulator)

								for ignore, type in kSetupTypes {
									targetDirectory := (kDatabaseDirectory . "User\" . code . "\" . car . "\" . track . "\Car Setups\" . type)

									FileCreateDir %targetDirectory%

									loop Files, %sourceDirectory%\Car Setups\%type%\*.*, F
									{
										SplitPath A_LoopFileName, , , extension

										if (extension != "info") {
											FileCopy %A_LoopFilePath%, %targetDirectory%\%A_LoopFileName%

											if FileExist(A_LoopFilePath . ".info")
												FileCopy %A_LoopFilePath%.info, %targetDirectory%\%A_LoopFileName%.info
										}
									}
								}
							}

							if (selection.HasKey(key . "Automations") && FileExist(sourceDirectory . "\Track.automations")) {
								code := this.SessionDatabase.getSimulatorCode(simulator)

								automations := this.SessionDatabase.loadTrackAutomations(sourceDirectory . "\Track.automations")

								trackAutomations := this.SessionDatabase.getTrackAutomations(simulator, car, track)

								for ignore, automation in automations {
									automation.Active := false

									trackAutomations.Push(automation)
								}

								this.SessionDatabase.setTrackAutomations(simulator, car, track, trackAutomations)
							}
						}
					}
			}
			catch Any as exception {
				logError(exception)
			}
			finally {
				Gui %window%:-Disabled

				hideProgress()
			}

			this.selectData()
		}
	}

	loadData() {
		local window := this.Window
		local progressWindow := showProgress({color: "Green", title: translate("Analyzing Data")})
		local defaultListView, selectedSimulator, selectedCar, selectedTrack, drivers, simulator, progress, tracks, track
		local car, carName, found, targetDirectory, telemetryDB, ignore, driver, tyresDB, result, count, strategies
		local automations, trackName, setups, ignore, type, extension

		Gui %progressWindow%:+Owner%window%
		Gui %window%:Default
		Gui %window%:+Disabled

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % this.AdministrationListView

			LV_Delete()

			selectedSimulator := this.SelectedSimulator
			selectedCar := this.SelectedCar
			selectedTrack := this.SelectedTrack

			if selectedSimulator {
				drivers := this.SessionDatabase.getAllDrivers(selectedSimulator)
				simulator := this.SessionDatabase.getSimulatorCode(selectedSimulator)

				progress := 0

				tracks := []

				loop Files, %kDatabaseDirectory%User\Tracks\%simulator%\*.*, F		; Tracks
				{
					SplitPath A_LoopFileName, , , , track

					if (((selectedTrack = true) || (track = selectedTrack)) && !inList(tracks, track)) {
						LV_Add("", translate("Tracks"), this.getTrackName(selectedSimulator, track)
							 , "-", 1)

						tracks.Push(track)
					}
				}

				loop Files, %kDatabaseDirectory%User\%simulator%\*.*, D					; Car
					if (InStr(A_LoopFileName, ".") != 1) {
						car := A_LoopFileName

						if ((selectedCar == true) || (car = selectedCar)) {
							carName := this.getCarName(selectedSimulator, car)

							loop Files, %kDatabaseDirectory%User\%simulator%\%car%\*.*, D		; Track
							{
								track := A_LoopFileName

								if ((selectedTrack == true) || (track = selectedTrack)) {
									trackName := this.getTrackName(selectedSimulator, track)
									found := false

									showProgress({progress: ++progress
												, message: translate("Car: ") . carName . translate(", Track: ") . trackName})

									if (progress >= 100)
										progress := 0

									Gui %window%:Default
									Gui ListView, % this.AdministrationListView

									targetDirectory := (kDatabaseDirectory . "User\" . simulator . "\" . car . "\" . track . "\")

									telemetryDB := TelemetryDatabase(simulator, car, track)

									for ignore, driver in drivers {
										count := (telemetryDB.getElectronicsCount(driver) + telemetryDB.getTyresCount(driver))

										if (count > 0)
											LV_Add("", translate("Telemetry"), (carName . " / " . trackName)
													 , this.SessionDatabase.getDriverName(selectedSimulator, driver)
													 , count)
									}

									tyresDB := TyresDatabase().getTyresDatabase(simulator, car, track)

									for ignore, driver in drivers {
										result := tyresDB.query("Tyres.Pressures", {Group: [["Driver", "count", "Count"]]
																				  , Where: {Driver: driver}})

										count := ((result.Length() > 0) ? result[1].Count : 0)

										result := tyresDB.query("Tyres.Pressures.Distribution"
															  , {Group: [["Driver", "count", "Count"]]
															   , Where: {Driver: driver}})

										count += ((result.Length() > 0) ? result[1].Count : 0)

										if (count > 0)
											LV_Add("", translate("Pressures"), (carName . " / " . trackName)
													 , this.SessionDatabase.getDriverName(selectedSimulator, driver)
													 , count)
									}

									strategies := 0

									loop Files, %kDatabaseDirectory%User\%simulator%\%car%\%track%\Race Strategies\*.strategy, F		; Strategies
										strategies += 1

									if (strategies > 0)
										LV_Add("", translate("Strategies"), (carName . " / " . trackName), "-", strategies)

									setups := 0

									for ignore, type in kSetupTypes
										loop Files, %kDatabaseDirectory%User\%simulator%\%car%\%track%\Car Setups\%type%\*.*, F		; Setups
										{
											SplitPath A_LoopFileName, , , extension

											if (extension != "info")
												setups += 1
										}

									if (setups > 0)
										LV_Add("", translate("Setups"), (carName . " / " . trackName), "-", setups)

									automations := this.SessionDatabase.getTrackAutomations(simulator, car, track).Length()

									if (automations > 0)
										LV_Add("", translate("Automations"), (carName . " / " . trackName), "-", automations)
								}
							}
						}
					}
			}

			LV_ModifyCol()

			loop 4
				LV_ModifyCol(A_Index, "AutoHdr")

			this.updateState()
		}
		finally {
			Gui ListView, %defaultListView%
			Gui %window%:-Disabled

			hideProgress()
		}
	}

	selectData(load := true) {
		local window := this.Window
		local defaultListView, ignore, column, selectedSimulator, selectedCar, selectedTrack, drivers, cars, telemetry
		local pressures, strategies, automations, tracks, simulator, track, car, found, targetDirectory, count
		local ignore, type, extension, setups

		Gui %window%:Default

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % this.DataListView

			LV_Delete()

			while LV_DeleteCol(1)
				ignore := 1

			for ignore, column in collect(["Type", "#"], "translate")
				LV_InsertCol(A_Index, "", column)

			selectedSimulator := this.SelectedSimulator
			selectedCar := this.SelectedCar
			selectedTrack := this.SelectedTrack

			if selectedSimulator {
				drivers := this.SessionDatabase.getAllDrivers(selectedSimulator)
				cars := []
				telemetry := 0
				pressures := 0
				strategies := 0
				setups := 0
				automations := 0
				tracks := 0

				simulator := this.SessionDatabase.getSimulatorCode(selectedSimulator)

				tracks := []

				loop Files, %kDatabaseDirectory%User\Tracks\%simulator%\*.*, F		; Strategies
				{
					SplitPath A_LoopFileName, , , , track

					if (((selectedTrack = true) || (track = selectedTrack)) && !inList(tracks, track))
						tracks.Push(track)
				}

				loop Files, %kDatabaseDirectory%User\%simulator%\*.*, D					; Car
					if (InStr(A_LoopFileName, ".") != 1) {
						car := A_LoopFileName

						if ((selectedCar == true) || (car = selectedCar))
							loop Files, %kDatabaseDirectory%User\%simulator%\%car%\*.*, D		; Track
							{
								track := A_LoopFileName

								if ((selectedTrack == true) || (track = selectedTrack)) {
									found := false

									targetDirectory := (kDatabaseDirectory . "User\" . simulator . "\" . car . "\" . track . "\")

									if (FileExist(targetDirectory . "Electronics.CSV") || FileExist(targetDirectory . "Tyres.CSV")) {
										found := true

										telemetry += 1
									}

									if (FileExist(targetDirectory . "Tyres.Pressures.CSV")
									 || FileExist(targetDirectory . "Tyres.Pressures.Distribution.CSV")) {
										found := true

										pressures += 1
									}

									loop Files, %kDatabaseDirectory%User\%simulator%\%car%\%track%\Race Strategies\*.*, F		; Strategies
									{
										found := true

										strategies += 1
									}

									for ignore, type in kSetupTypes
										loop Files, %kDatabaseDirectory%User\%simulator%\%car%\%track%\Car Setups\%type%\*.*, F		; Setups
										{
											SplitPath A_LoopFileName, , , extension

											if (extension != "info")
												setups += 1
										}

									count := this.SessionDatabase.getTrackAutomations(simulator, car, track).Length()

									if (count > 0) {
										automations += count

										found := true
									}

									if (found && !inList(cars, car))
										cars.Push(car)
								}
							}
				}

				LV_Add("", translate("Tracks"), tracks.Length())
				LV_Add("", translate("Automations"), automations)
				LV_Add("", translate("Drivers"), drivers.Length())
				LV_Add("", translate("Cars"), cars.Length())
				LV_Add("", translate("Telemetry"), telemetry)
				LV_Add("", translate("Pressures"), pressures)
				LV_Add("", translate("Strategies"), strategies)
				LV_Add("", translate("Setups"), setups)

				LV_ModifyCol()
				LV_ModifyCol(1, "AutoHdr")
				LV_ModifyCol(2, "AutoHdr")
			}

			if load
				this.loadData()
		}
		finally {
			Gui ListView, %defaultListView%
		}
	}

	selectStrategies() {
		local window := this.Window
		local defaultListView, ignore, column, userSetups, communitySetups, type, setups
		local info, origin

		Gui %window%:Default

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % this.DataListView

			LV_Delete()

			while LV_DeleteCol(1)
				ignore := 1

			for ignore, column in collect(["Source", "#"], "translate")
				LV_InsertCol(A_Index, "", column)

			userStrategies := true
			communityStrategies := true

			this.SessionDatabase.getStrategyNames(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, &userStrategies, &communityStrategies)

			LV_Add("", translate("User"), userStrategies.Length())

			LV_Add("", translate("Community"), communityStrategies.Length())

			LV_ModifyCol()

			loop 2
				LV_ModifyCol(A_Index, "AutoHdr")

			this.loadStrategies()
		}
		finally {
			Gui ListView, %defaultListView%
		}
	}

	selectSetups() {
		local window := this.Window
		local defaultListView, ignore, column, userSetups, communitySetups, type, setups
		local info, origin

		Gui %window%:Default

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % this.DataListView

			LV_Delete()

			while LV_DeleteCol(1)
				ignore := 1

			for ignore, column in collect(["Source", "Type", "#"], "translate")
				LV_InsertCol(A_Index, "", column)

			userSetups := true
			communitySetups := true

			this.SessionDatabase.getSetupNames(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, &userSetups, &communitySetups)

			for type, setups in userSetups
				LV_Add("", translate("User"), translate(kSetupNames[type]), setups.Length())

			for type, setups in communitySetups
				LV_Add("", translate("Community"), translate(kSetupNames[type]), setups.Length())

			LV_ModifyCol()

			loop 3
				LV_ModifyCol(A_Index, "AutoHdr")

			this.loadSetups(this.SelectedSetupType, true)
		}
		finally {
			Gui ListView, %defaultListView%
		}
	}

	selectPressures() {
		local window := this.Window
		local defaultListView, ignore, column, info, source, simulator

		Gui %window%:Default

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % this.DataListView

			LV_Delete()

			while LV_DeleteCol(1)
				ignore := 1

			for ignore, column in collect(["Source", "Weather", "T Air", "T Track", "Compound", "#"], "translate")
				LV_InsertCol(A_Index, "", column)

			sessionDB := this.SessionDatabase
			simulator := this.SelectedSimulator

			for ignore, info in new this.EditorTyresDatabase().getPressureInfo(simulator, this.SelectedCar
																			 , this.SelectedTrack, this.SelectedWeather) {
				if (info.Source = "User") {
					if (info.Driver = kNull)
						source := translate("User")
					else
						source := sessionDB.getDriverName(simulator, info.Driver)
				}
				else
					source := translate("Community")

				LV_Add("", source
						 , translate(info.Weather)
						 , Round(convertUnit("Temperature", info.AirTemperature))
						 , Round(convertUnit("Temperature", info.TrackTemperature))
						 , translate(info.Compound), info.Count)
			}

			LV_ModifyCol()

			loop 6
				LV_ModifyCol(A_Index, "AutoHdr")

			this.loadPressures()
		}
		finally {
			Gui ListView, %defaultListView%
		}
	}

	moduleAvailable(module) {
		local simulator := this.SelectedSimulator
		local car := this.SelectedCar
		local track := this.SelectedTrack

		if simulator {
			this.iAvailableModules["Settings"] := true
			this.iAvailableModules["Data"] := true

			if ((car && (car != true)) && (track && (track != true))) {
				this.iAvailableModules["Strategies"] := true
				this.iAvailableModules["Setups"] := true
				this.iAvailableModules["Pressures"] := true
				this.iAvailableModules["Automation"] := this.SessionDatabase.hasTrackMap(simulator, track)
			}
			else {
				this.iAvailableModules["Strategies"] := false
				this.iAvailableModules["Setups"] := false
				this.iAvailableModules["Pressures"] := false
				this.iAvailableModules["Automation"] := false
			}
		}
		else {
			this.iAvailableModules["Settings"] := false
			this.iAvailableModules["Data"] := false
			this.iAvailableModules["Strategies"] := false
			this.iAvailableModules["Setups"] := false
			this.iAvailableModules["Pressures"] := false
			this.iAvailableModules["Automation"] := false
		}

		return this.iAvailableModules[module]
	}

	selectModule(module, force := false) {
		local window

		if this.moduleAvailable(module) {
			if (force || (this.SelectedModule != module)) {
				this.iSelectedModule := module

				window := this.Window

				Gui %window%:Default

				if ((module != "Automation") && this.TrackMap)
					this.unloadTrackMap()

				if (module != "Pressures")
					Gui %window%:Color, D0D0D0, D8D8D8

				switch module {
					case "Settings":
						this.selectSettings()
					case "Data":
						this.selectData()
					case "Strategies":
						this.selectStrategies()
					case "Setups":
						this.selectSetups()
					case "Automation":
						this.selectAutomation()
					case "Pressures":
						this.selectPressures()
				}

				this.updateState()
			}
		}
	}

	updateModules() {
		local window := this.Window

		Gui %window%:Default
		Gui %window%:Color, D0D0D0, D8D8D8

		GuiControl, , notesEdit, % this.SessionDatabase.readNotes(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack)

		if this.moduleAvailable(this.SelectedModule)
			this.selectModule(this.SelectedModule, true)
		else
			this.selectModule("Settings", true)
	}

	updateNotes(notes) {
		this.SessionDatabase.writeNotes(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, notes)
	}

	getSettingLabel(section := false, key := false) {
		local window, defaultListView, selected

		if !section {
			window := this.Window

			Gui %window%:Default

			defaultListView := A_DefaultListView

			try {
				Gui ListView, % this.SettingsListView

				selected := LV_GetNext(0)

				if selected {
					section := this.iSettings[selected][1]
					key := this.iSettings[selected][2]
				}
			}
			finally {
				Gui ListView, %defaultListView%
			}
		}

		return getMultiMapValue(this.SettingDescriptors, section . ".Labels", key, "")
	}

	getSettingType(section := false, key := false, ByRef default := false) {
		local window, defaultListView, selected, type

		if !section {
			window := this.Window

			Gui %window%:Default

			defaultListView := A_DefaultListView

			try {
				Gui ListView, % this.SettingsListView

				selected := LV_GetNext(0)

				if selected {
					section := this.iSettings[selected][1]
					key := this.iSettings[selected][2]
				}
				else
					return default
			}
			finally {
				Gui ListView, %defaultListView%
			}
		}

		type := getMultiMapValue(this.SettingDescriptors, section . ".Types", key, false)

		if type {
			type := string2Values(";", type)

			default := type[2]
			type := type[1]

			if InStr(type, "Choices:")
				type := string2Values(",", string2Values(":", type)[2])

			if (default = kTrue)
				default := true
			else if (default = kFalse)
				default := false

			if (this.SelectedSimulator && (this.SelectedSimulator != true)
			 && this.SelectedCar && (this.SelectedCar != true) && (section = "Session Settings")) {
				if (InStr(key, "Tyre.Dry.Pressure.Target") = 1)
					default := this.SessionDatabase.optimalTyrePressure(this.SelectedSimulator, this.SelectedCar, "Dry", default)
				else if (InStr(key, "Tyre.Wet.Pressure.Target") = 1)
					default := this.SessionDatabase.optimalTyrePressure(this.SelectedSimulator, this.SelectedCar, "Wet", default)
			}
		}

		return type
	}

	getAvailableSettings(selection := false) {
		local found := false
		local fileName, settingDescriptors, section, values, key, value, settings, skip, ignore
		local available, index, candidate, rootDirectory

		if (this.SettingDescriptors.Count() = 0) {
			settingDescriptors := readMultiMap(kResourcesDirectory . "Database\Settings.ini")

			for ignore, rootDirectory in [kTranslationsDirectory, kUserTranslationsDirectory]
				if FileExist(rootDirectory . "Settings." . getLanguage()) {
					found := true

					for section, values in readMultiMap(rootDirectory . "Settings." . getLanguage())
						for key, value in values
							setMultiMapValue(settingDescriptors, section, key, value)
				}

			if !found
				for section, values in readMultiMap(kTranslationsDirectory . "Settings.en")
					for key, value in values
						setMultiMapValue(settingDescriptors, section, key, value)

			this.iSettingDescriptors := settingDescriptors
		}

		settings := []

		for section, values in this.SettingDescriptors
			if InStr(section, ".Types") {
				section := StrReplace(section, ".Types", "")

				if (InStr(section, "Simulator.") == 1)
					skip := (StrReplace(section, "Simulator.", "") != this.SelectedSimulator)
				else
					skip := false

				if !skip
					for key, ignore in values {
						available := true

						for index, candidate in this.iSettings
							if (index != selection)
								if ((section = candidate[1]) && (key = candidate[2])) {
									available := false

									break
								}

						if available
							settings.Push(Array(section, key))
					}
			}

		return settings
	}

	addSetting(section, key, value) {
		local window := this.Window
		local defaultListView, type, ignore, display

		Gui %window%:Default
		Gui %window%:+Disabled

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % this.SettingsListView

			this.iSettings.Push(Array(section, key))

			ignore := false

			type := this.getSettingType(section, key, ignore)

			if IsObject(type)
				display := translate(value)
			else if (type = "Boolean")
				display := (value ? "x" : "")
			else if (type = "Text")
				display := StrReplace(value, "`n", A_Space)
			else if (type = "Float")
				display := displayValue("Float", value)
			else
				display := value

			LV_Modify(LV_Add("Select", this.getSettingLabel(section, key), display), "Vis")

			LV_ModifyCol()

			LV_ModifyCol(1, "AutoHdr")
			LV_ModifyCol(2, "AutoHdr")

			new SettingsDatabase().setSettingValue(this.SelectedSimulator
												 , this.SelectedCar["*"], this.SelectedTrack["*"], this.SelectedWeather["*"]
												 , section, key, value)

			this.selectSettings(false)
			this.updateState()
		}
		finally {
			Gui %window%:-Disabled
			Gui ListView, %defaultListView%
		}
	}

	deleteSetting(section, key) {
		local window := this.Window
		local defaultListView, selected

		Gui %window%:Default
		Gui %window%:+Disabled

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % this.SettingsListView

			selected := LV_GetNext(0)

			LV_Delete(selected)

			LV_ModifyCol()

			LV_ModifyCol(1, "AutoHdr")
			LV_ModifyCol(2, "AutoHdr")

			new SettingsDatabase().removeSettingValue(this.SelectedSimulator
													, this.SelectedCar["*"], this.SelectedTrack["*"], this.SelectedWeather["*"]
													, section, key)

			this.iSettings.RemoveAt(selected)

			this.selectSettings(false)
			this.updateState()
		}
		finally {
			Gui %window%:-Disabled
			Gui ListView, %defaultListView%
		}
	}

	updateSetting(section, key, value) {
		local window := this.Window
		local defaultListView, selected, type, ignore, display, settingsDB

		Gui %window%:Default
		Gui %window%:+Disabled

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % this.SettingsListView

			selected := LV_GetNext(0)

			ignore := false

			type := this.getSettingType(section, key, ignore)

			if IsObject(type)
				display := translate(value)
			else if (type = "Boolean")
				display := (value ? "x" : "")
			else if (type = "Text")
				display := StrReplace(value, "`n", A_Space)
			else if (type = "Float")
				display := displayValue("Float", value)
			else
				display := value

			LV_Modify(selected, "", this.getSettingLabel(section, key), display)

			LV_ModifyCol()

			LV_ModifyCol(1, "AutoHdr")
			LV_ModifyCol(2, "AutoHdr")

			settingsDB := SettingsDatabase()

			if ((this.iSettings[selected][1] != section) || (this.iSettings[selected][2] != key)) {
				settingsDB.removeSettingValue(this.SelectedSimulator
											, this.SelectedCar["*"], this.SelectedTrack["*"], this.SelectedWeather["*"]
											, this.iSettings[selected][1], this.iSettings[selected][2])

				this.iSettings[selected][1] := section
				this.iSettings[selected][2] := key
			}

			settingsDB.setSettingValue(this.SelectedSimulator
									 , this.SelectedCar["*"], this.SelectedTrack["*"], this.SelectedWeather["*"]
									 , section, key, value)

			this.selectSettings(false)
			this.updateState()
		}
		finally {
			Gui %window%:-Disabled
			Gui ListView, %defaultListView%
		}
	}

	loadPressures() {
		local sessionDB := this.SessionDatabase
		local window, compounds, chosenCompound, compound, compoundColor, pressureInfos, index
		local ignore, tyre, postfix, tyre, pressureInfo, pressure, trackDelta, airDelta, color
		local drivers, driver, selectedDriver

		static lastSimulator := false
		static lastCar := false
		static lastTrack := false
		static lastCommunity := "__Undefined__"

		if (this.SelectedSimulator && (this.SelectedSimulator != true)
		 && this.SelectedCar && (this.SelectedCar != true)
		 && this.SelectedTrack && (this.SelectedSimulator != true)) {
			window := this.Window

			Gui %window%:Default

			static lastColor := "D0D0D0"

			try {
				GuiControlGet airTemperatureEdit
				GuiControlGet trackTemperatureEdit
				GuiControlGet tyreCompoundDropDown

				compounds := sessionDB.getTyreCompounds(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack)

				GuiControl, , tyreCompoundDropDown, % ("|" . values2String("|", collect(compounds, "translate")*))

				chosenCompound := 0

				if ((this.SelectedSimulator = lastSimulator) && (this.SelectedCar = lastCar) && (this.SelectedTrack = lastTrack))
					chosenCompound := tyreCompoundDropDown
				else if this.iTyreCompound
					chosenCompound := inList(compounds, compound(this.iTyreCompound, this.iTyreCompoundColor))

				if ((chosenCompound == 0) && (compounds.Length() > 0))
					chosenCompound := 1

				GuiControl Choose, tyreCompoundDropDown, %chosenCompound%

				if ((this.SelectedSimulator != lastSimulator) || (this.UseCommunity != lastCommunity)) {
					drivers := [translate("All")]
					selectedDriver := false

					if !this.UseCommunity
						for ignore, driver in sessionDB.getAllDrivers(this.SelectedSimulator) {
							if (driver = sessionDB.ID)
								selectedDriver := driver

							drivers.Push(sessionDB.getDriverName(this.SelectedSimulator, driver))
						}

					GuiControl, , driverDropDown, % "|" . values2String("|", drivers*)

					if selectedDriver {
						GuiControl Choose, driverDropDown, % inList(sessionDB.getAllDrivers(this.SelectedSimulator), selectedDriver) + 1

						driver := [[selectedDriver]]
					}
					else {
						GuiControl Choose, driverDropDown, 1

						driver := [true]
					}
				}
				else {
					GuiControlGet driverDropDown

					if (driverDropDown = translate("All"))
						driver := [true]
					else
						driver := [[sessionDB.getDriverID(this.SelectedSimulator, driverDropDown)]]
				}

				lastSimulator := this.SelectedSimulator
				lastCar := this.SelectedCar
				lastTrack := this.SelectedTrack
				lastCommunity := this.UseCommunity

				if chosenCompound {
					compound := false
					compoundColor := false

					splitCompound(compounds[chosenCompound], &compound, &compoundColor)

					this.iTyreCompound := compound
					this.iTyreCompoundColor := compoundColor

					pressureInfos := this.EditorTyresDatabase().getPressures(this.SelectedSimulator, this.SelectedCar
																			   , this.SelectedTrack, this.SelectedWeather
																			   , convertUnit("Temperature", airTemperatureEdit, false)
																			   , convertUnit("Temperature", trackTemperatureEdit, false)
																			   , compound, compoundColor, driver*)
				}
				else
					pressureInfos := []

				if (pressureInfos.Count() == 0) {
					for ignore, tyre in ["fl", "fr", "rl", "rr"]
						for ignore, postfix in ["1", "2", "3", "4", "5"] {
							GuiControl Text, %tyre%Pressure%postfix%, % displayValue("Float", 0.0)
							GuiControl +Background, %tyre%Pressure%postfix%
							GuiControl Disable, %tyre%Pressure%postfix%
						}

					if this.RequestorPID
						GuiControl Disable, transferPressuresButton
				}
				else {
					for tyre, pressureInfo in pressureInfos {
						pressure := pressureInfo["Pressure"]
						trackDelta := pressureInfo["Delta Track"]
						airDelta := pressureInfo["Delta Air"] + Round(trackDelta * 0.49)

						pressure -= 0.2

						if ((airDelta == 0) && (trackDelta == 0))
							color := "Green"
						else if (airDelta == 0)
							color := "Lime"
						else
							color := "Yellow"

						if (true || (color != lastColor)) {
							lastColor := color

							Gui %window%:Color, D0D0D0, %color%
						}

						for index, postfix in ["1", "2", "3", "4", "5"] {
							GuiControl Text, %tyre%Pressure%postfix%, % displayValue("Float", convertUnit("Pressure", pressure))

							if (index = (3 + airDelta)) {
								GuiControl +Background, %tyre%Pressure%postfix%
								GuiControl Enable, %tyre%Pressure%postfix%
							}
							else {
								GuiControl -Background, %tyre%Pressure%postfix%
								GuiControl Disable, %tyre%Pressure%postfix%
							}

							pressure += 0.1
						}

						if this.RequestorPID
							GuiControl Enable, transferPressuresButton
					}
				}
			}
			catch Any as exception {
				logError(exception)
			}

			this.updateState()
		}
	}

	openPressuresEditor() {
		local window := this.Window
		local configuration

		Gui PE:+Owner%window%
		Gui %window%:+Disabled

		Gui %window%:Default

		GuiControlGet airTemperatureEdit
		GuiControlGet trackTemperatureEdit
		GuiControlGet tyreCompoundDropDown

		if new PressuresEditor(this, this.iTyreCompound, this.iTyreCompoundColor
								   , Round(convertUnit("Temperature", airTemperatureEdit, false))
								   , Round(convertUnit("Temperature", trackTemperatureEdit, false))).editPressures()
			this.selectPressures()

		Gui %window%:-Disabled
	}

	selectStrategy(row) {
		local window := this.Window
		local name, info

		Gui %window%:Default

		Gui ListView, % this.StrategyListView

		LV_GetText(name, row, 2)

		info := this.SessionDatabase.readStrategyInfo(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, name)

		if (info && getMultiMapValue(info, "Origin", "Driver", false) = this.SessionDatabase.ID) {
			GuiControl, , shareStrategyWithCommunityCheck, % getMultiMapValue(info, "Access", "Share", false)
			GuiControl, , shareStrategyWithTeamServerCheck, % getMultiMapValue(info, "Access", "Synchronize", false)
		}
		else {
			GuiControl, , shareStrategyWithCommunityCheck, 0
			GuiControl, , shareStrategyWithTeamServerCheck, 0
		}

		this.updateState()
	}

	selectSetup(row) {
		local window := this.Window
		local type, name, info

		Gui %window%:Default

		GuiControlGet setupTypeDropDown

		type := kSetupTypes[setupTypeDropDown]

		Gui ListView, % this.SetupListView

		LV_GetText(name, row, 2)

		info := this.SessionDatabase.readSetupInfo(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, type, name)

		if (info && getMultiMapValue(info, "Origin", "Driver", false) = this.SessionDatabase.ID) {
			GuiControl, , shareSetupWithCommunityCheck, % getMultiMapValue(info, "Access", "Share", false)
			GuiControl, , shareSetupWithTeamServerCheck, % getMultiMapValue(info, "Access", "Synchronize", false)
		}
		else {
			GuiControl, , shareSetupWithCommunityCheck, 0
			GuiControl, , shareSetupWithTeamServerCheck, 0
		}

		this.updateState()
	}

	uploadStrategy() {
		local window := this.Window
		local title := translate("Upload Strategy File...")
		local fileName, strategy

		Gui %window%:Default
		Gui +OwnDialogs

		OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Load", "Cancel"]))
		FileSelectFile fileName, 1, , %title%, , Strategy (*.strategy)
		OnMessage(0x44, "")

		if (fileName != "") {
			strategy := readMultiMap(fileName)

			SplitPath fileName, fileName

			this.SessionDatabase.writeStrategy(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, fileName, strategy, false, true)

			this.loadStrategies(fileName)
		}
	}

	downloadStrategy(strategyName) {
		local window := this.Window
		local title := translate("Download Strategy File...")
		local fileName

		Gui %window%:Default
		Gui +OwnDialogs

		OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Save", "Cancel"]))
		FileSelectFile fileName, S16, %strategyName%, %title%, Strategy (*.strategy)
		OnMessage(0x44, "")

		if (fileName != "") {
			deleteFile(fileName)

			writeMultiMap(fileName, this.SessionDatabase.readStrategy(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, strategyName))
		}
	}

	deleteStrategy(strategyName) {
		local window := this.Window
		local title := translate("Delete")

		Gui %window%:Default

		OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Yes", "No"]))
		MsgBox 262436, %title%, % translate("Do you really want to delete the selected strategy?")
		OnMessage(0x44, "")

		IfMsgBox Yes
		{
			this.SessionDatabase.removeStrategy(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, strategyName)

			this.loadStrategies()
		}
	}

	renameStrategy(strategyName) {
		local window := this.Window
		local title := translate("Rename")
		local prompt := translate("Please enter the new name for the selected strategy:")
		local locale := ((getLanguage() = "en") ? "" : "Locale")
		local newName, curExtension, curName

		Gui %window%:Default

		SplitPath strategyName, , , curExtension, curName

		InputBox newName, %title%, %prompt%, , 300, 200, , , %locale%, , % curName

		if !ErrorLevel {
			if (StrLen(curExtension) > 0)
				newName .= ("." . curExtension)

			this.SessionDatabase.renameStrategy(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, strategyName, newName)

			this.loadStrategies(newName)
		}
	}

	uploadSetup(setupType) {
		local window := this.Window
		local title := translate("Upload Setup File...")
		local fileName, file, size, setup

		Gui %window%:Default
		Gui +OwnDialogs

		OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Load", "Cancel"]))
		FileSelectFile fileName, 1, , %title%
		OnMessage(0x44, "")

		if (fileName != "") {
			file := FileOpen(fileName, "r")

			if file {
				size := file.Length

				file.RawRead(setup, size)

				file.Close()

				SplitPath fileName, fileName

				this.SessionDatabase.writeSetup(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, setupType, fileName, setup, size, false, true)

				this.loadSetups(this.SelectedSetupType, true, fileName)
			}
		}
	}

	downloadSetup(setupType, setupName) {
		local window := this.Window
		local title := translate("Download Setup File...")
		local fileName, setupData, file, size

		Gui %window%:Default
		Gui +OwnDialogs

		OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Save", "Cancel"]))
		FileSelectFile fileName, S16, %setupName%, %title%
		OnMessage(0x44, "")

		if (fileName != "") {
			size := false

			setupData := this.SessionDatabase.readSetup(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, setupType, setupName, &size)

			deleteFile(fileName)

			file := FileOpen(fileName, "w", "")

			if file {
				file.Length := size
				file.RawWrite(setupData, size)

				file.Close()
			}
		}
	}

	deleteSetup(setupType, setupName) {
		local window := this.Window
		local title := translate("Delete")

		Gui %window%:Default

		OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Yes", "No"]))
		MsgBox 262436, %title%, % translate("Do you really want to delete the selected setup?")
		OnMessage(0x44, "")

		IfMsgBox Yes
		{
			this.SessionDatabase.removeSetup(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, setupType, setupName)

			this.loadSetups(this.SelectedSetupType, true)
		}
	}

	renameSetup(setupType, setupName) {
		local window := this.Window
		local title := translate("Rename")
		local prompt := translate("Please enter the new name for the selected setup:")
		local locale := ((getLanguage() = "en") ? "" : "Locale")
		local newName, curExtension, curName

		Gui %window%:Default

		SplitPath setupName, , , curExtension, curName

		InputBox newName, %title%, %prompt%, , 300, 200, , , %locale%, , % curName

		if !ErrorLevel {
			if (StrLen(curExtension) > 0)
				newName .= ("." . curExtension)

			this.SessionDatabase.renameSetup(this.SelectedSimulator, this.SelectedCar, this.SelectedTrack, setupType, setupName, newName)

			this.loadSetups(this.SelectedSetupType, true, newName)
		}
	}
}


;;;-------------------------------------------------------------------------;;;
;;;                   Private Function Declaration Section                  ;;;
;;;-------------------------------------------------------------------------;;;

WM_MOUSEMOVE() {
	local editor := SessionDatabaseEditor.Instance
	local x, y, coordinateX, coordinateY, window

	static currentAction := false
	static previousAction := false
	static actionInfo := ""

	if (editor.SelectedModule = "Automation") {
		window := editor.Window

		Gui %window%:Default

		MouseGetPos x, y

		coordinateX := false
		coordinateY := false

		if editor.findTrackCoordinate(x - editor.iTrackDisplayArea[1] - editor.iTrackDisplayArea[5]
									, y - editor.iTrackDisplayArea[2] - editor.iTrackDisplayArea[6]
									, coordinateX, coordinateY) {
			currentAction := editor.findTrackAction(coordinateX, coordinateY)

			if !currentAction
				currentAction := (coordinateX . ";" . coordinateY)

			if (currentAction && (currentAction != previousAction)) {
				ToolTip

				if IsObject(currentAction) {
					actionInfo := translate((currentAction.Type = "Hotkey") ? (InStr(currentAction.Action, "|") ? "Hotkey(s): "
																												: "Hotkey: ")
																			: "Command: ")
					actionInfo := (inList(editor.SelectedTrackAutomation.Actions, currentAction) . translate(": ")
								 . (Round(currentAction.X, 3) . translate(", ") . Round(currentAction.Y, 3))
								 . translate(" -> ")
								 . actionInfo . currentAction.Action)
				}
				else
					actionInfo := (Round(string2Values(";", currentAction)[1], 3) . translate(", ") . Round(string2Values(";", currentAction)[2], 3))

				SetTimer RemoveToolTip, Off
				SetTimer DisplayToolTip, 1000

				previousAction := currentAction
			}
			else if !currentAction {
				ToolTip

				SetTimer RemoveToolTip, Off

				previousAction := false
			}
		}
		else {
			ToolTip

			SetTimer RemoveToolTip, Off

			previousAction := false
		}
	}

	return

    DisplayToolTip:
		SetTimer DisplayToolTip, Off

		ToolTip %actionInfo%

		SetTimer RemoveToolTip, 10000

		return

    RemoveToolTip:
		SetTimer RemoveToolTip, Off

		ToolTip

		return
}

actionDialog(xOrCommand := false, y := false, action := false) {
	local window, title, fileName, chosen, x

	static result := false

	static actionTypeDropDown
	static actionLabel
	static actionEdit
	static commandChooserButton

	if (xOrCommand == kOk)
		result := kOk
	else if (xOrCommand == kCancel)
		result := kCancel
	else if (xOrCommand = "Type") {
		GuiControl, , actionEdit, % ""

		actionDialog("Update")
	}
	else if (xOrCommand = "Update") {
		GuiControlGet actionTypeDropDown

		GuiControl, , actionLabel, % translate((actionTypeDropDown = 1) ? "Hotkey(s)" : "Command")

		if (actionTypeDropDown = 1)
			GuiControl Disable, commandChooserButton
		else
			GuiControl Enable, commandChooserButton
	}
	else if (xOrCommand = "Command") {
		GuiControlGet actionEdit

		title := translate("Select executable file...")

		Gui +OwnDialogs

		OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Select", "Cancel"]))
		FileSelectFile fileName, 1, %actionEdit%, %title%, Script (*.*)
		OnMessage(0x44, "")

		if fileName
			GuiControl, , actionEdit, %fileName%
	}
	else {
		result := false
		window := "EE"

		Gui %window%:New

		Gui %window%:Default

		Gui %window%:-Border ; -Caption
		Gui %window%:Color, D0D0D0, D8D8D8

		Gui %window%:Font, Norm, Arial

		Gui %window%:Add, Text, x16 y16 w70 h23 +0x200, % translate("Action")

		if action {
			chosen := inList(["Hotkey", "Command"], action.Type)
			actionEdit := action.Action
		}
		else {
			chosen := 1
			actionEdit := ""
		}

		Gui %window%:Add, DropDownList, x90 yp+1 w180 AltSubmit Choose%chosen% VactionTypeDropDown gchooseActionType, % values2String("|", collect(["Hotkey(s)", "Command"], "translate")*)

		Gui %window%:Add, Text, x16 yp+23 w70 h23 +0x200 vactionLabel, % translate("Hotkey(s)")
		Gui %window%:Add, Edit, x90 yp+1 w155 h21 VactionEdit, %actionEdit%
		Gui %window%:Add, Button, x247 yp w23 h23 vcommandChooserButton gchooseActionCommand, % translate("...")

		Gui %window%:Add, Button, x60 yp+35 w80 h23 Default gacceptAction, % translate("Ok")
		Gui %window%:Add, Button, x146 yp w80 h23 gcancelAction, % translate("&Cancel")

		x := (xOrCommand - 150)
		y := (y - 35)

		actionDialog("Update")

		Gui %window%:Show, x%x% y%y% AutoSize

		while !result
			Sleep 100

		Gui %window%:Submit
		Gui %window%:Destroy

		if (result == kCancel)
			return false
		else if (result == kOk) {
			GuiControlGet actionTypeDropDown
			GuiControlGet actionEdit

			if action
				action := action.Clone()
			else
				action := Object()

			action.Type := ["Hotkey", "Command"][actionTypeDropDown]
			action.Action := actionEdit

			return action
		}
	}
}

chooseActionType() {
	actionDialog("Type")
}

chooseActionCommand() {
	actionDialog("Command")
}

acceptAction() {
	actionDialog(kOk)
}

cancelAction() {
	actionDialog(kCancel)
}

global importSelectCheck

selectImportData(sessionDatabaseEditorOrCommand, directory := false) {
	local x, y, editor, owner, simulator, code, info, drivers, id, name, progressWindow, tracks, progress
	local car, carName, track, trackName, sourceDirectory, found, telemetryDB, tyresDB, driver, driverName, rows
	local strategies, automations, row, selection, data, type, count

	static importListViewHandle := false
	static result := false

	if (sessionDatabaseEditorOrCommand = kCancel)
		result := kCancel
	else if (sessionDatabaseEditorOrCommand = kOk)
		result := kOk
	else {
		result := false

		Gui IDS:Default

		Gui IDS:-Border ; -Caption
		Gui IDS:Color, D0D0D0, D8D8D8

		Gui IDS:Font, s10 Bold, Arial

		Gui IDS:Add, Text, w394 Center gmoveImport, % translate("Modular Simulator Controller System")

		Gui IDS:Font, s9 Norm, Arial
		Gui IDS:Font, Italic Underline, Arial

		Gui IDS:Add, Text, x153 YP+20 w104 cBlue Center gopenSettingsDocumentation, % translate("Database Location")

		Gui IDS:Font, s8 Norm, Arial

		Gui IDS:Add, Text, x8 yp+30 w410 0x10

		Gui IDS:Add, CheckBox, Check3 x16 yp+12 w15 h23 vimportSelectCheck gselectAllImportEntries ; +Theme

		Gui IDS:Add, ListView, x34 yp-2 w375 h400 -Multi -LV0x10 Checked AltSubmit HwndimportListViewHandle gselectImportEntry, % values2String("|", collect(["Type", "Car / Track", "Driver", "#"], "translate")*) ; NoSort NoSortHdr

		directory := normalizeDirectoryPath(directory)
		editor := sessionDatabaseEditorOrCommand
		owner := editor.Window

		simulator := editor.SelectedSimulator
		code := editor.SessionDatabase.getSimulatorCode(simulator)

		info := readMultiMap(directory . "\Export.info")

		drivers := {}

		for id, name in getMultiMapValues(info, "Driver") {
			drivers[id] := name
			drivers[name] := id
		}

		progressWindow := showProgress({color: "Green", title: translate("Analyzing Data")})

		Gui %progressWindow%:+Owner%owner%
		Gui %owner%:+Disabled

		try {
			tracks := 0

			Gui IDS:Default
			Gui ListView, %importListViewHandle%

			tracks := []

			loop Files, %directory%\.Tracks\*.*, F
			{
				SplitPath A_LoopFileName, , , , track

				if !inList(tracks, track) {
					LV_Add("Check", translate("Tracks"), editor.getTrackName(simulator, track), "-", 1)

					tracks.Push(track)
				}
			}

			progress := 0

			loop Files, %directory%\*.*, D	; Car
			{
				car := A_LoopFileName
				carName := editor.getCarName(simulator, car)

				loop Files, %directory%\%car%\*.*, D	; Track
				{
					track := A_LoopFileName
					trackName := editor.getTrackName(simulator, track)

					showProgress({progress: ++progress
								, message: translate("Car: ") . carName . translate(", Track: ") . trackName})

					if (progress >= 100)
						progress := 0

					Gui IDS:Default
					Gui ListView, %importListViewHandle%

					sourceDirectory := (A_LoopFileDir . "\" . track)

					found := false

					telemetryDB := TelemetryDatabase()

					telemetryDB.setDatabase(Database(sourceDirectory . "\", kTelemetrySchemas))

					for driver, driverName in drivers {
						count := (telemetryDB.getElectronicsCount(driver) + telemetryDB.getTyresCount(driver))

						if (count > 0)
							LV_Add("Check", translate("Telemetry"), (carName . " / " . trackName), driverName, count)
					}

					tyresDB := Database(sourceDirectory . "\", kTyresSchemas)

					for driver, driverName in drivers {
						rows := tyresDB.query("Tyres.Pressures", {Group: [["Driver", "count", "Count"]]
																, Where: {Driver: driver}})

						count := ((rows.Length() > 0) ? rows[1].Count : 0)

						rows := tyresDB.query("Tyres.Pressures.Distribution"
											, {Group: [["Driver", "count", "Count"]]
											 , Where: {Driver: driver}})

						count += ((rows.Length() > 0) ? rows[1].Count : 0)

						if (count > 0)
							LV_Add("Check", translate("Pressures"), (carName . " / " . trackName), driverName, count)
					}

					strategies := 0

					loop Files, %sourceDirectory%\Race Strategies\*.*, F		; Strategies
						strategies += 1

					if (strategies > 0)
						LV_Add("Check", translate("Strategies"), (carName . " / " . trackName), "-", strategies)

					if FileExist(sourceDirectory . "\Track.automations") {
						automations := editor.SessionDatabase.loadTrackAutomations(sourceDirectory . "\Track.automations").Length()

						if (automations > 0)
							LV_Add("Check", translate("Automations"), (carName . " / " . trackName), "-", automations)
					}
				}
			}
		}
		finally {
			Gui %owner%:+Disabled

			hideProgress()
		}

		Gui IDS:Default
		Gui ListView, %importListViewHandle%

		GuiControl, , importSelectCheck, % ((LV_GetCount() > 0) ? 1 : 0)

		LV_ModifyCol()

		loop 4
			LV_ModifyCol(A_Index, "AutoHdr")

		Gui IDS:Font, s8 Norm, Arial

		Gui IDS:Add, Text, x8 yp+410 w410 0x10

		Gui IDS:Add, Button, x123 yp+10 w80 h23 Default GacceptImport, % translate("Ok")
		Gui IDS:Add, Button, x226 yp w80 h23 GcancelImport, % translate("&Cancel")

		Gui IDS:+Owner%owner%
		Gui %owner%:+Disabled

		try {
			if getWindowPosition("Session Database.Import", x, y)
				Gui IDS:Show, x%x% y%y%
			else
				Gui IDS:Show

			loop
				Sleep 100
			until result
		}
		finally {
			Gui %owner%:-Disabled
		}

		if (result = kOk) {
			Gui ListView, %importListViewHandle%

			row := 0

			selection := {}

			while (row := LV_GetNext(row, "C")) {
				LV_GetText(type, row, 1)
				LV_GetText(data, row, 2)

				if InStr(data, " / ") {
					data := string2Values(" / ", data)

					car := data[1]
					track := data[2]
				}
				else if (type = translate("Tracks")) {
					car := "-"
					track := data
				}
				else {
					car := "-"
					track := "-"
				}

				LV_GetText(driver, row, 3)

				switch type {
					case translate("Tracks"):
						type := "Tracks"
					case translate("Telemetry"):
						type := "Telemetry"
					case translate("Pressures"):
						type := "Pressures"
					case translate("Strategies"):
						type := "Strategies"
				}

				if ((car = "-") && (track = "-"))
					selection["-.-." . type] := drivers[driver]
				else if (car = "-")
					selection["-." . editor.getTrackCode(simulator, track) . "." . type] := drivers[driver]
				else
					selection[editor.getCarCode(simulator, car) . "."
							. editor.getTrackCode(simulator, track) . "." . type] := drivers[driver]
			}

			result := selection
		}
		else
			result := false

		Gui IDS:Destroy

		return result
	}
}

acceptImport() {
	selectImportData(kOk)
}

cancelImport() {
	selectImportData(kCancel)
}

selectAllImportEntries() {
	GuiControlGet importSelectCheck

	if (importSelectCheck == -1) {
		importSelectCheck := 0

		GuiControl, , importSelectCheck, 0
	}

	loop % LV_GetCount()
		LV_Modify(A_Index, importSelectCheck ? "Check" : "-Check")
}

selectImportEntry() {
	local selected := 0
	local row := 0

	loop {
		row := LV_GetNext(row, "C")

		if row
			selected += 1
		else
			break
	}

	if (selected == 0)
		GuiControl, , importSelectCheck, 0
	else if (selected < LV_GetCount())
		GuiControl, , importSelectCheck, -1
	else
		GuiControl, , importSelectCheck, 1
}

moveImport() {
	moveByMouse("IDS", "Session Database.Import")
}

openImportDocumentation() {
	Run https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#managing-the-session-database
}

showSettings() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window

	protectionOn()

	Gui SE:+Owner%window%
	Gui %window%:+Disabled

	try {
		editSettings(editor)
	}
	finally {
		Gui %window%:-Disabled

		protectionOff()
	}
}

editSettings(editorOrCommand, arguments*) {
	local title, window, x, y, done, configuration, dllName, dllFile, connector, connection
	local directory, empty, original, changed, restart, groups, replication
	local oldConnections, ignore, group, enabled
	local identifier, serverURL, serverToken, serverURLs, serverTokens
	local availableServerURLs, settings, chosen

	static result := false
	static sessionDB := false

	static connections := []
	static currentConnection := 0

	static addConnectionButton
	static deleteConnectionButton
	static nextConnectionButton
	static previousConnectionButton

	static databaseLocationEdit := ""
	static synchTelemetryCheck
	static synchPressuresCheck
	static synchSetupsCheck
	static synchStrategiesCheck
	static serverIdentifierEdit := ""
	static serverURLEdit := ""
	static serverTokenEdit := ""
	static serverUpdateEdit := 0
	static tokenButtonHandle
	static rebuildButton

	if (editorOrCommand == kOk) {
		if currentConnection
			editSettings("SaveConnection")

		serverURLs := {}
		serverTokens := {}
		groups := {}

		for ignore, connection in connections {
			serverURLs[connection[1]] := connection[2]
			serverTokens[connection[1]] := connection[3]
			groups[connection[1]] := values2String(",", connection[4]*)
		}

		if ((groups.Count() != connections.Length()) || (serverURLs.Count() != connections.Length()) || (serverTokens.Count() != connections.Length())) {
			OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Ok"]))
			title := translate("Error")
			MsgBox 262160, %title%, % translate("Invalid values detected - please correct...")
			OnMessage(0x44, "")
		}
		else
			result := kOk
	}
	else if (editorOrCommand == kCancel)
		result := kCancel
	else if (editorOrCommand == "AddConnection") {
		editSettings("SaveConnection")

		connections.Push([translate("Standard"), "https://localhost:5001", "", ["Telemetry"]])

		editSettings("LoadConnection", connections.Length())
	}
	else if (editorOrCommand == "DeleteConnection") {
		connections.RemoveAt(currentConnection)

		if (connections.Length() > 0)
			editSettings("LoadConnection", 1)
		else {
			currentConnection := false

			editSettings("UpdateState")
		}
	}
	else if (editorOrCommand == "NextConnection") {
		editSettings("SaveConnection")

		currentConnection += 1

		editSettings("LoadConnection", currentConnection)
	}
	else if (editorOrCommand == "PreviousConnection") {
		editSettings("SaveConnection")

		currentConnection -= 1

		editSettings("LoadConnection", currentConnection)
	}
	else if (editorOrCommand == "LoadConnection") {
		currentConnection := arguments[1]

		serverIdentifierEdit := connections[currentConnection][1]
		serverURLEdit := connections[currentConnection][2]
		serverTokenEdit := connections[currentConnection][3]

		GuiControl, , serverIdentifierEdit, %serverIdentifierEdit%

		settings := readMultiMap(kUserConfigDirectory . "Application Settings.ini")

		availableServerURLs := string2Values(";", getMultiMapValue(settings, "Team Server", "Server URLs", ""))

		if (!inList(availableServerURLs, serverURLEdit) && StrLen(serverURLEdit) > 0)
			availableServerURLs.Push(serverURLEdit)

		chosen := inList(availableServerURLs, serverURLEdit)
		if (!chosen && (availableServerURLs.Length() > 0))
			chosen := 1

		GuiControl, , serverURLEdit, % ("|" . values2String("|", availableServerURLs*))
		GuiControl Choose, serverURLEdit, %chosen%
		GuiControl, , serverTokenEdit, %serverTokenEdit%

		groups := connections[currentConnection][4]

		synchTelemetryCheck := (inList(groups, "Telemetry") != false)
		synchPressuresCheck := (inList(groups, "Pressures") != false)
		synchSetupsCheck := (inList(groups, "Setups") != false)
		synchStrategiesCheck := (inList(groups, "Strategies") != false)

		GuiControl, , synchTelemetryCheck, %synchTelemetryCheck%
		GuiControl, , synchPressuresCheck, %synchPressuresCheck%
		GuiControl, , synchSetupsCheck, %synchSetupsCheck%
		GuiControl, , synchStrategiesCheck, %synchStrategiesCheck%

		editSettings("UpdateState")
	}
	else if (editorOrCommand == "SaveConnection") {
		if currentConnection {
			GuiControlGet serverIdentifierEdit
			GuiControlGet serverURLEdit
			GuiControlGet serverTokenEdit
			GuiControlGet synchTelemetryCheck
			GuiControlGet synchPressuresCheck
			GuiControlGet synchSetupsCheck
			GuiControlGet synchStrategiesCheck

			connections[currentConnection][1] := serverIdentifierEdit
			connections[currentConnection][2] := serverURLEdit
			connections[currentConnection][3] := serverTokenEdit

			groups := []

			for group, enabled in {Telemetry: synchTelemetryCheck, Pressures: synchPressuresCheck
								 , Setups: synchSetupsCheck, Strategies: synchStrategiesCheck}
				if enabled
					groups.Push(group)

			connections[currentConnection][4] := groups
		}
	}
	else if (editorOrCommand = "Rebuild") {
		configuration := readMultiMap(kUserConfigDirectory . "Session Database.ini")

		setMultiMapValue(configuration, "Team Server", "Synchronization", mapToString("|", "->", {}))

		writeMultiMap(kUserConfigDirectory . "Session Database.ini", configuration)
	}
	else if (editorOrCommand = "DatabaseLocation") {
		Gui +OwnDialogs

		OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Select", "Select", "Cancel"]))
		FileSelectFolder directory, *%kDatabaseDirectory%, 0, % translate("Select Session Database folder...")
		OnMessage(0x44, "")

		if (directory != "") {
			databaseLocationEdit := directory

			GuiControl, , databaseLocationEdit, %databaseLocationEdit%
		}
	}
	else if (editorOrCommand = "ValidateToken") {
		GuiControlGet serverURLEdit
		GuiControlGet serverTokenEdit

		dllName := "Data Store Connector.dll"
		dllFile := kBinariesDirectory . dllName

		try {
			if (!FileExist(dllFile)) {
				logMessage(kLogCritical, translate("Data Store Connector.dll not found in ") . kBinariesDirectory)

				throw "Unable to find Data Store Connector.dll in " . kBinariesDirectory . "..."
			}

			connector := CLR_LoadLibrary(dllFile).CreateInstance("TeamServer.DataConnector")
		}
		catch Any as exception {
			logMessage(kLogCritical, translate("Error while initializing Data Store Connector - please rebuild the applications"))

			showMessage(translate("Error while initializing Data Store Connector - please rebuild the applications") . translate("...")
					  , translate("Modular Simulator Controller System"), "Alert.png", 5000, "Center", "Bottom", 800)

			return
		}

		if GetKeyState("Ctrl", "P") {
			Gui TSL:+OwnerSE
			Gui SE:+Disabled

			try {
				token := loginDialog(connector, serverURLEdit)

				if token {
					serverTokenEdit := token

					Gui SE:Default

					GuiControl Text, serverTokenEdit, %serverTokenEdit%
				}
				else
					return
			}
			finally {
				Gui SE:-Disabled
			}
		}

		try {
			connector.Initialize(serverURLEdit, serverTokenEdit)

			connection := connector.Connect(serverTokenEdit, sessionDB.ID, sessionDB.getUserName())

			if (connection && (connection != "")) {
				connector.ValidateDataToken()

				settings := readMultiMap(kUserConfigDirectory . "Application Settings.ini")

				availableServerURLs := string2Values(";", getMultiMapValue(settings, "Team Server", "Server URLs", ""))

				if !inList(availableServerURLs, serverURLEdit) {
					availableServerURLs.Push(serverURLEdit)

					setMultiMapValue(settings, "Team Server", "Server URLs", values2String(";", availableServerURLs*))

					writeMultiMap(kUserConfigDirectory . "Application Settings.ini", settings)

					GuiControl, , serverURLEdit, % ("|" . values2String("|", availableServerURLs*))
					GuiControl Choose, serverURLEdit, % inList(availableServerURLs, serverURLEdit)
				}

				showMessage(translate("Successfully connected to the Team Server."))
			}
		}
		catch Any as exception {
			title := translate("Error")

			OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Ok"]))
			MsgBox 262160, %title%, % (translate("Cannot connect to the Team Server.") . "`n`n" . translate("Error: ") . exception.Message)
			OnMessage(0x44, "")

			return false
		}
	}
	else if (editorOrCommand = "UpdateState") {
		GuiControlGet synchTelemetryCheck
		GuiControlGet synchPressuresCheck
		GuiControlGet synchSetupsCheck
		GuiControlGet synchStrategiesCheck

		GuiControl Enable, addConnectionButton

		if (connections.Length() > 0) {
			GuiControl Enable, deleteConnectionButton
			GuiControl Enable, synchTelemetryCheck
			GuiControl Enable, synchPressuresCheck
			GuiControl Enable, synchSetupsCheck
			GuiControl Enable, synchStrategiesCheck
		}
		else {
			GuiControl Disable, deleteConnectionButton
			GuiControl Disable, synchTelemetryCheck
			GuiControl Disable, synchPressuresCheck
			GuiControl Disable, synchSetupsCheck
			GuiControl Disable, synchStrategiesCheck

			GuiControl, , synchTelemetryCheck, 0
			GuiControl, , synchPressuresCheck, 0
			GuiControl, , synchSetupsCheck, 0
			GuiControl, , synchStrategiesCheck, 0

			synchTelemetryCheck := false
			synchPressuresCheck := false
			synchSetupsCheck := false
			synchStrategiesCheck := false
		}

		if (connections.Length() > 1) {
			if (currentConnection = 1)
				GuiControl Disable, previousConnectionButton
			else
				GuiControl Enable, previousConnectionButton

			if (currentConnection = connections.Length())
				GuiControl Disable, nextConnectionButton
			else
				GuiControl Enable, nextConnectionButton
		}
		else {
			GuiControl Disable, nextConnectionButton
			GuiControl Disable, previousConnectionButton
		}

		if ((connections.Length() > 0) && !synchTelemetryCheck && !synchPressuresCheck && !synchSetupsCheck && !synchStrategiesCheck) {
			synchTelemetryCheck := true

			GuiControl, , synchTelemetryCheck, 1
		}

		if (synchTelemetryCheck || synchPressuresCheck || synchSetupsCheck || synchStrategiesCheck) {
			GuiControl Enable, serverIdentifierEdit
			GuiControl Enable, serverURLEdit
			GuiControl Enable, serverTokenEdit
			GuiControl Enable, serverUpdateEdit
			GuiControl Enable, %tokenButtonHandle%
			GuiControl Enable, rebuildButton

			GuiControlGet serverUpdateEdit

			if (serverUpdateEdit = "")
				GuiControl, , serverUpdateEdit, 10
		}
		else {
			GuiControl Disable, serverIdentifierEdit
			GuiControl Disable, serverURLEdit
			GuiControl Disable, serverTokenEdit
			GuiControl Disable, serverUpdateEdit
			GuiControl Disable, %tokenButtonHandle%
			GuiControl Disable, rebuildButton

			serverIdentifierEdit := ""
			serverURLEdit := ""
			serverTokenEdit := ""
			serverUpdateEdit := ""

			GuiControl, , serverIdentifierEdit, %serverIdentifierEdit%
			GuiControl Choose, serverURLEdit, 0
			GuiControl, , serverTokenEdit, %serverTokenEdit%
			GuiControl, , serverUpdateEdit, %serverUpdateEdit%
		}
	}
	else {
		connections := []
		result := false
		sessionDB := editorOrCommand.SessionDatabase

		window := "SE"

		for identifier, serverURL in sessionDB.ServerURLs
			connections.Push([identifier, serverURL, sessionDB.ServerToken[identifier], sessionDB.Groups[identifier]])

		currentConnection := ((connections.Length() = 0) ? 0 : 1)

		configuration := readMultiMap(kUserConfigDirectory . "Session Database.ini")

		databaseLocationEdit := normalizeDirectoryPath(getMultiMapValue(configuration, "Database", "Path", kDatabaseDirectory))

		replication := getMultiMapValue(configuration, "Team Server", "Replication", false)

		if currentConnection
			groups := connections[currentConnection][4]
		else
			groups := []

		if (groups.Length() > 0) {
			synchTelemetryCheck := (inList(groups, "Telemetry") != false)
			synchPressuresCheck := (inList(groups, "Pressures") != false)
			synchSetupsCheck := (inList(groups, "Setups") != false)
			synchStrategiesCheck := (inList(groups, "Strategies") != false)
		}
		else {
			synchTelemetryCheck := (replication != false)
			synchPressuresCheck := (replication != false)
			synchSetupsCheck := (replication != false)
			synchStrategiesCheck := (replication != false)
		}

		if (synchTelemetryCheck || synchPressuresCheck || synchSetupsCheck || synchStrategiesCheck) {
			if currentConnection {
				serverIdentifierEdit := connections[currentConnection][1]
				serverURLEdit := connections[currentConnection][2]
				serverTokenEdit := connections[currentConnection][3]
			}
			else {
				serverIdentifierEdit := "Standard"

				serverURLEdit := stringToMap("|", "->", getMultiMapValue(configuration, "Team Server", "Server.URL", ""), "Standard")
				serverURLEdit := (serverURLEdit.HasKey("Standard") ? serverURLEdit["Standard"] : "")

				serverTokenEdit := stringToMap("|", "->", getMultiMapValue(configuration, "Team Server", "Server.Token", ""), "Standard")
				serverTokenEdit := (serverTokenEdit.HasKey("Standard") ? serverTokenEdit["Standard"] : "")

				serverUpdateEdit := replication
			}
		}
		else {
			serverIdentifierEdit := ""
			serverURLEdit := ""
			serverTokenEdit := ""
			serverUpdateEdit := ""
		}

		Gui %window%:New

		Gui %window%:Default

		Gui %window%:-Border ; -Caption
		Gui %window%:Color, D0D0D0, D8D8D8

		Gui %window%:Font, s10 Bold, Arial

		Gui %window%:Add, Text, w394 Center gmoveSettings, % translate("Modular Simulator Controller System")

		Gui %window%:Font, s9 Norm, Arial
		Gui %window%:Font, Italic Underline, Arial

		Gui %window%:Add, Text, x133 YP+20 w144 cBlue Center gopenSettingsDocumentation, % translate("Database Settings")

		Gui %window%:Font, s8 Norm, Arial

		Gui %window%:Add, Text, x16 y60 w90 h23 +0x200, % translate("Database Folder")
		Gui %window%:Add, Edit, x146 yp w234 h21 VdatabaseLocationEdit, %databaseLocationEdit%
		Gui %window%:Add, Button, x382 yp-1 w23 h23 gchooseDatabaseLocation, % translate("...")

		Gui %window%:Font, Italic, Arial

		Gui %window%:Add, GroupBox, x16 yp+30 w388 h216 Section, % translate("Team Data")

		Gui %window%:Font, Norm, Arial

		Gui %window%:Add, Text, x24 yp+16 w90 h23 +0x200, % translate("Synchronization")
		Gui %window%:Add, CheckBox, x146 yp+2 w120 h21 vsynchTelemetryCheck gupdateSettingsState, % translate("Telemetry Data")
		Gui %window%:Add, CheckBox, x266 yp w120 h21 vsynchStrategiesCheck gupdateSettingsState, % translate("Race Strategies")
		Gui %window%:Add, CheckBox, x146 yp+24 w120 h21 vsynchPressuresCheck gupdateSettingsState, % translate("Pressures Data")
		Gui %window%:Add, CheckBox, x266 yp w120 h21 vsynchSetupsCheck gupdateSettingsState, % translate("Car Setups")

		GuiControl, , synchTelemetryCheck, %synchTelemetryCheck%
		GuiControl, , synchPressuresCheck, %synchPressuresCheck%
		GuiControl, , synchSetupsCheck, %synchSetupsCheck%
		GuiControl, , synchStrategiesCheck, %synchStrategiesCheck%

		Gui %window%:Add, Text, x24 yp+30 w90 h23 +0x200, % translate("Name")
		Gui %window%:Add, Edit, x146 yp+1 w246 vserverIdentifierEdit, %serverIdentifierEdit%

		settings := readMultiMap(kUserConfigDirectory . "Application Settings.ini")

		availableServerURLs := string2Values(";", getMultiMapValue(settings, "Team Server", "Server URLs", ""))

		if (!inList(availableServerURLs, serverURLEdit) && StrLen(serverURLEdit) > 0)
			availableServerURLs.Push(serverURLEdit)

		chosen := inList(availableServerURLs, serverURLEdit)
		if (!chosen && (availableServerURLs.Length() > 0))
			chosen := 1

		Gui %window%:Add, Text, x24 yp+30 w90 h23 +0x200, % translate("Server URL")
		Gui %window%:Add, ComboBox, x146 yp+1 w246 Choose%chosen% vserverURLEdit, % values2String("|", availableServerURLs*)

		Gui %window%:Add, Text, x24 yp+23 w90 h23 +0x200, % translate("Data Token")
		Gui %window%:Add, Edit, x146 yp w246 h21 vserverTokenEdit, %serverTokenEdit%
		Gui %window%:Add, Button, x122 yp-1 w23 h23 Center +0x200 HWNDtokenButtonHandle gvalidateServerToken
		setButtonIcon(tokenButtonHandle, kIconsDirectory . "Authorize.ico", 1, "L4 T4 R4 B4")

		Gui %window%:Add, Button, x296 yp+30 w23 h23 Center +0x200 HWNDbuttonHandle vaddConnectionButton gaddConnection
		setButtonIcon(buttonHandle, kIconsDirectory . "Plus.ico", 1, "L4 T4 R4 B4")
		Gui %window%:Add, Button, xp+24 yp w23 h23 Center +0x200 HWNDbuttonHandle vdeleteConnectionButton gdeleteConnection
		setButtonIcon(buttonHandle, kIconsDirectory . "Minus.ico", 1, "L4 T4 R4 B4")
		Gui %window%:Add, Button, xp+24 yp w23 h23 Center +0x200 HWNDbuttonHandle vpreviousConnectionButton gpreviousConnection
		setButtonIcon(buttonHandle, kIconsDirectory . "Previous.ico", 1, "L4 T4 R4 B4")
		Gui %window%:Add, Button, xp+24 yp w23 h23 Center +0x200 HWNDbuttonHandle vnextConnectionButton gnextConnection
		setButtonIcon(buttonHandle, kIconsDirectory . "Next.ico", 1, "L4 T4 R4 B4")

		Gui %window%:Add, Text, x24 yp+30 w110 h23 +0x200, % translate("Synchronize each")
		Gui %window%:Add, Edit, x146 yp w40 Number Limit2 vserverUpdateEdit, %serverUpdateEdit%
		Gui %window%:Add, UpDown, xp+32 yp-2 w18 h20 Range10-90, %serverUpdateEdit%
		Gui %window%:Add, Text, x190 yp w90 h23 +0x200, % translate("Minutes")

		Gui %window%:Add, Button, x296 yp w96 vrebuildButton grebuildDatabase, % translate("Rebuild...")

		Gui %window%:Add, Button, x122 ys+224 w80 h23 gacceptSettings, % translate("Ok")
		Gui %window%:Add, Button, x216 yp w80 h23 gcancelSettings, % translate("&Cancel")

		updateSettingsState()

		if getWindowPosition("Session Database.Settings", x, y)
			Gui %window%:Show, x%x% y%y%
		else
			Gui %window%:Show, AutoSize Center

		done := false

		while !done {
			result := false

			while !result
				Sleep 100

			if (result == kCancel)
				done := true
			else if (result == kOk) {
				GuiControlGet databaseLocationEdit
				GuiControlGet synchTelemetryCheck
				GuiControlGet synchPressuresCheck
				GuiControlGet synchSetupsCheck
				GuiControlGet synchStrategiesCheck
				GuiControlGet serverIdentifierEdit
				GuiControlGet serverURLEdit
				GuiControlGet serverTokenEdit
				GuiControlGet serverUpdateEdit

				changed := false
				restart := false

				if (databaseLocationEdit = "") {
					title := translate("Error")

					OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Ok"]))
					MsgBox 262160, %title%, % translate("You must enter a valid directory.")
					OnMessage(0x44, "")

					continue
				}
				else if (normalizeDirectoryPath(databaseLocationEdit) != normalizeDirectoryPath(kDatabaseDirectory)) {
					if !FileExist(databaseLocationEdit)
						try {
							FileCreateDir %databaseLocationEdit%
						}
						catch Any as exception {
							title := translate("Error")

							OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Ok"]))
							MsgBox 262160, %title%, % translate("You must enter a valid directory.")
							OnMessage(0x44, "")

							continue
						}

					SoundPlay *32

					title := translate("Information")

					OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Yes", "No", "Cancel"]))
					title := translate("Session Database")
					MsgBox 262179, %title%, % translate("You are about to change the session database location. Do you want to transfer the current content to the new location?")
					OnMessage(0x44, "")

					IfMsgBox Cancel
						continue

					IfMsgBox Yes
					{
						empty := true

						loop Files, %databaseLocationEdit%\*.*, FD
						{
							empty := false

							break
						}

						if !empty {
							title := translate("Error")

							OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Ok"]))
							MsgBox 262160, %title%, % translate("The new database folder must be empty.")
							OnMessage(0x44, "")

							continue
						}

						original := normalizeDirectoryPath(kDatabaseDirectory)

						showProgress({color: "Green", title: translate("Transfering Session Database"), message: translate("...")})

						copyFiles(original, databaseLocationEdit)

						showProgress({progress: 100, message: translate("Finished...")})

						Sleep 200

						hideProgress()
					}

					sessionDB.DatabasePath := (normalizeDirectoryPath(databaseLocationEdit) . "\")

					title := translate("Information")

					changed := true
					restart := true
				}

				if !changed {
					oldConnections := []

					for identifier, serverURL in sessionDB.ServerURLs
						oldConnections.Push([identifier, serverURL, sessionDB.ServerToken[identifier], sessionDB.Groups[identifier]])

					if (oldConnections.Length() != connections.Length()) {
						changed := true
						restart := true
					}
					else
						loop % connections.Length()
						{
							currentConnection := A_Index

							loop 3
								if (oldConnections[currentConnection][A_Index] != connections[currentConnection][A_Index]) {
									changed := true

									if (A_Index > 1)
										restart := true
								}

							if (!changed && (values2String(",", oldConnections[currentConnection][4]*) != values2String(",", connections[currentConnection][4]*))) {
								changed := true
								restart := true
							}
						}
				}

				configuration := readMultiMap(kUserConfigDirectory . "Session Database.ini")

				setMultiMapValue(configuration, "Team Server", "Replication", serverUpdateEdit)

				if changed {
					setMultiMapValue(configuration, "Team Server", "Synchronization", mapToString("|", "->", {}))

					databaseLocationEdit := (normalizeDirectoryPath(databaseLocationEdit) . "\")

					setMultiMapValue(configuration, "Database", "Path", databaseLocationEdit)

					serverURLs := {}
					serverTokens := {}
					groups := {}

					for ignore, connection in connections {
						serverURLs[connection[1]] := connection[2]
						serverTokens[connection[1]] := connection[3]
						groups[connection[1]] := values2String(",", connection[4]*)
					}

					setMultiMapValue(configuration, "Team Server", "Groups", mapToString("|", "->", groups))
					setMultiMapValue(configuration, "Team Server", "Server.URL", mapToString("|", "->", serverURLs))
					setMultiMapValue(configuration, "Team Server", "Server.Token", mapToString("|", "->", serverTokens))

					writeMultiMap(kUserConfigDirectory . "Session Database.ini", configuration)

					if restart {
						title := translate("Information")

						OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Ok"]))
						MsgBox 262192, %title%, % translate("The session database configuration has been updated and the application will exit now. Make sure to restart all other applications as well.")
						OnMessage(0x44, "")

						broadcastMessage(concatenate(kBackgroundApps, kForegroundApps), "exit")
					}
				}
				else
					writeMultiMap(kUserConfigDirectory . "Session Database.ini", configuration)

				SessionDatabase.reloadConfiguration()

				done := true
			}
		}

		Gui %window%:Destroy
	}
}

acceptSettings() {
	editSettings(kOk)
}

cancelSettings() {
	editSettings(kCancel)
}

chooseDatabaseLocation() {
	editSettings("DatabaseLocation")
}

addConnection() {
	editSettings("AddConnection")
}

deleteConnection() {
	editSettings("DeleteConnection")
}

nextConnection() {
	editSettings("NextConnection")
}

previousConnection() {
	editSettings("PreviousConnection")
}

rebuildDatabase() {
	OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Yes", "No"]))
	title := translate("Team Server")
	MsgBox 262436, %title%, % translate("Do you really want to rebuild the local database?")
	OnMessage(0x44, "")

	IfMsgBox Yes
		editSettings("Rebuild")
}

validateServerToken() {
	editSettings("ValidateToken")
}

updateSettingsState() {
	editSettings("UpdateState")
}

moveSettings() {
	moveByMouse("SE", "Session Database.Settings")
}

openSettingsDocumentation() {
	Run https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#database-configuration
}

loginDialog(connectorOrCommand := false, teamServerURL := false) {
	local window := "TSL"
	local title

	static result := false
	static nameEdit := ""
	static passwordEdit := ""

	if (connectorOrCommand == kOk)
		result := kOk
	else if (connectorOrCommand == kCancel)
		result := kCancel
	else {
		result := false

		Gui %window%:New

		Gui %window%:Default

		Gui %window%:-Border ; -Caption
		Gui %window%:Color, D0D0D0, D8D8D8

		Gui %window%:Font, Norm, Arial

		Gui %window%:Add, Text, x16 y16 w90 h23 +0x200, % translate("Server URL")
		Gui %window%:Add, Text, x110 yp w160 h23 +0x200, %teamServerURL%

		Gui %window%:Add, Text, x16 yp+30 w90 h23 +0x200, % translate("Name")
		Gui %window%:Add, Edit, x110 yp+1 w160 h21 VnameEdit, %nameEdit%
		Gui %window%:Add, Text, x16 yp+23 w90 h23 +0x200, % translate("Password")
		Gui %window%:Add, Edit, x110 yp+1 w160 h21 Password VpasswordEdit, %passwordEdit%

		Gui %window%:Add, Button, x60 yp+35 w80 h23 Default gacceptLogin, % translate("Ok")
		Gui %window%:Add, Button, x146 yp w80 h23 gcancelLogin, % translate("&Cancel")

		Gui %window%:Show, AutoSize Center

		while !result
			Sleep 100

		Gui %window%:Submit
		Gui %window%:Destroy

		if (result == kCancel)
			return false
		else if (result == kOk) {
			try {
				connectorOrCommand.Initialize(teamServerURL)

				connectorOrCommand.Login(nameEdit, passwordEdit)

				return connectorOrCommand.GetDataToken()
			}
			catch Any as exception {
				title := translate("Error")

				OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Ok"]))
				MsgBox 262160, %title%, % (translate("Cannot connect to the Team Server.") . "`n`n" . translate("Error: ") . exception.Message)
				OnMessage(0x44, "")

				return false
			}
		}
	}
}

acceptLogin() {
	loginDialog(kOk)
}

cancelLogin() {
	loginDialog(kCancel)
}

moveSessionDatabaseEditor() {
	moveByMouse(SessionDatabaseEditor.Instance.Window, "Session Database")
}

closeSessionDatabaseEditor() {
	ExitApp 0
}

openSessionDatabaseEditorDocumentation() {
	Run https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#managing-the-session-database
}

copyDirectory(source, destination, progressStep, ByRef count) {
	local files := []
	local ignore, fileName, file, subDirectory

	FileCreateDir %destination%

	loop Files, %source%\*.*, DF
		files.Push(A_LoopFilePath)

	for ignore, fileName in files {
		SplitPath fileName, file

		count += 1

		showProgress({progress: Round(50 + (count * progressStep)), message: translate("Copying ") . file . translate("...")})

		if InStr(FileExist(fileName), "D") {
			SplitPath fileName, subDirectory

			copyDirectory(fileName, destination . "\" . subDirectory, progressStep, count)
		}
		else
			FileCopy %fileName%, %destination%, 1
	}
}

copyFiles(source, destination) {
	local count := 0
	local progress := 0
	local step := 0

	source := normalizeDirectoryPath(source)
	destination := normalizeDirectoryPath(destination)

	showProgress({color: "Blue"})

	loop Files, %source%\*, DFR
	{
		if (Mod(count, 20) == 0)
			progress += 1

		showProgress({progress: Min(progress, 50), message: translate("Validating ") . A_LoopFileName . translate("...")})

		Sleep 1

		count += 1
	}

	showProgress({progress: 50, color: "Green"})

	copyDirectory(source, destination, 50 / count, step)
}

chooseSimulator() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window

	Gui %window%:Default

	GuiControlGet simulatorDropDown

	editor.loadSimulator(simulatorDropDown)
}

chooseCar() {
	local editor := SessionDatabaseEditor.Instance
	local simulator := editor.SelectedSimulator
	local window := editor.Window
	local index, car

	Gui %window%:Default

	GuiControlGet carDropDown

	if (carDropDown = translate("All"))
		editor.loadCar(true)
	else
		for index, car in editor.getCars(simulator)
			if (carDropDown = editor.getCarName(simulator, car)) {
				editor.loadCar(car)

				break
			}
}

chooseTrack() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window
	local simulator, tracks, trackNames

	Gui %window%:Default

	GuiControlGet trackDropDown

	if (trackDropDown = translate("All"))
		editor.loadTrack(true)
	else {
		simulator := editor.SelectedSimulator
		tracks := editor.getTracks(simulator, editor.SelectedCar)
		trackNames := collect(tracks, ObjBindMethod(editor, "getTrackName", simulator))

		editor.loadTrack(tracks[inList(trackNames, trackDropDown)])
	}
}

chooseWeather() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window

	Gui %window%:Default

	GuiControlGet weatherDropDown

	editor.loadWeather((weatherDropDown == 1) ? true : kWeatherConditions[weatherDropDown - 1])
}

updateNotes() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window

	Gui %window%:Default

	GuiControlGet notesEdit

	editor.updateNotes(notesEdit)
}

chooseSetting() {
	if (((A_GuiEvent = "Normal") || (A_GuiEvent = "RightClick")) && (A_EventInfo > 0))
		Task.startTask("chooseSettingAsync")
}

chooseSettingAsync() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window
	local defaultListView, selected, setting, value, settings, section, key, ignore, candidate
	local labels, descriptor, type

	Gui %window%:Default

	defaultListView := A_DefaultListView

	try {
		Gui ListView, % editor.SettingsListView

		selected := LV_GetNext(0)

		if !selected
			return

		LV_GetText(setting, selected, 1)
		LV_GetText(value, selected, 2)

		settings := editor.getAvailableSettings(selected)

		section := false
		key := false

		for ignore, candidate in settings
			if (setting = editor.getSettingLabel(candidate[1], candidate[2])) {
				section := candidate[1]
				key := candidate[2]

				break
			}

		labels := []

		for ignore, descriptor in settings
			labels.Push(editor.getSettingLabel(descriptor[1], descriptor[2]))

		bubbleSort(&labels)

		GuiControl, , settingDropDown, % "|" . values2String("|", labels*)
		GuiControl Choose, settingDropDown, % inList(labels, setting)

		ignore := false

		type := editor.getSettingType(section, key, ignore)

		if IsObject(type) {
			GuiControl Hide, settingValueEdit
			GuiControl Hide, settingValueText
			GuiControl Hide, settingValueCheck
			GuiControl Show, settingValueDropDown
			GuiControl Enable, settingValueDropDown

			labels := collect(type, "translate")

			GuiControl, , settingValueDropDown, % "|" . values2String("|", labels*)
			GuiControl Choose, settingValueDropDown, % inList(labels, value)
		}
		else if (type = "Boolean") {
			GuiControl Hide, settingValueDropDown
			GuiControl Hide, settingValueEdit
			GuiControl Hide, settingValueText
			GuiControl Show, settingValueCheck
			GuiControl Enable, settingValueCheck

			GuiControlGet settingValueCheck

			if (settingValueCheck != value)
				GuiControl, , settingValueCheck, % (value = "x") ? true : false
		}
		else if (type = "Text") {
			GuiControl Hide, settingValueDropDown
			GuiControl Hide, settingValueCheck
			GuiControl Hide, settingValueEdit
			GuiControl Show, settingValueText
			GuiControl Enable, settingValueText

			GuiControlGet settingValueText

			if (settingValueText != value) {
				settingValueText := value

				GuiControl, , settingValueText, %value%
			}
		}
		else {
			GuiControl Hide, settingValueDropDown
			GuiControl Hide, settingValueCheck
			GuiControl Hide, settingValueText
			GuiControl Show, settingValueEdit
			GuiControl Enable, settingValueEdit

			GuiControlGet settingValueEdit

			if (settingValueEdit != value) {
				settingValueEdit := value

				GuiControl, , settingValueEdit, %value%
			}
		}

		editor.updateState()
	}
	finally {
		Gui ListView, %defaultListView%
	}
}

addSetting() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window
	local defaultListView, settings, labels, ignore, setting, type, value, default

	Gui %window%:Default

	defaultListView := A_DefaultListView

	try {
		Gui ListView, % editor.SettingsListView

		settings := editor.getAvailableSettings(false)

		labels := []

		for ignore, setting in settings
			labels.Push(editor.getSettingLabel(setting[1], setting[2]))

		GuiControl Enable, settingDropDown
		GuiControl, , settingDropDown, % "|" . values2String("|", labels*)
		GuiControl Choose, settingDropDown, 1

		default := false

		type := editor.getSettingType(settings[1][1], settings[1][2], default)

		if IsObject(type) {
			GuiControl Hide, settingValueEdit
			GuiControl Hide, settingValueText
			GuiControl Hide, settingValueCheck
			GuiControl Show, settingValueDropDown
			GuiControl Enable, settingValueDropDown

			labels := collect(type, "translate")

			GuiControl, , settingValueDropDown, % "|" . values2String("|", labels*)
			GuiControl Choose, settingValueDropDown, % inList(type, default)

			value := default
		}
		else if (type = "Boolean") {
			GuiControl Hide, settingValueDropDown
			GuiControl Hide, settingValueEdit
			GuiControl Hide, settingValueText
			GuiControl Show, settingValueCheck
			GuiControl Enable, settingValueCheck

			GuiControl, , settingValueCheck, %default%

			value := default
		}
		else if (type = "Text") {
			GuiControl Hide, settingValueDropDown
			GuiControl Hide, settingValueCheck
			GuiControl Hide, settingValueEdit
			GuiControl Show, settingValueText
			GuiControl Enable, settingValueText

			GuiControl, , settingValueText, %default%

			value := default
		}
		else {
			GuiControl Hide, settingValueDropDown
			GuiControl Hide, settingValueCheck
			GuiControl Hide, settingValueText
			GuiControl Show, settingValueEdit
			GuiControl Enable, settingValueEdit

			value := default

			settingValueEdit := displayValue("Float", default)
			GuiControl, , settingValueEdit, %settingValueEdit%
		}

		editor.addSetting(settings[1][1], settings[1][2], value)
	}
	finally {
		Gui ListView, %defaultListView%
	}
}

deleteSetting() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window
	local defaultListView, selected, settings, section, key, ignore, setting

	Gui %window%:Default

	defaultListView := A_DefaultListView

	try {
		Gui ListView, % editor.SettingsListView

		selected := LV_GetNext(0)

		if !selected
			return

		GuiControlGet settingDropDown

		settings := editor.getAvailableSettings(selected)

		section := false
		key := false

		for ignore, setting in settings
			if (settingDropDown = editor.getSettingLabel(setting[1], setting[2])) {
				section := setting[1]
				key := setting[2]

				break
			}

		SessionDatabaseEditor.Instance.deleteSetting(section, key)
	}
	finally {
		Gui ListView, %defaultListView%
	}
}

selectSetting() {
	Task.startTask("selectSettingAsync")
}

selectSettingAsync() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window
	local defaultListView, selected, settings, section, key, ignore, setting, type, value, default, labels

	Gui %window%:Default

	defaultListView := A_DefaultListView

	try {
		Gui ListView, % editor.SettingsListView

		selected := LV_GetNext(0)

		if !selected
			return

		GuiControlGet settingDropDown

		settings := editor.getAvailableSettings(selected)

		section := false
		key := false

		for ignore, setting in settings
			if (settingDropDown = editor.getSettingLabel(setting[1], setting[2])) {
				section := setting[1]
				key := setting[2]

				break
			}

		default := false

		type := editor.getSettingType(section, key, default)

		if IsObject(type) {
			GuiControl Hide, settingValueEdit
			GuiControl Hide, settingValueText
			GuiControl Hide, settingValueCheck
			GuiControl Show, settingValueDropDown
			GuiControl Enable, settingValueDropDown

			labels := collect(type, "translate")

			GuiControl, , settingValueDropDown, % "|" . values2String("|", labels*)
			GuiControl Choose, settingValueDropDown, % inList(type, default)

			value := default
		}
		else if (type = "Boolean") {
			GuiControl Hide, settingValueDropDown
			GuiControl Hide, settingValueEdit
			GuiControl Hide, settingValueText
			GuiControl Show, settingValueCheck
			GuiControl Enable, settingValueCheck

			GuiControl, , settingValueCheck, %default%

			value := default
		}
		else if (type = "Text") {
			GuiControl Hide, settingValueDropDown
			GuiControl Hide, settingValueEdit
			GuiControl Hide, settingValueCheck
			GuiControl Show, settingValueText
			GuiControl Enable, settingValueText

			GuiControl, , settingValueText, %default%

			value := default
		}
		else {
			GuiControl Hide, settingValueDropDown
			GuiControl Hide, settingValueCheck
			GuiControl Hide, settingValueText
			GuiControl Show, settingValueEdit
			GuiControl Enable, settingValueEdit

			value := default

			settingValueEdit := displayValue("Float", value)
			GuiControl, , settingValueEdit, %settingValueEdit%
		}

		editor.updateSetting(section, key, value)
	}
	finally {
		Gui ListView, %defaultListView%
	}
}

changeSetting() {
	Task.startTask("changeSettingAsync")
}

changeSettingAsync() {
	local editor := SessionDatabaseEditor.Instance
	local window, defaultListView, selected, settings, section, key, ignore, setting
	local type, value, oldValue

	if (editor.SelectedModule = "Settings") {
		window := editor.Window

		Gui %window%:Default

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % editor.SettingsListView

			selected := LV_GetNext(0)

			if !selected
				return

			GuiControlGet settingDropDown

			settings := editor.getAvailableSettings(selected)

			section := false
			key := false

			for ignore, setting in settings
				if (settingDropDown = editor.getSettingLabel(setting[1], setting[2])) {
					section := setting[1]
					key := setting[2]

					break
				}

			ignore := false

			type := editor.getSettingType(section, key, ignore)

			if IsObject(type) {
				GuiControlGet settingValueDropDown

				value := type[inList(collect(type, "translate"), settingValueDropDown)]
			}
			else if (type = "Boolean") {
				GuiControlGet settingValueCheck

				value := settingValueCheck
			}
			else if (type = "Text") {
				GuiControlGet settingValueText

				if InStr(settingValueText, "`n") {
					settingValueText := StrReplace(settingValueText, "`n", A_Space)

					GuiControl, , settingValueText, %settingValueText%
				}

				value := settingValueText
			}
			else {
				oldValue := settingValueEdit

				GuiControlGet settingValueEdit

				if (type = "Integer") {
					if settingValueEdit is not Integer
					{
						settingValueEdit := oldValue

						GuiControl, , settingValueEdit, %settingValueEdit%
					}

					value := settingValueEdit
				}
				else if (type = "Float") {
					value := internalValue("Float", settingValueEdit)

					if value is not Number
					{
						settingValueEdit := oldValue

						GuiControl, , settingValueEdit, %settingValueEdit%

						value := internalValue("Float", settingValueEdit)
					}
				}
			}

			editor.updateSetting(section, key, value)
		}
		finally {
			Gui ListView, %defaultListView%
		}
	}
}

chooseStrategy() {
	local editor := SessionDatabaseEditor.Instance

	if (((A_GuiEvent = "Normal") || (A_GuiEvent = "RightClick")) && (A_EventInfo > 0))
		editor.selectStrategy(A_EventInfo)
}

updateStrategyAccess() {
	local editor := SessionDatabaseEditor.Instance
	local sessionDB := editor.SessionDatabase
	local selected, type, name

	GuiControlGet shareStrategyWithCommunityCheck
	GuiControlGet shareStrategyWithTeamServerCheck

	Gui ListView, % editor.StrategyListView

	selected := LV_GetNext(0)

	if selected {
		LV_GetText(name, selected, 2)

		info := sessionDB.readStrategyInfo(editor.SelectedSimulator, editor.SelectedCar, editor.SelectedTrack, name)

		setMultiMapValue(info, "Strategy", "Synchronized", false)
		setMultiMapValue(info, "Access", "Share", shareStrategyWithCommunityCheck)
		setMultiMapValue(info, "Access", "Synchronize", shareStrategyWithTeamServerCheck)

		sessionDB.writeStrategyInfo(editor.SelectedSimulator, editor.SelectedCar, editor.SelectedTrack, name, info)
	}
}

uploadStrategy() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window

	Gui %window%:Default

	editor.uploadStrategy()
}

downloadStrategy() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window
	local defaultListView, name

	Gui %window%:Default

	defaultListView := A_DefaultListView

	try {
		Gui ListView, % editor.StrategyListView

		LV_GetText(name, LV_GetNext(0), 2)

		editor.downloadStrategy(name)
	}
	finally {
		Gui ListView, %defaultListView%
	}
}

renameStrategy() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window
	local defaultListView, name

	Gui %window%:Default

	defaultListView := A_DefaultListView

	try {
		Gui ListView, % editor.StrategyListView

		LV_GetText(name, LV_GetNext(0), 2)

		editor.renameStrategy(name)
	}
	finally {
		Gui ListView, %defaultListView%
	}
}

deleteStrategy() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window
	local defaultListView, name

	Gui %window%:Default

	defaultListView := A_DefaultListView

	try {
		Gui ListView, % editor.StrategyListView

		LV_GetText(name, LV_GetNext(0), 2)

		editor.deleteStrategy(name)
	}
	finally {
		Gui ListView, %defaultListView%
	}
}

chooseSetupType() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window

	Gui %window%:Default

	GuiControlGet setupTypeDropDown

	editor.loadSetups(kSetupTypes[setupTypeDropDown])
}

chooseSetup() {
	local editor := SessionDatabaseEditor.Instance

	if (((A_GuiEvent = "Normal") || (A_GuiEvent = "RightClick")) && (A_EventInfo > 0))
		editor.selectSetup(A_EventInfo)
}

updateSetupAccess() {
	local editor := SessionDatabaseEditor.Instance
	local sessionDB := editor.SessionDatabase
	local selected, type, name

	GuiControlGet shareSetupWithCommunityCheck
	GuiControlGet shareSetupWithTeamServerCheck
	GuiControlGet setupTypeDropDown

	type := kSetupTypes[setupTypeDropDown]

	Gui ListView, % editor.SetupListView

	selected := LV_GetNext(0)

	if selected {
		LV_GetText(name, selected, 2)

		info := sessionDB.readSetupInfo(editor.SelectedSimulator, editor.SelectedCar, editor.SelectedTrack, type, name)

		setMultiMapValue(info, "Setup", "Synchronized", false)
		setMultiMapValue(info, "Access", "Share", shareSetupWithCommunityCheck)
		setMultiMapValue(info, "Access", "Synchronize", shareSetupWithTeamServerCheck)

		sessionDB.writeSetupInfo(editor.SelectedSimulator, editor.SelectedCar, editor.SelectedTrack, type, name, info)
	}
}

uploadSetup() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window

	Gui %window%:Default

	GuiControlGet setupTypeDropDown

	editor.uploadSetup(kSetupTypes[setupTypeDropDown])
}

downloadSetup() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window
	local defaultListView, name

	Gui %window%:Default

	GuiControlGet setupTypeDropDown

	defaultListView := A_DefaultListView

	try {
		Gui ListView, % editor.SetupListView

		LV_GetText(name, LV_GetNext(0), 2)

		editor.downloadSetup(kSetupTypes[setupTypeDropDown], name)
	}
	finally {
		Gui ListView, %defaultListView%
	}
}

renameSetup() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window
	local defaultListView, name

	Gui %window%:Default

	GuiControlGet setupTypeDropDown

	defaultListView := A_DefaultListView

	try {
		Gui ListView, % editor.SetupListView

		LV_GetText(name, LV_GetNext(0), 2)

		editor.renameSetup(kSetupTypes[setupTypeDropDown], name)
	}
	finally {
		Gui ListView, %defaultListView%
	}
}

deleteSetup() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window
	local defaultListView, name

	Gui %window%:Default

	GuiControlGet setupTypeDropDown

	defaultListView := A_DefaultListView

	try {
		Gui ListView, % editor.SetupListView

		LV_GetText(name, LV_GetNext(0), 2)

		editor.deleteSetup(kSetupTypes[setupTypeDropDown], name)
	}
	finally {
		Gui ListView, %defaultListView%
	}
}

loadPressures() {
	local editor := SessionDatabaseEditor.Instance

	if (editor.SelectedModule = "Pressures")
		new WindowTask(editor.Window, ObjBindMethod(SessionDatabaseEditor.Instance, "loadPressures"), 100).start()
}

editPressures() {
	local editor := SessionDatabaseEditor.Instance

	if (editor.SelectedModule = "Pressures")
		new WindowTask(editor.Window, ObjBindMethod(SessionDatabaseEditor.Instance, "openPressuresEditor"), 100).start()
}

noSelect() {
	local editor, window, defaultListView

	if (((A_GuiEvent = "Normal") || (A_GuiEvent = "RightClick")) && (A_EventInfo > 0)) {
		editor := SessionDatabaseEditor.Instance
		window := editor.Window

		Gui %window%:Default

		defaultListView := A_DefaultListView

		try {
			Gui ListView, % editor.DataListView

			LV_Modify(A_EventInfo, "-Select")
		}
		finally {
			Gui ListView, %defaultListView%
		}
	}
}

selectTrackAction() {
	local editor := SessionDatabaseEditor.Instance
	local coordinateX := false
	local coordinateY := false
	local action := false
	local x, y, title, originalX, originalY, currentX, currentY

	MouseGetPos x, y

	if editor.findTrackCoordinate(x - editor.iTrackDisplayArea[1] - editor.iTrackDisplayArea[5]
								, y - editor.iTrackDisplayArea[2] - editor.iTrackDisplayArea[6]
								, coordinateX, coordinateY) {
		action := editor.findTrackAction(coordinateX, coordinateY)

		if action {
			if GetKeyState("Ctrl", "P") {
				OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Yes", "No"]))
				title := translate("Delete")
				MsgBox 262436, %title%, % translate("Do you really want to delete the selected action?")
				OnMessage(0x44, "")

				IfMsgBox Yes
					editor.deleteTrackAction(action)
			}
			else {
				originalX := action.X
				originalY := action.Y

				while (GetKeyState("LButton", "P")) {
					MouseGetPos x, y

					if editor.findTrackCoordinate(x - editor.iTrackDisplayArea[1] - editor.iTrackDisplayArea[5]
												, y - editor.iTrackDisplayArea[2] - editor.iTrackDisplayArea[6]
												, coordinateX, coordinateY) {
						action.X := coordinateX
						action.Y := coordinateY

						editor.updateTrackMap()
					}
				}

				currentX := action.X
				currentY := action.Y

				action.X := originalX
				action.Y := originalY

				if (editor.findTrackAction(currentX, currentY) == action) {
					editor.updateTrackMap()

					editor.actionClicked(originalX, originalY, action)
				}
				else {
					action.X := currentX
					action.Y := currentY
				}
			}
		}
		else
			editor.trackClicked(coordinateX, coordinateY)
	}
}

selectTrackAutomation() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window
	local index, trackAutomation, checkedRows, checked, changed, ignore, row, defaultListView

	Gui %window%:Default

	if (((A_GuiEvent = "Normal") || (A_GuiEvent = "RightClick")) && (A_EventInfo > 0)) {
		trackAutomation := editor.TrackAutomations[A_EventInfo].Clone()
		trackAutomation.Actions := trackAutomation.Actions.Clone()
		trackAutomation.Origin := editor.TrackAutomations[A_EventInfo]

		editor.iSelectedTrackAutomation := trackAutomation

		GuiControl, , trackAutomationNameEdit, % trackAutomation.Name

		editor.updateTrackAutomationInfo()

		editor.createTrackMap(editor.SelectedTrackAutomation.Actions)

		editor.updateState()
	}

	defaultListView := A_DefaultListView

	try {
		Gui ListView, % editor.TrackAutomationsListView

		checkedRows := []
		checked := LV_GetNext(0, "C")

		while checked {
			checkedRows.Push(checked)

			checked := LV_GetNext(checked, "C")
		}

		changed := false

		for index, trackAutomation in editor.TrackAutomations
			if !inList(checkedRows, index)
				if trackAutomation.Active {
					trackAutomation.Active := false

					changed := true
				}

		for index, row in checkedRows
			if !editor.TrackAutomations[row].Active {
				editor.TrackAutomations[row].Active := true

				checkedRows.RemoveAt(index)

				changed := true

				break
			}

		if changed {
			for ignore, row in checkedRows {
				editor.TrackAutomations[row].Active := false

				LV_Modify(row, "-Check")
			}

			editor.writeTrackAutomations(false)

		}
	}
	finally {
		Gui ListView, %defaultListView%
	}
}

addTrackAutomation() {
	SessionDatabaseEditor.Instance.addTrackAutomation()
}

deleteTrackAutomation() {
	local title := translate("Delete")

	OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Yes", "No"]))
	MsgBox 262436, %title%, % translate("Do you really want to delete the selected automation?")
	OnMessage(0x44, "")

	IfMsgBox Yes
		SessionDatabaseEditor.Instance.deleteTrackAutomation()
}

saveTrackAutomation() {
	SessionDatabaseEditor.Instance.saveTrackAutomation()
}

selectData() {
	SessionDatabaseEditor.Instance.updateState()
}

selectAllData() {
	GuiControlGet dataSelectCheck

	if (dataSelectCheck == -1) {
		dataSelectCheck := 0

		GuiControl, , dataSelectCheck, 0
	}

	Gui ListView, % SessionDatabaseEditor.Instance.AdministrationListView

	loop % LV_GetCount()
		LV_Modify(A_Index, dataSelectCheck ? "Check" : "-Check")

	SessionDatabaseEditor.Instance.updateState()
}

exportData() {
	local title := translate("Select target folder...")
	local folder

	Gui +OwnDialogs

	OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Select", "Select", "Cancel"]))
	FileSelectFolder folder, *%kDatabaseDirectory%, 0, %title%
	OnMessage(0x44, "")

	if (folder != "")
		SessionDatabaseEditor.Instance.exportData(folder . "\Export_" . A_Now)
}

importData() {
	local title := translate("Select export folder...")
	local folder, info, selection

	Gui +OwnDialogs

	OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Select", "Select", "Cancel"]))
	FileSelectFolder folder, *%kDatabaseDirectory%, 0, %title%
	OnMessage(0x44, "")

	if (folder != "")
		if FileExist(folder . "\Export.info") {
			info := readMultiMap(folder . "\Export.info")

			if (getMultiMapValue(info, "General", "Simulator") = SessionDatabaseEditor.Instance.SelectedSimulator) {
				selection := selectImportData(SessionDatabaseEditor.Instance, folder)

				if selection
					SessionDatabaseEditor.Instance.importData(folder, selection)
			}
			else {
				title := translate("Error")

				OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Ok"]))
				MsgBox 262160, %title%, % translate("The data has not been exported for the currently selected simulator.")
				OnMessage(0x44, "")
			}
		}
		else {
			title := translate("Error")

			OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Ok"]))
			MsgBox 262160, %title%, % translate("This is not a valid folder with exported data.")
			OnMessage(0x44, "")
		}
}

deleteData() {
	local title := translate("Delete")

	OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Yes", "No"]))
	MsgBox 262436, %title%, % translate("Do you really want to delete the selected data?")
	OnMessage(0x44, "")

	IfMsgBox Yes
		SessionDatabaseEditor.Instance.deleteData()
}

chooseTab1() {
	local editor := SessionDatabaseEditor.Instance

	if editor.moduleAvailable("Settings")
		editor.selectModule("Settings")
}

chooseTab2() {
	local editor := SessionDatabaseEditor.Instance

	if editor.moduleAvailable("Strategies")
		editor.selectModule("Strategies")
}

chooseTab3() {
	local editor := SessionDatabaseEditor.Instance

	if editor.moduleAvailable("Setups")
		editor.selectModule("Setups")
}

chooseTab4() {
	local editor := SessionDatabaseEditor.Instance

	if editor.moduleAvailable("Pressures")
		editor.selectModule("Pressures")
}

chooseTab5() {
	local editor := SessionDatabaseEditor.Instance

	if editor.moduleAvailable("Automation")
		editor.selectModule("Automation")
}

chooseTab6() {
	local editor := SessionDatabaseEditor.Instance

	if editor.moduleAvailable("Data")
		editor.selectModule("Data")
}

chooseDatabaseScope() {
	local editor := SessionDatabaseEditor.Instance
	local window := editor.Window
	local persistent, title

	Gui %window%:Default

	GuiControlGet databaseScopeDropDown

	persistent := false

	if GetKeyState("Ctrl", "P") {
		OnMessage(0x44, Func("translateMsgBoxButtons").Bind(["Yes", "No"]))
		title := translate("Modular Simulator Controller System")
		MsgBox 262436, %title%, % translate("Do you really want to change the scope for all applications?")
		OnMessage(0x44, "")

		IfMsgBox Yes
			persistent := true
	}

	if (persistent || ((databaseScopeDropDown == 2) != editor.UseCommunity)) {
		editor.UseCommunity[persistent] := (databaseScopeDropDown == 2)

		editor.loadSimulator(editor.SelectedSimulator, true)
	}
}

transferPressures() {
	local editor := SessionDatabaseEditor.Instance
	local sessionDB := editor.SessionDatabase
	local window := editor.Window
	local tyrePressures, compounds, compound, compoundColor, ignore, pressureInfo, driver

	Gui %window%:Default

	GuiControlGet airTemperatureEdit
	GuiControlGet trackTemperatureEdit
	GuiControlGet tyreCompoundDropDown
	GuiControlGet driverDropDown

	if (driverDropDown = translate("All"))
		driver := [true]
	else
		driver := [sessionDB.getDriverID(editor.SelectedSimulator, driverDropDown)]

	tyrePressures := []

	compounds := sessionDB.getTyreCompounds(editor.SelectedSimulator, editor.SelectedCar, editor.SelectedTrack)

	compound := false
	compoundColor := false

	splitCompound(compounds[tyreCompoundDropDown], &compound, &compoundColor)

	for ignore, pressureInfo in new editor.EditorTyresDatabase().getPressures(editor.SelectedSimulator, editor.SelectedCar
																			, editor.SelectedTrack, editor.SelectedWeather
																			, convertUnit("Temperature", airTemperatureEdit, false)
																			, convertUnit("Temperature", trackTemperatureEdit, false)
																			, compound, compoundColor, driver*)
		tyrePressures.Push(pressureInfo["Pressure"] + ((pressureInfo["Delta Air"] + Round(pressureInfo["Delta Track"] * 0.49)) * 0.1))

	messageSend(kFileMessage, "Setup", "setTyrePressures:" . values2String(";", compound, compoundColor, tyrePressures*), editor.RequestorPID)
}

testSettings() {
	local editor := SessionDatabaseEditor.Instance
	local exePath := kBinariesDirectory . "Race Settings.exe"
	local fileName := kTempDirectory . "Temp.settings"
	local settings, section, values, key, value, options

	try {
		settings := readMultiMap(getFileName("Race.settings", kUserConfigDirectory, kConfigDirectory))

		for section, values in new SettingsDatabase().loadSettings(editor.SelectedSimulator, editor.SelectedCar["*"]
																 , editor.SelectedTrack["*"], editor.SelectedWeather["*"], false)
			for key, value in values
				setMultiMapValue(settings, section, key, value)

		writeMultiMap(fileName, settings)

		options := "-NoTeam -Test -File """ . fileName . """"

		if (editor.SelectedSimulator)
			options .= (" -Simulator """ . editor.SelectedSimulator . """")

		if (editor.SelectedCar)
			options .= (" -Car """ . editor.SelectedCar . """")

		if (editor.SelectedTrack)
			options .= (" -Track """ . editor.SelectedTrack . """")

		Run "%exePath%" %options%, %kBinariesDirectory%
	}
	catch Any as exception {
		logMessage(kLogCritical, translate("Cannot start the Race Settings tool (") . exePath . translate(") - please rebuild the applications in the binaries folder (") . kBinariesDirectory . translate(")"))

		showMessage(substituteVariables(translate("Cannot start the Race Settings tool (%exePath%) - please check the configuration..."), {exePath: exePath})
				  , translate("Modular Simulator Controller System"), "Alert.png", 5000, "Center", "Bottom", 800)
	}
}

showSessionDatabaseEditor() {
	local icon := kIconsDirectory . "Session Database.ico"
	local settings := readMultiMap(kUserConfigDirectory . "Application Settings.ini")
	local simulator := getMultiMapValue(settings, "Session Database", "Simulator", false)
	local car := getMultiMapValue(settings, "Session Database", "Car", false)
	local track := getMultiMapValue(settings, "Session Database", "Track", false)
	local weather := false
	local airTemperature := 23
	local trackTemperature:= 27
	local compound := false
	local compoundColor := false
	local requestorPID := false
	local index := 1
	local editor

	Menu Tray, Icon, %icon%, , 1
	Menu Tray, Tip, Session Database

	while (index < A_Args.Length()) {
		switch A_Args[index] {
			case "-Simulator":
				simulator := A_Args[index + 1]
				index += 2
			case "-Car":
				car := A_Args[index + 1]
				index += 2
			case "-Track":
				track := A_Args[index + 1]
				index += 2
			case "-Weather":
				weather := A_Args[index + 1]
				index += 2
			case "-AirTemperature":
				airTemperature := A_Args[index + 1]
				index += 2
			case "-TrackTemperature":
				trackTemperature := A_Args[index + 1]
				index += 2
			case "-Compound":
				compound := A_Args[index + 1]
				index += 2
			case "-CompoundColor":
				compoundColor := A_Args[index + 1]
				index += 2
			case "-Setup":
				requestorPID := A_Args[index + 1]
				index += 2
			default:
				index += 1
		}
	}

	if (airTemperature <= 0)
		airTemperature := 23

	if (trackTemperature <= 0)
		trackTemperature := 27

	fixIE(11)

	protectionOn()

	try {
		editor := SessionDatabaseEditor(simulator, car, track, weather, airTemperature, trackTemperature, compound, compoundColor, requestorPID)

		editor.createGui(editor.Configuration)

		editor.show()
	}
	finally {
		protectionOff()
	}

	return
}


;;;-------------------------------------------------------------------------;;;
;;;                         Initialization Section                          ;;;
;;;-------------------------------------------------------------------------;;;

showSessionDatabaseEditor()