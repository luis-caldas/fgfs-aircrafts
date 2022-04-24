#This file is part of FlightGear.
#
#FlightGear is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 2 of the License, or
#(at your option) any later version.
#
#FlightGear is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with FlightGear.  If not, see <http://www.gnu.org/licenses/>.

# Remark: For views, axes are x:right, y:up, z:back

# Input from headtracker protocol
var headtracker_node = props.globals.getNode("sim/headtracker");

var Input = {
	new: func(prop) {
		return { parents: [Input], prop: prop, offset: 0, };
	},

	getValue: func {
		return me.prop.getValue() - me.offset;
	},

	center: func {
		me.offset = me.prop.getValue();
	},

	reset: func {
		me.offset = 0;
	},
};

var input = {
	x: Input.new(headtracker_node.getNode("x-m", 1)),
	y: Input.new(headtracker_node.getNode("y-m", 1)),
	z: Input.new(headtracker_node.getNode("z-m", 1)),
	h: Input.new(headtracker_node.getNode("heading-deg", 1)),
	p: Input.new(headtracker_node.getNode("pitch-deg", 1)),
	r: Input.new(headtracker_node.getNode("roll-deg", 1)),
};

var center_input = func {
	foreach(var axis; keys(input)) input[axis].center();
}

var reset_input = func {
	foreach(var axis; keys(input)) input[axis].reset();
}


var config_node = headtracker_node.getNode("config", 1);

var enabled = {
	global: config_node.getNode("enable", 1),
	translation: config_node.getNode("enable-translation", 1),
	roll: config_node.getNode("enable-roll", 1),
	external: config_node.getNode("enable-external", 1),
};


# Output (view offsets)
var current_view_node = props.globals.getNode("sim/current-view");

var output = {
	x: current_view_node.getNode("x-offset-m", 1),
	y: current_view_node.getNode("y-offset-m", 1),
	z: current_view_node.getNode("z-offset-m", 1),
	h: current_view_node.getNode("heading-offset-deg", 1),
	p: current_view_node.getNode("pitch-offset-deg", 1),
	r: current_view_node.getNode("roll-offset-deg", 1),
};


### View configuration (base offsets).
var view_config = {
	node: nil,
	x: 0,
	y: 0,
	z: 0,
	h: 0,
	p: 0,
	r: 0,
	internal: 0,
	index_listener: nil,
	config_listeners: [],

	# Rotation matrix from view-aligned coordinate space to model coordinate space
	rot_mat: [[1,0,0], [0,1,0], [0,0,1]],

	# Update configuration after view change.
	update: func {
		# Remove listeners from old view config node.
		foreach (var l; me.config_listeners) removelistener(l);
		me.config_listeners = [];

		# Get new view config node.
		me.node = view.current.getNode("config");
		me.internal = view.current.getNode("internal", 1).getBoolValue();

		# Set listeners on new view config node.
		append(me.config_listeners,
			setlistener(me.node.getNode("x-offset-m", 1), func { me.update_x(); }, 1, 0),
			setlistener(me.node.getNode("y-offset-m", 1), func { me.update_y(); }, 1, 0),
			setlistener(me.node.getNode("z-offset-m", 1), func { me.update_z(); }, 1, 0),
			setlistener(me.node.getNode("heading-offset-deg", 1), func { me.update_rot(); }, 1, 0),
			setlistener(me.node.getNode("pitch-offset-deg", 1), func { me.update_rot(); }, 1, 0),
			setlistener(me.node.getNode("roll-offset-deg", 1), func { me.update_rot(); }, 1, 0)
		);
	},

	# Update base offset values from current view configuration.
	update_rot: func {
		me.h = me.node.getValue("heading-offset-deg") or 0;
		me.p = me.node.getValue("pitch-offset-deg") or 0;
		me.r = me.node.getValue("roll-offset-deg") or 0;

		# Rotation matrix
		var ch = math.cos(me.h * D2R);
		var sh = math.sin(me.h * D2R);
		var cp = math.cos(me.p * D2R);
		var sp = math.sin(me.p * D2R);
		var cr = math.cos(me.r * D2R);
		var sr = math.sin(me.r * D2R);

		me.rot_mat[0][0] = -sh*sp*sr + ch*cr;
		me.rot_mat[0][1] = sh*sp*cr + ch*sr;
		me.rot_mat[0][2] = sh*cp;
		me.rot_mat[1][0] = -cp*sr;
		me.rot_mat[1][1] = cp*cr;
		me.rot_mat[1][2] = -sp;
		me.rot_mat[2][0] = -ch*sp*sr - sh*cr;
		me.rot_mat[2][1] = ch*sp*cr - sh*sr;
		me.rot_mat[2][2] = ch*cp;
	},

	update_x: func {
		me.x = me.node.getValue("x-offset-m") or 0;
	},

	update_y: func {
		me.y = me.node.getValue("y-offset-m") or 0;
	},

	update_z: func {
		me.z = me.node.getValue("z-offset-m") or 0;
	},

	# Rotate a vector 'vec' from view-aligned coordinate space to model coordinate space.
	apply_view_rot: func(vec) {
		return [vec[0]*me.rot_mat[0][0] + vec[1]*me.rot_mat[0][1] + vec[2]*me.rot_mat[0][2],
				vec[0]*me.rot_mat[1][0] + vec[1]*me.rot_mat[1][1] + vec[2]*me.rot_mat[1][2],
				vec[0]*me.rot_mat[2][0] + vec[1]*me.rot_mat[2][1] + vec[2]*me.rot_mat[2][2]];
	},

	# Start / stop automatic update of view base offsets.
	start: func {
		if (me.index_listener == nil) {
			me.index_listener = setlistener("/sim/current-view/view-number", func { me.update(); }, 1, 0);
		}
	},
	stop: func {
		if (me.index_listener != nil) {
			removelistener(me.index_listener);
			me.index_listener = nil;
			foreach (var l; me.config_listeners) removelistener(l);
			me.config_listeners = [];
		}
	},
};



var reset = func() {
	center_input();
	view.resetViewPos();
	view.resetViewDir();
};


var loop = func {
	if (!enabled.global.getBoolValue()
		or (!view_config.internal and !enabled.external.getBoolValue())) return;

	if (enabled.translation.getBoolValue()) {
		# Translation, with view base rotation applied.
		var trans = [input.x.getValue(), input.y.getValue(), input.z.getValue()];
		trans = view_config.apply_view_rot(trans);

		output.x.setValue(trans[0] + view_config.x);
		output.y.setValue(trans[1] + view_config.y);
		output.z.setValue(trans[2] + view_config.z);
	}

	# Compose two rotations, using Euler angles, ...
	# Apply both rotations to back and up vectors. The final angles can be obtained from the result.
	var h = input.h.getValue()*D2R;
	var p = input.p.getValue()*D2R;
	var r = enabled.roll.getBoolValue() ? input.r.getValue()*D2R : 0;
	var ch = math.cos(h);
	var sh = math.sin(h);
	var cp = math.cos(p);
	var sp = math.sin(p);
	var cr = math.cos(r);
	var sr = math.sin(r);
	var back = view_config.apply_view_rot([sh*cp, -sp, ch*cp]);
	var up = view_config.apply_view_rot([sh*sp*cr + ch*sr, cp*cr, ch*sp*cr - sh*sr]);

	# Total heading/pitch
	h = math.atan2(back[0], back[2]);
	p = -math.asin(back[1]);
	# remove computed final heading and pitch, to obtain roll.
	ch = math.cos(h);
	sh = math.sin(h);
	cp = math.cos(p);
	sp = math.sin(p);
	# up = [ch*up[0] - sh*up[2], up[1], ch*up[2] + sh*up[0]];
	# up = [up[0], cp*up[1] + sp*up[2], cp*up[2] - sp*up[1]];
	# r = math.atan2(up[0], up[1]);
	# Same, simplified:
	r = math.atan2(
			ch*up[0] - sh*up[2],
			cp*up[1] + sp*ch*up[2] + sp*sh*up[0]);

	output.h.setValue(h*R2D);
	output.p.setValue(p*R2D);
	output.r.setValue(r*R2D);
}

var loop_timer = maketimer(0, loop);



var running = 0;

var start = func {
	if (running) return;

	view_config.start();
	loop_timer.start();
	running = 1;
}

var stop = func {
	if (!running) return;

	view_config.stop();
	loop_timer.stop();
	running = 0;
}

# gui.popupTip("press '=' (equal sign) to reset head tracker", 20);
