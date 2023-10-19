## Introduction

Welcome to Jona, the world first fully interactive and AI-based Virtual Race Engineer for race car simulations.

Ok, enough marketing bullshit. Jona is a voice chat bot with a special knowledge about racing. It uses the telemetry data provided by a simulation game and a large domain specific rule set to derive its knowledge from there. Using this knowledge, Jona can give you information about the current state of your car (temperatures, pressures, remaining laps, upcoming pitstops, and so on), and can recommend settings for the next pitstop. Currently, Jona supports the *Assetto Corsa*, *Assetto Corsa Competizione*, *RaceRoom Racing Experience*, *rFactor 2*, *iRacing*, *Automobilista 2* and *Project CARS 2* simulation games through their respective plugins. Using the Pitstop MFD handling for *Assetto Corsa Competizione* introduced with [Release 2.0](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Update-Notes#release-20), Jona is even capable to setup a pitstop without user interaction completely on its own. Step by step, this will be made available for all simulations, where this is possible (currently *Assetto Corsa*, *Assetto Corsa Competizione*, *rFactor 2*, *RaceRoom Racing Experience* and *iRacing* are supported, although the support for *RaceRoom Racing Experience* and also *iRacing* is somewhat limited).

***

Before we head on, an important note: Depending on the simulation, the Race Assistants can not be used in a team race, since the required data is not availabe, when you are not the currently active driver.  I have concepts for a server based solution in the drawer, which will allow Jona to act as a Race Engineer for a complete team multiplayer endurance race. But this will be quite a huge undertaking and will take a while, depending on my available time to invest in this project.

***

As said above, Jona is a voice chat bot and therefore you can control Jona completely by voice. If you don't want to use voice control, there are other possibilities as well. More on that later in this documentation.

Before we dig deeper into the inner workings, here is a typical dialog based interaction, to give you an understanding of the current capabilities of Jona.

Important: If you have multiple *dialog partners* active, for example Jona and Cato, it will benecessary to use the [activation phrase](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Using-Simulator-Controller#voice-commands) the first time you start talking to a specific *dialog partner*.

### A typical dialog

**Jona: "Hi, here is Jona, your Race Engineer today. You can call me anytime if you have questions. Good luck."**

(You hear this or a similar phrase, whenever Jona is ready to interact with you. Typically this is at the beginning of the second lap in a session. From now on Jona might call you, when important information is available, or you can call her/him anytime using one of the key phrases - see the section about [phrase grammars](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#phrase-grammars) on that.)

**Driver: "Tell me the tyre temperatures."**

**Jona: "We have a blue screen here. Windows XP is crap. Give me a minute."**

(This answer, or a similar one, means, that Jona does not have enough data at the moment to answer your question. Typically, Jona needs two laps at the beginning of the session or after a pitstop, to be completely up and running)

(A lap later...)

**Driver: "Tell me the tyre temperatures."**

**Jona: "We have the following temperatures: Front left 87. 85 Degrees in the front right tyre. Rear left 93. 91 rear right."**

(You can ask for other information as well. See the section about [phrase grammars](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#phrase-grammars) for more information.)

(A few laps later...)

**Jona: "Warning. Only 3 laps before you will run out of fuel. Should I update the pitstop strategy now?"**

(With this question Jona asks, if you want to start the preparation process for the upcoming pitstop.)

**Driver: "No thank you."**

(We are brave and go on to another lap.)

**Jona: "Okay. Call me when you are ready."**

(As you can see, Jona always acknowledges what you have said. This helps you to check, whether Jona understood you correctly.)

(A lap later...)

**Jona: "What are you doing? You are running out of fuel. We should prepare for a pitstop, Okay?"**

**Driver: "Yes go on."**

**Jona: "Okay, give me a second."**

(A few moments later...)

**Jona: "Jona here. I recommend this for pitstop number one: ..."**

(Jona gives you a complete overview of all the settings, that were derived for the upcoming pitstop (refueling, tyre compound, pressures, repairs, and so on.)

(Maybe you have some corrections...)

**Driver: "Can we decrease front right by zero point two?"**

**Jona: "The pressure of the front right tyre shall be decreased by 0.2 PSI, is that correct?"**

**Driver: "Yes please"**

(A moment later...)

**Jona: "I updated the pitstop plan like you said. Anything else?"**

**Driver: "No thank you"**

**Jona: "Understood. I am here."**

(The pitstop is now planned, but still not locked in. We are very brave and stay out for the last lap...)

**Jona: "Warning. You will run out of fuel in one lap. You should come in immediately. Shall I instruct the pit crew?"**

(With the last question, Jona asks, whether the pitstop plan shall be locked in.)

**Driver: "Ok, let's go on."**

**Jona: "Okay, I will let the crew prepare everything immediately."**

(A few moments later...)

**Jona: "We are ready for the pitstop. You can come in."**

(The Pitstop MFD window of *Assetto Corsa Competizione* comes to life and all the data is input automatically. See the section about the [pitstop handling](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#the-pitstop) for more information.)

(You enter the pit and bring the car to a stop.)

**Jona: "Okay, let the crew do their job. Check ignition, relax and prepare for engine restart."**

(And now you are ready for your next stint...)

To have an error free session like this one, you must have a perfect setup for voice recognition. I strongly recommend using a headset, since alien noises might lead to false positives in Jonas voice recognition. Please see the section on [troubleshooting](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#troubleshooting), if you need some hints.

## Installation

Not much to do here, since Jona is a fully integrated component of the Simulator Controller package. Of yourse, you have to configure the Simulator Controller software, before you can use the Virtual Race Engineer. Please read the [installation documentation](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration) for a complete overview of the steps required, especially the installation and configuration for [Voice Control](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#tab-voice-control). You might want to have a look at the ["Race Engineer" plugin arguments](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-race-engineer), since this plugin controls Jona during your simulator sessions.

### Installation of Telemetry Providers

Jona acquires telemetry data from the different simulation games using so called telemtry providers, which in most cases read the [required data](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#telemetry-integration) from a shared memory interface. In general these are already included in Simulator Controller and there is nothing to do, but for *Assetto Corsa* and *rFactor 2*, you need to install a plugin into a special location for the telemetry interface to work and for *Automobilista 2* and *Project CARS 2* a change in the settings is necessary.

Please, note that all of this also applies to all other Virtual Race Assistants, but you have to do it only once, of course.

  1. *Assetto Corsa*
  
     Please copy the complete *SimlatorController* folder, which is located in the *Utilities\Plugins* folder of the Simulator Controller installation, to the Steam installation folder of *Assetto Corsa* and there into the *apps\python* folder. You will have to enable this plugin in the *Asseto Corsa* settings afterwards. This plugin uses code originally developed by *Sparten* which can be found at [GitHub](https://github.com/Sparten/ACInternalMemoryReader).
  
  2. *rFactor 2*
  
     You can find the plugin *rFactor2SharedMemoryMapPlugin64.dll* in *Utilities\Plugins* folder the Simulator Controller installation or you can load the [latest version](https://github.com/TheIronWolfModding/rF2SharedMemoryMapPlugin) from GitHub. Copy the DLL file to the *Bin64\Plugins* folder in the Steam installation directory of *rFactor 2*.

  3. *Automobilista 2* and *Project CARS 2*
  
     You have to enable Shared Memory access in the game settings. Please use the PCars 2 mode.

If you have used the quick setup method of "Simulator Setup", the plugins might already have been installed.

### Important preparation for the Pitstop MFD handling in *Assetto Corsa Competizione* and *RaceRoom Racing Experience*

Jona can control the pitstop settings, as you have seen in the dialog transcript above. Generally, this can be handled in the different simulation games using an API integration, with the exception of *Assetto Corsa Competizione* and *RaceRoom Racing Experience*. In the later cases, a special procedure using image recognition has been developed. Please see the documentation for the special preparation steps for [*Assetto Corsa Competizione*](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#important-preparation-for-the-pitstop-mfd-handling) and [*RaceRoom Racing Experience*](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#important-preparation-for-the-pitstop-mfd-handling-1) that might be necessary.

## Interacting with Jona

Although it is possible, to [use parts of Jona without voice interaction](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-race-engineer), it is not much fun. But to have fun with Jona, you must understand, how the interaction is structured, since in the end, Jona is stupid as bread and only reacts to strong standard patterns. For each language you want to use to interact with Jona, a so called grammar file must exist. As said, grammars for English and German are already there. The grammar files are named "Race Engineer.grammars.XX", where XX is the two letter ISO language code. These files reside in a special folder, either in the *Resources\Grammars* folder of Simulator Controller or in the *Simulator Controller\Grammars* folder in your user *Documents* folder. The later means, that you are able to provide your own grammar files or *overwrite* the existing ones. But be careful with overwriting, since this will introduce a pain in the a..., when updating to new versions.

Tha grammar files define the input patterns which Jona uses to understand you and also all reactions of Jona as predefined phrases. For each reaction, an unlimited number of phrases may exist (typically 2-4 different ones in the predefined grammar files) to provide for an entertaining variety of answers.

### Phrase grammars

Here is a small excerpt from the input setion of the English grammar file:

	[Choices]
	TellMe=Tell me, Give me, What are
	CanWe=Can you, Can we, Please
	[Listener Grammars]
	// Conversation //
	Call=[{Hi, Hey} %name%, {%name% do you hear me, %name% I need you, Hey %name% where are you}]
	Yes={Yes please, Yes go on, Perfect go on, Go on please, Head on please, Okay let's go on}
	No=No {thank you, not now, I will call you later}
	// Information //
	TyrePressures=[(TellMe) {the tyre pressures, the current tyre pressures, the pressures in the tyres}, What are the current pressures]

As you can see, a typical recognition phrase looks like this:

	[(TellMe) {the tyre pressures, the current tyre pressures, the pressures in the tyres}, (TellMe) the current pressures]
	
(TellMe) is a variable for a set of predefined optional filler phrases (in the example above TellMe stands for "Tell me, Give me, What are"). The definition above consists of two different independent phrases, which lead to the same reaction of Jona. This is denoted by the "[..., ...]" bracket construct. For the first phrase the "{..., ..., ...}" defines inner alternatives for this phrase. By using "[" and "{" constructs, you can create a variety of pattern alternatives. But in the end, Jona reacts only to the core words of a phrase, for example "the current pressures" in the above example.

Important: The words of the recognized phrase are reported to the Jona control program and may be analyzed there for further processing. For example, when asking for tyre pressures or temperaturs, the words "front", "left", ... are very important. Therefore be careful, if you change some of the predefined phrases.

Some phrases (input and output) may have additional variables enclosed in "%", as in *%name%* above. These variables are provided by the runtime to customize the questions and answers.

For the reactions of Jona, the format is much more simple. It looks like this:

	[Speaker Phrases]
	// Conversation //
	Greeting.1=Hi, I am %name%, your Race Engineer today. You can call me anytime if you have questions. Good luck.
	Greeting.2=Here is %name%. I am your Race Engineer for this session. Call me anytime.
	Greeting.3=Here is %name%, your Race Engineer. Have a great session.
	IHearYou.1=I am here. What can I do for you?
	IHearYou.2=Yeah? Have you called me?
	IHearYou.3=I hear you. Go on.
	IHearYou.4=Yes, I hear you. What do you need?
	Confirm.1=Roger, I come back to you as soon as possible.
	Confirm.2=Okay, give me a second.
	Comfirm.3=Wait a minute.
	Okay.1=Okay. Call me when you are ready.
	Okay.2=Understood. I am here.

As you can see here, each phrase provides different alternative sentences. Variables may be used here as well.

#### List of all voice commands

1. [English version](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Race-Engineer-Commands-(EN))

2. [German version](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Race-Engineer-Commands-(DE))

I strongly recommed to memorize the phrases in the language you use to interact with Jona. You will always find the current version of the grammar files as actually used by the software in the *Resources\Grammars* folder of the Simulator Controller distribution. Or you can take a look at the files in the [Resources\Grammars directory on GitHub](https://github.com/SeriousOldMan/Simulator-Controller/tree/main/Resources/Grammars), for example the German version [Race Engineer.grammars.de](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Resources/Grammars/Race%20Engineer.grammars.de).

### Enabling and disabling specific warnings and announcements

Jona will give you a lot of information about fuel level, damages after an accident, and so on. You may disable these warnings individually by using a special voice command:

	[Please] No more *warning* [please]

As you might expect, the word "please" is optional. Available options for *warning* are: "fuel warnings", "damage warnings", "damage analysis", "pressure warnings" and "weather warnings" (when the Assistant Cato is active, it will take the duty for weather warnings). After you have disabled one of the warnings (all are enabled by default), you can reenable it with the following command:

	[Please] Give me *warning* [please]

As an alternative, you can disable unwanted talking completely by saying:

	Be quiet please

To reactivate the Assistant use:

	I can listen now

These commands are also available as "Mute" and "Unmute" plugin actions, which can be configured for a Button Box or a Stream Deck, for example.

## Racing with Jona

Racing with Jona is easy, just begin your session and wait until Jona will contact you. This will be a few seconds after you crossed the start finish line after your first complete lap. Jona will be available in Practice, Qualifying and Race sessions, but the amount of support you can expect from Jona will vary between those session types. Pitstops, for example, will only be handled during race sessions, unless you enable them for other session types in the ["Session Database" tool](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#managing-the-session-database).

The Virtual Race Engineer is handled by the "Race Engineer" plugin, which may be integrated by the different simulation game plugins, if they want to support Jona. This plugin will start *Race Engineer.exe*, which is located in the *Binaries* folder, as a subprocess, as long as you are out on a track. (Note for developers: The communication between those two processes uses named pipes. For more technical information, see the [technical information](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#technical-information) section below).

Most of the information, that Jona needs, will be collected from the telemetry information of the simulation game. Unfortunately, this data does not contain every required information, and also there are additional data and configuration information, which are required by Jona. For example, data is required to understand the given race situation and the corresponding telemetry information, and to precisely predict tyre pressures, fuel requirements, tyre compound recommendations, and so on. In the end, all that means, that some setup work is required, before you start your session. 

Important: In the default configuration, Jona will be activated in the first lap of a session. This is necessary, so that Jona can setup the initial knowledge (fuel, pressures, etc.). If you join a session later than during the first lap, Jona will refuse to work. This behaviour can be changed with the setting "Engineer: Late Join" in the ["Session Database"](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#managing-the-session-database), but the behaviour of Jona may be somewhat confusing.

### Race Settings

The additional knowledge Jona needs is stored in a special file, *Race.settings*, that exists in the *Simulator Controller\Config* folder in your user *Documents* folder, which you have to modify for each session. You can do this by editing this file using a text editor or you can use a graphical user interface by using the application *Race Settings.exe* from the *Binaries* folder. As a side note, I am still trying to gather at least the setup part of this information from the simulation game itself.

The *Race.settings* looks like this:

	[Session Settings]
	Lap.AvgTime=106
	Lap.Formation=true
	Lap.PostRace=true
	Lap.PitstopWarning=3
	Fuel.AvgConsumption=2.7
	Fuel.SafetyMargin=3
	Pitstop.Delta=50
	Damage.Bodywork.Repair=Threshold
	Damage.Bodywork.Repair.Threshold=20.0
	Damage.Suspension.Repair=Always
	Damage.Suspension.Repair.Threshold=false
	Tyre.Compound.Change=Never
	Tyre.Compound.Change.Threshold=false
	Tyre.Pressure.Deviation=0.2
	Tyre.Pressure.Correction.Temperature=true
	Tyre.Pressure.Correction.Setup=true
	Tyre.Dry.Pressure.Target.FL=27.7
	Tyre.Dry.Pressure.Target.FR=27.7
	Tyre.Dry.Pressure.Target.RL=27.7
	Tyre.Dry.Pressure.Target.RR=27.7
	Tyre.Wet.Pressure.Target.FL=30.0
	Tyre.Wet.Pressure.Target.FR=30.0
	Tyre.Wet.Pressure.Target.RL=30.0
	Tyre.Wet.Pressure.Target.RR=30.0
	[Session Setup]
	Tyre.Compound=Dry
	Tyre.Compound.Color=Black
	Tyre.Set=7
	Tyre.Set.Fresh=8
	Tyre.Dry.Pressure.FL=26.1
	Tyre.Dry.Pressure.FR=26.1
	Tyre.Dry.Pressure.RL=26.1
	Tyre.Dry.Pressure.RR=26.1
	Tyre.Wet.Pressure.FL=28.2
	Tyre.Wet.Pressure.FR=28.2
	Tyre.Wet.Pressure.RL=28.2
	Tyre.Wet.Pressure.RR=28.2
	[Strategy Settings]
	Extrapolation.Laps=2
	Overtake.Delta=2
	Traffic.Considered=5
	Pitstop.Delta=50
	Service.Tyres=30
	Service.Refuel=1.5

Most options above define general settings which may be applicable to many different race events. But the options from the *[Session Setup]* section need to be adjusted for each individual race event, as long, as you want Jona to come to correct recommendations.

  - The first fresh tyre set (*Tyre.Set.Fresh*), which is available for a pitstop and the tyres and pressures (*Tyre.XXX.Pressure.YY*) used for the first stint. Jona needs this information to calculate the target pressures for the first pitstop.
  - The *Lap.AvgTime* and *Fuel.AvgConsumption* are more informational, but might lead to more accurate estimations for the fuel calulations in the first few laps, where you typically have much slower lap times.

Let's have a look at the settings tool, which provides a graphical user interface for the *Race.settings* file. The dialog provides two distinct areas as tabs.

#### Tab *Race*

The first tab of the settings tool contains information about the actual session, which typically will be a race.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Race%20Settings%201.JPG)

You must supply the tyre selection and pressure setup that is used at the beginning of the race in the lower area of the *Race* tab, whereas the static information for the given track and race is located in the upper area. With the "Setups..." button you can open the ["Session Database" tool](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#managing-the-session-database) to look up the best match for tyre pressures from recent sessions. Beside that, you can use the "Import" button to retrieve the current tyre setup information from your simulation game (this can also be triggered automatically at the beginning of a session depending on the configuration of the Race Engineer). But what data is available for an import depends on the capabilities of the simulator game in use. For example, *Assetto Corsa Competizione* currently only gives access to the tyre pressures that are configured in the Pitstop MFD. But you may use the "Use current pressures" option in the *Assetto Corsa Competizione* "Fuel & Strategy" area to transfer your current tyre setup to the Pitstop MFD and *import* the settings from there. Depending on your currently mounted tyres, the values will be imported as "Dry" or "Intermediate" / "Wet" setup values. Please consult the documentation for the [configuration of the "Race Engineer" plugin](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#tab-race-engineer) for more information on the different methods to initialize the initial pressures at the beginning of a session, and also take a look at the documentation about [handling tyre compounds](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Tyre-Compounds) in general.

The management of tyre sets (mainly used in *Assetto Corsa Competizione*) can be set to "Auto", if you are using automatic import from the simulation. See the discussion about [pitstop handling](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#the-pitstop) below for more information. 

Note: We requested a more versatile access to setup informations from Kunos already. Hopefully, this will be available in a future version of *Assetto Corsa Competizione*, and the whole process will become much less cumbersome. But to be honest, there is even less functionality available at the moment for other simulators.

Additionally worth to be mentioned is the field *Pitstop.Delta*, with which you supply the difference time needed for a normal pitstop (time for pit in and pit out but without any service the time minus the time to pass the pit area on the track). This information is used by Jona to decide, whether an early pitstop for a tyre change or damage repair might be worthwhile.

#### Tab *Pitstop*

The second tab, *Pitstop*, contains information that will be used to derived the settings for a pitstop.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Race%20Settings%202.JPG)

The upper area with the three dropdown menus give you you control over several decisions, Jona will take for an upcoming pitstop. For the repair settings you can decide between "Never", "Always", "Threshold" and "Impact".

  - "Threshold" will allow you to enter a value, which defines a level of damage as seconds that will be needed to repair this damage during a pitstop. . If the repair duration is above this value, Jona will advise to go for a repair on the next pitstop. The data APIs of the different simulators report damage differently. Typical are values between 0% and 100%, but *Assetto Corsa Competizione*, for example, report a meaningless, although linear rising number. To support a conversion to repair duration, you must set a conversion factor for a given simulator in the [settings](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Race-Settings) in the "Session Database". The conversion factor can be set independently for bodywork, suspension and engine repair, and I will provide a growing number of defaults for the different sims.

  In many cases it is not a godd idea to decide based on the repair duration, whether a repair is useful. Sometimes a damage, for example at the side of the car, has no bad influence on lap time. Therefore I recommend to use the "Impact" rule, whenever possible.
  
  - For "Impact" you can also enter a number of seconds. Jona will analyse your lap time and will go for a repair, if your lap time is slower by the number you entered with regards to the reference laps just before the accident. Jona will also consider the time needed for the repair with regards to the remaining session or stint time. Beside that, I advise to go always for a repair for supsension damage, since additional damage in a next accident will most likely be catastrophic.

For tyre compound changes, you can choose between the triggers "Never", "Tyre Temperature" and "Weather". If you choose "Weather", Jona will advise wet tyres for light rain or worse and dry tyres for a dry track or drizzle. "Tyre Temperature" will allow you to enter a temperature threshold, where Jona will plan a tyre change, if the tyre temeprature falls outside its optimal temperature window by this amount. For dry tyres, the optimal temperature is considered to be above 70 Degrees and for wet tyres below 55 Degrees.

In the lower area you can define the optimal or target tyre pressures. When there is a deviation larger than *Deviation Threshold* from these *Target Pressures* is detected by Jona, corresponding pressure adjustments will be applied for the next pitstop. Beside this very simple approach, there are rules in the AI kernel, which try to predict future influences by falling or rising ambient temperatures and upcoming weather changes, and Jona also might access the session database for a second opinion on target pressures, both depending on the selection of the *Correction* check boxes.

If you open the settings tool, it will load the *Race.settings* file located in the *Simulator Controller\Config* folder in your user *Documents* folder. If you close the tool with the "Ok" button, this file will be overwritten with the new information. Beside that, you can load a settings file from a different location with the "Load..." button and you can save the current settings with the "Save..." button. As an alternative to handle the locations of the settings files yourself, you can use the session database to organize them. Plesse see the [documentation](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#race--session-database) for the session database for further information.

Good to know: When the *Race.settings* file is changed while Jona or any other Assistant is already active, the updated settings will be imported into the active session. This is useful during Practice, Qualifying or even Endurance Race sessions. And, if you click on the blue label of the dialog title, this documentation will be opened in your browser.

Beside the session respectively race specific settings described in the previous sections, the general behaviour of the Virtual Race Engineer can be customized using the [configuration tool](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#tab-race-engineer).

#### Tab *Strategy*

You will find settings for the race strategy analysis and simulation in the third tab. These settings are mainly used by the Virtual Race Strategist, but some of them, for example the *Pitstop Delta* time or the *Safety Fuel* will also be used by Jona.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Race%20Settings%203.JPG)

Please see the [documentation](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Strategist#tab-strategy) in the Virtual Race Strategist chapter for a description of these fields.

#### Tab *Team*

This tab gives you all you need to become a driver in a team session. Whenever you want to participate in a team session, you must connect to the corresponding *Team Server* beforehand using the URI and the access token provided by your team manager and clicking on the "Key" button (if you hold down the Control key, while pressing on the "Key" button, you can use login credentials of the team manager as well). After you have established a valid connection, you can choose the team, your driver name and the sesison you want to join. Please note, that you still might have to activate a team session, before you head out onto the track (see the actions of the ["Team Server" plugin](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-team-server), if you want to control this using your Button Box, for example).

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Race%20Settings%204.JPG)

The details about the installation, configuration and usage of the *Team Server*, and also about the team administration task in general can be found in the [dedicated documentation](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Team-Server) for the *Team Server*.

### The Pitstop

The process of the pitstop handling differs between the various supported simulations. Below you will find some simulation specific hints. Please note, that pitstop handling is currently available for *Assetto Corsa*, *Assetto Corsa Competizione*, *rFactor 2*, *RaceRoom Racing Experience*, *iRacing*, *Automobilista 2* and *Project CARS 2*.

The pitstop is handled by Jona in two phases. In the first phase, the planning phase, Jona creates a list of the necessary activities (refueling, changing tires, repairs) and gives you the chosen service tasks by radio. If you then agree with the selected services, or after you have made any necessary corrections, the settings are transferred to the simulation in the second phase, the preparation phase. After the preparation is finished, you can come to the pit anytime (depending on the simulation, it might be necessary, to activate a "Request pitstop" function as well).

Good to know: If Jona has planned the pitstop based on a request from Cato, the Virtual Race Engineer, the lap in which you should come to the pit is already known. In this case, the preparation phase does not have to be triggered explicitly, since the preparation for the pitstop takes place automatically when you start the selected lap.

A final warning: If you ever perform a pitstop, which has not been planned and prepared by Jona, Jona will be very confused, say the least. You can do this, but please double check the recommendations of Jona for each subsequent pitstop, especially the chosen tyre set, if you don't want to end up with worn out tyres for your last stint. Also be very careful, when using the "Pitstop" mode on your Button Box to change the pitstop settings. Jona will not know about your changes, and might overwrite them during the pitstop preparation. There is one notable exception, if Jona has planned and prepared a pitstop, but this pitstop has not been carried out yet, every change to the pitstop settings using the "Pitstop" mode will be recognized and taken into account by Jona. However, this only applies to *Assetto Corsa Competizione* and *rFactor 2*, since these simulations will give other applications access to the current pitstop settings.

#### *Assetto Corsa Competizione*

Jona can acquire the curent settings directly from *Assetto Corsa Competizione* via API. Jona uses the values already set in the Pitstop MFD and applies the delta to the desired target values. Please note, that this requires the settings in the [*Race Settings*](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#tab-race) dialog to be valid. Beside that, I still recommend to setup a reasonable pitstop strategy, since this will reduce the time needed to dial in all those numbers (going from 0 to 120 liters of refueling will take quite some time).

A special case is the management of tyre sets. You can either dial the values of the tyre set mounted at the start of the session and the first fresh tyre set for the first pitstop into the "Race Settings", or you can set both values to "Auto" (or to **0** in the ["Session Database"](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#managing-the-session-database)). In this case, tyre sets are managed completely by the simulation when it comes to a pitstop.

#### *rFactor 2*

No special setup required for *rFactor 2*, since this simulation has an integrated interface to control the pitstop settings externally.

#### *iRacing*

No special setup required for *iRacing*, since this simulation has an integrated interface to control the pitstop settings externally.

#### *RaceRoom Racing Experience*

*RaceRoom Racing Experience* does not provide any data interface for initial setup information. So you must take care, that everything is entered correctly into the settings tool, before you head out onto the track. On the other hand, the support for pitstop settings is quite limited in *RaceRoom Racing Experience*, so you might skip tyre pressures and dry vs. wet tyre considerations alltogether.

#### *Automobilista 2* and *Project CARS 2*

Both siimulator do not provide any data interface for initial setup information. Therefore you must take care here as well, that everything is entered correctly into the settings tool, before you head out onto the track.

Furthermore, it is very important, that you do not use the *Automobilista 2* and *Project CARS 2* ICM yourself, while you want Jona to control the pitstop settings or want to use the "Pitstop" mode of the "AMS2" plugin. Additionally, you must leave *all* repairs selected in the default pitstop strategy and select *no tyre change* in the default pitstop strategy as well. Not complying with this requirements will give you funny results at least.

### How it works

Jona uses several statistical models to derive the data, on which the recommendations for the pitstop or other information is based. Therefore it will take some laps, before Jonas conclusion get more and more precise. So be careful, if you let Jona plan a pitstop after you have driven only three or four laps. You might end up with not enough fuel to reach the finish line.

The following statistical models are currently implemented:

  1. Tyre pressure development
  
     The pressure development of the last laps and the deviation from the predefined target pressures are considered to derive pressure corrections for the next pitstop. The number of laps considered and the weighting of past laps can be configured using the settings tool. To get the most precise recommendations, set the *Statistical Window* as large as possible and the *Damping Factor* as small as possible. For example, a statistical window of 10 and a damping factor of 0.1 will consider your last 10 laps, where your most recent lap counts fully and the lap five laps ago only with 50%. Depending on accidents, severe traffic or safety car phases, especially in the most recent laps, the algorithm will come up with unexpected results, so always double check Jonas recommendations here.
	 
	 When planning and preparing a pitstop, Jona will consult the ["Session Database"](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#managing-the-session-database) for a second opinion on tyre pressures for given temperature and weather conditions. Needless to say, these values are also specific for a given car and track combination. Jona will use the same algorithm as the database tool, therefore extra- or interpolation will be used, when no exact match is available. But in those cases an (un)certainty factor will be applied, so that the dynamically derived target pressures will be considered more relevant.

  2. Tyre pressure loss

     Beside looking at the *normal* tyre pressure development, the artificial intelligence also constantly observes and compares the pressures of all tyres in relation to each other. During the learning laps (see the ["Race Engineer" configuration](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#tab-race-engineer) for more information), a reference pressure is derived for each tyre. When the actual tyre pressure deviates more than other tyres from this reference pressure (actual the average of all deviations plus the standard deviation of all deviations is used as a threshold), than the artificial intelligence assumes that the tyre is loosing pressure, either by a sudden hit on a curb or slowly as a result of a puncture, and you will be informed about that by the Race Engineer. The pressure loss can alo be taken into account when planing and preparing the next pitstop, but you have to activate this feature in the [race settings](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#race-settings). Please always double-check the recommendation in this case, because the reported pressure loss could also have been a result of wrong cold pressures right from the start, which might give you even more underflated tyres at the end.

  3. Refuel amount
  
     Depending on the number of remaining laps and average fuel comsumption, Jona derives the exact amount of fuel required for the next stint. As for the tyre pressures, the lap weight of past laps may be configured for the fuel average calculation, so the remarks above on statistical window and damping factor are valid here as well.
	 
  4. Damage related lap time degration
  
     After Jona detects a new damage, the devlopment of your lap times are observed and Jona might suggest an adopted pitstop strategy, depending on remaining stint time and the delta time necessary for a pitstop. The underlying model is quite complex and recognizes and excludes special lap situations like pitstops, accidents, and so on, from the average laptime calculation. All laps of the current stint (except a couple of laps at the beginning) are considered by the algorithm and the average lap time incl. the standard deviation before the accident will be taken as the reference lap time. This means, that the computation will fail, if you had an accident very early in your stint, since you never had the chance to set a good reference lap.
	 
	 The following damage categories are supported for the different simulators:
	 
	 | Simulator                  | Bodywork & Aerodynamics | Suspension & Chassis | Engine |
     | -------------------------- | ----------------------- | -------------------- | ------ |
     | Assetto Corsa              | Yes (1)                 | No (1)               | No (1) |
     | Assetto Corsa Competizione | Yes                     | Yes                  | No     |
     | Automobilista 2            | Yes                     | Yes                  | Yes    |
     | iRacing                    | No                      | No                   | No     |
     | Projects CARS 2            | Yes                     | Yes                  | Yes    |
     | RaceRoom Racing Experience | Yes                     | Yes                  | Yes    |
     | rFactor 2                  | Yes (1)                 | No (1)               | No (1) |
	 
	 (1) It looks like the damage is reported by the corresponding API as an accumulated value for all different damage types. The damage will be reported by the Race Engineer as adamage to the Bodywork and only Bodywork repair will therefore automatically recommended for a pitstop. Select the other repair categories manually as needed.
	 
  5. Repair recommendations
  
     Based on the same model, Jona suggests repairs for the upcoming pitstop. You can configure various strategies (Repair Always, Repair Never, Repair when damage is above a given threshold, ...) using the settings tool.
	 
	 Some remarks regarding simulator specific restrictions for the different damage types:
	 
	 - *Assetto Corsa*
	   
	   Bodywork repair will be recommended, but you have to select suspension or engine repair on your own as needed.
	 
	 - *Assetto Corsa Competizione*
	   
	   Bodywork and suspension repair will be handled automatically, but although there is an engine warning light available in the HUDs, no data is available in the API regarding the current engine state. And it looks like configurable engine repair during pitstops is not supported as well.
	   
	 - *Automobilista 2* and *Project CARS 2*
	   
	   Repair recommendations will be given for all damage types.
	   
	 - *iRacing*
	   
	   No automatic support, you must select the "Quick fix" option for the upcoming pitstop manually.
	   
	 - *RaceRoom Racing Experience*
	   
	   Repair recommendations will be given for all damage types.
	 
	 - *rFactor 2*
	 
	   Since the damage types are not distinguishable in the API, only bodywork & aerodynamics damage will be recommended. Handle other damage types manually.
	 
  6. Tyre pressure gambling
  
     Linear regression models are used here, depending on the development of ambient, track and tyre temperatures and the resulting tyre pressure development, Jona might suggest higher or lower pressures for the next pitstop than currently might be perfect as a result of a clear past trend, thereby probably giving you a good compromise for the upcoming stint.
	 
  7. Weather trend analysis and tyre compound recommendation
  
     Beginning with Release 2.5, a weather model has been integrated in the working memory. The raw data is acquired from the simulation. For example, *Assetto Corsa Competizione* and *rFactor 2* supply current weather information ranging from "Dry" up to full "Thunderstorm". *Assetto Corsa Competizione* goes even further and can supply a full weather forecast from now on up to 30 minnutes into the future. Based on this information and currently mounted tyres, Jona will recommend a tyre change. This recomendation will be incorporated into the plan for an upcoming pitstop depending on the settings you have chosen in the [settings dialog](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#race-settings).
	 
	 All applications of Simulator Controller, incl. the Race Engineer, support three different tyre categories (Dry, Intermediate and Wet), as well as a couple of mixtures for each category. The combination of both is a tyre compound, for example "Dry (M)", a dry tyre (aka Slick) with a medium hardness. Please read the chapter [Tyre Compounds](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Tyre-Compounds) carefully for more information and especially for the mapping of simulator specific tyre compounds to the tyre model of Simulator Controller. Jona uses the tyre model to recommend the best possible tyre compound for the given weather conditions.
	 
	 | Weather      | Suitable Category | Optimal Category |
     | ------------ | ----------------- | ---------------- |
     | Dry          | Dry               | Dry              |
     | Drizzle      | Dry, Intermediate | Intermediate (1) |
     | Light Rain   | Intermediate, Wet | Intermediate (1) |
     | Medium Rain  | Wet               | Wet              |
     | Heavy Rain   | Wet               | Wet              |
     | Thunderstorm | Wet               | Wet              |
     
     (1) If no Intermediates are available, Dry Tyres will be used in Drizzle conditions and Wet Tyres in Light Rain conditions.
	 
	 Looking at the above table, you can understand when and why a tyre change will be recommended by the Jona. As long as the currently mounted tyre has a suitable category, no urgent pitstop will be requested. If you come in for a regular pitstop, the tyre compound with the optimal category will always be chosen, as long as it is available (see note (1)). But in the case, that the currently mounted tyre is not suitable for the current or upcoming weather conditions, an urgent pitstop will be requested and the optimal tyre compound will be chosen, if available.
	 
	 Finally some remarks regarding simulator specific restrictions:
	 
	 - *Assetto Corsa*
	   
	   Tyre Compounds are supported as described in the [Tyre Compounds](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Tyre-Compounds#using-tyre-compounds) chapter, but no weather model is available.
	 
	 - *Assetto Corsa Competizione*
	   
	   Everything works as designed, but only Dry and Wet tyre categories without different mixtures are available.
	   
	 - *Automobilista 2* and *Project CARS 2*
	 
	   Both simulator share the same engine, therefore everything applies to both. The API does not provide any information about the currently mounted tyre compound. So make sure, that the initial mounted tyres are specified correctly in the "Race Settings". Additionally, weather information is not available for the future, so weather warnings might come in a *little bit* late.
	   
	 - *iRacing*
	   
	   *iRacing* neither provides a weather model nor a sophisticated tyre model with different compounds. SO nothing to see her and move on.
	   
	 - *RaceRoom Racing Experience*
	   
	   Tyre Compounds are supported as described in the [Tyre Compounds](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Tyre-Compounds#using-tyre-compounds) chapter, but no weather model is available.
	 
	 - *rFactor 2*
	   
	   Tyre Compounds are supported as described in the [Tyre Compounds](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Tyre-Compounds#using-tyre-compounds) chapter. Weather information is not available for the future, so weather warnings might come in a *little bit* late. There might be a possibility to parse the weather control history, this will be implemented available in a future release.

	 
Note: Extrem changes in the conditions, for example an incoming thunderstorm on a previously dry and hot track, will result in extreme variances in the statistical models and thereby will lead to strange recommendations in many cases. This is a drawback for the moment, so always doublecheck under those circumstances. Jona will use the data collection of recent races, if available, to guess the best possible combination of tyre compound and pressures, but especially in changing conditions tyre pressures may be way off. So double check the recommendations fo the Race Engineer against your own experiences and gut feeling.

Additional notes for *iRacing* users: It looks like that tyre pressures and also to some extent tyre temperatures for most of the cars are not available in the *iRacing* live data. To make it worse, damage information is also not available in the API, although *iRacing* apparently has a sophisticated damage model. Since *iRacing* is a quite mature (not to say old) simulation game, and the API hasn't changed in a while, I am quite pessimistic, that this will be fixed. Therefore, the recommendations of the Virtual Race Engineer will be at best limited and in some cases even false. Nevertheless, Jona will help you with refuel recommendation for an upcoming pitstop and you will have someone to talk to while hunting down your opponent on the long straights.

## Race & Session database

With the introduction of Release 2.6, Jona, the Virtual Race Engineer, collects several data points from your practice and race sessions (qualifying sessions are not supported, since they often use special setups which will only be in the perfect window during the first few laps) and saves them together with the associated tyre choice and start pressures, air and asphalt temperature and other environmental conditions in a local database. Beside that, you can upload your car setups for a given track and different conditions to the setup databse. This informations may then be used as a starting point for a setup in an upcoming race under the same or similar conditions. In order to build up a comprehensive collection of data on vehicles, tracks and environmental conditions as quickly as possible, Jona can integrate your data with the data of all other drivers, and in return will make the consolidated database available to all contributors.

When your data is transferred, no direct or indirect personal data is involved. It is not possible to draw any conclusions about the individual user or the computers from which the data originated. A randomly generated key is used to identify the local database and the data supplied for further processing. Nevertheless and according to good data privacy standards, you must give your consent to share your data with other users of Simulator Controller by answering "Yes" for the different options in the dialog below. This consents are saved in the "CONSENT" file in the "Simulator Controller\Config" directory which is located in your user *Documents* folder. If you want to change your consents in the future, delete this file and this dialog will appear again.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Consent.JPG)

Note: You can give separate consents for sharing your tyre pressure setups, your race strategies and your mechanical and aerodynamic car setups. Since car setups and race strategies might be considered kind of a secret, you must declare, whether you want to share the given strategy or setup individually for each item and you must explicitly upload car setup data to be shared to the session database. On the other hand, tyre pressures will be collected automatically by Jona, but you will be asked whether to include them in the session database (see below).

If you have given your consents, the data collected in your local sessions will be transferred to a cloud database once a week. You will get a payback in terms of a consolidated database of all contributors and Jona will use the data to help you in your setup task in the pit, but also during a race, when radical weather changes are upcoming. This community database will be updated on your local PC every two days, so you will always get the latest and greatest setup data. The update process works completely in the background, so nothing to do on your side.

For the moment, the data collection consist of tyre and car setup information for the different track and weather conditions, as long, as they are available in the different simulation telemetry interfaces. But there will be more in the future. For example, there are ideas in the backlog to use race position data and pitstop events from the races to optimize the pitstop strategy with regards to the most positive effect on race position. Neural networks and reenforcment learning algorithms will be used for that, but to be able to do this, our joint database needs to have enough data points, so this will take some time.

Note: The database is stored in the *Simulator Controller\Database* folder, which is located in your users *Documents* folder. Your own data files will be located in the *User* subfolder, whereas the consolidated data will end up in the *Community* subfolder.

*Very Important*: As long as we can't get the actual car setup information from the different simulation games via APIs, you **really** have to follow the guidelines from [above sections](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#race-settings), so that Jona has a correct understanding of your car and tyre setup. This has been important in the past to get a correct setup for an upcoming pitstop, but it is even more important when building the setup databse, so that we do not end up with compromised data. Jona will ask you at the end of the session, if you were happy with your setup and if you want to include the setup information in the database. Please only answer "Yes" here, if you are sure, that the setup information has been transferred correctly to Jona, as described above. Please note, that you still may have had a too low or too high hot tyre pressure during your session, because your initial setup was wrong in the first place. This is no problem, since Jona will store the corrected values in the database, as long as your initial setup values are known.

### Using the Practice Center

As mentioned above, the Race Engineer can store information about your tyre pressures (both hot pressures and recommended cold pressures) in the session database depending on your ["Race Engineer" configuration](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#tab-race-engineer). But you can also collect your data during a practice run or even a solo race in a special application name "Practice Center", which allows you to inspect the data after your session and finally select the data that should be stored into your database. See the [documentation for the "Practice Center"](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Strategist#practice-center) for more information.

### Managing the Session Database

Whenever you have to setup your car for a given track and specific environmental conditions you can query the session database to get a recommendation on how to setup your car. When you start the application *Session Database.exe* from the *Binaries* folder, the following dialog will open up.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Session%20Database%203.jpg)

This tool gives you access to the database where you have access to the tyre pressures of all your past sessions, where you can store your track specific car setups and where you can provide default values for various settings for the Virtual Race Asssistants. These values can be used to initialize the [race settings](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#race-settings) using track and car specific default values. Telemetry information of all past sessions is also stored in the database. Use the ["Strategy Workbench"](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Strategist#strategy-workbench) to browse this data.

You have to use the menus in the upper left area to specify the simulation, car, track, current weather and so on. After you have done that, you can select one of the database topics using the choice tabs.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Session%20Database%204.jpg)

You will get a summary of all available data in the list below the tabs. Please note, that the "Setups" and "Tyre Pressures" will only be available, when you have selected a specific car and a specific track before.

Last, but not least, you can write some notes in the field in the upper right corner, which are also stored specifically for the simulator / car / track combination.

With the dropdown menu above the list of available data you can choose whether only your own setups (=> "User") will be included in the database search or that also the setups of other users of Simulator Controller might be considered (=> "User & Community").

Important:

  1. If you change the scope using the dropdown menu mentioned above, this will affect only the behaviour and scope during the current run of the "Session Database" tool. If you want to alter the scope permanently, so that it will also influence the retrieved values ​​by other applications such as the Race Assistants, hold the Control key down while choosing a different scope from the dropdown menu.
  2. Simulator Controller knows nothing about the available cars and tracks of any simulator. This info will only get available when you run a session with a specific car on a specific track. It is not necessary to save any setup information by the Assistants, simply running one lap is enough.
  3. "Session Database" displays some graphs using the Google chart library in an embedded web browser. This web browser, which is part of Windows, must be configured for a given application using a setting in the Windows Registry. In most cases, this setting can be configured automatically by the given application, but in rare cases, admin privileges are required to insert the corresponding key in the registry. If you encounter an error, that the Google library can not be loaded, you must run "Session Database" once using administrator privileges.

Following you will find an overview about the different database topics:

#### Race Settings

The Virtual Race Assistants provide many settings, as you have seen above in the section about the [Race Settings](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#race-settings). Many values are specific for a given car or track, for example the pitstop delta or the time required to change tyres. You can change all these settings manually before each session, or you can store default values for all theses settings in the session database.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Session%20Database%205.jpg)

When you enter a session, these default values are loaded depending on a [setting in the configuration](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#tab-race-engineer) and are used to initialize the race settings used for this session. You can provide setting values for each possible combination of simulator / car / track /  weather, as selected in the upper left area. When the settings are loaded, they will be loaded in the order from the least specific to the most specific, thereby allowing you to inherit settings and *overwrite* them for a more specific configuration. Let's take a look at a specific example:

The Race Assistants use several values from the race settings to calculate how much time a specific pitstop will need - the time required to refuel the car,  to change the tyres and for entering and leaving the pits. Some values are specific for the given track, some for the car in use and even some might be identical for all cars and tracks. This is how you use the default values for these settings, you simply select the desired scope using the menus in the upper left corner and then enter the required values in the list of settings.

| Settings for *all* cars and *all* tracks | Specific setting for *Hungaroring* |
|------------------------------------------|------------------------------------|
| ![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Session%20Database%208.jpg) | ![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Session%20Database%209.jpg) |

Below you find the order, in which the different combinations will be loaded. As you can see, setting values from a more concrete combination of car / track / weather will be *overwriten* those from a less specific combination.

| Car      | Track    | Weather  |
|----------|----------|----------|
| All      | All      | All      |
| Specific | All      | All      |
| All      | Specific | All      |
| All      | All      | Specific |
| Specific | Specific | All      |
| Specific | All      | Specific |
| All      | Specific | Specific |
| Specific | Specific | Specific |

Important note: Some values underly a transformation between internal and external representations. For example, lap times are stored in a millisecond format in many places, **0** for tyre sets means "Auto" and so on. Therefore, when entering a new settings value, take a look at the supplied default value, and understand its meaning. And use the "Test..." button to open the "Race Settings" tool to check the resulting values for the current selected car / track / weather combination, after you have entered or changed any settings. Additionally, you may find entries in the list of available settings for which no corresponding field in the "Race Settings" tool exist. These settings are for internal calculations in most cases, for example the correction factor for temperature based tyre pressure calculations. Be careful, when entering values for these settings, you may get funny results. The default values are generally the best choice here.

The default values for all these settings may not only be used to initialize the race settings for an upcoming session, but they may also be used in the "Strategy Workbench" to provide values for many [settings for strategy simulation & planning](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Strategist#rules--settings).

A detailed overview and description for all available settings and their usage can be found [here](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Race-Settings).

#### Strategies

This tab shows you a list of race stratagies, which are stored in the database. Note: Race strategies can be created and stored in the session database using the "Strategy Workbench".

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Session%20Database%2015.jpg)

You can use the buttons below the list to upload, download, rename or delete a strategy, but you can also use the "Strategy Workbench" to create a strategy and store it on the database. Once you have selected a strategy in the list above, you can decide whether you want to share this strategy potentially with the community (if you have given consent to share strategies) and/or whether you want to synchronize the strategy with any of the [connected Team Servers](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#database-configuration) (see below).

#### Setups

This tab allows you to store your preferred car setup files for different conditions (Wet vs. Dry) and different Sessions (Qualifying vs. Race) in the session database.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Session%20Database%206.jpg)

Use the drop down menu at the top to select the type of setup, you want to store or retrieve. After you have done that, you can use the buttons below the list to upload, download, rename or delete a setup file from your simulator. Once you have selected a setup in the list above, you can decide whether you want to share this setup potentially with the community (if you have given consent to share setups) and/or whether you want to synchronize the setup with any of the [connected Team Servers](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#database-configuration) (see below).

##### Naming conventions

Although technically not strictly necessary, it would be benificial that everybody who contributes to the setup collection will follow the same naming conventions. Therefore, I dare to propose a naming scheme here:

	[Nickname] [T Air] [T Track] [Weather] [Track Surface] [Compound]

Example: "TBO 21 27 Drizzle Damp Dry(Soft)" - (TBO is my nickname (for TheBigO), Dry(Soft) is the tyre compound, the rest is self-explanatory)

Why so complex? There is a strong dependency between the track surface state, air and track temperatures and the needed tyre pressures. Following this convention will give any user of the setup enough information how to alter the pressures for different conditions.

Please note, that you can use the "Pencil" button to rename an already uploaded setup file to follow the above conventions, if necessary.

#### Tyre Pressures

Here you will get a recommendation for initial cold tyre pressures, if a matching setup is available in the session database. Depending on the temperature settings the recommended tyre pressures will be marked in dark green for a perfect match, or light green or even yellow, if the values have been extra- or interpolated from different air and/or track temperatures.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Session%20Database%207.jpg)

Notes:

  1. If you choose a specific driver in the "Driver" menu, only the tyre pressures of this driver are shown, if available.

  2. If the "Session Database" tool has been [started by the "Race Settings" tool](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#tab-race), you can transfer the current tyre pressure and compound information to the *Race Settings* by pressing the "Load" button.

  3. You can configure using the [settings in the "Session Database"](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#race-settings-1) the session types, from which tyre pressure data will be collected and stored into the database by Jona. Default is to collect tyre pressure data during practice and race sessions.

##### Browsing and Editing Tyre Pressures

A tool is available to investigate the tyre pressure data collected by the Race Engineer. Using this tool you can also correct invalid data points, if wrong pressures might have been mistakingly recorded. To open this tool, you must select a specific weather condition (i.e. not "All") and you must choose yourself as the current driver. Then you can click on the small button with the "Pencil" beside the driver name and the following window opens:

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Session%20Database%2016.jpg)

Here you can select one of the tyre compounds, you have used in that specific weather condition, and the temperatures (air / track) for which pressure data is available. In the list in the lower part of the window you will see all recorded data points. Select one of the entries, and you can increase or decrease the count and thereby the weight of this data point, or you can delete it alltogether. The graph in the upper area shows you the data distribution. The narrower the box, the more accurate the cold tyre pressure recommendation.

Please note, that **all** changes will only be saved, if you close the tool using the "Save" button.

#### Automations

At this page, you can define automatic actions for specific locations at the track. Since this is a very extensive functionality and observing your car and its position on the track is the duty of the Race Spotter, there is a [dedicated chapter](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Spotter#track-automations) in the documentation of the Virtual Race Spotter, which shows how to setup and use track automations.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Session%20Database%2013.jpg)

#### Administration

Here you can browse all available data in your session database. Data can be deleted by request and you can export data, so that it can be imported by one of your team mates or vice versa. The driver, who originally created the corresponding data will be preserved. Data of multiple drivers can be used in the strategy development using the ["Strategy Workbench"](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Strategist#strategy-workbench). When running team races using the ["Race Center"](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Team-Server#race-center), data of your team mates will be stored to your database as well.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Session%20Database%2010.jpg)

You can restrict the scope of the data in the browser using the menus in the topleft corner of the window, thereby making it possible to work with the all the available data of a given simulator or only for a single car on a single track, for example. The window above shows a list of all available cars and tracks for *Assetto Corsa Competizione* with the *Honda NSX Evo* / *Hungaroring* combination selected either for export or even for deletion.

When you export data by clicking on "Export...", you will be prompted to identify the target directory, where a directory containing all the selected data will be created. This export directory will be automatically named "Export_XXYYZZ", where *XXYYZZ* represents the current date and time. You may change the name afterwards, but make sure that you always pass the complete export directory to the target PC, where the data will be imported again.

If you click on "Import..." you will be requested to locate this export directory. When you located a valid export directory, a window opens where you can select all data or only a fraction of the data available in the export package to be imported.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Session%20Database%2011.jpg)

Here only the *McLaren 720s* data for the *Mount Panorama* and the *Nürburgring* will be imported, when you click on "Ok".

##### Importing data from other sources

You can import data from foreign sources, for example telemetry information from a real car, in order to use this data in "Strategy Workbench" or in other tools of Simulator Controller, as long as the structure follows the rules:

1. For the moment you have to choose one of the simulators as the home for your imported data. A future release might provide a special place for foreign data.
2. You have to create a folder with the data to be imported.
3. You must create a subfolder for each car and therein a subfolder for each track. The names of the cars and the names of the tracks can be chosen as you like, but it is preferred to not interfere with the names of the chosen simulator, so that the data will not be used in conjunction with already present data.
4. Create a CSV file for each of the telemetry data type you want to import ("Electronics", "Tyres", "Tyres.Pressures", "Tyres.Pressures.Distribution"). Please take a look at a sample export for the naming conventions and the content for these files. But you may omit columns in the CSV files, if the corresponding data is not available (see next point).
5. At the root of the export folder, you must create a "Export.info" file with the meta data. Here is an example:

		[Driver]
		123.456.789=Oliver Juwig (OJU)
		[General]
		Creator=123.456.789
		Origin=123.456.789
		Simulator=Assetto Corsa Competizione
		[Schema]
		Electronics=Weather,Temperature.Air,Temperature.Track,Tyre.Compound,Tyre.Compound.Color,Fuel.Remaining,Fuel.Consumption,Lap.Time,Map,TC,ABS,Driver
		Tyres=Weather,Temperature.Air,Temperature.Track,Tyre.Compound,Tyre.Compound.Color,Fuel.Remaining,Fuel.Consumption,Lap.Time,Tyre.Laps,Tyre.Pressure.Front.Left,Tyre.Pressure.Front.Right,Tyre.Pressure.Rear.Left,Tyre.Pressure.Rear.Right,Tyre.Temperature.Front.Left,Tyre.Temperature.Front.Right,Tyre.Temperature.Rear.Left,Tyre.Temperature.Rear.Right,Tyre.Wear.Front.Left,Tyre.Wear.Front.Right,Tyre.Wear.Rear.Left,Tyre.Wear.Rear.Right,Driver
		Tyres.Pressures=Weather,Temperature.Air,Temperature.Track,Compound,Compound.Color,Tyre.Pressure.Cold.Front.Left,Tyre.Pressure.Cold.Front.Right,Tyre.Pressure.Cold.Rear.Left,Tyre.Pressure.Cold.Rear.Right,Tyre.Pressure.Hot.Front.Left,Tyre.Pressure.Hot.Front.Right,Tyre.Pressure.Hot.Rear.Left,Tyre.Pressure.Hot.Rear.Right,Driver
		Tyres.Pressures.Distribution=Weather,Temperature.Air,Temperature.Track,Compound,Compound.Color,Type,Tyre,Pressure,Count,Driver

Here is what you have to do:

- For each driver, for whom you have data sets available, create a line in the "[Driver]" section. You may choose the driver id randomly, as long as the identifier follows the 3-dot scheme and is unique acroos all your drivers.

- Identify the simulator, where you want the data to be imported in the "[General]" section. You can omit the *Creator* and *Origin* settings.

- Describe the contents of each of your CSV file in the "[Schema]" section. As mentioned above, you can omit fields, for example the *Temperature.Track*, if not available. The values will be set to *Null* during the import, but whether you can work with this data afterwards, is not guaranted. You must provide the *Driver* field, though, otherwise the import will fail.

Then start the "Session Database", select the target simulator and run the import as described [above](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#administration).

#### Database Configuration

Normally, the database is located in the *Simulator Controller\Database* folder in your user *Documents* folder. You can move the database to another location on your PC, and you also can synchronize most data objects with those of other drivers in your team, as long as all of you are using the [Team Server](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Team-Server). To change the database configuration, click on the small button with the cog wheel in the upper right corner. The following window appears:

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Session%20Database%2014.jpg)

In the first field, you can define the location of the database on your local PC. Doing this, you can move your own database folder to another location, or you can switch temporarily to another database, for example to look at the data of a friend or team mate. If you change this location and leave the dialog with "Ok", you will be asked, if you want to transfer all your current data to the new location, or if you want to use the new database folder as it is. Please note, that as long as you configured your database to a location of a copy of a *foreign* users database, no data will be collected in order to prevent disorder.

In the lower area of the window, you can configure one or more connections to Team Servers, which allow you to synchronize all kinds of *your* data to a central database and also replicate the same kind of data of all your team mates from the central database to your local database. Very helpful for data analysis, strategy development and stint planning in endurance races.

To enable data synchronization, click on the "+" button to create a new entry and then tick the corresponding check boxes for the desired data categories and enter the login credentials (Server URL and access token), which you will normally get from the team manager (see the corresponding [documentation](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Team-Server#managing-teams) for more information), which is responsible for this Team Server. Once you have entered the credentials, you can click on the small button with the key to check, whether a valid connection to the synchronization service can be established. If a data connection is no longer needed, you can remove it with "-" button and using the "<" and ">" buttons, you can switch between all currently configured data connections.

You can also set the synchronization interval here. Using higher values will decrease the load on the connected Team Servers, but in general it will be fine to use the default value of 10 minutes here.

If you want to rebuild your local database, for example, after losing all your data due to a harddisk problem, you can click the "Rebuild" button. This will reload all data, which is available to you. Since pushing this button will trigger a complete and very time consuming re-synchronization, use it only in *emergency* situations.

Please note, that the initial synchronization might take quite a while (up to a couple of hours), depending on the amount of data in your local database, but also depending on the amount of data available by your team mates. The synchronization will run in the background without any further user interaction. The background process is automatically started by "Simulator Startup". Once, the initial synchronization is finished, the incremental update of your database will take only a few seconds and happens in the interval mentioned above.

Final note: Once you have changed the database location or the synchronization settings, you will be prompted to restart all applications of Simulator Controller.

##### Data privacy

It is important to understand, that in all cases only data that you created yourself, will be replicated to a central database in a Team Server. This protects the personal rights and copyrights of other drivers. Although you will receive all data from all other team members, this data will never be replicated back to any (other) Team Server. So, if you switch teams, for example, the data replicated from your former team will still be available in your local database, but it will not be synchronized with the central Team Server database of your new team.

## Technical information

This section will give you some background information about the inner workings of Jona. To understand the most of it, you need some background knowledge about programming. Therefore, if you never have coded just a tiny bit, you can safely skip this section.

The most important part of Jona, beside the natural language interface, which has been described above, is the rule engine and the knowledgebase, the rules work with. The major part of the knowledgebase consists of a history of past events, which is used by the rules to give Jona a kind of memory and allows the bot to interact in a context-sensitive manner. The history is also used by the rules to infere future trends, for example, a projection of target tyre pressures for long stints in an evening session, when the air and track temperatures are falling. Past and future weather trend information will be integrated as well, when they are available. Jona is able to recommend whether a repair of a damage be worth of for the next pitstop by calculating the historic impact of the damage on your lap time, and so on. Not all of this has been implemented completely in the alpha version of Jona, but the genetics are all there.

Below you will find some information about the rule engine and the knowledge base, although this is not a complete documentation at all for the moment.

### The Rule Engine

The rule engine used for Jona is a so called hybrid rule engine, which means, that rules can derive new knowledge from given knowledge, called forward chaining, or rules can be used to prove a hypothesis by reducing it to more and more simple questions until all those question has been answered or no more possibilities are available, which means, that the hypothesis is considered to be false. This is called backward chaining and the most prominent representative for this kind of logical computation is the programming language Prolog.

Jonas forward chaining rules look like this:

	{All: [?Pitstop.Plan], [?Tyre.Pressure.Target.FL]} =>
		(Set: Pitstop.Planned.Tyre.Pressure.FL, ?Tyre.Pressure.Target.FL),
		(Set: Pitstop.Planned.Tyre.Pressure.FL.Increment, !Tyre.Pressure.Target.FL.Increment)

This rule, for example, is triggered, when a new pitstop plan had been requested (*[?Pitstop.Plan]*) and when at the same time a target pressure for the front left tyre had been derived (typically by another rule). The rule above then *fires* and thereby copies this information to the pitstop plan.

A backward chaining rule is typically used for calculations and looks like this:

	updateRemainingLaps(?lap) <=
		remainingStintLaps(?lap, ?stintLaps), remainingRaceLaps(?lap, ?raceLaps),
		?stintLaps < ?raceLaps, Set(Lap.Remaining, ?stintLaps)

	lowFuelWarning(?lap, ?remainingLaps) <= pitstopLap(?lap), !, fail
	lowFuelWarning(?lap, ?remainingLaps) <= Call(lowFuelWarning, ?remainingLaps)
	
In this example, the rule *updateRemainingLaps* calculates the number of laps, which remains with the current amount of fuel. Or, as an alternative route, it might consider the remaining stint time of the current driver. The result is then updated in the memory as the *Lap.Remaining* fact, which might trigger other rules. One of these rules might then invoke *lowFuelWarning*, the second part of the example above. This rule calls the external function *lowFuelWarning*, which in the end let Jona call you and tell you, that you are running out of fuel. As you can see by the first instance of the rule *lowFuelWarning*, this call is only issued, when the current lap (*?lap*) is not a lap, where the driver has pitted.

You can find the rules of Jona in the file *Race Engineer.rules* which resides in the *Resources\Rules* folder in the installation folder of Simulator Controller. As always, you are able to overwrite this file by placing a (modified) copy in the *Simulator Controller\Rules* folder in your user *Documents* folder. This might be or might not be a good idea, depending on your programming skills in logical languages.

### Interaction States

At this time, Jona can handle three important states in its knowledge base.

  - A pitstop has been planned
  - A pitstop has been prepared, which means that all the settings had been transferred to the simulation game, for example to the Pitstop MFD of *Assetto Corsa Competizione*
  - The car is in the pit and the crew is working on the car
  
You can trigger the first two states, as long as logical for the given situation, by setting the facts *Pitstop.Plan* or *Pitstop.Prepare* to *true* in the knowledge base. The rule network will do the rest. An undertaken pitstop must be triggered by setting *Pitstop.Lap* to the lap number, where the driver pitted. All this is handled by the *RaceEngineer* class already, so there is no need to do this at the knowledge base level. But it is important to know, that these states exist, in order to undertstand Jonas reactions to your requests. For example, Jona first wants to plan a pitstop before you enter the pit, which is quite logical, right?

### Jonas Memory

The content of the knowledgbase of Jona or the facts, as these are called in the world of rule engines, can be divided into three categories:

  - *Historical information:* Here, all recent laps and pitstops are memorized to build a base of historic data for trend anlysis.
  - *Derived future information:* In this category fall the state information described above, for example the projected settings for the next pitstop.
  - *Real working memory:* Jona constantly calculates future trends and events, like low fuel in a few laps. These projected values are stored in the memory as well.
  
For historical information, the format is quite simple. All facts for a past lap start with *Lap.X* where X is the lap number. A similar format is used for pitstops, *Pitstop.X*, where X is the pitstop number here. Normally you will have more laps than pitstops in the memory, except you are me in a reverse grid league race, hey?
The derived future information is typically categorized by the first part of the fact name, for example *Tyre* for all knowledge about the current and projected tyre state.

You can take a look at the knowledge base by enabling "Debug" mode in the configuration, as described in the [Troubleshooting](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#troubleshooting) section. By doing this, you will pay a performance penalty, which might or might not be noticeable depending on your hardware.

### Telemetry Integration

A considerable part of the knowledge of Jona comes from the telemetry information of the simulation game. As said, data providers for *Assetto Corsa*, *Assetto Corsa Competizione*, *RaceRoom Racing Experience*, *rFactor 2*, *iRacing*, *Automobilista 2* and *Project CARS 2* are already builtin. The special plugin "Race Engineer" collects the data from the simulation games and hands it over to Jona. Small applications like "ACC SHM Provider.exe" or "RF2 SHM Provider.exe", which are located in the *Binaries* folder, are used to acquire the data. They run periodically and output the following data:

	[Car Data]
	BodyworkDamage=0, 0, 0, 0, 0
	SuspensionDamage=0, 0, 0, 0
	FuelRemaining=54.6047
	TyreCompound=Dry
	TyreCompoundColor=White
	TyreTemperature=84.268, 74.6507, 85.6955, 77.2675
	TyrePressure=27.6296, 27.6063, 27.6666, 27.5575
	Map=1
	TC=2
	ABS=3
	[Stint Data]
	DriverForname=The
	DriverSurname=BigO
	DriverNickname=TBO
	Sector=2
	Laps=3
	LapLastTime=116697
	LapBestTime=116697
	StintTimeRemaining=1.41874e+06
	DriverTimeRemaining=1.41874e+06
	InPit=false
	[Track Data]
	Temperature=25.5913
	Grip=Optimum
	[Setup Data]
	TyreCompound=Dry
	TyreCompoundColor=White
	TyreSet=2
	FuelAmount=0
	TyrePressureFL=25.3
	TyrePressureFR=26.6
	TyrePressureRL=25
	TyrePressureRR=26.2
	[Weather Data]
	Temperature=22.9353
	Weather=Dry
	Weather10min=Dry
	Weather30min=Dry
	[Session Data]
	Active=true
	Paused=false
	Session=Race
	Car=mclaren_720s_gt3
	Track=Paul_Ricard
	FuelAmount=125
	SessionFormat=Time
	SessionTimeRemaining=1.41874e+06
	SessionLapsRemaining=9

The shared memory of the simulation games typically provide a lot more information, but this is all that is needed for Jona at the moment. Future versions of Jona will incorporate more data, as Jona gets smarter. For example, version 1.7 of *Assetto Corsa Competizione* introduced updated information for weather information and the current settings of the Pitstop MFD, which had been incorporated into the above telemetry file.

The "Race Engineer" plugin writes this information to a temporary file and hands it over to Jona for each new lap. A special case is the flag *InPit*. If this is found to be *true*, the driver is currently in the pit. In this case, the ACC plugin informs Jona about this by raising the corresponding event. Another special case is the flag *Active* which is used to detect, whether you are in a simulation (Practice, Qualifying, Race, whatever) right now. Not every simulation may provide all data as in the example above. In this case, a default value will be assumed.

The *[Setup Data]* section reference the settings at the start of the session and must only be written by the data provider, if the *-Setup* option has been passed to the process. These information are ussed in the pitstop preparation process and also by the *Race Settings* when importing the initial setup data.

Note: If you are a developer and want to take the challenge to adopt Jona to a different simulation game, you are welcome. You can use the "RF2" plugin code and the above file format as a blueprint, but the shared memory interface of each simulation game is different. Please feel free to contact me, if you have questions. I would be happy to integrate plugins for other simulation games into Simulator Controller in the future.

## Troubleshooting

The biggest hurdle to overcome when using Jona, is to find a satisfying setting for voice recognition. Here are some hints:

  - I strongly recommend to use a head set. Although it is possible, and I have tested it myself, to talk to Jona using a desktop or webcam microphone, it is hard to find a satisfying setup. Typically, you will get a couple of false positives in this scenario, while the V12 sound from the Aston Martin is hammering from the speakers. You have been warned...
  - Even when using headset, you might get false positives. The reason for that, normally is a too sensitive microphone level. Reduce the input level of the microphone as low as possible in the Windows audio devices settings, so that Jona still recognizes your spoken words, but does not interpret your sighs and breath noises as valid input.
  - If voice recognition is not working at all, you might need to unblock the DLLs. Follow the instructions in the [installation section](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#installation-of-speech-recognition-libraries) above.
  - Although it is very helpful to be able to talk to Jona anytime, you might consider to use the *Push To Talk* functionality introduced with release 2.4. Please consult the corresponding [documentation](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#tab-voice-control) on how to configure this feature, which will eliminate false positives almost completely.
  - Most important: Learn the phrases, which are defined as input for Jona. Sometimes, only a somewhat different pronounciation is needed, and everything is fine. As a last line of defence, define your own input grammar as described above in the section about [phrase grammars](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#phrase-grammars). But doing this will make your upgrade path for future versions much more complicated.

It has been reported, that the system sound volume gets sometimes significantly reduced, when voice recognition is active. In most cases, it will help to enable [*Push To Talk*](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#tab-voice-control), since the sound volume reduction should then only happen while you are holing down the *Push To Talk* button. If this does not help, you can try to uncheck the sound enhacement option in the properties dialog of your select Microphone, but you might encounter reduced recognition quality afterwards.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Microphon%20Properties.JPG)

Beside that, when you encounter false recommendations from Jona, you might take a look into the brain of Jona to see, why Jona arrived at those conclusions. You can do this by enabling "Debug" mode in the configuration. In the next run, Jona will periodically dump its knowledge to the file "Race Engineer.knowledge" in the folder *Simulator Controller\Temp* that resides in your user *Documents* folder. If you think, that you have found a bug in Jonas behaviour, it would be very helpful for me, when you attach this file to any reported issue.

And, last but not least, you might have a problem with the Shared Memory Reader for a simulation game. Please check, if files named "Race Engineer Lap X.Y.data" (where X and Y are consecutive running numbers) exists in the *Simulator Controller\Temp\XXX Data* folder (where XXX is the three letter short code for the simulation), which is located in your user *Documents* folder. Use a text editor to check whether these files have a content as shown a bove in the section about [telemetry integration](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#telemetry-integration). If these files do not exist or haven't a meaningful content, you might try a complete reinstall.

If you still have problems with voice recognition, you might try this combination:

  1. Disable voice recognition by supplying *raceAssistantListener: false* as argument for the ["Race Engineer" plugin](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-race-engineer).
  2. Configure all necessary options you want to use for the ["Pitstop" mode](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#mode-pitstop) for example for the ACC plugin, especially for the *pitstopCommands* *PitstopPlan* and *PitstopPrepare*.

With this setup, Jona will be there and inform you about low fuel, damages and so on, but you have to use the Button Box to initiate pitstop planning and preparation. You will miss out all the eloquent conversations with Jona, but functionality wise, you are almost on par.