import QtQuick 2.8

Item {
	visible: false

	property var localization: {
		"en": {
			name: "English (US)",

			pop_dismiss: "Dismiss",
			updpop_header: "New Update:",
			updpop_get: "Get New Version",
			updpop_info: `
			reflow has detected a new version has been released. You are currently using version ${theme.version}. Please visit <a href="https://github.com/Fr75s/reflow/releases/latest">the latest release</a> to download the update.
			`,

			details_not_applicable: "N/A",
			details_last_played: "Last Played",
			details_last_played_never: "Never",
			details_play_time: "Play Time",
			details_play_time_never: "Never Played",
			details_play_time_s: " sec.",
			details_play_time_m: " min.",
			details_play_time_h: " hrs.",
			details_rating: "Rating",

			main_menu_collections: "Collections",
			main_menu_settings: "Settings",
			main_menu_search: "Search",

			settings_subpages: "Subsections",
			settings_header_general: "General",

			settings_subpage_appearance: "Appearance",
			settings_appearance_lightmode: "Light Mode",
			settings_appearance_theme: "Interface Theme",
			settings_appearance_zoom: "Interface Zoom",

			settings_subpage_behavior: "Behavior",
			settings_behavior_carouselup: "Up → Main Menu",

			settings_subpage_localization: "Localization",
			settings_localization_lang: "Language",
			settings_localization_24h: "24 Hour Clock",

			settings_other: "Other Settings",
			settings_other_repreload: "Redo Preload",
		},

		"en-gb": {
			name: "English (UK)",

			pop_dismiss: "Dismiss",
			updpop_header: "[]",
			updpop_get: "Get New Version",
			updpop_info: `
			[]
			`,

			details_not_applicable: "[]",
			details_last_played: "[]",
			details_last_played_never: "[]",
			details_play_time: "[]",
			details_play_time_never: "[]",
			details_play_time_s: "[]",
			details_play_time_m: "[]",
			details_play_time_h: "[]",
			details_rating: "[]",

			main_menu_collections: "[]",
			main_menu_settings: "[]",
			main_menu_search: "[]",

			settings_subpages: "Subsections",
			settings_header_general: "General",

			settings_subpage_appearance: "Appearance",
			settings_appearance_lightmode: "Light Mode",
			settings_appearance_theme: "Interface Theme",
			settings_appearance_zoom: "Interface Zoom",

			settings_subpage_behavior: "Behaviour",
			settings_behavior_carouselup: "Up → Main Menu",

			settings_subpage_localization: "Localisation",
			settings_localization_lang: "Language",
			settings_localization_24h: "[]",

			settings_other: "Other Settings",
			settings_other_repreload: "Redo Preload",
		},

		"de": {
			name: "Deutsch",

			pop_dismiss: "[]",
			updpop_header: "[]",
			updpop_get: "[]",
			updpop_info: `
			[]
			`,

			details_not_applicable: "[]",
			details_last_played: "[]",
			details_last_played_never: "[]",
			details_play_time: "[]",
			details_play_time_never: "[]",
			details_play_time_s: "[]",
			details_play_time_m: "[]",
			details_play_time_h: "[]",
			details_rating: "[]",

			main_menu_collections: "[]",
			main_menu_settings: "[]",
			main_menu_search: "[]",

			settings_subpages: "Unterabschnitte",
			settings_header_general: "Allgemein",

			settings_subpage_appearance: "Aussehen",
			settings_appearance_lightmode: "Lichtmodus",
			settings_appearance_theme: "Schnittstellenthema",
			settings_appearance_zoom: "Schnittstellenzoom",

			settings_subpage_behavior: "Verhalten",
			settings_behavior_carouselup: "Ob → Hauptmenü",

			settings_subpage_localization: "[]",
			settings_localization_lang: "[]",
			settings_localization_24h: "[]",

			settings_other: "Andere Einstellungen",
			settings_other_repreload: "Vorladen wiederholen",
		},

		"nl": {
			name: "Nederlands",

			pop_dismiss: "[]",
			updpop_header: "[]",
			updpop_get: "[]",
			updpop_info: `
			[]
			`,

			details_not_applicable: "[]",
			details_last_played: "[]",
			details_last_played_never: "[]",
			details_play_time: "[]",
			details_play_time_never: "[]",
			details_play_time_s: "[]",
			details_play_time_m: "[]",
			details_play_time_h: "[]",
			details_rating: "[]",

			main_menu_collections: "[]",
			main_menu_settings: "[]",
			main_menu_search: "[]",

			settings_subpages: "Onderafdelingen",
			settings_header_general: "Algemeen",

			settings_subpage_appearance: "Verschijning",
			settings_appearance_lightmode: "Lichte modus",
			settings_appearance_theme: "Interfacethema",
			settings_appearance_zoom: "Interfacezoom",

			settings_subpage_behavior: "Gedrag",
			settings_behavior_carouselup: "Omhoog → Hoofdmenu",

			settings_subpage_localization: "[]",
			settings_localization_lang: "[]",
			settings_localization_24h: "[]",

			settings_other: "Andere instellingen",
			settings_other_repreload: "Voorbelasting hervoeren",
		},

		"bs": {
			name: "Bosanski",

			pop_dismiss: "[]",
			updpop_header: "[]",
			updpop_get: "[]",
			updpop_info: `
			[]
			`,

			details_not_applicable: "[]",
			details_last_played: "[]",
			details_last_played_never: "[]",
			details_play_time: "[]",
			details_play_time_never: "[]",
			details_play_time_s: "[]",
			details_play_time_m: "[]",
			details_play_time_h: "[]",
			details_rating: "[]",

			main_menu_collections: "[]",
			main_menu_settings: "[]",
			main_menu_search: "[]",

			settings_subpages: "Pododjeljci",
			settings_header_general: "Opća podešavanja",

			settings_subpage_appearance: "Izgled",
			settings_appearance_lightmode: "Svijetla postavka",
			settings_appearance_theme: "Tema sučelja",
			settings_appearance_zoom: "Veličina sučelja",

			settings_subpage_behavior: "Ponašanje",
			settings_behavior_carouselup: "Gore → Glavni meni",

			settings_subpage_localization: "[]",
			settings_localization_lang: "[]",
			settings_localization_24h: "[]",

			settings_other: "Druga podešavanja",
			settings_other_repreload: "Ponovi predučitavanje",
		},

		"hr": {
			name: "Hrvatski",

			pop_dismiss: "[]",
			updpop_header: "[]",
			updpop_get: "[]",
			updpop_info: `
			[]
			`,

			details_not_applicable: "[]",
			details_last_played: "[]",
			details_last_played_never: "[]",
			details_play_time: "[]",
			details_play_time_never: "[]",
			details_play_time_s: "[]",
			details_play_time_m: "[]",
			details_play_time_h: "[]",
			details_rating: "[]",

			main_menu_collections: "[]",
			main_menu_settings: "[]",
			main_menu_search: "[]",

			settings_subpages: "Pododjeljci",
			settings_header_general: "Opće postavke",

			settings_subpage_appearance: "Izgled",
			settings_appearance_lightmode: "Svijetla postavka",
			settings_appearance_theme: "Tema sučelja",
			settings_appearance_zoom: "Veličina sučelja",

			settings_subpage_behavior: "Ponašanje",
			settings_behavior_carouselup: "Gore → Glavni izbornik",

			settings_subpage_localization: "[]",
			settings_localization_lang: "[]",
			settings_localization_24h: "[]",

			settings_other: "Druge postavke",
			settings_other_repreload: "Ponovi predučitavanje",
		},

		"sr": {
			name: "Српски",

			pop_dismiss: "[]",
			updpop_header: "[]",
			updpop_get: "[]",
			updpop_info: `
			[]
			`,

			details_not_applicable: "[]",
			details_last_played: "[]",
			details_last_played_never: "[]",
			details_play_time: "[]",
			details_play_time_never: "[]",
			details_play_time_s: "[]",
			details_play_time_m: "[]",
			details_play_time_h: "[]",
			details_rating: "[]",

			main_menu_collections: "[]",
			main_menu_settings: "[]",
			main_menu_search: "[]",

			settings_subpages: "Пододељци",
			settings_header_general: "Општа подешавања",

			settings_subpage_appearance: "Изглед",
			settings_appearance_lightmode: "Светло подешење",
			settings_appearance_theme: "Тема интерфејса",
			settings_appearance_zoom: "Величина интерфејса",

			settings_subpage_behavior: "Понашање",
			settings_behavior_carouselup: "Горе → Главни мени",

			settings_subpage_localization: "[]",
			settings_localization_lang: "[]",
			settings_localization_24h: "[]",

			settings_other: "Друга подешавања",
			settings_other_repreload: "Поновите предучитавање",
		}
	}

	function getLocalization(lang) {
		return localization[lang];
	}

	function getLangs() {
		return Object.keys(localization);
	}

	function getNameMap() {
		let langIDs = Object.keys(localization);
		let langMap = {};
		langIDs.forEach((id) => {
			langMap[id] = localization[id].name;
		});
		return langMap;
	}
}
