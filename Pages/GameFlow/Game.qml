import QtQuick 2.8
import QtMultimedia 5.9
import QtGraphicalEffects 1.15

Component {
	id: gameflowDelegate

	Item {
		id: effectHandlerContainer

		width: gameWidth
		height: averageAspectDeviance < 0.1 ? width * (gameBoxArt.sourceSize.height / gameBoxArt.sourceSize.width) : (width / averageAspectRatio)

		property real averageAspectDeviance: assets.boxFront ? Math.abs((gameBoxArt.sourceSize.width / gameBoxArt.sourceSize.height) - averageAspectRatio) : 10

		z: (sideCount + 2) - Math.abs(gameflowView.realCurrentIndex - index) + gameflowView.count;

		property real leftRightCenter: gameflowView.realCurrentIndex === index ? 0 : (x + width / 2 > sw / 2 ? 2 : 1)

		anchors.bottom: parent.bottom

		Rectangle {
			id: gameBoxArtContainer

			width: parent.width
			height: parent.height
			z: parent.z

			anchors.horizontalCenter: parent.horizontalCenter
			anchors.bottom: parent.bottom

			color: "transparent"
			visible: false

			Image {
				id: gameBoxArt
				width: parent.width
				height: parent.height

				anchors.centerIn: parent

				source: assets.boxFront || missingSource
				fillMode: Image.PreserveAspectFit
				asynchronous: true

				z: parent.z + 3

				Component.onCompleted: {
					if (!assets.boxFront) {
						sourceSize.height = sourceSize.width * (1 / averageAspectRatio)
					}
				}

				onStatusChanged: {
					if (status === Image.Ready && assets.boxFront) {
						gameBoxArtBackBlur.visible = Math.abs((gameBoxArt.sourceSize.width / gameBoxArt.sourceSize.height) - averageAspectRatio) >= 0.1
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

				anchors.top: parent.bottom
				anchors.topMargin: 4

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
					if (verticalVelocity < -800) {
						screen = 0;
					}
				}

				// Click to play or switch to clicked game
				MouseArea {
					anchors.fill: parent
					enabled: gameflowView.focus
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

}
