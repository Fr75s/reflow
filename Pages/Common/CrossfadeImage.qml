import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
	property int cfDuration: 300
	property int blurRadius: 0
	property bool fillSpace: false
	property url initialSource: ""

	property bool aJustChanged: false
	property bool bJustChanged: false
	property int showcaseAOpacityDuration: cfDuration

	Image {
		id: screenshotShowcaseA
		visible: false
		z: parent.z + 3

		anchors.fill: parent
		fillMode: Image.PreserveAspectCrop

		source: initialSource
		asynchronous: true

		onStatusChanged: {
			if (screenshotShowcaseA.status === Image.Ready && aJustChanged) {
				showcaseAOpacityDuration = 0;
				screenshotShowcaseABlur.opacity = 1;
				screenshotShowcaseBBlur.visible = false;
				screenshotShowcaseBBlur.opacity = 0;
				aJustChanged = false;
			}
		}
	}

	FastBlur {
		id: screenshotShowcaseABlur
		source: screenshotShowcaseA
		anchors.fill: screenshotShowcaseA
		z: screenshotShowcaseA.z

		opacity: 1
		Behavior on opacity {
			NumberAnimation {
				duration: showcaseAOpacityDuration
			}
		}

		radius: blurRadius
	}

	Image {
		id: screenshotShowcaseB
		visible: false
		z: screenshotShowcaseA.z + 1

		anchors.fill: parent
		fillMode: Image.PreserveAspectCrop

		source: initialSource
		asynchronous: true

		onStatusChanged: {
			if (screenshotShowcaseB.status === Image.Ready && bJustChanged) {
				showcaseAOpacityDuration = cfDuration;
				screenshotShowcaseBBlur.visible = true;
				screenshotShowcaseBBlur.opacity = 1;
				screenshotShowcaseABlur.opacity = 0;
				revisTimer.start();
				bJustChanged = false;
			}
		}
	}

	FastBlur {
		id: screenshotShowcaseBBlur
		source: screenshotShowcaseB
		anchors.fill: screenshotShowcaseB
		z: screenshotShowcaseB.z

		visible: false
		opacity: 0
		Behavior on opacity {
			NumberAnimation {
				duration: cfDuration
			}
		}

		radius: blurRadius
	}

	Timer {
		id: revisTimer
		interval: cfDuration

		onTriggered: {
			aJustChanged = true;
			screenshotShowcaseA.source = screenshotShowcaseB.source;
		}
	}

	function fadeTo(url) {
		bJustChanged = true;
		revisTimer.stop();
		screenshotShowcaseB.source = url;
	}

	function setTo(url) {
		revisTimer.stop();
		screenshotShowcaseA.source = url;
	}
}

