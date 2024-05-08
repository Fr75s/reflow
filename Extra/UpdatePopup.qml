import QtQuick 2.15
import QtGraphicalEffects 1.15

FocusScope {
	id: updpopRoot

	property bool active: false
	property var updString: ""

	anchors.fill: theme

	focus: active
	opacity: active ? 1 : 0
	Behavior on opacity {
		NumberAnimation {
			easing.type: Easing.InOutQuad
			duration: 300
		}
	}

	FixedAspectItem {
		id: updpopContainer
		z: parent.z

		anchors.horizontalCenter: parent.horizontalCenter

		baseWidth: parent.width
		baseHeight: parent.height

		aspectRatio: 1.5

		y: parent.active ? 0 : parent.height * 0.1
		Behavior on y {
			NumberAnimation {
				easing.type: Easing.InOutQuad
				duration: 400
			}
		}

		Rectangle {
			id: updpopBG
			z: parent.z + 5
			anchors.fill: parent
			anchors.margins: parent.height * 0.05

			color: ocolor(colors.bg1, "c0")
			border {
				color: colors.outline
				width: 1
			}

			radius: parent.height * 0.025
			visible: true

			// Info Content
			Image {
				id: updpopIcon

				width: height
				height: parent.height * 0.15

				anchors.top: parent.top
				anchors.topMargin: parent.height * 0.05
				anchors.left: parent.left
				anchors.leftMargin: parent.height * 0.05

				source: "../assets/icon/info.png"
			}

			Text {
				id: updpopTitle

				width: parent.width - parent.height * 0.15 - updpopIcon.width
				height: updpopIcon.height

				anchors.top: parent.top
				anchors.topMargin: parent.height * 0.05
				anchors.right: parent.right
				anchors.rightMargin: parent.height * 0.05

				text: loc.updpop_header + " " + updString
				color: colors.text
				verticalAlignment: Text.AlignVCenter
				font {
					family: display.name
					weight: Font.Medium
					pixelSize: height * 0.8
				}
			}

			Text {
				id: updpopDescription

				width: parent.width - parent.height * 0.1
				height: parent.height * 0.5

				anchors.top: updpopIcon.bottom
				anchors.topMargin: parent.height * 0.05
				anchors.left: parent.left
				anchors.leftMargin: parent.height * 0.05

				text: loc.updpop_info
				color: colors.text
				linkColor: colors.accent
				wrapMode: Text.Wrap
				font {
					family: readtext.name
					weight: Font.Normal
					pixelSize: parent.height * 0.035
				}
			}

			// Buttons
			Rectangle {
				id: dismissButton
				focus: updpopRoot.focus
				width: parent.width * 0.35
				height: parent.height * 0.15

				anchors.bottom: parent.bottom
				anchors.bottomMargin: parent.height * 0.05
				anchors.left: parent.left
				anchors.leftMargin: parent.height * 0.1

				color: activeFocus ? colors.bg4 : colors.bg2
				Behavior on color {
					ColorAnimation {
						easing.type: Easing.OutCubic
						duration: 300
					}
				}
				border {
					color: colors.outline
					width: 1
				}
				radius: height / 6

				Text {
					anchors.centerIn: parent
					text: loc.pop_dismiss
					color: colors.text
					font {
						family: display.name
						weight: Font.Medium
						pixelSize: parent.height / 3
					}
				}

				KeyNavigation.left: visitButton
				KeyNavigation.right: visitButton
				Keys.onPressed: {
					if (api.keys.isAccept(event)) {
						event.accepted = true;
						deactivate();
					}
				}
			}

			Rectangle {
				id: visitButton
				focus: updpopRoot.focus
				width: parent.width * 0.35
				height: parent.height * 0.15

				anchors.bottom: parent.bottom
				anchors.bottomMargin: parent.height * 0.05
				anchors.right: parent.right
				anchors.rightMargin: parent.height * 0.1

				color: activeFocus ? colors.bg4 : colors.bg2
				Behavior on color {
					ColorAnimation {
						easing.type: Easing.OutCubic
						duration: 300
					}
				}
				border {
					color: colors.outline
					width: 1
				}
				radius: height / 6

				Text {
					anchors.centerIn: parent
					text: loc.updpop_get
					color: colors.text
					font {
						family: display.name
						weight: Font.Medium
						pixelSize: parent.height / 3
					}
				}

				KeyNavigation.left: dismissButton
				KeyNavigation.right: dismissButton
				Keys.onPressed: {
					if (api.keys.isAccept(event)) {
						event.accepted = true;
						Qt.openUrlExternally("https://github.com/Fr75s/reflow/releases/latest");
					}
				}
			}
		}
	}

	FastBlur {
		id: updpopBlur
		anchors.fill: parent
		source: interactionScreens
		radius: 60
	}

	Keys.onPressed: {
		if (api.keys.isCancel(event)) {
			event.accepted = true;
			deactivate();
		}
	}

	function deactivate() {
		updpop.active = false;
		switch (screen) {
			case 0:
				mainmenu.forceActiveFocus();
				break;
			case 1:
				settingsPG.forceActiveFocus();
				break;
			case 2:
				gameflow.forceActiveFocus();
				break;
		}
	}
}
