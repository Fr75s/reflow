import QtQuick 2.8

Rectangle {
	property real progress: 0

	radius: height / 2
	color: colors["bg2"]

	Rectangle {
		property real spacing: 4

		width: (parent.width - spacing * 2) * progress
		height: parent.height - spacing * 2

		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.leftMargin: spacing
		radius: height / 2

		color: colors["text"]
	}
}
