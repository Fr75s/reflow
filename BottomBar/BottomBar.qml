import QtQuick 2.8

Rectangle {
	id: bottomBar

	z: 15
	color: settings["theme"] === "retro" ? colors["accent"] : colors["barBG"]

	width: parent.width
	height: parent.height * 0.075
	anchors.bottom: parent.bottom

	Row {
		spacing: 30

		layoutDirection: Qt.RightToLeft

		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		anchors.rightMargin: 40

		height: parent.height * 0.45

		IconPair {
			icon: icons.btnScheme[settings["btnScheme"]].A
			label: "Launch"
		}

		IconPair {
			icon: icons.btnScheme[settings["btnScheme"]].X
			label: "Details"
		}
	}
}
