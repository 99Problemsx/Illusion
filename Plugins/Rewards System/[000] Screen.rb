#==========================================================
# Reward Screen Scene
#==========================================================
class RewardScreenScene
  GRID_COLS = 5 # Max number of columns in the grid

  def pbStartScene(rewards, lootTable_name, texture, text_color, button_color)
    @rewards = rewards
    @grid_index = 0
    @sprites = {}
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @buttons = ["Claim All", "Discard All"]
    @button_color = button_color

    pbSEPlay("GUI menu open", 80)
    create_loot_table_name(text_color, lootTable_name)
    create_reward_screen(texture)
    pbFadeInAndShow(@sprites)
    show_rewards_with_animation

    loop do
      update

      break if is_reward_empty
    end

    pbPlayCloseMenuSE
    pbEndScene
  end
#=======================================================================
# Other Methods
#=======================================================================
  def update
    pbUpdateSpriteHash(@sprites)
    Graphics.update
    Input.update

    navigation
    update_highlight
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { update }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  def is_reward_empty
    @rewards.each do |reward|
      if reward[:claimed] == false
        return false
      end
    end
    return true
  end
#=======================================================================
# Grid Movement
#=======================================================================
  def navigation
    total_rewards = @rewards.size
    total_slots = total_rewards + @buttons.size
    dynamic_rows = (total_rewards.to_f / GRID_COLS).ceil # Calculate rows based on rewards

    if Input.trigger?(Input::UP)
      if @grid_index >= total_rewards # Check if currently on a button
        @grid_index = 0
        recursive_skip_claimed(:forward)
      else
        move_up(total_rewards, dynamic_rows)
        recursive_skip_claimed(:upwards)
      end
      pbPlayCursorSE
    elsif Input.trigger?(Input::DOWN)
      if @grid_index >= total_rewards # Check if currently on a button
        @grid_index = 0
        recursive_skip_claimed(:forward)
      else
        move_down(total_rewards, dynamic_rows)
        recursive_skip_claimed(:downwards)
      end
      pbPlayCursorSE
    elsif Input.trigger?(Input::LEFT)
      move_left(total_rewards)
      recursive_skip_claimed(:backward)
      pbPlayCursorSE
    elsif Input.trigger?(Input::RIGHT)
      move_right(total_slots)
      recursive_skip_claimed(:forward)
      pbPlayCursorSE
    elsif Input.trigger?(Input::C)
      handle_selection
    end
  end

  def move_up(total_rewards, dynamic_rows)
    if @grid_index >= GRID_COLS
      @grid_index -= GRID_COLS
    elsif @grid_index >= total_rewards
      @grid_index -= GRID_COLS
    else
      @grid_index = total_rewards + @buttons.size - 1 # Wrap to buttons
    end
  end

  def move_down(total_rewards, dynamic_rows)
    if @grid_index < GRID_COLS * (dynamic_rows - 1) && @grid_index + GRID_COLS < total_rewards
      @grid_index += GRID_COLS
    elsif @grid_index < total_rewards
      @grid_index = total_rewards
    else
      @grid_index = 0 # Wrap to top of grid
    end
  end

  def move_left(total_rewards)
    if @grid_index > 0
      @grid_index -= 1
    else
      @grid_index = total_rewards + @buttons.size - 1 # Wrap to last button
    end
  end

  def move_right(total_slots)
    if @grid_index < total_slots - 1
      @grid_index += 1
    else
      @grid_index = 0 # Wrap to first slot
    end
  end

  def recursive_skip_claimed(direction, start_index = nil)
    start_index ||= @grid_index
    step = case direction
           when :forward then 1
           when :backward then -1
           when :upwards then -GRID_COLS
           when :downwards then GRID_COLS
           end

    total_slots = @rewards.size + @buttons.size
    total_rewards = @rewards.size

    # Handle grid and button bounds
    if @grid_index < total_rewards
      return if !@rewards[@grid_index][:claimed]
    else
      return
    end

    @grid_index += step

    # Wrap around logic
    @grid_index = 0 if @grid_index >= total_slots # Wrap forward
    @grid_index = total_slots - 1 if @grid_index < 0 # Wrap backward

    return if @grid_index == start_index

    recursive_skip_claimed(direction, start_index)
  end
#=======================================================================
# Selection
#=======================================================================
  def handle_selection
    if @grid_index < @rewards.size
      reward_index = @grid_index
      reward = @rewards[reward_index]

      if reward[:claimed]
        pbMessage("This reward has already been claimed.")
        recursive_skip_claimed(:forward)
      else
        case reward[:type]
        when :item
          item = reward[:data][:item]
          quantity = reward[:data][:quantity]
          choice = pbMessage("You found #{quantity}x #{item.name}. What would you like to do?", ["Take", "Discard", "Cancel"])
          case choice
          when 0 # Take
            claim_reward(reward)
          when 1 # Discard
            discard_reward(reward)
          when 2 # Cancel

          end
        when :money
          amount = reward[:data]
          choice = pbMessage("You found $#{amount}. What would you like to do?", ["Take", "Discard", "Cancel"])
          case choice
          when 0 # Take
            claim_reward(reward)
          when 1 # Discard
            discard_reward(reward)
          when 2 # Cancel

          end
        when :pokemon
          pokemon = reward[:data]
          choice = pbMessage("You found a #{pokemon.name}! What would you like to do?", ["Take", "Discard", "Cancel"])
          case choice
          when 0 # Take
            claim_reward(reward)
          when 1 # Discard
            discard_reward(reward)
          when 2 # Cancel

          end
        when :card
          card = reward[:data]
          species_name = card.species.to_s.capitalize
          choice = pbMessage("You found an #{species_name} card. What would you like to do?", ["Take", "Discard", "Cancel"])
          case choice
          when 0 # Take
            claim_reward(reward)
          when 1 # Discard
            discard_reward(reward)
          when 2 # Cancel

          end
        else
          pbMessage("Unknown reward type!")
        end
        recursive_skip_claimed(:forward)
      end
    else
      button_index = @grid_index - @rewards.size
      case button_index
      when 0
        claim_all_rewards
      when 1
        discard_all_rewards
      end
    end
    pbPlayDecisionSE
  end

  def claim_reward(reward)
    case reward[:type]
    when :item
      $bag.add(reward[:data][:item], reward[:data][:quantity])
      pbMessage("You received #{reward[:data][:quantity]}x #{reward[:data][:item].name}!")
      reward[:claimed] = true
    when :money
      $player.money += reward[:data]
      pbMessage("You received $#{reward[:data]}!")
      reward[:claimed] = true
    when :pokemon
      pokemon = reward[:data]
      if pbBoxesFull?
        pbMessage(_INTL("There's no more room for Pokémon!") + "\1")
        pbMessage(_INTL("The Pokémon Boxes are full and can't accept any more!"))
        discard_reward(reward)
      else
        species_name = pokemon.speciesName
        pbMEPlay("Battle capture success", 80)
        pbMessage(_INTL("{1} obtained {2}!", $player.name, species_name) + "\\me[pokemon get]\\wtnp[80]")
        was_owned = $player.owned?(pokemon.species)
        $player.pokedex.set_seen(pokemon.species)
        $player.pokedex.set_owned(pokemon.species)
        $player.pokedex.register(pokemon) if true
        # Show Pokédex entry for new species if it hasn't been owned before
        if Settings::SHOW_NEW_SPECIES_POKEDEX_ENTRY_MORE_OFTEN && true && !was_owned &&
           $player.has_pokedex && $player.pokedex.species_in_unlocked_dex?(pokemon.species)
          pbMessage(_INTL("{1}'s data was added to the Pokédex.", species_name))
          $player.pokedex.register_last_seen(pokemon)
          pbFadeOutIn do
            scene = PokemonPokedexInfo_Scene.new
            screen = PokemonPokedexInfoScreen.new(scene)
            screen.pbDexEntry(pokemon.species)
          end
        end
        pbNicknameAndStore(pokemon)
        reward[:claimed] = true
      end
    when :card
      card = reward[:data]
      species_name = card.species.to_s.capitalize
      if $PokemonGlobal.triads.can_add?(card.species, 1)
        $PokemonGlobal.triads.add(card.species, 1)
        pbMessage("You received a #{species_name} card!")
        reward[:claimed] = true
      else
        pbMessage("You can't hold any more of the #{species_name} card!")
        discard_reward(reward)
      end
    else
      pbMessage("Unknown reward type!")
    end
  end

  def discard_reward(reward)
    reward[:claimed] = true
    case reward[:type]
    when :item
      pbMessage("You discarded #{reward[:data][:quantity]}x #{reward[:data][:item].name}.")
    when :money
      pbMessage("You discarded $#{reward[:data]}.")
    when :pokemon
      pbMessage("You released #{reward[:data].name}.")
    when :card
      pbMessage("You discarded a #{reward[:data].species.to_s.capitalize} card.")
    else
      pbMessage("You discarded an unknown reward.")
    end
  end

  def claim_all_rewards
    @rewards.each do |reward|
      next if reward[:claimed]

      reward[:claimed] = true
      claim_reward(reward)
    end
    pbMessage("You claimed all rewards.")
  end

  def discard_all_rewards
    @rewards.each do |reward|
      next if reward[:claimed]

      discard_reward(reward)
    end
    pbMessage("You discarded all rewards.")
  end
#=======================================================================
# MENU BULDING
#=======================================================================
  def create_loot_table_name(color, lootTable_name)
    @sprites["name"] = Sprite.new(@viewport)
    @sprites["name"].bitmap = Bitmap.new(256, 48)
    @sprites["name"].x = Graphics.width / 2 - @sprites["name"].width / 2
    @sprites["name"].y = 14
    pbSetSystemFont(@sprites["name"].bitmap)

    pbDrawOutlineText(@sprites["name"].bitmap, 0, 0, 256, 48, lootTable_name,
      Color.new(color[0], color[1], color[2]),  # Default text color
      Color.new(color[3], color[4], color[5]),  # Shadow color
      1                                         # Center alignment
    )
  end

  def create_reward_screen(texture)
    # Screen BG
    @sprites["screen"] = Sprite.new(@viewport)
    @sprites["screen"].bitmap = RPG::Cache.load_bitmap("Graphics/UI/Reward/", "#{texture}_RewardScreen")
    @sprites["screen"].y = 0
    @sprites["screen"].x = 0
    @sprites["screen"].z = -9999

    # Cursor // Going to rewrite later so it uses bitmap.fill and clear instead of png
    @sprites["cursor"] = Sprite.new(@viewport)
    @sprites["cursor"].bitmap = RPG::Cache.load_bitmap("Graphics/UI/Reward/", "#{texture}_BoxCursor")
    @sprites["cursor"].z = -9997
    @sprites["cursor"].zoom_x = 1.5
    @sprites["cursor"].zoom_y = 1.5
    @sprites["cursor"].visible = false

    @sprites["highlight"] = Sprite.new(@viewport)
    @sprites["highlight"].bitmap = Bitmap.new(54, 54)
    @sprites["highlight"].bitmap.fill_rect(0,0, 54, 54, Settings::HIGHLIGHT_COLOR)
    @sprites["highlight"].z = -9998
    @sprites["highlight"].visible = false
    @sprites["highlight"].opacity = 128

    # Buttons
    button_spacing_x = 300
    base_x = 34
    y = Graphics.height - 62

    @buttons.each_with_index do |b, i|
      @sprites["buttonBox#{i}"] = Sprite.new(@viewport)
      @sprites["buttonBox#{i}"].bitmap = RPG::Cache.load_bitmap(Settings::GRAPHICS_PATH, "#{texture}_ButtonBox")
      @sprites["buttonBox#{i}"].x = base_x + i * button_spacing_x
      @sprites["buttonBox#{i}"].y = y
      @sprites["buttonBox#{i}"].z = -9998

      @sprites["buttonLabel#{i}"] = Sprite.new(@viewport)
      @sprites["buttonLabel#{i}"].bitmap = Bitmap.new(@sprites["buttonBox#{i}"].bitmap.width, @sprites["buttonBox#{i}"].bitmap.height)
      @sprites["buttonLabel#{i}"].x = base_x + i * button_spacing_x
      @sprites["buttonLabel#{i}"].y = y + 16
      pbSetNarrowFont(@sprites["buttonLabel#{i}"].bitmap)

      pbDrawOutlineText(
        @sprites["buttonLabel#{i}"].bitmap,
        0, 0, @sprites["buttonBox#{i}"].bitmap.width, @sprites["buttonBox#{i}"].bitmap.height,
        @buttons[i],
        Color.new(@button_color[0], @button_color[1], @button_color[2]),
        Color.new(@button_color[3], @button_color[4], @button_color[5]),
        1
      )
    end

    reward_boxes_and_icons(texture)
  end

  def reward_boxes_and_icons(texture)
    margin_x = 20
    margin_y = 65
    spacing_x = 100
    spacing_y = 86

    @rewards.each_with_index do |reward, index|
      next unless reward

      box_x = margin_x + (index % GRID_COLS) * spacing_x
      box_y = margin_y + (index / GRID_COLS).floor * spacing_y

      box_type = case reward[:type]
                 when :item then "ItemBox"
                 when :money then "MoneyBox"
                 when :pokemon then "PokemonBox"
                 when :card then "CardBox"
                 end

      @sprites["rewardBox#{index}"] = Sprite.new(@viewport)
      @sprites["rewardBox#{index}"].bitmap = RPG::Cache.load_bitmap(Settings::GRAPHICS_PATH, "#{texture}_#{box_type}")
      @sprites["rewardBox#{index}"].x = box_x
      @sprites["rewardBox#{index}"].y = box_y
      @sprites["rewardBox#{index}"].z = -9998
      @sprites["rewardBox#{index}"].zoom_x = 0.5
      @sprites["rewardBox#{index}"].zoom_y = 0.5
      @sprites["rewardBox#{index}"].opacity = 0

      create_reward_icon(reward, index, box_x, box_y)
    end
  end

  def create_reward_icon(reward, index, box_x, box_y)
    icon_sprite = initialize_icon_sprite(index, box_x, box_y)

    case reward[:type]
    when :item
      setup_item_icon(icon_sprite, reward[:data][:item])
    when :money
      setup_money_icon(icon_sprite, reward[:data])
    when :pokemon
      icon_sprite = setup_pokemon_icon(reward[:data], index, box_x, box_y)
    when :card
      setup_card_icon(icon_sprite, reward[:data], index, box_x, box_y)
    end

    adjust_sprite_position(@sprites["icon#{index}"])
  end

  def initialize_icon_sprite(index, x, y)
    @sprites["icon#{index}"] = IconSprite.new(x, y, @viewport)
  end

  def setup_item_icon(sprite, item)
    sprite.bitmap = item_bitmap(item.id)
    sprite.x -= 1
  end

  def setup_money_icon(sprite, amount)
    icon_name = case amount
                when 10000..       then "RELICGOLD"
                when 5000...10000   then "RELICSILVER"
                else                     "RELICCOPPER"
                end
    sprite.bitmap = RPG::Cache.load_bitmap("Graphics/Items/", icon_name)
    sprite.x -= 1
  end

  def setup_pokemon_icon(pokemon, index, x, y)
    @sprites["icon#{index}"] = PokemonIconSprite.new(pokemon, @viewport)
    @sprites["icon#{index}"].setOffset(PictureOrigin::CENTER)
    @sprites["icon#{index}"].x = x + 4
    @sprites["icon#{index}"].y = y + 26
  end

  def setup_card_icon(sprite, card_data, index, x, y)
    pkmn_icon = RPG::Cache.load_bitmap("Graphics/Pokemon/Icons/", "#{card_data.species}")
    sprite.bitmap = RPG::Cache.load_bitmap("Graphics/UI/Triple Triad/", "card_player")
    sprite.x = x - 4
    sprite.y = y - 12

    @sprites["iconCard#{index}"] = IconSprite.new(x, y, @viewport)
    @sprites["iconCard#{index}"].bitmap = Bitmap.new(pkmn_icon.width, pkmn_icon.height)
    @sprites["iconCard#{index}"].src_rect.set(0, 0, pkmn_icon.width / 2, pkmn_icon.height)
    @sprites["iconCard#{index}"].bitmap.blt(0, 0, pkmn_icon, Rect.new(0, 0, pkmn_icon.width, pkmn_icon.height))
    @sprites["iconCard#{index}"].x = x + 20
    @sprites["iconCard#{index}"].y = y + 16
    @sprites["iconCard#{index}"].opacity = 0
  end

  def adjust_sprite_position(sprite)
    sprite.x += sprite.bitmap.width / 4
    sprite.y += sprite.bitmap.height / 4
    sprite.opacity = 0
  end

  def show_rewards_with_animation
    delay = Settings::DELAY
    times = 0
    type_box = 1.5
    type_icon = 1 #Item, Pokemon & Money
    icon_card = 0.5
    pkmn_card_icon = 0.5

    @rewards.each_with_index do |reward, index|
      next unless reward

      10.times do
        @sprites["rewardBox#{index}"].zoom_x += (type_box - @sprites["rewardBox#{index}"].zoom_x) / 2.0
        @sprites["rewardBox#{index}"].zoom_y += (type_box - @sprites["rewardBox#{index}"].zoom_y) / 2.0
        @sprites["rewardBox#{index}"].opacity += 25

        if reward[:type] == :card
          @sprites["icon#{index}"].zoom_x += (icon_card - @sprites["icon#{index}"].zoom_x) / 2.0
          @sprites["icon#{index}"].zoom_y += (icon_card - @sprites["icon#{index}"].zoom_y) / 2.0
          if @sprites["iconCard#{index}"]
            @sprites["iconCard#{index}"].zoom_x += (pkmn_card_icon - @sprites["iconCard#{index}"].zoom_x) / 2.0
            @sprites["iconCard#{index}"].zoom_y += (pkmn_card_icon - @sprites["iconCard#{index}"].zoom_y) / 2.0
            @sprites["iconCard#{index}"].opacity += 13
          end
        else
          @sprites["icon#{index}"].zoom_x += (type_icon - @sprites["icon#{index}"].zoom_x) / 2.0
          @sprites["icon#{index}"].zoom_y += (type_icon - @sprites["icon#{index}"].zoom_y) / 2.0
        end

        @sprites["icon#{index}"].opacity += 13
        Graphics.update
      end
      pbSEPlay(Settings::REWARD_SOUND, 80, 100 + times * Settings::PITCH_PER_BOX)

      times += 1
      delay.times do
        pbUpdateSpriteHash(@sprites)
        Graphics.update
      end
      delay -= Settings::DECREASE_DELAY_PER_BOX
    end
  end

  def item_bitmap(item_id)
    normalized_name = item_id.to_s
    RPG::Cache.load_bitmap("Graphics/Items/", normalized_name)
  rescue
    RPG::Cache.load_bitmap("Graphics/Items/", "000")
  end

  def update_highlight
    @sprites.each_key do |key|
      if key.start_with?("icon")
        index = key[/\d+/].to_i
        if @rewards[index][:claimed]
          @sprites[key].opacity = 0
        else
          @sprites[key].opacity = (index == @grid_index) ? 255 : 130
        end
      elsif key.start_with?("buttonLabel")
        index = key[/\d+/].to_i
        is_selected = (@rewards.size + index == @grid_index)
        @sprites[key].bitmap.clear
        pbDrawOutlineText(
          @sprites[key].bitmap,
          0, 0, @sprites[key].bitmap.width, @sprites[key].bitmap.height,
          @buttons[index],
          is_selected ? Color.new(255, 255, 255) : Color.new(@button_color[0], @button_color[1], @button_color[2]),  # Highlight or dim
          Color.new(@button_color[3], @button_color[4], @button_color[5]),
          1
        )
      end
    end
    update_cursor
  end

  def update_cursor
    margin_x = 20
    margin_y = 65
    spacing_x = 100
    spacing_y = 86

    if @grid_index < @rewards.size
      # Align cursor to reward boxes
      reward = @rewards[@grid_index]
      box_x = margin_x + (@grid_index % GRID_COLS) * spacing_x
      box_y = margin_y + (@grid_index / GRID_COLS).floor * spacing_y
      @sprites["cursor"].x = box_x - 3
      @sprites["cursor"].y = box_y - 3
      @sprites["cursor"].visible = true
      @sprites["highlight"].x = box_x + 9
      @sprites["highlight"].y = box_y + 9
      @sprites["highlight"].visible = true
    else
      @sprites["cursor"].visible = false
      @sprites["highlight"].visible = false
    end
  end
end
#=======================================================================
# METHOD FOR EVENT
#=======================================================================
def startRewardScreen(loot_table_name, minimum_rewards, custom_texture = "Default", name_color = [128, 128, 128, 0, 0, 0], button_color = [128, 128, 128, 0, 0, 0])

  rewards = LootSystem.get_rewards(loot_table_name, minimum_rewards)

  scene = RewardScreenScene.new
  scene.pbStartScene(rewards, loot_table_name, custom_texture, name_color, button_color)
end
