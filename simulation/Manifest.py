action = "simulation"
sim_tool = "ghdl"
top_module = "toplevel" + "_tb"

sim_cmd = "ghdl -r " + top_module
use_large_simulation = True
open_gtkwave = True
use_gtkwave_config = False

if use_large_simulation:
    sim_cmd += " --max-stack-alloc=0"

if open_gtkwave:
    sim_cmd += " --wave=wave.ghw\n\t\tgtkwave wave.ghw"
    if use_gtkwave_config:
        sim_cmd += " config.gtkw"

sim_post_cmd = (
    sim_cmd
)

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
