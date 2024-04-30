import QtQuick 2.8
import QtGraphicalEffects 1.15

Item {
	id: galleryContainer

	property var game: null

	property real indicatorHeight: height * 0.1

	clip: false

	// Gallery
	ListView {
		id: galleryView
		anchors.fill: parent

		focus: parent.focus

		orientation: ListView.Horizontal
		snapMode: ListView.SnapToItem
		highlightRangeMode: ListView.StrictlyEnforceRange
		clip: true

		model: game ? game.assets.screenshotList : []
		delegate: Image {
			width: galleryContainer.width
			height: galleryContainer.height

			source: game ? game.assets.screenshotList[index] || missingArt : missingArt
			fillMode: Image.PreserveAspectFit
			asynchronous: true
		}
		interactive: game && game.assets.screenshotList.length > 1
	}

	// Placeholder Image
	Image {
		anchors.fill: parent

		source: missingArt
		fillMode: Image.PreserveAspectFit
		asynchronous: true

		visible: !game || (game.assets.screenshotList.length === 0)
	}

	// Progress Indicator
	Rectangle {
		id: progressIndicator
		width: height * 4
		height: indicatorHeight

		visible: false

		color: colors.bg1
		radius: height / 2

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom
		anchors.bottomMargin: height * 0.5

		Text {
			anchors.fill: parent

			text: (galleryView.currentIndex + 1) + " / " + game.assets.screenshotList.length
			color: colors.text

			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter

			font {
				family: display.name
				weight: Font.ExtraBold
				pixelSize: height * 0.65
			}
		}
	}

	DropShadow {
		anchors.fill: progressIndicator
		visible: game && game.assets.screenshotList.length > 1

		horizontalOffset: 0
		verticalOffset: 5

		radius: 20
		samples: 21
		color: "#ff000000"

		source: progressIndicator
	}

}
