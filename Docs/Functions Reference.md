## Thread Protection ([Task.ahk](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Sources/Libraries/Task.ahk))
In AutoHotkey scripts, running threads may be interrupted by other events, such as keyboard events or timer functions. Using the functions below, it is possible to create protected sections of code, which may not be interrupted.

#### *protectionOn()*
Starts a protected section of code. Calls to protectionOn() may be nested.

#### *protectionOff()*
Finishes a protected section of code. Only if the outermost section has been finished, the current thread becomes interruptable again.

#### *withProtection(function :: TypeUnion(String, FuncObj), #rest params)*
Convenience function to call a given function with supplied parameters in a protected section.

***

## Debugging and Logging ([Debug.ahk](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Sources/Framework/Debug.ahk))
Essential support for tracking down coding errors. Since AutoHotkey is a weakly typed programming language, it is sometimes very difficult to get to the root cause of an error. Especially the tracing and logging capabilities may help here. All log files are located in the *Simulator Controller\Logs* folder found in your user *Documents* folder.

#### *isDevelopment()*
Returns *true*, if the current application was compiled for the development enviroment. This enables additonal debug support for the underlying language runtime system.

#### *isDebug()*
Returns *true*, if debugging is currently enabled. The Simulator Controller uses debug mode to handle things differently, for example all plugins and modes will be active, even if they declare to be not.

#### *setDebug(debug :: Boolean)*
Enables or disables debug mode. The default value for non compiled scripts is *ture*, but you can also define debug mode for compiled scripts using the [configuration tool](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#configuration).

#### *getLogLevel()*
Return the current log level. May be one of: *kLogInfo*, *kLogWarn*, *kLogCritical* or *kLogOff*.

#### *setLogLevel(logLevel :: OneOf(kLogInfo, kLogWarn, kLogCritical, kLogOff))*
Sets the current log level. If *logLevel* is *kLogOff*, logging will normally be fully supressed.

#### *increaseLogLevel()*
Increases the current log level.

#### *decreaseLogLevel()*
Reduces the current log level.

#### *logMessage(logLevel :: OneOf(kLogInfo, kLogWarn, kLogCritical, kLogOff), message :: String)*
Sends the given message to the log file, if the supplied log level is at the same or a more critical level than the current log level. If *logLevel* is *kLogOff*, the message will be written to the log file, even if logging has been disabled completely by *setLogLevel(kLogOff)* previously.

#### *logError(exception)*
Writes information about the exception to the log file and continues.

***

## String Helper Functions ([Strings.ahk](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Sources/Framework/Strings.ahk))
Often used string functions, that are not part of the AutoHotkey language.

#### *substituteVariables(string :: String, values :: Map := {})*
Substitutes all variables enclosed by "%" with their values and returns the modified string. The values are lookedup from the supplied values map. If not found there, the global name space is used.

#### *string2Values(delimiter :: String, string :: String, count :: Integer := false)*
Splits *string* apart using the supplied delimiter and returns the parts as an array. If *count* is supplied, only that much parts are splitted and all remaining ocurrencies of *delimiter* are ignored.

#### *values2String(delimiter :: String, #rest values)*
Joins the given unlimited number of values using *delimiter* into one string. *values* must have a string representation.

***

## Collection Helper Functions ([Collections.ahk](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Sources/Framework/Collections.ahk))
Often used collection functions, that are not part of the AutoHotkey language.

#### *inList(list :: Array, value)*
Returns the position of *value* in the given list or array, or *false*, if not found.

#### *listEqual(list1 :: Array, list2 :: Array)*
Returns *true*, if the given lists are identical in size and contain the same elements.

#### *concatenate(#rest lists :: Array)*
Returns a freshly allocated list containing all the elements contained in the supplied lists. The global order is preserved.

#### *reverse(list :: Array)*
Returns a freshly allocated list containing all the elements of the supplied list in reversed order.

#### *map(list :: Array, function :: TypeUnion(String, FuncObj))*
Returns a new list with the result of *function* applied to each element in *list*, while preserving the order of elements.

#### *remove(list :: Array, object :: Object)*
Returns a new list with all occurencies of *object* removed from the original list.

#### *removeDuplicates(list :: Array)*
Returns a new list with all duplicate values removed.

#### *do(list :: Array, function :: TypeUnion(String, FuncObj))*
Applies the given function to each element in *list* in the order of elements without collecting the results.

#### *getKeys(map :: Map)*
Returns a list of all keys in the given map.

#### *getValues(map :: Map)*
Returns a list of all values in the given map in the order of their keys.

#### *combine(#rest maps :: Map)*
Returns a freshly allocated map containing all the key/value pairs of all supplied maps. The maps are processed from left to right, which is important in case of duplicate keys.

#### *bubbleSort(ByRef array :: Array, comparator :: Function Name)*
Sorts the given array in place, using *comparator* to define the order of the elements. This function will receive two objects and must return *true*, if the first one is considered larger or of the same order than the other. Stable sorting rules apply.

***

## File Handling ([Files.ahk](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Sources/Framework/Files.ahk))
A small collection of functions to deal with files and directories. Note: All the directory names used with these functions must contain a trailing backslash "\", since this is standard in the Simulator Controller code.

#### *getFileName*(fileName :: String, #rest directories :: String)*
If *fileName* contains an absolute path, itself will be returned. Otherwise, all directories will be checked, if a file with the (partial) path can be found, and this file path will be returned. If not found, a path consisting of the first supplied directory and *fileName* will be returned.

#### *getFileNames*(filePattern :: String, #rest directories :: String)*
Returns a list of absolute paths for all files in the given directories satisfying *filePattern*.

#### *temporaryFileName(name :: String, extension :: String)*
Creates a unique file name for a file located in the *Temp* folder. *name* will be followed by a unique number and the file will have an extension as defined by the second parameter.

#### *normalizeFilePath(filePath :: String)*
Removes all "\\*directory*\\.." occurrencies from *filePath* and returns this simplified file path.

#### *normalizeDirectoryPath(directoryPath :: String)*
Assures that a trailing "\" is present at the end of the directory path.

#### *temporaryFileName(name :: String, extension :: String)*
Creates and returns a unique file name in the temporary folder by adding a random number between 1 and 100000 to the name.

#### *deleteFile(fileName :: String)*
Deletes the file with the given name. Returns *true*, if the file was deleted, otherwise *false*.

#### *deleteDirectory(directoryName :: String)*
Deletes the directory with the given name incl. all current content. Returns *true*, if the directory was deleted, otherwise *false*.

***

## Process Communication ([Messages.ahk](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Sources/Libraries/Messages.ahk))
Messages may be used to communicate between different processes. In Simulator Controller, the startup application sends events to the controller application to start all components configured for the Simulator Controller, to play and stop a startup song and so on.

#### *registerMesssageHandler(category :: String, handler :: TypeUnion(String, FuncObj), object :: Object := false)*
Registers a message handler function for the given category. When *object* is not supplied, a message handler is supplied the category and the transmitted message as arguments and typically looks like this:

	handleStartupMessages(category, data) {
		if InStr(data, ":") {
			data := StrSplit(data, ":")
			
			function := data[1]
			arguments := string2Values(";", data[2])
				
			withProtection(function, arguments*)
		}
		else	
			withProtection(data)
	}

When *object* was supplied during registration, the handler will receive the given *objec* as its second argument:

	handleControllerMessages(category, controller, data) {
		...
	}

Since both variants are very common implementations of a message handler, the predefined *functionMessageHandler* and *methodMessageHandler* may be used in those situations.

#### *functionMessageHandler(category :: String, data :: String)*
You can use this function as a generic message handler, when all messages will be handled by global functions. *data* must be a ";"-delimited string list, where the first element is the function name and all remaining elements are the arguments for the function call. You can pass *functionMessageHandler* to *registerMessageHandler* when registering message categories, which adhere to these rules.

#### *methodMessageHandler(category :: String, data :: String)*
You can use this function as a generic message handler, when all messages will be handled by methods of a single object. *data* must be a ";"-delimited string list, where the first element is the function name and all remaining elements are the arguments for the function call. You can pass *methodMessageHandler* to *registerMessageHandler* when registering message categories, which adhere to these rules.

#### *sendMessage(messageType :: OneOf(kLocalMessage, kWindowMessage, kPipeMessage, kFileMessage), category :: String, data :: String, target := false)*
Sends the given message. The first parameter defines the delivery method, where *kFileMessage* is the most reliable, but also the slowest one. If the argument for *messageType* is *kLocalMessage*, the message will be delivered in the current process. Otherwise, the message is delivered to the process defined by target, which must have registered a message handler for the given category. For *kWindowMessage*, the target must be defined according to the [window title pattern](https://www.autohotkey.com/docs/misc/WinTitle.htm) of *AutoHotkey* and for *kFileMessage*, you must provide the process id of the target process. Last but not least, if message type is *kPipeMessage*, no target must be specified and multiple processes may register a message handler for the given category, but only one process will receive the message.

***

## Configurations ([Configuration.ahk](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Sources/Framework/Configuration.ahk))
Configurations are used to store a definition or the state of an object to the file system. Configurations are organized as maps divided by sections or topics. Inside a section, you may have an unlimited number of values referenced by keys. Configuration maps are typically stored in *.ini files, therefore the character "=" is not allowed in keys or values written to a configuration map. Keys themselves may have a complex, pathlike structure. See [ConfigurationItem.descriptor](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Class-Reference#class-method-descriptorrest-values) for reference.

#### *newConfiguration()* 
Returns a new empty configuration map. The configuration map is not derived from a public class and may be accessed only through the functions given below. 

#### *getConfigurationValue(configuration :: ConfigurationMap, section :: String, key :: String, default := false)*
Returns the value defined for the given key or the *default*, if no such key has been defined.

#### *setConfigurationValue(configuration :: ConfigurationMap, section :: String, key :: String, value)*
Stores the given value for the given key in the configuration map. The value must be convertible to a String representation.

#### *getConfigurationSectionValues(configuration :: ConfigurationMap, section :: String, default := false)*
Retrieves all key / value pairs for a given section as a map. Returns *default*, if the section does not exist.

#### *setConfigurationValues(configuration, otherConfiguration)*
This function takes all key / value pairs from all sections in *otherConfiguration* and copies them to *configuration*.

#### *setConfigurationSectionValues(configuration :: ConfigurationMap, section :: String, values :: Object)*
Stores all the key / value pairs in the configuration map under the given section.

#### *removeConfigurationValue(configuration :: ConfigurationMao, section :: String, key :: String)*
Removes the given key and its value from the configuration map.

#### *removeConfigurationSection(configuration :: ConfigurationMao, section :: String)*
Removes the given section including all keys and values from the configuration map.

#### *readConfiguration(configFile :: String)*
Reads a configuration map from an *.ini file. The Strings "true" and "false" will he converted to the literal values *true* and *false* when encountered as values in the configuration file. If *configFile* denotes an absolute path, this path will be used. Otherwise, the file will be looked up in the *kUserConfigDirectory* and in *kConfigDirectory* (see the [constants documentation](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Constants-Reference#installation-paths-constantsahk) for reference), in that order.

#### *parseConfiguration(text :: String)*
Simular to *readConfiguration*, but reads the configuration from a string instead of a file.

#### *writeConfiguration(configFile :: String, configuration :: ConfigurationMap)*
Stores a configuration map in the given file. All previous content of the file will be overwritten. The literal values *true* and *false* will be converted to "true" and "false", before being written to the configuration file. If *configFile* denotes an absolute path, the configuration will be saved in this file. Otherwise it will be saved relative to *kUserConfigDirectory* (see the [constants documentation](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Constants-Reference#installation-paths-constantsahk) for reference).

#### *printConfiguration(configuration :: ConfigurationMap)*
Simular to *writeConfiguration*, but returns the textual configuration as a string.

#### *getControllerState()*
This function returns a representation of the file *Simulator Controller.status* which is located in the *Simulator Controller\Config* folder, which is located in your users *Documents* folder. The configuration object consists of information about the configured plugins and simulation applications and the available modes provided by the Simulator Controller as well as a lot of information about the internal status of all components. This file is created by the *Simulator Controller.exe* application and is updated periodically. Note: This function is actually not part of the *Configuration* library, but is referenced here for completeness.

***

## Localization & Translation ([Localization.ahk](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Sources/Framework/Localization.ahk))
A simple translation support is built into Simulator Controller. Every text, that appears in the different screens and system messages may translated to a different language than standard English. To support this, a single tranlation file (see the [translation file](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Resources/Templates/Translations.de) for German for an example) must exist for each target language in one of the *Simulator Controller\Translations* folder in you user *Documents* folder.

#### *availableLanguages()*
Returns a map, where the key defines the [ISO language code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) and the value the language name (example: *{en: English, de: Deutsch}*. The map is populated with all available translations.

#### *readTranslations(languageCode :: String)*
Returns a translation map for the given [ISO language code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes). Keys are the original texts in English with the translated texts as their values. Normally, it is much more convinient to use the *translate* function below.

#### *writeTranslations(languageCode :: String, languageName :: String, translations :: Map)*
Saves a translation map for the given [ISO language code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) and language name. The format of the *translations* map must be according to the description in *readTranslations*. The translation map is stored in the *Simulator Controller\Translations* folder in your user *Documents* folder in a file named "Translations.LC", where LC is the given ISO language code.

#### *setLanguage(languageCode :: String)*
The [ISO language code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) for the target language, for example "de" for German.

#### *getLanguage()*
Returns the [ISO language code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) for the active language.

#### *translate(string :: String)*
*string* is a text in English. *translate* reads the translations for the current target language and returns the translated text, or *string* itself, if no translation can be found.

#### *registerLocalizationCallback(callback :: Function)*
Registers a callback, which will be invoked, whenever a part of the localization is changed. A map is passed to this function which contains information about the changes. It contains one or more of the following key / value pairs:

	*Language:* languageCode

#### *getUnit(type :: OneOf("Temperature", "Pressure", "Mass", "Volume", "Length", "Speed"), translate :: Boolean := false)*
Returns the currently selected unit name for the given *type*, or, if you have passed *true* for the optional parameter *translate*, a translation for the unit name, which can be used as a field label.

#### *getFloatSeparator()*
Returns either "." or "," depending on the selected number format.

#### *convertUnit(type :: OneOf("Temperature", "Pressure", "Mass", "Volume", "Length", "Speed"), value :: Number, display :: Boolean := true, round :: Boolean := true)*
Converts between internal representation of a given unit and its external value to be used in the user interface. With *display*, you control the direction of the conversion and with *round* you can specify whether the resulting value should be rounded to the *natural* length of the given unit.

#### *getFormat(type :: OneOf("Float", "Time"))*
Returns the currently active display format for the given format type, which is one of "#.##" or "#,##" for numbers or one of "[H:]M:S.##" or "[H:]M:S,##" for time values.

#### *setFormat(type :: OneOf("Float", "Time"), format :: String)*
Sets the display format for the given format type. *format* must be one of "#.##" or "#,##" for numbers or one of "[H:]M:S.##" or "[H:]M:S,##" for time values.

#### *withFormat(type :: OneOf("Float", "Time"), format :: String, function :: TypeUnion(String, FuncObj), #rest params)*
Calls a given function with supplied parameters while the supplied format choice is active. *format* must be one of "#.##" or "#,##" for numbers or one of "[H:]M:S.##" or "[H:]M:S,##" for time values.

#### *displayValue(type :: OneOf("Float", "Time"), value :: Number, ...)*
Converts an internal value of the given *type* to its display representation, which is always a string. For floating point numbers, this might involve a change of the floating point character. For time values, which must be supplied as seconds with an optional fraction, the conversion might be even more complex. For floating point number you may supply the precision for an optional rounding step.

#### *internalValue(type :: OneOf("Float", "Time"), value :: String)*
Converts a display representation of the given *type* to its internal value, which is always a number.

#### *validNumber(value :: String, display :: Boolean := true)*
This function return *true*, if the given *value* in display representation represents a value number. If you pass *false* for the optional *display* parameter, value must be valid number in internal representation, a check which can also be conducted using elements of the programming language itself.

***

## GUI Tools ([GUI.ahk](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Sources/Framework/GUI.ahk))
Miscellaneous helper functions for GUI programming.

#### *moveByMouse(guiPrefix :: String, descriptor :: String := false)*
You can call this function from a click handler of a GUI element. It will move the underlying window by following the mouse cursor. *guiPrefix* must be the [prefix](https://www.autohotkey.com/docs/commands/Gui.htm#MultiWin) used, while creating the GUI elements using the AutoHotkey [*GUI Add, ...*](https://www.autohotkey.com/docs/commands/Gui.htm#Add) command. If *descriptor* is supplied, the resulting new position is stored in the configuration and can be retrieved using [getWindowPosition](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Functions-Reference#getwindowpositiondescriptor--string-byref-x--integer-byref-y--integer).

#### *getWindowPosition(descriptor :: String, ByRef x :: Integer, ByRef y :: Integer)*
Retrieves the position of a window identified by the given *descriptor*, once it has been moved by the user. If a position is known, *getWindowPosition* return *true* and *x* and *y* will be set.

#### *setButtonIcon(buttonHandle :: Handle, file :: String)*
Sets an icon for a button identified by *buttonHandle*, which must have been initialized with an HWND argument.

#### *translateMsgBoxButtons(buttonLabels :: Array)*
This function helps you to translate the button labels for standard dialogs like those of the AutoHotkey *MsgBox* command: A typical usage looks like this:

	OnMessage(0x44, Func("translateMsgBoxButtons").bind(["Yes", "No", "Never"]))
	title := translate("Modular Simulator Controller System")
	MsgBox 262179, %title%, % translate("The local configuration database needs an update. Do you want to run the update now?")
	OnMessage(0x44, "")

As you can see, this dialog will show three buttons which will be labeled "Yes", "No" and "Never" in the English language setting. *translateMsgBoxButtons* will call the *translate* function automatically for these labels, before they will be set as labels for the different buttons.

***

## Splash Screens ([Splash.ahk](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Sources/Framework/Splash.ahk))
Several applications of Simulator Controller uses a splash window to entertain the user while performing their operations. The splash screen shows different pictures or even an animation using a GIF. All required resources, that are part of the Simulator Controller distribution, are normally loacated in the *Resources/Splash Media* folder. An additional location for user supplied media exists in the *Simulator Controller\Splash Media* folder in the user *Documents* folder. The user can define several themes with rotating pictures or a GIF animation with the help of the [themes editor](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#themes-editor).

#### *showSplash(image :: String, alwaysOnTop :: Boolean := true)*
*showSplash* opens the splash screen showing a picture. *image* must either be a partial path for a JPG or GIF file relative to [kSplashMediaDirectory](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Constants-Reference#ksplashmediadirectory-kbuttonboximagesdirectory-kiconsdirectory), for example "Simulator Splash Images\ACC Splash.jpg", or a partial path relative to the *Simulator Controller\Splash Media* folder, which is located in the *Documents* folder of the current user, or an absolute path.

#### *rotateSplash(alwaysOnTop :: Boolean := true)*
Uses all JPG files available in [kSplashMediaDirectory](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Constants-Reference#ksplashmediadirectory-kbuttonboximagesdirectory-kiconsdirectory) and in the *Simulator Controller\Splash Media* folder, which is located in the *Documents* folder of the current user, as a kind of picture carousel. Every call to *rotateSplash* will show the next picture.

Important: This function is deprecated and will be removed in a future version of Simulator Controller. Use *showPlashTheme* instead.

#### *hideSplash()*
Closes the current splash window. Note: If the splash window had been opened using *showSplashTheme*, use *hideSplashTheme* instead.

#### *showSplashTheme(theme :: String, songHandler :: TypeUnion(String, FuncObj) := false, alwaysOnTop :: Boolean := true)*
Themes are a collection of pictures or a GIF animation possibly combined with a sound file. Themes are maintained by the [themes editor](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#themes-editor). *showSplashTheme* opens a splash window according to the themes definition. If *songHandler* is not provided, a default handler will be used, but the song will stop playing, if the current splash window is closed.

#### *hideSplashTheme()*
Closes the current theme based splash window.
 
***

## Progress Bar ([Progress.ahk](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Sources/Framework/Progress.ahk))
This module provides a simple to use, but customizeable progress bar, which can be positioned by the user.

#### *showProgress(options :: Map(X, Y, Width := 300, Title, Message, Color, Progress))*
Opens or updates a progress bar window. For the initial call, when the progress window is opened, the parameters *X* and *Y* must and *Width* may be supplied. The arguments for *Title*, *Messsage*, *Color* and *Progress* will be used in every call and will update those aspects of the progress bar window accordingly. The argument for the *Color* of the progress bar must be a HTML color name as described in the [Autohotkey documentation](https://www.autohotkey.com/docs/commands/Progress.htm#colors) and *Progress* must be an integer between 0 and 100. *showProgress* returns the name of the window to be used to own it by another window.

#### *hideProgress()*
Closes the currently open progress window.
 
***

## Message Box ([Message.ahk](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Sources/Framework/Message.ahk))
As an addition to the progress bar, you can use the message notification box to show short messages to the user, which will be shown for a specific number of millisecends and than will disappear automatically.

#### *showMessage(message :: String, title :: String := "Modular Simulator Controller System", icon :: String := "Information.png", duration :: Integer := 5000, x :: TypeUnion(String, Integer) := "Center", y :: TypeUnion(String, Integer) := "Bottom", width :: Integer := 400, height :: Integer := 100)*
Displays a message box on the main screen. *duration* defines the number of milliseconds, the message box will be shown. Beside giving normal screen coordinates for *x* and *y*, you can supply "Left", "Center" or "Right" for the horizontal and "Top", "Center" or "Bottom" for the vertical position.

***

## Tray Popups ([TrayMenu.ahk](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Sources/Framework/TrayMenu.ahk))
Tray messages or TrayTips are small popup windows in the lower right corner of the main screen used by applications or the Windows operating system to inform the user about an important event. Tray messages can be displayed by the Simulator Controller for almost every change in the controller state.

#### *trayMessage(title :: String, message :: String, duration :: Integer := false)*
Popups a tray message. If *duration* is supplied, it must be an integer defining the number of milliseconds, the popup will be visible. If not given, a default period may apply (see below).

#### *disableTrayMessages()*
Diasables all tray messages from now on. Every following call to *trayMessage* will have no effect.

#### *enableTrayMessages(duration :: Integer := 1500)*
(Re-)enables tray messages, if previously been disabled by *disableTrayMessages*. A default for the number of milliseconds the popups will be visible, may be supplied.

***

## Controller Actions
The functions in this section are a little bit special. Although they can be called from your code as well, they are meant to be used as [actions for controller functions](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#actions). Therefore, they will be configured for controller functions using the [configuration tool](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#configuration).

#### *setDebug(debug :: Boolean)*
Enables or disables debugging. *debug* must be either *true* or *false*. Note: This function is identical to the one described above in the [Debugging and Logging](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Functions-Reference#debugging-and-logging-debugahk) section.

#### *setLogLevel(logLevel :: OneOf("Debug", "Info", "Warn", "Critical", "Off"))*
Sets the log level. *logLevel* must be one of "Info", "Warn", "Critical" or "Off", where "Info" is the most verbose one. Note: This function is identical to the one described above in the [Debugging and Logging](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Functions-Reference#debugging-and-logging-debugahk) section.

#### *increaseLogLevel()*
Increases the log level, i.e. makes the log information more verbose. Note: This function is identical to the one described above in the [Debugging and Logging](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Functions-Reference#debugging-and-logging-debugahk) section.

#### *decreaseLogLevel()*
Decreases the log level, i.e. makes the log information less verbose. Note: This function is identical to the one described above in the [Debugging and Logging](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Functions-Reference#debugging-and-logging-debugahk) section.

#### *pushButton(number :: Integer)*
Virtually pushes the button with the given number.

#### *rotateDial(number :: Integer, direction :: OneOf("Increase", "Decrease"))*
Virtually rotates the rotary dial with the given number. *direction* must be one of "Increase" or "Decrease".

#### *switchToggle(type :: OneOf("1WayToggle", "2WayToggle"), number :: Integer, state :: OneOf("On", "Off"))*
Virtually switches the toggle switch with the given number. *state* must be one of "On" or "Off" for 2-way toggle switches and "On" for 1-way toggle switches. The type of the toggle switch must be passed as *type*, one of "1WayToggle" and "2WayToggle".

#### *setMode(mode :: String)*
Switches the currently active mode for the hardware controller. See the [plugin reference](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes) for an in depth explanation of all available modes.

#### *startSimulation(simulator :: String := false)*
Starts a simulation game. If the simulator name is not provided, the first one in the list of configured simulators on the *General* tab in the [configuration tool](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#configuration) is used.

#### *stopSimulation()*
Stops the currently running simulation game.

#### *shutdownSystem()*
Displays a dialog and asks, whether the PC should be shutdown. Use with caution.

#### *enablePedalVibration()*
Enables the pedal vibration motors, that might be mounted to your pedals. This action function is provided by the "Tactile Feedback" plugin and is available depending on the concrete configuration.

#### *disablePedalVibration()*
Disables the pedal vibration motors, that might be mounted to your pedals. This action function is provided by the "Tactile Feedback" plugin and is available depending on the concrete configuration.

#### *enableFrontChassisVibration()*
Enables the chassis vibration bass shakers that might be mounted to the front of your simulation rig. This action function is provided by the "Tactile Feedback" plugin and is available depending on the concrete configuration.

#### *disableFrontChassisVibration()*
Disables the chassis vibration bass shakers that might be mounted to the front of your simulation rig. This action function is provided by the "Tactile Feedback" plugin and is available depending on the concrete configuration.

#### *enableRearChassisVibration()*
Enables the chassis vibration bass shakers that might be mounted to the rear of your simulation rig. This action function is provided by the "Tactile Feedback" plugin and is available depending on the concrete configuration.

#### *disableRearChassisVibration()*
Disables the chassis vibration bass shakers that might be mounted to the rear of your simulation rig. This action function is provided by the "Tactile Feedback" plugin and is available depending on the concrete configuration.

#### *disableRearChassisVibration()*
Disables the chassis vibration bass shakers that might be mounted to the rear of your simulation rig. This action function is provided by the "Tactile Feedback" plugin and is available depending on the concrete configuration.

#### *startMotion()*
Starts the motion feedback system of your simulation rig. This action function is provided by the "Motion Feedback" plugin and is available depending on the concrete configuration.

#### *stopMotion()*
Stops the motion feedback system of your simulation rig and brings the rig back to its resting position. This action function is provided by the "Motion Feedback" plugin and is available depending on the concrete configuration.

#### *openPitstopMFD(descriptor :: false)*
Opens the pitstop settings dialog of the currently running simulator, if supported. If the given simulation supports more than one pitstop settings dialog, the optional parameter *descriptor* can be used to denote the specific dialog. For IRC this is either "Fuel" or "Tyres", with "Fuel" as the default. This action function is provided by the *SimulatorPlugin* class and is available depending on the concrete configuration and simulation.

#### *closePitstopMFD()*
Closes the pitstop settings dialog of the currently running simulator, if supported. This action function is provided by the *SimulatorPlugin* class and is available depending on the concrete configuration and simulation.

#### *changePitstopOption(option :: String, selection :: String, increments :: Integer := false)*
Enables or disables one of the activities carried out by your pitstop crew.  The supported options depend on the current simlation game. For example, for ACC the available options are "Change Tyres", "Change Brakes", "Repair Bodywork" and "Repair Suspension", for R3E "Change Tyres", "Repair Bodywork" and "Repair Suspension", for RF2 "Repair", and for IRC "Change Tyres" and "Repair". *selection* must be either "Next" / "Increase" or "Previous" / "Decrease". For stepped options, you can supply the number of increment steps by supplying a value for *increments*. This action function is provided by the *SimulatorPlugin* class and is available depending on the concrete configuration and simulation.

#### *changePitstopStrategy(selection :: String)*
Selects one of the pitstop strategies. *selection* must be either "Next" or "Previous". This action function is provided by the *SimulatorPlugin* class and is available depending on the concrete configuration and simulation.

#### *changePitstopFuelAmount(direction :: String, liters :: Integer := 5)*
Changes the amount of fuel to add during the next pitstop. *direction* must be either "Increase" or "Decrease" and *liters* may define the amount of fuel to be changed in one step. This parameter has a default of 5. This action function is provided by the *SimulatorPlugin* class and is available depending on the concrete configuration and simulation.

#### *changePitstopTyreSet(selection :: String)*
Selects the tyre sez to change to during  the next pitstop. *selection* must be either "Next" or "Previous". This action function is provided by the *SimulatorPlugin* class and is available depending on the concrete configuration and simulation.

#### *changePitstopTyreCompound(selection :: String)*
Selects the tyre compound to change to during  the next pitstop. *selection* must be either "Next" / "Increase" or "Previous" / "Decrease". This action function is provided by the *SimulatorPlugin* class and is available depending on the concrete configuration and simulation.

#### *changePitstopTyrePressure(tyre :: String, direction :: String, increments :: Integer := 1)*
Changes the tyre pressure during the next pitstop. *tyre* must be one of "All Around", "Front Left", "Front Right", "Rear Left" and "Rear Right", and *direction* must be either "Increase" or "Decrease". *increments* with a default of 1 define the change in 0.1 psi increments. This action function is provided by the *SimulatorPlugin* class and is available depending on the concrete configuration and simulation.

#### *changePitstopBrakeType(brake :: String, selection :: String)*
Selects the brake pad compound to change to during the next pitstop. *brake* must be "Front Brake" or "Rear Brake" and *selection* must be "Next" or "Previous". This action function is provided by the *SimulatorPlugin* class and is available depending on the concrete configuration and simulation.

#### *changePitstopDriver(selection :: String)*
Selects the driver to take the car during the next pitstop. *selection* must be either "Next" or "Previous". This action function is provided by the *SimulatorPlugin* class and is available depending on the concrete configuration and simulation.

#### *planPitstop()*
*planPitstop* triggers Jona, the Virtual Race Engineer, to plan a pitstop. This action function is provided by the "Race Engineer" plugin and is available depending on the concrete configuration.

#### *preparePitstop()*
*preparePitstop* triggers Jona, the Virtual Race Engineer, to prepare a previously planned pitstop. This action function is provided by the "Race Engineer" plugin and is available depending on the concrete configuration.

#### *openRaceSettings(import :: Boolean := false)*
Opens the settings tool, with which you can edit all the race specific settings, Jona needs for a given race. This action function is provided by the "Race Engineer" plugin and is available depending on the concrete configuration. If you supply *true* for the *import* parameter, the setup data is imported directly from a running simulation and the dialog is not opened.

#### *openSetupAdvisor()*
Opens the tool which helps you creating a suspension setup for a car. This action function is provided by the "Race Engineer" plugin and is available depending on the concrete configuration.

#### *openSessionDatabase()*
Opens the tool for the session database, with which you can get the tyre pressures for a given session depending on the current environmental conditions. If a simulation is currently running, most of the query arguments will already be prefilled. This action function is provided by the "Race Engineer" and "Race Strategis" plugins and is available depending on the concrete configuration.

#### *openStrategyWorkbench()*
Opens the "Strategy Workbench" tool, with which you can explore the telemetrie data for past session, as long as they have been saved by the Race Strategist, and with which you can create a strategy for an upcoming race. If a simulation is currently running, several selections (car, track, and so on) will already be prefilled.

#### *openRaceCenter()*
Opens the "Race Center" tool, with which you can analyze the telemetry data of a running team session, plan and control pitstops and change race strategy on the fly.

#### execute(command :: String)*
Execute any command, which can be an executable or a script with an extension accepted by the system. The *command* string can name additional arguments for parameters accepted by the command, and you can use global variables enclosed in percent signs, like %ComSpec%.

#### *hotkey(hotkeys :: String, method :: String := "Event")*
This function can be used to send keyboard commands to a simulator, for example. Each keyboard command is a [keyboard command hotkey](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#hotkeys). The vertical bar separates between the individual commands, if there are more than one command. The optional argument for method specifies the communication method to send the keyboard commands. These are named "Event", Input", "Play", "Raw" and "Default".