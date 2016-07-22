-- 黄门
local Door = require("app.entity.door.BaseDoor");

local YellowDoor = class("YellowDoor",Door);

function YellowDoor:ctor()
	YellowDoor.super:ctor();
	self.m_res = "yellow_door";
	self.m_doorId = 1; -- 门类型
	self.m_name = "yellow door";
end

return YellowDoor;