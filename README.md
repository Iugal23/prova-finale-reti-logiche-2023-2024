# peponzo
vivado -mode tcl 
open_project project_reti_logiche.xpr

launch_simulation -mode post-synthesis -type functional

set_property top project_tb_109 [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
update_compile_order -fileset sim_1

check:
258
262
276



