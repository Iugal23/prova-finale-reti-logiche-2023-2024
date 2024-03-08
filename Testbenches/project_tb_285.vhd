-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_285 is
end project_tb_285;

architecture project_tb_arch_285 of project_tb_285 is
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

constant SCENARIO_LENGTH : integer := 982;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (208,0,113,0,80,0,219,0,0,0,0,0,157,0,206,0,2,0,0,0,0,0,0,0,36,0,0,0,4,0,128,0,0,0,33,0,86,0,220,0,0,0,71,0,105,0,0,0,138,0,93,0,102,0,0,0,212,0,88,0,43,0,150,0,0,0,85,0,82,0,38,0,175,0,181,0,0,0,4,0,161,0,243,0,63,0,0,0,186,0,127,0,37,0,86,0,222,0,44,0,0,0,109,0,0,0,2,0,126,0,187,0,33,0,82,0,0,0,15,0,226,0,238,0,146,0,131,0,7,0,143,0,153,0,183,0,162,0,214,0,170,0,152,0,82,0,167,0,77,0,59,0,137,0,0,0,0,0,62,0,0,0,12,0,140,0,130,0,132,0,0,0,230,0,79,0,112,0,6,0,58,0,0,0,27,0,68,0,47,0,225,0,224,0,255,0,206,0,156,0,0,0,43,0,0,0,169,0,41,0,0,0,135,0,43,0,34,0,0,0,0,0,0,0,142,0,0,0,48,0,112,0,124,0,105,0,22,0,208,0,0,0,37,0,149,0,71,0,73,0,31,0,247,0,158,0,0,0,80,0,0,0,162,0,42,0,224,0,235,0,0,0,39,0,195,0,11,0,182,0,110,0,127,0,77,0,0,0,88,0,99,0,0,0,95,0,230,0,245,0,126,0,224,0,0,0,119,0,248,0,0,0,46,0,18,0,60,0,67,0,8,0,0,0,102,0,0,0,12,0,122,0,0,0,176,0,215,0,4,0,0,0,238,0,15,0,229,0,0,0,194,0,81,0,0,0,30,0,253,0,0,0,85,0,226,0,22,0,73,0,203,0,50,0,94,0,34,0,177,0,197,0,96,0,0,0,9,0,0,0,0,0,0,0,0,0,0,0,208,0,174,0,0,0,0,0,43,0,182,0,97,0,0,0,116,0,225,0,67,0,0,0,177,0,110,0,0,0,142,0,41,0,0,0,42,0,157,0,238,0,97,0,158,0,158,0,137,0,206,0,0,0,37,0,190,0,94,0,123,0,53,0,148,0,115,0,156,0,216,0,65,0,60,0,0,0,16,0,132,0,86,0,0,0,165,0,147,0,207,0,0,0,0,0,161,0,145,0,106,0,0,0,200,0,12,0,249,0,40,0,0,0,199,0,131,0,43,0,84,0,235,0,91,0,0,0,128,0,96,0,148,0,0,0,0,0,181,0,50,0,0,0,94,0,22,0,122,0,244,0,102,0,28,0,184,0,0,0,6,0,114,0,146,0,222,0,233,0,0,0,23,0,0,0,103,0,0,0,36,0,14,0,0,0,118,0,241,0,74,0,204,0,14,0,217,0,89,0,195,0,228,0,28,0,155,0,0,0,84,0,233,0,151,0,141,0,63,0,161,0,0,0,241,0,133,0,202,0,0,0,0,0,0,0,18,0,117,0,148,0,197,0,238,0,0,0,246,0,170,0,0,0,137,0,41,0,241,0,0,0,239,0,163,0,69,0,66,0,182,0,203,0,140,0,0,0,235,0,242,0,179,0,254,0,115,0,83,0,0,0,220,0,77,0,200,0,0,0,53,0,124,0,0,0,0,0,209,0,0,0,0,0,0,0,0,0,153,0,0,0,124,0,196,0,56,0,253,0,0,0,108,0,146,0,109,0,50,0,51,0,34,0,6,0,168,0,0,0,230,0,0,0,39,0,0,0,0,0,218,0,0,0,140,0,160,0,134,0,185,0,0,0,0,0,178,0,25,0,248,0,0,0,78,0,0,0,0,0,0,0,33,0,136,0,0,0,92,0,160,0,208,0,252,0,0,0,211,0,0,0,0,0,150,0,36,0,0,0,143,0,42,0,70,0,32,0,104,0,192,0,137,0,0,0,117,0,233,0,66,0,0,0,53,0,200,0,117,0,0,0,0,0,0,0,193,0,45,0,231,0,0,0,82,0,0,0,148,0,67,0,188,0,117,0,30,0,76,0,162,0,34,0,96,0,114,0,12,0,122,0,86,0,0,0,216,0,0,0,128,0,228,0,0,0,102,0,164,0,179,0,0,0,248,0,232,0,221,0,0,0,212,0,78,0,86,0,201,0,146,0,94,0,217,0,96,0,223,0,147,0,170,0,144,0,203,0,0,0,0,0,73,0,151,0,151,0,149,0,0,0,192,0,11,0,255,0,252,0,164,0,25,0,78,0,0,0,102,0,170,0,46,0,169,0,111,0,34,0,0,0,178,0,42,0,76,0,52,0,61,0,0,0,0,0,209,0,0,0,0,0,0,0,228,0,246,0,92,0,219,0,169,0,10,0,0,0,0,0,30,0,117,0,204,0,169,0,53,0,223,0,158,0,0,0,180,0,194,0,3,0,11,0,0,0,166,0,111,0,151,0,154,0,10,0,0,0,22,0,84,0,180,0,75,0,89,0,243,0,2,0,0,0,0,0,0,0,218,0,103,0,31,0,205,0,111,0,169,0,226,0,113,0,0,0,87,0,34,0,78,0,0,0,0,0,84,0,0,0,155,0,0,0,164,0,63,0,74,0,0,0,37,0,247,0,31,0,232,0,222,0,176,0,195,0,120,0,82,0,46,0,142,0,127,0,153,0,0,0,149,0,161,0,0,0,21,0,58,0,129,0,148,0,209,0,108,0,15,0,128,0,0,0,99,0,0,0,149,0,7,0,147,0,221,0,0,0,49,0,187,0,130,0,4,0,0,0,16,0,0,0,0,0,0,0,124,0,1,0,0,0,207,0,0,0,153,0,147,0,37,0,0,0,0,0,178,0,0,0,154,0,42,0,15,0,111,0,0,0,0,0,244,0,0,0,240,0,0,0,187,0,18,0,4,0,215,0,0,0,101,0,96,0,249,0,71,0,0,0,0,0,250,0,202,0,171,0,0,0,0,0,198,0,0,0,130,0,255,0,58,0,122,0,14,0,162,0,0,0,24,0,188,0,64,0,54,0,2,0,237,0,114,0,44,0,3,0,35,0,14,0,161,0,255,0,0,0,0,0,0,0,89,0,45,0,224,0,0,0,46,0,77,0,216,0,11,0,225,0,56,0,16,0,0,0,29,0,0,0,10,0,106,0,251,0,184,0,107,0,0,0,89,0,130,0,211,0,198,0,40,0,0,0,238,0,156,0,121,0,126,0,82,0,49,0,0,0,0,0,122,0,116,0,177,0,0,0,162,0,0,0,227,0,0,0,126,0,71,0,239,0,206,0,169,0,0,0,0,0,109,0,73,0,105,0,84,0,0,0,0,0,92,0,156,0,0,0,91,0,235,0,51,0,0,0,0,0,177,0,231,0,155,0,117,0,193,0,222,0,0,0,231,0,228,0,189,0,27,0,84,0,21,0,105,0,185,0,93,0,196,0,0,0,130,0,238,0,146,0,178,0,0,0,53,0,75,0,81,0,179,0,187,0,222,0,196,0,20,0,238,0,211,0,24,0,213,0,130,0,0,0,89,0,40,0,0,0,239,0,38,0,0,0,0,0,0,0,225,0,198,0,198,0,213,0,145,0,199,0,26,0,0,0,9,0,0,0,63,0,198,0,82,0,83,0,62,0,128,0,76,0,0,0,184,0,244,0,0,0,193,0,152,0,88,0,0,0,158,0,137,0,248,0,222,0,206,0,0,0,7,0,214,0,80,0,200,0,0,0,252,0,0,0,148,0,0,0,128,0,79,0,55,0,0,0,0,0,180,0,142,0,0,0,71,0,55,0,116,0,14,0,126,0,207,0,0,0,121,0,0,0,150,0,88,0,138,0,103,0,60,0,90,0,0,0,153,0,82,0,16,0,37,0,127,0,170,0,209,0,175,0,193,0,0,0,42,0,0,0,52,0,61,0,46,0,0,0,160,0,109,0,62,0,0,0,0,0,195,0,0,0,242,0,129,0,157,0,21,0,0,0,172,0,203,0,129,0,250,0,246,0,7,0,24,0,83,0,50,0,104,0,0,0,154,0,100,0,239,0,0,0,0,0,160,0,177,0,181,0,150,0,8,0,203,0,0,0,0,0,0,0,159,0,199,0,65,0,10,0,45,0,32,0,121,0,0,0,101,0,0,0,230,0,95,0,169,0,32,0,250,0,119,0,0,0,76,0,0,0,84,0,83,0,0,0,237,0,198,0,7,0,0,0,181,0,0,0,13,0,252,0,158,0,198,0,241,0,69,0,38,0,0,0,209,0,145,0,174,0,0,0,0,0,0,0,72,0,113,0,137,0,111,0,14,0,0,0,0,0,254,0,0,0,0,0,97,0,0,0,157,0,76,0,71,0,240,0,153,0,178,0,244,0,241,0,174,0,78,0,101,0,68,0,53,0,0,0,252,0,67,0,142,0,138,0,235,0,135,0,230,0,0,0,6,0,113,0,54,0,0,0,123,0,0,0,43,0,226,0,59,0,0,0,175,0);
signal scenario_full  : scenario_type := (208,31,113,31,80,31,219,31,219,30,219,29,157,31,206,31,2,31,2,30,2,29,2,28,36,31,36,30,4,31,128,31,128,30,33,31,86,31,220,31,220,30,71,31,105,31,105,30,138,31,93,31,102,31,102,30,212,31,88,31,43,31,150,31,150,30,85,31,82,31,38,31,175,31,181,31,181,30,4,31,161,31,243,31,63,31,63,30,186,31,127,31,37,31,86,31,222,31,44,31,44,30,109,31,109,30,2,31,126,31,187,31,33,31,82,31,82,30,15,31,226,31,238,31,146,31,131,31,7,31,143,31,153,31,183,31,162,31,214,31,170,31,152,31,82,31,167,31,77,31,59,31,137,31,137,30,137,29,62,31,62,30,12,31,140,31,130,31,132,31,132,30,230,31,79,31,112,31,6,31,58,31,58,30,27,31,68,31,47,31,225,31,224,31,255,31,206,31,156,31,156,30,43,31,43,30,169,31,41,31,41,30,135,31,43,31,34,31,34,30,34,29,34,28,142,31,142,30,48,31,112,31,124,31,105,31,22,31,208,31,208,30,37,31,149,31,71,31,73,31,31,31,247,31,158,31,158,30,80,31,80,30,162,31,42,31,224,31,235,31,235,30,39,31,195,31,11,31,182,31,110,31,127,31,77,31,77,30,88,31,99,31,99,30,95,31,230,31,245,31,126,31,224,31,224,30,119,31,248,31,248,30,46,31,18,31,60,31,67,31,8,31,8,30,102,31,102,30,12,31,122,31,122,30,176,31,215,31,4,31,4,30,238,31,15,31,229,31,229,30,194,31,81,31,81,30,30,31,253,31,253,30,85,31,226,31,22,31,73,31,203,31,50,31,94,31,34,31,177,31,197,31,96,31,96,30,9,31,9,30,9,29,9,28,9,27,9,26,208,31,174,31,174,30,174,29,43,31,182,31,97,31,97,30,116,31,225,31,67,31,67,30,177,31,110,31,110,30,142,31,41,31,41,30,42,31,157,31,238,31,97,31,158,31,158,31,137,31,206,31,206,30,37,31,190,31,94,31,123,31,53,31,148,31,115,31,156,31,216,31,65,31,60,31,60,30,16,31,132,31,86,31,86,30,165,31,147,31,207,31,207,30,207,29,161,31,145,31,106,31,106,30,200,31,12,31,249,31,40,31,40,30,199,31,131,31,43,31,84,31,235,31,91,31,91,30,128,31,96,31,148,31,148,30,148,29,181,31,50,31,50,30,94,31,22,31,122,31,244,31,102,31,28,31,184,31,184,30,6,31,114,31,146,31,222,31,233,31,233,30,23,31,23,30,103,31,103,30,36,31,14,31,14,30,118,31,241,31,74,31,204,31,14,31,217,31,89,31,195,31,228,31,28,31,155,31,155,30,84,31,233,31,151,31,141,31,63,31,161,31,161,30,241,31,133,31,202,31,202,30,202,29,202,28,18,31,117,31,148,31,197,31,238,31,238,30,246,31,170,31,170,30,137,31,41,31,241,31,241,30,239,31,163,31,69,31,66,31,182,31,203,31,140,31,140,30,235,31,242,31,179,31,254,31,115,31,83,31,83,30,220,31,77,31,200,31,200,30,53,31,124,31,124,30,124,29,209,31,209,30,209,29,209,28,209,27,153,31,153,30,124,31,196,31,56,31,253,31,253,30,108,31,146,31,109,31,50,31,51,31,34,31,6,31,168,31,168,30,230,31,230,30,39,31,39,30,39,29,218,31,218,30,140,31,160,31,134,31,185,31,185,30,185,29,178,31,25,31,248,31,248,30,78,31,78,30,78,29,78,28,33,31,136,31,136,30,92,31,160,31,208,31,252,31,252,30,211,31,211,30,211,29,150,31,36,31,36,30,143,31,42,31,70,31,32,31,104,31,192,31,137,31,137,30,117,31,233,31,66,31,66,30,53,31,200,31,117,31,117,30,117,29,117,28,193,31,45,31,231,31,231,30,82,31,82,30,148,31,67,31,188,31,117,31,30,31,76,31,162,31,34,31,96,31,114,31,12,31,122,31,86,31,86,30,216,31,216,30,128,31,228,31,228,30,102,31,164,31,179,31,179,30,248,31,232,31,221,31,221,30,212,31,78,31,86,31,201,31,146,31,94,31,217,31,96,31,223,31,147,31,170,31,144,31,203,31,203,30,203,29,73,31,151,31,151,31,149,31,149,30,192,31,11,31,255,31,252,31,164,31,25,31,78,31,78,30,102,31,170,31,46,31,169,31,111,31,34,31,34,30,178,31,42,31,76,31,52,31,61,31,61,30,61,29,209,31,209,30,209,29,209,28,228,31,246,31,92,31,219,31,169,31,10,31,10,30,10,29,30,31,117,31,204,31,169,31,53,31,223,31,158,31,158,30,180,31,194,31,3,31,11,31,11,30,166,31,111,31,151,31,154,31,10,31,10,30,22,31,84,31,180,31,75,31,89,31,243,31,2,31,2,30,2,29,2,28,218,31,103,31,31,31,205,31,111,31,169,31,226,31,113,31,113,30,87,31,34,31,78,31,78,30,78,29,84,31,84,30,155,31,155,30,164,31,63,31,74,31,74,30,37,31,247,31,31,31,232,31,222,31,176,31,195,31,120,31,82,31,46,31,142,31,127,31,153,31,153,30,149,31,161,31,161,30,21,31,58,31,129,31,148,31,209,31,108,31,15,31,128,31,128,30,99,31,99,30,149,31,7,31,147,31,221,31,221,30,49,31,187,31,130,31,4,31,4,30,16,31,16,30,16,29,16,28,124,31,1,31,1,30,207,31,207,30,153,31,147,31,37,31,37,30,37,29,178,31,178,30,154,31,42,31,15,31,111,31,111,30,111,29,244,31,244,30,240,31,240,30,187,31,18,31,4,31,215,31,215,30,101,31,96,31,249,31,71,31,71,30,71,29,250,31,202,31,171,31,171,30,171,29,198,31,198,30,130,31,255,31,58,31,122,31,14,31,162,31,162,30,24,31,188,31,64,31,54,31,2,31,237,31,114,31,44,31,3,31,35,31,14,31,161,31,255,31,255,30,255,29,255,28,89,31,45,31,224,31,224,30,46,31,77,31,216,31,11,31,225,31,56,31,16,31,16,30,29,31,29,30,10,31,106,31,251,31,184,31,107,31,107,30,89,31,130,31,211,31,198,31,40,31,40,30,238,31,156,31,121,31,126,31,82,31,49,31,49,30,49,29,122,31,116,31,177,31,177,30,162,31,162,30,227,31,227,30,126,31,71,31,239,31,206,31,169,31,169,30,169,29,109,31,73,31,105,31,84,31,84,30,84,29,92,31,156,31,156,30,91,31,235,31,51,31,51,30,51,29,177,31,231,31,155,31,117,31,193,31,222,31,222,30,231,31,228,31,189,31,27,31,84,31,21,31,105,31,185,31,93,31,196,31,196,30,130,31,238,31,146,31,178,31,178,30,53,31,75,31,81,31,179,31,187,31,222,31,196,31,20,31,238,31,211,31,24,31,213,31,130,31,130,30,89,31,40,31,40,30,239,31,38,31,38,30,38,29,38,28,225,31,198,31,198,31,213,31,145,31,199,31,26,31,26,30,9,31,9,30,63,31,198,31,82,31,83,31,62,31,128,31,76,31,76,30,184,31,244,31,244,30,193,31,152,31,88,31,88,30,158,31,137,31,248,31,222,31,206,31,206,30,7,31,214,31,80,31,200,31,200,30,252,31,252,30,148,31,148,30,128,31,79,31,55,31,55,30,55,29,180,31,142,31,142,30,71,31,55,31,116,31,14,31,126,31,207,31,207,30,121,31,121,30,150,31,88,31,138,31,103,31,60,31,90,31,90,30,153,31,82,31,16,31,37,31,127,31,170,31,209,31,175,31,193,31,193,30,42,31,42,30,52,31,61,31,46,31,46,30,160,31,109,31,62,31,62,30,62,29,195,31,195,30,242,31,129,31,157,31,21,31,21,30,172,31,203,31,129,31,250,31,246,31,7,31,24,31,83,31,50,31,104,31,104,30,154,31,100,31,239,31,239,30,239,29,160,31,177,31,181,31,150,31,8,31,203,31,203,30,203,29,203,28,159,31,199,31,65,31,10,31,45,31,32,31,121,31,121,30,101,31,101,30,230,31,95,31,169,31,32,31,250,31,119,31,119,30,76,31,76,30,84,31,83,31,83,30,237,31,198,31,7,31,7,30,181,31,181,30,13,31,252,31,158,31,198,31,241,31,69,31,38,31,38,30,209,31,145,31,174,31,174,30,174,29,174,28,72,31,113,31,137,31,111,31,14,31,14,30,14,29,254,31,254,30,254,29,97,31,97,30,157,31,76,31,71,31,240,31,153,31,178,31,244,31,241,31,174,31,78,31,101,31,68,31,53,31,53,30,252,31,67,31,142,31,138,31,235,31,135,31,230,31,230,30,6,31,113,31,54,31,54,30,123,31,123,30,43,31,226,31,59,31,59,30,175,31);

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
