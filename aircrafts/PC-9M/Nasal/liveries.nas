aircraft.livery.init("Aircraft/PC-9M/Models/Liveries");

var init = 1;
var dt = 0.1;
var views = props.globals.getNode("sim").getChildren("view");

# engine[0] : PC-9M
# engine[2] : PC-7
# endine[3] : PC-21

var newModel = func {
  setprop("/sim/hud/visibility[1]", 0);
  setprop("/sim/model/pc9m/pc-7", 0);
  setprop("/sim/model/pc9m/pc-7mk2", 0);
  setprop("/sim/model/pc9m/pc-7mkx", 0);
  setprop("/sim/model/pc9m/pc-9a", 0);
  setprop("/sim/model/pc9m/pc-9m", 0);
  setprop("/sim/model/pc9m/t-6", 0);
  setprop("/sim/model/pc9m/pc-21", 0);
  setprop("/sim/model/pc-7", 0);

  var index = getprop("sim/current-view/view-number");
  var val = getprop("/sim/model/pc9m/dialogs/model-type");
  if (val == "PC-7") {
    setprop("sim/view[0]/config/y-offset-m",  0.86);
    setprop("sim/view[0]/config/z-offset-m", -0.74);
    setprop("sim/view[100]/config/y-offset-m", 0.88);
    setprop("sim/view[100]/config/z-offset-m", 0.63);
    setprop("/sim/model/pc9m/pc-7", 1);
    setprop("/sim/model/pc-7", 1);
    setprop("/fdm/jsbsim/propulsion/engine[0]/hold", 1);
    setprop("/fdm/jsbsim/propulsion/engine[2]/hold", 0);
    setprop("/fdm/jsbsim/propulsion/engine[3]/hold", 1);
    var path = "/PC-7";
    var name = "NLAF Classic";
  } elsif (val == "PC-7 Mk II") {
    setprop("sim/view[0]/config/y-offset-m", 0.85);
    setprop("sim/view[0]/config/z-offset-m", -0.59);
    setprop("sim/view[100]/config/y-offset-m", 0.88);
    setprop("sim/view[100]/config/z-offset-m", 0.86);
    setprop("/sim/model/pc9m/pc-7mk2", 1);
    setprop("/sim/model/pc-7", 1);
    setprop("/fdm/jsbsim/propulsion/engine[0]/hold", 1);
    setprop("/fdm/jsbsim/propulsion/engine[2]/hold", 0);
    setprop("/fdm/jsbsim/propulsion/engine[3]/hold", 1);
    var path = "/PC-7mk";
    var name = "Factory PC-7 Mk II";
  } elsif (val == "PC-7 MKX") {
    setprop("sim/view[0]/config/y-offset-m", 0.85);
    setprop("sim/view[0]/config/z-offset-m", -0.59);
    setprop("sim/view[100]/config/y-offset-m", 0.88);
    setprop("sim/view[100]/config/z-offset-m", 0.86);
    setprop("/sim/model/pc9m/pc-7mkx", 1);
    setprop("/sim/model/pc-7", 1);
    setprop("/fdm/jsbsim/propulsion/engine[0]/hold", 1);
    setprop("/fdm/jsbsim/propulsion/engine[2]/hold", 0);
    setprop("/fdm/jsbsim/propulsion/engine[3]/hold", 1);
    var path = "/PC-7mk";
    var name = "Factory PC-7 MKX";
  } elsif (val == "PC-21") {
    setprop("/sim/hud/visibility[1]", 1);
    setprop("sim/view[0]/config/y-offset-m", 1.0);
    setprop("sim/view[0]/config/z-offset-m", -0.72);
    setprop("sim/view[100]/config/y-offset-m", 1.19);
    setprop("sim/view[100]/config/z-offset-m", 0.71);
    setprop("/sim/model/pc9m/pc-21", 1);
    setprop("/fdm/jsbsim/propulsion/engine[0]/hold", 1);
    setprop("/fdm/jsbsim/propulsion/engine[2]/hold", 1);
    setprop("/fdm/jsbsim/propulsion/engine[3]/hold", 0);
    var path = "/PC-21";
    var name = "Demonstrator HB-HZC";
  } else {
    setprop("sim/view[0]/config/y-offset-m", 0.93);
    setprop("sim/view[0]/config/z-offset-m", -0.28);
    setprop("sim/view[100]/config/y-offset-m", 1.05);
    setprop("sim/view[100]/config/z-offset-m", 1.17);
    setprop("/fdm/jsbsim/propulsion/engine[0]/hold", 0);
    setprop("/fdm/jsbsim/propulsion/engine[2]/hold", 1);
    setprop("/fdm/jsbsim/propulsion/engine[3]/hold", 1);
    if (val == "T-6") {
      setprop("/sim/model/pc9m/t-6", 1);
      var path = "/T-6";
      var name = "USA";
    } else {
      if (val == "PC-9/A") {
        setprop("/sim/model/pc9m/pc-9a", 1);
      } else {
        setprop("/sim/model/pc9m/pc-9m", 1);
      }
      var path = "";
      var name = "Pilatus Factory Demonstrator";
    }
  }

  aircraft.livery.dialog.close();
  aircraft.livery.init("Aircraft/PC-9M/Models/Liveries" ~ path);
  if (!init) aircraft.livery.dialog.toggle();
  init = 0;

  if ((index == 0) or (index == 9)) {
    var y_offset = views[index].getValue("config/y-offset-m");
    var z_offset = views[index].getValue("config/z-offset-m");
    interpolate("sim/current-view/y-offset-m", y_offset, dt);
    interpolate("sim/current-view/z-offset-m", z_offset, dt);
  }
}

settimer(newModel, 2);
