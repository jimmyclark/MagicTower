local BaseProp = require("app.entity.BaseProp");

local BlueDrink = class("BlueDrink",BaseProp);

function BlueDrink:ctor()
	self.m_propId = 11 ; -- 物品id
	self.m_res = "drink/blue_drink.png"; -- 物品资源路径
	self.m_extraValues = 200; -- 额外属性
end

return BlueDrink;