-- 蓝门
local Door = require("app.entity.door.BaseDoor");

local RedDoor = class("RedDoor",Door);

function RedDoor:ctor()
	RedDoor.super:ctor();
	self.m_res = "door/red_door1.png";
end

return RedDoor;