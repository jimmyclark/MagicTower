local BaseProp = require("app.entity.BaseProp");

local DefenProp = class("DefenProp",BaseProp);

function DefenProp:ctor()
	DefenProp.super:ctor();
	self.m_propId = 4 ; -- 物品id
	self.m_res = "prop/item1.png"; -- 物品资源路径
	self.m_extraValues = 1; -- 额外属性

	self.m_showTables = {x=32,y=0};
end


return DefenProp;