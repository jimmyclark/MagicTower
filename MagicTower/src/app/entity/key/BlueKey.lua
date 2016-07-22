-- 蓝钥匙
local BaseProp = require("app.entity.prop.BaseProp");

local BlueKey = class("BlueKey",BaseProp);

function BlueKey:ctor()
	BlueKey.super:ctor();
	self.m_propId = 2 ; -- 物品id
	self.m_res = "keys/blue_key.png"; -- 物品资源路径
	self.m_extraValue = 1; -- 额外属性

	self.m_name = "blue key";
end


return BlueKey;