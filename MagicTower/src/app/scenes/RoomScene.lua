local RoomScene = class("RoomScene",function()
	return display.newScene("RoomScene");
end)

function RoomScene:ctor()
	self:createLeftLayer();

	self:createMainLayer();
end

kGameWall 	   = 0;  -- 普通墙壁
kGameUpStair   = 1 ; -- 向上楼梯
kGameDownStair = -1; -- 向下楼梯
kGameDoor  	   = 2;  -- 房间门
kGameKey 	   = 3;  -- 房间钥匙
kGameDrink 	   = 4;  -- 药水
kGamePropAttack= 5;  -- 攻击
kGamePropDefen = 6;  -- 防御

function RoomScene:createLeftLayer()
	local layer = display.newColorLayer(cc.c4b(0x8B,0x8B,0xBB, 255));
	layer:addTo(self);

end

function RoomScene:createMainLayer()
	local map = cc.TMXTiledMap:create("map/floor1.tmx");
	map:setPosition(display.cx ,display.cy)
	map:setAnchorPoint(cc.p(0.5,0.5));
	self:addChild(map);

	-- local yelloDoor = map:layerNamed("yello_door");
	

end

function RoomScene:onEnter()

end

function RoomScene:dtor()

end

return RoomScene;