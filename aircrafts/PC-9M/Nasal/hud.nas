# turn off hud in external views
setlistener("/sim/current-view/view-number", func(n) {
  var val = getprop("/sim/model/pc9m/dialogs/model-type");
  if (val == "PC-21") {
    setprop("/sim/hud/visibility[1]", n.getValue() == 0)
  }
},1);
