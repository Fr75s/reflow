import QtQuick 2.8

Item {
	property int showcaseIndex: 0
	property int showcaseAOpacityDuration: 300

	property var imageList: []

	Image {
		id: screenshotShowcaseA

		opacity: 1
		Behavior on opacity {
			NumberAnimation {
				duration: showcaseAOpacityDuration
			}
		}

		anchors.fill: parent
		fillMode: Image.PreserveAspectFit

		source: imageList.length > 0 ? imageList[showcaseIndex] : missingArt
		asynchronous: true
	}

	Image {
		id: screenshotShowcaseB

		opacity: 0
		Behavior on opacity {
			NumberAnimation {
				duration: 300
			}
		}

		visible: false
		z: screenshotShowcaseA.z + 1

		anchors.fill: parent
		fillMode: Image.PreserveAspectFit

		source: imageList.length > 0 ? (showcaseIndex > imageList.length - 2 ? imageList[0] : imageList[showcaseIndex + 1]) : missingArt
		asynchronous: true
	}

	Timer {
		repeat: true
		running: imageList.length > 1
		interval: 5000

		onTriggered: {
			showcaseAOpacityDuration = 300;
			screenshotShowcaseB.visible = true;
			screenshotShowcaseB.opacity = 1;
			screenshotShowcaseA.opacity = 0;
			revisTimer.start();
		}
	}

	Timer {
		id: revisTimer
		interval: 300

		onTriggered: {
			if (showcaseIndex < currentGame.assets.screenshotList.length - 1)
				showcaseIndex += 1;
			else
				showcaseIndex = 0;
			showcaseAOpacityDuration = 0;
			screenshotShowcaseA.opacity = 1;
			screenshotShowcaseB.visible = false;
			screenshotShowcaseB.opacity = 0;
		}
	}
}
