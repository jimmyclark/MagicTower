-- 向上的楼梯
local Stair = require("app.entity.stairs.Stair");

local UpStair = class("UpStair",Stair);

function UpStair:ctor()
	UpStair.super:ctor();
	self.m_res = "floor/up_floor.png";

	self.m_name = "up_floor";
end

return UpStair;	