Using Simulator Controller is quite easy. The most difficult part will be the configuration, but fortunately, this has to be done only once. Please see the extensive [Installation & Configuration](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration) guide for more information about this task.

Once you have configured everything for your simulation rig, there are two applications, which you will use while having fun with your simulations. Both applications are located in the *Binaries* folder. Normally, you will run *Simlator Startup.exe* to set the stage for everything. Depending on your choices during your initial installation, you will find a link to this program on your desktop and/or the Windows Start menu. Using the [configuration tool](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#configuration) you can also decide, whether *Simulator Startup* will be run automatically whenever your PC is started. When you run *Simlator Startup.exe*, you will see the following window:

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Launch%20Pad.JPG)

This window will give you access to all applications of Simulator Controller. You will get some information about a given application, when you hover with the mouse above the icon. Beside starting any of the applications and tools of Simulator Controller, you can continue the startup process of all the components you need, when running a simulation, by clicking on the top left icon. Depending on your concrete configuration, *Simulator Startup* will then start all the configured component applications including *Simulator Controller.exe*, which will be responsible for the essential part, the control of all your simulation applications and simulator games using your hardware controller. Put a check mark in the check box in the lower left corner, when you want the launch window to be closed automatically, when you enter your simulation.

The two applications on the right side of the launch pad are a little bit special. With the top icon, you can run the [monitoring dashboard](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Using-Simulator-Controller#monitoring-health-and-activities) which will normally be configured in the [settings](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Using-Simulator-Controller#customizing-startup-configuration) to start automatically, when starting the simulation. The icon below lets you start the update process, which checks whether a newer version of Simulator Controller is available and installs it for you. This check is done automatically once per day, so under normal circumstances there is no need to trigger it manually.

If you want to download and install a new version of Simulator Controller, it is important that none of the applications of the suite is running during the update. Please use the button "Close All..." in the lower right corner just before running the update.

Note: If you don't want to use the launch window and want *Simulator Startup* to run through, create a shortcut and add the option "-NoLaunchPad" to the *Target* field. When you use this shortcut file, no launch window will be shown, unless you hold down the Shift key, while running *Simulator Startup*. The other way around can also be used: If you press the Shift key while running *Simulator Startup* normally, no launch window will be shown and the startup process will run directly.

## Startup Process & Settings

Before starting up, *Simulator Startup* checks the configuration information. If there is no valid configuration, a tool to edit the settings and supply a valid configuration will be launched automatically. You can trigger this anytime later by holding down the Control key when clicking on the Startup icon in *Simulator Startup*. The following settings dialog will show up:

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Settings%20Editor.JPG)

With this editor, which can also be opened by clicking on the small button with the cog wheel icon in the upper right corner of the window of *Simulator Startup*, you can change the runtime settings for Simulator Controller. In contrast to the general configuration, which configures all required and optional components of your simulation rig, you decide here which of them you want to use for the next run and onward and how they should behave. Please note, that you can click on the blue label of the dialog title, which will open this documentation in your browser.

Beside maintaining this startup settings, you can jump to the [configuration tool](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#configuration) by clicking on the button "Configuration...". This might be helpful, if you detect an error in your simulation rig configuration or if you want to add a new simulation game, you just installed on your PC.

### Customizing Startup Configuration

In the first group, you can decide which of the core applications configured in the [Applications tab](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#tab-applications) of the configuration tool should be started during the startup process. Normally you want to start all of them, after all they are core applications, right? A special case might be the ["System Monitor"](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Using-Simulator-Controller#monitoring-health-and-activities), which gives you a great overview of the health state and the activities of all system components, but it needs some screen space and can therefore only be used during a simulation, if you have a second monitor in your setup.

The second group lets you decide whether to start the different feedback components of your simulation rig. In the configuration, that is part of the standard distribution of Simulator Controller, feedback is handled by the ["Tactile Feedback"](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-tactile-feedback) and ["Motion Feedback"](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-motion-feedback) plugins, which on their side will use the [SimHub](https://www.simhubdash.com/) and [SimFeedback](https://www.opensfx.com/) applications to implement their functionalities. These two applications may be started in advance during the startup process, but they also can be started later from your hardware controller. Me, myself and I, for example, almost always start *SimHub* in advance, since I will always use vibration effects to get a better understanding about what my tyres are doing, but I will start motion feedback later depending on the track and the kind of driving, I am in (training, racing, having fun with friends, and so on).

### Customizing Controller Notifications

In the next group, you can decide, how Simulator Controller will notify you about state changes in your simulation rig or in the applications under control of Simulator Controller. Two types of notifications are supported, for Tray Tips (small message windows popping up in lower right corner of your main screen) and for Button Boxes, the visual representation of your controller hardware. Depending on the situation you are in (in simulation game or not), you might want to use different notifications or no notifications at all. You can configure, how long in milliseconds the Tray Tip or the Button Box windows will stay open. For the Button Boxes, a duration of 9999 ms will be interpreted as *forever*, so the window will be kept open all the time. Also, you can decide where the Button Boxes will appear. To do that, choose one of the corners of your main screen in the dropdown list below the notification duration input fields.

Some applications of Simulator Controller show you the progress of long-running tasks with a progress bar or popup some information windows as overlays in the foreground. You can choose the position where the overlays appear on your screen in the correspondinig dropdown list. If you are using a hardware dashboard, which hides the lower part of your screen, you can choose the "Top" position, for example.

### Configuration of the Controller Mode automation

If you click on then button "Controller Automation...", a new dialog will open up, where you can select predefined Modes for your connected hardware controller.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Automation%20Editor.JPG)

You can choose the context with the first two dropdown menus, for example 1. when no simulation is running or 2. when you are in a given simulator and there in a practice session. Then you select the *Modes* (see the documentation for [Plugins & Modes](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes) for more information), which will be automatically activated for this context. Please note, that more than one mode will only make sense, if you have more than one hardware controller connected, and when each mode only use one of these hardware controllers exclusively.

### Theme and Splash Screen configuration

In the lower part of the settings dialog, you can choose one of the color schemes to be used for all applications and you can select one of the [splash screens](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#splash-screen-editor), which will be used for your entertainment during the startup process. Please see the [installation guide](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#using-your-own-pictures-videos-and-sounds-for-all-the-splash-screens) on how to install your own media files in a special location in your *Documents* folder and hot to use the splash screen editor. If you decide to play a song while starting your Simulator Controller applications and even your favorite simulation game, the song will keep playing until you press the left mouse button or the Escape key, even if *Simulator Startup* has exited already.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Splash%20Screen.JPG)

Last, but not least, you can choose a simulation game from your list of Simulators and start it automatically, after all other startup tasks have finished.

### More Settings & Configurations

Here is an overview for the all settings and configuration options for the various parts of Simulator Controller:

  1. *Simulator Settings*
  
     Maintained by the "Simulator Startup" application and is stored in the *Simulator Settings.ini* file in the *Simulator Controller\Config* folder in your user *Documents* folder. As described [above](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Using-Simulator-Controller#startup-process--settings), these settings influence the startup process of Simulator Controller and where on your screen the visual representations of your Button Boxes will appear.

  2. *Simulator Configuration*
  
     Maintained by the "Simulator Configuration" and the more simple "Simulator Setup" applications and stored in *Simulator Configuration.ini*, *Button Box Configuration.ini* and *Stream Deck Configuration.ini* files in the *Simulator Controller\Config* folder in your user *Documents* folder. This configuration contains the complete configuration of all your hardware and software with regards to Simulator Controller. Typically this will be very static, once you have found a satisfying configuration, at least, until you add another piece of hardware or new software. See the documentation for the [configuration tool](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#configuration) for more information.

  3. *Race (Assistant) Settings*
  
     Maintained by the "Race Settings" and "Session Database" applications and stored in the *Race.settings* file in the *Simulator Controller\Config* folder in your user *Documents* folder. Whenever you start a race (or even a training session), the Virtual Race Assistants will use these settings to control various functionality, for example, how to react to damages, when to change tyres after a severe weather change, and so on. You can edit these settings with the "Race Settings" application just before each session, or you can manage a lot of the setting values by using the "Session Database" application and store default values depending on a given car / track / weather combination. See the [corresponding documentation](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#race-settings) for more information.

## Using Simulator Controller

After closing the configuration dialog, the actual startup process begins. Normally, you will be greeted by a splash screen and will see a pogress bar which informs you about what the system is currently doing. If you decide to stop the startup process, you can do this by pressing Escape anytime. If you decide that you want to start your favorite simulation (the first one in the Simulators list (see the [General tab](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#tab-general) in the configuration tool) after the startup process has finished, you can do this by holding down the Control key during the startup process, even if you haven't checked the startup option in the configuration dialog above.

After the startup process has completed, the splash screen of *Simulator Startup* may stay open still playing a video or showing pictures, unless a simulation has been started as well. You can close it anytime by pressing Escape or it will disappear automatically, when a simulator starts up. But the background process *Simulator Controller.exe* including all the configured [plugins](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes) will keep running and now is in complete control of your simulation rig. Depending on your configuration, you will see the visual representation of your controller hardware, i.e. a Button Box.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Button%20Box%201.JPG)

Normally, the active mode on your hardware controller will be the "Launch" mode, so that you can launch additional applications by the touch of a button. For a complete documentation on everything available in the "Simulator Controller" application, please consult the documentation about [Plugins & Modes](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes).

Normally, it is not necessary to close *Simulator Controller.exe*, since it is very efficient and does not use many system resources. But if necessary, you can locate its icon, a small orange cog wheel, in the System Tray (at the lower right side of the Windows taskbar), right click the icon and choose Exit.

### Enabling and disabling features

Simulataor Controller is a modular software and consists of many functions, which can be enabled or disabled during runtime. Beside using buttons on your hardware controller to enable or disable these functions, for example the connection to the Team Server or whether Track Automations will be active during the current session, you can also control most of them from the tray menu of the "Simulator Controller" application. Please don't touch the options in the "Support" submenu, unless told you so when tracking down problems.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Simulator%20Controller%20Menu.JPG)

### Voice Commands

The Simulator Controller framework supports a sophisticated natural language interface. This capability is used by the Race Assistants Jona and Cato, thereby allowing a fully voice enabled dialog between you and these Assistants, but the voice recognition can also be used to control parts of your controller hardware by voice commands.

With the introduction of a new Race Assistant in Release 3.1 there are now several different *communication partners* and it is very important that the system understands, to whom you are talking. Therefore an activatiom command, very simular to other digital Assistants like Alexa or Cortana, has been introduced. For the Assistants Jona and Cato this is the call phrase "Hey %name%", where %name% is the configured name of the Assistant. For example, if you say "Hi Jona" or "Jona, can you hear me?" for example (as long as you sticked to the preconfigured name "Jona"), the Virtual Race Engineer will start to listen to the following commands. Jona will give you a short answer, so you know that the activation was successful. Beside this activation, the dedicated listen mode will also be activated, when any of the Assistants has asked you a question and is waiting for the answer. The listen mode of the Simulator Controller itself, which allows you to trigger [controller actions](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#tab-controller) by voice, must be activated by an activation command as well, if you have more than one dialog partner active. This activation command can be configured in the [voice control tab of the configuration tool](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#tab-voice-control). When this activation command is recognized, you will hear a short chime tone as confirmation and the system is ready to activate controller actions by voice. Please note, that you also hear a different short tone, when you have pressed the [Push To Talk](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#tab-voice-control) control in order to tell you, that you can issue your voice command.

Important: In order to reduce confusion of an activation command with a normal command given to the currently active *dialog partner*, the [Push To Talk](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#tab-voice-control) control has two different behaviours. If you simply press the configured control, for example a button on your steering wheel, you will talk to the currently active *dialog partner*. Whenever you press the control twice like double clicking a mouse button, you will activate a special listener, which only accepts the activation phrases. The last button press of the *double press* must be held down as long as you speak.

#### Push-To-Talk Behaviour

Beside the behaviour of the Push-To-Talk button described above, where you need to hold down the button as long as your are talking, there is an alternative mode available. This mode allows you to release the button while you are talking. Once, you have finished your voice command, you press the Push-2-Talk button again, to indicate that you have finished and that the command should be executed. This alternative mode can be activated either by choosing the corresponding preset in "Simulator Setup" or by copying the file "P2T Configuration.ini" from the *Resources\Templates* directory from the program folder to the *Simulator Controller\Config* directory which resides in your user *Documents* folder.

Please don't forget to press the Push-To-Talk button at the end of your speech, even, if the command had already been recognized, because you made a long pause. If you don't push the button, the sequence will get out of sync and you will end up being very confused.

#### Testing voice configuration and voice commands

*After* you have finished all the required [installation and configuration](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration) steps (especially for the [voice support](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#installation) of the Assistants), you can test the dialog with two different Assistants. To do this, please open a Windows command shell (type Windows-R => cmd => Return), go to the *Binaries* folder of the Simulator Controller distribution and enter the following commands (or go the the *Utilities* folder in the installation folder and double-click the file "Voice Test.bat"):

	D:\Controller\Binaries>"Voice Server.exe" -Debug true

	D:\Controller\Binaries>"Race Engineer.exe" -Debug true -Speaker true -Listener true -Language DE -Name Jona -Logo true

	D:\Controller\Binaries>"Race Strategist.exe" -Debug true -Speaker true -Listener true -language EN -Name Cato -Logo true
	
Both, the Virtual Race Engineer and the Virtual Race Strategist will start up and will listen to your commands (Jona will be a german personality, while Cato will use English to talk with you). Please note, that if you configured [Push To Talk](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#tab-voice-control) in the configuration, you need to hold the respective button, while talking. Since no simulation will be running during your test, the functionality of Jona und Cato will be quite restricted, but you may switch between those Assistants using the activation phrase and you may ask some questions like "Is rain ahead?" or "Wird es regnen?". You may also start the Virtual Race Spotter here, but this will be of no big use, since the Spotter does not answer many questions.

Note: If there is only *one* dialog partner configured, this will be activated for listen mode by default. In this situation, no activation command is necesssary.

Beside the *builtin* voice recognition capabilities, you can still use specialized external voice recognition appplications like [VoiceMacro](http://www.voicemacro.net/) as an external event source for controller actions, since these specialized applications might have a better recognition quality in some cases.

#### Jona, the Virtual Race Engineer

Release 2.1 introduced Jona, an artificial Race Engineer as an optional component of the Simulator Controller package. Since Jona is quite a complex piece of software with its natural language interface, it is fully covered in a separate [documentation chapter](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer).

#### Cato, the Virtual Race Strategist

Using the technology developed for Jona, Release 3.1 introduced an additional Race Assitant. This Assistant is named Cato and is a kind of Race Strategy Expert. It is also fully covered in a separate [documentation chapter](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Strategist).

#### Elisa, the Virtual Race Spotter

The third Assistant, Elisa, is not so much of a dialog partner, but gives you crucial information about the traffic, your opponents and the current race situation. See the separate [documentation chapter](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Strategist) for more information.

### Controller Commands

If you have configured one or more hardware controllers (Button Boxes, Stream Decks or even your steering wheel), you will have the possibility to trigger almost all commands for the Virtual Race Assistants and other functionalities of Simulator Controller with your hardware. Sometimes it will be much more convinient (and faster) to tell Jona to plan the upcoming pitstop with a simple press of a button. You will find a complete overview and instructions on how to configure all those controller actions in the documentation about [Plugins & Modes](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes) or you can use "Simulator Setup", which provides a graphical point and click environment to configure controller actions.

Please note, that you can mix voice commands and commands triggered by the controller hardware freely, so choose your weapon depending on the current situation on the track.

### External Commands

There is also the possibility to trigger actions in Simulator Controller from other applications. There are several ways to do this, but the most easy ones are:

1. Keyboard commands

   As you have seen in the chapter about [Installation & Configuration](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration), every action or command in Simulator Controller can be activated from any hardware controller like Button Boxes, Stream Decks or your steering wheel, but you can also define keyboard shortcuts, called Hotkeys, to achieve the same effect. These keyboard shortcuts can be triggered not only from the keyboard, but also from other applications, as long as they are able to send events to other applications.

2. Command scripts

   Not every application can easily send keyboard commands to other applications, for example Windows .BAT or .CMD scripts. A second method exists therefore, that uses a script file as an interface. You can create a file named "Controller.cmd" in the *Simulator Controller\Temp* folder which resides in your user *Documents* folder. This file is checked every 100 ms, and if it is not empty, it will be processed and afterwards deleted. Here is in example for a "Controller.cmd":
   
	2WayToggle.1 On
	Button.1
	Button.2
	Dial.4 Decrease
	
   This will achieve the same effect as pushing or rotating the corresponding controls on your hardware controller. See the [corresponding documentation](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#tab-controller) to see which controller functions (*1WayToggle*, *2WayToggle*, *Button*, *Dial* and *Custom*) are available and especially how to define *Custom* controller functions (which are typically not assiciated with a Button Box or a Stream Deck) using the [configuration tool](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#configuration). As you have seen in the above example, you must use *On* and *Off* as a second argument for *2WayToggle*, and *Increase* and *Decrease* for *Dial*, to specify the desired change.

   A last note for experienced users: Together with the [*execute* controller action function](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#tab-controller), you can create powerful macros. Create a *Custom* controller function, which can be triggered by a button, for example on your steering wheel. This *Custom* function *executes* a Windows command script wich the writes a "Controller.cmd" file as described above.

### Audio Routing

Simulator Controller allows you to direct voice output to different audio devices, as long as the additional software [SoX](http://sox.sourceforge.net/) is installed and configured. This is mainly of interest to those of you, who are streaming their races, or when you want maximum immersion by directing car sound to a 5.1 sound system, but the assistant voices to your headphone. Since this if not of widespread use, there is no user interface to configure this, but a simple text file. If you want to configure your audio routing, create a text file with the name "Audio Settings.ini" and place it in the *Config* folder which is located in your user *Documents* folder. Open it with a text editor and enter the following content:

	[Output]
	Race Spotter.AudioDevice=Headphone
	Race Engineer.AudioDevice=Headphone
	Race Strategist.AudioDevice=Headphone

*Headphone* is only an example for any configured audio device which is named "Headphone" in the standard Windows settings. You only have to enter those lines, where you want to configure a non-default audio device, if not present the currently selected default audio device will be used.

As you might expect, you can configure voice input as well. There are some additional things to consider, though, as you can see in the example below.

	[Input]
	Default.AudioDevice=Streaming
	Activation.AudioDevice=Headphone
	Race Spotter.AudioDevice=Headphone
	Race Engineer.AudioDevice=Headphone
	Race Strategist.AudioDevice=Headphone
	Controller.AudioDevice=Headphone

First you have to identify the default audio input device, which should be active whenever no voice input is captured by Simulator Controller (i.e. the Push-To-Talk button is not activated). This may be important, when you are using different microphones, for example, because you are streaming your race on a video platform. In the example above, this microphone device is named "Streaming". This setting must be identical to that you have chosen in the Windows settings, otherwise you won't get the desired results.

After defining the default input device, you can configure the voice input devices for all Simulator Controller dialog partners, first and foremost the Race Assistants. A special listener is the *Activation* object, which listens to the activation phrases, as you might expect. Typically you will use here the same input device here, you use to talk to the Assistants. Additionally, if you are using voice commands to trigger actions in Simulator Controller, for example switching between track automations, you can also set the input audio device for the *Controller* object as well.
 
Similar to the output settings shown above, you only have to enter those audio devices, which differ from the default audio device. Please note, that changing the input audio device is only supported when the additional software [NirCmd](https://www.nirsoft.net/utils/nircmd.html) is installed and configured.

## Keyboard shortcuts & modifiers

Many applications of Simulator Controller provide modifier keys for several functions. You can find a list of all modifiers and their functionalities [here](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Keyboard-Modifiers).
   
## Monitoring health and activities

Simulator Controller is a complex system with lots of different processes and even uses cloud-based servers when you are using the [Team Server](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Team-Server). In such a complex system, lots of things can go wrong and it is therefore important to understand the internal state and activities of all parts of the system. This is, where the "System Monitor" comes into play.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/System%20Monitor%201.JPG)

This tool, which either can be startet on demand by using the launch pad described above or automatically whenever you enter a simulation with Simualtor Controller (check "System Monitor" in the *Core* section of the settings as described above), provides you complete information about all the components of Simulator Controller. In order to give you a quick graphical clue, "System Monitor" uses color-coded traffic lights for each component and process.

| Color                                                                                           | Meaning                                                                                                                              |
| ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| ![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Resources/Icons/Black.png)  | Not started currently. An example is the current simulation, if no simulation game is currently running.                             |
| ![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Resources/Icons/Gray.png)   | Started, but waiting to become active. For example, you have started the game but you are in the main menus.                             |
| ![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Resources/Icons/Green.png)  | Component is up and running. No known operation problems.                                                                              |
| ![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Resources/Icons/Yellow.png) | Component is up, but no normal operation is possible. Example: The Race Assistants have a cool down time after the end of a session. |
| ![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Resources/Icons/Red.png)    | Somthing is wrong and might need your attention. Example: The connection to the Team Server cannot be established.                   |

The "System Monitor" is divided into several pages of information:

  1. Dashboard
  
     This page gives an overview over the most important functions and background processes. You can see, when a running simulation has been detected, whether the Race Assistants are active, whether the connection to the Team Server has been sucessfully established and so on. The *traffic lights* will show you the health state at a glance using the color coding described above and a couple of important detail informations will be provided as well.
	 
	 ![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/System%20Monitor%202.JPG)

  2. Session
  
     On this page you will find important information about the currently running session, be it the remaining stint time and remaining laps or the tyre temperatures, and so on.
	 
	 ![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/System%20Monitor%206.JPG)
	 
	 The following information components are available:
	 
	 - Session
	 
	   Shows you information about the car, track and session mode. Not so important.
	   
	 - Duration
	 
	   Gives information about session length, remaining session, stint and driver time, and so on.
	   
	 - Conditions
	 
	   Shows the current weather and temperatures as well as an outlook for the next 30 minutes.
	   
	 - Stint
	 
	   Information about the current driver, the position, the current lap, lap times and the number of laps driven in this stint so far.
	   
	 - Fuel
	 
	   Detailed information about fuel consumption, remaining fuel and remaining possible laps.
	   
	 - Tyres
	 
	   Shows the current pressures and tyre temperatures, and tyre wear, if available.
	   
	 - Brakes
	 
	   Shows the current brake temperatures, and brake wear, if available.
	   
	 - Standings
	 
	   Gives you detailed information about your most important opponents, the leader, the car in front of you and the car behind you. For each opponent, the number of laps, the gap in seconds and the lap time is shown.
	   
	 - Strategy
	 
	   This component give you a summary about the active strategy, if any. Most important is the summary about the next pending pitstop.
	 
	 - Pitstop
	 
	   When an upcoming pitstop has been planned, this component will show you all relevant settings like fuel amount, tyre compound and pressures, as well as selected repairs.
	 
	 In most cases, redundant information is suppressed. For example, if the remaining session, stint and driver time are identical, only the remaining time is shown.
	 
	 The components, that will be shown, as well as the update frequency of the information can be configured by clicking on the settings button in the upper right corner of the "System Monitor" window.

	 ![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/System%20Monitor%207.JPG)

  3. Team
  
     Since it is such an important part of the operation in team events, the connection to the Team Server has its own page of information. Beside monitoring your own connection to the Team Server you will see which other drivers are currently successfully connected to the Team Server and who is currently driving the car. You will also be warned if there is a mismatch in driver names, since driver name match is a very important aspect of the operation of the Team Server.
	 
	 ![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/System%20Monitor%204.JPG)

  4. Modules
  
     A more detailed view than the Dashboard, since a list of **all** components of Simulator Controller and their current health state will be shown here. In the "Information" column, you will get a short summary of the current state of operation, but you will also see detailed error messages here, when a component is in a critical state.
	 
	 ![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/System%20Monitor%203.JPG)

  5. Logs
  
     Provides a very low level view into the operation of Simulator Controller. All applications write log information, especially when errors or other unexpected situations occur. The recent log entries of all applications will be displayed here in this list. You can switch between log levels for all currently running applications with the dropdown menu in the lower right corner, but be aware that chossing "Info" might slow down the applications significantly. So use this only when tracking down problems. 
	 
	 ![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/System%20Monitor%205.JPG)

Final note: The information provided by "System Monitor" is asynchronous by nature, in order to not interfere with some time critical operations of other parts of the system. Therefore it can take a couple of seconds before problem will be visible. If you loose the connection to the Team Server, for example, it might not become evident, when no requests against against the Server are currently being issued. Also it is possible that state information is not updated anymore, when central backgroud processes, first and formost "Simulator Controller.exe" have been terminated manually.

## And now it's time

...to have some fun. If you like Simulator Controller and find it useful, I would be very happy about a small donation, which will help in the further development of this software. Please see the [README](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/README.md) for the donation link. Thanks and see you on the track...
