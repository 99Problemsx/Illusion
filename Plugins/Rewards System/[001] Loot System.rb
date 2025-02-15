module LootSystem
  #===========================================================
  #=== Reward Types ===
  # :item - Specify the item symbol. Example: :RARECANDY
  # :pokemon - Specify the Pokémon symbol. Example: :PIKACHU
  # :money - Specify the amount of money (integer). Example: 10000
  # :card - Specify the Pokémon symbol for the card. Example: :PIKACHU

  #=== RNG Method ===
  # :weight - (Integer) Example: 8
  # !NOTE! If not specified, the default weight will be 0.
  # :chance - (Float) Example: 0.1 (10%)
  #
  # Weight works by calculating the item's weight relative to the total weight.
  # For example, if a Pokémon has a weight of 5 and the total weight is 30,
  # the chance of selecting that Pokémon is 5/30 or approximately 16.7%.
  #
  # :chance specifies a fixed probability that is unaffected by weights.
  # For example, if :chance is 0.2 (20%), then the item always has a 20% chance
  # of being selected, regardless of other entries in the loot table.

  #=== Extra Parameters for Item ===
  # :quantity - (Integer) Specifies the number of items in the reward stack.

  #=== Extra Parameters for Pokémon ===
  # :level - (Integer) Specifies the Pokémon's level.
  # !NOTE! If not specified, the default level will be 5.
  # :gender - (Boolean or Nil) true = male, false = female, nil = genderless.
  # :form - (Integer) Specifies what form the pokemon is using. Example: :SANDSLASH, form: 1 => Alola Sandslash
  # :nature - (Symbol) Specifies the nature. Example: :ADAMANT
  # :ability - (Symbol) Specifies the ability. Example: :STATIC
  # :moves - (Array of Symbols) Specifies the Pokémon's moves. Example: [:EARTHQUAKE, :FIREBLAST]
  # :shiny - (Boolean) true = shiny, false = not shiny.
  # :shiny_odds - (Integer) Specifies the odds for shiny. Example: 16 (1 in 16 chance).
  # :super_shiny - (Boolean) true = super shiny, false = not super shiny.
  # :super_shiny_odds - (Integer) Specifies the odds for super shiny. Example: 32 (1 in 32 chance).
  # :ivs - (Hash) Custom IV values for each stat.
  # Example: { HP: 31, ATTACK: 20, DEFENSE: 15, SPEED: 25, SPECIAL_ATTACK: 10, SPECIAL_DEFENSE: 5 }
  # :iv_range - (Hash) Randomize IVs within a range for each stat.
  # Example: { HP: (10..20), ATTACK: (15..30) }

  #=== Extra Rules for Pokémon, Items, and Cards ===
  # :can_get_multible - (Boolean) true = The player can get this reward multiple times,
  #                               false = The player can only get one if they don't already own it.
  # :no_limit - (Boolean) true = Multiple copies of this reward can appear on the reward screen,
  #                       false = Limited to one per screen.
  #
  # !NOTE! All entries except money are limited to one without this explicitly specified.

  #=== Extra Parameters ===
  # :time_limit - Specifies a time window during which the reward is available.
  #               Supports both strict and yearly recurring date ranges.
  #
  #   :start - (String) The start date in one of the following formats:
  #            1. "YYYY-MM-DD" (Strict date): A specific start date in the given year.
  #               Example: "2024-10-01" (October 1, 2024).
  #            2. "MM-DD" (Yearly recurring): A recurring start date every year.
  #               Example: "10-01" (October 1, every year).
  #
  #   :end - (String) The end date in one of the following formats:
  #          1. "YYYY-MM-DD" (Strict date): A specific end date in the given year.
  #             Example: "2024-10-31" (October 31, 2024).
  #          2. "MM-DD" (Yearly recurring): A recurring end date every year.
  #             Example: "10-31" (October 31, every year).
  #
  # Example (Strict Date Range):
  # { item: :SPOOKYKEY, weight: 10, time_limit: { start: "2024-10-01", end: "2024-10-31" } }
  #
  # Example (Yearly Recurring Date Range):
  # { item: :CHRISTMASBOX, weight: 5, time_limit: { start: "12-01", end: "12-25" } }
  #
  # Notes:
  # - :time_limit uses UTC (Coordinated Universal Time) for time checks.
  # - Players can manipulate their system clock to access time-limited rewards unless additional protections are implemented.
  # - Ensure the `start` and `end` dates are formatted consistently, either both as "YYYY-MM-DD" or both as "MM-DD".
  # - (Recommendation) if you setup a yearly reward in February, include the leap day February 29 this will automaticlly skip
  #   that day if it is not a leap year.
  #
  # :conditions - (Array of Lambdas) An array of conditions (lambdas) that must all be met
  #               for the reward to appear. These can use any custom logic.
  #
  # Example:
  # { pokemon: :ARCEUS, chance: 0.02, conditions: [
  #     -> { owns_pokemon?(:GIRATINA) && !is_time?(3..10)},
  #     -> { owns_pokemon?(:PALKIA) || owns_pokemon?(:DIALGA) },
  #     -> { has_badges?(8) }
  #   ]
  # }
  #
  # Below are some predefined methods you can use in conditions:
  #
  # owns_pokemon?(species)
  # encountered_pokemon?(species)
  # has_badges?(count)
  # has_money?(amount)
  # is_time?(range)
  # total_pokemon_owned?(count)
  # has_species?(species, form = -1)
  # has_item?(item)
  # switch_enabled?(id)
  # global_variable?(id, value)
  #
  # :fallback - (Hash) Specifies an alternative reward if the primary reward cannot be given.
  #             The fallback inherits the original reward's :weight or :chance, ensuring consistency.
  #
  # Example:
  # { pokemon: :ZAPDOS, weight: 5, fallback: { item: :MASTERBALL } }
  # - If the player already owns ZAPDOS or cannot receive it, the fallback reward (MASTERBALL) is given instead.
  # - The fallback inherits the weight (5) from the original reward.
  #
  # Example with chance:
  # { pokemon: :ZAPDOS, chance: 0.1, fallback: { item: :MASTERBALL } }
  # - If the player already owns ZAPDOS or cannot receive it, the fallback reward (MASTERBALL) is given instead.
  # - The fallback inherits the chance (0.1) from the original reward.
  #
  # Example on nested fallbacks:
  # { pokemon: :ZAPDOS, weight: 5, fallback: {
  #   item: :MASTERBALL, fallback: {
  #     card: :ZAPDOS, fallback: {
  #       money: 1000
  #     }
  #   }
  # } }
  #
  # !Notes!
  # - Fallbacks are processed recursively until a valid reward is found or all fallbacks are exhausted.
  # - Fallbacks do not define their own :weight or :chance. Instead, they inherit these values from the original reward.

  #=== How to Start a Loot Table ===
  # Create an event and use the Script command. Add one of the following:
  # startRewardScreen("Example_Loot_Name", minimum_rewards)
  # or
  # startRewardScreen("Example_Loot_Name", minimum_rewards, "customMenuTexture", [x,x,x,x,x,x], [x,x,x,x,x,x])
  # (If you have other ways of trigger this method that will also work)
  #
  # Parameters:
  # 1. (Required) The name of the loot table (String). Example: "Example_Loot_Name".
  # 2. (Required) Minimum rewards (Integer) between 1 and 15, which determines what the minimum amount of rewards is.
  # 3. (Optional) A custom texture for the screen (String). Example: "CoolUI".
  #    Custom textures must be placed in the Graphics/UI/Reward/ directory.
  #    The default texture is "Default".
  # 4. (Optional) A array of Intergers for the name text for the screen
  #    1-3 is the RGB for the base color
  #    4-6 is the RGB for the shadow around the text
  #    The default is set too [128, 128, 128, 0, 0, 0]
  # 5. (Optional) A array of Intergers for the button text for the screen
  #    1-3 is the RGB for the base color
  #    4-6 is the RGB for the shadow around the text
  #    The default is set too [128, 128, 128, 0, 0, 0]
  #===========================================================

  LOOT_TABLES = {
    "Example 1" => [
      { item: :POTION, weight: 10, can_get_multible: true, no_limit: true },
      { item: :SUPERPOTION, weight: 5, can_get_multible: true, no_limit: true },
      { item: :RARECANDY, weight: 1, can_get_multible: true },
      { pokemon: :PIKACHU, weight: 4, super_shiny_odds: 8, level: 50, can_get_multible: true, no_limit: true, gender: true },
      { pokemon: :MEWTWO, weight: 6, shiny_odds: 16, can_get_multible: true, form: 1 },
      { pokemon: :GROUDON, weight: 2, shiny: true, can_get_multible: false },
      { pokemon: :SANDSLASH, weight: 10, shiny: false  },
      { pokemon: :SANDSLASH, weight: 10, shiny: false, form: 1 },
      { pokemon: :SLAKING, chance: 0.02, super_shiny: true, ability: :HUGEPOWER, nature: :ADAMANT, moves: [:EARTHQUAKE, :EXTREMESPEED] },
      { money: 2000, weight: 3 }, # Gets the relic copper icon if money: is between 1 - 4999
      { money: 5000, weight: 2 }, # Gets the relic silver icon if money: is between 5000 - 9999
      { money: 10000, weight: 1 }, # Gets the relic gold icon if money: is 10000 or more
      { card: :LUCARIO, weight: 5, no_limit: true, time_limit: { start: "12-01", end: "12-30" } },
      { pokemon: :DARKRAI, chance: 0.8, can_get_multible: false, fallback: { card: :DARKRAI, can_get_multible: true } }
    ],
    "Example 2" => [
      { pokemon: :LUCARIO, weight: 4, can_get_multible: true, no_limit: true, ivs: { HP: 31, ATTACK: 31, DEFENSE: 31, SPECIAL_ATTACK: 31, SPECIAL_DEFENSE: 31, SPEED: 31 } },
      { pokemon: :DARKRAI, weight: 4, can_get_multible: false, iv_range: { HP: (30..32), ATTACK: (15..30), SPEED: (0..2) }, fallback: { item: :THUNDERSTONE, can_get_multible: true } },
      { pokemon: :ARCEUS, chance: 0.52, can_get_multible: true,
      conditions: [ #Conditions is just if statements that need all the -> to be true for it to show up
        -> { (owns_pokemon?(:DIALGA) && has_badges?(3)) || (total_pokemon_owned?(200) && !has_money?(50000) && is_time?(12..21)) },
        -> { has_species?(:SANDSLASH, 1) }
      ] },
      { item: :POTION, quantity: 5, weight: 10, no_limit: false, can_get_multible: false, fallback: { pokemon: :SNORLAX, can_get_multible: true }},
    ],
    "Christmas Special Bundle" => [
      { pokemon: :IRONBUNDLE, chance: 0.05, fallback: { item: :BOOSTERENERGY, fallback: { item: :ULTRABALL, can_get_multible: true } } },
      { pokemon: :DELIBIRD, weight: 3, can_get_multible: true},
      { pokemon: :DEERLING, weight: 5, fallback: { pokemon: :SAWSBUCK } },
      { item: :NUGGET, weight: 5, can_get_multible: true, no_limit: true },
      { item: :BIGNUGGET, weight: 1, can_get_multible: true, no_limit: true },
      { card: :IRONBUNDLE, chance: 0.1, can_get_multible: true },
      { money: 2500, weight: 10}
    ]
  }

  #===========================================================
  # Common Conditions
  # These methods provide access to frequently used conditions
  #===========================================================
  def self.owns_pokemon?(species)
    $player.pokedex.owned?(species)
    # Checks if the player owns a specific species.
  end

  def self.encountered_pokemon?(species)
    $player.pokedex.seen?(species)
    # Checks if the player has encountered a specific species.
  end

  def self.has_badges?(count)
    $player.badges.count(true) >= count
    # Checks if the player has at least the specified number of badges.
  end

  def self.has_money?(amount)
    $player.money >= amount
    # Checks if the player has at least the specified amount of money.
  end

  def self.is_time?(range)
    current_hour = Time.now.hour
    range.include?(current_hour)
    # Checks if the current hour falls within a specified range. (UTC)
  end

  def self.total_pokemon_owned?(count)
    $player.pokedex.owned_count >= count
    # Checks if the player owns at least the specified number of Pokémon.
  end

  def self.has_species?(species, form = -1)
    return $player.party.any? { |p| p&.isSpecies?(species) && (form < 0 || p.form == form) }
    # Checks if the player has a specific species in their party, optionally matching a specific form.
  end

  def self.has_item?(item)
    $bag.has?(item)
    # Checks if the player has a specific item in their inventory.
  end

  def self.switch_enabled?(id)
    $game_switches[id]
    # Checks if a specific game switch is enabled.
  end

  def self.global_variable?(id, value)
    $game_variables[id] >= value
    # Checks if a specific game variable is greater than or equal to a specified value.
  end

  #===========================================================
  # Reward Logic
  #===========================================================
  def self.get_rewards(loot_table_name, min_rewards)
    loot_table = LOOT_TABLES[loot_table_name]
    return [] unless loot_table

    # Clamp min_rewards to a range of 1 to 15
    min_rewards = [[min_rewards, 15].min, 1].max
    total_weight = loot_table.sum { |entry| entry[:weight] || 0 }


    n_rewards = min_rewards + rand(0..16 - min_rewards)

    added_entries = []
    rewards = []

    while rewards.size < n_rewards
      loot_table.each do |entry|

        next unless within_time_limit?(entry)
        next unless meets_conditions?(entry)
        if entry[:chance]
          next unless rand < entry[:chance]
        else
          chance = (entry[:weight].to_f / total_weight)
          next unless rand < chance
        end

        reward_entry = resolve_fallback(entry)

        if reward_entry[:pokemon]
          next if !reward_entry[:can_get_multible] && $player.pokedex.owned?(reward_entry[:pokemon])
          next if added_entries.include?(reward_entry[:pokemon]) && !reward_entry[:no_limit]

          pokemon = create_pokemon(reward_entry)
          rewards << { type: :pokemon, data: pokemon, claimed: false }
          added_entries << reward_entry[:pokemon] unless reward_entry[:no_limit]
        elsif reward_entry[:money]
          rewards << { type: :money, data: reward_entry[:money], claimed: false }
        elsif reward_entry[:item]
          next if !reward_entry[:can_get_multible] && $bag.has?(reward_entry[:item])
          next if added_entries.include?(reward_entry[:item]) && !reward_entry[:no_limit]

          item = create_item(reward_entry)
          rewards << { type: :item, data: item, claimed: false }
          added_entries << reward_entry[:item] unless reward_entry[:no_limit]
        elsif reward_entry[:card]
          next if !reward_entry[:can_get_multible] && has_card?(reward_entry[:card])
          next if added_entries.include?(reward_entry[:card]) && !reward_entry[:no_limit]

          card = create_card(reward_entry)
          rewards << { type: :card, data: card, claimed: false }
          added_entries << reward_entry[:card] unless reward_entry[:no_limit]
        end

        break if rewards.size >= n_rewards
      end
    end

    rewards.shuffle.take(15)
  end

  def self.resolve_fallback(entry)
    return entry unless entry[:fallback]

    fallback_entry = entry[:fallback].dup

    if entry[:weight]
      fallback_entry[:weight] = entry[:weight]
    elsif entry[:chance]
      fallback_entry[:chance] = entry[:chance]
    end

    case
    when entry[:pokemon]
      return entry if entry[:can_get_multible] || !$player.pokedex.owned?(entry[:pokemon])
    when entry[:item]
      return entry if entry[:can_get_multible] || !$bag.has?(entry[:item])
    when entry[:card]
      return entry if entry[:can_get_multible] || !has_card?(entry[:card])
    end

    resolve_fallback(fallback_entry)
  end

  def self.create_card(entry)
    card_species = entry[:card]
    card = TriadCard.new(card_species)
    return card
  end

  def self.create_item(entry)
    item = GameData::Item.get(entry[:item])
    quantity = entry[:quantity] || 1
    return { item: item, quantity: quantity }
  end

  def self.create_pokemon(entry)
    pokemon = Pokemon.new(entry[:pokemon], entry[:level] || 5)
    pokemon.form = entry[:form] || -1
    pokemon.ability = entry[:ability] if entry[:ability]
    pokemon.shiny = true if entry[:shiny]
    pokemon.super_shiny = true if entry[:super_shiny]
    pokemon.moves = entry[:moves] if entry[:moves]
    pokemon.nature = entry[:nature] if entry[:nature]

    if entry[:ivs]
      stats = []
      GameData::Stat.each_main { |s| stats.push(s.id) }
      stats.each do |stat|
        if entry[:ivs].key?(stat)
          pokemon.iv[stat] = entry[:ivs][stat]
        else
          pokemon.iv[stat] = rand(0..Pokemon::IV_STAT_LIMIT)
        end
      end
    end
    if entry[:iv_range]

      stats = []
      GameData::Stat.each_main { |s| stats.push(s.id) }
      stats.each do |stat|
        if entry[:iv_range].key?(stat)
          pokemon.iv[stat] = rand(entry[:iv_range][stat])
        else
          pokemon.iv[stat] = rand(0..Pokemon::IV_STAT_LIMIT)
        end
      end
    end

    if entry.key?(:gender)
      if entry[:gender] == true
        pokemon.gender = 0
      elsif entry[:gender] == false
        pokemon.gender = 1
      elsif entry[:gender] == nil
        pokemon.gender = 2
      end
    end

    if entry[:shiny_odds] && rand(entry[:shiny_odds]) == 0
      pokemon.shiny = true
    end
    if entry[:super_shiny_odds] && rand(entry[:super_shiny_odds]) == 0
      pokemon.super_shiny = true
    end

    return pokemon
  end

  def self.within_time_limit?(entry)
    return true unless entry[:time_limit]

    start_date = entry[:time_limit][:start]
    end_date = entry[:time_limit][:end]

    current_time = Time.now.utc
    current_year = current_time.year

    if start_date.count("-") == 2 && end_date.count("-") == 2
      # (YYYY-MM-DD) = Strict
      start_time = Time.utc(*start_date.split("-").map(&:to_i))
      end_time = Time.utc(*end_date.split("-").map(&:to_i))
    elsif start_date.count("-") == 1 && end_date.count("-") == 1
      # (MM-DD) = Yearly
      start_month, start_day = start_date.split("-").map(&:to_i)
      end_month, end_day = end_date.split("-").map(&:to_i)

      # if February 29 is specified
      if start_month == 2 && start_day == 29 && !leap_year?(current_year)
        return false
      end
      if end_month == 2 && end_day == 29 && !leap_year?(current_year)
        return false
      end

      start_time = Time.utc(current_year, start_month, start_day)
      end_time = Time.utc(current_year, end_month, end_day)
    else
      puts "Invalid time_limit format. Use either 'YYYY-MM-DD' or 'MM-DD'."
    end

    start_time <= current_time && current_time <= end_time
  end

  def self.leap_year?(year)
    year % 4 == 0 && year % 100 != 0 || year % 400 == 0
  end

  def self.meets_conditions?(entry)
    return true unless entry[:conditions]
    entry[:conditions].all? { |condition| condition.call }
  end

  def self.has_card?(species)
    $PokemonGlobal.triads.length.times do |i|
      item = $PokemonGlobal.triads[i]
      return true if item[0] == species
    end
    false
  end

end
