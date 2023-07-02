core.register_chatcommand("pn",{
  description = "Pick node you pointing on. Use `/pn l` for point liquids",
  privs = {creative=true},
  params = "[l]",
  func = function(name,param)
	local player = core.get_player_by_name(name)
	if not player then
		return false, "No player"
	end
	local witem = player:get_wielded_item()
	local def = witem:get_definition()
	local eye_height = player:get_properties().eye_height
	local raybegin = vector.add(player:get_pos(),{x=0, y=eye_height, z=0})
	local rayend = vector.add(raybegin, vector.multiply(player:get_look_dir(), (def.range or 12)))
	local ray = core.raycast(raybegin,rayend,false,(param == "l"))
	local pointed_thing = ray:next()
	if not pointed_thing then
		return false, "Out of range"
	end
	local pos = pointed_thing.under
	local node = core.get_node(pos)
	local nici = core.get_item_group(node.name, "not_in_creative_inventory")
	if nici == 1 and not core.check_player_privs(name,{give=true}) then
		return false, "`give` privilege is required to pick this node"
	end
	player:set_wielded_item(node.name)
	return true, "Picked "..node.name
  end
})
