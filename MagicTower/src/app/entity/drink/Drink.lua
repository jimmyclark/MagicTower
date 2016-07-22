-- 药水
local BaseProp = require("app.entity.prop.BaseProp");

local Drink = class("Drink",BaseProp);

function Drink:ctor()
	Drink.super:ctor();
	self.m_propId = 0 ; -- 物品id
	self.m_res = ""; -- 物品资源路径
	self.m_extraValue = nil; -- 额外属性

	self.m_sprite = nil; -- 精灵

	self.m_name = "";
end

return Drink;	