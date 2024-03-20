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


	ListView {
		width: parent.width * 0.9
		height: parent.height * 0.8

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom

		model: settingModel
	}



	function goToChildPage(childID) {
		let idxOfChild = getIndexOfChildPage(curPage.split("/").pop(), curPageContents);
		if (idxOfChild >= 0) {
			curPage += "/" + childID;
			curPageContents = curPageContents[idxOfChild].items;
		}
		refreshModel();
	}

	function goToParentPage() {
		if (curPage !== "/") {
			curPage = curPage.substring(0, curPage.lastIndexOf("/"));
			curPageContents = settingData;

			let directory = curPage.split("/");
			for (let i = 1; i < directory.length; i++) {
				let idxOfChild = getIndexOfChildPage(directory[i], curPageContents);
				curPageContents = curPageContents[idxOfChild].items;
			}
		}
		refreshModel();
	}

	function getIndexOfChildPage(pageID, contents) {
		for (let i = 0; i < contents.length; i++) {
			if ("id" in contents[i] && contents[i].id === pageID) {
				return true;
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
