# Simulator Controller

Simulator Controller is a modular and extendable administration and controller application for Sim Racing. At the core is a comprehensive plugin capable automation framework, which can use almost any external controller hardware, such as Button Boxes, to control typical simulator components such as SimHub, SimFeedback and alike. Beside that, Simulator Controller also comes with several voice chat capable Assistants, which are based on artificial intelligence technologies. The first, a kind of Virtual Race Engineer, will assist you during your races to keep the hands on the wheel. It will handle all the cumbersome stuff, like preparing a pitstop, take an eye on the weather forecast, calculate damagae impact on your lap times, and so on. The second Assistant, a Virtual Race Strategist, will keep an eye on the overall race situation and will develop and adapt strategies depending on race position, traffic and weather changes. The next assistant, a Virtual Race Spotter will watch over your race and will warn you about crtical situations with nearby cars, and so on. Last, but not least, a Virtual Driving Coach will be your invaluable source for information about car handling and everything, you want to know about racing in the real world or in a simulation.

Beside that, Simulator Controller brings even a bunch of other functionality and features to make the life of all of us virtual racers even more fun and simple. You will find a [comprehensive overwiew](https://github.com/SeriousOldMan/Simulator-Controller#main-features) of all features later in this document, but first things first...

### Donation

If you find this tool useful, please help me with the further development. Any donation contributed will be used only to support the project.

[![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate?hosted_button_id=7GV86ZPS95SL6)

Another possibility is to use [Patreon](https://www.patreon.com/simulatorcontroller) to give me a hug, and as a benefit, you might get access to the public Team Server for your multiplayer endurance races.

Thank you very much for your support!

### Download and Installation

Installation is very easy. For first time users I recommand using the automated installer below. But there are different download and installation options available. Please see the complete documentation on [Installation & Configuration](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration), where you also will find a quick start guide for new users, for more information.

#### Antivirus Warnings

The programming language used for building Simulator Controller uses some really nasty tricks to control Windows applications, tricks also used by malware. Therefore, depending on your concrete Antivirus program, you may get some warnings regarding the Simulator Controller applications. I can assure you, that there's nothing about it. But you can read about these issues in the forums of [AutoHotkey](https://www.autohotkey.com/) itself. If your Antivirus programm allows exception rules, please define rules for the Simulator Controller applications, otherwise you need to have a beer and search for another Simulator Controller tool. Sorry...

If you don't want to use the automated installer (or you can't cause of your Antivirus protection), you can manually install one of the versions below. There are separate download links for the current development build and at least the two latest stable releases. Download one of these builds and unzip it anywhere on your hard disks. Beginnging with Release 3.5.2, you then need to run the "Simulator Tools" application in the *Binaries* folder. This will guide you through the remaining installation process. For release information, even for a preview on upcoming features in the next stable build, don't miss the [Release Notes](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Release-Notes).

#### Automated Installer

Simply download and run [Simulator Controller.exe](https://simulatorcontroller.s3.eu-central-1.amazonaws.com/Simulator+Controller.exe) (you may have to deactivate your Antivirus or Browser download protection). This small application will connect to the version repository and will download and install the latest version automatically for you. If you want to install a version other than the current one, no problem. This is possible by downloading and installing one of the versions below manually, but consult the [documentation](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#installation) beforehand.

Here is a short video which shows how to configure Simulator Controller for the first time with a few clicks:

[![](https://img.youtube.com/vi/qLMYz1FkEGs/0.jpg)](https://youtu.be/qLMYz1FkEGs)

#### Latest release build

VERY IMPORTANT (for users with an already configured installation of Simulator Controller):
An automated update mechanism for local configuration databases exists since Release 2.0. Please read the [information about the update process](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Update-Notes) carefully before starting one of the Simulator Controller applications. It might also be a good idea, to make a backup copy of the *Simulator Controller* folder in your user *Documents* folder, just to be on the safe side. Also, if you have installed and used a prerelease version, it will be necessary to rerun the automatic update. Please consult the documentation mentioned above on how to do this.

[5.6.4.0-release](https://cutt.ly/Bw3ggKYy) (Changes: Fixed pitstop and pitlane detection for iRacing, Fixed green flag regression, Invalid laps for iRacing, Default for "Pitstop Tyre Service" is now recognized for iRacing, Fixed memory leak in iRacing connector, Fixed Track Mapper for iRacing, Changing tyre compounds support for iRacing, Fixed "Simulator Setup" support for "Le Mans Ultimate", Fixed spanish voice recognition, Fixed track map periodic update in "Race Center", Accident detection now also for ACC, "Practice Center" informs about unsaved data before starting a new session, Increased iRacing position data reliability, Migrated to AHK 2.0.12, Updated meta data for R3E.)

Please read the [Release Notes](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Release-Notes) and - even more important - the release specific [Update Notes](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Update-Notes#release-564) of this version and all the versions you might have skipped, before installing and using this version.

##### Earlier release builds

[5.6.3.2-release](https://cutt.ly/uw2o3Euu) (Changes: Added customizing for "Simulator Setup", Initial support for rain and track wetness for iRacing, Spotter informs about accidents and slow cars, Extended configuration for the Spotter in "Simulator Setup" and "Simulator Configuration", Extended announcements voice command for Spotter, New settings in the "Session Database" to define the distance for slow cars and accidents.)

[5.6.2.0-release](https://cutt.ly/Pw1nfWZ2) (Changes: New startup logging, Strategy recalculation now incorporates completed pitstops for validation, Pitstop window as well as refuel and tyre rules relate only required pitstops, Settings export file format in "Session Database" fixed, Fixed import settings in "Session Database", Increased reliability of opponent pitstop information in "Race Center", Choice for car indication by the Spotter, The Spotter now interrupts itself more often, Import of team specific settings as a special preset in "Simulator Setup", Improved car name parsing fo Le Mans Ultimate.)

#### Latest development build

None for the moment...

### Documentation

A very [extensive documentation](https://github.com/SeriousOldMan/Simulator-Controller/wiki) of roughly 400 pages will guide you through the configuration process and will help you to understand the inner concepts and all the functions & features of Simulator Controller. For developers, who want to create their own plugins, a complete [developers guide & reference](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Development-Overview-&-Concepts) is available as well.

The markdown files, the so to say source code of this documentation Wiki, can be found in the [Docs](https://github.com/SeriousOldMan/Simulator-Controller/tree/main/Docs) folder.

### Video Tutorials

Beside the quite extensive documentation (more than 500 pages - I know, nobody reads documentation these days), we also have a list of video tutorials, which are recordings of live coaching session in our Discord community.

1. [Quick start guide](https://youtu.be/qLMYz1FkEGs) - This video shows you how to create your first running configuration with a few clicks.

2. [Setup and Configuration](https://youtu.be/1XFvWhg2cPw) - You will learn a lot about the general setup and configuration of the Simulator Controller suite. The Setup Wizard "Simulator Setup" is introduced, but we will also take a look at the low level configuration tool "Simulator Configuration".

3. [Managing Button Boxes and Stream Decks](https://youtu.be/wPUnjViU15U) - Here we go a lot more into the details how to configure your available hardware controllers like Button Boxes, Stream Decks and Steering Wheels.

4. [Voice Control](https://youtu.be/u_2cIrZ1zFk) - In this session you will learn the capabilities of voice control, beginning with the simple standard configuration up to a full configuration with individual names, voices and languages for all the different Assistants.

5. [Pitstop Automation using Race Engineer](https://youtu.be/V35v0Be2nUE) - We will take a look at pitstop automation using the Race Engineer. You will learn everything about the necessary configuration and see and hear the Race Engineer in action on the track.

6. [Managing Settings](https://youtu.be/Pdwpbfadd5g) - This video gives an introduction into the settings used by the Virtual Race Assistants and how to manage these settings in the most efficient way.

7. [Using Strategy Workbench](https://youtu.be/rDlMWS5mbOM) - In this video we take a walk in "Strategy Workbench", the premium fuel calculator of the Simulator Controller suite. You will also learn, how to use the created strategies in "Race Center" and using the Virtual Race Assistents.

8. [Introduction to Team Races](https://youtu.be/R-6mRwMv81I) - In this video, all the functionality of the Simulator Controller suite come together to manage and control your team races. You will learn how to setup everything, how to use the services of the Race Assistants during a team race and how to remote control the pitstop settings for the currently driving team mate.

9. [More about the Race Assistants](https://youtu.be/AWJe7mZC2UI) - After learning a little bit here and there about the Race Assistants in the last videos, this one is completely dedicated to the Race Assistants.

10. [Working with the Setup Workbench](https://youtu.be/TqkMvOB0UWI) - The Setup Workbench is a tool which helps you with your car setup work. It takes your handling problems and comes up with recommendations how to fix those. For a couple of simulators, setup files can loaded, modified and written back after automatically having applied the recommendations.

11. [Working with data from multiple Drivers](https://youtu.be/TK-TMtd1W9o) - This time you will learn how to work with data from multiple drivers in your telemetry database and how to create team strategies from this data. You will also see, how you can export and import data from and to your telemetry database.

12. [Track Mapping and Track Automation](https://youtu.be/QWJyUYdjlFg) - This video shows you how to create a track map for any track in any simulator and where you can use these track maps. A special usage is the automation of in-car settings like traction control or ABS depending on your location on the track, which will be demonstrated on-track at the end of the video.

13. [Tyre Compounds and Weather Model](https://youtu.be/KFyhVuqojVk) - This session covers the handling of simulator specific tyre compounds. You will learn how to configure the available compounds for your car of choice and we will take a look at the weather model of Simulator Controller and learn how this is used together with the tyre compounds in strategy simulations.

14. [Team Data Replication](https://youtu.be/KgZ86YIBMOQ) - This video shows you how to share telemetry and other data in your team using the Team Server. This data can then be used to create team strategies or lookup tyre pressures for an unplanned pitstop in a team race and so on.

15. [Analyzing Driving Style and Handling Issues](https://youtu.be/UmXMKMpGOkk) - This video shows you how to use the all new telemetry analyzer, which will automatically detect handling issues of your setup (or your driving style) while you are driving. The handling issues can then be transferred to the Setup Workbench to create a modification of the car setup.

16. [Expert guide to race settings](https://youtu.be/UeD397KFEhg) - This video will give you a complete overview over all the settings used by the Race Assistants, for example all the stuff needed by the Race Engineer to handle a successful pitstop in even the worst conditions.

17. [Create your own voice commands](https://youtu.be/QJtKu3I75Vs) - In this video you will learn how to define your own voice commands to control not only any part of Simulator Controller, but also all functionalities of  your simulation games.

18. [Strategy Development Revisited](https://youtu.be/nEmH_RbX8hg) - This video covers a couple of new capabilities for strategy development and handling during the race including a demonstration in ACC.

19. [Race handled fully by AI](https://youtu.be/MlbAESpzg7Q) - This video gives you a full demonstration of a race under complete control of the AI Assistants. No driver interaction was necessary during this 3-stint race. Fully supported in solo as well as in multi player team races.

20. [Defining custom Button Box Modes](https://youtu.be/CqXcjTRoLpE) - This video demonstrates how you can define your own Button Box layers with custom commands.

21. [Unboxing Practice Center](https://www.youtube.com/watch?v=Qx3I0B8AvhQ) - We are taking a detailed look at the "Practice Center", which lets you organize your practice sessions and solo races, as well as the data collected during those sessions.

22. [Updating your configuration to 5.3](https://youtu.be/f4HuUjSW-3k) - This video shows you how to update your configuration to use the new capabilities of "Simulator Setup", which simplify many configuration tasks significantly.

23. [Your personal Driving Coach](https://youtu.be/LBtLk_md1IE) - Demonstrates a general interaction with Aiden, the Virtual Driving Coach.

24. [Car meta data](https://youtu.be/oKq8k9VZ2jU) - This video introduces you to car meta data and all the secret knowledge needed when extending the "Setup Workbench" for modded cars.

25. [Using the Startup Profiles](https://youtu.be/2L0lH8J1Cac) - This video explains the Startup Profiles in detail, which let you define configuration and enable or disable many important functions for different types of sessions.

26. [Strategy Development Revisited again](https://youtu.be/rCnYFTLX2L4) - This video will take another look at the "Strategy Workbench" and demonstrates a couple of new options, which allow you to create very special strategies.

This list will be extended from time to time to cover new functionalities.

### Discord Community

If you want to become a part of the small and very young Community for Simulator Controller on Discord. Here you will also find a large collection of FAQs and you will be able to attend live coaching sessions each Monday. Please use [this invitation](https://discord.gg/5N8JrNr48H) to join the Discord Server.

### Main features

  - Connect all your external controller, like Button Boxes, Stream Decks, and so on, to one single center of control
    - An unlimited number of layers of functions and actions, called modes, can be defined for your controller. Switch between modes simply by pushing a button or switch a toggle on your controller. Here is an example of several layers of functions and actions combined in five modes:
	
	![](./Docs/Images/Button%20Box%20Layout.jpg)
	
	- Modes are defined and handled by [plugins](https://github.com/SeriousOldMan/Simulator-Controller#included-plugins), which can be implemented using an object oriented scripting language.
  - Configurable, visual feedback for your controller actions
    - Define your own Button Box visual representation and integrate it with the Simulator Controller using the simple plugin support and a graphical layout editor. Depending on configuration, the Button Box window will popup whenever an action is triggered from your controller, even during active simulation, or it might stay open all the time, if you have anough screen space, for example a second monitor.
    
    ![](./Docs/Images/Button%20Box%202.JPG)
    
    - Code your own functions to be called by the controller buttons and switches using the simple, object-oriented scripting language
  - Configure all additional [applications](https://github.com/SeriousOldMan/Simulator-Controller#third-party-applications) to your taste, including the simulation games used for your virtual races
    - Start and stop applications from your controller hardware or automatically upon configurable events
    - Add splash screens and title melodies using a spedial editor for a more emotional startup experience
    - Full support for sophisticated application automation - for example, start your favorite voice chat software like TeamSpeak and automatically switch to your standard channel 
  - Several plugins are supplied out of the box:
    - Support for *Assetto Corsa*, *Assetto Corsa Competizione*, *rFactor 2*, *Le Mans Ultimate*, *iRacing*, *Automobilista 2*, *RaceRoom Racing Experience*, *Project CARS 2* and *Le Mans Ultimate* is already builtin, other simulation games will follow, when they become available
    - Fully customizable plugins supplied for total control of SimHub and SimFeedback - change your settings while racing using the dials and switches on your favorite Button Box
	- Control the calibration curves of your high end pedals by a simple button press with the plugin for the Heusinkveld pedal family
    - Send your predefined kudos and rants to the ingame chat without touching the keyboard
  - Additional support to trigger every function and action from external sources like a voice or gesture recognition software to always keep your hands on the wheel
  - Builtin support for visual head tracking to control ingame viewing angle - see [third party applications](https://github.com/SeriousOldMan/Simulator-Controller#third-party-applications) below

#### AI powered Virtual Race Assistants

Simulator Controller offers a virtual pit crew based on an AI powered chatbot engine. At the heart of this engine is hybrid rule engine coupled with voice recognition and voice synthesis. A rule engine is very suitable for the tasks of a typical pit crew, since all actions are event based and use big amounts of data.

According to the maturity scale of *attractive.ai* (one of several hundreds maturity models that can be found on the net), the Race Assistants of Simulator Controller are at level 2.5. The observe your racing, can give recommendations and take responsibilty for certain tasks like strategy management and pitstop planning and preparation.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/AI%20Maturity%20Levels.png)

##### Driving Coach

The Assistant is based on text-based GPT technology and uses a publically available large language model which has been trained with vasts amount of information. Using this knowledge, this Assistant behaves as your personal driving coach. Although the Driving Coach is not a part of your active crew, you can ask him anything about racing, car handling and driving techniques and you will probably will get an interesting answer.

Click on the picture to hear an actual conversation with the Driving Coach:

[![](https://img.youtube.com/vi/LBtLk_md1IE/0.jpg)](https://youtu.be/LBtLk_md1IE)

The Virtual Driving Coach can use LLM runtimes of OpenAI or Azure, but if your PC is powerful enough, you can also use an integrated runtime for a variety of LLM architectures, like Llama, Falcon, Mistral, GPT, and so on, as long as they are available in [GGUF format](https://github.com/ggerganov/ggml/pull/302).

##### Race Engineer & Race Strategist

An AI based Race Engineer with fully dialog capable voice control will guide you through your race, warn you about critical technical issues and will help you with the pitstop, whereas the Race Strategist keeps an eye on the race positions, develops a pitstop strategy, and so on. These smart chat bots are independent applications, but are integreated with the ACC and other simulation game plugins using interprocess communication right now. An integration for a new simulation games requires some effort, especially for the necessary data acquisition from the simulation game, but a knowledged programmer can manage it in about three to four hours.

Based on the data sets, that are acquired during your sessions by the Virtual Race Assistants, a very flexible tool allows you to [analyze your performance](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Strategist#race-reports) and the performance of your opponents in many different ways.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Race%20Reports%202.JPG)

Another capability of the Virtual Race Strategist is to support you during the [development of a strategy](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Strategist#strategy-workbench) for an upcoming race using the telemetry data of past sessions on the same track in similar conditions.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Strategy%20Workbench.JPG)

You can even use all these functionalities during multiplayer team races using the [*Team Server*](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Team-Server), which handles the state and knowledge of the Race Assistants and share this information between all participating drivers. The Team Server is the backend for the so called "Race Center", a console, which can be used by any team member (even if not an active driver) to gather all kind of session data and remote control various aspects of the session, for example the settings for an upcoming pitstop.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Race%20Center%201.JPG)

##### Race Spotter

Simulator Controller also comes with a Virtual Spotter, which will keep an eye on the traffic around you and will warn you about critical situations. You can fully customize the information provided by the Spotter to your specific needs and taste.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Configuration%20Tab%2011.JPG)

Beside the typical duties of a Spotter, this Assistant is also able to automate various actions depending on your location on the track. For example, it can automatically reduce the traction control, when approaching a tight turn.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Session%20Database%2013.jpg)

#### Setup Workbench

Another very useful tool of the Simulator Controller suite is the Setup Workbench. This tool is based upon the AI technology which is used by the Race Assistants and generates recommendations for changing the setup options of a car based on handling problems described by the driver.

![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/Setup%20Workbench.jpg)

### Additional features

  - Configurable and automated build tool for developers
  - Sophisticated logging, tracing and debug support to track down any errors while developing your own plugins
  - Fully graphical configuration utilities
  
  ![](./Docs/Images/Settings%20Editor.JPG) ![](./Docs/Images/Configuration%20Editor.JPG)
  
  - Last, but not least, a versatile monitoring tool, which gives you insights into the current operation and the health state of all components

  ![](https://github.com/SeriousOldMan/Simulator-Controller/blob/main/Docs/Images/System%20Monitor%201.JPG)

Simulator Controller has been implemented to great extent in AutoHotkey, a very sophisticated and object-oriented Windows automation and scripting language, which is capable to connect keyboard and other input devices to functions in the script with a simple macro language. On the other hand, AutoHotkey also has a lot of robotics capabilities to automate software packages, which do not provide external APIs, by simulating mouse clicks and keyboard input. You can write your own plugins using the AutoHotkey language. To get you started, full source code for all bundled plugins with different complexity from simple to advanced is included.

You will also find a lot of C#, C++ and even C code for the low-level stuff like telemetry data acquisition or connecting to cloud services on the Azure cloud, for example. Here also, all the sources are open and free to use. Last, but not least, and not for the faint-hearted, there is a hybrid, forward and backward chaining rule engine used to implement the Virtual Race Assistants. It uses a modified RETE-algorithm to be as efficient as possible when using large numbers of facts.

### Included plugins

These plugins are part of the Simulator Controller distribution. Beside providing functionality to the core, they may be used as templates for building your own plugins. They range from very simple functional additions with only a small number of lines of code up to very complex behemoths controlling external software such as SimHub.

| Plugin | Description |
| ------ | ------ |
| [System](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-system) | Handles multiple Button Box layers and manages all applications configured for your simulation configuration. |
| [Button Box](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#button-box-layouts) | Tools for building your own Button Box / Controller visuals. The default implementation of *ButtonBox* implements grid based Button Box layouts, which can be configured using a [graphical layout editor](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#button-box-layouts). |
| [Stream Deck](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#stream-deck-layouts) | Tools for connecting one or more Stream Decks as external controller to Simulator Controller. A special Stream Deck plugin is provided, which is able to dynamically display information both as text and/or icon on your Stream Deck. |
| [Tactile Feedback](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-tactile-feedback) | Fully configurable support for pedal and chassis vibration using [SimHub](https://github.com/SeriousOldMan/Simulator-Controller#third-party-applications). |
| [Motion Feedback](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-motion-feedback) | Fully configurable support for rig motion feedback using [SimFeedback](https://github.com/SeriousOldMan/Simulator-Controller#third-party-applications). |
| [Pedal Calibration](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-pedal-calibration) | Allows to choose between the different calibration curves of your high end pedals directly from the hardware controller. |
| [Driving Coach](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-driving-coach) | This plugin integrates Aiden, the Virtual Driving Coach. If this plugin is active and correctly configured, this Assistant will be automatically available, when Simulator Controller is running. |
| [Race Engineer](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-race-engineer) | This plugin integrates Jona, the Virtual Race Engineer, with all other plugins for the simulation games, like the ACC plugin. The plugin handles the data transfer between the simulation game and the Virtual Race Engineer. |
| [Race Strategist](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-race-strategist) | This plugin integrates Cato, the Virtual Race Strategist, with all other plugins for the simulation games, like the ACC plugin. The plugin handles the data transfer between the simulation game and the Virtual Race Strategist. |
| [Race Spotter](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-race-spotter) | This plugin integrates Elisa, the Virtual Race Spotter, with all other plugins for the simulation games, like the ACC plugin. The plugin handles the data transfer between the simulation game and the Virtual Race Spotter. |
| [Team Server](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-team-server) | The *Team Server* supports using the Virtual Race Assistants even in a multiplayer team race. It is based on a serverside solution, which manages the state of the car and Assistants knowledge and passes them between the participating drivers. |
| [ACC](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-acc) | Provides special support for starting and stopping *Assetto Corsa Competizione* from your hardware controller. The mode "Chat", which is available when *Assetto Corsa Competizione* is currently running, handle automated chat messages for the multiplayer ingame chat system, where the chat messages can be configured by the [configuration tool](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Installation-&-Configuration#configuration). Additionally, beginning with Release 2.0, this plugin provides sophisticated support for the Pitstop MFD of *Assetto Corsa Competizione*. All settings may be tweaked with the controller hardware using the "Pitstop" mode, but it is also possible to control the settings using voice control to keep your hands on the steering wheel. An integration with Jona, the Virtual Race Engineer, with Cato, the Virtual Race Strategist and also with Elisa, the Virtual Race Spotter is available. The "Assistant" mode can handle most of the Race Assistant commands from your hardware controller. |
| [AC](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-ac) | Integration for *Assetto Corsa*, which supports  Jona, the Virtual Race Engineer, Cato, the Virtual Race Strategist and also Elisa, the Virtual Race Spotter. The plugin also supports a "Pitstop" mode for adjusting pitstop settings and a "Assistant" mode to interact with the Race Assistants. |
| [AMS2](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-AMS2) | Integration for *Automobilista 2*, which supports  Jona, the Virtual Race Engineer, Cato, the Virtual Race Strategist and also Elisa, the Virtual Race Spotter. The plugin also supports a "Pitstop" mode for adjusting pitstop settings and a "Assistant" mode to interact with the Race Assistants. |
| [IRC](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-irc) | This plugin integrates the *iRacing* simulation game with Simulator Controller. A "Pitstop" mode is available to control the pitstop settings from your controller hardware and an integration with Jona, the Virtual Race Engineer, with Cato, the Virtual Race Strategist and also with Elisa, the Virtual Race Spotter is available as well. The "Assistant" mode can handle most of the Race Assistant commands from your hardware controller. |
| [RF2](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-rf2) | Similar to the ACC and IRC plugin provides this plugin start and stop support for *rFactor 2*. A "Pitstop" mode is available to control the pitstop settings from your controller hardware and an integration with Jona, the Virtual Race Engineer, and with Cato, the Virtual Race Strategist is available as well. The "Assistant" mode can handle most of the Race Assistant commands from your hardware controller. |
| [R3E](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-rre) | Similar to the ACC, IRC and RF2 plugins provides this plugin start and stop support for *RaceRoom Racing Experience*. A "Pitstop" mode is available to control the pitstop settings from your controller hardware and an integration with Jona, the Virtual Race Engineer, with Cato, the Virtual Race Strategist and also with Elisa, the Virtual Race Spotter is available as well. The "Assistant" mode can handle most of the Race Assistant commands from your hardware controller. |
| RSP | Simple integration for Rennsport. No functionality beside starting and stopping from a hardware controller. |
| [PCARS2](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-PCARS2) | Integration for *Project CARS 2*, which supports  Jona, the Virtual Race Engineer, Cato, the Virtual Race Strategist and also Elisa, the Virtual Race Spotter. The plugin also supports a "Pitstop" mode for adjusting pitstop settings and a "Assistant" mode to interact with the Race Assistants. |
| [LMU](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-lmu) | Full support for *Le Mans Ultimate* incl. pitstop automation and integration of the Race Assistants. Functionality is identical to that of the plugin for *rFactor 2*, since *Le Mans Ultimate* is based on the same engine. |
| [Integration](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-integration) | This plugin implements interoperability with other applications like SimHub. |

### Third party applications

The following applications are not part of the distribution and are not strictly necessary for Simulator Controller. But Simulator Controller is aware of these components and will integrate them for a better overall experience, if available.

| Application | Description |
| ------ | ------ |
| [AutoHotkey](https://www.autohotkey.com/) | [Development Only] Object oriented scripting language. You need it, if you want to develop your own plugins. |
| [Visual Studio](https://visualstudio.microsoft.com/de/vs/) | [Development Only] Development environment for Windows applications. Used for the development of the different telemetry interfaces of the supported simulation games. |
| [NirCmd](https://www.nirsoft.net/utils/nircmd.html) | [Optional] Extended Windows command shell. Used by Simulator Controller to control ingame sound volume settings during startup. |
| [SoX](http://sox.sourceforge.net/) | [Optional] Audio processing utility. Used by the Race Assistants for audio post processing to achieve a team radio like audio quality. |
| [VoiceMacro](http://www.voicemacro.net/) | [Optional] Connects to your microphone and translates voice commands to complex keyboard and/or mouse input. These macros can be connected to Simulator Controller as external input to control functions and actions identical to your hardware controller. |
| [AITrack](https://github.com/AIRLegend/aitrack) | [Optional] Neat little tool which uses neural networks to detect your viewing angle on a dashcam video stream. Used in conjunction with opentrack to control your ingame viewing angle. |
| [opentrack](https://sourceforge.net/projects/opentrack.mirror/) | [Optional] Connects to your simulation game and controls the viewing angle using the freetrack protocol. Several input methods are supported, for example analog joysticks or UDP based sources such as AITrack. |
| [SimHub](https://www.simhubdash.com/) | [Optional] Versatile, multipurpose software collection for simulation games. Generates vibration using bass shakers or vibration motors and provides a fully integrated Arduino development environment. Additional features support the definition of custom dashboards. A special plugin is part of Simulator Controller to control the tactile feedback options of SimHub, such as vibration strength, with a touch of a button. |
| [SimFeedback](https://www.opensfx.com/) | [Optional] Not only a software, but a complete DIY project for building motion rigs. SimFeedback controls the motion actuators using visual control curves, which translate the ingame physics data to complex and very fast rig movements. Here also, a plugin is integrated in Simulator Controller to use your hardware controller for controlling SimFeedback. |
| [SFX-100-Streamdeck](https://github.com/ashupp/SFX-100-Streamdeck) | [Optional] This extension for SimFeedback is used to connect to SimFeedback in order to control effect states and intensities. If not used, a subset of the SimFeedback settings will be controlled by mouse automation, which on a side effect requires the SimFeedback window to be the topmost. Since this is not really funny, while currently trying to overtake one of your opponents in a difficult chicane, I strongly advice to install the connector extension, but this requires the *commercial* expert license for SimFeedback. You will find a copy of the *SFX-100-Streamdeck* plugin in the *Utilities\3rd Party* folder for your convenience. And don't forget to read the [installation & configuration instructions](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Plugins-&-Modes#plugin-motion-feedback), since there are two steps necessary. |
| [Microsoft Voice Languages](https://support.microsoft.com/en-us/office/how-to-download-text-to-speech-languages-for-windows-10-d5a6b612-b3ae-423f-afa5-4f6caf1ec5d3) | [Optional] Depending on your Windows version and your selected language, you might want to install additional *Text-to-Speech* languages from Microsoft for the speech generation capabilities of Simulator Controller, especially for Jona, the Virtual Race Engineer. |
| [Microsoft Voice Recognition](https://www.microsoft.com/en-us/download/details.aspx?id=16789) | [Optional] Also depending on your Windows version and your selected language, you might want to install additional *Speech-to-Text* or voice recognition languages from Microsoft, especially for Jona, the Virtual Race Engineer. You will find a copy of the language runtime and some selected recognizer in the *Utilities\3rd Party* folder for your convenience. |
| [rFactor 2 Telemetry Provider](https://github.com/TheIronWolfModding/rF2SharedMemoryMapPlugin) | [Optional] If you are running the *rFactor 2* or the *Le Mans Ultimate* simulation game and want to use Jona, the Virtual Race Engineer during your races, you need to install this data aqcuisition plugin in your *rFactor 2* application directory. You will find a copy of the plugin (named *rf2_sm_tools_3.7.14.2.zip*) including a Readme file in the *Utilities\3rd Party* folder for your convenience. Same applies to *Le Mans Ultimate* which is based on the same game engine. Take a look [here](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Virtual-Race-Engineer#installation-of-telemetry-providers) for installation instructions. |

### Known issues

1. Connection between the "Motion Feedback" plugin and *SimFeedback* has some stabilty issues. Looks like the root cause is located in the *SFX-100-Streamdeck* extension. For a workaround click on "Reload Profile..." on the Extensions tab in SimFeedback, if you see strange numbers in the Button Box "Motion" mode page.

### Development

For new features coming in the next release, take a look at the [Release Notes](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Release-Notes).

Want to contribute? Great!

  - Build your own plugins and offer them on GitHub or join the [Discord community](https://discord.gg/5N8JrNr48H) and post your plugin in the #share-your-mods channel. Contact me and I will add a link to your plugin in this documentation.
  - Found a bug, or built a new feature? Even better. Please contact me, and I will give you access to the code repository.

Heads Up: I am looking for a co-developer for some fancy upcoming AI stuff.

### To Do

After firing out one release per week during the last few weeks, the project will slow down a little bit from now on. But the development of Simulator Controller still goes on, and I am sure that we will end up in a two weeks cycle in the long run. My own list of ideas in the [backlog](https://github.com/SeriousOldMan/Simulator-Controller/wiki/Backlog) is always long enough for at least three more releases and if you want to propose a feature to be included in the backlog, you can open an enhancement issue on GitHub or join the [Discord community](https://discord.gg/5N8JrNr48H) and post your idea on the #request-a-feature channel...

### License

This software is provided as is. You are free to use it for any purpose and modify it to your needs, as long as you do not use it for any commercial purposes.

(2024) Creative Commons - BY-NC-SA - by Oliver Juwig (TheBigO)
