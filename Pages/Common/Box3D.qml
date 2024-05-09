import QtQuick 2.15

Item {

	id: boxRoot

	x: 0
	y: 0

	scale: 1

	width: 200
	height: 300

	property real rotX: 0 // Pitch
	property real rotY: 0 // Yaw
	property real rotZ: 0 // Roll

	property real thickness: 0.15

	Rectangle {
		id: front

		width: parent.width
		height: parent.height
		color: "#ff0000"

		transform: Rotation {
			origin {x: front.width / 2; y: front.height / 2}
			axis {x: 0; y: 1; z: 0}
			angle: rotY
		}
	}

	Rectangle {
		id: left

		//x: parent.width * thickness * -1

		width: parent.width * thickness * 2
		height: parent.height
		color: "#00ff00"

		transform: [
			Translate {
				x: front.width / 2
			},
			Rotation {
				origin {x: front.width / 2 + left.width / 2; y: front.height / 2}
				axis {x: 0; y: 1; z: 0}
				angle: rotY - 90
			},
			Translate {
				x: (front.width / 2 + front.width * thickness) * -1
			},
			Rotation {
				origin {x: front.width / 2; y: front.height / 2}
				axis {x: 0; y: 1; z: 0}
				angle: rotY
			}
		]
	}

}
