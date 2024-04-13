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

		transform: Matrix4x4 {
			matrix: Qt.matrix4x4(
				1, 0, 0, Math.sin(rotY) * 200,
				0, 1, 0, 0,
				0, 0, 1, Math.sin(rotY) * 2,
				0, 0, 0, 1,
			)
		}

		/*
		transform: Matrix4x4 {
			property real fw: front.width / 2
			property real fh: front.height / 2

			matrix: Qt.matrix4x4(
				ypr(rotY, 0)*ypr(rotX, 0), ypr(rotY, 1), 0, ypr(rotY, 4, fw, fh),
				ypr(rotY, 2), ypr(rotY, 2), 0, ypr(rotY, 5, fw, fh),
				ypr(rotX, 1), ypr(rotX, 0)*ypr(rotZ, 2), ypr(rotX, 0)*ypr(rotZ, 2), 0,
				0, 0, 0, 1,
			)
		}
		*/
	}

	Rectangle {
		id: t

		width: 10
		height: 10
		color: "#ffffff"
	}

	/* Yaw matrix value.
	 * a: angle
	 * vw: origin width offset
	 * vh: origin height offset
	 * o: offset
	 * 0 1 - 4
	 * 2 3 - 5
	 * - - - -
	 * - - - -
	 */
	function ypr(a, idx, vw=0, vh=0) {
		switch (idx) {
			case 0:
				return Math.cos(a);
			case 1:
				return -Math.sin(a);
			case 2:
				return Math.sin(a);
			case 3:
				return -Math.cos(a);
			case 4:
				return -vw*Math.cos(a) + vh*Math.sin(a) + vw
			case 5:
				return -vw*Math.sin(a) - vh*Math.cos(a) + vh
		}
	}

}
