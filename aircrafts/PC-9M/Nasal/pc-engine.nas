# engine 1
var start1 = props.globals.getNode("/controls/engines/start1", 1);
var abort1 = props.globals.getNode("/controls/engines/abort1", 1);

var switchback1 = func() {
	setprop("/controls/engines/run1",1);
	setprop("/controls/engines/start1",0);
	setprop("/controls/engines/abort1",0);
}

var set_engine1_state = func() {
	start1 = getprop("/controls/engines/start1");
	abort1 = getprop("/controls/engines/abort1");
	cutoff1 = getprop("/controls/engines/engine[0]/cutoff");
	fuel_cutoff1 = getprop("/controls/fuel-cutoff1");

	if (start1 and cutoff1 and !fuel_cutoff1)
	{
                # turboprops
		setprop("/controls/engines/engine[0]/starter", 1);
                setprop("/controls/engines/engine[1]/starter", 1);
                setprop("/controls/engines/engine[2]/starter", 1);
                setprop("/controls/engines/engine[3]/starter", 1);
                interpolate("/fdm/jsbsim/propulsion/engine[0]/n1", 20, 15);
                interpolate("/fdm/jsbsim/propulsion/engine[2]/n1", 20, 15);
                interpolate("/fdm/jsbsim/propulsion/engine[3]/n1", 20, 15);
		settimer(func {
                    setprop("/controls/engines/engine[0]/cutoff", 0);
                    setprop("/controls/engines/engine[1]/cutoff", 0);
                    setprop("/controls/engines/engine[2]/cutoff", 0);
                    setprop("/controls/engines/engine[3]/cutoff", 0);
                 }, 16);

		settimer(switchback1, 1);
	}
	if (abort1)
	{
		setprop("/controls/engines/engine[0]/cutoff", 1);
                setprop("/controls/engines/engine[1]/cutoff", 1);
                setprop("/controls/engines/engine[2]/cutoff", 1);
                setprop("/controls/engines/engine[3]/cutoff", 1);
		settimer(switchback1, 1);
	}
}

var set_pitch_fadec = maketimer(0.333333333, func {
	## management of the feathering of the propellers
	## for the moment, if the engine is stopped, we feather the propeller,
        ## otherwise, we put full throttle
	if (getprop("/engines/engine/fuel-flow_pph") == 0) {
		interpolate("/controls/engines/engine/propeller-pitch-fadec", 0, 1);
	} elsif (getprop("/controls/engines/engine/propeller-feather") == 1) {
		##for testing
		interpolate("/controls/engines/engine/propeller-pitch-fadec", 0, 1);
	} else {
		var propeller_pitch = 1; #full power
		##icing
#		propeller_pitch = propeller_pitch - getprop("/sim/icing/propellers");
		interpolate("/controls/engines/engine/propeller-pitch-fadec", propeller_pitch, 1);
	}
});
set_pitch_fadec.start();

setlistener(start1, set_engine1_state);
setlistener(abort1, set_engine1_state);
