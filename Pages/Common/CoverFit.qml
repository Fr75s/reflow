import QtQuick 2.8
import QtGraphicalEffects 1.15

Item {
	property var game: null // Game Item Model

	property var hAlign: Image.AlignLeft
	property var vAlign: Image.AlignTop

	Image {
		id: gameBoxArt
		anchors.fill: parent

		source: game ? game.assets.boxFront || missingSource : missingSource
		fillMode: Image.PreserveAspectFit
		horizontalAlignment: hAlign
		verticalAlignment: vAlign
		asynchronous: true

		z: parent.z + 3
	}

	DropShadow {
		id: gameDisplay

		anchors.fill: parent
		z: parent.z + 3

		horizontalOffset: 0
		verticalOffset: 5

		radius: 20
		samples: 21
		color: "#ff000000"

		source: gameBoxArt
	}
}
