import QtQuick 2.8
import QtMultimedia 5.9
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15

import SortFilterProxyModel 0.2

import "Pages"
import "Pages/GameFlow"
import "BottomBar"
import "Extra"

FocusScope {

    //
    // Variables
    //

    id: theme
    focus: true

    // Version Number
    property string version: "0.3.0"

    // Just a shorthand for the screen width and height
    property int sw: theme.width
    property int sh: theme.height

    // Unstretch Factors (sw * usx = 1920)
    property real usx: 1920 / sw
    property real usy: 1080 / sh

    // Just a few fonts, needs [id].name to work in font.family
	FontLoader { id: display; source: "./assets/font/Outfit-Light.otf" }
	FontLoader { id: readtext; source: "./assets/font/Inter-Regular.ttf" }

	IconFont {
        id: icons
    }

    property var settings: {
        "theme": api.memory.has("theme") ? api.memory.get("theme") : "retro",
        "btnScheme": api.memory.has("btnScheme") ? api.memory.get("btnScheme") : "ps",

        "24hClock": api.memory.has("24hClock") ? api.memory.get("24hClock") : false,
        "light": api.memory.has("light") ? api.memory.get("light") : false,

        "a_gamebg": api.memory.has("a_gamebg") ? api.memory.get("a_gamebg") : true,

        "carousel_zoom": api.memory.has("carousel_zoom") ? api.memory.get("carousel_zoom") : 1,
        "carousel_up_menu": api.memory.has("carousel_up_menu") ? api.memory.get("carousel_up_menu") : true,

        "lang": api.memory.has("lang") ? api.memory.get("lang") : "en"
    }

    property var colorschemes: {
        "planet": {
            "light": {
                bg1: "#F2F6FF", // Used as the flat background color
                bg2: "#DBDFE7",
                bg3: "#BDC0C7",
                bg4: "#989ba1",
                mid: "#7c7f8e",
                text: "#16171A", // Used as the text color
                subtext: "#31333A",
                accent: "#74AAFF", // Used as the accent color (slider circles in settings)
                outline: "#000000",
                darkSurface: "#7C7f8e",
                bottomIcons: "#F2F6FF", // Used as the color of the bottom bar icons
                shadow: "#80000000",
            },
            "dark": {
                bg1: "#16171A",
                bg2: "#26282D",
                bg3: "#31333A",
                bg4: "#494D57",
                mid: "#7c7f8e",
                text: "#F2F6FF",
                subtext: "#BDC0C7",
                accent: "#74AAFF",
                outline: "#7c7f8e",
                darkSurface: "#000000",
                bottomIcons: "#F2F6FF",
                shadow: "#ff000000",
            }
        }
    }

    // Which colors to use right now
    // MODIFICATION TIP: Replace everything after "colors:" with the address of your colorscheme to use a custom color scheme, like so: colorschemes["mycolorscheme"]["dark"]
	property var colors: settings["light"] ? colorschemes["planet"]["light"] : colorschemes["planet"]["dark"]



	// Localization
	// Provides different languages to Library
	// Please check Localization.qml for more

	Localization {
		id: localizationData
	}

	// Get all languages
	property var langs: localizationData.getLangs()
    property var langNameMap: localizationData.getNameMap();
	// Alias for the object that is the localization's current language
	property var loc: localizationData.getLocalization(settings.lang)

    // Extra Data
    // Default box aspect ratios
    AspectRatios {
        id: defaultAspectRatios
    }

    // Missing image placeholders
    // Missing Box Art
    property url missingSource: "assets/placeholder/no_game.png"
    // Missing Logo
    property url missingLogo: "assets/placeholder/no_logo.png"
    // Missing Screenshots/Art
    property url missingArt: "assets/placeholder/no_art.png"

    // Actual Theme

    property int screen: 2

    // Status Screen
    StatusScreen {
        id: status
    }

    // Main Menu
    MainMenu {
        id: mainmenu

        y: (screen === 0) ? 0 : -sh
        focus: y === 0
        Behavior on y {
            NumberAnimation {
                easing.type: Easing.InOutCubic
                duration: 400
            }
        }

        onYChanged: {
            if (y === 0) {
                console.log("Main Menu Focused");
            }
        }

        anchors.horizontalCenter: parent.horizontalCenter
    }

    // Interaction Screens
    Item {
        id: interactionScreens
        focus: true

        opacity: updpop.active ? 0 : 1
		Behavior on opacity {
			NumberAnimation {
				easing.type: Easing.InOutQuad
				duration: 300
			}
		}
        width: parent.width
        height: parent.height

        // If screen = 0 position below view, else position on screen
        x: 0
        y: (screen != 0) ? 0 : sh
        Behavior on y {
            NumberAnimation {
                easing.type: Easing.InOutCubic
                duration: 400
            }
        }

        // Settings page
        Settings {
            id: settingsPG
            focus: (screen === 1)
            visible: (y !== sh)
            opacity: focus || (updpop.active && screen === 1) ? 1 : 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 400
                }
            }

            onSettingChanged: {
                gameflow.settingChanged(setting);
            }

            onActionTaken: {
                gameflow.actionTaken(action);
            }
        }

        // GameFlow page
        GameFlow {
            id: gameflow
            focus: (screen === 2 && !gameflowLSM.active)
            visible: (y !== sh)
            opacity: (focus || gameflowLSM.active || (updpop.active && screen === 2)) ? 1 : 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 400
                }
            }
            onActivateFlowLSM: {
                gameflowLSM.startIndex = startIndex;
                gameflowLSM.active = true;
                enableMouse = false;
            }
        }
        // GameFlow flowbar (separate as shaders do not work properly when included)
        FlowBar {
            opacity: gameflow.opacity
            visible: (y !== sh)
        }
        // Gameflow Collections Selector
        LeftSelectorMenu {
            id: gameflowLSM
            focus: active && (screen === 2)
            function updateCurrentCollection(collectionIndex) {
                gameflow.changeCollection(collectionIndex);
            }
            onDeactivate: {
                active = false;
                gameflow.enableMouse = true;
            }
        }

        // Back on screen = main menu (unless back action otherwise occupied)
        Keys.onPressed: {
            if (api.keys.isCancel(event)) {
                event.accepted = true;
                if (screen > 0) {
                    screen = 0;
                }
            }
        }
    }

    UpdatePopup {
        id: updpop
        active: false
        z: 100000
    }


    // The Background
    // Background Gradients
    Image {
        width: parent.width
        height: parent.height * 3

        x: 0
        y: (screen == 0) ? 0 : -sh
        Behavior on y {
            NumberAnimation {
                easing.type: Easing.InOutQuad
                duration: 400
            }
        }
        z: -14

        source: "assets/art/blurs_light.png"
        opacity: settings["light"] ? 1 : 0.5
        mipmap: true
    }

    // Background Back Layer
	Rectangle {
		id: background
		z: -15
		color: colors.bg1
		anchors.fill: parent

		Behavior on color {
            ColorAnimation {
                easing.type: Easing.OutCubic
                duration: 200
            }
        }
	}



    // Actions

    // Launch a game
    function launchGame(game) {
		game.launch();
	}

	// Adds an opacity to a color.
	// Opacity is a hex integer represented as a string from 0x00 to 0xff.
	function ocolor(color, opacity) {
        let newColor = color;
        if (color.substring(0, 1) === "#") {
            newColor = color.substring(1);
        }
        newColor = opacity + newColor;
        newColor = "#" + newColor;
        return newColor;
    }

    // Detects if a new update is available.
    function checkForNewUpdate() {
        console.log("Checking for any updates...");
        const xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            console.log(xhr.readyState);
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    console.log("Latest release page fetched.");
                    // A mess of regex to get the update tag from the latest releases page
                    const tag = xhr.responseText
                        .match(/<li(.*?)class="breadcrumb-item(.*?)releases\/tag(.*?)>/g)[0]
                        .match(/tag\/(.*?)"/g)[0]
                        .match(/\d+\.\d+\.\d+/g)[0];
                    console.log("Most recent update:", tag);
                    const comparisonWithCurrent = compareSemverTags(tag, theme.version);
                    if (comparisonWithCurrent === 1) {
                        console.log("! This version of reflow is out of date !");
                        updpop.active = true;
                        updpop.updString = tag;
                    } else {
                        console.log("This version is up to date.");
                    }
                } else {
                    console.log("Error in fetching releases, ignoring...");
                }
            }
        }
        xhr.open("GET", "https://github.com/Fr75s/reflow/releases/latest");
        xhr.send();
    }

    // Compares two semantic versioning tags a and b.
    // Returns 0 if the versions are the same, 1 if a is more recent, and -1 if b is more recent.
    function compareSemverTags(a, b) {
        const aNums = a.match(/\d+/g);
        const bNums = b.match(/\d+/g);
        for (let i = 0; i < 2; i++) {
            let compA = Number(aNums[i]);
            let compB = Number(bNums[i]);
            if (compA > compB) {
                return 1;
            } else if (compB > compA) {
                return -1;
            }
        }
        return 0;
    }

    //
    Component.onCompleted: {
        console.log("Theme initialized.");
        console.log("REFLOW version", theme.version);
        checkForNewUpdate();
    }
}
