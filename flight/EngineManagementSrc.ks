@lazyglobal off.

parameter burnStage.

local ignitionDelay is 0.
local activeEngines is list().

runoncepath("/FCFuncs").

// Setup active engine list
local stageEngines is LAS_GetStageEngines(burnStage).

for e in stageEngines
{
    if e:Ignitions <> 0
    {
        activeEngines:Add(e).
            
        if e:Ullage
        {
            // Add half a second for ullage.
            if e:PressureFed
                set ignitionDelay to max(ignitionDelay, 1).
            else
                set ignitionDelay to max(ignitionDelay, 3).
        }
    }
}

global function EM_IgDelay
{
    return ignitionDelay.
}

global function EM_GetEngines
{
    return activeEngines.
}

global function EM_CheckThrust
{
    parameter p.

    return activeEngines[0]:Thrust > activeEngines[0]:PossibleThrust * p.
}
    
global function EM_Ignition
{
    // If we have engines, prep them to ignite.
    if not activeEngines:empty
    {
        // Burn forwards with RCS.
        rcs on.
        set Ship:Control:Fore to 1.
        
        for e in activeEngines
            wait until e:FuelStability >= 0.99.
        
        set Ship:Control:MainThrottle to 1.
        
        for e in activeEngines
            e:Activate.

        wait until EM_CheckThrust(0.8) or activeEngines[0]:Flameout.
        
        set Ship:Control:Fore to 0.
    }
    
    return not activeEngines:empty.
}

global function EM_Shutdown
{
    // Cutoff engines
    for e in activeEngines
        e:Shutdown.
    if not activeEngines:empty
        print "MECO".

    unlock steering.
    set Ship:Control:Neutralize to true.
    rcs off.

    LAS_Avionics("shutdown").
}