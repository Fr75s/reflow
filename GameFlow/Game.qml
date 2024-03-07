import QtQuick 2.8
import QtMultimedia 5.9
import QtGraphicalEffects 1.15

Component {
	id: gameflowDelegate

	Image {
		id: gameBoxArt
		width: gameWidth
		height: width * (sourceSize.height / sourceSize.width)

		anchors.bottom: parent.bottom

		source: assets.boxFront || "../assets/no_game.png"

		z: (sideCount + 2) - Math.abs(gameflowView.realCurrentIndex - index)

		property real leftRightCenter: gameflowView.realCurrentIndex === index ? 0 : (x + width / 2 > sw / 2 ? 2 : 1)

		transform: Rotation {
			id: gameRotation
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

			width: parent.width
			height: parent.height

			anchors.top: parent.bottom
			anchors.topMargin: 2

			source: parent.source

			transform: Scale {
				origin { x: width / 2; y: height / 2 }
				yScale: -1.0
			}

			Rectangle {
				anchors.fill: parent
				color: "#80000000"
			}
		}

		Component.onCompleted: {
			if (!assets.boxFront) {
				console.log(title);
				sourceSize.height = sourceSize.width * (1 / averageAspectRatio)
			}
		}
	}
}
