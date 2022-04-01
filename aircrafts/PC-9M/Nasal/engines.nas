var label = func(txt, posx, posy, desc) {
  cDefaultGroup.createChild("text", desc)
                .setTranslation(posx, posy)
                .setAlignment("left-top")
                .setFont("typewriter.txf")
                .setFontSize(12, 1.5)
                .setColor(1,1,1)
                .setText(txt);
};

var variable = func(txt, posx, posy, desc) {
  cDefaultGroup.createChild("text", desc)
                .setTranslation(posx, posy)
                .setAlignment("right-top")
                .setFont("DSEG/DSEG7/Classic/DSEG7Classic-BoldItalic.ttf")
                .setFontSize(20, 1.2)
                .setColor(1,1,1)
                .setText(txt);
};

var needle = func(posx, posy) {
  cDefaultGroup.createChild("path")
               .setTranslation(posx, posy)
               .setColor(1,1,1);
};

# calculate
var DEG2RAD = 0.0174533;
var draw_vario = func(needle_t, radius, vario_norm) {

  var from_deg = -135*DEG2RAD;
  var to_deg = from_deg + 270*vario_norm*DEG2RAD;
  var (rx, ry) = (typeof(radius) == "vector") ? [radius[0], radius[1]] : [radius, radius];
  var (fs, fc) = [math.sin(from_deg), math.cos(from_deg)];
  var dx = (math.sin(to_deg) - fs) * rx;
  var dy = (math.cos(to_deg) - fc) * ry;

  needle_t.moveTo(rx*fs, -ry*fc);
  if(abs(to_deg - from_deg) > 180*DEG2RAD) {
    needle_t.arcLargeCW(rx, ry, 0, dx, -dy);
  } else {
    needle_t.arcSmallCW(rx, ry, 0, dx, -dy);
  }
  needle_t.close();
}

var cDisplay = canvas.new({
  "name": "systems",
  "size": [1024, 1024],
  "view": [795, 1024],
  "mipmapping": 1
});
cDisplay.addPlacement({"node": "sysdisp"});
#cDisplay.set("background", canvas.style.getColor("bg_color"));
cDisplay.set("background", "#333333");

var cDefaultGroup = cDisplay.createGroup();

# Comment out to display a debugging dialog
#var window = canvas.Window.new([240,309],"dialog");
#window.setCanvas(cDisplay);

# engine torque
#label("TORQUE", 154, 198, "torque");
#label("PSIx10", 176, 288, "psix10");
var torque_t = variable( "0.0", 232, 236, "tq");
var torque_nt = needle(209, 247);

# turbine temperature
#label("ITT", 189, 518, "itt");
#label("x100⁰C", 181, 606, "x100degc");
var itt_t = variable( "0.0", 232, 553, "itt");
var itt_nt = needle(209, 565);

# gass generator speed
#label("NG", 190, 822, "ng");
#label("%RPMx10", 166, 906, "pctrpmx10");
var ng_t = variable( "0.0", 232, 858, "ng");
var ng_nt = needle(209, 869);

# fuel, fuel remaining and fuel flow
#label("FUEL", 375, 331, "fuel");
#label("(LBS)", 432, 331, "(lbs)");
#label("QTY", 337, 369, "qty");
var qty_t = variable( "0.0", 468, 355, "qty");
#label("FL/H", 329, 413, "fl/h");
var flh_t = variable( "0.0", 468, 398, "fl_h");
#label("USED", 327, 460, "used");
var used_t = variable( "0.0", 468, 447, "used");

# hydraulic pressure
label("N2", 636, 426, "n2");
label("HYD", 629, 448, "hyd");
label("PSIx1000", 609, 466, "psix1000");

# propeller speed
label("NP  RPM", 389, 565, "np rpm");
var np_t = variable( "0.0", 464, 585, "np");

# outside air temperature
label("OAT ⁰C", 575, 559, "oatdegc");
var oat_t = variable( "0.0", 631, 579, "np");

# DC bysbar voltage and current
label("DC VOLTS", 384, 623, "dcvolts");
var dcv_t = variable( "0.0", 454, 639, "dcv");

label("DC AMPS", 561, 618, "dcamps");
var dca_t = variable( "0.0", 634, 639, "dca");

var torque_o = 0;
var itt_o = 0;
var ng_o = 0;
var qty_o = 0;
var qty_i = 0;
var flh_o = 0;
var used_o = 0;
var np_o = 0;
var oat_o = 0;
var dcv_o = 0;
var dca_o = 0;

var rtimer = maketimer(0.333333333, func {

    torque = getprop("engines/engine/thruster/torque") or 0;
    if (torque_o != torque) {
       torque_o = torque;

       # The PT6A-6 uses a conversion factor of 30.87 X torque in PSI
       var psi = math.abs(torque)/30.87;

       torque_t.setText(sprintf("%3.1f", psi));
#      draw_vario(torque_nt, [210,230], psi/10 - 4);
    }

    itt = getprop("engines/engine/itt_degf") or 0;
    if (itt_o != itt) {
       itt_o = itt;
       itt = (itt - 32.0)*0.5555555555;

       itt_t.setText(sprintf("%4i", itt));
#      draw_vario(itt_nt, [210,230], itt/100 - 8);
    }

    ng = getprop("engines/engine/n1") or 0;
    if (ng_o != ng) {
       ng_o = ng;
       ng_t.setText(sprintf("%4.1f", ng));
#      draw_vario(ng_nt, [210,230], ng/10 - 7.5);
    }

    qty = getprop("consumables/fuel/tank/level-lbs") or 0;
    if (qty_o != qty) {
       if (qty_i <= 0) qty_i = qty;
       qty_o = qty;
       qty_t.setText(sprintf("%4i", qty));
       used_t.setText(sprintf("%4i", qty_i - qty));
    }

    flh = getprop("engines/engine/fuel-flow_pph") or 0;
    if (flh_o != flh) {
       flh_o = flh;
       flh_t.setText(sprintf("%3i", flh*0.568));
    }

    np = getprop("engines/engine/thruster/rpm") or 0;
    if (np_o != np) {
        np_o = np;
        np_t.setText(sprintf("%5i", np));
    }

    oat = getprop("environment/temperature-degc") or 0;
    if (oat_o != oat) {
        oat_o = oat;
        oat_t.setText(sprintf("%3i", oat));
    }
});
rtimer.start();

