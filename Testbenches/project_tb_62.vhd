-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 1005;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (209,0,49,0,42,0,0,0,145,0,124,0,192,0,79,0,48,0,0,0,0,0,152,0,126,0,238,0,0,0,60,0,175,0,0,0,0,0,46,0,175,0,195,0,105,0,223,0,112,0,161,0,29,0,0,0,141,0,0,0,198,0,227,0,199,0,202,0,88,0,215,0,85,0,95,0,199,0,237,0,200,0,248,0,44,0,77,0,232,0,52,0,0,0,142,0,210,0,0,0,200,0,0,0,26,0,116,0,93,0,232,0,38,0,247,0,0,0,68,0,0,0,252,0,0,0,0,0,227,0,44,0,174,0,227,0,199,0,233,0,56,0,67,0,254,0,116,0,61,0,188,0,54,0,51,0,164,0,102,0,119,0,28,0,2,0,59,0,229,0,163,0,92,0,74,0,21,0,72,0,26,0,0,0,162,0,0,0,73,0,202,0,0,0,0,0,158,0,164,0,142,0,251,0,181,0,0,0,179,0,139,0,74,0,173,0,0,0,0,0,5,0,206,0,203,0,128,0,0,0,225,0,118,0,117,0,0,0,0,0,37,0,8,0,140,0,4,0,0,0,219,0,67,0,0,0,121,0,244,0,76,0,146,0,0,0,92,0,151,0,186,0,0,0,75,0,221,0,118,0,175,0,159,0,207,0,153,0,233,0,138,0,99,0,131,0,0,0,0,0,0,0,117,0,18,0,191,0,72,0,169,0,162,0,187,0,0,0,0,0,49,0,0,0,84,0,159,0,36,0,225,0,152,0,186,0,154,0,19,0,110,0,247,0,225,0,90,0,0,0,157,0,130,0,118,0,0,0,0,0,0,0,175,0,30,0,151,0,205,0,205,0,206,0,74,0,0,0,47,0,139,0,148,0,0,0,36,0,212,0,150,0,170,0,0,0,0,0,200,0,115,0,192,0,0,0,0,0,0,0,235,0,116,0,108,0,213,0,0,0,0,0,178,0,62,0,39,0,198,0,136,0,95,0,42,0,149,0,101,0,0,0,0,0,56,0,105,0,59,0,180,0,47,0,8,0,0,0,217,0,72,0,0,0,43,0,0,0,32,0,29,0,173,0,198,0,210,0,14,0,36,0,73,0,104,0,0,0,19,0,78,0,0,0,85,0,0,0,156,0,0,0,147,0,233,0,0,0,193,0,76,0,150,0,162,0,0,0,0,0,44,0,233,0,75,0,163,0,0,0,0,0,227,0,43,0,0,0,68,0,46,0,0,0,170,0,5,0,19,0,0,0,75,0,42,0,229,0,12,0,10,0,160,0,0,0,64,0,160,0,168,0,225,0,244,0,165,0,37,0,144,0,223,0,149,0,0,0,199,0,0,0,212,0,201,0,0,0,192,0,42,0,220,0,0,0,196,0,144,0,95,0,0,0,152,0,170,0,245,0,0,0,222,0,59,0,0,0,204,0,154,0,172,0,179,0,43,0,30,0,5,0,213,0,36,0,137,0,0,0,211,0,45,0,87,0,226,0,158,0,178,0,12,0,211,0,28,0,186,0,0,0,0,0,97,0,0,0,95,0,0,0,131,0,5,0,249,0,250,0,134,0,64,0,79,0,0,0,138,0,157,0,252,0,110,0,0,0,12,0,13,0,103,0,0,0,192,0,76,0,0,0,81,0,119,0,128,0,47,0,180,0,220,0,0,0,0,0,0,0,61,0,202,0,0,0,116,0,15,0,164,0,0,0,61,0,46,0,0,0,13,0,27,0,236,0,150,0,174,0,0,0,0,0,142,0,194,0,0,0,8,0,72,0,118,0,128,0,240,0,58,0,144,0,156,0,0,0,26,0,168,0,70,0,47,0,226,0,138,0,129,0,0,0,0,0,37,0,2,0,53,0,124,0,32,0,34,0,0,0,150,0,117,0,238,0,0,0,97,0,121,0,249,0,167,0,82,0,194,0,5,0,0,0,168,0,159,0,93,0,0,0,193,0,41,0,0,0,42,0,0,0,189,0,33,0,56,0,0,0,167,0,134,0,166,0,165,0,132,0,52,0,34,0,193,0,42,0,120,0,253,0,0,0,66,0,83,0,149,0,92,0,132,0,86,0,0,0,200,0,212,0,86,0,184,0,0,0,221,0,185,0,41,0,204,0,60,0,10,0,59,0,226,0,28,0,231,0,202,0,98,0,0,0,20,0,160,0,23,0,160,0,56,0,121,0,60,0,174,0,3,0,77,0,233,0,134,0,211,0,252,0,121,0,150,0,246,0,188,0,0,0,10,0,0,0,161,0,0,0,221,0,147,0,169,0,224,0,72,0,55,0,101,0,32,0,175,0,185,0,164,0,138,0,123,0,176,0,4,0,108,0,172,0,64,0,228,0,152,0,208,0,89,0,153,0,0,0,94,0,209,0,223,0,131,0,207,0,83,0,37,0,0,0,10,0,36,0,44,0,113,0,56,0,208,0,102,0,155,0,229,0,41,0,13,0,114,0,188,0,23,0,255,0,238,0,110,0,224,0,70,0,0,0,106,0,84,0,34,0,19,0,200,0,199,0,35,0,232,0,143,0,0,0,220,0,3,0,0,0,195,0,0,0,119,0,220,0,219,0,0,0,59,0,132,0,0,0,16,0,0,0,0,0,72,0,84,0,39,0,92,0,187,0,71,0,28,0,73,0,227,0,0,0,119,0,178,0,6,0,0,0,120,0,3,0,17,0,0,0,136,0,130,0,215,0,148,0,97,0,196,0,32,0,232,0,18,0,0,0,0,0,15,0,30,0,223,0,0,0,6,0,107,0,178,0,0,0,0,0,179,0,252,0,8,0,177,0,14,0,50,0,0,0,214,0,176,0,132,0,0,0,216,0,74,0,6,0,104,0,179,0,12,0,27,0,246,0,236,0,185,0,11,0,160,0,40,0,13,0,0,0,248,0,241,0,140,0,0,0,246,0,94,0,97,0,126,0,128,0,238,0,201,0,7,0,216,0,137,0,235,0,54,0,197,0,245,0,96,0,248,0,52,0,205,0,215,0,0,0,132,0,0,0,0,0,45,0,0,0,218,0,162,0,57,0,0,0,163,0,190,0,161,0,240,0,0,0,197,0,184,0,162,0,150,0,125,0,0,0,199,0,199,0,249,0,221,0,58,0,111,0,8,0,13,0,146,0,36,0,120,0,27,0,0,0,0,0,20,0,223,0,0,0,66,0,0,0,0,0,102,0,182,0,108,0,183,0,200,0,172,0,255,0,50,0,126,0,196,0,78,0,0,0,176,0,143,0,89,0,0,0,161,0,0,0,0,0,28,0,222,0,72,0,0,0,84,0,23,0,130,0,242,0,128,0,0,0,213,0,14,0,222,0,0,0,62,0,132,0,120,0,95,0,66,0,119,0,46,0,114,0,231,0,245,0,234,0,21,0,105,0,0,0,104,0,224,0,247,0,156,0,175,0,124,0,85,0,202,0,124,0,101,0,191,0,231,0,19,0,0,0,33,0,159,0,0,0,60,0,0,0,0,0,31,0,32,0,0,0,0,0,0,0,15,0,126,0,107,0,32,0,87,0,195,0,0,0,74,0,224,0,2,0,65,0,66,0,161,0,150,0,0,0,0,0,22,0,94,0,53,0,64,0,0,0,0,0,213,0,218,0,144,0,123,0,214,0,201,0,141,0,187,0,221,0,0,0,37,0,0,0,62,0,107,0,0,0,237,0,200,0,166,0,140,0,116,0,44,0,0,0,6,0,0,0,0,0,105,0,19,0,175,0,81,0,0,0,116,0,116,0,44,0,45,0,0,0,255,0,0,0,192,0,160,0,0,0,194,0,0,0,103,0,8,0,16,0,40,0,198,0,215,0,98,0,110,0,0,0,86,0,0,0,80,0,121,0,0,0,62,0,0,0,63,0,218,0,105,0,185,0,4,0,0,0,189,0,132,0,206,0,8,0,116,0,166,0,92,0,5,0,202,0,30,0,4,0,97,0,121,0,183,0,27,0,244,0,0,0,171,0,110,0,114,0,236,0,215,0,180,0,179,0,112,0,229,0,92,0,148,0,7,0,27,0,54,0,143,0,244,0,145,0,19,0,182,0,0,0,0,0,158,0,0,0,56,0,0,0,0,0,180,0,17,0,77,0,0,0,0,0,159,0,69,0,188,0,144,0,96,0,119,0,17,0,103,0,191,0,185,0,69,0,138,0,0,0,214,0,0,0,96,0,148,0,79,0,87,0,0,0,49,0,98,0,201,0,159,0,227,0,0,0,112,0,203,0,0,0,11,0,254,0,7,0,153,0,0,0,0,0,8,0,136,0,111,0,0,0,83,0,54,0,74,0,213,0,151,0,131,0,255,0,0,0,152,0,97,0,0,0,0,0,37,0,11,0,175,0,213,0,53,0,123,0,80,0,0,0,255,0,168,0,184,0,133,0,15,0,99,0,101,0,87,0,5,0,253,0,0,0,0,0,0,0,210,0,0,0,101,0,157,0,171,0,146,0,103,0,200,0,132,0,0,0,63,0,120,0,57,0,39,0,146,0,133,0,28,0,138,0,1,0,45,0,0,0,130,0);
signal scenario_full  : scenario_type := (209,31,49,31,42,31,42,30,145,31,124,31,192,31,79,31,48,31,48,30,48,29,152,31,126,31,238,31,238,30,60,31,175,31,175,30,175,29,46,31,175,31,195,31,105,31,223,31,112,31,161,31,29,31,29,30,141,31,141,30,198,31,227,31,199,31,202,31,88,31,215,31,85,31,95,31,199,31,237,31,200,31,248,31,44,31,77,31,232,31,52,31,52,30,142,31,210,31,210,30,200,31,200,30,26,31,116,31,93,31,232,31,38,31,247,31,247,30,68,31,68,30,252,31,252,30,252,29,227,31,44,31,174,31,227,31,199,31,233,31,56,31,67,31,254,31,116,31,61,31,188,31,54,31,51,31,164,31,102,31,119,31,28,31,2,31,59,31,229,31,163,31,92,31,74,31,21,31,72,31,26,31,26,30,162,31,162,30,73,31,202,31,202,30,202,29,158,31,164,31,142,31,251,31,181,31,181,30,179,31,139,31,74,31,173,31,173,30,173,29,5,31,206,31,203,31,128,31,128,30,225,31,118,31,117,31,117,30,117,29,37,31,8,31,140,31,4,31,4,30,219,31,67,31,67,30,121,31,244,31,76,31,146,31,146,30,92,31,151,31,186,31,186,30,75,31,221,31,118,31,175,31,159,31,207,31,153,31,233,31,138,31,99,31,131,31,131,30,131,29,131,28,117,31,18,31,191,31,72,31,169,31,162,31,187,31,187,30,187,29,49,31,49,30,84,31,159,31,36,31,225,31,152,31,186,31,154,31,19,31,110,31,247,31,225,31,90,31,90,30,157,31,130,31,118,31,118,30,118,29,118,28,175,31,30,31,151,31,205,31,205,31,206,31,74,31,74,30,47,31,139,31,148,31,148,30,36,31,212,31,150,31,170,31,170,30,170,29,200,31,115,31,192,31,192,30,192,29,192,28,235,31,116,31,108,31,213,31,213,30,213,29,178,31,62,31,39,31,198,31,136,31,95,31,42,31,149,31,101,31,101,30,101,29,56,31,105,31,59,31,180,31,47,31,8,31,8,30,217,31,72,31,72,30,43,31,43,30,32,31,29,31,173,31,198,31,210,31,14,31,36,31,73,31,104,31,104,30,19,31,78,31,78,30,85,31,85,30,156,31,156,30,147,31,233,31,233,30,193,31,76,31,150,31,162,31,162,30,162,29,44,31,233,31,75,31,163,31,163,30,163,29,227,31,43,31,43,30,68,31,46,31,46,30,170,31,5,31,19,31,19,30,75,31,42,31,229,31,12,31,10,31,160,31,160,30,64,31,160,31,168,31,225,31,244,31,165,31,37,31,144,31,223,31,149,31,149,30,199,31,199,30,212,31,201,31,201,30,192,31,42,31,220,31,220,30,196,31,144,31,95,31,95,30,152,31,170,31,245,31,245,30,222,31,59,31,59,30,204,31,154,31,172,31,179,31,43,31,30,31,5,31,213,31,36,31,137,31,137,30,211,31,45,31,87,31,226,31,158,31,178,31,12,31,211,31,28,31,186,31,186,30,186,29,97,31,97,30,95,31,95,30,131,31,5,31,249,31,250,31,134,31,64,31,79,31,79,30,138,31,157,31,252,31,110,31,110,30,12,31,13,31,103,31,103,30,192,31,76,31,76,30,81,31,119,31,128,31,47,31,180,31,220,31,220,30,220,29,220,28,61,31,202,31,202,30,116,31,15,31,164,31,164,30,61,31,46,31,46,30,13,31,27,31,236,31,150,31,174,31,174,30,174,29,142,31,194,31,194,30,8,31,72,31,118,31,128,31,240,31,58,31,144,31,156,31,156,30,26,31,168,31,70,31,47,31,226,31,138,31,129,31,129,30,129,29,37,31,2,31,53,31,124,31,32,31,34,31,34,30,150,31,117,31,238,31,238,30,97,31,121,31,249,31,167,31,82,31,194,31,5,31,5,30,168,31,159,31,93,31,93,30,193,31,41,31,41,30,42,31,42,30,189,31,33,31,56,31,56,30,167,31,134,31,166,31,165,31,132,31,52,31,34,31,193,31,42,31,120,31,253,31,253,30,66,31,83,31,149,31,92,31,132,31,86,31,86,30,200,31,212,31,86,31,184,31,184,30,221,31,185,31,41,31,204,31,60,31,10,31,59,31,226,31,28,31,231,31,202,31,98,31,98,30,20,31,160,31,23,31,160,31,56,31,121,31,60,31,174,31,3,31,77,31,233,31,134,31,211,31,252,31,121,31,150,31,246,31,188,31,188,30,10,31,10,30,161,31,161,30,221,31,147,31,169,31,224,31,72,31,55,31,101,31,32,31,175,31,185,31,164,31,138,31,123,31,176,31,4,31,108,31,172,31,64,31,228,31,152,31,208,31,89,31,153,31,153,30,94,31,209,31,223,31,131,31,207,31,83,31,37,31,37,30,10,31,36,31,44,31,113,31,56,31,208,31,102,31,155,31,229,31,41,31,13,31,114,31,188,31,23,31,255,31,238,31,110,31,224,31,70,31,70,30,106,31,84,31,34,31,19,31,200,31,199,31,35,31,232,31,143,31,143,30,220,31,3,31,3,30,195,31,195,30,119,31,220,31,219,31,219,30,59,31,132,31,132,30,16,31,16,30,16,29,72,31,84,31,39,31,92,31,187,31,71,31,28,31,73,31,227,31,227,30,119,31,178,31,6,31,6,30,120,31,3,31,17,31,17,30,136,31,130,31,215,31,148,31,97,31,196,31,32,31,232,31,18,31,18,30,18,29,15,31,30,31,223,31,223,30,6,31,107,31,178,31,178,30,178,29,179,31,252,31,8,31,177,31,14,31,50,31,50,30,214,31,176,31,132,31,132,30,216,31,74,31,6,31,104,31,179,31,12,31,27,31,246,31,236,31,185,31,11,31,160,31,40,31,13,31,13,30,248,31,241,31,140,31,140,30,246,31,94,31,97,31,126,31,128,31,238,31,201,31,7,31,216,31,137,31,235,31,54,31,197,31,245,31,96,31,248,31,52,31,205,31,215,31,215,30,132,31,132,30,132,29,45,31,45,30,218,31,162,31,57,31,57,30,163,31,190,31,161,31,240,31,240,30,197,31,184,31,162,31,150,31,125,31,125,30,199,31,199,31,249,31,221,31,58,31,111,31,8,31,13,31,146,31,36,31,120,31,27,31,27,30,27,29,20,31,223,31,223,30,66,31,66,30,66,29,102,31,182,31,108,31,183,31,200,31,172,31,255,31,50,31,126,31,196,31,78,31,78,30,176,31,143,31,89,31,89,30,161,31,161,30,161,29,28,31,222,31,72,31,72,30,84,31,23,31,130,31,242,31,128,31,128,30,213,31,14,31,222,31,222,30,62,31,132,31,120,31,95,31,66,31,119,31,46,31,114,31,231,31,245,31,234,31,21,31,105,31,105,30,104,31,224,31,247,31,156,31,175,31,124,31,85,31,202,31,124,31,101,31,191,31,231,31,19,31,19,30,33,31,159,31,159,30,60,31,60,30,60,29,31,31,32,31,32,30,32,29,32,28,15,31,126,31,107,31,32,31,87,31,195,31,195,30,74,31,224,31,2,31,65,31,66,31,161,31,150,31,150,30,150,29,22,31,94,31,53,31,64,31,64,30,64,29,213,31,218,31,144,31,123,31,214,31,201,31,141,31,187,31,221,31,221,30,37,31,37,30,62,31,107,31,107,30,237,31,200,31,166,31,140,31,116,31,44,31,44,30,6,31,6,30,6,29,105,31,19,31,175,31,81,31,81,30,116,31,116,31,44,31,45,31,45,30,255,31,255,30,192,31,160,31,160,30,194,31,194,30,103,31,8,31,16,31,40,31,198,31,215,31,98,31,110,31,110,30,86,31,86,30,80,31,121,31,121,30,62,31,62,30,63,31,218,31,105,31,185,31,4,31,4,30,189,31,132,31,206,31,8,31,116,31,166,31,92,31,5,31,202,31,30,31,4,31,97,31,121,31,183,31,27,31,244,31,244,30,171,31,110,31,114,31,236,31,215,31,180,31,179,31,112,31,229,31,92,31,148,31,7,31,27,31,54,31,143,31,244,31,145,31,19,31,182,31,182,30,182,29,158,31,158,30,56,31,56,30,56,29,180,31,17,31,77,31,77,30,77,29,159,31,69,31,188,31,144,31,96,31,119,31,17,31,103,31,191,31,185,31,69,31,138,31,138,30,214,31,214,30,96,31,148,31,79,31,87,31,87,30,49,31,98,31,201,31,159,31,227,31,227,30,112,31,203,31,203,30,11,31,254,31,7,31,153,31,153,30,153,29,8,31,136,31,111,31,111,30,83,31,54,31,74,31,213,31,151,31,131,31,255,31,255,30,152,31,97,31,97,30,97,29,37,31,11,31,175,31,213,31,53,31,123,31,80,31,80,30,255,31,168,31,184,31,133,31,15,31,99,31,101,31,87,31,5,31,253,31,253,30,253,29,253,28,210,31,210,30,101,31,157,31,171,31,146,31,103,31,200,31,132,31,132,30,63,31,120,31,57,31,39,31,146,31,133,31,28,31,138,31,1,31,45,31,45,30,130,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
