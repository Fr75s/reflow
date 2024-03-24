import QtQuick 2.8

Item {
	visible: false

	property var localization: {
		"en": {
			settings_subpages: "Subsections",
			settings_header_general: "General",

			settings_subpage_appearance: "Appearance",
			settings_appearance_lightmode: "Light Mode",
			settings_appearance_theme: "Interface Theme",
			settings_appearance_zoom: "Interface Zoom",

			settings_subpage_behavior: "Behavior",
			settings_behavior_carouselup: "Up → Main Menu",

			settings_other: "Other Settings",
			settings_other_repreload: "Redo Preload",
		}
	}

	function getLocalization(lang) {
		return localization[lang]
	}

	function getLangs() {
		return Object.keys(localization)
	}
}
