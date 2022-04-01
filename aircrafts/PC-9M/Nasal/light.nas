##########
# Lights #
##########
var strobe_switch = props.globals.getNode("systems/electrical/outputs/strobe-lights", 1);
aircraft.light.new("sim/model/lights/strobe", [0.05, 1.5], strobe_switch);

var beacon_switch = props.globals.getNode("systems/electrical/outputs/beacon", 1);
aircraft.light.new("sim/model/lights/beacon", [0.4, 0.4], beacon_switch);

var taxilight_switch = props.globals.getNode("systems/electrical/outputs/taxi-lights");
var landinglight_switch = props.globals.getNode("systems/electrical/outputs/landing-light");
var lights_timer = maketimer(0.33, func {
    if (landinglight_switch.getBoolValue())
    {
        gearpos = getprop("/gear/gear[1]/position-norm");
        if (gearpos) {
            setprop("/sim/model/lights/landing-lights/state", 1);
        } else {
            setprop("/sim/model/lights/landing-lights/state", 0);
        }
    }

    setprop("/sim/model/lights/taxi-lights/state", 0);
    var val = getprop("/sim/model/pc9m/dialogs/model-type");
    if (val == "PC-21")
    {
        if (taxilight_switch.getBoolValue())
        {   
            WoW = getprop("/gear/gear[0]/wow");
            if (WoW) {
                setprop("/sim/model/lights/taxi-lights/state", 1);
            } else {
                setprop("/sim/model/lights/taxi-lights/state", 0);
            }
        }
    }
});
lights_timer.start();

