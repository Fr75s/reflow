import QtQuick 2.8
import QtMultimedia 5.9
import QtGraphicalEffects 1.15

Item {
	id: effectHandlerContainer

	property var game: null // Game Item Model

	property real aar: 1 // Average Aspect Ratio of boxes in current collection
	readonly property real aad: game ? (game.assets.boxFront ? Math.abs((gameBoxArt.sourceSize.width / gameBoxArt.sourceSize.height) - aar) : 10) : 10 // Deviance of this box from Average Aspect Ratio, set to higher than threshold if no art

	property real reflSpacing: 4 // Space between game and reflection
	property int reflAnimDuration: 0 // Duration for reflection y movement animation

	width: 0//theme.width * 0.2 // DEFAULT WIDTH
	height: aad < 0.1 ? width * (gameBoxArt.sourceSize.height / gameBoxArt.sourceSize.width) : (width / aar)

	property real leftRightCenter: 0 // 0: Center, 1: Left, 2: Right

	Rectangle {
		id: gameBoxArtContainer

		width: parent.width
		height: parent.height
		z: parent.z

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom

		visible: false

		Image {
			id: gameBoxArt
			width: parent.width
			height: parent.height

			anchors.bottom: parent.bottom

			source: game ? game.assets.boxFront || missingSource : missingSource
			fillMode: Image.PreserveAspectFit
			asynchronous: true

			z: parent.z + 3

			Component.onCompleted: {
				if (!game.assets.boxFront) {
					sourceSize.height = sourceSize.width * (1 / aar)
				}
			}

			onStatusChanged: {
				if (status === Image.Ready && game && game.assets.boxFront) {
					gameBoxArtBackBlur.visible = Math.abs((gameBoxArt.sourceSize.width / gameBoxArt.sourceSize.height) - aar) >= 0.1
				}
			}
		}

		Image {
			id: gameBoxArtBackBlurSource
			anchors.fill: parent
			visible: false

			source: gameBoxArt.source
			fillMode: Image.PreserveAspectCrop
			asynchronous: true
		}

		FastBlur {
			id: gameBoxArtBackBlur
			anchors.fill: parent
			source: gameBoxArtBackBlurSource
			radius: 64

			z: parent.z + 1

			Rectangle {
				anchors.fill: parent
				z: parent.z + 1

				color: ocolor(colors.darkSurface, "80");
			}
		}
	}


	DropShadow {
		id: gameDisplay

		anchors.fill: gameBoxArtContainer
		z: parent.z + 7

		horizontalOffset: 0
		verticalOffset: 5

		radius: 20
		samples: 21
		color: "#ff000000"

		source: gameBoxArtContainer

		transform: Rotation {
			id: shadowRotation

			origin.x: gameBoxArtContainer.width / 2;
			origin.y: gameBoxArtContainer.height / 2;

			axis { x: 0; y: 1; z: 0 }
			angle: leftRightCenter === 0 ? 0 : (leftRightCenter === 1 ? 30 : -30);
			Behavior on angle {
				NumberAnimation {
					easing.type: Easing.OutQuad
					duration: 300
				}
			}
		}

		scale: leftRightCenter === 0 ? 1 : (0.85)
		Behavior on scale {
			NumberAnimation {
				easing.type: Easing.OutQuad
				duration: 300
			}
		}

		Rectangle {
			id: reflectionImage

			y: parent.height + reflSpacing
			Behavior on y {
				NumberAnimation {
					duration: reflAnimDuration
					easing.type: Easing.InOutCubic
				}
			}

			width: parent.width
			height: parent.height

			anchors.horizontalCenter: parent.horizontalCenter

			z: parent.z - 7

			transform: Scale {
				origin { x: width / 2; y: height / 2 }
				yScale: -1.0
			}

			LinearGradient {
				anchors.fill: parent
				start: Qt.point(0, parent.height)
				end: Qt.point(0, parent.height - 300)

				z: parent.z + 4

				gradient: Gradient {
					GradientStop { position: 0.0; color: ocolor(colors.darkSurface, "60"); }
					GradientStop { position: 1.0; color: ocolor(colors.darkSurface, "d0"); }
				}
			}

			Image {
				anchors.fill: parent

				source: gameBoxArt.source
				fillMode: Image.PreserveAspectFit
				asynchronous: true

				z: parent.z + 3
			}

			Image {
				id: gameBoxArtShadowBackBlurSource
				anchors.fill: parent

				source: gameBoxArt.source
				fillMode: Image.PreserveAspectCrop

				asynchronous: true
				visible: false
			}

			FastBlur {
				anchors.fill: parent
				source: gameBoxArtShadowBackBlurSource
				radius: 64

				z: parent.z + 1

				Rectangle {
					anchors.fill: parent
					color: ocolor(colors.darkSurface, "80");
					z: parent.z + 1
				}
			}
		}

		// Interactivity
		Flickable {
			anchors.fill: parent

			enabled: gameflowView.focus
			flickableDirection: Flickable.VerticalFlick
			onFlickStarted: {
				// Flick up to go to main menu
				if (verticalVelocity < -1000) {
					screen = 0;
				}
			}

			// Click to play or switch to clicked game
			MouseArea {
				anchors.fill: parent
				enabled: parent.enabled
				onClicked: {
					if (gameflowView.realCurrentIndex === index) {
						gameflowView.launchGameFromGameflow();
					} else {
						gameflowView.currentIndex = (index - (sideCount + 1)) % currentModel.count;
					}
				}
			}
		}
	}
}
