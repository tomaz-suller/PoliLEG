action = "simulation"
sim_tool = "ghdl"
top_module = "toplevel" + "_tb"

sim_cmd = "ghdl -r " + top_module
use_large_simulation = True
open_gtkwave = True
use_gtkwave_config = True
config_file = "fibonacci.gtkw"

if use_large_simulation:
    sim_cmd += " --max-stack-alloc=0"

if open_gtkwave:
    sim_cmd += " --wave=wave.ghw; gtkwave wave.ghw"
    if use_gtkwave_config:
        if config_file is None:
            sim_cmd += " config.gtkw"
        else:
            sim_cmd += " "+config_file

sim_post_cmd = sim_cmd

modules = {
    "local" : [
        "../testbenches/",
        "../testbenches/alu",
        "../testbenches/control",
        "../testbenches/functional",
        "../testbenches/memory",
        "../testbenches/register_file",
    ],
}
