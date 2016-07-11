local BaseProp = require("app.entity.BaseProp");

local RedDrink = class("RedDrink",BaseProp);

function RedDrink:ctor()
	self.m_propId = 12 ; -- 物品id
	self.m_res = "drink/red_drink.png"; -- 物品资源路径
	self.m_extraValues = 50; -- 额外属性
end

return RedDrink;