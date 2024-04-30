import QtQuick 2.8

import "../Common"

FocusScope {
	id: gdRoot

	property var currentGame: null

	property bool active: false

	property real currentGameWidth: theme.width * 0.1
	property real currentAAR: 1

	// Index of the screenshot showcase
	property int showcaseIndex: 0
	property int showcaseAOpacityDuration: 300

	readonly property url iconsDir: "../../assets/icon/"

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

		color: ocolor(colors.bg1, "80")

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
			id: descriptionContainer
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

			Keys.onUpPressed: {
				flick(0, 500);
			}
			Keys.onDownPressed: {
				flick(0, -500);
			}

			KeyNavigation.right: playButton
		}

		Rectangle {
			anchors.fill: descriptionContainer
			anchors.margins: theme.height * -0.01

			color: "transparent"
			radius: theme.height * 0.01

			opacity: descriptionContainer.focus ? 1 : 0
			Behavior on opacity {
				NumberAnimation {
					easing.type: Easing.InOutQuad
					duration: 200
				}
			}

			border {
				width: 1
				color: colors.outline
			}
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

			ImageShowcase {
				anchors.fill: parent
				imageList: currentGame.assets.screenshotList
			}

			/*
			ScreenGallery {
				anchors.fill: parent
				game: currentGame

				focus: focusMode === 2
			}
			*/
		}

		// Interaction Buttons
		Row {
			id: buttonRow
			width: parent.width * 0.45
			height: parent.height * 0.15

			spacing: ((width - (height * 4)) > 0 ? (width - (height * 4)) : 0) / 3

			anchors.right: parent.right
			anchors.rightMargin: parent.width * 0.05
			anchors.bottom: parent.bottom
			anchors.bottomMargin: parent.height * 0.05

			// Play Game
			RoundIconButton {
				id: playButton
				width: height > parent.width / 4 ? parent.width / 4 : height
				height: parent.height

				focus: true

				icon: iconsDir + "play.png"
				onAction: {
					launchGame(currentGame);
				}

				KeyNavigation.right: favButton
			}

			// Toggle favorite
			RoundIconButton {
				id: favButton
				width: height > parent.width / 4 ? parent.width / 4 : height
				height: parent.height

				icon: iconsDir + (currentGame.favorite ? "fav_full.png" : "fav.png")
				onAction: {
					currentGame.favorite = !currentGame.favorite;
				}

				KeyNavigation.left: playButton
				KeyNavigation.right: infoButton
			}

			// Extra Info
			RoundIconButton {
				id: infoButton
				width: height > parent.width / 4 ? parent.width / 4 : height
				height: parent.height

				icon: iconsDir + "info.png"
				onAction: {
					console.log("showing info");
				}

				KeyNavigation.left: favButton
				KeyNavigation.right: galleryButton
			}

			// Fullscreen Gallery
			RoundIconButton {
				id: galleryButton
				width: height > parent.width / 4 ? parent.width / 4 : height
				height: parent.height

				icon: iconsDir + "gallery.png"
				onAction: {
					console.log("showing gallery");
				}

				KeyNavigation.left: infoButton
			}
		}
	}

}
