import QtQuick 2.8
import QtGraphicalEffects 1.15

Item {
	id: galleryContainer

	signal close

	property var imageList: []

	property real indicatorHeight: height * 0.1

	clip: false

	// Backdrop
	Rectangle {
		id: galleryBackdrop
		anchors.fill: parent
		color: "#000000"
	}

	DropShadow {
		anchors.fill: galleryBackdrop

		horizontalOffset: 0
		verticalOffset: 10

		radius: 20
		samples: 21
		color: "#ff000000"

		source: galleryBackdrop
	}

	// Gallery
	ListView {
		id: galleryView
		anchors.fill: parent

		focus: parent.focus
		enabled: focus

		orientation: ListView.Horizontal
		snapMode: ListView.SnapToItem
		highlightRangeMode: ListView.StrictlyEnforceRange
		highlightMoveDuration: 300
		keyNavigationWraps: true
		clip: true

		model: imageList
		delegate: Image {
			width: galleryContainer.width
			height: galleryContainer.height

			source: imageList[index] || missingArt
			fillMode: Image.PreserveAspectFit
			asynchronous: true

			// Flick down to hide
			Flickable {
				anchors.fill: parent
				enabled: galleryView.focus

				flickableDirection: Flickable.VerticalFlick
				onFlickStarted: {
					// Flick down to close
					if (verticalVelocity < -800) {
						console.log("Closing Gallery")
						galleryContainer.close();
					}
				}
			}
		}
		interactive: imageList.length > 1
	}

	// Placeholder Image
	Image {
		anchors.fill: parent

		source: missingArt
		fillMode: Image.PreserveAspectFit
		asynchronous: true

		visible: imageList.length === 0
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
		anchors.top: parent.top
		anchors.topMargin: height * 0.5

		Text {
			anchors.fill: parent

			text: (galleryView.currentIndex + 1) + " / " + imageList.length
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
		visible: imageList.length > 1

		horizontalOffset: 0
		verticalOffset: 5

		radius: 20
		samples: 21
		color: "#ff000000"

		source: progressIndicator
	}
}
