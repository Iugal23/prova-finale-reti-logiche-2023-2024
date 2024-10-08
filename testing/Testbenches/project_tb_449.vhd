-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_449 is
end project_tb_449;

architecture project_tb_arch_449 of project_tb_449 is
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

constant SCENARIO_LENGTH : integer := 1023;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (207,0,19,0,0,0,165,0,230,0,88,0,88,0,0,0,24,0,17,0,225,0,50,0,0,0,79,0,146,0,170,0,0,0,56,0,182,0,49,0,57,0,70,0,203,0,0,0,148,0,107,0,168,0,0,0,135,0,184,0,0,0,49,0,85,0,64,0,231,0,20,0,0,0,29,0,139,0,248,0,12,0,216,0,174,0,98,0,69,0,137,0,28,0,162,0,113,0,182,0,124,0,158,0,0,0,183,0,77,0,163,0,145,0,0,0,108,0,199,0,0,0,0,0,33,0,118,0,152,0,207,0,69,0,152,0,0,0,151,0,233,0,0,0,78,0,80,0,243,0,43,0,215,0,0,0,213,0,253,0,19,0,126,0,0,0,0,0,74,0,58,0,0,0,100,0,26,0,18,0,80,0,217,0,59,0,168,0,86,0,138,0,181,0,57,0,223,0,175,0,71,0,81,0,0,0,24,0,194,0,30,0,76,0,152,0,90,0,17,0,116,0,0,0,0,0,55,0,192,0,192,0,23,0,213,0,169,0,20,0,67,0,24,0,183,0,133,0,65,0,22,0,93,0,242,0,11,0,0,0,236,0,46,0,82,0,59,0,149,0,57,0,71,0,193,0,176,0,20,0,246,0,40,0,0,0,48,0,182,0,0,0,194,0,32,0,161,0,0,0,234,0,97,0,222,0,3,0,201,0,214,0,3,0,158,0,114,0,178,0,81,0,57,0,14,0,223,0,98,0,194,0,166,0,103,0,82,0,61,0,245,0,0,0,255,0,48,0,237,0,37,0,7,0,230,0,0,0,0,0,190,0,0,0,190,0,57,0,173,0,105,0,0,0,174,0,252,0,58,0,136,0,52,0,0,0,0,0,30,0,0,0,238,0,33,0,136,0,13,0,0,0,0,0,0,0,87,0,0,0,93,0,192,0,151,0,75,0,59,0,120,0,0,0,62,0,120,0,114,0,0,0,3,0,57,0,130,0,149,0,0,0,28,0,55,0,156,0,186,0,0,0,240,0,109,0,6,0,151,0,245,0,179,0,58,0,0,0,176,0,249,0,0,0,193,0,94,0,183,0,196,0,0,0,75,0,176,0,243,0,0,0,81,0,0,0,55,0,29,0,60,0,142,0,44,0,171,0,141,0,0,0,134,0,0,0,154,0,58,0,234,0,250,0,129,0,233,0,232,0,0,0,219,0,123,0,136,0,0,0,0,0,89,0,0,0,67,0,38,0,53,0,188,0,229,0,215,0,0,0,225,0,124,0,97,0,3,0,126,0,224,0,9,0,170,0,24,0,0,0,152,0,177,0,250,0,54,0,0,0,77,0,11,0,132,0,34,0,61,0,251,0,220,0,43,0,119,0,0,0,0,0,0,0,181,0,253,0,99,0,17,0,168,0,240,0,200,0,76,0,0,0,151,0,167,0,130,0,0,0,229,0,0,0,38,0,21,0,147,0,228,0,223,0,170,0,103,0,249,0,0,0,1,0,0,0,160,0,0,0,146,0,182,0,228,0,172,0,144,0,120,0,0,0,249,0,41,0,24,0,73,0,53,0,167,0,191,0,188,0,216,0,66,0,77,0,47,0,163,0,0,0,90,0,44,0,6,0,108,0,50,0,124,0,0,0,150,0,145,0,12,0,36,0,142,0,6,0,62,0,225,0,33,0,51,0,0,0,44,0,211,0,42,0,184,0,0,0,132,0,252,0,85,0,238,0,220,0,210,0,169,0,44,0,126,0,0,0,0,0,4,0,21,0,0,0,122,0,246,0,84,0,250,0,111,0,196,0,209,0,171,0,249,0,56,0,0,0,234,0,63,0,228,0,122,0,0,0,115,0,32,0,9,0,201,0,226,0,239,0,167,0,0,0,110,0,49,0,128,0,115,0,115,0,18,0,100,0,214,0,64,0,183,0,0,0,142,0,178,0,119,0,14,0,127,0,16,0,0,0,18,0,0,0,117,0,245,0,0,0,188,0,67,0,0,0,243,0,74,0,144,0,36,0,118,0,5,0,95,0,245,0,197,0,81,0,0,0,187,0,46,0,0,0,139,0,137,0,36,0,138,0,210,0,243,0,106,0,86,0,172,0,108,0,0,0,243,0,40,0,183,0,195,0,0,0,79,0,59,0,0,0,25,0,49,0,149,0,254,0,0,0,73,0,39,0,0,0,10,0,40,0,151,0,86,0,229,0,0,0,0,0,159,0,0,0,114,0,241,0,83,0,47,0,102,0,0,0,0,0,221,0,108,0,178,0,8,0,0,0,138,0,145,0,123,0,182,0,149,0,53,0,138,0,0,0,0,0,0,0,251,0,233,0,0,0,191,0,193,0,19,0,196,0,0,0,251,0,219,0,98,0,0,0,78,0,129,0,65,0,36,0,0,0,161,0,83,0,214,0,66,0,93,0,148,0,0,0,77,0,119,0,219,0,243,0,21,0,53,0,22,0,0,0,191,0,203,0,253,0,31,0,52,0,0,0,15,0,122,0,145,0,169,0,20,0,107,0,0,0,40,0,7,0,148,0,218,0,41,0,0,0,98,0,2,0,174,0,142,0,39,0,144,0,0,0,0,0,118,0,0,0,155,0,195,0,248,0,250,0,242,0,173,0,189,0,200,0,189,0,0,0,53,0,0,0,12,0,37,0,87,0,141,0,183,0,216,0,0,0,115,0,0,0,148,0,186,0,0,0,142,0,3,0,8,0,219,0,148,0,0,0,105,0,101,0,23,0,54,0,36,0,234,0,162,0,204,0,101,0,154,0,34,0,13,0,0,0,157,0,212,0,185,0,205,0,26,0,56,0,223,0,75,0,153,0,163,0,184,0,2,0,190,0,83,0,0,0,195,0,113,0,0,0,222,0,0,0,0,0,0,0,223,0,0,0,0,0,251,0,0,0,155,0,203,0,87,0,73,0,144,0,1,0,10,0,133,0,88,0,5,0,92,0,247,0,98,0,205,0,52,0,69,0,232,0,154,0,0,0,192,0,10,0,58,0,84,0,21,0,90,0,141,0,35,0,44,0,67,0,173,0,86,0,57,0,17,0,134,0,211,0,153,0,239,0,0,0,0,0,191,0,1,0,0,0,0,0,116,0,0,0,235,0,51,0,246,0,0,0,120,0,120,0,141,0,184,0,67,0,233,0,205,0,165,0,140,0,95,0,126,0,212,0,85,0,32,0,57,0,0,0,2,0,162,0,0,0,77,0,52,0,0,0,207,0,113,0,0,0,231,0,163,0,0,0,93,0,140,0,0,0,86,0,0,0,0,0,163,0,203,0,0,0,228,0,27,0,82,0,243,0,0,0,118,0,0,0,24,0,0,0,161,0,45,0,0,0,28,0,84,0,138,0,81,0,208,0,194,0,201,0,225,0,62,0,114,0,162,0,74,0,0,0,40,0,216,0,10,0,203,0,212,0,0,0,101,0,168,0,123,0,34,0,176,0,38,0,191,0,0,0,250,0,0,0,0,0,0,0,0,0,113,0,100,0,34,0,52,0,196,0,11,0,77,0,252,0,110,0,215,0,150,0,0,0,170,0,0,0,0,0,67,0,183,0,33,0,111,0,173,0,228,0,40,0,14,0,108,0,157,0,36,0,199,0,159,0,0,0,107,0,163,0,151,0,0,0,223,0,120,0,187,0,18,0,0,0,61,0,163,0,208,0,37,0,45,0,59,0,183,0,74,0,248,0,171,0,237,0,0,0,168,0,14,0,134,0,95,0,11,0,186,0,137,0,157,0,69,0,71,0,152,0,25,0,188,0,223,0,167,0,0,0,0,0,83,0,62,0,82,0,10,0,46,0,139,0,0,0,77,0,0,0,0,0,0,0,151,0,0,0,23,0,89,0,105,0,128,0,69,0,20,0,8,0,4,0,10,0,45,0,0,0,215,0,16,0,188,0,222,0,91,0,117,0,83,0,0,0,0,0,48,0,105,0,237,0,192,0,132,0,58,0,211,0,55,0,0,0,109,0,222,0,5,0,83,0,48,0,32,0,39,0,79,0,0,0,53,0,5,0,223,0,73,0,242,0,58,0,158,0,0,0,0,0,5,0,133,0,215,0,108,0,63,0,110,0,0,0,0,0,0,0,147,0,0,0,244,0,0,0,107,0,89,0,74,0,23,0,138,0,234,0,79,0,60,0,31,0,238,0,103,0,41,0,67,0,67,0,0,0,0,0,238,0,108,0,235,0,77,0,109,0,0,0,7,0,177,0,211,0,192,0,0,0,161,0,33,0,48,0,49,0,184,0,230,0,141,0,96,0,0,0,34,0,69,0,71,0,249,0,249,0,174,0,236,0,163,0,191,0,203,0,241,0,61,0,249,0,0,0,194,0,129,0,0,0,147,0,83,0,227,0,3,0,44,0,0,0,18,0,31,0,160,0,0,0,209,0,161,0,0,0,174,0,0,0,194,0,79,0,55,0,27,0,0,0,73,0,118,0,193,0,235,0,221,0,230,0,84,0,58,0,0,0,217,0,0,0,0,0,169,0,165,0,74,0,151,0,218,0,0,0,81,0,251,0,0,0,133,0,0,0,232,0,0,0,106,0,83,0,94,0,0,0,202,0,124,0,250,0,9,0,118,0);
signal scenario_full  : scenario_type := (207,31,19,31,19,30,165,31,230,31,88,31,88,31,88,30,24,31,17,31,225,31,50,31,50,30,79,31,146,31,170,31,170,30,56,31,182,31,49,31,57,31,70,31,203,31,203,30,148,31,107,31,168,31,168,30,135,31,184,31,184,30,49,31,85,31,64,31,231,31,20,31,20,30,29,31,139,31,248,31,12,31,216,31,174,31,98,31,69,31,137,31,28,31,162,31,113,31,182,31,124,31,158,31,158,30,183,31,77,31,163,31,145,31,145,30,108,31,199,31,199,30,199,29,33,31,118,31,152,31,207,31,69,31,152,31,152,30,151,31,233,31,233,30,78,31,80,31,243,31,43,31,215,31,215,30,213,31,253,31,19,31,126,31,126,30,126,29,74,31,58,31,58,30,100,31,26,31,18,31,80,31,217,31,59,31,168,31,86,31,138,31,181,31,57,31,223,31,175,31,71,31,81,31,81,30,24,31,194,31,30,31,76,31,152,31,90,31,17,31,116,31,116,30,116,29,55,31,192,31,192,31,23,31,213,31,169,31,20,31,67,31,24,31,183,31,133,31,65,31,22,31,93,31,242,31,11,31,11,30,236,31,46,31,82,31,59,31,149,31,57,31,71,31,193,31,176,31,20,31,246,31,40,31,40,30,48,31,182,31,182,30,194,31,32,31,161,31,161,30,234,31,97,31,222,31,3,31,201,31,214,31,3,31,158,31,114,31,178,31,81,31,57,31,14,31,223,31,98,31,194,31,166,31,103,31,82,31,61,31,245,31,245,30,255,31,48,31,237,31,37,31,7,31,230,31,230,30,230,29,190,31,190,30,190,31,57,31,173,31,105,31,105,30,174,31,252,31,58,31,136,31,52,31,52,30,52,29,30,31,30,30,238,31,33,31,136,31,13,31,13,30,13,29,13,28,87,31,87,30,93,31,192,31,151,31,75,31,59,31,120,31,120,30,62,31,120,31,114,31,114,30,3,31,57,31,130,31,149,31,149,30,28,31,55,31,156,31,186,31,186,30,240,31,109,31,6,31,151,31,245,31,179,31,58,31,58,30,176,31,249,31,249,30,193,31,94,31,183,31,196,31,196,30,75,31,176,31,243,31,243,30,81,31,81,30,55,31,29,31,60,31,142,31,44,31,171,31,141,31,141,30,134,31,134,30,154,31,58,31,234,31,250,31,129,31,233,31,232,31,232,30,219,31,123,31,136,31,136,30,136,29,89,31,89,30,67,31,38,31,53,31,188,31,229,31,215,31,215,30,225,31,124,31,97,31,3,31,126,31,224,31,9,31,170,31,24,31,24,30,152,31,177,31,250,31,54,31,54,30,77,31,11,31,132,31,34,31,61,31,251,31,220,31,43,31,119,31,119,30,119,29,119,28,181,31,253,31,99,31,17,31,168,31,240,31,200,31,76,31,76,30,151,31,167,31,130,31,130,30,229,31,229,30,38,31,21,31,147,31,228,31,223,31,170,31,103,31,249,31,249,30,1,31,1,30,160,31,160,30,146,31,182,31,228,31,172,31,144,31,120,31,120,30,249,31,41,31,24,31,73,31,53,31,167,31,191,31,188,31,216,31,66,31,77,31,47,31,163,31,163,30,90,31,44,31,6,31,108,31,50,31,124,31,124,30,150,31,145,31,12,31,36,31,142,31,6,31,62,31,225,31,33,31,51,31,51,30,44,31,211,31,42,31,184,31,184,30,132,31,252,31,85,31,238,31,220,31,210,31,169,31,44,31,126,31,126,30,126,29,4,31,21,31,21,30,122,31,246,31,84,31,250,31,111,31,196,31,209,31,171,31,249,31,56,31,56,30,234,31,63,31,228,31,122,31,122,30,115,31,32,31,9,31,201,31,226,31,239,31,167,31,167,30,110,31,49,31,128,31,115,31,115,31,18,31,100,31,214,31,64,31,183,31,183,30,142,31,178,31,119,31,14,31,127,31,16,31,16,30,18,31,18,30,117,31,245,31,245,30,188,31,67,31,67,30,243,31,74,31,144,31,36,31,118,31,5,31,95,31,245,31,197,31,81,31,81,30,187,31,46,31,46,30,139,31,137,31,36,31,138,31,210,31,243,31,106,31,86,31,172,31,108,31,108,30,243,31,40,31,183,31,195,31,195,30,79,31,59,31,59,30,25,31,49,31,149,31,254,31,254,30,73,31,39,31,39,30,10,31,40,31,151,31,86,31,229,31,229,30,229,29,159,31,159,30,114,31,241,31,83,31,47,31,102,31,102,30,102,29,221,31,108,31,178,31,8,31,8,30,138,31,145,31,123,31,182,31,149,31,53,31,138,31,138,30,138,29,138,28,251,31,233,31,233,30,191,31,193,31,19,31,196,31,196,30,251,31,219,31,98,31,98,30,78,31,129,31,65,31,36,31,36,30,161,31,83,31,214,31,66,31,93,31,148,31,148,30,77,31,119,31,219,31,243,31,21,31,53,31,22,31,22,30,191,31,203,31,253,31,31,31,52,31,52,30,15,31,122,31,145,31,169,31,20,31,107,31,107,30,40,31,7,31,148,31,218,31,41,31,41,30,98,31,2,31,174,31,142,31,39,31,144,31,144,30,144,29,118,31,118,30,155,31,195,31,248,31,250,31,242,31,173,31,189,31,200,31,189,31,189,30,53,31,53,30,12,31,37,31,87,31,141,31,183,31,216,31,216,30,115,31,115,30,148,31,186,31,186,30,142,31,3,31,8,31,219,31,148,31,148,30,105,31,101,31,23,31,54,31,36,31,234,31,162,31,204,31,101,31,154,31,34,31,13,31,13,30,157,31,212,31,185,31,205,31,26,31,56,31,223,31,75,31,153,31,163,31,184,31,2,31,190,31,83,31,83,30,195,31,113,31,113,30,222,31,222,30,222,29,222,28,223,31,223,30,223,29,251,31,251,30,155,31,203,31,87,31,73,31,144,31,1,31,10,31,133,31,88,31,5,31,92,31,247,31,98,31,205,31,52,31,69,31,232,31,154,31,154,30,192,31,10,31,58,31,84,31,21,31,90,31,141,31,35,31,44,31,67,31,173,31,86,31,57,31,17,31,134,31,211,31,153,31,239,31,239,30,239,29,191,31,1,31,1,30,1,29,116,31,116,30,235,31,51,31,246,31,246,30,120,31,120,31,141,31,184,31,67,31,233,31,205,31,165,31,140,31,95,31,126,31,212,31,85,31,32,31,57,31,57,30,2,31,162,31,162,30,77,31,52,31,52,30,207,31,113,31,113,30,231,31,163,31,163,30,93,31,140,31,140,30,86,31,86,30,86,29,163,31,203,31,203,30,228,31,27,31,82,31,243,31,243,30,118,31,118,30,24,31,24,30,161,31,45,31,45,30,28,31,84,31,138,31,81,31,208,31,194,31,201,31,225,31,62,31,114,31,162,31,74,31,74,30,40,31,216,31,10,31,203,31,212,31,212,30,101,31,168,31,123,31,34,31,176,31,38,31,191,31,191,30,250,31,250,30,250,29,250,28,250,27,113,31,100,31,34,31,52,31,196,31,11,31,77,31,252,31,110,31,215,31,150,31,150,30,170,31,170,30,170,29,67,31,183,31,33,31,111,31,173,31,228,31,40,31,14,31,108,31,157,31,36,31,199,31,159,31,159,30,107,31,163,31,151,31,151,30,223,31,120,31,187,31,18,31,18,30,61,31,163,31,208,31,37,31,45,31,59,31,183,31,74,31,248,31,171,31,237,31,237,30,168,31,14,31,134,31,95,31,11,31,186,31,137,31,157,31,69,31,71,31,152,31,25,31,188,31,223,31,167,31,167,30,167,29,83,31,62,31,82,31,10,31,46,31,139,31,139,30,77,31,77,30,77,29,77,28,151,31,151,30,23,31,89,31,105,31,128,31,69,31,20,31,8,31,4,31,10,31,45,31,45,30,215,31,16,31,188,31,222,31,91,31,117,31,83,31,83,30,83,29,48,31,105,31,237,31,192,31,132,31,58,31,211,31,55,31,55,30,109,31,222,31,5,31,83,31,48,31,32,31,39,31,79,31,79,30,53,31,5,31,223,31,73,31,242,31,58,31,158,31,158,30,158,29,5,31,133,31,215,31,108,31,63,31,110,31,110,30,110,29,110,28,147,31,147,30,244,31,244,30,107,31,89,31,74,31,23,31,138,31,234,31,79,31,60,31,31,31,238,31,103,31,41,31,67,31,67,31,67,30,67,29,238,31,108,31,235,31,77,31,109,31,109,30,7,31,177,31,211,31,192,31,192,30,161,31,33,31,48,31,49,31,184,31,230,31,141,31,96,31,96,30,34,31,69,31,71,31,249,31,249,31,174,31,236,31,163,31,191,31,203,31,241,31,61,31,249,31,249,30,194,31,129,31,129,30,147,31,83,31,227,31,3,31,44,31,44,30,18,31,31,31,160,31,160,30,209,31,161,31,161,30,174,31,174,30,194,31,79,31,55,31,27,31,27,30,73,31,118,31,193,31,235,31,221,31,230,31,84,31,58,31,58,30,217,31,217,30,217,29,169,31,165,31,74,31,151,31,218,31,218,30,81,31,251,31,251,30,133,31,133,30,232,31,232,30,106,31,83,31,94,31,94,30,202,31,124,31,250,31,9,31,118,31);

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
