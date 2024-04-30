import QtQuick 2.15

Item {
	id: roundIconButton

	signal action
	property url icon: ""

	Rectangle {
		anchors.fill: parent
		radius: height / 6

		color: parent.focus ? colors.bg3 : colors.bg1
		Behavior on color {
			ColorAnimation {
				easing.type: Easing.OutCubic
				duration: 200
			}
		}

		border {
			color: colors.outline
			width: 1
		}
	}

	Image {
		anchors.fill: parent
		anchors.margins: parent.height * 0.15

		fillMode: Image.PreserveAspectFit

		source: icon
		mipmap: true
	}



	Keys.onPressed: {
		if (api.keys.isAccept(event)) {
			event.accepted = true;
			roundIconButton.action();
		}
	}

	MouseArea {
		anchors.fill: parent
		onClicked: {
			if (parent.focus)
				roundIconButton.action();
			else
				parent.forceActiveFocus();
		}
	}
}
