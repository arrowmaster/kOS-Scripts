@lazyglobal off.

global LAS_TargetPe is 185.
global LAS_TargetAp is 185.

// Calc required inclination
runpath("0:/launch/lunarl4l5launch", true).

runpath("0:/launch/launchascentsystem.ks", -1, 0).
