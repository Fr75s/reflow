import QtQuick 2.8
import QtMultimedia 5.9
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15

import SortFilterProxyModel 0.2

FocusScope {

	id: gameflow

	anchors.fill: parent

	property int currentCollectionIndex: 0
	property var currentCollection: api.collections.get(currentCollectionIndex)

	//property var currentModel: currentCollection.games

	property var flowProgress: [(gameflowView.selectionIndex) + 1, currentCollection.games.count]

	ListModel {
		id: currentModel

		Component.onCompleted: {
			update();

			while (gameflowView.selectionIndex > 0) {
				gameflowView.decrementCurrentIndex();
			}
		}
	}

	property bool tempUselessValueForForceUpdates: false
	property var currentGame: tempUselessValueForForceUpdates, currentModel.get(gameflowView.selectionIndex)

	function updateCurrentGame() {
		tempUselessValueForForceUpdates = !tempUselessValueForForceUpdates
	}


	Text {
		id: titleText
		width: parent.width * .9

		text: currentCollection.name
		color: colors["text"]

		font {
			family: display.name
			weight: Font.Medium
			pixelSize: parent.height * .04
		}

		anchors.left: parent.left
		anchors.leftMargin: parent.width * .05
		anchors.top: parent.top
		anchors.topMargin: parent.height * .05
	}

	Row {
		spacing: 20

		layoutDirection: Qt.RightToLeft

		anchors.top: parent.top
		anchors.topMargin: parent.height * .05
		anchors.right: parent.right
		anchors.rightMargin: parent.width * .05

		height: titleText.font.pixelSize

		Text {
			text: getBatteryIcon(api.device.batteryPercent)
			visible: !isNaN(api.device.batteryPercent)

			height: parent.height

			verticalAlignment: Text.AlignVCenter
			font {
				family: icons.name
				pixelSize: parent.height
			}

			color: colors["text"]

			function getBatteryIcon() {
				if (!isNaN(api.device.batteryPercent)) {
					if (api.device.batteryCharging) {
						return icons.battery_charging;
					} else {
						var truncPercent = Math.round(api.device.batteryPercent * 10) * 10;
						return icons.battery[truncPercent];
					}
				} else {
					return "";
				}
			}
		}

		Text {
			text: getBatteryPercent(api.device.batteryPercent)
			visible: !isNaN(api.device.batteryPercent)

			height: parent.height

			verticalAlignment: Text.AlignVCenter
			font {
				family: display.name
				weight: Font.Light
				pixelSize: parent.height * 0.8
			}

			color: colors["text"]

			function getBatteryPercent() {
				if (!isNaN(api.device.batteryPercent)) {
					return Math.round(api.device.batteryPercent * 100);
				} else {
					return "";
				}
			}
		}

		Text {
			id: currentTime

			height: parent.height

			verticalAlignment: Text.AlignVCenter
			font {
				family: display.name
				weight: Font.Light
				pixelSize: parent.height * 0.8
			}

			color: colors["text"]

			function set() {
				currentTime.text = settings["24hClock"] ? Qt.formatTime(new Date(), "hh:mm") : Qt.formatTime(new Date(), "hh:mm AP");
			}

			// Runs the timer to update the time every second
			Timer {
				id: currentTimeTextTimer
				interval: 1000 // Run the timer every second
				repeat: true
				running: true
				triggeredOnStart: true // Start immediately
				onTriggered: currentTime.set()
			}
		}
	}



	property real averageAspectRatio: getAverageAspectRatio();
	property real gameWidth: sw * 0.225 * Math.pow(averageAspectRatio, 0.6);
	property real gameSpacing: gameWidth * -0.2

	// Number of games (excluding the middle one) that fill the left edge of the screen to the center
	property int sideCount: Math.ceil((sw / 2) / (gameWidth + gameSpacing))

	/* Left Edge:

	sw / 2 - {num widths. + spaces to left edge} * gw
				> ceil((sw / 2) / (gw + sp))


	*/

	PathView {
		id: gameflowView

		anchors.left: parent.left
		anchors.right: parent.right

		anchors.bottom: parent.bottom
		anchors.bottomMargin: parent.height * 0.3

		focus: visible

		model: currentModel
		delegate: Game { }

		property int realCurrentIndex: (currentIndex + (sideCount + 1)) % currentModel.count
		property int selectionIndex: (currentIndex + (sideCount + 1)) % currentCollection.games.count

		snapMode: PathView.SnapOneItem
		//preferredHighlightBegin: 0
		//preferredHighlightEnd: 0.3
		highlightRangeMode: PathView.StrictlyEnforceRange
		highlightMoveDuration: 300

		pathItemCount: 3 + sideCount * 2
		path: Path {
			id: gameFlowPath
			startX: (parent.width * 0.5) - (sideCount + 1) * (gameWidth + gameSpacing)
			startY: 0

			PathLine {
				id: gameFlowPathLine
				x: gameflowView.path.startX + gameflowView.pathItemCount * (gameWidth + gameSpacing)
				y: gameflowView.path.startY
			}
		}

		Keys.onLeftPressed: { decrementCurrentIndex() }
		Keys.onRightPressed: { incrementCurrentIndex() }

        Keys.onPressed: {
			if (api.keys.isAccept(event)) {
				event.accepted = true;
				launchGame(currentCollection.games.get(selectionIndex));
			}

			if (api.keys.isNextPage(event)) {
				event.accepted = true;
				changeCollection(false);
			}
			if (api.keys.isPrevPage(event)) {
				event.accepted = true;
				changeCollection(true);
			}
		}
	}

	Rectangle {
		id: pathViewReflMaterial

		anchors.bottom: parent.bottom

		z: -12

		width: parent.width
		height: parent.height * 0.35

		color: "black"
		opacity: 0.5
	}

	function updateModel() {
		// Reset Model
		currentModel.clear();

		// Initiate Model
		for (var i = 0; i < currentCollection.games.count; i++) {
			currentModel.append(currentCollection.games.get(i));
		}

		// Add extra to fill carousel
		var originalLength = currentModel.count;
		while (currentModel.count < 3 + (sideCount * 2)) {
			for (var i = 0; i < originalLength; i++) {
				currentModel.append(currentModel.get(i))
			}
		}
	}

	Image {
		id: testAspectRatio
		visible: false
	}

	function getAverageAspectRatio() {
		if (currentCollection.shortName in defaultAspectRatios.data) {
			return defaultAspectRatios.data[currentCollection.shortName];
		} else {
			var numAspectRatios = 0;
			var aspectRatioSum = 0;
			let aspectTests = currentCollection.games.count < 5 ? currentCollection.games.count : 5
			for (var i = 0; i < aspectTests; i++) {
				testAspectRatio.source = currentCollection.games.get(i).assets.boxFront;
				if (testAspectRatio.sourceSize.width > 0 && testAspectRatio.sourceSize.height > 0) {
					aspectRatioSum += testAspectRatio.sourceSize.width / testAspectRatio.sourceSize.height;
					numAspectRatios += 1;
				}
			}
			return numAspectRatios > 0 ? (aspectRatioSum / numAspectRatios) : (8 / 7);
		}
	}

	function changeCollection(decrement) {
		// Change the collection
		if (decrement) {
			currentCollectionIndex -= 1;
			if (currentCollectionIndex < 0) {
				currentCollectionIndex = api.collections.count - 1;
			}
		} else {
			currentCollectionIndex += 1;
			if (currentCollectionIndex >= api.collections.count) {
				currentCollectionIndex = 0;
			}
		}

		// Update the model and currently selected game
		update();

		// Set selection index to 0
		for (var i = 0; i <= sideCount; i++) {
			gameflowView.decrementCurrentIndex();
		}
	}

	function update() {
		averageAspectRatio = getAverageAspectRatio();
		gameWidth = sw * 0.225 * Math.pow(averageAspectRatio, 0.6);
		gameSpacing = gameWidth * -0.2
		sideCount = Math.round((sw / 2) / (gameWidth + gameSpacing));
		updateModel();
		updateCurrentGame();
	}
}
