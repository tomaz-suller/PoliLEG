action = "simulation"
sim_tool = "ghdl"
top_module = "ram_tb"
sim_post_cmd = (
    "ghdl -r " + top_module + " --wave=wave.ghw\n\t\t"
    +"gtkwave wave.ghw" #+ "config.gtkw"
)

modules = {
    "local" : [ "../testbenches"],
}
