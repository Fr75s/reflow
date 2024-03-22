import QtQuick 2.15


FocusScope {
	id: settings

	anchors.fill: parent

	/* Contains all of the data for each setting, as well as layout data.
	 *
	 * Settings are organized into lists of items, which can contain any of the below types.
	 * Each item has some universal properties:
	 * 	type: The type of the item (see below)
	 * 	name: The name of the setting (often used as a label)
	 * 	header [OPTIONAL]: A header to place above the setting, used to divide sections of a page.
	 * 	invisible [OPTIONAL]: Whether or not to show this setting. If this property is not present, the setting is always shown.
	 *
	 * Items consist of one of the following types:
	 * 	"page": A setting subpage, which can contain any other item.
	 * 		UNIQUE PROPERTIES:
	 * 		id: A unique ID for this page, used for navigation
	 * 		items: The subpage's contents, consisting of a list of items
	 *
	 * 	The following types are setting types, which contain the following properties:
	 * 	setting: The name of the setting to change.
	 * 	xinfo [OPTIONAL]: Additional information regarding the setting.
	 *
	 * 	"setting_bin": A toggleable setting, which can be set to true or false.
	 * 	"setting_list": A setting which selects one option from a fixed list of items.
	 * 		UNIQUE PROPERTIES:
	 * 		list: The fixed list of items this setting chooses from
	 * 	"setting_range": A setting which sets the value to a value in the given range.
	 * 		UNIQUE PROPERTIES:
	 * 		lower: The lower bound of the range
	 * 		upper: The upper bound of the range
	 * 		step: The step size (how much to decrease/increase per increment)
	 *
	 */
	property var settingData: [
		{
			type: "page",
			id: "appearance",
			name: loc.settings_subpage_appearance,
			header: loc.settings_subpages,
			items: [
				{
					type: "page",
					id: "t2l_subpage",
					name: "Temporary 2nd Level Subpage",
					items: []
				},
				{
					type: "setting_bin",
					name: loc.settings_appearance_lightmode,
					setting: "light"
				},
				{
					type: "setting_range",
					name: loc.settings_appearance_zoom,
					setting: "zoom",
					lower: 0.5,
					upper: 1.2,
					step: 0.1
				}
			]
		},
		{
			type: "page",
			id: "behavior",
			name: loc.settings_subpage_behavior,
			items: [
				{
					type: "setting_bin",
					name: loc.settings_behavior_carouselup,
					setting: "carousel_up_menu"
				},
			]
		},
		{
			type: "setting_list",
			name: loc.settings_theme,
			header: loc.settings_other,
			setting: "theme",
			list: themes
		},
		{
			type: "setting_bin",
			name: "aa",
			setting: "aa"
		}
	]

	property string curPage: "/"
	property var curPageContents: settingData

	property var themes: [
		"retro"
	]



	ListModel {
		id: settingModel

		Component.onCompleted: {
			refreshModel();
		}
	}

	Text {
		id: title
		anchors.top: parent.top
		anchors.topMargin: parent.height * 0.05

		width: parent.width
		height: parent.height * 0.05

		text: "Settings"
		color: colors.text
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter

		font {
			family: display.name
			weight: Font.Medium
			pixelSize: height
		}
	}

	Text {
		id: settingsPathDisplay
		anchors.top: title.bottom
		anchors.topMargin: parent.height * 0.025

		width: parent.width
		height: parent.height * 0.025

		text: formatCurPage()
		color: colors.text
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter

		font {
			family: display.name
			weight: Font.Light
			pixelSize: height
		}

		function formatCurPage() {
			if (curPage === "/") {
				return "Main Page";
			} else {
				let out = "";
				let components = curPage.substring(1, curPage.length - 1).split("/");
				for (let i = 0; i < components.length; i++) {
					out += components[i].substring(0, 1).toUpperCase() + components[i].substring(1).toLowerCase();
					if (i < components.length - 1) {
						out += " » ";
					}
				}
				return out;
			}
		}
	}

	ListView {
		id: settingView
		width: parent.width * 0.9 > 1000 ? 1000 : parent.width * 0.9
		height: parent.height * 0.8

		focus: parent.focus

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom

		model: settingModel

		delegate: Item {
			id: settingBox
			width: ListView.view.width
			height: header ? settingRectContainer.height + settingHeaderLabel.height : settingRectContainer.height

			property bool selected: settingView.currentIndex === index
			property real selectedMargin: settingRectContainer.height * 0.1

			Text {
				id: settingHeaderLabel
				anchors.left: parent.left
				anchors.leftMargin: 0
				anchors.top: parent.top

				width: parent.width
				height: settings.height * 0.05

				text: header ? header : ""
				color: colors.text
				horizontalAlignment: Text.AlignLeft
				verticalAlignment: Text.AlignVCenter

				font {
					family: display.name
					weight: Font.Medium
					pixelSize: settings.height * 0.03
				}
			}

			Rectangle {
				width: parent.width
				height: 2
				radius: height / 2

				anchors.top: settingHeaderLabel.verticalCenter
				anchors.topMargin: settingHeaderLabel.font.pixelSize / 2
				visible: header ? true : false
			}

			Item {
				id: settingRectContainer
				width: parent.width
				height: settings.height * 0.1

				anchors.bottom: parent.bottom

				Rectangle {
					id: settingRect
					anchors.fill: parent
					anchors.margins: selected ? 0 : selectedMargin
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

					border {
						width: 1
						color: colors.mid
					}

					radius: height / 8

					Text {
						anchors.left: parent.left
						anchors.leftMargin: selectedMargin * 2
						anchors.verticalCenter: parent.verticalCenter

						width: parent.width - selectedMargin * 4
						height: settingRectContainer.height * 0.35

						text: name
						color: colors.text
						horizontalAlignment: Text.AlignLeft
						verticalAlignment: Text.AlignVCenter

						font {
							family: display.name
							weight: Font.Light
							pixelSize: height
						}
					}

					Image {
						width: height
						height: settingRectContainer.height * 0.35

						anchors.right: parent.right
						anchors.rightMargin: selectedMargin * 2.5
						anchors.verticalCenter: parent.verticalCenter

						source: "../assets/icon/folder.png"
						mipmap: true
						asynchronous: true
						visible: (type === "page")
					}
				}
			}
		}

		Keys.onPressed: {
			if (api.keys.isAccept(event)) {
				event.accepted = true;
				settingInteraction(currentIndex);
			}

			if (api.keys.isCancel(event)) {
				event.accepted = true;
				if (curPage === "/") {
					screen = 0;
				} else {
					goToParentPage();
				}
			}

			// Scroll to next header.
			// If end of page reached, scroll to top
			// If no headers present, scroll to top
			if (api.keys.isDetails(event)) {
				event.accepted = true;
				do {
					if (currentIndex === count - 1) {
						currentIndex = 0;
					} else {
						incrementCurrentIndex();
					}
				} while (currentIndex > 0 && settingModel.get(currentIndex).header === undefined);
			}
		}

		Keys.onUpPressed: {
			if (currentIndex === 0) {
				if (curPage === "/") {
					screen = 0;
				}
			} else {
				decrementCurrentIndex();
			}
		}

		Keys.onDownPressed: {
			if (currentIndex === count - 1) {
				currentIndex = 0;
			} else {
				incrementCurrentIndex();
			}
		}
	}



	function settingInteraction(index) {
		let metaSetting = settingModel.get(index);
		switch (metaSetting.type) {
			case "page":
				goToChildPage(metaSetting.id);
				break;
		}
	}

	function goToChildPage(childID) {
		curPage += childID + "/";
		curPageContents = curPageContents[getIndexOfChildPage(childID, curPageContents)].items;
		refreshModel();
	}

	function goToParentPage() {
		if (curPage !== "/") {
			curPage = curPage.substring(0, curPage.lastIndexOf("/", curPage.length - 2) + 1);
			curPageContents = settingData;

			let directory = curPage.split("/");
			for (let i = 1; i < directory.length - 1; i++) {
				let idxOfChild = getIndexOfChildPage(directory[i], curPageContents);
				curPageContents = curPageContents[idxOfChild].items;
			}
			refreshModel();
		}
	}

	function getIndexOfChildPage(pageID, contents) {
		for (let i = 0; i < contents.length; i++) {
			if ("id" in contents[i] && contents[i].id === pageID) {
				return i;
			}
		}
		return -1;
	}

	function refreshModel() {
		settingModel.clear();
		for (let i = 0; i < curPageContents.length; i++) {
			if (!("invisible" in curPageContents[i]) || !curPageContents[i].invisible) {
				settingModel.append(curPageContents[i]);
			}
		}
	}
}
