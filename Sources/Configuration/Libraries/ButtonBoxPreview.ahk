;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   Modular Simulator Controller System - Button Box Preview              ;;;
;;;                                                                         ;;;
;;;   Author:     Oliver Juwig (TheBigO)                                    ;;;
;;;   License:    (2023) Creative Commons - BY-NC-SA                        ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;-------------------------------------------------------------------------;;;
;;;                        Private Constant Section                         ;;;
;;;-------------------------------------------------------------------------;;;

global kEmptySpaceDescriptor := "Button;" . kButtonBoxImagesDirectory . "Empty.png;52 x 52"


;;;-------------------------------------------------------------------------;;;
;;;                          Public Classes Section                         ;;;
;;;-------------------------------------------------------------------------;;;

;;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;;
;;; ButtonBoxPreview                                                        ;;;
;;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;;;

class ButtonBoxPreview extends ControllerPreview {
	static kHeaderHeight := 70
	static kLabelMargin := 5

	static kRowMargin := 20
	static kColumnMargin := 40

	static kSidesMargin := 20
	static kBottomMargin := 15

	iRows := 0
	iColumns := 0
	iRowMargin := this.kRowMargin
	iColumnMargin := this.kColumnMargin
	iSidesMargin := this.kSidesMargin
	iBottomMargin := this.kBottomMargin

	iRowDefinitions := []

	iFunctions := {}
	iLabels := {}

	Type {
		Get {
			return "Button Box"
		}
	}

	RowMargin {
		Get {
			return this.iRowMargin
		}
	}

	ColumnMargin {
		Get {
			return this.iColumnMargin
		}
	}

	SidesMargin {
		Get {
			return this.iSidesMargin
		}
	}

	BottomMargin {
		Get {
			return this.iBottomMargin
		}
	}

	RowDefinitions[row := false] {
		Get {
			if row
				return this.iRowDefinitions[row]
			else
				return this.iRowDefinitions
		}
	}

	createGui(configuration) {
		local rowHeights := false
		local columnWidths := false
		local function, height, width, window, vertical, row, rowHeight, rowDefinition
		local horizontal, column, columnWidth, descriptor, label, labelWidth, labelHeight, descriptor, number
		local image, imageWidth, imageHeight, x, y, labelHandle

		this.computeLayout(rowHeights, columnWidths)

		height := 0

		loop % rowHeights.Length()
			height += rowHeights[A_Index]

		width := 0

		loop % columnWidths.Length()
			width += columnWidths[A_Index]

		height += ((rowHeights.Length() - 1) * this.RowMargin) + this.kHeaderHeight + this.BottomMargin
		width += ((columnWidths.Length() - 1) * this.ColumnMargin) + (2 * this.SidesMargin)

		window := this.Window

		Gui %window%:-Border -Caption

		Gui %window%:+LabelbuttonBox

		Gui %window%:Add, Picture, x-10 y-10, % kButtonBoxImagesDirectory . "Photorealistic\CF Background.png"

		Gui %window%:Font, s12 Bold cSilver
		Gui %window%:Add, Text, x0 y8 w%width% h23 +0x200 +0x1 BackgroundTrans, % translate("Modular Simulator Controller System")
		Gui %window%:Font, s10 cSilver
		Gui %window%:Add, Text, x0 y28 w%width% h23 +0x200 +0x1 BackgroundTrans, % this.Name
		Gui %window%:Color, 0x000000
		Gui %window%:Font, s8 Norm, Arial

		vertical := this.kHeaderHeight

		loop % this.Rows
		{
			row := A_Index

			rowHeight := rowHeights[A_Index]
			rowDefinition := this.RowDefinitions[A_Index]

			horizontal := this.SidesMargin

			loop % this.Columns
			{
				column := A_Index

				columnWidth := columnWidths[A_Index]

				descriptor := rowDefinition[A_Index]

				if (StrLen(Trim(descriptor)) = 0)
					descriptor := "Empty.0"

				descriptor := string2Values(",", descriptor)

				if (descriptor.Length() > 1) {
					label := string2Values("x", getMultiMapValue(this.Configuration, "Labels", descriptor[2], ""))
					labelWidth := label[1]
					labelHeight := label[2]
				}
				else {
					labelWidth := 0
					labelHeight := 0
				}

				if (descriptor[1] = "Empty.0") {
					descriptor := kEmptySpaceDescriptor
					number := 0
				}
				else {
					descriptor := ConfigurationItem.splitDescriptor(descriptor[1])
					number := descriptor[2]
					descriptor := getMultiMapValue(this.Configuration, "Controls", descriptor[1], "")
				}

				descriptor := string2Values(";", descriptor)

				if (descriptor.Length() > 0) {
					function := descriptor[1]
					image := substituteVariables(descriptor[2])

					descriptor := string2Values("x", descriptor[3])
					imageWidth := descriptor[1]
					imageHeight := descriptor[2]

					function := ConfigurationItem.descriptor(function, number)

					if !this.iFunctions.HasKey(row)
						this.iFunctions[row] := {}

					this.iFunctions[row][column] := function

					x := horizontal + Round((columnWidth - imageWidth) / 2)
					y := vertical + Round((rowHeight - (labelHeight + this.kLabelMargin) - imageHeight) / 2)

					Gui %window%:Add, Picture, x%x% y%y% w%imageWidth% h%imageHeight% BackgroundTrans gcontrolClick, %image%

					if ((labelWidth > 0) && (labelHeight > 0)) {
						Gui %window%:Font, s8 Norm cBlack

						x := horizontal + Round((columnWidth - labelWidth) / 2)
						y := vertical + rowHeight - labelHeight

						labelHandle := false

						Gui %window%:Add, Text, x%x% y%y% w%labelWidth% h%labelHeight% +Border -Background HWNDlabelHandle +0x1000 +0x1 gcontrolClick, %number%

						if !this.iLabels.HasKey(row)
							this.iLabels[row] := {}

						this.iLabels[row][column] := labelHandle
					}
				}

				horizontal += (columnWidth + this.ColumnMargin)
			}

			vertical += (rowHeight + this.RowMargin)
		}

		this.Width := width
		this.Height := height
	}

	createBackground(configuration) {
		local window := this.Window
		local previewMover := this.PreviewManager.getPreviewMover()
		
		previewMover := (previewMover ? ("g" . previewMover) : "")

		Gui %window%:Add, Picture, x-10 y-10 %previewMover% 0x4000000, % kButtonBoxImagesDirectory . "Photorealistic\CF Background.png"
	}

	loadFromConfiguration(configuration) {
		local layout := string2Values(",", getMultiMapValue(configuration, "Layouts", ConfigurationItem.descriptor(this.Name, "Layout"), ""))
		local rows := []

		if (layout.Length() > 1)
			this.iRowMargin := layout[2]

		if (layout.Length() > 2)
			this.iColumnMargin := layout[3]

		if (layout.Length() > 3)
			this.iSidesMargin := layout[4]

		if (layout.Length() > 4)
			this.iBottomMargin := layout[5]

		layout := string2Values("x", layout[1])

		this.Rows := layout[1]
		this.Columns := layout[2]

		loop % this.Rows
			rows.Push(string2Values(";", getMultiMapValue(configuration, "Layouts", ConfigurationItem.descriptor(this.Name, A_Index), "")))

		this.iRowDefinitions := rows
	}

	computeLayout(ByRef rowHeights, ByRef columnWidths) {
		local rowHeight, rowDefinition, descriptor, label, labelWidth, labelHeight, imageWidth, imageHeight

		rowHeights := []
		columnWidths := []

		loop % this.Columns
			columnWidths.Push(0)

		loop % this.Rows
		{
			rowHeight := 0

			rowDefinition := this.RowDefinitions[A_Index]

			loop % this.Columns
			{
				descriptor := rowDefinition[A_Index]

				if (StrLen(Trim(descriptor)) = 0)
					descriptor := "Empty.0"

				descriptor := string2Values(",", descriptor)

				if (descriptor.Length() > 1) {
					label := string2Values("x", getMultiMapValue(this.Configuration, "Labels", descriptor[2], ""))
					labelWidth := label[1]
					labelHeight := label[2]
				}
				else {
					labelWidth := 0
					labelHeight := 0
				}

				if (descriptor[1] = "Empty.0")
					descriptor := kEmptySpaceDescriptor
				else
					descriptor := getMultiMapValue(this.Configuration, "Controls"
													  , ConfigurationItem.splitDescriptor(descriptor[1])[1], "")

				descriptor := string2Values(";", descriptor)

				if (descriptor.Length() > 0) {
					descriptor := string2Values("x", descriptor[3])

					imageWidth := descriptor[1]
					imageHeight := descriptor[2]
				}
				else {
					imageWidth := 0
					imageHeight := 0
				}

				rowHeight := Max(rowHeight, imageHeight + ((labelHeight > 0) ? (this.kLabelMargin + labelHeight) : 0))

				columnWidths[A_Index] := Max(columnWidths[A_Index], Max(imageWidth, labelWidth))
			}

			rowHeights.Push(rowHeight)
		}
	}

	getControl(clickX, clickY, ByRef row, ByRef column, ByRef isEmpty) {
		local rowHeights := false
		local columnWidths := false
		local function, height, width, vertical, horizontal, rowHeight, rowDefinition, columnWidth
		local descriptor, name, number, image, imageWidth, imageHeight, x, y, labelHeight, label, labelWidth

		this.computeLayout(rowHeights, columnWidths)

		height := 0

		loop % rowHeights.Length()
			height += rowHeights[A_Index]

		width := 0

		loop % columnWidths.Length()
			width += columnWidths[A_Index]

		height += ((rowHeights.Length() - 1) * this.RowMargin) + this.kHeaderHeight + this.BottomMargin
		width += ((columnWidths.Length() - 1) * this.ColumnMargin) + (2 * this.SidesMargin)

		vertical := this.kHeaderHeight

		loop % this.Rows
		{
			row := A_Index

			rowHeight := rowHeights[A_Index]
			rowDefinition := this.RowDefinitions[A_Index]

			horizontal := this.SidesMargin

			loop % this.Columns
			{
				column := A_Index

				columnWidth := columnWidths[A_Index]

				descriptor := rowDefinition[A_Index]

				if (StrLen(Trim(descriptor)) = 0) {
					descriptor := "Empty.0"

					isEmpty := true
				}
				else
					isEmpty := false

				descriptor := string2Values(",", descriptor)

				if (descriptor.Length() > 1) {
					label := string2Values("x", getMultiMapValue(this.Configuration, "Labels", descriptor[2], ""))
					labelWidth := label[1]
					labelHeight := label[2]
				}
				else {
					labelWidth := 0
					labelHeight := 0
				}

				if (descriptor[1] = "Empty.0") {
					descriptor := kEmptySpaceDescriptor
					name := "Empty"
					number := 0
				}
				else {
					descriptor := ConfigurationItem.splitDescriptor(descriptor[1])
					name := descriptor[1]
					number := descriptor[2]
					descriptor := getMultiMapValue(this.Configuration, "Controls", descriptor[1], "")
				}

				descriptor := string2Values(";", descriptor)

				if (descriptor.Length() > 0) {
					function := descriptor[1]
					image := substituteVariables(descriptor[2])

					descriptor := string2Values("x", descriptor[3])
					imageWidth := descriptor[1]
					imageHeight := descriptor[2]

					x := horizontal + Round((columnWidth - imageWidth) / 2)
					y := vertical + Round((rowHeight - (labelHeight + this.kLabelMargin) - imageHeight) / 2)

					if ((clickX >= x) && (clickX <= (x + imageWidth)) && (clickY >= y) && (clickY <= (y + imageHeight)))
						return ["Control", ConfigurationItem.descriptor(name, number)]

					if ((labelWidth > 0) && (labelHeight > 0)) {
						x := horizontal + Round((columnWidth - labelWidth) / 2)
						y := vertical + rowHeight - labelHeight

						if ((clickX >= x) && (clickX <= (x + labelWidth)) && (clickY >= y) && (clickY <= (y + labelHeight)))
							return ["Label", ConfigurationItem.descriptor(name, number)]
					}
				}

				horizontal += (columnWidth + this.ColumnMargin)
			}

			vertical += (rowHeight + this.RowMargin)
		}

		return false
	}

	getFunction(row, column) {
		local rowFunctions

		if this.iFunctions.HasKey(row) {
			rowFunctions := this.iFunctions[row]

			if rowFunctions.HasKey(column)
				return rowFunctions[column]
		}

		return false
	}

	setLabel(row, column, text) {
		local rowLabels, label

		if this.iLabels.HasKey(row) {
			rowLabels := this.iLabels[row]

			if rowLabels.HasKey(column) {
				label := rowLabels[column]

				GuiControl Text, %label%, %text%
			}
		}
	}

	controlClick(element, row, column, isEmpty) {
		local handler := this.iControlClickHandler
		local function := ConfigurationItem.splitDescriptor(element[2])
		local control, descriptor

		for control, descriptor in getMultiMapValues(this.Configuration, "Controls")
			if (control = function[1]) {
				function := ConfigurationItem.descriptor(string2Values(";", descriptor)[1], function[2])

				break
			}

		return %handler%(this, element, function, row, column, isEmpty)
	}

	openControlMenu(preview, element, function, row, column, isEmpty) {
		local count, menuItem, window, label, handler, control, definition, menu

		if (GetKeyState("Ctrl", "P") && !isEmpty)
			LayoutsList.Instance.changeControl(row, column, "__Number__", false)
		else {
			menuItem := (translate(element[1]) . translate(": ") . StrReplace(element[2], "`n", A_Space) . " (" . row . " x " . column . ")")

			try {
				Menu MainMenu, DeleteAll
			}
			catch Any as exception {
				logError(exception)
			}

			window := this.Window

			Gui %window%:Default

			Menu MainMenu, Add, %menuItem%, controlMenuIgnore
			Menu MainMenu, Disable, %menuItem%
			Menu MainMenu, Add

			try {
				Menu ControlMenu, DeleteAll
			}
			catch Any as exception {
				logError(exception)
			}

			label := translate("Empty")
			handler := ObjBindMethod(LayoutsList.Instance, "changeControl", row, column, false)

			Menu ControlMenu, Add, %label%, %handler%
			Menu ControlMenu, Add

			for control, definition in ControlsList.Instance.getControls() {
				handler := ObjBindMethod(LayoutsList.Instance, "changeControl", row, column, control)

				Menu ControlMenu, Add, %control%, %handler%

				if (control = ConfigurationItem.splitDescriptor(element[2])[1])
					Menu ControlMenu, Check, %control%
			}

			if !isEmpty {
				Menu ControlMenu, Add

				try {
					Menu NumberMenu, DeleteAll
				}
				catch Any as exception {
					logError(exception)
				}

				label := translate("Input...")
				handler := ObjBindMethod(LayoutsList.Instance, "changeControl", row, column, "__Number__", false)

				Menu NumberMenu, Add, %label%, %handler%
				Menu NumberMenu, Add

				count := 1

				loop 4 {
					label := (count . " - " . (count + 9))

					menu := ("NumSubMenu" . A_Index)

					try {
						Menu %menu%, DeleteAll
					}
					catch Any as exception {
						logError(exception)
					}

					loop 10 {
						handler := ObjBindMethod(LayoutsList.Instance, "changeControl", row, column, "__Number__", count)

						Menu %menu%, Add, %count%, %handler%

						if (count = ConfigurationItem.splitDescriptor(element[2])[2])
							Menu %menu%, Check, %count%

						count += 1
					}

					Menu NumberMenu, Add, %label%, :%menu%
				}

				label := translate("Number")

				Menu ControlMenu, Add, %label%, :NumberMenu
			}

			label := translate("Control")

			Menu MainMenu, Add, %label%, :ControlMenu

			if !isEmpty {
				try {
					Menu LabelMenu, DeleteAll
				}
				catch Any as exception {
					logError(exception)
				}

				label := translate("Empty")
				handler := ObjBindMethod(LayoutsList.Instance, "changeLabel", row, column, false)

				Menu LabelMenu, Add, %label%, %handler%
				Menu LabelMenu, Add

				for label, definition in LabelsList.Instance.getLabels() {
					handler := ObjBindMethod(LayoutsList.Instance, "changeLabel", row, column, label)

					Menu LabelMenu, Add, %label%, %handler%
				}

				label := translate("Label")

				Menu MainMenu, Add, %label%, :LabelMenu
			}

			Menu MainMenu, Show
		}
	}
}

;;;-------------------------------------------------------------------------;;;
;;;                   Private Function Declaration Section                  ;;;
;;;-------------------------------------------------------------------------;;;

buttonBoxContextMenu(guiHwnd, ctrlHwnd, eventInfo, isRightClick, x, y) {
	if (isRightClick && ControllerPreview.ControllerPreviews.HasKey(A_Gui))
		controlClick()
}