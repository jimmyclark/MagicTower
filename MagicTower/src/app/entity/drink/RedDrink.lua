-- 红色药水
local Drink = require("app.entity.drink.Drink");

local RedDrink = class("RedDrink",Drink);

function RedDrink:ctor()
	RedDrink.super:ctor();
	self.m_res = "prop/red_drink.png";
	self.m_value = 50; -- 恢复值
end

return RedDrink;	