-- 攻击
local BaseProp = require("app.entity.BaseProp");

local AttackProp = class("AttackProp",BaseProp);

function AttackProp:ctor()
	AttackProp.super:ctor();
	self.m_propId = 11 ; -- 物品id
	self.m_res = "prop/attack.png"; -- 物品资源路径
	self.m_extraValues = 1; -- 额外属性
end


return AttackProp;