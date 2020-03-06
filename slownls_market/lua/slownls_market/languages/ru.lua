--[[  
    Addon: Market
    By: SlownLS
]]

-- Thanks to LOyoujoLI (https://www.gmodstore.com/users/LOyoujoLI) for this translation

local LANGUAGE = {
    press_r_to_add_to_cart = "Нажмите E для добавления в корзину",
   
    nameInvalid = "Некорректное имя",
    modelInvalid = "Некорректная модель",
    classInvalid = "Некорректный класс",
    typeInvalid = "Некорректное тип энтити",
    nameAlreadyTaken = "Это имя уже есть",
    dontLookNPC = "Вы должны смотреть на NPC",
   
    save = "Сохр.",
    cart = "Корзина",
    model = "Модель",
    price = "Цена",
    delete = "Удалить",
    edit = "Ред.",
    buy = "Купить",
    not_enough_money = "Недостаточно денег для покупки",
    purchase_made = "Покупка совершена",
    crate = "Упак.",
    amount = "Кол.",
    spawn = "Забрать",
 
 
    total_price = "Это будет стоять %s $",
    cart_empty = "Ваша корзина пустая",
 
 
    item_added = "Придмет добавлен",
    item_modified = "Придмет отредактирован",
    item_deleted = "Придмет удален",
    item_not_exist = "Этого придмета не существует",
    item_reload_to_edit = "Нажмите R для редакт.",
 
 
    invalid_zone = "Некорректная зона",
    npc_name_not_exist = "Этого NPC не существует",
    zone_name_already_taken = "Имя зоны уже занята",
    zone_added = "Зона добавлена",
    zone_removed = "Зона удалена",
    zone_modified = "Зона отредактирована",
   
    name_of_entity = "Имя энтити",
    class_of_entity = "Класс энтити",
    price_of_entity = "Цена энтити",
    type_of_entity = "Тип энтити",
    energy_of_entity = "Сколько даёт к голоду?",
 
 
    config_weapon_reload = "'R' для настройки зоны",
    config_weapon_primary = "'ЛКМ' чтобы добавить точку",
    config_weapon_secondary = "'ПКМ' чтобы удалить последнюю точку",
    config_weapon_name_of_zone = "Имя зоны",
    config_weapon_name_of_npc = "Имя NPC",
    config_weapon_model_of_npc = "Модель NPC",
 
 
    npc_reload_to_remove = "'R' чтобы удалить NPC",
    npc_added = "NPC добавлен",
    npc_removed = "NPC удален",
    npc_modified = "NPC отредактирован",
}

SlownLS.Market:AddLanguage("ru",LANGUAGE)