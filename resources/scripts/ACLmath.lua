local ALCmath = {}

function ALCmath.doMath(DimX, DimY, Size, GridID)

					spacing = Size * 8 --SPACE BETWEEN TILES

					--FIND THE MEDIAN OF BOTH DIMENSIONS
					if DimX % 2 == 1 then
						MedianX = DimX/2 + 0.5
						Xodd = true
					else 
						MedianX = DimX/2
						Xodd = false
					end

					if DimY % 2 == 1 then
					  MedianY = DimY/2 + 0.5
					  Yodd = true
					else 
					  MedianY = DimY/2
					  Yodd = false
					end
				  
					-- FIND ROW AND COLUMN
					row = GridID % DimX
				  
					for a = 1, DimY do

						if GridID <= (a * DimX) then
						
							column = a
							break
						
						end

					end
					-- ACTUAL PROCEDURE
					if Xodd == true then
					  
						if row == MedianX then
						  
						  DistanceX = 0
						  left = false
						  --IF ITS THE MIDDLE
						elseif row < MedianX and row ~= 0 then
						  
						  DistanceX = MedianX - row
						  left = true
						  --IF ITS ON THE LEFT SIDE
						elseif row > MedianX or row == 0 then
						
							if row == 0 then
								DistanceX = DimX - MedianX
							else
								DistanceX = row - MedianX
							end
							left = false
						  --IF ITS ON THE RIGHT
						end
					  
						if left == true then
						  DistanceX = DistanceX * -1
						end
					  
						PosX = (DistanceX * spacing)
					  
					else
						
						DistanceX = 0.5
						
						if row == MedianX then --CHECK IF ITS MIDDLE LEFT
						  left = true
						  
						elseif row == MedianX + 1 then --CHECK IF ITS MIDDLE RIGHT
						  left = false
						  
						elseif row < MedianX and row ~= 0 then --CHECK IF ITS LEFT
						  
						  DistanceX = (MedianX - row) + 0.5
							left = true

						elseif row > MedianX or row == 0 then --CHECK IF ITS RIGHT
						
							if row == 0 then
								  DistanceX = (DimX - MedianX) - 0.5
							else
								  DistanceX = (row - MedianX) - 0.5
							end
							left = false
						end
						  
						if left == true then
						  DistanceX = DistanceX * -1
						end
					  
						PosX = (DistanceX * spacing)
						
					end
				  
				  
					if Yodd == true then
						
						--COPYPASTE X
						
						if column == MedianY then
						  
						  DistanceY = 0
						  down = false
						  --IF ITS THE MIDDLE
						elseif column < MedianY and column ~= 0 then
						  
						  DistanceY = MedianY - column
						  down = false
						  --IF ITS ON THE LEFT SIDE
						elseif column > MedianY or column == 0 then
						
							if column == 0 then
								  DistanceY = DimY - MedianY
							else
								  DistanceY = column - MedianY
							end
							down = true
							--IF ITS ON THE RIGHT
						end
					  
						if down ~= true then
						  DistanceY = DistanceY * -1
						end
						
						PosY = (DistanceY * spacing)
						
						
					else
						
						DistanceY = 0.5
						
						if column == MedianY then --CHECK IF ITS MIDDLE LEFT
						  down = false
						  
						elseif column == MedianY + 1 then --CHECK IF ITS MIDDLE RIGHT
						  down = true
						  
						elseif column < MedianY and column ~= 0 then --CHECK IF ITS LEFT
						  
						  DistanceY = (MedianY - column) + 0.5
							down = false

						elseif column > MedianY or column == 0 then --CHECK IF ITS RIGHT
						
							if column == 0 then
								DistanceY = (DimY - MedianY) - 0.5
							else
								DistanceY = (column - MedianY) - 0.5
							end
							down = true
						end
						  
						if down ~= true then
						  DistanceY = DistanceY * -1
						end
					  
						PosY = (DistanceY * spacing)
						
					end --END OF ODD Y STATEMENT
					
					
					return PosX, PosY
				
				
end
				
				
return ALCmath