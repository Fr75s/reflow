import QtQuick 2.15
import QtGraphicalEffects 1.15

import "../Common"

FocusScope {
	id: gdRoot

	signal favoriteUpdated(bool newValue)
	signal close

	property var currentGame: null

	property bool active: false

	property real currentGameWidth: theme.width * 0.1
	property real currentAAR: 1

	// Index of the screenshot showcase
	property int showcaseIndex: 0
	property int showcaseAOpacityDuration: 300

	readonly property url iconsDir: "../../assets/icon/"
	// Show game stats instead of description
	property bool showStats: false
	// Show and focus screenshot gallery
	property bool showGallery: false

	// Side box
	CoverFit {
		id: gameBox
		game: currentGame

		width: theme.height * 0.35
		height: theme.height * 0.35

		x: parent.width * 0.05
		y: parent.height * 0.15
	}

	// Details Panel
	Rectangle {
		width: parent.width - parent.height * 0.25 - gameBox.width
		height: parent.height * 0.7

		anchors.right: parent.right
		anchors.rightMargin: parent.height * 0.1
		anchors.top: parent.top
		anchors.topMargin: parent.height * 0.125

		color: ocolor(colors.bg1, "80")

		radius: parent.height * 0.025

		border {
			width: 1
			color: ocolor(colors.outline, "60")
		}

		// Logo
		Image {
			width: parent.width * 0.8
			height: parent.height * 0.25

			anchors.right: parent.right
			anchors.rightMargin: parent.width * 0.1
			anchors.top: parent.top
			anchors.topMargin: parent.height * 0.05

			source: currentGame ? currentGame.assets.logo || missingLogo : missingLogo
			fillMode: Image.PreserveAspectFit
			horizontalAlignment: Image.AlignHCenter
			verticalAlignment: Image.AlignTop
			asynchronous: true
		}

		// Description Scroll Area
		Flickable {
			id: descriptionContainer
			width: parent.width * 0.4
			height: parent.height * 0.6

			opacity: showStats ? 0 : 1
			Behavior on opacity {
				NumberAnimation {
					duration: 300
				}
			}
			z: stats.z + 10

			anchors.left: parent.left
			anchors.leftMargin: parent.width * 0.05
			anchors.bottom: parent.bottom
			anchors.bottomMargin: parent.height * 0.05

			flickableDirection: Flickable.VerticalFlick
			clip: true

			contentWidth: width
			contentHeight: descriptionText.contentHeight

			// Description Text
			Text {
				id: descriptionText
				width: parent.width

				text: parseAndRemoveImg(currentGame.description) || "[no description]"
				color: colors.text

				wrapMode: Text.Wrap

				font {
					family: readtext.name
					pixelSize: theme.height * 0.02
				}

				// Remove all <img> tags from content
				function parseAndRemoveImg(content) {
					if (content) {
						// The forbidden art of parsing HTML with regex
						return content.replace(/<img(.*?)>/g, "");
					}
					return "[no description]";
				}
			}

			Keys.onUpPressed: {
				flick(0, 500);
			}
			Keys.onDownPressed: {
				flick(0, -500);
			}

			KeyNavigation.right: playButton
		}

		// Outline for focused description text
		Rectangle {
			anchors.fill: descriptionContainer
			anchors.margins: theme.height * -0.01

			color: "transparent"
			radius: theme.height * 0.01

			opacity: descriptionContainer.focus ? 1 : 0
			Behavior on opacity {
				NumberAnimation {
					easing.type: Easing.InOutQuad
					duration: 200
				}
			}

			border {
				width: 1
				color: colors.outline
			}
		}

		Item {
			id: stats

			opacity: showStats ? 1 : 0
			Behavior on opacity {
				NumberAnimation {
					duration: 300
				}
			}
			anchors.fill: descriptionContainer

			Text {
				id: statsMain

				anchors.fill: parent

				text: `<b>${currentGame.title}</b><br>
				<font size="7">
				${currentGame.releaseYear > 0 ? currentGame.releaseYear : loc.details_not_applicable}
				</font><br><br>
				${loc.details_last_played}: ${!isNaN(currentGame.lastPlayed) ? currentGame.lastPlayed.toLocaleDateString() : loc.details_last_played_never}<br>
				${loc.details_play_time}: <i>${formattedPlaytime(currentGame.playTime)}</i><br>
				${loc.details_rating}: ${formattedRating(currentGame.rating)}<br>
				${loc.details_num_players}: ${formattedNP(currentGame.players)}<br>
				${loc.details_genres}: ${currentGame.genre}<br><br>
				<font size="1">${loc.details_files}: ${formattedFiles(currentGame.files)}</font>
				`;
				color: colors.text

				wrapMode: Text.Wrap

				font {
					family: readtext.name
					pixelSize: theme.height * 0.02
				}

				function formattedPlaytime(playtime) {
					if (playtime === 0) {
						return loc.details_play_time_never
					} else if (playtime < 60) {
						return playtime + loc.details_play_time_s
					} else if (playtime < 3600) {
						return Math.floor(playtime / 60) + loc.details_play_time_m
					} else {
						return Math.floor(playtime / 3600) + loc.details_play_time_h
					}
				}

				function formattedRating(rating) {
					if (rating > 0) {
						return `${Math.round(rating * 100)} / 100`;
					} else {
						return loc.details_not_applicable;
					}
				}

				function formattedNP(num) {
					let out = "";
					for (let i = 0; i < num && i < 8; i++) {
						out += `<img src="../../assets/icon/player.png" align="middle" width="${statsMain.font.pixelSize}" height="${statsMain.font.pixelSize}">`;
					}
					if (num > 8) {
						out += "+";
					}
					return out;
				}

				function formattedFiles(f) {
					let out = "";
					for (let i = 0; i < f.count; i++) {
						out += f.get(i).path + ", ";
					}
					out = out.substring(0, out.length - 2);
					return out;
				}
			}

			Text {
				id: statsSub

				anchors.fill: parent
				verticalAlignment: Text.AlignBottom

				text: `${currentGame.developer}<br>
				<i>${currentGame.publisher}</i>
				`;
				color: colors.text

				wrapMode: Text.Wrap

				font {
					family: readtext.name
					pixelSize: theme.height * 0.015
				}
			}
		}



		// Screenshot Gallery
		ImageShowcase {
			id: galleryBG
			z: gallery.z - 2
			anchors.fill: gallery
			fillSpace: true
			imageList: allScreensAsList(currentGame);
			visible: true
		}

		FastBlur {
			anchors.fill: galleryBG
			source: galleryBG
			radius: 40
		}

		Rectangle {
			anchors.fill: galleryBG
			color: ocolor(colors.bg1, "80")
		}

		ImageShowcase {
			id: gallery
			z: parent.z
			width: parent.width * 0.45
			height: parent.height * 0.4

			anchors.right: parent.right
			anchors.rightMargin: parent.width * 0.05
			anchors.bottom: parent.bottom
			anchors.bottomMargin: parent.height * 0.25

			imageList: allScreensAsList(currentGame);
		}

		// Interaction Buttons
		Row {
			id: buttonRow
			width: parent.width * 0.45
			height: parent.height * 0.15

			spacing: ((width - (height * 4)) > 0 ? (width - (height * 4)) : 0) / 3

			anchors.right: parent.right
			anchors.rightMargin: parent.width * 0.05
			anchors.bottom: parent.bottom
			anchors.bottomMargin: parent.height * 0.05

			// Play Game
			RoundIconButton {
				id: playButton
				width: height > parent.width / 4 ? parent.width / 4 : height
				height: parent.height

				focus: true

				icon: iconsDir + "play.png"
				onAction: {
					launchGame(currentGame);
				}

				KeyNavigation.left: showStats ? null : descriptionContainer
				KeyNavigation.right: favButton
			}

			// Toggle favorite
			RoundIconButton {
				id: favButton
				width: height > parent.width / 4 ? parent.width / 4 : height
				height: parent.height

				icon: iconsDir + (currentGame.favorite ? "fav_full.png" : "fav.png")
				onAction: {
					currentGame.favorite = !currentGame.favorite;
					gdRoot.favoriteUpdated(currentGame.favorite);
				}

				KeyNavigation.left: playButton
				KeyNavigation.right: infoButton
			}

			// Extra Info
			RoundIconButton {
				id: infoButton
				width: height > parent.width / 4 ? parent.width / 4 : height
				height: parent.height

				icon: iconsDir + "info.png"
				onAction: {
					showStats = !showStats;
				}

				KeyNavigation.left: favButton
				KeyNavigation.right: galleryButton
			}

			// Fullscreen Gallery
			RoundIconButton {
				id: galleryButton
				width: height > parent.width / 4 ? parent.width / 4 : height
				height: parent.height

				icon: iconsDir + "gallery.png"
				onAction: {
					if (currentGame && allScreensAsList(currentGame).length > 0)
						showGallery = true;
				}

				KeyNavigation.left: infoButton
			}
		}
	}

	// Fullscreen Screenshot Gallery
	ScreenGallery {
		width: parent.width * 0.95
		height: parent.height * 0.8

		anchors.horizontalCenter: parent.horizontalCenter
		y: showGallery ? parent.height * 0.05 : parent.height * 0.15
		Behavior on y {
			NumberAnimation {
				easing.type: Easing.InOutQuad
				duration: 300
			}
		}

		imageList: allScreensAsList(currentGame);

		opacity: showGallery ? 1 : 0
		Behavior on opacity {
			NumberAnimation {
				duration: 300
			}
		}

		focus: showGallery

		onClose: {
			closeGallery();
		}

		Keys.onPressed: {
			if (api.keys.isDetails(event)) {
				event.accepted = true;
				closeGallery();
			}

			if (api.keys.isCancel(event)) {
				event.accepted = true;
				closeGallery();
			}
		}

		function closeGallery() {
			showGallery = false;
			galleryButton.forceActiveFocus();
		}
	}

	Flickable {
		width: parent.width
		height: parent.height * 0.2

		anchors.bottom: parent.bottom
		enabled: parent.focus

		flickableDirection: Flickable.VerticalFlick
		onFlickStarted: {
			if (verticalVelocity > 800) {
				gdRoot.close();
			}
		}
	}

	// Compile all screenshot/art assets into one list
	/* Assets (in order):
	 * - titlescreen
	 * - screenshotList
	 * - backgroundList
	 * - bannerList
	 */
	function allScreensAsList(game) {
		let out = [];
		if (game) {
			out = out.concat(game.assets.titlescreenList);
			out = out.concat(game.assets.screenshotList);
			out = out.concat(game.assets.backgroundList);
			out = out.concat(game.assets.bannerList);
		}
		return out;
	}
}
