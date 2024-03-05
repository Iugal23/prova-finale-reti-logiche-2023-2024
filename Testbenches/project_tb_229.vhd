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

constant SCENARIO_LENGTH : integer := 1007;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (138,0,216,0,0,0,0,0,232,0,172,0,139,0,43,0,43,0,124,0,88,0,18,0,10,0,61,0,88,0,44,0,144,0,0,0,147,0,75,0,89,0,249,0,7,0,96,0,222,0,0,0,68,0,136,0,14,0,38,0,224,0,222,0,19,0,166,0,0,0,10,0,20,0,0,0,175,0,103,0,33,0,245,0,96,0,66,0,150,0,57,0,94,0,120,0,232,0,13,0,111,0,131,0,192,0,153,0,237,0,46,0,42,0,181,0,140,0,85,0,117,0,141,0,0,0,0,0,56,0,227,0,149,0,53,0,122,0,187,0,49,0,185,0,131,0,203,0,0,0,56,0,0,0,68,0,0,0,248,0,187,0,31,0,55,0,175,0,0,0,52,0,114,0,58,0,0,0,149,0,161,0,119,0,169,0,5,0,89,0,141,0,0,0,63,0,122,0,34,0,72,0,184,0,210,0,34,0,239,0,72,0,0,0,193,0,0,0,0,0,205,0,208,0,176,0,202,0,228,0,137,0,12,0,57,0,5,0,61,0,229,0,194,0,180,0,0,0,18,0,60,0,87,0,80,0,1,0,141,0,228,0,172,0,74,0,0,0,0,0,180,0,158,0,220,0,13,0,191,0,61,0,97,0,201,0,0,0,204,0,0,0,0,0,177,0,152,0,40,0,196,0,249,0,0,0,138,0,182,0,196,0,0,0,41,0,184,0,0,0,104,0,47,0,120,0,231,0,219,0,77,0,0,0,98,0,22,0,5,0,54,0,73,0,76,0,203,0,162,0,0,0,54,0,168,0,122,0,71,0,197,0,0,0,125,0,176,0,113,0,111,0,105,0,167,0,231,0,138,0,99,0,0,0,72,0,160,0,67,0,191,0,9,0,33,0,73,0,162,0,133,0,165,0,245,0,179,0,0,0,151,0,71,0,0,0,24,0,232,0,143,0,192,0,229,0,100,0,0,0,222,0,254,0,0,0,145,0,0,0,0,0,0,0,65,0,0,0,184,0,123,0,125,0,148,0,38,0,172,0,66,0,0,0,89,0,44,0,101,0,70,0,0,0,3,0,0,0,94,0,7,0,76,0,122,0,0,0,183,0,0,0,120,0,0,0,0,0,229,0,203,0,238,0,111,0,131,0,166,0,25,0,142,0,173,0,0,0,199,0,196,0,114,0,75,0,95,0,165,0,72,0,0,0,0,0,64,0,0,0,59,0,184,0,3,0,3,0,0,0,92,0,207,0,0,0,144,0,44,0,0,0,0,0,61,0,173,0,143,0,237,0,0,0,0,0,226,0,176,0,253,0,132,0,14,0,0,0,40,0,163,0,133,0,231,0,78,0,23,0,9,0,189,0,0,0,174,0,9,0,74,0,99,0,0,0,34,0,162,0,237,0,0,0,221,0,24,0,87,0,190,0,203,0,133,0,0,0,146,0,239,0,0,0,0,0,221,0,114,0,0,0,238,0,204,0,130,0,8,0,242,0,44,0,0,0,132,0,0,0,43,0,0,0,164,0,8,0,86,0,119,0,160,0,17,0,113,0,245,0,48,0,93,0,148,0,224,0,140,0,202,0,0,0,0,0,190,0,228,0,40,0,103,0,107,0,0,0,231,0,0,0,88,0,3,0,207,0,154,0,249,0,5,0,0,0,173,0,26,0,19,0,194,0,64,0,0,0,189,0,135,0,0,0,87,0,67,0,79,0,0,0,247,0,229,0,131,0,216,0,0,0,179,0,165,0,173,0,46,0,0,0,56,0,100,0,153,0,0,0,138,0,204,0,0,0,85,0,23,0,151,0,98,0,52,0,0,0,71,0,112,0,165,0,0,0,255,0,152,0,220,0,224,0,50,0,221,0,0,0,189,0,74,0,115,0,0,0,0,0,184,0,0,0,222,0,0,0,0,0,234,0,70,0,139,0,203,0,186,0,135,0,12,0,0,0,78,0,109,0,53,0,164,0,0,0,0,0,129,0,0,0,216,0,250,0,12,0,63,0,235,0,122,0,209,0,201,0,72,0,0,0,0,0,34,0,0,0,123,0,1,0,0,0,0,0,105,0,179,0,5,0,64,0,0,0,157,0,227,0,153,0,0,0,95,0,150,0,18,0,54,0,191,0,137,0,0,0,137,0,227,0,231,0,0,0,158,0,216,0,0,0,5,0,0,0,231,0,2,0,0,0,0,0,139,0,0,0,130,0,255,0,0,0,191,0,0,0,222,0,0,0,0,0,93,0,130,0,3,0,0,0,235,0,33,0,25,0,165,0,79,0,64,0,180,0,108,0,72,0,0,0,132,0,230,0,23,0,181,0,0,0,0,0,12,0,7,0,131,0,0,0,0,0,145,0,87,0,0,0,201,0,0,0,115,0,224,0,0,0,83,0,199,0,0,0,224,0,76,0,0,0,175,0,224,0,83,0,178,0,0,0,20,0,183,0,35,0,0,0,236,0,130,0,136,0,146,0,0,0,158,0,22,0,50,0,150,0,249,0,226,0,79,0,227,0,0,0,63,0,55,0,251,0,221,0,188,0,215,0,28,0,187,0,84,0,10,0,175,0,78,0,66,0,178,0,46,0,245,0,203,0,0,0,179,0,37,0,20,0,129,0,47,0,232,0,109,0,227,0,148,0,135,0,173,0,161,0,195,0,107,0,18,0,141,0,75,0,83,0,57,0,0,0,213,0,130,0,116,0,187,0,226,0,0,0,215,0,225,0,0,0,241,0,195,0,0,0,0,0,141,0,243,0,220,0,41,0,12,0,120,0,0,0,1,0,0,0,59,0,246,0,148,0,186,0,176,0,55,0,171,0,225,0,148,0,76,0,156,0,148,0,139,0,132,0,26,0,198,0,153,0,0,0,68,0,153,0,0,0,191,0,133,0,208,0,0,0,209,0,228,0,254,0,229,0,175,0,0,0,0,0,0,0,0,0,4,0,243,0,170,0,167,0,211,0,214,0,0,0,241,0,6,0,54,0,92,0,118,0,0,0,208,0,177,0,246,0,242,0,8,0,194,0,248,0,0,0,1,0,122,0,134,0,254,0,179,0,110,0,163,0,234,0,20,0,217,0,167,0,229,0,48,0,43,0,110,0,0,0,31,0,212,0,158,0,55,0,50,0,39,0,30,0,78,0,57,0,13,0,0,0,25,0,0,0,0,0,100,0,0,0,14,0,40,0,121,0,118,0,183,0,11,0,54,0,64,0,146,0,0,0,187,0,151,0,34,0,0,0,103,0,115,0,25,0,205,0,19,0,246,0,211,0,0,0,128,0,14,0,95,0,155,0,38,0,103,0,0,0,0,0,194,0,187,0,0,0,41,0,0,0,47,0,2,0,0,0,0,0,30,0,182,0,45,0,115,0,0,0,80,0,118,0,128,0,0,0,146,0,184,0,119,0,145,0,26,0,116,0,93,0,0,0,231,0,223,0,0,0,193,0,0,0,112,0,0,0,196,0,157,0,151,0,103,0,101,0,65,0,137,0,0,0,35,0,8,0,54,0,34,0,120,0,117,0,22,0,83,0,14,0,46,0,88,0,246,0,113,0,232,0,153,0,44,0,95,0,214,0,239,0,0,0,87,0,0,0,239,0,214,0,2,0,26,0,0,0,36,0,0,0,91,0,170,0,21,0,228,0,179,0,1,0,89,0,126,0,218,0,182,0,91,0,0,0,42,0,136,0,121,0,67,0,148,0,249,0,204,0,36,0,239,0,42,0,81,0,251,0,219,0,94,0,0,0,248,0,37,0,175,0,9,0,227,0,205,0,0,0,86,0,86,0,39,0,205,0,22,0,0,0,204,0,255,0,195,0,36,0,231,0,90,0,107,0,163,0,149,0,69,0,241,0,217,0,23,0,199,0,68,0,253,0,0,0,197,0,0,0,240,0,202,0,163,0,101,0,7,0,32,0,226,0,155,0,25,0,35,0,85,0,0,0,158,0,239,0,74,0,0,0,0,0,9,0,148,0,221,0,64,0,240,0,183,0,0,0,28,0,179,0,26,0,173,0,172,0,111,0,122,0,0,0,0,0,128,0,100,0,60,0,0,0,9,0,30,0,97,0,0,0,147,0,72,0,26,0,30,0,87,0,147,0,0,0,250,0,234,0,47,0,204,0,0,0,183,0,0,0,145,0,183,0,63,0,18,0,18,0,34,0,25,0,0,0,185,0,194,0,220,0,117,0,76,0,35,0,44,0,59,0,24,0,95,0,224,0,0,0,0,0,233,0,103,0,153,0,8,0,135,0,93,0,99,0,181,0,0,0,0,0,39,0,106,0,104,0,215,0,27,0,241,0,199,0,160,0,202,0,141,0,168,0,47,0,201,0,86,0,35,0,211,0,0,0,144,0,173,0,187,0,82,0,136,0,91,0,187,0,0,0,142,0,232,0,205,0,62,0,233,0,88,0,0,0,169,0,161,0,0,0,0,0,207,0,143,0,79,0,47,0,63,0,116,0,0,0,251,0,32,0,29,0,75,0,234,0,89,0,58,0,187,0,0,0,237,0,190,0,214,0,246,0);
signal scenario_full  : scenario_type := (138,31,216,31,216,30,216,29,232,31,172,31,139,31,43,31,43,31,124,31,88,31,18,31,10,31,61,31,88,31,44,31,144,31,144,30,147,31,75,31,89,31,249,31,7,31,96,31,222,31,222,30,68,31,136,31,14,31,38,31,224,31,222,31,19,31,166,31,166,30,10,31,20,31,20,30,175,31,103,31,33,31,245,31,96,31,66,31,150,31,57,31,94,31,120,31,232,31,13,31,111,31,131,31,192,31,153,31,237,31,46,31,42,31,181,31,140,31,85,31,117,31,141,31,141,30,141,29,56,31,227,31,149,31,53,31,122,31,187,31,49,31,185,31,131,31,203,31,203,30,56,31,56,30,68,31,68,30,248,31,187,31,31,31,55,31,175,31,175,30,52,31,114,31,58,31,58,30,149,31,161,31,119,31,169,31,5,31,89,31,141,31,141,30,63,31,122,31,34,31,72,31,184,31,210,31,34,31,239,31,72,31,72,30,193,31,193,30,193,29,205,31,208,31,176,31,202,31,228,31,137,31,12,31,57,31,5,31,61,31,229,31,194,31,180,31,180,30,18,31,60,31,87,31,80,31,1,31,141,31,228,31,172,31,74,31,74,30,74,29,180,31,158,31,220,31,13,31,191,31,61,31,97,31,201,31,201,30,204,31,204,30,204,29,177,31,152,31,40,31,196,31,249,31,249,30,138,31,182,31,196,31,196,30,41,31,184,31,184,30,104,31,47,31,120,31,231,31,219,31,77,31,77,30,98,31,22,31,5,31,54,31,73,31,76,31,203,31,162,31,162,30,54,31,168,31,122,31,71,31,197,31,197,30,125,31,176,31,113,31,111,31,105,31,167,31,231,31,138,31,99,31,99,30,72,31,160,31,67,31,191,31,9,31,33,31,73,31,162,31,133,31,165,31,245,31,179,31,179,30,151,31,71,31,71,30,24,31,232,31,143,31,192,31,229,31,100,31,100,30,222,31,254,31,254,30,145,31,145,30,145,29,145,28,65,31,65,30,184,31,123,31,125,31,148,31,38,31,172,31,66,31,66,30,89,31,44,31,101,31,70,31,70,30,3,31,3,30,94,31,7,31,76,31,122,31,122,30,183,31,183,30,120,31,120,30,120,29,229,31,203,31,238,31,111,31,131,31,166,31,25,31,142,31,173,31,173,30,199,31,196,31,114,31,75,31,95,31,165,31,72,31,72,30,72,29,64,31,64,30,59,31,184,31,3,31,3,31,3,30,92,31,207,31,207,30,144,31,44,31,44,30,44,29,61,31,173,31,143,31,237,31,237,30,237,29,226,31,176,31,253,31,132,31,14,31,14,30,40,31,163,31,133,31,231,31,78,31,23,31,9,31,189,31,189,30,174,31,9,31,74,31,99,31,99,30,34,31,162,31,237,31,237,30,221,31,24,31,87,31,190,31,203,31,133,31,133,30,146,31,239,31,239,30,239,29,221,31,114,31,114,30,238,31,204,31,130,31,8,31,242,31,44,31,44,30,132,31,132,30,43,31,43,30,164,31,8,31,86,31,119,31,160,31,17,31,113,31,245,31,48,31,93,31,148,31,224,31,140,31,202,31,202,30,202,29,190,31,228,31,40,31,103,31,107,31,107,30,231,31,231,30,88,31,3,31,207,31,154,31,249,31,5,31,5,30,173,31,26,31,19,31,194,31,64,31,64,30,189,31,135,31,135,30,87,31,67,31,79,31,79,30,247,31,229,31,131,31,216,31,216,30,179,31,165,31,173,31,46,31,46,30,56,31,100,31,153,31,153,30,138,31,204,31,204,30,85,31,23,31,151,31,98,31,52,31,52,30,71,31,112,31,165,31,165,30,255,31,152,31,220,31,224,31,50,31,221,31,221,30,189,31,74,31,115,31,115,30,115,29,184,31,184,30,222,31,222,30,222,29,234,31,70,31,139,31,203,31,186,31,135,31,12,31,12,30,78,31,109,31,53,31,164,31,164,30,164,29,129,31,129,30,216,31,250,31,12,31,63,31,235,31,122,31,209,31,201,31,72,31,72,30,72,29,34,31,34,30,123,31,1,31,1,30,1,29,105,31,179,31,5,31,64,31,64,30,157,31,227,31,153,31,153,30,95,31,150,31,18,31,54,31,191,31,137,31,137,30,137,31,227,31,231,31,231,30,158,31,216,31,216,30,5,31,5,30,231,31,2,31,2,30,2,29,139,31,139,30,130,31,255,31,255,30,191,31,191,30,222,31,222,30,222,29,93,31,130,31,3,31,3,30,235,31,33,31,25,31,165,31,79,31,64,31,180,31,108,31,72,31,72,30,132,31,230,31,23,31,181,31,181,30,181,29,12,31,7,31,131,31,131,30,131,29,145,31,87,31,87,30,201,31,201,30,115,31,224,31,224,30,83,31,199,31,199,30,224,31,76,31,76,30,175,31,224,31,83,31,178,31,178,30,20,31,183,31,35,31,35,30,236,31,130,31,136,31,146,31,146,30,158,31,22,31,50,31,150,31,249,31,226,31,79,31,227,31,227,30,63,31,55,31,251,31,221,31,188,31,215,31,28,31,187,31,84,31,10,31,175,31,78,31,66,31,178,31,46,31,245,31,203,31,203,30,179,31,37,31,20,31,129,31,47,31,232,31,109,31,227,31,148,31,135,31,173,31,161,31,195,31,107,31,18,31,141,31,75,31,83,31,57,31,57,30,213,31,130,31,116,31,187,31,226,31,226,30,215,31,225,31,225,30,241,31,195,31,195,30,195,29,141,31,243,31,220,31,41,31,12,31,120,31,120,30,1,31,1,30,59,31,246,31,148,31,186,31,176,31,55,31,171,31,225,31,148,31,76,31,156,31,148,31,139,31,132,31,26,31,198,31,153,31,153,30,68,31,153,31,153,30,191,31,133,31,208,31,208,30,209,31,228,31,254,31,229,31,175,31,175,30,175,29,175,28,175,27,4,31,243,31,170,31,167,31,211,31,214,31,214,30,241,31,6,31,54,31,92,31,118,31,118,30,208,31,177,31,246,31,242,31,8,31,194,31,248,31,248,30,1,31,122,31,134,31,254,31,179,31,110,31,163,31,234,31,20,31,217,31,167,31,229,31,48,31,43,31,110,31,110,30,31,31,212,31,158,31,55,31,50,31,39,31,30,31,78,31,57,31,13,31,13,30,25,31,25,30,25,29,100,31,100,30,14,31,40,31,121,31,118,31,183,31,11,31,54,31,64,31,146,31,146,30,187,31,151,31,34,31,34,30,103,31,115,31,25,31,205,31,19,31,246,31,211,31,211,30,128,31,14,31,95,31,155,31,38,31,103,31,103,30,103,29,194,31,187,31,187,30,41,31,41,30,47,31,2,31,2,30,2,29,30,31,182,31,45,31,115,31,115,30,80,31,118,31,128,31,128,30,146,31,184,31,119,31,145,31,26,31,116,31,93,31,93,30,231,31,223,31,223,30,193,31,193,30,112,31,112,30,196,31,157,31,151,31,103,31,101,31,65,31,137,31,137,30,35,31,8,31,54,31,34,31,120,31,117,31,22,31,83,31,14,31,46,31,88,31,246,31,113,31,232,31,153,31,44,31,95,31,214,31,239,31,239,30,87,31,87,30,239,31,214,31,2,31,26,31,26,30,36,31,36,30,91,31,170,31,21,31,228,31,179,31,1,31,89,31,126,31,218,31,182,31,91,31,91,30,42,31,136,31,121,31,67,31,148,31,249,31,204,31,36,31,239,31,42,31,81,31,251,31,219,31,94,31,94,30,248,31,37,31,175,31,9,31,227,31,205,31,205,30,86,31,86,31,39,31,205,31,22,31,22,30,204,31,255,31,195,31,36,31,231,31,90,31,107,31,163,31,149,31,69,31,241,31,217,31,23,31,199,31,68,31,253,31,253,30,197,31,197,30,240,31,202,31,163,31,101,31,7,31,32,31,226,31,155,31,25,31,35,31,85,31,85,30,158,31,239,31,74,31,74,30,74,29,9,31,148,31,221,31,64,31,240,31,183,31,183,30,28,31,179,31,26,31,173,31,172,31,111,31,122,31,122,30,122,29,128,31,100,31,60,31,60,30,9,31,30,31,97,31,97,30,147,31,72,31,26,31,30,31,87,31,147,31,147,30,250,31,234,31,47,31,204,31,204,30,183,31,183,30,145,31,183,31,63,31,18,31,18,31,34,31,25,31,25,30,185,31,194,31,220,31,117,31,76,31,35,31,44,31,59,31,24,31,95,31,224,31,224,30,224,29,233,31,103,31,153,31,8,31,135,31,93,31,99,31,181,31,181,30,181,29,39,31,106,31,104,31,215,31,27,31,241,31,199,31,160,31,202,31,141,31,168,31,47,31,201,31,86,31,35,31,211,31,211,30,144,31,173,31,187,31,82,31,136,31,91,31,187,31,187,30,142,31,232,31,205,31,62,31,233,31,88,31,88,30,169,31,161,31,161,30,161,29,207,31,143,31,79,31,47,31,63,31,116,31,116,30,251,31,32,31,29,31,75,31,234,31,89,31,58,31,187,31,187,30,237,31,190,31,214,31,246,31);

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
