import QtQuick 2.8

Row {

	height: parent.height

	spacing: 10

	property string icon: ""

	property string label: ""

	Text {
		text: icon

		height: parent.height

		verticalAlignment: Text.AlignVCenter
		font {
			family: icons.name
			pixelSize: parent.height * 0.8
		}

		color: colors["barBG"]
	}

	Text {
		text: label

		height: parent.height

		verticalAlignment: Text.AlignVCenter
		font {
			family: gilroyLight.name
			pixelSize: parent.height
		}

		color: colors["barBG"]
	}
}
