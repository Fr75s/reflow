import QtQuick 2.15
import "../Helpers"

Rectangle {
	id: statusScreen
	anchors.fill: theme
	z: 9999

	property string statusMessage: ""
	property real majorProgress: 0
	property real minorProgress: 0

	color: colors.bg1
	opacity: 0
	enabled: (opacity == 1)

	Behavior on opacity {
		NumberAnimation {
			easing.type: Easing.InOutQuad
		}
	}

	Image {
		id: centerLogo
		source: "../assets/meta/logo.png"

		anchors.bottom: parent.verticalCenter
		anchors.bottomMargin: parent.height * -0.1
		anchors.horizontalCenter: parent.horizontalCenter
		width: parent.width * 0.5
		height: parent.height * 0.4
		fillMode: Image.PreserveAspectFit
	}

	ProgressBar {
		anchors.top: centerLogo.bottom
		anchors.topMargin: parent.height * 0.1
		anchors.horizontalCenter: parent.horizontalCenter

		height: parent.height * 0.02
		width: parent.width * 0.5

		progress: majorProgress
	}

	ProgressBar {
		id: minorProgressBar
		anchors.top: centerLogo.bottom
		anchors.topMargin: parent.height * 0.135
		anchors.horizontalCenter: parent.horizontalCenter

		height: parent.height * 0.015
		width: parent.width * 0.4

		progress: minorProgress
		visible: false
	}

	Text {
		text: statusMessage

		anchors.top: centerLogo.bottom
		anchors.topMargin: parent.height * 0.025

		width: parent.width
		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter

		font {
			family: display.name
			weight: Font.Medium
			pixelSize: parent.height * 0.035
		}

		color: colors.text
	}


	function showStatus(msg) {
		statusMessage = msg;
		opacity = 1;
		majorProgress = 0;
		minorProgress = 0;
	}

	function hideStatus() {
		opacity = 0;
	}

	function changeStatusMessage(msg) {
		statusMessage = msg;
	}

	function setMajorProgress(progress) {
		majorProgress = progress;
	}

	function setMinorProgress(progress) {
		minorProgress = progress;
	}

	function toggleMinorProgress() {
		minorProgressBar.visible = !minorProgressBar.visible;
	}
}
