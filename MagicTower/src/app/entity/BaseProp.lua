local BaseProp = class("BaseProp");

function BaseProp:ctor()
	self.m_propId = 0 ; -- 物品id
	self.m_res = ""; -- 物品资源路径
	self.m_extraValues = nil; -- 额外属性
	self.m_showTables = nil; -- 显示数组

end

function BaseProp:play()
	
end

function BaseProp:show(x,y)
	if not self.m_showTables then 
		local prop = UICreator.createImg(self.m_res,true,x,y,32,32);
		return prop;
	else
		print(self.m_showTables.x,self.m_showTables.y)
		local prop = display.newTilesSprite(self.m_res,cc.rect(self.m_showTables.x,self.m_showTables.y,32,32));
		prop:pos(x,y);
		return prop;
	end
end

function BaseProp:getValues()
	return self.m_extraValues;
end

return BaseProp;