class Battle::Field_city < Battle::Field
  def initialize(battle, duration = Battle::Field::DEFAULT_FIELD_DURATION)
    super
    @id                  = :city
    @name                = _INTL("City")
    @nature_power_change = :SMOG
    @mimicry_type        = :NORMAL
    @camouflage_type     = :NORMAL
    @secret_power_effect = 2 # need to change to poison
    @field_announcement  = { :start => _INTL("The streets are busy..."),
                             :end   => _INTL("The street is cleared!") }

    @multipliers = {
      [:power_multiplier, 1.3, _INTL("In the cracks and the walls!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[BUG].include?(type) && user.grounded?
      },
      [:power_multiplier, 1.3, _INTL("All kinds of pollution strengthened the attack!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[POISON].include?(type) && user.grounded?
      },
      [:power_multiplier, 1.3, _INTL("The right tool for the job!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[STEEL].include?(type) && user.grounded?
      },
      [:power_multiplier, 0.7, _INTL("This is no place for fairytales...")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[FAIRY].include?(type) && user.grounded?
      },
      [:power_multiplier, 1.5, _INTL("An overwhelming first impression!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[FIRSTIMPRESSION].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("A crowd is gathering!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[BEATUP].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("Working 9 to 5 for this!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[PAYDAY].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("The city smog is suffocating!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[SMOG].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("Careful on the street!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[STEAMROLLER].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("The power of science is amazing!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[TECHNOBLAST].include?(move.id)
      },
      [:power_multiplier, 0.5, _INTL("The city is no place for a family!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[POPULATIONBOMB].include?(move.id)
      },
    }

    @effects[:move_second_type] = proc { |effectiveness, move, moveType, defType, user, target|
      next :NORMAL if %i[FIRSTIMPRESSION].include?(move.id)
    }

  end
end

Battle::Field.register(:city, {
  :trainer_name => [],
  :environment  => [],
  :map_id       => [],
  :edge_type    => [],
})

# Physical Normal-type moves increase in base power by 1.5x. #
# Big Pecks additionally boosts the user's Defense by 1 stage on switch in. #
# Competitive boosts the bearer's Special Attack by 3 stages when activated. #
# Download boosts bearer's user's Attack or Special Attack by 2 stages when activated. #
# Early Bird additionally boosts the bearer's Attack by 1 stage on switch-in. #
# Frisk additionally lowers the target's Special Defense by 1 stage.  #
# Hustle now boosts damage by 75%, but lowers accuracy by 33%. #
# Pickup and Rattled additionally boost the bearer's Speed by 1 stage on switch in. #
# Stench's activation chance is doubled to 20%. #
# Autotomize boosts the user's Speed by 3 stages. #
# Corrosive Gas additionally lowers all of the target's stats by 1 stage. #
# Poison Gas and Smog never miss and inflict Bad Poison to the target. #
# Recycle additionally boosts a random stat of the user by 1 stage if successful.  #
# Shift Gear boosts the user's Attack and Speed by 2 stages. #
# Smokescreen lowers the target's Accuracy by 2 stages. #
# Work Up boosts the user's Attack and Special Attack by 2 stages. #
# Shelter halves damage from Normal-type moves. #
# Terrain Pulse's type becomes Normal. #

# To change to Back Alley field #
# Any move in this section inherently gains a 1.3x damage boost if it changes the field, unless noted otherwise. #
# This field will transform into Back Alley if any of the moves Covet, Pursuit, or Thief are used. #