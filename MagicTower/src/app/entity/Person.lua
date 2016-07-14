local Person = class("Person");

function Person:ctor()
	self.m_id = 0 ; -- 人物id
	self.m_res = ""; -- 物品资源路径

	self.m_sprite = nil;	-- 动物精灵
	self.m_isPlaying = false; -- 是否在动画

	self.m_life = 0; -- 血
	self.m_attack = 0; -- 攻击力
	self.m_defense = 0; -- 防御力
	self.m_coin = 0; --金币数

	self.m_extraValues = nil; -- 额外属性

	self.m_showTables = nil; -- 显示数组

end

function Person:play()
	
end

function Person:show(x,y,anchorX,anchorY,root,direction)

end

return Person;