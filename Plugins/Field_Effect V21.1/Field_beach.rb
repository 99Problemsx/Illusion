class Battle::Field_beach < Battle::Field
  def initialize(battle, duration = Battle::Field::DEFAULT_FIELD_DURATION)
    super
    @id                  = :beach
    @name                = _INTL("Beach")
    @nature_power_change = :MEDITATE
    @mimicry_type        = :GROUND
    @camouflage_type     = :GROUND
    @secret_power_effect = 3 # lower special attack
    @field_announcement  = { :start    => _INTL("Focus and relax to the sound of crashing waves..."),
                             :continue => _INTL("The waves are still lapping at the shore."),
                             :end      => _INTL("The shore recedes from the battlefield!") }

    @multipliers = {
      [:power_multiplier, 2, _INTL("Sand mixed into the attack!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[MUDBOMB MUDSHOT MUDSLAP SANDTOMB].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("...And with pure focus!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[CLANGOROUSSOULBLAZE HIDDENPOWER STRENGTH].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("The sand strengthened the atttack!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[LANDSWRATH SANDSEARSTORM SCORCHINGSANDS].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("The salty sea strengthened the attack!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[BRINE SALTCURE SEMLLINGSALTS].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("Time for crab!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[CRABHAMMER].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("A shining shell on the beach!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[RAZORSHELL SHELLSIDEARM SHELLTRAP].include?(move.id)
      },
      [:power_multiplier, 1.5, _INTL("Surf's up!")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[MUDDYWATER SURF THOUSANDWAVES WAVECRASH].include?(move.id)
      },
      [:power_multiplier, 1.3, _INTL("...And with full focus...")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[AURASPHERE FOCUSBLAST STOREDPOWER FOCUSPUNCH ZENHEADBUTT].include?(move.id)
      },
      [:power_multiplier, 1.2, _INTL("...And with focus...")] => proc { |user, target, numTargets, move, type, power, mults|
        next true if %i[PSYCHIC].include?(move.id)
      },
    }

    @effects[:end_of_move] = proc { |user, targets, move, numHits|
      if %i[FIRESPIN LEAFTORNADO RAZORWIND TWISTER WHIRLPOOL].include?(move.id)
        battlers = [targets, user].flatten
        lowering_battlers = []
        battlers.each { |battler| lowering_battlers << battler if battler.pbCanLowerStatStage?(:ACCURACY, user, move) }
        next if lowering_battlers.empty?
        @battle.pbDisplay(_INTL("The attack stirred up the ash on the ground!"))
        lowering_battlers.each { |battler| battler.pbLowerStatStage(:ACCURACY, 1, user) }
      end
    }

    @effects[:status_immunity] = proc { |battler, newStatus, yawn, user, show_message, self_inflicted, move, ignoreStatus|
      if %i[CONFUSION].include?(newStatus)
        if battler.pbHasType?(:FIGHTING)
          @battle.pbDisplay(_INTL("{1} was protected from confusion!")) if show_message
          next true
        end
        if battle.hasActiveAbility?(:INNERFOCUS)
          @battle.pbDisplay(_INTL("{1} was protected from confusion because of its focus!")) if show_message
          next true
        end
      end
    }

    @effects[:accuracy_modify] = proc { |user, target, move, modifiers, type|
      modifiers[:base_accuracy] = 0 if user.hasActiveAbility?(%i[INNERFOCUS OWNTEMPO PUREPOWER SANDVEIL STEADFAST])
    }

    @effects[:base_type_change] = proc { |user, move|
      next :FIGHTING if %i[STRENGTH].include?(move.id) # Strength primary typing Fighting
    }

    @effects[:move_second_type] = proc { |effectiveness, move, moveType, defType, user, target|
      next :PSYCHIC if %i[STRENGTH].include?(move.id) # Strength secondary typing Psychic
    }

  end
end

Battle::Field.register(:beach, {
  :trainer_name => [],
  :environment  => [],
  :map_id       => [],
  :edge_type    => [],
})

# Special Flying-type attacks lower all active Pokémon's Accuracy by 1 stage #
# Target has As One or Unnerve = able to change accuracy and evasion changes caused by abilities #
# Sand Force, Sand Rush, Sand Veil, and Zen Mode are always active #
# Water Compaction boosts Special Defense by two stages on activation #
# Sand Spit lowers Accuracy of all foes by 1 stage upon activation #
# Calm Mind boosts the user's Special Attack and Special Defense by 2 stages #
# Focus Blast's accuracy is increased to 90%.  #
# Focus Energy boosts the user's Critical Hit rate by 3 stages. #
# Kinesis and Sand Attack lower the target's Accuracy by 2 stages. #
# Meditate boosts the user's Attack by 3 stages #
# Psych Up additionally cures user's status. #
# Sand Tomb additionally lowers the trapped Pokémon's Accuracy by 1 stage each turn. #
# Shore Up fully restores the user's HP.  #
# Shelter halves damage from Ground-type moves. #
# Terrain Pulse's type becomes Ground #
# Shell Bell now restores HP equal to 25% of the damage dealt. #