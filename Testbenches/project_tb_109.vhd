-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_109 is
end project_tb_109;

architecture project_tb_arch_109 of project_tb_109 is
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

constant SCENARIO_LENGTH : integer := 1010;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (108,0,139,0,0,0,56,0,249,0,0,0,6,0,191,0,0,0,176,0,198,0,185,0,29,0,143,0,0,0,130,0,0,0,79,0,185,0,0,0,233,0,90,0,0,0,56,0,0,0,224,0,47,0,180,0,230,0,133,0,87,0,0,0,63,0,54,0,233,0,0,0,59,0,99,0,232,0,117,0,51,0,158,0,115,0,71,0,54,0,148,0,221,0,194,0,60,0,0,0,36,0,139,0,63,0,13,0,133,0,88,0,0,0,82,0,31,0,67,0,30,0,26,0,175,0,0,0,117,0,180,0,156,0,67,0,60,0,75,0,110,0,104,0,104,0,193,0,0,0,12,0,194,0,235,0,18,0,37,0,90,0,80,0,21,0,245,0,0,0,15,0,0,0,48,0,86,0,39,0,239,0,119,0,250,0,195,0,182,0,71,0,161,0,61,0,50,0,0,0,0,0,74,0,226,0,236,0,30,0,28,0,0,0,83,0,217,0,65,0,200,0,37,0,133,0,0,0,0,0,191,0,100,0,45,0,82,0,238,0,0,0,179,0,45,0,152,0,44,0,142,0,16,0,189,0,172,0,133,0,127,0,190,0,92,0,70,0,0,0,89,0,181,0,92,0,47,0,18,0,53,0,133,0,219,0,134,0,207,0,251,0,34,0,185,0,160,0,6,0,174,0,0,0,7,0,170,0,0,0,86,0,236,0,1,0,139,0,0,0,0,0,59,0,206,0,0,0,110,0,189,0,168,0,0,0,12,0,83,0,247,0,0,0,0,0,0,0,16,0,122,0,51,0,60,0,62,0,68,0,173,0,219,0,241,0,157,0,0,0,68,0,125,0,120,0,167,0,247,0,23,0,8,0,46,0,151,0,59,0,0,0,96,0,136,0,253,0,0,0,0,0,127,0,178,0,106,0,0,0,0,0,44,0,198,0,248,0,0,0,28,0,21,0,61,0,88,0,9,0,0,0,121,0,140,0,254,0,36,0,210,0,111,0,253,0,0,0,0,0,45,0,68,0,70,0,183,0,99,0,163,0,216,0,13,0,0,0,209,0,200,0,0,0,40,0,136,0,29,0,212,0,95,0,149,0,244,0,240,0,181,0,24,0,225,0,112,0,18,0,237,0,0,0,0,0,49,0,105,0,148,0,185,0,61,0,0,0,152,0,89,0,0,0,97,0,10,0,108,0,203,0,187,0,0,0,230,0,138,0,217,0,136,0,25,0,113,0,146,0,230,0,171,0,182,0,189,0,253,0,177,0,54,0,36,0,93,0,24,0,254,0,159,0,135,0,98,0,72,0,0,0,75,0,15,0,209,0,4,0,65,0,246,0,14,0,113,0,196,0,55,0,8,0,194,0,149,0,91,0,0,0,51,0,0,0,0,0,229,0,143,0,0,0,209,0,5,0,77,0,210,0,136,0,168,0,4,0,209,0,255,0,146,0,162,0,114,0,0,0,217,0,208,0,203,0,0,0,0,0,48,0,14,0,0,0,113,0,26,0,176,0,0,0,105,0,90,0,0,0,105,0,61,0,192,0,195,0,0,0,136,0,229,0,95,0,238,0,65,0,205,0,0,0,153,0,190,0,158,0,68,0,73,0,140,0,6,0,43,0,237,0,249,0,233,0,0,0,255,0,70,0,35,0,81,0,0,0,39,0,119,0,95,0,102,0,206,0,165,0,212,0,114,0,0,0,191,0,154,0,54,0,135,0,249,0,251,0,215,0,201,0,0,0,38,0,163,0,228,0,232,0,40,0,27,0,15,0,66,0,183,0,136,0,110,0,101,0,249,0,119,0,0,0,179,0,53,0,15,0,160,0,48,0,74,0,221,0,86,0,106,0,255,0,118,0,0,0,133,0,113,0,0,0,0,0,91,0,28,0,0,0,0,0,221,0,0,0,0,0,28,0,111,0,253,0,220,0,243,0,3,0,67,0,2,0,14,0,229,0,197,0,121,0,237,0,114,0,0,0,137,0,194,0,0,0,0,0,234,0,55,0,157,0,1,0,10,0,143,0,127,0,0,0,15,0,29,0,24,0,0,0,17,0,119,0,0,0,88,0,0,0,171,0,8,0,152,0,80,0,36,0,13,0,40,0,97,0,118,0,0,0,83,0,164,0,0,0,230,0,80,0,235,0,11,0,99,0,0,0,85,0,195,0,149,0,40,0,154,0,0,0,95,0,13,0,221,0,85,0,250,0,17,0,162,0,25,0,0,0,35,0,35,0,89,0,0,0,0,0,99,0,150,0,222,0,83,0,11,0,180,0,18,0,0,0,230,0,126,0,189,0,172,0,154,0,96,0,55,0,37,0,0,0,0,0,0,0,53,0,113,0,42,0,0,0,14,0,0,0,29,0,5,0,0,0,132,0,0,0,170,0,0,0,239,0,237,0,41,0,131,0,254,0,54,0,120,0,228,0,0,0,0,0,0,0,125,0,73,0,248,0,0,0,230,0,52,0,159,0,99,0,83,0,201,0,184,0,0,0,134,0,0,0,18,0,151,0,0,0,197,0,60,0,191,0,159,0,233,0,29,0,206,0,139,0,87,0,94,0,185,0,141,0,0,0,62,0,181,0,173,0,197,0,67,0,144,0,46,0,0,0,129,0,125,0,0,0,128,0,0,0,207,0,76,0,150,0,123,0,0,0,132,0,32,0,67,0,227,0,10,0,45,0,0,0,0,0,0,0,243,0,146,0,0,0,22,0,202,0,159,0,59,0,105,0,0,0,242,0,0,0,0,0,217,0,0,0,237,0,80,0,57,0,0,0,213,0,31,0,175,0,97,0,138,0,22,0,26,0,0,0,161,0,127,0,211,0,118,0,206,0,154,0,0,0,239,0,113,0,173,0,59,0,0,0,0,0,168,0,0,0,124,0,0,0,0,0,0,0,186,0,141,0,18,0,172,0,38,0,128,0,140,0,89,0,0,0,206,0,201,0,1,0,0,0,158,0,13,0,153,0,0,0,133,0,51,0,30,0,254,0,51,0,0,0,0,0,40,0,196,0,213,0,221,0,183,0,0,0,235,0,50,0,2,0,234,0,0,0,18,0,140,0,10,0,214,0,91,0,0,0,234,0,64,0,102,0,76,0,164,0,252,0,148,0,6,0,219,0,254,0,0,0,196,0,176,0,63,0,9,0,0,0,0,0,51,0,236,0,196,0,126,0,169,0,0,0,124,0,253,0,99,0,17,0,88,0,180,0,0,0,0,0,22,0,148,0,0,0,0,0,156,0,97,0,159,0,149,0,51,0,116,0,220,0,155,0,0,0,233,0,168,0,229,0,241,0,240,0,84,0,113,0,241,0,108,0,27,0,0,0,237,0,157,0,0,0,130,0,25,0,3,0,152,0,183,0,0,0,160,0,117,0,155,0,107,0,48,0,154,0,175,0,189,0,41,0,12,0,142,0,89,0,45,0,112,0,105,0,23,0,112,0,0,0,166,0,91,0,172,0,40,0,85,0,62,0,63,0,0,0,141,0,202,0,131,0,130,0,0,0,183,0,0,0,1,0,32,0,0,0,75,0,0,0,16,0,175,0,194,0,167,0,110,0,145,0,0,0,150,0,74,0,0,0,138,0,102,0,0,0,0,0,90,0,65,0,160,0,0,0,166,0,101,0,53,0,22,0,131,0,19,0,0,0,95,0,196,0,0,0,207,0,180,0,0,0,93,0,114,0,0,0,103,0,204,0,147,0,92,0,0,0,0,0,207,0,27,0,251,0,5,0,0,0,216,0,19,0,0,0,225,0,146,0,2,0,90,0,0,0,56,0,160,0,193,0,15,0,183,0,134,0,238,0,0,0,101,0,197,0,197,0,12,0,237,0,224,0,172,0,203,0,64,0,29,0,8,0,209,0,85,0,0,0,36,0,209,0,0,0,123,0,101,0,107,0,0,0,197,0,159,0,32,0,177,0,0,0,93,0,103,0,206,0,242,0,41,0,160,0,44,0,0,0,169,0,101,0,63,0,175,0,0,0,42,0,174,0,195,0,100,0,40,0,46,0,0,0,130,0,141,0,47,0,124,0,130,0,228,0,0,0,195,0,238,0,160,0,138,0,214,0,8,0,201,0,50,0,183,0,27,0,0,0,204,0,255,0,219,0,184,0,170,0,25,0,97,0,246,0,0,0,216,0,0,0,0,0,232,0,0,0,160,0,135,0,147,0,81,0,72,0,119,0,0,0,0,0,20,0,0,0,140,0,30,0,253,0,54,0,17,0,39,0,0,0,66,0,50,0,0,0,0,0,25,0,0,0,0,0,6,0,0,0,101,0,0,0,0,0,0,0,218,0,93,0,0,0,0,0,83,0,165,0,0,0,105,0,65,0,100,0,232,0,12,0,62,0,0,0,140,0,229,0,24,0,171,0,44,0,155,0,0,0,255,0,76,0,12,0,121,0,169,0,24,0,60,0,103,0,0,0,0,0,101,0,0,0,231,0,186,0,0,0,180,0,160,0,201,0,14,0,0,0,22,0,115,0,247,0,0,0,170,0,51,0,19,0,70,0,0,0,251,0,194,0,161,0);
signal scenario_full  : scenario_type := (108,31,139,31,139,30,56,31,249,31,249,30,6,31,191,31,191,30,176,31,198,31,185,31,29,31,143,31,143,30,130,31,130,30,79,31,185,31,185,30,233,31,90,31,90,30,56,31,56,30,224,31,47,31,180,31,230,31,133,31,87,31,87,30,63,31,54,31,233,31,233,30,59,31,99,31,232,31,117,31,51,31,158,31,115,31,71,31,54,31,148,31,221,31,194,31,60,31,60,30,36,31,139,31,63,31,13,31,133,31,88,31,88,30,82,31,31,31,67,31,30,31,26,31,175,31,175,30,117,31,180,31,156,31,67,31,60,31,75,31,110,31,104,31,104,31,193,31,193,30,12,31,194,31,235,31,18,31,37,31,90,31,80,31,21,31,245,31,245,30,15,31,15,30,48,31,86,31,39,31,239,31,119,31,250,31,195,31,182,31,71,31,161,31,61,31,50,31,50,30,50,29,74,31,226,31,236,31,30,31,28,31,28,30,83,31,217,31,65,31,200,31,37,31,133,31,133,30,133,29,191,31,100,31,45,31,82,31,238,31,238,30,179,31,45,31,152,31,44,31,142,31,16,31,189,31,172,31,133,31,127,31,190,31,92,31,70,31,70,30,89,31,181,31,92,31,47,31,18,31,53,31,133,31,219,31,134,31,207,31,251,31,34,31,185,31,160,31,6,31,174,31,174,30,7,31,170,31,170,30,86,31,236,31,1,31,139,31,139,30,139,29,59,31,206,31,206,30,110,31,189,31,168,31,168,30,12,31,83,31,247,31,247,30,247,29,247,28,16,31,122,31,51,31,60,31,62,31,68,31,173,31,219,31,241,31,157,31,157,30,68,31,125,31,120,31,167,31,247,31,23,31,8,31,46,31,151,31,59,31,59,30,96,31,136,31,253,31,253,30,253,29,127,31,178,31,106,31,106,30,106,29,44,31,198,31,248,31,248,30,28,31,21,31,61,31,88,31,9,31,9,30,121,31,140,31,254,31,36,31,210,31,111,31,253,31,253,30,253,29,45,31,68,31,70,31,183,31,99,31,163,31,216,31,13,31,13,30,209,31,200,31,200,30,40,31,136,31,29,31,212,31,95,31,149,31,244,31,240,31,181,31,24,31,225,31,112,31,18,31,237,31,237,30,237,29,49,31,105,31,148,31,185,31,61,31,61,30,152,31,89,31,89,30,97,31,10,31,108,31,203,31,187,31,187,30,230,31,138,31,217,31,136,31,25,31,113,31,146,31,230,31,171,31,182,31,189,31,253,31,177,31,54,31,36,31,93,31,24,31,254,31,159,31,135,31,98,31,72,31,72,30,75,31,15,31,209,31,4,31,65,31,246,31,14,31,113,31,196,31,55,31,8,31,194,31,149,31,91,31,91,30,51,31,51,30,51,29,229,31,143,31,143,30,209,31,5,31,77,31,210,31,136,31,168,31,4,31,209,31,255,31,146,31,162,31,114,31,114,30,217,31,208,31,203,31,203,30,203,29,48,31,14,31,14,30,113,31,26,31,176,31,176,30,105,31,90,31,90,30,105,31,61,31,192,31,195,31,195,30,136,31,229,31,95,31,238,31,65,31,205,31,205,30,153,31,190,31,158,31,68,31,73,31,140,31,6,31,43,31,237,31,249,31,233,31,233,30,255,31,70,31,35,31,81,31,81,30,39,31,119,31,95,31,102,31,206,31,165,31,212,31,114,31,114,30,191,31,154,31,54,31,135,31,249,31,251,31,215,31,201,31,201,30,38,31,163,31,228,31,232,31,40,31,27,31,15,31,66,31,183,31,136,31,110,31,101,31,249,31,119,31,119,30,179,31,53,31,15,31,160,31,48,31,74,31,221,31,86,31,106,31,255,31,118,31,118,30,133,31,113,31,113,30,113,29,91,31,28,31,28,30,28,29,221,31,221,30,221,29,28,31,111,31,253,31,220,31,243,31,3,31,67,31,2,31,14,31,229,31,197,31,121,31,237,31,114,31,114,30,137,31,194,31,194,30,194,29,234,31,55,31,157,31,1,31,10,31,143,31,127,31,127,30,15,31,29,31,24,31,24,30,17,31,119,31,119,30,88,31,88,30,171,31,8,31,152,31,80,31,36,31,13,31,40,31,97,31,118,31,118,30,83,31,164,31,164,30,230,31,80,31,235,31,11,31,99,31,99,30,85,31,195,31,149,31,40,31,154,31,154,30,95,31,13,31,221,31,85,31,250,31,17,31,162,31,25,31,25,30,35,31,35,31,89,31,89,30,89,29,99,31,150,31,222,31,83,31,11,31,180,31,18,31,18,30,230,31,126,31,189,31,172,31,154,31,96,31,55,31,37,31,37,30,37,29,37,28,53,31,113,31,42,31,42,30,14,31,14,30,29,31,5,31,5,30,132,31,132,30,170,31,170,30,239,31,237,31,41,31,131,31,254,31,54,31,120,31,228,31,228,30,228,29,228,28,125,31,73,31,248,31,248,30,230,31,52,31,159,31,99,31,83,31,201,31,184,31,184,30,134,31,134,30,18,31,151,31,151,30,197,31,60,31,191,31,159,31,233,31,29,31,206,31,139,31,87,31,94,31,185,31,141,31,141,30,62,31,181,31,173,31,197,31,67,31,144,31,46,31,46,30,129,31,125,31,125,30,128,31,128,30,207,31,76,31,150,31,123,31,123,30,132,31,32,31,67,31,227,31,10,31,45,31,45,30,45,29,45,28,243,31,146,31,146,30,22,31,202,31,159,31,59,31,105,31,105,30,242,31,242,30,242,29,217,31,217,30,237,31,80,31,57,31,57,30,213,31,31,31,175,31,97,31,138,31,22,31,26,31,26,30,161,31,127,31,211,31,118,31,206,31,154,31,154,30,239,31,113,31,173,31,59,31,59,30,59,29,168,31,168,30,124,31,124,30,124,29,124,28,186,31,141,31,18,31,172,31,38,31,128,31,140,31,89,31,89,30,206,31,201,31,1,31,1,30,158,31,13,31,153,31,153,30,133,31,51,31,30,31,254,31,51,31,51,30,51,29,40,31,196,31,213,31,221,31,183,31,183,30,235,31,50,31,2,31,234,31,234,30,18,31,140,31,10,31,214,31,91,31,91,30,234,31,64,31,102,31,76,31,164,31,252,31,148,31,6,31,219,31,254,31,254,30,196,31,176,31,63,31,9,31,9,30,9,29,51,31,236,31,196,31,126,31,169,31,169,30,124,31,253,31,99,31,17,31,88,31,180,31,180,30,180,29,22,31,148,31,148,30,148,29,156,31,97,31,159,31,149,31,51,31,116,31,220,31,155,31,155,30,233,31,168,31,229,31,241,31,240,31,84,31,113,31,241,31,108,31,27,31,27,30,237,31,157,31,157,30,130,31,25,31,3,31,152,31,183,31,183,30,160,31,117,31,155,31,107,31,48,31,154,31,175,31,189,31,41,31,12,31,142,31,89,31,45,31,112,31,105,31,23,31,112,31,112,30,166,31,91,31,172,31,40,31,85,31,62,31,63,31,63,30,141,31,202,31,131,31,130,31,130,30,183,31,183,30,1,31,32,31,32,30,75,31,75,30,16,31,175,31,194,31,167,31,110,31,145,31,145,30,150,31,74,31,74,30,138,31,102,31,102,30,102,29,90,31,65,31,160,31,160,30,166,31,101,31,53,31,22,31,131,31,19,31,19,30,95,31,196,31,196,30,207,31,180,31,180,30,93,31,114,31,114,30,103,31,204,31,147,31,92,31,92,30,92,29,207,31,27,31,251,31,5,31,5,30,216,31,19,31,19,30,225,31,146,31,2,31,90,31,90,30,56,31,160,31,193,31,15,31,183,31,134,31,238,31,238,30,101,31,197,31,197,31,12,31,237,31,224,31,172,31,203,31,64,31,29,31,8,31,209,31,85,31,85,30,36,31,209,31,209,30,123,31,101,31,107,31,107,30,197,31,159,31,32,31,177,31,177,30,93,31,103,31,206,31,242,31,41,31,160,31,44,31,44,30,169,31,101,31,63,31,175,31,175,30,42,31,174,31,195,31,100,31,40,31,46,31,46,30,130,31,141,31,47,31,124,31,130,31,228,31,228,30,195,31,238,31,160,31,138,31,214,31,8,31,201,31,50,31,183,31,27,31,27,30,204,31,255,31,219,31,184,31,170,31,25,31,97,31,246,31,246,30,216,31,216,30,216,29,232,31,232,30,160,31,135,31,147,31,81,31,72,31,119,31,119,30,119,29,20,31,20,30,140,31,30,31,253,31,54,31,17,31,39,31,39,30,66,31,50,31,50,30,50,29,25,31,25,30,25,29,6,31,6,30,101,31,101,30,101,29,101,28,218,31,93,31,93,30,93,29,83,31,165,31,165,30,105,31,65,31,100,31,232,31,12,31,62,31,62,30,140,31,229,31,24,31,171,31,44,31,155,31,155,30,255,31,76,31,12,31,121,31,169,31,24,31,60,31,103,31,103,30,103,29,101,31,101,30,231,31,186,31,186,30,180,31,160,31,201,31,14,31,14,30,22,31,115,31,247,31,247,30,170,31,51,31,19,31,70,31,70,30,251,31,194,31,161,31);

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
