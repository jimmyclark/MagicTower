local BaseDoor = class("BaseDoor");

function BaseDoor:ctor()
	self.m_resFiles = {}; -- 要播放的动画文件
	self.m_isPinTu = false; -- 是否是拼图资源
	self.m_resFilesH = {}; -- 拼图序列动画在拼图的高度
	self.m_defaultShow = {}; -- 默认资源
end

function BaseDoor:play()
	if self.m_isPinTu then 

	end
end

function BaseDoor:showDefaultKey(x,y)
	if self.m_isPinTu then
		if type(self.m_defaultShow) == "table" then 
			local image = display.newTilesSprite(self.m_resFiles[1],cc.rect(self.m_defaultShow.x,self.m_defaultShow.y,32,32));
			image:pos(x,y);
			return image;
		end
	end
end

return BaseDoor;

