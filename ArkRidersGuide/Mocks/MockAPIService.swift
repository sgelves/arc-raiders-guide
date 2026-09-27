import Foundation

nonisolated final class MockAPIService: APIServiceProtocol {
    var mockItems: [Item] = MockData.items
    var mockEnemies: [ArcEnemy] = MockData.enemies
    var mockEnemyDetail: ArcEnemyDetail = MockData.enemyDetail
    var mockQuests: [Quest] = MockData.quests
    var shouldFail = false

    func fetchItems() async throws -> [Item] {
        if shouldFail { throw APIError.invalidResponse }
        return mockItems
    }

    func fetchEnemies() async throws -> [ArcEnemy] {
        if shouldFail { throw APIError.invalidResponse }
        return mockEnemies
    }

    func fetchEnemyDetail(id: String) async throws -> ArcEnemyDetail {
        if shouldFail { throw APIError.invalidResponse }
        return mockEnemyDetail
    }

    func fetchQuests() async throws -> [Quest] {
        if shouldFail { throw APIError.invalidResponse }
        return mockQuests
    }
}

enum MockData {
    static let enemies: [ArcEnemy] = [
        ArcEnemy(id: "wasp", name: "Wasp", updatedAt: "2025-10-23T12:37:58.471Z", icon: "/arc/icons/wasp.svg"),
        ArcEnemy(id: "hornet", name: "Hornet", updatedAt: "2025-10-20T10:12:20.202Z", icon: "/arc/icons/hornet.svg"),
        ArcEnemy(id: "firefly", name: "Firefly", updatedAt: "2026-02-24T12:18:29.206Z", icon: "/arc/icons/snitch.svg"),
        ArcEnemy(id: "snitch", name: "Snitch", updatedAt: "2025-10-20T10:12:20.202Z", icon: "/arc/icons/snitch.svg"),
        ArcEnemy(id: "tick", name: "Tick", updatedAt: "2025-10-20T10:12:20.202Z", icon: "/arc/icons/tick.svg")
    ]

    static let items: [Item] = [
        Item(
            id: "adrenaline_shot",
            name: "Adrenaline Shot",
            description: "A serum that fully restores stamina and temporarily increases stamina regeneration.",
            rarity: "common",
            type: "quick use",
            foundIn: [],
            value: 300,
            icon: "/items/icons/adrenaline_shot.webp",
            updatedAt: "2025-10-20T11:29:16.330Z"
        ),
        Item(
            id: "acoustic_guitar",
            name: "Acoustic Guitar",
            description: "A playable acoustic guitar used to attract ARC's attention, and impress other Raiders.",
            rarity: "legendary",
            type: "quick use",
            foundIn: [],
            value: 7000,
            icon: nil,
            updatedAt: "2025-12-28T14:24:01.035Z"
        ),
        Item(
            id: "advanced_arc_powercell",
            name: "Advanced ARC Powercell",
            description: "Very valuable resource that drops from certain ARC enemies.",
            rarity: "rare",
            type: "misc",
            foundIn: ["ARC"],
            value: 640,
            icon: "/items/icons/advanced_arc_powercell.webp",
            updatedAt: "2025-10-20T11:29:16.330Z"
        ),
        Item(
            id: "wires",
            name: "Wires",
            description: "Copper wires useful for crafting and repairs.",
            rarity: "uncommon",
            type: "topside material",
            foundIn: ["electrical", "technological"],
            value: 200,
            icon: "/items/icons/wires.webp",
            updatedAt: "2025-11-07T20:43:03.418Z"
        ),
        Item(
            id: "agave",
            name: "Agave",
            description: "A piece of an agave leaf. Can be used to regain a small amount of health.",
            rarity: nil,
            type: "nature",
            foundIn: ["nature"],
            value: 1000,
            icon: "/items/icons/agave.webp",
            updatedAt: "2025-10-20T11:29:16.330Z"
        )
    ]

    static let enemyDetail = ArcEnemyDetail(
        id: "vaporizer",
        name: "Vaporizer",
        updatedAt: "2026-03-31T19:50:51.419Z",
        image: "/arc/images/vaporizer.webp",
        icon: "/arc/icons/vaporizer.svg",
        dropTable: [
            Item(
                id: "advanced_arc_powercell",
                name: "Advanced ARC Powercell",
                description: "Very valuable resource that drops from certain ARC enemies.",
                rarity: "rare",
                type: "misc",
                foundIn: ["ARC"],
                value: 640,
                icon: "/items/icons/advanced_arc_powercell.webp",
                updatedAt: "2025-10-20T11:29:16.330Z"
            ),
            Item(
                id: "arc_alloy",
                name: "ARC Alloy",
                description: "Sturdy material from ARC units.",
                rarity: "uncommon",
                type: "topside material",
                foundIn: ["ARC"],
                value: 200,
                icon: "/items/icons/arc_alloy.webp",
                updatedAt: "2025-10-20T11:29:16.330Z"
            )
        ],
        relatedLocationTypes: ["vaporizer"],
        markers: [EnemyMarker(coordinate: [4332.28, 5095.3], mapId: "dam")],
        relatedMaps: [EnemyRelatedMap(id: "dam", name: "Dam Battlegrounds", image: "/maps/images/dam.webp", description: "Alcantara Power Plant")]
    )

    static let quests: [Quest] = [
        Quest(
            id: "picking_up_the_pieces",
            maps: [
                QuestMap(id: "dam", name: "Dam Battlegrounds"),
                QuestMap(id: "spaceport", name: "The Spaceport")
            ],
            steps: [
                QuestStep(title: "Visit any area on your map with a loot category icon", amount: nil),
                QuestStep(title: "Loot 3 containers", amount: 3)
            ],
            title: "Picking Up The Pieces",
            description: "The storm has mostly settled, but much of our infrastructure has taken a proper beating. If you're hoping to work with us, I'll need you to pull your weight in the repair efforts.",
            trader: Trader(
                id: "shani",
                name: "Shani",
                type: "Security",
                description: "Shani fights an uphill battle to keep Speranza safe.",
                image: "/traders/images/shani.webp",
                icon: "/traders/icons/shani.webp"
            ),
            requiredItems: [],
            xpReward: 0,
            updatedAt: "2025-10-31T03:24:27.556Z"
        ),
        Quest(
            id: "clearer_skies",
            maps: [
                QuestMap(id: "dam", name: "Dam Battlegrounds"),
                QuestMap(id: "buried-city", name: "Buried City")
            ],
            steps: [
                QuestStep(title: "Destroy 3 ARC enemies", amount: nil),
                QuestStep(title: "Get 3 ARC Alloy for Shani", amount: nil)
            ],
            title: "Clearer Skies",
            description: "A swarm of disoriented Wasps crashed near one of our skylights. I need you to help thin ARC's ranks before any more accidents happen.",
            trader: Trader(
                id: "shani",
                name: "Shani",
                type: "Security",
                description: "Shani fights an uphill battle to keep Speranza safe.",
                image: "/traders/images/shani.webp",
                icon: "/traders/icons/shani.webp"
            ),
            requiredItems: [
                RequiredItem(
                    item: Item(
                        id: "arc_alloy",
                        name: "ARC Alloy",
                        description: "Sturdy material from ARC units.",
                        rarity: "uncommon",
                        type: "topside material",
                        foundIn: ["ARC"],
                        value: 200,
                        icon: "/items/icons/arc_alloy.webp",
                        updatedAt: "2025-10-20T11:29:16.330Z"
                    ),
                    amount: 3
                )
            ],
            xpReward: 0,
            updatedAt: "2025-11-02T18:58:44.388Z"
        ),
        Quest(
            id: "trash_into_treasure",
            maps: [
                QuestMap(id: "spaceport", name: "The Spaceport"),
                QuestMap(id: "blue-gate", name: "Blue Gate")
            ],
            steps: [
                QuestStep(title: "Obtain 6 Wires", amount: 6),
                QuestStep(title: "Obtain 1 Battery", amount: 1)
            ],
            title: "Trash Into Treasure",
            description: "There's no such thing as junk, to a Raider; just valuable materials waiting to be recycled.",
            trader: Trader(
                id: "shani",
                name: "Shani",
                type: "Security",
                description: "Shani fights an uphill battle to keep Speranza safe.",
                image: "/traders/images/shani.webp",
                icon: "/traders/icons/shani.webp"
            ),
            requiredItems: [],
            xpReward: 0,
            updatedAt: "2025-10-31T03:24:27.556Z"
        )
    ]
}
