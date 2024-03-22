import QtQuick 2.15
import QtGraphicalEffects 1.15

FocusScope {
	id: settingsRoot

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
					type: "setting_bin",
					name: loc.settings_appearance_lightmode,
					setting: "light"
				},
				{
					type: "setting_range",
					name: loc.settings_appearance_zoom,
					setting: "carousel_zoom",
					minVal: 0.5,
					maxVal: 1.2,
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
					header: loc.settings_header_general,
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
		}
	]

	signal settingChanged(string setting);

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

			// Header text
			Text {
				id: settingHeaderLabel
				anchors.left: parent.left
				anchors.leftMargin: selectedMargin
				anchors.top: parent.top

				width: parent.width
				height: settingsRoot.height * 0.05

				text: header ? header : ""
				color: colors.text
				horizontalAlignment: Text.AlignLeft
				verticalAlignment: Text.AlignVCenter

				font {
					family: display.name
					weight: Font.Medium
					pixelSize: settingsRoot.height * 0.03
				}
			}

			// Header underline
			Rectangle {
				width: parent.width
				height: 2
				radius: height / 2

				anchors.top: settingHeaderLabel.verticalCenter
				anchors.topMargin: settingHeaderLabel.font.pixelSize / 2
				visible: header ? true : false

				color: colors.subtext
			}

			// Position the actual setting rectangle in a container to make anchors.margins easy
			Item {
				id: settingRectContainer
				width: parent.width
				height: settingsRoot.height * 0.1

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

					radius: height / 6

					// Setting name
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

					// Container for icons
					Item {
						width: (type === "setting_list") ? height * 4 : height
						height: settingRectContainer.height * 0.35

						anchors.right: parent.right
						anchors.rightMargin: selectedMargin * 2.5
						anchors.verticalCenter: parent.verticalCenter

						// TYPE = page
						// Folder Icon
						Image {
							id: pageIcon
							anchors.fill: parent

							source: "../assets/icon/folder.png"
							mipmap: true
							asynchronous: true
							visible: false
						}
						ColorOverlay {
							anchors.fill: pageIcon
							source: pageIcon
							color: colors.text
							visible: (type === "page")
						}

						// TYPE = setting_bin
						// Toggle switch icon
						Rectangle {
							anchors.verticalCenter: parent.verticalCenter
							width: parent.width
							height: parent.height * 0.1
							radius: height / 2

							color: colors.subtext
							visible: (type === "setting_bin")
						}
						Rectangle {
							anchors.verticalCenter: parent.verticalCenter
							width: height
							height: parent.height * 0.6
							radius: height / 2

							x: settings[setting] ? parent.width - width : 0
							Behavior on x {
								NumberAnimation {
									easing.type: Easing.OutCubic
									duration: 250
								}
							}

							visible: (type === "setting_bin")
						}

						// TYPE = setting_range + TYPE = setting_list
						// Value label
						Text {
							anchors.fill: parent
							color: colors.text

							horizontalAlignment: (type === "setting_list") ? Text.AlignRight: Text.AlignHCenter
							verticalAlignment: Text.AlignVCenter

							text: (type === "setting_range") ? formatRangeStr() : (settings[setting] ? settings[setting] : "")

							visible: (type === "setting_list") || (type === "setting_range")

							font {
								family: display.name
								weight: Font.Light
								pixelSize: height / 2
							}

							function formatRangeStr() {
								let out = settings[setting];
								if (settings[setting] > settingModel.get(index).minVal) {
									out = "« " + out;
								}
								if (settings[setting] < settingModel.get(index).maxVal) {
									out += " »";
								}
								return out;
							}
						}
					}
				}

				// Mouse Interactivity
				MouseArea {
					anchors.fill: parent
					onClicked: {
						if (!selected) {
							settingView.currentIndex = index;
						} else {
							settingInteraction(index);
							settingSideInteraction(currentIndex, 1);
						}
					}
				}
			}
		}

		Keys.onPressed: {
			// Do a normal setting interaction + interaction = to pressing right
			if (api.keys.isAccept(event)) {
				event.accepted = true;
				settingInteraction(currentIndex);
				settingSideInteraction(currentIndex, 1);
			}

			// Go to parent page or main menu if at root page
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
				if (curPage === "/" && settings["carousel_up_menu"]) {
					screen = 0;
				} else {
					currentIndex = count - 1;
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

		Keys.onLeftPressed: {
			settingSideInteraction(currentIndex, 0);
		}

		Keys.onRightPressed: {
			settingSideInteraction(currentIndex, 1);
		}
	}


	// Behavior upon interacting with a setting, either by clicking or pressing accept.
	function settingInteraction(index) {
		let metaSetting = settingModel.get(index);
		switch (metaSetting.type) {
			case "page":
				goToChildPage(metaSetting.id);
				break;
			case "setting_bin":
				settings[metaSetting.setting] = !settings[metaSetting.setting];
				refreshSettings(metaSetting.setting);
				break;
			case "setting_range":
				if (settings[metaSetting.setting] === metaSetting.maxVal) {
					settings[metaSetting.setting] = metaSetting.minVal - metaSetting.step;
				}
				refreshSettings(metaSetting.setting);
				break;
		}
	}

	function settingSideInteraction(index, dir) {
		let metaSetting = settingModel.get(index);
		switch (metaSetting.type) {
			case "setting_range":
				if (dir == 1 && settings[metaSetting.setting] < metaSetting.maxVal) {
					settings[metaSetting.setting] += metaSetting.step;
				} else if (dir == 0 && settings[metaSetting.setting] > metaSetting.minVal) {
					settings[metaSetting.setting] -= metaSetting.step;
				}
				settings[metaSetting.setting] = Math.round(settings[metaSetting.setting] * 1000) / 1000
				refreshSettings(metaSetting.setting);
				break;
		}
	}

	// Go to the child page specified by the given ID.
	/* IMPLEMENTATION NOTE:
	 * When passed as a parameter to this function, the child page's .items field is treated
	 * as a ListModel rather than a JavaScript Object. This is why the syntax below is used
	 * for curPageContents rather than passing the .items field directly.
	 */
	function goToChildPage(childID) {
		curPage += childID + "/";
		curPageContents = curPageContents[getIndexOfChildPage(childID)].items;
		refreshModel();
	}

	// Go to the parent page.
	function goToParentPage() {
		if (curPage !== "/") {
			curPage = curPage.substring(0, curPage.lastIndexOf("/", curPage.length - 2) + 1);
			curPageContents = settingData;

			let directory = curPage.split("/");
			for (let i = 1; i < directory.length - 1; i++) {
				let idxOfChild = getIndexOfChildPage(directory[i]);
				curPageContents = curPageContents[idxOfChild].items;
			}
			refreshModel();
		}
	}

	// Get the index of the child page with ID pageID in the given page contents.
	// The page contents is a list of setting items.
	function getIndexOfChildPage(pageID, contents = curPageContents) {
		for (let i = 0; i < contents.length; i++) {
			if ("id" in contents[i] && contents[i].id === pageID) {
				return i;
			}
		}
		return -1;
	}

	// Refreshes the setting model to the current page contents.
	// Basically, converts curPageContents to a ListModel.
	function refreshModel() {
		settingModel.clear();
		for (let i = 0; i < curPageContents.length; i++) {
			if (!("invisible" in curPageContents[i]) || !curPageContents[i].invisible) {
				settingModel.append(curPageContents[i]);
			}
		}
	}

	function refreshSettings(settingThatChanged) {
		settings = new Object(settings);
		settingsRoot.settingChanged(settingThatChanged);
	}
}
