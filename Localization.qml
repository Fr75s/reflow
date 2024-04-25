import QtQuick 2.8

Item {
	visible: false

	property var localization: {
		"en": {
			settings_subpages: "Subsections",
			settings_header_general: "General",

			settings_subpage_appearance: "Appearance",
			settings_appearance_lightmode: "Light Mode",
			settings_appearance_theme: "Interface Theme",
			settings_appearance_zoom: "Interface Zoom",

			settings_subpage_behavior: "Behavior",
			settings_behavior_carouselup: "Up → Main Menu",

			settings_other: "Other Settings",
			settings_other_repreload: "Redo Preload",
		}

		"en-gb": {
			settings_subpages: "Subsections",
			settings_header_general: "General",

			settings_subpage_appearance: "Appearance",
			settings_appearance_lightmode: "Light Mode",
			settings_appearance_theme: "Interface Theme",
			settings_appearance_zoom: "Interface Zoom",

			settings_subpage_behavior: "Behaviour",
			settings_behavior_carouselup: "Up → Main Menu",

			settings_other: "Other Settings",
			settings_other_repreload: "Redo Preload",
		}

		"de": {
			settings_subpages: "Unterabschnitte",
			settings_header_general: "Allgemein",

			settings_subpage_appearance: "Aussehen",
			settings_appearance_lightmode: "Lichtmodus",
			settings_appearance_theme: "Schnittstellenthema",
			settings_appearance_zoom: "Schnittstellenzoom",

			settings_subpage_behavior: "Verhalten",
			settings_behavior_carouselup: "Ob → Hauptmenü",

			settings_other: "Andere Einstellungen",
			settings_other_repreload: "Vorladen wiederholen",
		}

		"nl": {
			settings_subpages: "Onderafdelingen",
			settings_header_general: "Algemeen",

			settings_subpage_appearance: "Verschijning",
			settings_appearance_lightmode: "Lichte modus",
			settings_appearance_theme: "Interfacethema",
			settings_appearance_zoom: "Interfacezoom",

			settings_subpage_behavior: "Gedrag",
			settings_behavior_carouselup: "Omhoog → Hoofdmenu",

			settings_other: "Andere instellingen",
			settings_other_repreload: "Voorbelasting hervoeren",
		}

		"bs": {
			settings_subpages: "Pododjeljci",
			settings_header_general: "Opća podešavanja",

			settings_subpage_appearance: "Izgled",
			settings_appearance_lightmode: "Svijetla postavka",
			settings_appearance_theme: "Tema sučelja",
			settings_appearance_zoom: "Veličina sučelja",

			settings_subpage_behavior: "Ponašanje",
			settings_behavior_carouselup: "Gore → Glavni meni",

			settings_other: "Druga podešavanja",
			settings_other_repreload: "Ponovi predučitavanje",
		}

		"hr": {
			settings_subpages: "Pododjeljci",
			settings_header_general: "Opće postavke",

			settings_subpage_appearance: "Izgled",
			settings_appearance_lightmode: "Svijetla postavka",
			settings_appearance_theme: "Tema sučelja",
			settings_appearance_zoom: "Veličina sučelja",

			settings_subpage_behavior: "Ponašanje",
			settings_behavior_carouselup: "Gore → Glavni izbornik",

			settings_other: "Druge postavke",
			settings_other_repreload: "Ponovi predučitavanje",
		}

		"sr": {
			settings_subpages: "Пододељци",
			settings_header_general: "Општа подешавања",

			settings_subpage_appearance: "Изглед",
			settings_appearance_lightmode: "Светло подешење",
			settings_appearance_theme: "Тема интерфејса",
			settings_appearance_zoom: "Величина интерфејса",

			settings_subpage_behavior: "Понашање",
			settings_behavior_carouselup: "Горе → Главни мени",

			settings_other: "Друга подешавања",
			settings_other_repreload: "Поновите предучитавање",
		}
	}

	function getLocalization(lang) {
		return localization[lang]
	}

	function getLangs() {
		return Object.keys(localization)
	}
}
