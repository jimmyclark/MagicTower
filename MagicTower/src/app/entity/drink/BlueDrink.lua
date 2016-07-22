-- 蓝色药水
local Drink = require("app.entity.drink.Drink");

local BlueDrink = class("BlueDrink",Drink);

function BlueDrink:ctor()
	BlueDrink.super:ctor();
	self.m_propId = 22;
	self.m_res = "prop/blue_drink.png";
	self.m_extraValue = 200; -- 恢复值

	self.m_name = "blue drink";
end

return BlueDrink;	