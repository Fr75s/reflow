import QtQuick 2.15
import QtGraphicalEffects 1.0

Item {
	id: lsm

	signal deactivate

	z: parent.z + 999

	width: parent.width * 0.4
	height: parent.height

	property bool active: false
	property int startIndex: 0
	onActiveChanged: {
		if (active) {
			collectionList.currentIndex = startIndex;
		}
	}

	focus: active

	x: active ? 0 : -1 * width
	Behavior on x {
		NumberAnimation {
			easing.type: Easing.OutCubic
			duration: 300
		}
	}
	y: 0

	// Back Blur
	ShaderEffectSource {
		id: blurSource
		anchors.fill: parent
		sourceItem: gameflow
		sourceRect: Qt.rect(0, 0, lsm.width, lsm.height)
		visible: false
	}

	GaussianBlur {
		id: blurEffect
		anchors.fill: blurSource
		source: blurSource
		radius: 32
		samples: 30
		visible: true
		opacity: 1

		Rectangle {
			anchors.fill: parent
			color: ocolor(colors.bg1, "b0")
		}
	}

	// Border
	Rectangle {
		id: borderRight
		anchors.right: parent.right
		width: 1
		height: parent.height

		color: ocolor(colors.outline, "60")
	}

	// Collection List
	ListView {
		id: collectionList
		anchors.fill: parent
		anchors.margins: 8

		focus: active

		keyNavigationWraps: true
		highlightRangeMode: ListView.ApplyRange
		preferredHighlightBegin: 0
		preferredHighlightEnd: height
		highlightMoveDuration: 0
		highlightMoveVelocity: -1

		model: api.collections
		delegate: Item {
			id: fixedBox
			width: collectionList.width
			height: collectionList.height * 0.08

			MouseArea {
				anchors.fill: parent
				enabled: collectionList.focus
				onClicked: {
					if (index !== collectionList.currentIndex) {
						collectionList.currentIndex = index;
					} else {
						updateCurrentCollection(index);
						lsm.deactivate();
					}
				}
			}

			Rectangle {
				anchors.fill: parent
				anchors.margins: index === collectionList.currentIndex ? 0 : 8
				Behavior on anchors.margins {
					NumberAnimation {
						easing.type: Easing.OutCubic
						duration: 300
					}
				}

				color: ocolor(index === collectionList.currentIndex ? colors.bg3 : colors.bg1, "c0")
				border {
					width: 1
					color: ocolor(colors.outline, "60")
				}
				radius: height / 4

				Text {
					anchors.centerIn: parent
					height: fixedBox.height
					width: parent.width * 0.8

					text: name
					elide: Text.ElideRight
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter

					color: colors.text
					font {
						family: display.name
						weight: Font.Medium
						pixelSize: height * 0.4
					}
				}
			}
		}

		Keys.onPressed: {
			// Launch game
			if (api.keys.isAccept(event)) {
				event.accepted = true;
				updateCurrentCollection(currentIndex);
				lsm.deactivate();
			}

			if (api.keys.isCancel(event)) {
				event.accepted = true;
				lsm.deactivate();
			}

			// Close Menu
			if (api.keys.isPageUp(event)) {
				event.accepted = true;
				lsm.deactivate();
			}
		}
	}
}
