# ZiphyCheck

An app intended to help with auditing tasks.

Welcome to ZiphyCheck! This app's main purpose is to help you perform common routine checks and report them as a simple text you can send to anyone via email, messaging apps, and others.

# Features

- Simple interface with ease to pick up in mind
- Easy to set up
- Customizable in nature (Create your own reports, objects, and checks instead of using a predefined template)
- Data can be exported as JSON files and imported later on

# How the object hierarchy works

### Reports

In ZiphyCheck, the highest structure you can have is a **report**. Reports define what exacly you are checking. Some examples include: IT Infrastructure, computer labs, pre-event checklists that involve checking multiple objects individually, among others.

### Locations

Reports are composed of **Locations**, and these, of **Objects**. Locations conveniently separate your objects into each palce they're stored in. These could be different rooms, buildings, or anything physically distant that can't be checked at the exact same time as other objects from other locations.

### Objects & Object types

**Objects**, on the other hand, define *the specific physical or abstract objects* that you are checking ("PC 1", "PC 2", "PC 3", and so on). Each object has a type, referred to as an **Object Type** (in the previous example, "PC"). Differently from objects, object types (which are configured separately from the individual reports, since they can be reused in different reports) define *what* those objects are -- are they computers, subwoofers, light bulbs, televisions, etc. -- and what checks should be done to them. Each object that is linked to an object type automatically inherits all checks assotiated with that type.

### Checks

At the lowest end of the hierarchy, there are **Checks**. Checks define something that should be checked about an object, ideally phrased as a question, which can be answered by the user as either "YES" or "NO". Examples include: "Is the monitor OK?", "Is sound calibrated?", "Are the image settings set correctly?" and others. When defining a check, you can define a set of common issues the user can select to specify what the specific problem was. For instance, if a user answers "NO" in a check "Is the computer turning on?", default fail options could be: "Power supply is dead", "Power outlet damaged", "Switch was just turned off", and others. 

When giving a "NO" answer to a check, the user can also specify notes related to their issue, provide an entirely different problem description, and also mark the issue as resolved.

# How to install

Installing is simple:

## Android

Simply [visit the latest release page from this link](https://github.com/GabPSS/ziphycheck/releases/latest) or the Releases panel on the right side of this description, then download the appropriate `.apk` file. 

Once downloaded, open it up and follow through the dialog to allow it to be installed, and follow the remaining instructions to install it onto your device

## Web

Alternatively, if you wish to try it out on any other devices and have skills in setting up web servers, you can download the zip file containing the web version of the app that can be hosted onto servers of your choosing (make sure to ajust the base path in `index.html` if you are placing it on a subdirectory under your root page!)

# Building the program yourself

This project is Flutter-based, so if you want to build it yourself, you will need to download and install the [Flutter SDK from their website](https://docs.flutter.dev/get-started/install). Once downloaded and with everything set up, simply clone this repository via git and run `flutter build apk --release` (replace `apk` with whatever platform you're building for)

# Open source

This project is Open Source -- feel free to contribute to it if it has helped you!
