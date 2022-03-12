import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops

import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing

import XMonad.Util.EZConfig
import XMonad.Util.Ungrab

main = xmonad 
     . ewmh 
   =<< statusBar "xmobar" myXmobarPP toggleStrutsKey myConfig
  where
    toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
    toggleStrutsKey XConfig{ modMask = m } = (m, xK_b)

myConfig = def
  { modMask            = mod4Mask   -- Rebind Mod to the Super key
  , layoutHook         = spacingRaw True (Border 7 7 7 7) True (Border 7 7 7 7) True $ myLayout   -- Use custom layouts 
  , handleEventHook    = myHandleEventHook
  , startupHook        = myStartupHook
  , focusFollowsMouse  = False
  , normalBorderColor  = "#bd93f9"
  , focusedBorderColor = "lightblue"
  }
  `additionalKeysP`
  [ ("M-S-z", spawn "xscreensaver-command -lock"                )
  , ("M-S-=", unGrab *> spawn "scrot -s"                        )
  , ("M-["  , spawn "code"                                      )
  , ("M-]"  , spawn "brave"                                     )
  , ("<XF86AudioLowerVolume>", spawn "amixer -q sset Master 2%-")
  , ("<XF86AudioRaiseVolume>", spawn "amixer -q sset Master 2%+")
  , ("<XF86AudioMute>", spawn "amixer set Master toggle"        )
  , ("<XF86MonBrightnessDown>", spawn "light -U 10"             )
  , ("<XF86MonBrightnessUp>", spawn "light -A 10"               )
  ]

myLayout = tiled ||| Mirror tiled ||| Full ||| threeCol
  where
    threeCol = ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1     -- Default number of windows in the master pane
    ratio    = 1/2   -- Default proportion of screen occupied by master pane
    delta    = 3/100 -- Percent of screen to increment by when resizing panes

myStartupHook = do
  spawn "feh --bg-fill ~/.wallpapers/haskell-galaxy.jpg"
  spawn "ps cax | grep stalonetray ; if ! [ $? -eq 0 ]; then stalonetray; fi"
myHandleEventHook =
  fullscreenEventHook

myXmobarPP :: PP
myXmobarPP = def
      { ppSep             = blue " - "
      , ppTitle           = wrap (purple "[ ") (purple " ]") . blue . ppWindow
      , ppTitleSanitize   = xmobarStrip
      , ppCurrent         = wrap (purple "[ ") (purple " ]")
      , ppHidden          = white . wrap " " ""
      , ppHiddenNoWindows = lowWhite . wrap " " ""
      , ppUrgent          = red . wrap (yellow "!") (yellow "!")
      }
    where
      -- | Windows should have *some* title, which should not not exceed a
      -- sane length.
      ppWindow :: String -> String
      ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 40

      blue, lowWhite, magenta, red, white, yellow, purple :: String -> String
      magenta  = xmobarColor "#ff79c6" ""
      blue     = xmobarColor "lightblue" ""
      white    = xmobarColor "#f8f8f2" ""
      yellow   = xmobarColor "#f1fa8c" ""
      red      = xmobarColor "#ff5555" ""
      lowWhite = xmobarColor "#bbbbbb" ""
      purple   = xmobarColor "#bd93f9" ""
