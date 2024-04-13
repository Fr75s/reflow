import QtQuick 2.15

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

		Text {
			text: getBatteryIcon(api.device.batteryPercent)
			visible: !isNaN(api.device.batteryPercent)

			height: parent.height

			verticalAlignment: Text.AlignVCenter
			font {
				family: icons.name
				pixelSize: parent.height
			}

			color: colors.text

			function getBatteryIcon() {
				if (!isNaN(api.device.batteryPercent)) {
					if (api.device.batteryCharging) {
						return icons.battery_charging;
					} else {
						var truncPercent = Math.round(api.device.batteryPercent * 10) * 10;
						return icons.battery[truncPercent];
					}
				} else {
					return "";
				}
			}
		}

		Text {
			text: getBatteryPercent(api.device.batteryPercent)
			visible: !isNaN(api.device.batteryPercent)

			height: parent.height

			verticalAlignment: Text.AlignVCenter
			font {
				family: display.name
				weight: Font.Light
				pixelSize: parent.height * 0.8
			}

			color: colors.text

			function getBatteryPercent() {
				if (!isNaN(api.device.batteryPercent)) {
					return Math.round(api.device.batteryPercent * 100);
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
