import QtQuick 2.15
import QtGraphicalEffects 1.0

Rectangle {
	id: flowBar

	z: 15

	color: colors["barBG"]

	width: parent.width
	height: parent.height * 0.1

	visible: settings["theme"] === "retro"

	anchors.bottom: parent.bottom

	// Back Blur
	ShaderEffectSource {
		id: blurSource
		anchors.fill: parent
		sourceItem: gameflow
		sourceRect: Qt.rect(0, theme.height - flowBar.height, flowBar.width, flowBar.height)
		visible: false
	}

	GaussianBlur {
		id: blurEffect
		anchors.fill: blurSource
		source: blurSource
		radius: 32
		samples: 30
		visible: true
		opacity: 0.5
	}

	// Top Border
	Rectangle {
		id: borderTop
		anchors.top: parent.top
		width: parent.width
		height: 1

		color: "#607c7f8e"
	}

	// Title and _ of _
	Text {
		id: gameTitle
		width: parent.width * 0.5
		height: parent.height * 0.5

		anchors.top: parent.top
		anchors.topMargin: parent.height * 0.1
		anchors.horizontalCenter: parent.horizontalCenter

		text: gameflow.currentGame.title
		color: colors["text"]

		elide: Text.ElideRight

		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter

		font {
			family: gilroyLight.name
			pixelSize: height * 0.75
		}
	}

	Text {
		id: gameCount
		width: parent.width
		height: parent.height * 0.5

		anchors.bottom: parent.bottom

		text: gameflow.flowProgress[0] + " of " + gameflow.flowProgress[1]
		color: colors["text"]

		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter

		font {
			family: gilroyLight.name
			pixelSize: height * 0.5
		}
	}
}
