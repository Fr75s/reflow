import QtQuick 2.8

Item {
	visible: false

	property var localization: {
		"en": {

		}
	}

	function getLocalization(lang) {
		return localization[lang]
	}

	function getLangs() {
		return Object.keys(localization)
	}
}
