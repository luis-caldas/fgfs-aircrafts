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

# Configuration file used to store properties.
var config_file = nil;
var config_node = props.globals.getNode("sim/headtracker/config");
var exit_listener = nil;

var read_config = func {
	io.read_properties(config_file, config_node);
}

var write_config = func {
	io.write_properties(config_file, config_node);
}


var main = func(addon) {
	config_file = addon.createStorageDir() ~ "/config.xml";
	read_config();

	io.load_nasal(addon.basePath ~ '/headtracker.nas', "headtracker");

	if (exit_listener != nil) removelistener(exit_listener);
	exit_listener = setlistener("/sim/signals/exit", write_config);

	headtracker.start();
	gui.menuEnable("headtracker", 1);
}

var unload = func {
	headtracker.stop();
	gui.menuEnable("headtracker", 0);

	if (exit_listener != nil) removelistener(exit_listener);
	exit_listener = nil;

	write_config();
}
