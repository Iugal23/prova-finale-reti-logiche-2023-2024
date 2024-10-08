-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_119 is
end project_tb_119;

architecture project_tb_arch_119 of project_tb_119 is
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

constant SCENARIO_LENGTH : integer := 1012;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (192,0,37,0,16,0,251,0,110,0,33,0,174,0,37,0,0,0,52,0,199,0,115,0,40,0,143,0,0,0,209,0,22,0,76,0,136,0,186,0,224,0,109,0,100,0,66,0,63,0,25,0,92,0,54,0,116,0,60,0,0,0,42,0,10,0,0,0,152,0,124,0,175,0,18,0,133,0,0,0,109,0,0,0,237,0,104,0,0,0,155,0,63,0,0,0,154,0,83,0,58,0,177,0,140,0,0,0,159,0,106,0,183,0,9,0,158,0,175,0,248,0,0,0,0,0,216,0,156,0,112,0,234,0,188,0,11,0,0,0,168,0,180,0,144,0,204,0,70,0,152,0,0,0,211,0,231,0,179,0,3,0,103,0,209,0,0,0,68,0,255,0,194,0,110,0,0,0,66,0,237,0,45,0,167,0,168,0,73,0,15,0,88,0,141,0,15,0,70,0,130,0,0,0,163,0,0,0,118,0,0,0,200,0,53,0,225,0,205,0,153,0,19,0,85,0,0,0,85,0,210,0,0,0,100,0,76,0,175,0,113,0,237,0,0,0,109,0,162,0,0,0,123,0,111,0,0,0,128,0,145,0,32,0,0,0,164,0,52,0,201,0,33,0,24,0,16,0,146,0,90,0,252,0,112,0,77,0,60,0,84,0,189,0,155,0,126,0,65,0,114,0,123,0,93,0,137,0,0,0,110,0,246,0,0,0,40,0,48,0,4,0,140,0,157,0,0,0,71,0,147,0,73,0,174,0,216,0,0,0,124,0,231,0,0,0,94,0,78,0,30,0,32,0,0,0,0,0,132,0,178,0,220,0,11,0,81,0,54,0,169,0,210,0,47,0,214,0,29,0,0,0,139,0,78,0,0,0,110,0,85,0,196,0,60,0,0,0,152,0,37,0,221,0,86,0,189,0,222,0,170,0,145,0,183,0,165,0,143,0,149,0,0,0,107,0,146,0,127,0,191,0,0,0,0,0,235,0,140,0,205,0,222,0,91,0,0,0,0,0,133,0,12,0,51,0,172,0,10,0,0,0,61,0,203,0,17,0,222,0,149,0,133,0,169,0,157,0,45,0,109,0,0,0,6,0,0,0,110,0,0,0,209,0,159,0,222,0,255,0,120,0,0,0,62,0,0,0,37,0,205,0,8,0,152,0,238,0,44,0,0,0,0,0,22,0,0,0,107,0,235,0,35,0,181,0,0,0,84,0,52,0,211,0,53,0,140,0,0,0,241,0,68,0,0,0,189,0,56,0,0,0,30,0,0,0,18,0,0,0,74,0,37,0,0,0,58,0,0,0,193,0,219,0,37,0,242,0,0,0,211,0,0,0,78,0,181,0,73,0,16,0,84,0,82,0,10,0,35,0,12,0,156,0,0,0,185,0,60,0,12,0,152,0,159,0,182,0,0,0,169,0,0,0,42,0,253,0,122,0,81,0,138,0,10,0,136,0,0,0,180,0,178,0,112,0,78,0,0,0,0,0,33,0,203,0,173,0,0,0,124,0,102,0,104,0,216,0,56,0,0,0,93,0,57,0,80,0,19,0,135,0,132,0,0,0,75,0,7,0,6,0,39,0,151,0,0,0,249,0,185,0,218,0,95,0,60,0,0,0,134,0,215,0,33,0,0,0,85,0,214,0,224,0,0,0,161,0,0,0,0,0,112,0,242,0,98,0,75,0,0,0,0,0,195,0,182,0,0,0,211,0,0,0,222,0,181,0,178,0,140,0,106,0,4,0,74,0,145,0,246,0,181,0,125,0,116,0,59,0,127,0,255,0,53,0,0,0,105,0,177,0,241,0,37,0,0,0,248,0,20,0,71,0,253,0,78,0,0,0,161,0,110,0,126,0,231,0,110,0,32,0,4,0,251,0,71,0,93,0,22,0,0,0,225,0,191,0,0,0,232,0,173,0,85,0,24,0,116,0,250,0,18,0,67,0,0,0,96,0,0,0,251,0,97,0,111,0,3,0,174,0,242,0,0,0,94,0,111,0,246,0,15,0,233,0,0,0,177,0,215,0,201,0,0,0,0,0,243,0,0,0,126,0,0,0,79,0,159,0,180,0,7,0,27,0,23,0,170,0,91,0,135,0,54,0,14,0,216,0,66,0,217,0,219,0,233,0,0,0,217,0,18,0,35,0,219,0,101,0,3,0,71,0,0,0,23,0,164,0,0,0,0,0,14,0,162,0,119,0,255,0,174,0,0,0,130,0,232,0,216,0,0,0,152,0,0,0,250,0,8,0,71,0,66,0,248,0,0,0,28,0,185,0,12,0,69,0,60,0,242,0,205,0,225,0,200,0,0,0,0,0,88,0,217,0,39,0,40,0,223,0,0,0,234,0,66,0,109,0,0,0,0,0,0,0,41,0,107,0,188,0,21,0,179,0,0,0,172,0,74,0,92,0,87,0,154,0,255,0,54,0,0,0,145,0,0,0,235,0,86,0,156,0,16,0,63,0,22,0,169,0,69,0,0,0,0,0,201,0,201,0,99,0,172,0,58,0,151,0,83,0,0,0,47,0,9,0,0,0,225,0,178,0,27,0,74,0,179,0,79,0,0,0,183,0,93,0,225,0,0,0,135,0,205,0,0,0,137,0,73,0,0,0,238,0,23,0,40,0,0,0,0,0,238,0,0,0,165,0,137,0,155,0,163,0,7,0,200,0,196,0,147,0,138,0,47,0,3,0,12,0,173,0,235,0,210,0,123,0,99,0,95,0,73,0,235,0,233,0,207,0,0,0,0,0,0,0,134,0,146,0,149,0,215,0,52,0,75,0,143,0,149,0,155,0,0,0,235,0,80,0,37,0,116,0,132,0,0,0,65,0,215,0,197,0,248,0,0,0,130,0,0,0,233,0,139,0,201,0,246,0,153,0,137,0,0,0,68,0,0,0,212,0,251,0,255,0,92,0,45,0,156,0,154,0,0,0,153,0,231,0,231,0,73,0,208,0,127,0,152,0,186,0,0,0,31,0,28,0,82,0,35,0,111,0,51,0,0,0,130,0,244,0,46,0,175,0,169,0,105,0,103,0,153,0,65,0,238,0,65,0,0,0,0,0,0,0,0,0,0,0,41,0,83,0,54,0,90,0,98,0,10,0,224,0,244,0,0,0,120,0,205,0,105,0,131,0,36,0,93,0,104,0,81,0,243,0,0,0,119,0,0,0,1,0,198,0,0,0,212,0,107,0,198,0,8,0,122,0,237,0,173,0,14,0,82,0,131,0,0,0,25,0,18,0,41,0,110,0,210,0,146,0,134,0,5,0,71,0,15,0,157,0,86,0,241,0,197,0,131,0,0,0,0,0,30,0,180,0,138,0,0,0,83,0,255,0,67,0,73,0,159,0,0,0,59,0,108,0,0,0,7,0,41,0,0,0,218,0,88,0,173,0,244,0,0,0,207,0,219,0,202,0,147,0,51,0,72,0,142,0,143,0,212,0,2,0,0,0,95,0,171,0,0,0,0,0,213,0,91,0,53,0,0,0,154,0,119,0,226,0,189,0,235,0,61,0,217,0,49,0,35,0,25,0,11,0,0,0,230,0,0,0,4,0,0,0,202,0,0,0,110,0,201,0,46,0,0,0,0,0,148,0,92,0,92,0,0,0,0,0,57,0,129,0,68,0,177,0,107,0,123,0,161,0,203,0,253,0,120,0,0,0,139,0,0,0,209,0,141,0,0,0,69,0,237,0,78,0,221,0,162,0,146,0,0,0,204,0,239,0,252,0,155,0,24,0,244,0,178,0,159,0,115,0,228,0,190,0,117,0,85,0,100,0,132,0,65,0,181,0,15,0,183,0,236,0,0,0,190,0,0,0,69,0,39,0,0,0,204,0,148,0,121,0,75,0,248,0,107,0,134,0,72,0,236,0,74,0,42,0,0,0,14,0,105,0,249,0,229,0,185,0,106,0,191,0,134,0,0,0,154,0,96,0,0,0,33,0,232,0,13,0,49,0,0,0,179,0,207,0,151,0,253,0,159,0,0,0,101,0,14,0,240,0,227,0,74,0,9,0,71,0,116,0,216,0,77,0,254,0,93,0,6,0,32,0,191,0,177,0,148,0,0,0,74,0,209,0,198,0,0,0,0,0,0,0,0,0,22,0,76,0,135,0,47,0,87,0,0,0,0,0,253,0,216,0,0,0,91,0,29,0,245,0,127,0,54,0,0,0,183,0,173,0,55,0,17,0,0,0,88,0,0,0,0,0,0,0,16,0,105,0,155,0,0,0,108,0,25,0,233,0,212,0,151,0,0,0,202,0,0,0,144,0,93,0,0,0,232,0,36,0,221,0,86,0,201,0,24,0,37,0,237,0,64,0,107,0,72,0,181,0,17,0,96,0,231,0,0,0,164,0,113,0,0,0,94,0,0,0,40,0,180,0,53,0,58,0,8,0,133,0,94,0,7,0,174,0,204,0,58,0,75,0,9,0,204,0,159,0,54,0,0,0,32,0,123,0,0,0,32,0,97,0,110,0,133,0,86,0,222,0,77,0,0,0,124,0,42,0,118,0,253,0,60,0,27,0,154,0,247,0);
signal scenario_full  : scenario_type := (192,31,37,31,16,31,251,31,110,31,33,31,174,31,37,31,37,30,52,31,199,31,115,31,40,31,143,31,143,30,209,31,22,31,76,31,136,31,186,31,224,31,109,31,100,31,66,31,63,31,25,31,92,31,54,31,116,31,60,31,60,30,42,31,10,31,10,30,152,31,124,31,175,31,18,31,133,31,133,30,109,31,109,30,237,31,104,31,104,30,155,31,63,31,63,30,154,31,83,31,58,31,177,31,140,31,140,30,159,31,106,31,183,31,9,31,158,31,175,31,248,31,248,30,248,29,216,31,156,31,112,31,234,31,188,31,11,31,11,30,168,31,180,31,144,31,204,31,70,31,152,31,152,30,211,31,231,31,179,31,3,31,103,31,209,31,209,30,68,31,255,31,194,31,110,31,110,30,66,31,237,31,45,31,167,31,168,31,73,31,15,31,88,31,141,31,15,31,70,31,130,31,130,30,163,31,163,30,118,31,118,30,200,31,53,31,225,31,205,31,153,31,19,31,85,31,85,30,85,31,210,31,210,30,100,31,76,31,175,31,113,31,237,31,237,30,109,31,162,31,162,30,123,31,111,31,111,30,128,31,145,31,32,31,32,30,164,31,52,31,201,31,33,31,24,31,16,31,146,31,90,31,252,31,112,31,77,31,60,31,84,31,189,31,155,31,126,31,65,31,114,31,123,31,93,31,137,31,137,30,110,31,246,31,246,30,40,31,48,31,4,31,140,31,157,31,157,30,71,31,147,31,73,31,174,31,216,31,216,30,124,31,231,31,231,30,94,31,78,31,30,31,32,31,32,30,32,29,132,31,178,31,220,31,11,31,81,31,54,31,169,31,210,31,47,31,214,31,29,31,29,30,139,31,78,31,78,30,110,31,85,31,196,31,60,31,60,30,152,31,37,31,221,31,86,31,189,31,222,31,170,31,145,31,183,31,165,31,143,31,149,31,149,30,107,31,146,31,127,31,191,31,191,30,191,29,235,31,140,31,205,31,222,31,91,31,91,30,91,29,133,31,12,31,51,31,172,31,10,31,10,30,61,31,203,31,17,31,222,31,149,31,133,31,169,31,157,31,45,31,109,31,109,30,6,31,6,30,110,31,110,30,209,31,159,31,222,31,255,31,120,31,120,30,62,31,62,30,37,31,205,31,8,31,152,31,238,31,44,31,44,30,44,29,22,31,22,30,107,31,235,31,35,31,181,31,181,30,84,31,52,31,211,31,53,31,140,31,140,30,241,31,68,31,68,30,189,31,56,31,56,30,30,31,30,30,18,31,18,30,74,31,37,31,37,30,58,31,58,30,193,31,219,31,37,31,242,31,242,30,211,31,211,30,78,31,181,31,73,31,16,31,84,31,82,31,10,31,35,31,12,31,156,31,156,30,185,31,60,31,12,31,152,31,159,31,182,31,182,30,169,31,169,30,42,31,253,31,122,31,81,31,138,31,10,31,136,31,136,30,180,31,178,31,112,31,78,31,78,30,78,29,33,31,203,31,173,31,173,30,124,31,102,31,104,31,216,31,56,31,56,30,93,31,57,31,80,31,19,31,135,31,132,31,132,30,75,31,7,31,6,31,39,31,151,31,151,30,249,31,185,31,218,31,95,31,60,31,60,30,134,31,215,31,33,31,33,30,85,31,214,31,224,31,224,30,161,31,161,30,161,29,112,31,242,31,98,31,75,31,75,30,75,29,195,31,182,31,182,30,211,31,211,30,222,31,181,31,178,31,140,31,106,31,4,31,74,31,145,31,246,31,181,31,125,31,116,31,59,31,127,31,255,31,53,31,53,30,105,31,177,31,241,31,37,31,37,30,248,31,20,31,71,31,253,31,78,31,78,30,161,31,110,31,126,31,231,31,110,31,32,31,4,31,251,31,71,31,93,31,22,31,22,30,225,31,191,31,191,30,232,31,173,31,85,31,24,31,116,31,250,31,18,31,67,31,67,30,96,31,96,30,251,31,97,31,111,31,3,31,174,31,242,31,242,30,94,31,111,31,246,31,15,31,233,31,233,30,177,31,215,31,201,31,201,30,201,29,243,31,243,30,126,31,126,30,79,31,159,31,180,31,7,31,27,31,23,31,170,31,91,31,135,31,54,31,14,31,216,31,66,31,217,31,219,31,233,31,233,30,217,31,18,31,35,31,219,31,101,31,3,31,71,31,71,30,23,31,164,31,164,30,164,29,14,31,162,31,119,31,255,31,174,31,174,30,130,31,232,31,216,31,216,30,152,31,152,30,250,31,8,31,71,31,66,31,248,31,248,30,28,31,185,31,12,31,69,31,60,31,242,31,205,31,225,31,200,31,200,30,200,29,88,31,217,31,39,31,40,31,223,31,223,30,234,31,66,31,109,31,109,30,109,29,109,28,41,31,107,31,188,31,21,31,179,31,179,30,172,31,74,31,92,31,87,31,154,31,255,31,54,31,54,30,145,31,145,30,235,31,86,31,156,31,16,31,63,31,22,31,169,31,69,31,69,30,69,29,201,31,201,31,99,31,172,31,58,31,151,31,83,31,83,30,47,31,9,31,9,30,225,31,178,31,27,31,74,31,179,31,79,31,79,30,183,31,93,31,225,31,225,30,135,31,205,31,205,30,137,31,73,31,73,30,238,31,23,31,40,31,40,30,40,29,238,31,238,30,165,31,137,31,155,31,163,31,7,31,200,31,196,31,147,31,138,31,47,31,3,31,12,31,173,31,235,31,210,31,123,31,99,31,95,31,73,31,235,31,233,31,207,31,207,30,207,29,207,28,134,31,146,31,149,31,215,31,52,31,75,31,143,31,149,31,155,31,155,30,235,31,80,31,37,31,116,31,132,31,132,30,65,31,215,31,197,31,248,31,248,30,130,31,130,30,233,31,139,31,201,31,246,31,153,31,137,31,137,30,68,31,68,30,212,31,251,31,255,31,92,31,45,31,156,31,154,31,154,30,153,31,231,31,231,31,73,31,208,31,127,31,152,31,186,31,186,30,31,31,28,31,82,31,35,31,111,31,51,31,51,30,130,31,244,31,46,31,175,31,169,31,105,31,103,31,153,31,65,31,238,31,65,31,65,30,65,29,65,28,65,27,65,26,41,31,83,31,54,31,90,31,98,31,10,31,224,31,244,31,244,30,120,31,205,31,105,31,131,31,36,31,93,31,104,31,81,31,243,31,243,30,119,31,119,30,1,31,198,31,198,30,212,31,107,31,198,31,8,31,122,31,237,31,173,31,14,31,82,31,131,31,131,30,25,31,18,31,41,31,110,31,210,31,146,31,134,31,5,31,71,31,15,31,157,31,86,31,241,31,197,31,131,31,131,30,131,29,30,31,180,31,138,31,138,30,83,31,255,31,67,31,73,31,159,31,159,30,59,31,108,31,108,30,7,31,41,31,41,30,218,31,88,31,173,31,244,31,244,30,207,31,219,31,202,31,147,31,51,31,72,31,142,31,143,31,212,31,2,31,2,30,95,31,171,31,171,30,171,29,213,31,91,31,53,31,53,30,154,31,119,31,226,31,189,31,235,31,61,31,217,31,49,31,35,31,25,31,11,31,11,30,230,31,230,30,4,31,4,30,202,31,202,30,110,31,201,31,46,31,46,30,46,29,148,31,92,31,92,31,92,30,92,29,57,31,129,31,68,31,177,31,107,31,123,31,161,31,203,31,253,31,120,31,120,30,139,31,139,30,209,31,141,31,141,30,69,31,237,31,78,31,221,31,162,31,146,31,146,30,204,31,239,31,252,31,155,31,24,31,244,31,178,31,159,31,115,31,228,31,190,31,117,31,85,31,100,31,132,31,65,31,181,31,15,31,183,31,236,31,236,30,190,31,190,30,69,31,39,31,39,30,204,31,148,31,121,31,75,31,248,31,107,31,134,31,72,31,236,31,74,31,42,31,42,30,14,31,105,31,249,31,229,31,185,31,106,31,191,31,134,31,134,30,154,31,96,31,96,30,33,31,232,31,13,31,49,31,49,30,179,31,207,31,151,31,253,31,159,31,159,30,101,31,14,31,240,31,227,31,74,31,9,31,71,31,116,31,216,31,77,31,254,31,93,31,6,31,32,31,191,31,177,31,148,31,148,30,74,31,209,31,198,31,198,30,198,29,198,28,198,27,22,31,76,31,135,31,47,31,87,31,87,30,87,29,253,31,216,31,216,30,91,31,29,31,245,31,127,31,54,31,54,30,183,31,173,31,55,31,17,31,17,30,88,31,88,30,88,29,88,28,16,31,105,31,155,31,155,30,108,31,25,31,233,31,212,31,151,31,151,30,202,31,202,30,144,31,93,31,93,30,232,31,36,31,221,31,86,31,201,31,24,31,37,31,237,31,64,31,107,31,72,31,181,31,17,31,96,31,231,31,231,30,164,31,113,31,113,30,94,31,94,30,40,31,180,31,53,31,58,31,8,31,133,31,94,31,7,31,174,31,204,31,58,31,75,31,9,31,204,31,159,31,54,31,54,30,32,31,123,31,123,30,32,31,97,31,110,31,133,31,86,31,222,31,77,31,77,30,124,31,42,31,118,31,253,31,60,31,27,31,154,31,247,31);

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
