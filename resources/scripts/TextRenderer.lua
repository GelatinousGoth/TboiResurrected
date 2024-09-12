local TextRenderer = {}



local title = Font()
local desc = Font()
local desc2 = Font()
local desc3 = Font()
local name = Font()
local counterTop = Font()
local portCountT = Font()
local ScreenY = 0
local ScreenX = 0
local ScreenYAdjustment = 0
local ScreenXAdjustment = 0


title:Load("font/teammeatfont12.fnt")
name:Load("font/teammeatfont16.fnt")
desc:Load("font/pftempestasevencondensed.fnt")
desc2:Load("font/pftempestasevencondensed.fnt")
desc3:Load("font/pftempestasevencondensed.fnt")
counterTop:Load("font/pftempestasevencondensed.fnt")
portCountT:Load("font/pftempestasevencondensed.fnt")

function TextRenderer:Render(T, D, U, N, C, P, last) --Title, Description, Unlocked, Near

		ScreenY = Isaac.GetScreenHeight()
		ScreenYAdjustment = math.floor((ScreenY - 290) / 2)
		ScreenX = Isaac.GetScreenWidth()
		ScreenXAdjustment = math.floor((ScreenX - 440) / 2)
		
		if ScreenYAdjustment <= 0 then 
			ScreenYAdjustment = 0
		end
		if ScreenXAdjustment <= 0 then 
			ScreenXAdjustment = 0
		end
	
	if (U == true and last == false) or (last == true and C > 0) then
		if ScreenY <= 252.0 or ScreenX <= 473.0 then 
			title:DrawString(T,(21 + ScreenXAdjustment),(185 + ScreenYAdjustment),KColor(1,1,1,1),0,true)
		else
			title:DrawString(T,(50 + ScreenXAdjustment),(210 + ScreenYAdjustment),KColor(1,1,1,1),0,true)
		end
	else
		if ScreenY <= 252.0 or ScreenX <= 473.0 then 
			title:DrawString("? ? ?",(21 + ScreenXAdjustment),(185 + ScreenYAdjustment),KColor(1,1,1,1),0,true)
		else
			title:DrawString("? ? ?",(50 + ScreenXAdjustment),(210 + ScreenYAdjustment),KColor(1,1,1,1),0,true)
		end
	end	

	if ((U == true or N == true) and last == false) or (last == true and C > 0) then
		if D ~= nil then
			local x
			local y
			local D1
			local D2
			local D3
			if ScreenY <= 252.0 or ScreenX <= 473.0 then 
		
				if #D > 30 then 
				
					x = string.find(D, "%s", 25)
					if x == nil then
						x = #D
					end
					D1 = string.sub(D, 1, x)
					desc:DrawString(D1,26 + ScreenXAdjustment,201 + ScreenYAdjustment,KColor(1,1,1,255),0,true)
					
					if #D >= 60 then
						y = string.find(D, "%s", 55)
					
						D2 = string.sub(D, x+1, y)
						D3 = string.sub(D, y+1, #D)
						desc2:DrawString(D2,26 + ScreenXAdjustment,212 + ScreenYAdjustment,KColor(1,1,1,255),0,true)
						desc3:DrawString(D3,26 + ScreenXAdjustment,223 + ScreenYAdjustment,KColor(1,1,1,255),0,true)
					else
						if x ~= #D then
							D2 = string.sub(D, x+1, #D)
							desc2:DrawString(D2,26 + ScreenXAdjustment,212 + ScreenYAdjustment,KColor(1,1,1,255),0,true)
						end
					end
				else
					desc:DrawString(D,26 + ScreenXAdjustment,201 + ScreenYAdjustment,KColor(1,1,1,255),0,true)
				end
		
			else
				if #D > 55 then 
					x = string.find(D, "%s", 45)
					D1 = string.sub(D, 1, x)
					D2 = string.sub(D, x+1, #D)
					desc:DrawString(D1,55 + ScreenXAdjustment,226 + ScreenYAdjustment,KColor(1,1,1,255),0,true)
					desc2:DrawString(D2,55 + ScreenXAdjustment,237 + ScreenYAdjustment,KColor(1,1,1,255),0,true)
				else
					desc:DrawString(D,55 + ScreenXAdjustment,226 + ScreenYAdjustment,KColor(1,1,1,255),0,true)
				end
			end
		else

			if ScreenY <= 252.0 or ScreenX <= 473.0 then 
				desc:DrawString("this is a test shurt",26 + ScreenXAdjustment,228 + ScreenYAdjustment,KColor(1,1,1,255),0,true)
			else
				desc:DrawString("this is a test shurt",55 + ScreenXAdjustment,228 + ScreenYAdjustment,KColor(1,1,1,255),0,true)
			end
			
		end

	else
		if ScreenY <= 252.0 or ScreenX <= 473.0 then 
			desc:DrawString("? ? ?",26 + ScreenXAdjustment,201 + ScreenYAdjustment,KColor(1,1,1,255),0,true)
		else
			desc:DrawString("? ? ?",55 + ScreenXAdjustment,226 + ScreenYAdjustment,KColor(1,1,1,255),0,true)
		end
	end
	
	if C >= 1 then
		if ScreenY <= 252.0 or ScreenX <= 473.0 then 
			name:DrawString(P,10 + ScreenXAdjustment,12 + ScreenYAdjustment,KColor(1,1,1,1),0,true)
		else
			name:DrawString(P,364 + ScreenXAdjustment,8 + ScreenYAdjustment,KColor(1,1,1,1),1,true)
		end

	else
		if ScreenY <= 252.0 or ScreenX <= 473.0 then 
			name:DrawString("? ? ?",10 + ScreenXAdjustment,12 + ScreenYAdjustment,KColor(1,1,1,1),0,true)
		else
			name:DrawString("? ? ?",364 + ScreenXAdjustment,8 + ScreenYAdjustment,KColor(1,1,1,1),1,true)
		end
	end
end

function TextRenderer:RenderCounters(S, BotX, TopX, Counter, CounterTotal, Page, Pages) --Size, Bottom Tile X value, Top Tile X value, Counter, GridAMOUNT, GridPAGE, GridTOTAL 

--[[
YOU WOULD need size, in order to calculate what the correct spacing would be, or at least the SPACING value.
The Y value will always be -64 / 64 for the LINE, so 8 pixels off for the text below and above should be good.
TopX would equal grid[DimX]
BotX would equal the grid[#grid]
CounterTotal would equal the same
Counter would equal portrait.counter
Size would equal portrait.size
]]--
	--portLine:Render(Vector((TopX + (S * 8) + 366), 70))
	--counterLine:Render(Vector((BotX + (S * 8) + 366), 175))
	
	ScreenY = Isaac.GetScreenHeight()
		ScreenYAdjustment = math.floor((ScreenY - 290) / 2)
		ScreenX = Isaac.GetScreenWidth()
		ScreenXAdjustment = math.floor((ScreenX - 440) / 2)
		
		if ScreenYAdjustment <= 0 then 
			ScreenYAdjustment = 0
		end
		if ScreenXAdjustment <= 0 then 
			ScreenXAdjustment = 0
		end
if ScreenY <= 252.0 or ScreenX <= 473.0 then
	counterTop:DrawString(Counter.." / "..CounterTotal, 238 + ScreenXAdjustment, 200 + ScreenYAdjustment,KColor(1,1,1,255),0,true)

	portCountT:DrawString(Page.." / "..Pages, 238 + ScreenXAdjustment, 185 + ScreenYAdjustment,KColor(1,1,1,255),0,true)
else
	counterTop:DrawString(Counter.." / "..CounterTotal, 380 + ScreenXAdjustment, 225 + ScreenYAdjustment,KColor(1,1,1,255),0,true)

	portCountT:DrawString(Page.." / "..Pages, 380 + ScreenXAdjustment, 210 + ScreenYAdjustment,KColor(1,1,1,255),0,true)
end

end

return TextRenderer