-- 消息类
local Message = {};

-- 普通提示语
Message.TOUCH_WALL 			= "Wall,Don't go!";  						-- 碰到墙壁了

Message.NOT_HAVE_YELLOW_KEY = "Sorry,you haven't yellow key." 			-- 没有黄钥匙
Message.USE_YELLOW_KEY 		= "You have used yellow key." 				-- 使用一把黄钥匙
Message.NOT_HAVE_BLUE_KEY 	= "Sorry,you haven't blue key." 			-- 没有蓝钥匙
Message.USE_BLUE_KEY 		= "You have used blue key." 				-- 使用一把蓝钥匙
Message.NOT_HAVE_RED_KEY 	= "Sorry,you haven't red key."  			-- 没有红钥匙
Message.USE_RED_KEY 		= "You have used red key." 					-- 使用一把红钥匙

Message.GET_PROP_PREFIX 	= "You got a %s."							-- 得到道具

Message.ATTACK_ENEMY 		= "You are beating %s \n now." 				-- 正在攻击
Message.ATTACK_NOT_BEAT 	= "You have not enough life \n to beat it." -- 打不过提示
Message.ATTACK_SUCCESS 		= "You have beat %s, \n got %s coins." 		-- 打败了敌人，获取金币

Message.UP_FLOOR   			= "Go upstairs!"; 							-- 上楼
Message.DOWN_FLOOR 			= "Go downstairs!";  						-- 下楼

return Message;