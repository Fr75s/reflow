import QtQuick 2.8

import "../Common"

FocusScope {

	id: gdRoot

	property var currentGame: null

	/*
	Image {
		width: height
		height: parent.height * 0.3

		fillMode: Image.PreserveAspectFit

		x: 0
		y: 0

		source: currentGame ? currentGame.assets.boxFront : ""
	}
	*/

	Box3D {
		id: box
		x: 150
		y: 150

		rotY: -Math.PI / 12
		rotZ: 0

		scale: 0.75

		Timer {
			interval: 200
			running: true
			repeat: true
			onTriggered: {
				box.rotY -= Math.PI / 12;
				if (box.rotY < -Math.PI - 0.1) {
					box.rotY = 0;
				}
			}
		}
	}

}
