DarkRP.createCategory{
	name = "Smuggling",
	categorises = "entities",
	startExpanded = true,
	color = Color(0, 107, 0, 255),
	canSee = fp{fn.Id, true},
	sortOrder = 255,
}

DarkRP.createCategory{
	name = "Smuggling",
	categorises = "jobs",
	startExpanded = true,
	color = Color(0, 107, 0, 255),
	canSee = fp{fn.Id, true},
	sortOrder = 255,
}

--[[-------------------------------------------------------------------------
Job configuration
---------------------------------------------------------------------------]]
TEAM_TFO = DarkRP.createJob("Smuggler", {
	color = Color(210, 65, 0, 255),
	model = {
		"models/player/Group01/Female_01.mdl",
        "models/player/Group01/Female_02.mdl",
        "models/player/Group01/Female_03.mdl",
        "models/player/Group01/Female_04.mdl",
        "models/player/Group01/Female_06.mdl",
        "models/player/group01/male_01.mdl",
        "models/player/Group01/Male_02.mdl",
        "models/player/Group01/male_03.mdl",
        "models/player/Group01/Male_04.mdl",
        "models/player/Group01/Male_05.mdl",
        "models/player/Group01/Male_06.mdl",
        "models/player/Group01/Male_07.mdl",
        "models/player/Group01/Male_08.mdl",
        "models/player/Group01/Male_09.mdl"
	},
	description = [[As a smuggler your role is to provide to the town shipments of falsified papers, documents and even new identity for some citizens.]],
	weapons = {},
	command = "tfojob",
	max = 2,
	admin = 0,
	salary = 80,
    category = "Smuggling",
})
--[[-------------------------------------------------------------------------
Entities configuration
---------------------------------------------------------------------------]]
DarkRP.createEntity("Static Camera", {
	ent = "tfo_cam",
	model = "models/props/coop_cementplant/phoenix/phoenix_camcorder.mdl",
	price = 900,
	max = 1,
	cmd = "buytfocam",
	allowed = TEAM_TFO
})

DarkRP.createEntity("Darknet device", {
	ent = "tfo_darknet",
	model = "models/props_lab/reciever01b.mdl",
	price = 1500,
	max = 1,
	cmd = "buytfodarknet",
	allowed = TEAM_TFO
})

DarkRP.createEntity("Delivery desk", {
	ent = "tfo_desk",
	model = "models/props/de_train/hr_t/computer_cart_a/computer_cart_a.mdl",
	price = 2050,
	max = 1,
	cmd = "buytfodesk",
	allowed = TEAM_TFO
})

DarkRP.createEntity("Quality Fabricator", {
	ent = "tfo_fabricator",
	model = "models/props_wasteland/laundry_washer003.mdl",
	price = 4350,
	max = 1,
	cmd = "buytfofabricator",
	allowed = TEAM_TFO
})

DarkRP.createEntity("Ink", {
	ent = "tfo_ink",
	model = "models/props_lab/jar01a.mdl",
	price = 225,
	max = 4,
	cmd = "buytfoink",
	allowed = TEAM_TFO
})

DarkRP.createEntity("Paper", {
	ent = "tfo_paper",
	model = "models/props_office/paper_box.mdl",
	price = 165,
	max = 4,
	cmd = "buytfopaper",
	allowed = TEAM_TFO
})

DarkRP.createEntity("Printer (copymachine)", {
	ent = "tfo_printer",
	model = "models/props_interiors/copymachine01.mdl",
	price = 1860,
	max = 1,
	cmd = "buytfoprinter",
	allowed = TEAM_TFO
})


DarkRP.createEntity("Work table", {
	ent = "tfo_table",
	model = "models/props/cs_militia/table_shed.mdl",
	price = 2980,
	max = 1,
	cmd = "buytfotable",
	allowed = TEAM_TFO
})