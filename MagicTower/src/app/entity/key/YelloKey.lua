-- 黄钥匙
local BaseProp = require("app.entity.prop.BaseProp");

local YelloKey = class("YelloKey",BaseProp);

function YelloKey:ctor()
	YelloKey.super:ctor();
	self.m_propId = 1 ; -- 物品id
	self.m_res = "keys/yellow_key.png"; -- 物品资源路径
	self.m_extraValues = 1; -- 额外属性

	self.m_name = "yellow key";
end


return YelloKey;