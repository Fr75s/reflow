import QtQuick 2.8

import "../Common"

FocusScope {
	id: gdRoot

	property var currentGame: null

	property bool active: false

	property real currentGameWidth: theme.width * 0.1
	property real currentAAR: 0

	readonly property real currentGameHeight: currentGameWidth / currentAAR

	FloatingGame {
		game: currentGame

		aar: currentAAR
		leftRightCenter: 0
		reflSpacing: active ? 4 + theme.height * 0.5 + currentGameHeight : 4
		reflAnimDuration: 400

		width: active ? theme.height * 0.25 : currentGameWidth
		Behavior on width {
			NumberAnimation {
				duration: 400
				easing.type: Easing.InOutCubic
			}
		}

		z: 0

		x: (active ? parent.width * 0.05 : parent.width * 0.5 - currentGameWidth / 2)
		Behavior on x {
			NumberAnimation {
				duration: 400
				easing.type: Easing.InOutCubic
			}
		}
		anchors.bottomMargin: (active ? parent.height * 0.85 - height : parent.height * 0.3)
		Behavior on anchors.bottomMargin {
			NumberAnimation {
				duration: 400
				easing.type: Easing.InOutCubic
			}
		}

		anchors.bottom: parent.bottom
	}

}
