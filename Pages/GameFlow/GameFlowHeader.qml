import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
	width: parent.width
	height: parent.height

	anchors.top: parent.top
	anchors.topMargin: parent.height * .05

	property string titleLabel: ""

	Text {
		id: titleText
		width: parent.width * .9

		text: titleLabel
		color: colors.text

		font {
			family: display.name
			weight: Font.Medium
			pixelSize: parent.height * .04
		}

		anchors.left: parent.left
		anchors.leftMargin: parent.width * .05
	}

	Row {
		spacing: 20

		layoutDirection: Qt.RightToLeft

		anchors.right: parent.right
		anchors.rightMargin: parent.width * .05

		height: titleText.font.pixelSize

		Image {
			id: batteryIcon
			source: getBatteryIcon()
			visible: false

			width: height
			height: parent.height
			mipmap: true
			verticalAlignment: Image.AlignVCenter

			function getBatteryIcon() {
				let src = "../../assets/icon/battery/";
				if (!isNaN(api.device.batteryPercent)) {
					// Get rounded %
					let roundp = Math.round(api.device.batteryPercent * 100);

					// Step through battery icons
					if (roundp >= 80) {
						src += "80";
					} else if (roundp >= 60) {
						src += "60"
					} else if (roundp >= 40) {
						src += "40"
					} else if (roundp >= 20) {
						src += "20"
					} else {
						src += "0"
					}

					// Add charging icon
					if (api.device.batteryCharging) {
						if (roundp >= 99) {
							src += "f";
						} else {
							src += "c";
						}
					}

					src += ".svg";
					return src;
				} else {
					return src + "0.svg";
				}
			}
		}

		ColorOverlay {
			visible: batteryLabel.visible

			width: batteryIcon.width
			height: batteryIcon.height

			source: batteryIcon
			color: colors.text
		}

		Text {
			id: batteryLabel
			text: getBatteryPercent(api.device.batteryPercent)
			visible: !isNaN(api.device.batteryPercent)

			width: contentWidth + theme.width * 0.025
			height: parent.height

			horizontalAlignment: Text.AlignRight
			verticalAlignment: Text.AlignVCenter
			font {
				family: display.name
				weight: Font.Light
				pixelSize: parent.height * 0.8
			}

			color: colors.text

			function getBatteryPercent() {
				if (!isNaN(api.device.batteryPercent)) {
					return Math.round(api.device.batteryPercent * 100) + "%";
				} else {
					return "";
				}
			}
		}

		Text {
			id: currentTime

			height: parent.height

			verticalAlignment: Text.AlignVCenter
			font {
				family: display.name
				weight: Font.Light
				pixelSize: parent.height * 0.8
			}

			color: colors.text

			function set() {
				currentTime.text = settings["24hClock"] ? Qt.formatTime(new Date(), "hh:mm") : Qt.formatTime(new Date(), "hh:mm AP");
				if (batteryLabel.visible) {
					batteryIcon.source = batteryIcon.getBatteryIcon();
					batteryLabel.text = batteryLabel.getBatteryPercent();
				}
			}

			// Runs the timer to update the time every second
			Timer {
				id: currentTimeTextTimer
				interval: 1000 // Run the timer every second
				repeat: true
				running: true
				triggeredOnStart: true // Start immediately
				onTriggered: {
					currentTime.set();
				}
			}
		}
	}
}
