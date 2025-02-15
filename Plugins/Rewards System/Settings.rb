module Settings
  # =======================================================
  # Graphics Path For The UI
  #========================================================
  GRAPHICS_PATH = "Graphics/UI/Reward/"

  #---------------------------------------------------------------------------------------------------------------------
    #========================================================
    # Time It Takes Between Boxes To Show Up
    #========================================================
    DELAY = 20

    #========================================================
    # For Each Box Appearing The Pitch Of The Sound Increases
    # - Starts at 100 after that it is (100 + PITCH_PER_BOX * n_boxes)
    #========================================================
    PITCH_PER_BOX = 6

    #========================================================
    # For Each Box Appearing The Time Between Decreases
    # - if DECREASE_DELAY_PER_BOX = 1 that means decrease with 1 per box
    #   after box 7 the delay is DELAY - 7 or more (DELAY - DECREASE_DELAY_PER_BOX * n_boxes)
    #========================================================
    DECREASE_DELAY_PER_BOX = 2

    #========================================================
    # The Name Of The Sound To Use When Reward Shows On Screen (This uses the pbSEPlay so sounds in SE folder in Auido)
    #========================================================
    REWARD_SOUND = "Battle catch click"
  #---------------------------------------------------------------------------------------------------------------------

  #
  # Color Of The Background Highlight
  #
  HIGHLIGHT_COLOR = Color.new(105, 240, 255)


end
