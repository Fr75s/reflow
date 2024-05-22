import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
	property var currentGame: null
	property int blurRadius: 30

	CrossfadeImage {
		id: detailsBG
		z: -11
		anchors.fill: parent
		visible: true

		cfDuration: 300
		fillSpace: true
		blurRadius: 25
	}

	Rectangle {
		id: detailsBGOverlay
		anchors.fill: detailsBG
		z: -11

		color: ocolor(colors.bg2, "c0")
		Behavior on opacity {
			NumberAnimation {
				duration: 300
			}
		}
	}

	onCurrentGameChanged: {
		if (!(currentGame.assets.background || currentGame.assets.screenshot)) {
			detailsBGOverlay.opacity = 0;
		} else {
			detailsBGOverlay.opacity = 1;
		}
		detailsBG.fadeTo(currentGame.assets.background || currentGame.assets.screenshot || "../../assets/placeholder/empty.png");
	}
}
