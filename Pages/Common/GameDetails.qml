import QtQuick 2.8

import "../Common"

FocusScope {
	id: gdRoot

	property var currentGame: null

	property bool active: false

	property real currentGameWidth: theme.width * 0.1
	property real currentAAR: 1

	// Control currently focused component
	/* 0: Interaction icons
	 * 1: Description
	 * 2: Screenshot Gallery
	 */
	property int focusMode: 0

	// Side box
	CoverFit {
		id: gameBox
		game: currentGame

		width: theme.height * 0.35
		height: theme.height * 0.35

		x: parent.width * 0.05
		y: parent.height * 0.15
	}

	// Details Panel
	Rectangle {
		width: parent.width - parent.height * 0.25 - gameBox.width
		height: parent.height * 0.7

		anchors.right: parent.right
		anchors.rightMargin: parent.height * 0.1
		anchors.top: parent.top
		anchors.topMargin: parent.height * 0.125

		color: ocolor(colors.bg1, "b0")

		radius: parent.height * 0.025

		border {
			width: 1
			color: ocolor(colors.outline, "60")
		}

		// Logo
		Image {
			width: parent.width * 0.8
			height: parent.height * 0.25

			anchors.right: parent.right
			anchors.rightMargin: parent.width * 0.1
			anchors.top: parent.top
			anchors.topMargin: parent.height * 0.05

			source: currentGame ? currentGame.assets.logo || missingLogo : missingLogo
			fillMode: Image.PreserveAspectFit
			horizontalAlignment: Image.AlignHCenter
			verticalAlignment: Image.AlignTop
			asynchronous: true
		}

		// Description Scroll Area
		Flickable {
			width: parent.width * 0.4
			height: parent.height * 0.6

			anchors.left: parent.left
			anchors.leftMargin: parent.width * 0.05
			anchors.bottom: parent.bottom
			anchors.bottomMargin: parent.height * 0.05

			flickableDirection: Flickable.VerticalFlick
			clip: true

			contentWidth: width
			contentHeight: descriptionText.contentHeight

			// Description Text
			Text {
				id: descriptionText
				width: parent.width

				text: currentGame.description || "[no description]"
				color: colors.text

				wrapMode: Text.Wrap

				font {
					family: readtext.name
					pixelSize: theme.height * 0.02
				}
			}

			focus: focusMode === 1
		}

		// Screenshot Gallery
		Rectangle {
			width: parent.width * 0.45
			height: parent.height * 0.4

			anchors.right: parent.right
			anchors.rightMargin: parent.width * 0.05
			anchors.bottom: parent.bottom
			anchors.bottomMargin: parent.height * 0.25

			color: "#000000"

			ScreenGallery {
				anchors.fill: parent
				game: currentGame

				focus: focusMode === 2
			}
		}

		// Interaction Buttons

	}

}
