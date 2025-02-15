class Battle::Field_sahara < Battle::Field
  def initialize(battle, duration = Battle::Field::DEFAULT_FIELD_DURATION)
    super
    @id                  = :sahara
    @name                = _INTL("Sahara")
    @nature_power_change = :NEEDLEARM
    @mimicry_type        = :GROUND
    @camouflage_type     = :GROUND
    @secret_power_effect = 10 # burn
    @field_announcement  = { :start => _INTL("The air is dry and humid."),
                             :end   => _INTL("The dry air clears!") }

    @multipliers = {
      [:power_multiplier, 1.3, _INTL("The humid air boosted the attack!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[BUG FIRE GROUND ROCK].include?(type) && user.grounded?
      },
      [:power_multiplier, 0.8, _INTL("The water evaporated!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[WATER].include?(type) && user.grounded?
      },
      [:power_multiplier, 1.5, _INTL("The dry earth boosted the attack!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[NEEDLEARM OVERHEAT PINNEEDLE ROCKWRECKER SANDTOMB SCORCHINGSANDS].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("They're coming out of the woodwork!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[ATTACKORDER BUGBUZZ].include?(move.id)
      },
    }

    @effects[:no_charging] = proc { |user, move|
      next true if %i[SOLARBEAM SOLARBLADE].include?(move.id) && user.grounded?
    }

  end
end

Battle::Field.register(:sahara, {
  :trainer_name => [],
  :environment  => [],
  :map_id       => [],
  :edge_type    => [],
})

# Physical moves reduced to 0.8x #
# Ice type moves become Water type #
# The stat changing affects of these moves is increased: Sand Attack Thermal Exchange Defend Order Silver Wind #
# Water type moves have a chance to heal 1/8 of the targets health #
# Terrain Pulse becomes Ground-type #
# Shelter halves damage from Fire Moves #
# Blaze, Torrent & Overgrow decreases the user's Defence on switch in #
# Swarm is increased to 1.6x #
# Chlorophyll, Leaf Guard, Protosynthesis & Flower gift activates on switch in #
# Drizzle & electric surge has no effect #
# Drought causes extremely harsh sunlight #
# Dry skin, Fur Coat & Fluffy reduces HP on switch in & every turn #
# Flare boost & Flash fire are increased to 1.6x #
# Forecast changes to sunny form #
# Ice face, Ice Scales, Refrigerate & Snow Warning have no effect #
# Sand force, Sand Rush & Sand Veil are all activated #
# Protean changes user's type to Ground on switch in #