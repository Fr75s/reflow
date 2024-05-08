import QtQuick 2.15

Item {
	property real aspectRatio: 1

	property real baseWidth: 200
	property real baseHeight: 100

	width: (baseWidth / baseHeight < aspectRatio) ? baseWidth : baseHeight * aspectRatio
	height: (baseWidth / baseHeight < aspectRatio) ? baseWidth / aspectRatio : baseHeight
}
