-- 向下的楼梯
local Stair = require("app.entity.stairs.Stair");

local DownStair = class("DownStair",Stair);

function DownStair:ctor()
	DownStair.super:ctor();
	self.m_res = "floor/down_floor.png";
end

return DownStair;	