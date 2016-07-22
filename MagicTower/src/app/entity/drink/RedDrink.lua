-- 红色药水
local Drink = require("app.entity.drink.Drink");

local RedDrink = class("RedDrink",Drink);

function RedDrink:ctor()
	RedDrink.super:ctor();
	self.m_propId = 21;
	self.m_res = "prop/red_drink.png";
	self.m_extraValue = 50; -- 恢复值
	self.m_name = "red drink";
end

return RedDrink;	