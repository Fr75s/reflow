import QtQuick 2.8
import QtMultimedia 5.9
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15

import SortFilterProxyModel 0.2

import "GameFlow"
import "BottomBar"
import "Extra"

FocusScope {

    //
    // Variables
    //

    id: theme

    focus: true

    // Just a shorthand for the screen width and height
    property int sw: theme.width
    property int sh: theme.height

    // Unstretch Factors (sw * usx = 1920)
    property real usx: 1920 / sw
    property real usy: 1080 / sh

    // Just a few fonts, needs [id].name to work in font.family
    FontLoader { id: gilroyExtraBold; source: "./assets/font/Gilroy-ExtraBold.otf" }
	FontLoader { id: gilroyLight; source: "./assets/font/Gilroy-Light.otf" }
	FontLoader { id: ralewayExtraBold; source: "./assets/font/Raleway-ExtraBold.ttf"}
	FontLoader { id: ralewayLight; source: "./assets/font/Raleway-Light.ttf" }

	IconFont {
        id: icons
    }

    property var settings: {
        "theme": api.memory.has("theme") ? api.memory.get("theme") : "retro",
        "btnScheme": api.memory.has("btnScheme") ? api.memory.get("btnScheme") : "ps",

        "24hClock": api.memory.has("24hClock") ? api.memory.get("24hClock") : false,
        "light": api.memory.has("light") ? api.memory.get("light") : false
    }

    property var colorschemes: {
        "planet": {
            "light": {
                "plainBG": "#F2F6FF", // Used as the flat background color
                "text": "#16171A", // Used as the text color
                "accent": "#74AAFF", // Used as the accent color (slider circles in settings)
                "barBG": "#000000", // Used as the bottom bar color
                "bottomIcons": "#F2F6FF", // Used as the color of the bottom bar icons
            },
            "dark": {
                "plainBG": "#16171A",
                "text": "#F2F6FF",
                "accent": "#74AAFF",
                "barBG": "#000000",
                "bottomIcons": "#F2F6FF",
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
	// Get current Language
	property string currentLanguage: api.memory.has("currentLanguage") ? api.memory.get("currentLanguage") : "en"
	// Alias for the object that is the localization's current language
	property var loc: localizationData.getLocalization(currentLanguage)


    // Actual Theme

    // FLOW
    GameFlow {
        id: gameflow
        focus: visible
    }



    // Lower Bars
    FlowBar {
        id: gameInfoBar
    }

    // The Background
	Rectangle {
		id: background
		z: -15
		color: colors["plainBG"]
		anchors.fill: parent
	}





    // Launching a game
    function launchGame(game) {
		game.launch();
	}
}
