-- 蓝门
local Door = require("app.entity.door.BaseDoor");

local BlueDoor = class("BlueDoor",Door);

function BlueDoor:ctor()
	BlueDoor.super:ctor();
	self.m_res = "door/blue_door1.png";
end

return BlueDoor;