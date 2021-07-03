action = "simulation"
sim_tool = "ghdl"
top_module = "rom_tb"

open_gtkwave = False
use_gtkwave_config = False

cmd = "ghdl -r " + top_module
if open_gtkwave:
    cmd += " --wave=wave.ghw\n\t\tgtkwave wave.ghw"
    if use_gtkwave_config:
        cmd += " config.gtkw"

sim_post_cmd = (
    cmd
)

modules = {
    "local" : [ "../testbenches"],
}
