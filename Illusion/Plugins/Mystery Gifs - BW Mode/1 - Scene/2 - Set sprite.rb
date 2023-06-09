module MGBW
	class Show

		#------------#
		# Set bitmap #
		#------------#
		# Image
		def create_sprite(spritename,filename,vp,dir="")
			@sprites[spritename.to_s] = Sprite.new(vp)
			folder = "Mytery Gifs BW"
			file = dir ? "Graphics/Pictures/#{folder}/#{dir}/#{filename}" : "Graphics/Pictures/#{folder}/#{filename}"
			@sprites[spritename.to_s].bitmap = Bitmap.new(file)
		end
		def set_sprite(spritename,filename,dir="")
			folder = "Mytery Gifs BW"
			file = dir ? "Graphics/Pictures/#{folder}/#{dir}/#{filename}" : "Graphics/Pictures/#{folder}/#{filename}"
			@sprites[spritename.to_s].bitmap = Bitmap.new(file)
		end
		# Set ox, oy
		def set_oxoy_sprite(spritename,ox,oy)
			@sprites[spritename.to_s].ox = ox
			@sprites[spritename.to_s].oy = oy
		end
		# Set x, y
		def set_xy_sprite(spritename,x,y)
			@sprites[spritename.to_s].x = x
			@sprites[spritename.to_s].y = y
		end
		# Set zoom
		def set_zoom_sprite(spritename,zoom_x,zoom_y)
			@sprites[spritename.to_s].zoom_x = zoom_x
			@sprites[spritename.to_s].zoom_y = zoom_y
		end
		# Set visible
		def set_visible_sprite(spritename,vsb=false)
			@sprites[spritename.to_s].visible = vsb
		end
		# Set angle
		def set_angle_sprite(spritename,angle)
			@sprites[spritename.to_s].angle = angle
		end
		# Set src
		# width, height
		def set_src_wh_sprite(spritename,w,h)
			@sprites[spritename.to_s].src_rect.width = w
			@sprites[spritename.to_s].src_rect.height = h
		end
		# x, y
		def set_src_xy_sprite(spritename,x,y)
			@sprites[spritename.to_s].src_rect.x = x
			@sprites[spritename.to_s].src_rect.y = y
		end
		#------#
		# Text #
		#------#
		# Draw
		def create_sprite_2(spritename,vp)
			@sprites[spritename.to_s] = Sprite.new(vp)
			@sprites[spritename.to_s].bitmap = Bitmap.new(Graphics.width,Graphics.height)
		end
		# Write
		def drawTxt(bitmap,textpos,font=nil,fontsize=nil,width=0,pw=false,height=0,ph=false,clearbm=true)
			# Sprite
			bitmap = @sprites[bitmap.to_s].bitmap
			bitmap.clear if clearbm
			# Set font, size
			(font!=nil)? (bitmap.font.name=font) : pbSetSystemFont(bitmap)
			bitmap.font.size = fontsize if !fontsize.nil?
			textpos.each { |i|
				if pw
					i[1] += width==0 ? 0 : width==1 ? bitmap.text_size(i[0]).width/2 : bitmap.text_size(i[0]).width
				else
					i[1] -= width==0 ? 0 : width==1 ? bitmap.text_size(i[0]).width/2 : bitmap.text_size(i[0]).width
				end
				if ph
					i[2] += height==0 ? 0 : height==1 ? bitmap.text_size(i[0]).height/2 : bitmap.text_size(i[0]).height
				else
					i[2] -= height==0 ? 0 : height==1 ? bitmap.text_size(i[0]).height/2 : bitmap.text_size(i[0]).height
				end
				i[2] += 10
			}
			pbDrawTextPositions(bitmap,textpos)
		end
		# Clear
		def clearTxt(bitmap)
			@sprites[bitmap.to_s].bitmap.clear
		end
		#------------------------------------------------------------------------------#
		# Set SE for input
		#------------------------------------------------------------------------------#
		def checkInput(name,exact=false)
			if exact
				if Input.triggerex?(name)
					(name==:X)? pbPlayCloseMenuSE : pbPlayDecisionSE
					return true
				end
			else
				if Input.trigger?(name)
					(name==Input::BACK)? pbPlayCloseMenuSE : pbPlayDecisionSE
					return true
				end
			end
			return false
		end
		#------------------------------------------------------------------------------#
    # Dispose
    def dispose(id=nil)
      (id.nil?)? pbDisposeSpriteHash(@sprites) : pbDisposeSprite(@sprites,id)
    end
    # Update (just script)
    def update
      pbUpdateSpriteHash(@sprites)
    end
    # Update
    def update_ingame
      Graphics.update
      Input.update
      pbUpdateSpriteHash(@sprites)
    end
    # End
    def endScene
      # Dipose sprites
      self.dispose
      # Dispose viewport
      @viewport.dispose
			@blackvp.dispose
    end

	end
end