--[[  
    Addon: Market
    By: SlownLS
]]

-- Thanks to Tesko (https://www.gmodstore.com/users/76561198114219040) for this translation

local LANGUAGE = {
    press_r_to_add_to_cart = "Drücke 'USE' um das Item in dein Warenkorb zulegen",
    
    nameInvalid = "Ungültiger Name",
    modelInvalid = "Ungültiges Model",
    classInvalid = "Ungültige Klasse",
    typeInvalid = "Ungültiges Entitie Typ",
    nameAlreadyTaken = "Dieser Name wird bereits benutzt.",
    dontLookNPC = "Du musst den NPC angucken",
    
    save = "Speichern",
    cart = "Warenkorb",
    model = "Model",
    price = "Preis",
    delete = "Löschen",
    edit = "Edetieren",
    buy = "Kaufen",
    not_enough_money = "Du hast nicht genug Geld",
    purchase_made = "Einkauf gemacht",
    crate = "Kiste",
    amount = "Menge",
    spawn = "Rausnehmen",

    total_price = "Das macht dann %s Dollar",
    cart_empty = "Dein Warenkorb ist leer",

    item_added = "Gegenstand erfolgreich hinzugefügt",
    item_modified = "Gegenstand erfolgreich edetiert",
    item_deleted = "Gegenstand erfolgreich gelöscht",
    item_not_exist = "Dieser Gegenstand exestiert nicht",
    item_reload_to_edit = "Drücke 'R' zum Edetieren",

    invalid_zone = "Ungültige Zone",
    npc_name_not_exist = "Dieser NPC exestiert nicht",
    zone_name_already_taken = "Dieser Zonen-Name wird bereits genutzt",
    zone_added = "Zone erfolgreich hinzugefügt",
    zone_removed = "Zonge erfolgreich gelöscht",
    zone_modified = "Zone erfolgreich edetiert",
    
    name_of_entity = "Entitie Name",
    class_of_entity = "Entitie Klasse",
    price_of_entity = "Entitie Preis",
    type_of_entity = "Entitie Type",
    energy_of_entity = "Energie des Essens",


    config_weapon_reload = "Drücke 'R' um die Zone zu konfigurieren",
    config_weapon_primary = "'LINKSKLICK' um einen Punkt hinzuzufügen",
    config_weapon_secondary = "'RECHTSKLICK' um den letzten Punkt zu löschen",
    config_weapon_name_of_zone = "Zonen Name",
    config_weapon_name_of_npc = "Name des NPC's",
    config_weapon_model_of_npc = "Model des NPC's",


    npc_reload_to_remove = "Drücke 'R' um den NPC zu entfernen",
    npc_added = "NPC erfolgreich hinzugefügt",
    npc_removed = "NPC erfolgreich entfernt",
    npc_modified = "NPC erfolgreich edetiert",
}

SlownLS.Market:AddLanguage("de",LANGUAGE)