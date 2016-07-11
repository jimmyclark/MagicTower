local BaseProp = require("app.entity.BaseProp");

local AttackProp = class("AttackProp",BaseProp);

function AttackProp:ctor()
	AttackProp.super:ctor();
	self.m_propId = 3 ; -- 物品id
	self.m_res = "prop/item1.png"; -- 物品资源路径
	self.m_extraValues = 1; -- 额外属性

	self.m_showTables = {x=0,y=0};

end


return AttackProp;