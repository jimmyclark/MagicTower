-- 蓝门
local Door = require("app.entity.door.BaseDoor");

local RedDoor = class("RedDoor",Door);

function RedDoor:ctor()
	RedDoor.super:ctor();
	self.m_res = "red_door";

	self.m_name = "red door";
end

return RedDoor;