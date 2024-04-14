import QtQuick 2.15
import QtGraphicalEffects 1.15

FocusScope {

	width: parent.width
	height: parent.height

	Image {
		id: logoImage
		width: parent.width
		height: parent.height * 0.3

		source: settings["light"] ? "../assets/meta/logo_light.png" : "../assets/meta/logo.png"
		fillMode: Image.PreserveAspectFit

		anchors.top: parent.top
		anchors.topMargin: parent.height * 0.05
		anchors.horizontalCenter: parent.horizontalCenter
	}

	ListModel {
		id: pageModel

		ListElement {
			page: "Collections"
			screenIndex: 2
		}

		/*
		ListElement {
			page: "Search"
			screenIndex: 3
		}
		*/

		ListElement {
			page: "Settings"
			screenIndex: 1
		}
	}

	GridView {
		id: pageView

		width: parent.width * 0.4
		height: parent.height * 0.55
		keyNavigationWraps: true

		//focus: parent.focus

		cellWidth: width
		cellHeight: parent.height * 0.1

		anchors.top: logoImage.bottom
		anchors.topMargin: parent.height * 0.05
		anchors.horizontalCenter: parent.horizontalCenter

		model: pageModel
		delegate: Item {
			id: pageSelectionBox
			width: GridView.view.cellWidth
			height: GridView.view.cellHeight

			property bool selected: pageView.currentIndex === index

			Rectangle {
				id: pageSelectionRect
				anchors.fill: parent
				anchors.margins: selected ? 0 : parent.height * 0.1
				Behavior on anchors.margins {
					NumberAnimation {
						easing.type: Easing.OutCubic
						duration: 200
					}
                }

				color: selected ? ocolor(colors.bg4, "80") : ocolor(colors.bg2, "80")
				Behavior on color {
					ColorAnimation {
						easing.type: Easing.OutCubic
						duration: 200
					}
				}

				radius: height / 6

				border {
					color: colors.mid
					width: 1
				}

				Text {
					anchors.centerIn: parent
					width: parent.width
					height: pageSelectionBox.height * 0.35

					text: page
					color: colors.text
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter

					font {
						family: display.name
						weight: Font.Light
						pixelSize: height
					}
				}
			}

			MouseArea {
				anchors.fill: parent
				onClicked: {
					if (!selected) {
						pageView.currentIndex = index;
					} else {
						interact();
					}
				}
			}

			function interact() {
				screen = screenIndex;
			}
		}
	}

	/* PageView Actions
	 *
	 * For some reason when pageView is focused Pegasus's menu doesn't open at all,
	 * so these actions need to be outside. I honestly don't know why because there
	 * was never an api.keys.isCancel action, yet cancel actions didn't propagate.
	 * This is a mystery I'll probably never know the true solution to...
	 */

	Keys.onUpPressed: {
		pageView.moveCurrentIndexUp();
	}

	Keys.onDownPressed: {
		pageView.moveCurrentIndexDown();
	}

	Keys.onPressed: {
		if (api.keys.isAccept(event)) {
			event.accepted = true;
			screen = pageModel.get(pageView.currentIndex).screenIndex;
		}
	}
}
