-- 圣剑
local BaseProp = require("app.entity.prop.BaseProp");

local ShengSwallowProp = class("ShengSwallowProp",BaseProp);

function ShengSwallowProp:ctor()
	ShengSwallowProp.super:ctor();
	self.m_propId = 13 ; -- 物品id
	self.m_res = "prop/prop_shengswallow.png"; -- 物品资源路径
	self.m_extraValue = 100; -- 额外属性

	self.m_name = "圣剑"; 
end


return ShengSwallowProp;