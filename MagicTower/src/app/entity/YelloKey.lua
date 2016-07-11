local BaseProp = require("app.entity.BaseProp");

local YelloKey = class("YelloKey",BaseProp);

function YelloKey:ctor()
	YelloKey.super:ctor();
	self.m_propId = 1 ; -- 物品id
	self.m_res = "door/yellow_door.png"; -- 物品资源路径
	self.m_extraValues = 1; -- 额外属性
end


return YelloKey;