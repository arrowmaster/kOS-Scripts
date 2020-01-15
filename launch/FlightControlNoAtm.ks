@lazyglobal off.
parameter _0 is 90.
local _1 is 20.
local _2 is 30.
local _3 is cos(_2).
local lock _f0 to 90-vang(Ship:up:vector,Ship:Velocity:Surface).
local _4 is 0.
local _5 is 1.
local _6 is 2.
local _7 is 3.
local _8 is 4.
local _9 is _4.
local function _f1
{
if _9>=_6
{
LAS_UpdateGuidance().
local _10 is LAS_GetGuidanceAim().
if _9=_6
{
if _10:SqrMagnitude>0.9
{
local _11 is LAS_ShipPos():Normalized.
if vdot(_11,_10)<=vdot(_11,Ship:Velocity:Surface:Normalized)
{
_9=_7.
lock Steering to _10.
print"Orbital guidance mode active".
}
}
}
else
{
if _10:SqrMagnitude>0.9
lock Steering to _10.
if LAS_GuidanceCutOff()
{
print"Main engine cutoff".
set Ship:Control:PilotMainThrottle to 0.
local _12 is LAS_GetStageEngines().
for eng in _12
{
if eng:AllowShutdown
eng:Shutdown().
}
set _9 to _8.
}
}
}
else if Ship:VerticalSpeed>=_1
{
if vdot(Ship:SrfPrograde:ForeVector,LAS_ShipPos():Normalized)>_3
{
set _9 to _5.
}
else
{
if LAS_StartGuidance(Stage:Number,-1,0,_0)
set _9 to _6.
}
lock Steering to Heading(_0,min(90-_2,_f0)).
}
else
{
lock Steering to LookDirUp(Ship:Up:Vector,Ship:Facing:TopVector).
}
}
until _9=_8
{
_f1().
wait 0.
}
set Ship:Control:Neutralize to true.
