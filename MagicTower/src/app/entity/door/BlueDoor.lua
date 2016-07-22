-- 蓝门
local Door = require("app.entity.door.BaseDoor");

local BlueDoor = class("BlueDoor",Door);

function BlueDoor:ctor()
	BlueDoor.super:ctor();
	self.m_res = "blue_door";
	self.m_doorId = 2; -- 门类型
	self.m_name = "blue door";
end

return BlueDoor;