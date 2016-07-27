-- 圣盾
local BaseProp = require("app.entity.prop.BaseProp");

local ShengShieldProp = class("ShengShieldProp",BaseProp);

function ShengShieldProp:ctor()
	ShengShieldProp.super:ctor();
	self.m_propId = 14 ; -- 物品id
	self.m_res = "prop/prop_shengshield.png"; -- 物品资源路径
	self.m_extraValue = 100; -- 额外属性

	self.m_name = "圣盾"; 
end


return ShengShieldProp;