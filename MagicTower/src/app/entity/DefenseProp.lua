-- 防御
local BaseProp = require("app.entity.BaseProp");

local Defense = class("Defense",BaseProp);

function Defense:ctor()
	Defense.super:ctor();
	self.m_propId = 12 ; -- 物品id
	self.m_res = "prop/defense.png"; -- 物品资源路径
	self.m_extraValues = 1; -- 额外属性
end


return Defense;