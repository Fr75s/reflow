# 1.0.0 TODO

x: Even More interface layouts
x: Uniflow compatibility
x: Other coverflow app theme compatibility (?)
x: 3D boxes

# 0.4.0 TODO

x: Built-in update detector
x: Search functionality
x: Non-infinite gameflow
x: Box Art / Marquee switch (further information required)
x: Settings page animation improvements

# 0.3.1

x: Add settings
x: Exit settings page gesture

- Improved look of screenshot gallery in details page
- Added Update Notification popup
	- Fetches the latest release from github and checks if the current version is up to date
- Added game art to background (can be toggled in settings)

# 0.3.0

- Added details screen
	- Contains logo, image gallery & showcase, description, and ability to favorite/unfavorite
	- Accessible via pressing "details" key on a game
- Added favorite banner, which shows if a game is favorited on the collections menu
- Collection selector menu (Accessible by pressing Page Up (L2) or swiping right from bottom left)
- General improvements to mouse/touch based navigation
- Improved Battery Icons
- New Settings:
	- Toggle 24 Hour Clock (Localization » 24 Hour Clock)
	- Language (Localization » Language)
		- Translations available for everything present in v0.2.0 and for some features in v0.3.0
		- New Translations: British English, German, Dutch, Bosnian, Croatian, Serbian
		- Translations provided by Github user SecularSteve

# 0.2.0

- Added Main Menu
- Added Settings page
	- Added Light Mode
	- Added Zoom
	- Added toggle for up button to lead to main menu
	- Added "Redo Preload" action
- Added Background details
- Changed preloading to detect if any games were changed

# 0.1.1

- Get median average aspect ratio instead of mean
- Store average aspect ratios of common consoles
- Preloading process implemented (right now, only gets median aspect ratio for each console not in default aspect ratios)
- New logo

# 0.1.0

- Added Letterboxing/Pillarboxing to boxes that deviate significantly from the average aspect ratio
- Enhanced efficiency of average aspect ratio detection
- Changed Fonts
- Changed to one lower bar with a blur effect
- Enhanced shadow effect

# Longshot Ideas

{requires more advanced XMLHttpRequest knowledge, but DEFINITELY possible as it has been done before}
x: Builtin Preload Scraper (using XMLHttpRequest? easy for missing descriptions and other text data but not images)
x: RetroAchievements

{requires manipulation of files/reading precise image data}
x: Preload blurhash calculations (maybe can be done remotely? but preferrably locally so as to not overload the blurhash website)
x: Preload image scraping
x: Full builtin scraper?
