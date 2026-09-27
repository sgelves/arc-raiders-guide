import Foundation

enum AccessibilityID {
    enum Splash {
        static let title = "splash_title"
        static let subtitle = "splash_subtitle"
        static let initializeButton = "splash_initialize_button"
        static let bootLog = "splash_boot_log"
    }

    enum MainTab {
        static let tabBar = "main_tab_bar"
        static let objectivesTab = "main_tab_objectives"
        static let questsTab = "main_tab_quests"
    }

    enum Objectives {
        static let navigationBar = "objectives_navigation_bar"
        static let segmentedControl = "objectives_segmented_control"
        static let enemiesTab = "objectives_enemies_tab"
        static let materialsTab = "objectives_materials_tab"
        static let itemsTab = "objectives_items_tab"
    }

    enum Enemies {
        static let list = "enemies_list"
        static let cell = "enemies_cell"
        static let cellImage = "enemies_cell_image"
        static let cellTitle = "enemies_cell_title"
    }

    enum Materials {
        static let list = "materials_list"
        static let cell = "materials_cell"
        static let cellImage = "materials_cell_image"
        static let cellTitle = "materials_cell_title"
        static let cellRarity = "materials_cell_rarity"
        static let cellValue = "materials_cell_value"
    }

    enum Items {
        static let list = "items_list"
        static let cell = "items_cell"
        static let cellImage = "items_cell_image"
        static let cellTitle = "items_cell_title"
        static let cellType = "items_cell_type"
        static let cellRarity = "items_cell_rarity"
        static let cellValue = "items_cell_value"
    }

    enum Quests {
        static let list = "quests_list"
        static let followedSection = "quests_followed_section"
        static let availableSection = "quests_available_section"
        static let cell = "quests_cell"
        static let cellTitle = "quests_cell_title"
        static let cellDescription = "quests_cell_description"
        static let cellTraderImage = "quests_cell_trader_image"
        static let cellTraderName = "quests_cell_trader_name"
        static let cellStepCount = "quests_cell_step_count"
    }

    enum QuestMaterials {
        static let cell = "quest_materials_cell"
        static let cellImage = "quest_materials_cell_image"
        static let cellTitle = "quest_materials_cell_title"
        static let cellAmountBadge = "quest_materials_cell_amount_badge"
        static let cellCheckbox = "quest_materials_cell_checkbox"
        static let progressSummary = "quest_materials_progress_summary"
        static let questHeader = "quest_materials_quest_header"
    }
}
