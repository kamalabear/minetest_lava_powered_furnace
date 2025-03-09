local modpath = minetest.get_modpath("lava_powered_furnace")

-- Extend furnace to have infinite fuel when placed above lava

minetest.register_node("lava_powered_furnace:lava_furnace_fuel", {
    description = "Lava Fuel",
    drawtype = "none",
    pointable = "blocking",  -- If true, can be pointed at
    diggable = false,  -- If false, can never be dug
    is_ground_content = false,
    groups = {cracky = 1, flammable = 2},
    tiles = {"lava_furnace_fuel.png"},
    inventory_image = "lava_furnace_fuel.png",
    wield_image = "lava_furnace_fuel.png",
})

minetest.register_craft({
	type = "fuel",
	recipe = "lava_powered_furnace:lava_furnace_fuel",
	burntime = 9,
})

minetest.register_abm({
nodenames = {"default:furnace"},
neighbors = {"default:lava_flowing", "default:lava_source"},
interval = 1.0,
chance = 1,
catch_up = true,
action = function(pos, node, active_object_count, active_object_count_wider)
    minetest.log("action", "Found a furnace by lava - adding lava fuel to the furnace")
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    if inv:is_empty("fuel") and not inv:is_empty("src")  then
        inv:add_item("fuel", ItemStack("lava_powered_furnace:lava_furnace_fuel 2"))
        local timer = minetest.get_node_timer(pos)
        timer:start(0.1) -- in seconds
    end
end
})
-- *** FURNACE TESTS ***
-- local orig_active = default.get_furnace_active_formspec

-- function new_active(fuel_percent, item_percent)
-- 	local formspec = orig_active(fuel_percent, item_percent)
-- 	minetest.log("[lava_powered_furnace]formspec before replace = "..formspec)
-- 	formspec = string.gsub(formspec, "list%[context;fuel.?]", "")
-- 	minetest.log("[lava_powered_furnace]formspec after replace = "..formspec)
-- 	return formspec
-- end

-- default.get_furnace_active_formspec = new_active

-- local orig_inactive = default.get_furnace_inactive_formspec

-- function new_inactive()
-- 	local formspec = orig_inactive()
-- 	minetest.log("[lava_powered_furnace]formspec before replace = "..formspec)
-- 	formspec = string.gsub(formspec, "list%[context;fuel.?]", "")
-- 	minetest.log("[lava_powered_furnace]formspec after replace = "..formspec)
-- 	return formspec
-- end

-- default.get_furnace_inactive_formspec = new_inactive

-- local meta = minetest.get_meta({type="detached", name="formspec"})
-- local inv = meta:get_inventory()
-- local srclist, fuellist
-- srclist = inv:get_list("src")
-- fuellist = inv:get_list("fuel")

minetest.register_chatcommand("formspec", {
	func = function(name, param)
		local inv = minetest.get_inventory({type="player", name=name})
		local srclist, fuellist
		srclist = inv:get_list("src")
		fuellist = inv:get_list("fuels")
		minetest.show_formspec(name, "lava_powered_furnace:form", default.get_furnace_inactive_formspec())
	end
})
