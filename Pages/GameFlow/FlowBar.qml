import QtQuick 2.15
import QtGraphicalEffects 1.0

Rectangle {
	id: flowBar

	z: 15

	color: colors.bg1

	width: parent.width
	height: parent.height * 0.1

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

		color: ocolor(colors.outline, "60")
	}

	// Title and _ of _
	Text {
		id: gameTitle
		width: parent.width * 0.5
		height: parent.height * 0.5

		anchors.top: parent.top
		anchors.topMargin: parent.height * 0.075
		anchors.horizontalCenter: parent.horizontalCenter

		text: gameflow.currentGame ? gameflow.currentGame.title : ""
		color: colors.text

		elide: Text.ElideRight

		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter

		font {
			family: display.name
			weight: Font.Medium
			pixelSize: height * 0.75
		}
	}

	Text {
		id: gameCount
		width: parent.width
		height: parent.height * 0.5

		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height * 0.025

		text: gameflow.flowProgress[0] + " of " + gameflow.flowProgress[1]
		color: colors.text

		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter

		font {
			family: display.name
			weight: Font.Light
			pixelSize: height * 0.5
		}
	}
}
