import QtQuick 2.8
import QtMultimedia 5.9
import QtGraphicalEffects 1.15

Component {
	id: gameflowDelegate

	Item {
		width: gameWidth
		height: width * (gameBoxArt.sourceSize.height / gameBoxArt.sourceSize.width)

		z: (sideCount + 2) - Math.abs(gameflowView.realCurrentIndex - index);

		property real leftRightCenter: gameflowView.realCurrentIndex === index ? 0 : (x + width / 2 > sw / 2 ? 2 : 1)

		anchors.bottom: parent.bottom

		Image {
			id: gameBoxArt
			width: parent.width
			height: parent.height

			anchors.bottom: parent.bottom

			source: assets.boxFront || "../assets/no_game.png"

			visible: false

			Component.onCompleted: {
				if (!assets.boxFront) {
					sourceSize.height = sourceSize.width * (1 / averageAspectRatio)
				}
			}
		}

		DropShadow {
			id: gameDisplay

			anchors.fill: gameBoxArt
			horizontalOffset: 0
			verticalOffset: 5
			radius: 20
			samples: 21
			color: "#ff000000"
			source: gameBoxArt

			z: parent.z

			transform: Rotation {
				id: shadowRotation
				origin.x: width / 2;
				origin.y: height / 2;

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

			Image {
				id: reflectionSource

				width: gameBoxArt.width
				height: gameBoxArt.height

				anchors.top: parent.bottom
				anchors.topMargin: 4

				source: gameBoxArt.source

				z: parent.z - 10

				transform: Scale {
					origin { x: width / 2; y: height / 2 }
					yScale: -1.0
				}

				LinearGradient {
					anchors.fill: parent
					start: Qt.point(0, parent.height)
					end: Qt.point(0, parent.height - 300)
					gradient: Gradient {
						GradientStop { position: 0.0; color: "#60000000" }
						GradientStop { position: 1.0; color: "#d0000000" }
					}
				}
			}
		}
	}

}
