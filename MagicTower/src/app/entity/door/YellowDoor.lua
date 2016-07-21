-- 黄门
local Door = require("app.entity.door.BaseDoor");

local YellowDoor = class("YellowDoor",Door);

function YellowDoor:ctor()
	YellowDoor.super:ctor();
	self.m_res = "door/yellow_door1.png";
end

return YellowDoor;