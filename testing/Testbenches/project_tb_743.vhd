-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_743 is
end project_tb_743;

architecture project_tb_arch_743 of project_tb_743 is
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

constant SCENARIO_LENGTH : integer := 974;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (161,0,228,0,136,0,230,0,128,0,158,0,100,0,209,0,114,0,92,0,0,0,38,0,60,0,198,0,235,0,144,0,246,0,0,0,126,0,32,0,25,0,0,0,77,0,55,0,0,0,164,0,191,0,0,0,24,0,206,0,168,0,224,0,109,0,0,0,0,0,122,0,141,0,195,0,48,0,228,0,57,0,143,0,190,0,64,0,139,0,155,0,134,0,185,0,39,0,188,0,20,0,127,0,75,0,10,0,15,0,115,0,121,0,135,0,94,0,0,0,178,0,0,0,0,0,61,0,65,0,0,0,41,0,167,0,82,0,222,0,238,0,29,0,243,0,77,0,0,0,97,0,118,0,0,0,0,0,0,0,0,0,203,0,190,0,146,0,223,0,42,0,148,0,195,0,25,0,112,0,5,0,181,0,216,0,0,0,164,0,210,0,241,0,0,0,64,0,53,0,243,0,134,0,247,0,0,0,177,0,123,0,65,0,118,0,77,0,121,0,0,0,203,0,134,0,97,0,214,0,0,0,33,0,0,0,188,0,185,0,252,0,9,0,9,0,0,0,0,0,0,0,201,0,231,0,27,0,0,0,237,0,78,0,217,0,184,0,207,0,0,0,0,0,0,0,38,0,189,0,204,0,207,0,9,0,0,0,100,0,21,0,0,0,100,0,132,0,156,0,188,0,0,0,2,0,195,0,38,0,79,0,70,0,103,0,252,0,0,0,173,0,0,0,6,0,166,0,88,0,155,0,18,0,44,0,182,0,212,0,0,0,40,0,244,0,0,0,177,0,145,0,34,0,132,0,103,0,0,0,100,0,29,0,126,0,228,0,109,0,0,0,78,0,0,0,0,0,185,0,109,0,66,0,243,0,43,0,0,0,186,0,55,0,0,0,0,0,200,0,0,0,194,0,112,0,117,0,206,0,146,0,90,0,8,0,0,0,128,0,107,0,214,0,111,0,243,0,184,0,111,0,234,0,72,0,0,0,143,0,158,0,133,0,159,0,0,0,54,0,97,0,246,0,116,0,7,0,88,0,228,0,154,0,149,0,16,0,100,0,206,0,0,0,222,0,251,0,195,0,200,0,28,0,80,0,76,0,0,0,0,0,161,0,72,0,2,0,0,0,0,0,82,0,23,0,0,0,248,0,250,0,139,0,210,0,0,0,55,0,0,0,122,0,0,0,254,0,188,0,111,0,117,0,245,0,237,0,22,0,100,0,204,0,186,0,0,0,0,0,126,0,0,0,183,0,91,0,229,0,0,0,23,0,145,0,83,0,221,0,16,0,31,0,150,0,113,0,172,0,115,0,53,0,13,0,33,0,0,0,0,0,99,0,201,0,78,0,106,0,48,0,0,0,117,0,115,0,185,0,114,0,11,0,4,0,165,0,170,0,0,0,56,0,0,0,210,0,58,0,132,0,202,0,0,0,0,0,78,0,106,0,0,0,45,0,0,0,0,0,22,0,205,0,229,0,51,0,195,0,114,0,202,0,92,0,0,0,30,0,3,0,238,0,33,0,82,0,0,0,6,0,0,0,128,0,22,0,212,0,0,0,0,0,15,0,126,0,151,0,114,0,227,0,178,0,219,0,14,0,170,0,10,0,195,0,184,0,54,0,94,0,59,0,14,0,93,0,140,0,0,0,20,0,216,0,15,0,0,0,173,0,34,0,59,0,208,0,193,0,203,0,243,0,88,0,200,0,0,0,251,0,0,0,168,0,138,0,74,0,201,0,205,0,172,0,185,0,180,0,169,0,148,0,220,0,0,0,0,0,45,0,127,0,164,0,11,0,157,0,76,0,0,0,0,0,202,0,0,0,0,0,75,0,19,0,45,0,115,0,134,0,0,0,104,0,184,0,245,0,248,0,169,0,138,0,49,0,73,0,60,0,5,0,76,0,214,0,235,0,0,0,0,0,38,0,123,0,118,0,0,0,255,0,41,0,33,0,3,0,253,0,254,0,0,0,199,0,236,0,0,0,0,0,0,0,112,0,0,0,1,0,231,0,129,0,106,0,0,0,87,0,0,0,198,0,116,0,204,0,90,0,230,0,60,0,128,0,0,0,174,0,252,0,171,0,207,0,207,0,0,0,1,0,177,0,177,0,0,0,156,0,0,0,213,0,0,0,0,0,84,0,110,0,6,0,94,0,82,0,0,0,0,0,32,0,181,0,249,0,0,0,0,0,237,0,113,0,215,0,83,0,0,0,251,0,0,0,34,0,220,0,14,0,210,0,27,0,77,0,111,0,133,0,168,0,186,0,25,0,251,0,0,0,0,0,0,0,228,0,74,0,11,0,56,0,183,0,42,0,19,0,117,0,33,0,217,0,206,0,60,0,186,0,0,0,197,0,14,0,0,0,99,0,66,0,111,0,251,0,14,0,189,0,0,0,56,0,69,0,240,0,16,0,119,0,66,0,0,0,184,0,98,0,119,0,95,0,72,0,154,0,175,0,224,0,0,0,225,0,0,0,198,0,0,0,196,0,0,0,23,0,172,0,17,0,4,0,218,0,10,0,0,0,244,0,36,0,95,0,18,0,221,0,0,0,150,0,231,0,17,0,0,0,201,0,67,0,158,0,171,0,248,0,201,0,43,0,0,0,56,0,89,0,174,0,0,0,126,0,190,0,62,0,135,0,117,0,240,0,17,0,21,0,4,0,104,0,128,0,152,0,15,0,110,0,107,0,125,0,76,0,156,0,60,0,97,0,76,0,220,0,79,0,18,0,0,0,52,0,139,0,88,0,62,0,94,0,100,0,61,0,0,0,78,0,173,0,63,0,28,0,193,0,0,0,249,0,250,0,203,0,120,0,13,0,34,0,57,0,0,0,74,0,243,0,152,0,111,0,125,0,115,0,2,0,241,0,25,0,55,0,176,0,107,0,117,0,110,0,221,0,101,0,0,0,128,0,227,0,208,0,22,0,218,0,0,0,238,0,132,0,0,0,56,0,0,0,239,0,187,0,161,0,240,0,0,0,81,0,163,0,29,0,216,0,71,0,3,0,0,0,194,0,0,0,65,0,44,0,203,0,0,0,12,0,0,0,0,0,0,0,180,0,51,0,50,0,188,0,245,0,126,0,199,0,218,0,145,0,47,0,70,0,141,0,214,0,248,0,176,0,0,0,109,0,113,0,164,0,148,0,0,0,170,0,184,0,253,0,66,0,95,0,115,0,48,0,0,0,28,0,148,0,57,0,201,0,170,0,50,0,58,0,197,0,165,0,58,0,93,0,176,0,0,0,37,0,254,0,72,0,83,0,5,0,0,0,225,0,192,0,0,0,158,0,13,0,48,0,222,0,172,0,126,0,41,0,15,0,0,0,128,0,183,0,0,0,159,0,106,0,161,0,96,0,202,0,14,0,162,0,221,0,66,0,0,0,40,0,240,0,51,0,0,0,174,0,0,0,0,0,247,0,178,0,252,0,0,0,172,0,0,0,0,0,32,0,109,0,148,0,0,0,255,0,93,0,207,0,188,0,183,0,238,0,30,0,166,0,126,0,232,0,58,0,6,0,225,0,188,0,39,0,88,0,225,0,105,0,253,0,87,0,129,0,0,0,112,0,131,0,126,0,51,0,237,0,175,0,0,0,95,0,47,0,68,0,94,0,103,0,136,0,254,0,246,0,0,0,207,0,138,0,201,0,0,0,124,0,129,0,60,0,130,0,0,0,0,0,0,0,0,0,168,0,0,0,0,0,78,0,163,0,0,0,212,0,216,0,2,0,214,0,32,0,71,0,190,0,112,0,0,0,0,0,231,0,207,0,2,0,133,0,51,0,115,0,248,0,0,0,97,0,0,0,19,0,144,0,160,0,140,0,124,0,249,0,222,0,71,0,171,0,109,0,227,0,0,0,213,0,122,0,15,0,74,0,220,0,137,0,124,0,132,0,114,0,85,0,129,0,26,0,73,0,101,0,146,0,0,0,240,0,194,0,254,0,217,0,236,0,201,0,81,0,0,0,136,0,184,0,232,0,125,0,205,0,5,0,0,0,46,0,45,0,0,0,125,0,161,0,80,0,190,0,0,0,13,0,249,0,12,0,254,0,147,0,211,0,143,0,56,0,216,0,238,0,120,0,0,0,174,0,43,0,105,0,98,0,174,0,232,0,0,0,125,0,97,0,253,0,39,0,240,0,47,0,228,0,136,0,33,0,0,0,177,0,230,0,84,0,227,0,152,0,111,0,0,0,226,0,0,0,53,0,86,0,69,0,9,0,60,0,90,0,105,0,32,0,0,0,212,0,0,0,233,0,250,0,246,0,0,0,233,0,96,0,213,0,0,0,0,0,203,0,131,0,174,0,116,0,30,0,138,0,104,0,93,0,18,0,13,0,53,0,0,0,0,0,172,0,141,0,242,0,0,0);
signal scenario_full  : scenario_type := (161,31,228,31,136,31,230,31,128,31,158,31,100,31,209,31,114,31,92,31,92,30,38,31,60,31,198,31,235,31,144,31,246,31,246,30,126,31,32,31,25,31,25,30,77,31,55,31,55,30,164,31,191,31,191,30,24,31,206,31,168,31,224,31,109,31,109,30,109,29,122,31,141,31,195,31,48,31,228,31,57,31,143,31,190,31,64,31,139,31,155,31,134,31,185,31,39,31,188,31,20,31,127,31,75,31,10,31,15,31,115,31,121,31,135,31,94,31,94,30,178,31,178,30,178,29,61,31,65,31,65,30,41,31,167,31,82,31,222,31,238,31,29,31,243,31,77,31,77,30,97,31,118,31,118,30,118,29,118,28,118,27,203,31,190,31,146,31,223,31,42,31,148,31,195,31,25,31,112,31,5,31,181,31,216,31,216,30,164,31,210,31,241,31,241,30,64,31,53,31,243,31,134,31,247,31,247,30,177,31,123,31,65,31,118,31,77,31,121,31,121,30,203,31,134,31,97,31,214,31,214,30,33,31,33,30,188,31,185,31,252,31,9,31,9,31,9,30,9,29,9,28,201,31,231,31,27,31,27,30,237,31,78,31,217,31,184,31,207,31,207,30,207,29,207,28,38,31,189,31,204,31,207,31,9,31,9,30,100,31,21,31,21,30,100,31,132,31,156,31,188,31,188,30,2,31,195,31,38,31,79,31,70,31,103,31,252,31,252,30,173,31,173,30,6,31,166,31,88,31,155,31,18,31,44,31,182,31,212,31,212,30,40,31,244,31,244,30,177,31,145,31,34,31,132,31,103,31,103,30,100,31,29,31,126,31,228,31,109,31,109,30,78,31,78,30,78,29,185,31,109,31,66,31,243,31,43,31,43,30,186,31,55,31,55,30,55,29,200,31,200,30,194,31,112,31,117,31,206,31,146,31,90,31,8,31,8,30,128,31,107,31,214,31,111,31,243,31,184,31,111,31,234,31,72,31,72,30,143,31,158,31,133,31,159,31,159,30,54,31,97,31,246,31,116,31,7,31,88,31,228,31,154,31,149,31,16,31,100,31,206,31,206,30,222,31,251,31,195,31,200,31,28,31,80,31,76,31,76,30,76,29,161,31,72,31,2,31,2,30,2,29,82,31,23,31,23,30,248,31,250,31,139,31,210,31,210,30,55,31,55,30,122,31,122,30,254,31,188,31,111,31,117,31,245,31,237,31,22,31,100,31,204,31,186,31,186,30,186,29,126,31,126,30,183,31,91,31,229,31,229,30,23,31,145,31,83,31,221,31,16,31,31,31,150,31,113,31,172,31,115,31,53,31,13,31,33,31,33,30,33,29,99,31,201,31,78,31,106,31,48,31,48,30,117,31,115,31,185,31,114,31,11,31,4,31,165,31,170,31,170,30,56,31,56,30,210,31,58,31,132,31,202,31,202,30,202,29,78,31,106,31,106,30,45,31,45,30,45,29,22,31,205,31,229,31,51,31,195,31,114,31,202,31,92,31,92,30,30,31,3,31,238,31,33,31,82,31,82,30,6,31,6,30,128,31,22,31,212,31,212,30,212,29,15,31,126,31,151,31,114,31,227,31,178,31,219,31,14,31,170,31,10,31,195,31,184,31,54,31,94,31,59,31,14,31,93,31,140,31,140,30,20,31,216,31,15,31,15,30,173,31,34,31,59,31,208,31,193,31,203,31,243,31,88,31,200,31,200,30,251,31,251,30,168,31,138,31,74,31,201,31,205,31,172,31,185,31,180,31,169,31,148,31,220,31,220,30,220,29,45,31,127,31,164,31,11,31,157,31,76,31,76,30,76,29,202,31,202,30,202,29,75,31,19,31,45,31,115,31,134,31,134,30,104,31,184,31,245,31,248,31,169,31,138,31,49,31,73,31,60,31,5,31,76,31,214,31,235,31,235,30,235,29,38,31,123,31,118,31,118,30,255,31,41,31,33,31,3,31,253,31,254,31,254,30,199,31,236,31,236,30,236,29,236,28,112,31,112,30,1,31,231,31,129,31,106,31,106,30,87,31,87,30,198,31,116,31,204,31,90,31,230,31,60,31,128,31,128,30,174,31,252,31,171,31,207,31,207,31,207,30,1,31,177,31,177,31,177,30,156,31,156,30,213,31,213,30,213,29,84,31,110,31,6,31,94,31,82,31,82,30,82,29,32,31,181,31,249,31,249,30,249,29,237,31,113,31,215,31,83,31,83,30,251,31,251,30,34,31,220,31,14,31,210,31,27,31,77,31,111,31,133,31,168,31,186,31,25,31,251,31,251,30,251,29,251,28,228,31,74,31,11,31,56,31,183,31,42,31,19,31,117,31,33,31,217,31,206,31,60,31,186,31,186,30,197,31,14,31,14,30,99,31,66,31,111,31,251,31,14,31,189,31,189,30,56,31,69,31,240,31,16,31,119,31,66,31,66,30,184,31,98,31,119,31,95,31,72,31,154,31,175,31,224,31,224,30,225,31,225,30,198,31,198,30,196,31,196,30,23,31,172,31,17,31,4,31,218,31,10,31,10,30,244,31,36,31,95,31,18,31,221,31,221,30,150,31,231,31,17,31,17,30,201,31,67,31,158,31,171,31,248,31,201,31,43,31,43,30,56,31,89,31,174,31,174,30,126,31,190,31,62,31,135,31,117,31,240,31,17,31,21,31,4,31,104,31,128,31,152,31,15,31,110,31,107,31,125,31,76,31,156,31,60,31,97,31,76,31,220,31,79,31,18,31,18,30,52,31,139,31,88,31,62,31,94,31,100,31,61,31,61,30,78,31,173,31,63,31,28,31,193,31,193,30,249,31,250,31,203,31,120,31,13,31,34,31,57,31,57,30,74,31,243,31,152,31,111,31,125,31,115,31,2,31,241,31,25,31,55,31,176,31,107,31,117,31,110,31,221,31,101,31,101,30,128,31,227,31,208,31,22,31,218,31,218,30,238,31,132,31,132,30,56,31,56,30,239,31,187,31,161,31,240,31,240,30,81,31,163,31,29,31,216,31,71,31,3,31,3,30,194,31,194,30,65,31,44,31,203,31,203,30,12,31,12,30,12,29,12,28,180,31,51,31,50,31,188,31,245,31,126,31,199,31,218,31,145,31,47,31,70,31,141,31,214,31,248,31,176,31,176,30,109,31,113,31,164,31,148,31,148,30,170,31,184,31,253,31,66,31,95,31,115,31,48,31,48,30,28,31,148,31,57,31,201,31,170,31,50,31,58,31,197,31,165,31,58,31,93,31,176,31,176,30,37,31,254,31,72,31,83,31,5,31,5,30,225,31,192,31,192,30,158,31,13,31,48,31,222,31,172,31,126,31,41,31,15,31,15,30,128,31,183,31,183,30,159,31,106,31,161,31,96,31,202,31,14,31,162,31,221,31,66,31,66,30,40,31,240,31,51,31,51,30,174,31,174,30,174,29,247,31,178,31,252,31,252,30,172,31,172,30,172,29,32,31,109,31,148,31,148,30,255,31,93,31,207,31,188,31,183,31,238,31,30,31,166,31,126,31,232,31,58,31,6,31,225,31,188,31,39,31,88,31,225,31,105,31,253,31,87,31,129,31,129,30,112,31,131,31,126,31,51,31,237,31,175,31,175,30,95,31,47,31,68,31,94,31,103,31,136,31,254,31,246,31,246,30,207,31,138,31,201,31,201,30,124,31,129,31,60,31,130,31,130,30,130,29,130,28,130,27,168,31,168,30,168,29,78,31,163,31,163,30,212,31,216,31,2,31,214,31,32,31,71,31,190,31,112,31,112,30,112,29,231,31,207,31,2,31,133,31,51,31,115,31,248,31,248,30,97,31,97,30,19,31,144,31,160,31,140,31,124,31,249,31,222,31,71,31,171,31,109,31,227,31,227,30,213,31,122,31,15,31,74,31,220,31,137,31,124,31,132,31,114,31,85,31,129,31,26,31,73,31,101,31,146,31,146,30,240,31,194,31,254,31,217,31,236,31,201,31,81,31,81,30,136,31,184,31,232,31,125,31,205,31,5,31,5,30,46,31,45,31,45,30,125,31,161,31,80,31,190,31,190,30,13,31,249,31,12,31,254,31,147,31,211,31,143,31,56,31,216,31,238,31,120,31,120,30,174,31,43,31,105,31,98,31,174,31,232,31,232,30,125,31,97,31,253,31,39,31,240,31,47,31,228,31,136,31,33,31,33,30,177,31,230,31,84,31,227,31,152,31,111,31,111,30,226,31,226,30,53,31,86,31,69,31,9,31,60,31,90,31,105,31,32,31,32,30,212,31,212,30,233,31,250,31,246,31,246,30,233,31,96,31,213,31,213,30,213,29,203,31,131,31,174,31,116,31,30,31,138,31,104,31,93,31,18,31,13,31,53,31,53,30,53,29,172,31,141,31,242,31,242,30);

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
