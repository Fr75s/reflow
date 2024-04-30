import QtQuick 2.8
import QtMultimedia 5.9
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15

import SortFilterProxyModel 0.2

import "../Common"

FocusScope {
	id: gameflowRoot
	anchors.fill: parent

	signal activateFlowLSM(int startIndex)

	// Current collection
	property int currentCollectionIndex: 0
	property var currentCollection: api.collections.get(currentCollectionIndex)

	// Preloaded data (if it exists)
	property var preloadData: api.memory.get("preload");

	// Current index of the gameflow (0: current index, 1: total amount)
	property var flowProgress: [(gameflowView.selectionIndex) + 1, currentCollection.games.count]

	// Mode
		// 0: Flow
		// 1: Details
		// 2: Collections
	property int menuMode: 0

	ListModel {
		id: currentModel

		Component.onCompleted: {
			console.log("Initializing Model");
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

	GameFlowHeader {
		titleLabel: currentCollection.name
	}

	// Median aspect ratio of games in collection
	property real averageAspectRatio: 1;
	// Fixed width of each game
	property real gameWidth: theme.width * 0.225 * settings["carousel_zoom"] * Math.pow(averageAspectRatio, 0.6)
	// Space between games
	property real gameSpacing: gameWidth * -0.2

	// Number of games (excluding the middle one) that fill the left edge of the screen to the center
	property int sideCount: Math.ceil((theme.width / 2) / (gameWidth + gameSpacing))

	property bool enableMouse: true

	/* Left Edge:
	sw / 2 - {num widths. + spaces to left edge} * gw
				> ceil((sw / 2) / (gw + sp))
	*/

	property int detailsAnimationDuration: 400

	PathView {
		id: gameflowView

		z: 100

		width: parent.width
		height: parent.height

		property bool middleVisible: true

		anchors.left: parent.left
		anchors.right: parent.right

		y: (menuMode === 0 ? parent.height * -0.3 : (gameWidth / averageAspectRatio) * 1.2)
		Behavior on y {
			NumberAnimation {
				duration: detailsAnimationDuration
				easing.type: Easing.InOutCubic
			}
		}

		focus: parent.focus && menuMode === 0
		interactive: enableMouse && menuMode === 0

		model: currentModel
		delegate: FloatingGame {
			game: currentModel.get(index);

			aar: averageAspectRatio
			leftRightCenter: gameflowView.realCurrentIndex === index ? 0 : (x + width / 2 > sw / 2 ? 2 : 1)

			//visible: (index !== gameflowView.realCurrentIndex) || gameflowView.middleVisible
			reflSpacing: 4
			reflAnimDuration: menuMode === 0 ? 0 : detailsAnimationDuration

			width: gameWidth
			z: (sideCount + 2) - Math.abs(gameflowView.realCurrentIndex - index) + gameflowView.count;

			anchors.bottom: parent.bottom
		}

		property int realCurrentIndex: (currentIndex + (sideCount + 1)) % currentModel.count
		property int selectionIndex: (currentIndex + (sideCount + 1)) % currentCollection.games.count

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

		Keys.onLeftPressed: {
			if (middleVisible) {
				forceWaitSecondaryInteractions()
				decrementCurrentIndex();
			}
		}
		Keys.onRightPressed: {
			if (middleVisible) {
				forceWaitSecondaryInteractions()
				incrementCurrentIndex();
			}
		}
		Keys.onUpPressed: {
			if (settings["carousel_up_menu"])
				screen = 0;
		}

        Keys.onPressed: {
			// Launch game
			if (api.keys.isAccept(event)) {
				event.accepted = true;
				if (!event.isAutoRepeat) {
					launchGameFromGameflow();
				}
			}

			// Change collection
			if (api.keys.isNextPage(event)) {
				event.accepted = true;
				if (middleVisible)
					changeCollection(currentCollectionIndex + 1);
			}
			if (api.keys.isPrevPage(event)) {
				event.accepted = true;
				if (middleVisible)
					changeCollection(currentCollectionIndex - 1);
			}

			// Activate Collection Selection menu
			if (api.keys.isPageUp(event)) {
				event.accepted = true;
				if (detailsKeyEnabled)
					gameflowRoot.activateFlowLSM(currentCollectionIndex);
			}
		}

		function launchGameFromGameflow() {
			launchGame(currentCollection.games.get(selectionIndex));
		}
	}

	// Mouse interactivity
	Flickable {
		width: parent.width * 0.5
		height: parent.height * 0.3

		anchors.left: parent.left
		anchors.bottom: parent.bottom

		enabled: menuMode === 0 && enableMouse

		flickableDirection: Flickable.HorizontalFlick
		onFlickStarted: {
			// Flick right to open collection menu
			if (horizontalVelocity < -800) {
				console.log("Opening Collections Menu");
				gameflowRoot.activateFlowLSM(currentCollectionIndex);
			}
		}

		// Click to decrement collection
		MouseArea {
			anchors.fill: parent
			enabled: parent.enabled
			propagateComposedEvents: !enabled
			onClicked: {
				changeCollection(currentCollectionIndex - 1);
			}
		}
	}


	MouseArea {
		width: parent.width * 0.5
		height: parent.height * 0.3

		anchors.right: parent.right
		anchors.bottom: parent.bottom

		enabled: menuMode === 0 && enableMouse
		propagateComposedEvents: !enabled
		onClicked: {
			changeCollection(currentCollectionIndex + 1);
		}
	}

	GameDetails {
		id: gameDetailsPage

		width: parent.width
		height: parent.height

		active: menuMode === 1

		opacity: active ? 1 : 0
		Behavior on opacity {
			NumberAnimation {
				easing.type: Easing.InOutQuad
				duration: detailsAnimationDuration
			}
		}

		x: 0
		y: active ? 0 : theme.height * 0.15
		Behavior on y {
			NumberAnimation {
				easing.type: Easing.InOutCubic
				duration: detailsAnimationDuration
			}
		}

		z: 0

		focus: active

		currentGame: currentCollection.games.get(gameflowView.selectionIndex)
		currentGameWidth: gameWidth
		currentAAR: averageAspectRatio
	}



	Rectangle {
		id: pathViewReflMaterial
		y: menuMode === 0 ? parent.height - height : parent.height
		Behavior on y {
			NumberAnimation {
				duration: detailsAnimationDuration
				easing.type: Easing.InOutCubic
			}
		}

		z: -12

		width: parent.width
		height: parent.height * 0.35

		color: colors.darkSurface
		opacity: 0.5
	}



	// Functionality

	// Force waiting for details/collections menu
	function forceWaitSecondaryInteractions() {
		detailsKeyEnabled = false;
		collectionChangeDetailsCooldown.restart();
	}

	// Update current model
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

	/* Gets the median aspect ratio.
	 * Usually gets this value from the list of default aspect ratios or preloaded data.
	 * If in neither, manually calculates it.
	 */
	function getAverageAspectRatio(collection, broadcastProgress = 0) {
		console.log("Getting average aspect ratio for " + collection.name);
		if (defaultAspectRatios && collection.shortName in defaultAspectRatios.data) {
			console.log("Getting from default aspect ratios");
			console.log("Value: " + defaultAspectRatios.data[collection.shortName]);
			return defaultAspectRatios.data[collection.shortName];
		} else if (preloadData && collection.shortName in preloadData && "averageAspectRatio" in preloadData[collection.shortName]) {
			console.log("Getting from preload data");
			console.log("Value: " + preloadData[collection.shortName]["averageAspectRatio"]);
			return preloadData[collection.shortName]["averageAspectRatio"];
		} else {
			console.log("Calculating average aspect for " + collection.name);
			let aspectRatios = [];
			let aspectTests = collection.games.count;
			console.log("This collection has " + collection.games.count + " games");
			for (var i = 0; i < aspectTests; i++) {
				testAspectRatio.source = collection.games.get(i).assets.boxFront;
				if (testAspectRatio.sourceSize.width > 0 && testAspectRatio.sourceSize.height > 0) {
					aspectRatios.push(testAspectRatio.sourceSize.width / testAspectRatio.sourceSize.height);
				}

				// Broadcast to StatusScreen
				if (broadcastProgress > 0) {
					if (broadcastProgress > 1) {
						// Broadcast to major progress bar
						status.setMajorProgress((i + 1) / aspectTests);
					} else {
						// Broadcast to minor progress bar
						status.setMinorProgress((i + 1) / aspectTests);
					}
				}
			}

			console.log("Calculation finished");
			return aspectRatios.length > 0 ? aspectRatios[Math.floor((aspectRatios.length - 1) / 2)] : (8 / 7);
		}
	}

	function changeCollection(newIndex) {
		// Change the collection
		currentCollectionIndex = newIndex;
		if (currentCollectionIndex < 0) {
			currentCollectionIndex = api.collections.count - 1;
		} else if (currentCollectionIndex >= api.collections.count) {
			currentCollectionIndex = 0;
		}

		// Activate cooldown for details screen
		forceWaitSecondaryInteractions()

		// Update the model and currently selected game
		update();

		// Set selection index to 0
		for (var i = 0; i <= sideCount; i++) {
			gameflowView.decrementCurrentIndex();
		}
	}

	function update() {
		averageAspectRatio = getAverageAspectRatio(currentCollection);
		gameWidth = sw * 0.225 * settings["carousel_zoom"] * Math.pow(averageAspectRatio, 0.6);
		gameSpacing = gameWidth * -0.2;
		sideCount = Math.round((sw / 2) / (gameWidth + gameSpacing));
		updateModel();
		updateCurrentGame();
	}

	function settingChanged(setting) {
		if (setting === "carousel_zoom") {
			update();
		}
	}

	function actionTaken(action) {
		if (action === "act_repreload") {
			preloadData = {};
			preload();
		}
	}


	Component.onCompleted: {
		// Check for any needed preloads
		// Check if previous preloaded data exists
		if (!preloadData) {
			// Preload
			preload();
		} else {
			let doPreload = false;
			let preloadKeys = Object.keys(preloadData);
			for (let i = 0; i < preloadKeys.length; i++) {
				let preloadedCollection = preloadData[preloadKeys[i]];
				// Check if games field does not exist or is not the same
				if (!("games" in preloadedCollection)) {
					doPreload = true;
					break;
				} else if (preloadedCollection["games"] != api.collections.get(i).games.toVarArray()) {
					doPreload = true;
					break;
				}
				if (!("averageAspectRatio" in preloadedCollection) && !(preloadKeys[i] in defaultAspectRatios)) {
					doPreload = true;
					break;
				}
				i++;
			}
			if (doPreload) {
				preload();
			}
		}
	}

	function preload() {
		console.log("Preloading...");
		status.showStatus("Preloading Collections...");
		// Init with preexisting data
		let newPreloadData = preloadData;
		if (!preloadData) {
			newPreloadData = {};
		}
		// Get preloaded data
		for (let i = 0; i < api.collections.count; i++) {
			const currentPCollection = api.collections.get(i);
			console.log("Preloading " + currentPCollection.name);
			// Preload Collections
			if (!(currentPCollection.shortName in newPreloadData)) {
				newPreloadData[currentPCollection.shortName] = {};
			}
			// Preload Games
			// Get var array of games
			let currentPCollectionGames = currentPCollection.games.toVarArray();
			// Check if needed
			if (!("games" in newPreloadData[currentPCollection.shortName]) || (newPreloadData[currentPCollection.shortName]["games"] != currentPCollectionGames)) {
				// Fill with all game titles
				newPreloadData[currentPCollection.shortName]["games"] = [];
				for (let i = 0; i < currentPCollectionGames.length; i++) {
					newPreloadData[currentPCollection.shortName]["games"].push(currentPCollectionGames[i].title);
				}
			}
			// Preload Average Aspect Ratio
			if (!(currentPCollection.shortName in defaultAspectRatios.data) && !("averageAspectRatio" in newPreloadData[currentPCollection.shortName])) {
				// If x-aar is present & valid, set average aspect ratio to that
				if ("extra" in currentPCollection && "aar" in currentPCollection.extra && !isNaN(currentPCollection.extra.aar) && (currentPCollection.extra.aar > 0)) {
					// Valid x-aar present, use that
					newPreloadData[currentPCollection.shortName]["averageAspectRatio"] = currentPCollection.extra.aar;
				} else {
					// No valid x-aar, calculate manually
					status.toggleMinorProgress();
					newPreloadData[currentPCollection.shortName]["averageAspectRatio"] = getAverageAspectRatio(currentPCollection, 1);
					console.log("Average aspect acquired!");
					status.toggleMinorProgress();
				}
			}
			// Update progress
			status.setMajorProgress((i + 1) / api.collections.count);
		}
		// Write to storage
		api.memory.set("preload", newPreloadData);
		preloadData = newPreloadData;
		// Hide status screen
		status.hideStatus();
	}

	property bool detailsKeyEnabled: true

	Keys.onPressed: {
		// Toggle details
		if (api.keys.isDetails(event)) {
			event.accepted = true;
			if (!event.isAutoRepeat && detailsKeyEnabled) {
				console.log("Toggling details...");
				if (menuMode === 0) {
					menuMode = 1;
					gameflowView.middleVisible = false;
					middleVisibleTrueAfterAnimTimer.stop();
				} else {
					menuMode = 0;
					middleVisibleTrueAfterAnimTimer.start();
				}
			}
		}
	}

	Timer {
		id: middleVisibleTrueAfterAnimTimer
		interval: detailsAnimationDuration
		onTriggered: {
			gameflowView.middleVisible = true;
		}
	}

	Timer {
		id: collectionChangeDetailsCooldown
		interval: 300
		onTriggered: {
			detailsKeyEnabled = true;
		}
	}
}
