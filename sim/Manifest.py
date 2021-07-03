action = "simulation"
sim_tool = "ghdl"
top_module = "shiftleft2_tb"
sim_post_cmd = (
    "ghdl -r " + top_module # + " --wave=wave.ghw\n\t\t"
    # "gtkwave wave.vcd config.gtkw"
)

modules = {
    "local" : [ "../testbenches"],
}
