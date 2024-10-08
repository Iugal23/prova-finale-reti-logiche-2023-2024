-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_130 is
end project_tb_130;

architecture project_tb_arch_130 of project_tb_130 is
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

constant SCENARIO_LENGTH : integer := 1013;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (53,0,42,0,108,0,21,0,217,0,17,0,16,0,82,0,158,0,170,0,111,0,74,0,169,0,0,0,166,0,24,0,128,0,186,0,1,0,0,0,173,0,107,0,147,0,52,0,0,0,96,0,0,0,141,0,192,0,208,0,154,0,106,0,69,0,203,0,0,0,208,0,0,0,124,0,215,0,11,0,0,0,44,0,139,0,166,0,161,0,77,0,133,0,38,0,13,0,252,0,98,0,0,0,93,0,149,0,91,0,83,0,9,0,0,0,0,0,160,0,49,0,171,0,46,0,32,0,229,0,47,0,216,0,199,0,33,0,151,0,0,0,26,0,202,0,125,0,0,0,86,0,0,0,96,0,174,0,0,0,237,0,80,0,144,0,0,0,220,0,20,0,0,0,231,0,73,0,144,0,0,0,180,0,79,0,129,0,107,0,155,0,0,0,0,0,0,0,30,0,234,0,187,0,0,0,232,0,181,0,238,0,240,0,17,0,157,0,146,0,3,0,213,0,204,0,51,0,168,0,0,0,26,0,68,0,0,0,204,0,127,0,104,0,138,0,35,0,31,0,190,0,42,0,0,0,219,0,72,0,201,0,235,0,0,0,204,0,0,0,198,0,128,0,6,0,48,0,0,0,0,0,69,0,2,0,251,0,21,0,97,0,112,0,129,0,216,0,117,0,107,0,30,0,139,0,51,0,79,0,141,0,182,0,217,0,222,0,60,0,183,0,79,0,185,0,57,0,107,0,10,0,42,0,0,0,236,0,76,0,29,0,0,0,86,0,187,0,0,0,209,0,36,0,41,0,59,0,0,0,0,0,147,0,32,0,212,0,104,0,2,0,34,0,159,0,28,0,0,0,245,0,0,0,136,0,212,0,0,0,202,0,203,0,96,0,0,0,80,0,0,0,0,0,5,0,0,0,24,0,204,0,232,0,83,0,19,0,0,0,0,0,206,0,0,0,72,0,100,0,0,0,6,0,217,0,20,0,32,0,0,0,252,0,16,0,230,0,4,0,124,0,114,0,232,0,167,0,175,0,0,0,0,0,0,0,110,0,138,0,223,0,102,0,0,0,9,0,154,0,163,0,0,0,0,0,0,0,54,0,154,0,35,0,119,0,0,0,40,0,0,0,220,0,76,0,190,0,156,0,112,0,0,0,144,0,104,0,56,0,174,0,102,0,177,0,242,0,68,0,78,0,7,0,183,0,227,0,5,0,226,0,213,0,167,0,99,0,0,0,16,0,160,0,56,0,40,0,109,0,213,0,120,0,183,0,157,0,96,0,15,0,185,0,222,0,96,0,220,0,159,0,193,0,107,0,131,0,233,0,0,0,79,0,91,0,0,0,0,0,150,0,188,0,103,0,221,0,2,0,126,0,10,0,179,0,0,0,84,0,153,0,42,0,66,0,183,0,121,0,77,0,131,0,0,0,123,0,53,0,109,0,201,0,82,0,97,0,17,0,123,0,92,0,92,0,74,0,0,0,126,0,250,0,0,0,0,0,0,0,194,0,0,0,172,0,0,0,15,0,249,0,41,0,9,0,200,0,109,0,111,0,0,0,0,0,224,0,151,0,0,0,3,0,0,0,202,0,104,0,0,0,152,0,0,0,118,0,0,0,161,0,89,0,0,0,103,0,31,0,0,0,253,0,81,0,0,0,0,0,13,0,137,0,182,0,99,0,115,0,231,0,158,0,120,0,143,0,240,0,105,0,210,0,121,0,0,0,12,0,198,0,193,0,30,0,18,0,242,0,48,0,208,0,113,0,93,0,231,0,204,0,247,0,0,0,177,0,104,0,0,0,13,0,17,0,236,0,0,0,0,0,200,0,254,0,114,0,78,0,0,0,62,0,244,0,114,0,221,0,212,0,238,0,82,0,97,0,234,0,0,0,0,0,0,0,101,0,234,0,129,0,0,0,0,0,224,0,57,0,133,0,60,0,0,0,138,0,57,0,144,0,107,0,255,0,238,0,0,0,15,0,0,0,229,0,57,0,90,0,202,0,97,0,0,0,133,0,6,0,137,0,124,0,70,0,78,0,48,0,252,0,31,0,37,0,52,0,48,0,47,0,195,0,160,0,166,0,0,0,0,0,0,0,47,0,207,0,85,0,0,0,226,0,214,0,144,0,121,0,144,0,68,0,0,0,42,0,195,0,181,0,217,0,169,0,0,0,164,0,140,0,242,0,7,0,145,0,164,0,206,0,55,0,157,0,5,0,233,0,108,0,0,0,0,0,240,0,71,0,122,0,0,0,0,0,0,0,0,0,249,0,88,0,140,0,175,0,148,0,27,0,6,0,137,0,78,0,236,0,0,0,0,0,182,0,50,0,228,0,124,0,204,0,149,0,0,0,207,0,176,0,68,0,202,0,139,0,92,0,129,0,205,0,24,0,159,0,0,0,17,0,126,0,217,0,0,0,31,0,135,0,21,0,0,0,226,0,0,0,25,0,189,0,225,0,0,0,62,0,135,0,0,0,144,0,22,0,139,0,135,0,43,0,249,0,182,0,48,0,0,0,21,0,19,0,109,0,0,0,183,0,156,0,0,0,240,0,0,0,79,0,0,0,26,0,202,0,147,0,19,0,221,0,0,0,193,0,194,0,118,0,130,0,127,0,33,0,0,0,143,0,93,0,107,0,64,0,0,0,0,0,217,0,148,0,181,0,169,0,41,0,124,0,188,0,13,0,118,0,79,0,56,0,126,0,139,0,116,0,191,0,59,0,184,0,6,0,159,0,0,0,56,0,0,0,0,0,0,0,154,0,132,0,129,0,249,0,165,0,28,0,188,0,140,0,140,0,127,0,213,0,240,0,0,0,242,0,0,0,0,0,70,0,41,0,64,0,215,0,205,0,54,0,41,0,183,0,0,0,132,0,0,0,193,0,0,0,0,0,66,0,213,0,135,0,50,0,59,0,42,0,42,0,127,0,254,0,0,0,95,0,0,0,0,0,0,0,153,0,206,0,0,0,222,0,148,0,0,0,66,0,252,0,244,0,245,0,19,0,0,0,247,0,231,0,162,0,202,0,126,0,125,0,0,0,113,0,0,0,157,0,61,0,4,0,0,0,71,0,148,0,65,0,195,0,231,0,0,0,60,0,233,0,222,0,0,0,52,0,164,0,17,0,0,0,240,0,0,0,251,0,0,0,0,0,201,0,127,0,255,0,242,0,135,0,97,0,0,0,117,0,45,0,127,0,108,0,56,0,63,0,223,0,18,0,0,0,241,0,0,0,77,0,147,0,204,0,6,0,81,0,163,0,138,0,97,0,0,0,66,0,194,0,0,0,102,0,81,0,243,0,0,0,45,0,69,0,108,0,133,0,70,0,0,0,18,0,39,0,0,0,205,0,164,0,0,0,180,0,0,0,146,0,169,0,20,0,145,0,0,0,40,0,223,0,41,0,0,0,219,0,0,0,191,0,153,0,163,0,0,0,216,0,206,0,218,0,35,0,72,0,123,0,244,0,174,0,249,0,246,0,0,0,50,0,202,0,234,0,150,0,251,0,247,0,170,0,4,0,254,0,73,0,192,0,173,0,136,0,78,0,139,0,46,0,0,0,163,0,0,0,0,0,9,0,183,0,0,0,96,0,78,0,196,0,44,0,217,0,104,0,196,0,39,0,129,0,21,0,214,0,119,0,86,0,169,0,46,0,155,0,118,0,242,0,17,0,250,0,111,0,245,0,210,0,10,0,0,0,171,0,142,0,122,0,114,0,0,0,208,0,168,0,100,0,4,0,79,0,148,0,47,0,77,0,26,0,62,0,0,0,55,0,96,0,149,0,3,0,0,0,179,0,0,0,139,0,222,0,43,0,237,0,49,0,38,0,93,0,8,0,255,0,0,0,12,0,98,0,251,0,245,0,29,0,36,0,16,0,0,0,37,0,0,0,88,0,245,0,0,0,181,0,245,0,0,0,139,0,125,0,52,0,156,0,230,0,18,0,192,0,115,0,29,0,153,0,160,0,3,0,63,0,0,0,235,0,24,0,123,0,242,0,128,0,4,0,179,0,0,0,0,0,171,0,44,0,53,0,203,0,0,0,193,0,138,0,66,0,250,0,136,0,201,0,123,0,136,0,0,0,243,0,176,0,134,0,0,0,23,0,141,0,13,0,93,0,115,0,200,0,62,0,164,0,157,0,127,0,0,0,0,0,0,0,230,0,198,0,167,0,186,0,0,0,0,0,60,0,146,0,239,0,100,0,72,0,7,0,17,0,0,0,145,0,150,0,179,0,63,0,227,0,6,0,248,0,157,0,121,0,41,0,2,0,0,0,38,0,202,0,0,0,141,0,246,0,93,0,53,0,167,0,161,0,123,0,67,0,102,0,207,0,50,0,245,0,57,0,207,0,79,0,92,0,225,0,0,0,247,0,62,0,39,0,186,0,141,0,203,0,0,0,0,0,223,0,237,0,97,0,63,0,66,0,168,0,59,0,0,0,111,0,0,0,106,0,227,0,208,0,29,0,24,0,36,0,17,0,193,0,0,0,180,0,196,0,69,0,0,0,193,0,228,0,66,0,32,0,126,0,179,0,210,0);
signal scenario_full  : scenario_type := (53,31,42,31,108,31,21,31,217,31,17,31,16,31,82,31,158,31,170,31,111,31,74,31,169,31,169,30,166,31,24,31,128,31,186,31,1,31,1,30,173,31,107,31,147,31,52,31,52,30,96,31,96,30,141,31,192,31,208,31,154,31,106,31,69,31,203,31,203,30,208,31,208,30,124,31,215,31,11,31,11,30,44,31,139,31,166,31,161,31,77,31,133,31,38,31,13,31,252,31,98,31,98,30,93,31,149,31,91,31,83,31,9,31,9,30,9,29,160,31,49,31,171,31,46,31,32,31,229,31,47,31,216,31,199,31,33,31,151,31,151,30,26,31,202,31,125,31,125,30,86,31,86,30,96,31,174,31,174,30,237,31,80,31,144,31,144,30,220,31,20,31,20,30,231,31,73,31,144,31,144,30,180,31,79,31,129,31,107,31,155,31,155,30,155,29,155,28,30,31,234,31,187,31,187,30,232,31,181,31,238,31,240,31,17,31,157,31,146,31,3,31,213,31,204,31,51,31,168,31,168,30,26,31,68,31,68,30,204,31,127,31,104,31,138,31,35,31,31,31,190,31,42,31,42,30,219,31,72,31,201,31,235,31,235,30,204,31,204,30,198,31,128,31,6,31,48,31,48,30,48,29,69,31,2,31,251,31,21,31,97,31,112,31,129,31,216,31,117,31,107,31,30,31,139,31,51,31,79,31,141,31,182,31,217,31,222,31,60,31,183,31,79,31,185,31,57,31,107,31,10,31,42,31,42,30,236,31,76,31,29,31,29,30,86,31,187,31,187,30,209,31,36,31,41,31,59,31,59,30,59,29,147,31,32,31,212,31,104,31,2,31,34,31,159,31,28,31,28,30,245,31,245,30,136,31,212,31,212,30,202,31,203,31,96,31,96,30,80,31,80,30,80,29,5,31,5,30,24,31,204,31,232,31,83,31,19,31,19,30,19,29,206,31,206,30,72,31,100,31,100,30,6,31,217,31,20,31,32,31,32,30,252,31,16,31,230,31,4,31,124,31,114,31,232,31,167,31,175,31,175,30,175,29,175,28,110,31,138,31,223,31,102,31,102,30,9,31,154,31,163,31,163,30,163,29,163,28,54,31,154,31,35,31,119,31,119,30,40,31,40,30,220,31,76,31,190,31,156,31,112,31,112,30,144,31,104,31,56,31,174,31,102,31,177,31,242,31,68,31,78,31,7,31,183,31,227,31,5,31,226,31,213,31,167,31,99,31,99,30,16,31,160,31,56,31,40,31,109,31,213,31,120,31,183,31,157,31,96,31,15,31,185,31,222,31,96,31,220,31,159,31,193,31,107,31,131,31,233,31,233,30,79,31,91,31,91,30,91,29,150,31,188,31,103,31,221,31,2,31,126,31,10,31,179,31,179,30,84,31,153,31,42,31,66,31,183,31,121,31,77,31,131,31,131,30,123,31,53,31,109,31,201,31,82,31,97,31,17,31,123,31,92,31,92,31,74,31,74,30,126,31,250,31,250,30,250,29,250,28,194,31,194,30,172,31,172,30,15,31,249,31,41,31,9,31,200,31,109,31,111,31,111,30,111,29,224,31,151,31,151,30,3,31,3,30,202,31,104,31,104,30,152,31,152,30,118,31,118,30,161,31,89,31,89,30,103,31,31,31,31,30,253,31,81,31,81,30,81,29,13,31,137,31,182,31,99,31,115,31,231,31,158,31,120,31,143,31,240,31,105,31,210,31,121,31,121,30,12,31,198,31,193,31,30,31,18,31,242,31,48,31,208,31,113,31,93,31,231,31,204,31,247,31,247,30,177,31,104,31,104,30,13,31,17,31,236,31,236,30,236,29,200,31,254,31,114,31,78,31,78,30,62,31,244,31,114,31,221,31,212,31,238,31,82,31,97,31,234,31,234,30,234,29,234,28,101,31,234,31,129,31,129,30,129,29,224,31,57,31,133,31,60,31,60,30,138,31,57,31,144,31,107,31,255,31,238,31,238,30,15,31,15,30,229,31,57,31,90,31,202,31,97,31,97,30,133,31,6,31,137,31,124,31,70,31,78,31,48,31,252,31,31,31,37,31,52,31,48,31,47,31,195,31,160,31,166,31,166,30,166,29,166,28,47,31,207,31,85,31,85,30,226,31,214,31,144,31,121,31,144,31,68,31,68,30,42,31,195,31,181,31,217,31,169,31,169,30,164,31,140,31,242,31,7,31,145,31,164,31,206,31,55,31,157,31,5,31,233,31,108,31,108,30,108,29,240,31,71,31,122,31,122,30,122,29,122,28,122,27,249,31,88,31,140,31,175,31,148,31,27,31,6,31,137,31,78,31,236,31,236,30,236,29,182,31,50,31,228,31,124,31,204,31,149,31,149,30,207,31,176,31,68,31,202,31,139,31,92,31,129,31,205,31,24,31,159,31,159,30,17,31,126,31,217,31,217,30,31,31,135,31,21,31,21,30,226,31,226,30,25,31,189,31,225,31,225,30,62,31,135,31,135,30,144,31,22,31,139,31,135,31,43,31,249,31,182,31,48,31,48,30,21,31,19,31,109,31,109,30,183,31,156,31,156,30,240,31,240,30,79,31,79,30,26,31,202,31,147,31,19,31,221,31,221,30,193,31,194,31,118,31,130,31,127,31,33,31,33,30,143,31,93,31,107,31,64,31,64,30,64,29,217,31,148,31,181,31,169,31,41,31,124,31,188,31,13,31,118,31,79,31,56,31,126,31,139,31,116,31,191,31,59,31,184,31,6,31,159,31,159,30,56,31,56,30,56,29,56,28,154,31,132,31,129,31,249,31,165,31,28,31,188,31,140,31,140,31,127,31,213,31,240,31,240,30,242,31,242,30,242,29,70,31,41,31,64,31,215,31,205,31,54,31,41,31,183,31,183,30,132,31,132,30,193,31,193,30,193,29,66,31,213,31,135,31,50,31,59,31,42,31,42,31,127,31,254,31,254,30,95,31,95,30,95,29,95,28,153,31,206,31,206,30,222,31,148,31,148,30,66,31,252,31,244,31,245,31,19,31,19,30,247,31,231,31,162,31,202,31,126,31,125,31,125,30,113,31,113,30,157,31,61,31,4,31,4,30,71,31,148,31,65,31,195,31,231,31,231,30,60,31,233,31,222,31,222,30,52,31,164,31,17,31,17,30,240,31,240,30,251,31,251,30,251,29,201,31,127,31,255,31,242,31,135,31,97,31,97,30,117,31,45,31,127,31,108,31,56,31,63,31,223,31,18,31,18,30,241,31,241,30,77,31,147,31,204,31,6,31,81,31,163,31,138,31,97,31,97,30,66,31,194,31,194,30,102,31,81,31,243,31,243,30,45,31,69,31,108,31,133,31,70,31,70,30,18,31,39,31,39,30,205,31,164,31,164,30,180,31,180,30,146,31,169,31,20,31,145,31,145,30,40,31,223,31,41,31,41,30,219,31,219,30,191,31,153,31,163,31,163,30,216,31,206,31,218,31,35,31,72,31,123,31,244,31,174,31,249,31,246,31,246,30,50,31,202,31,234,31,150,31,251,31,247,31,170,31,4,31,254,31,73,31,192,31,173,31,136,31,78,31,139,31,46,31,46,30,163,31,163,30,163,29,9,31,183,31,183,30,96,31,78,31,196,31,44,31,217,31,104,31,196,31,39,31,129,31,21,31,214,31,119,31,86,31,169,31,46,31,155,31,118,31,242,31,17,31,250,31,111,31,245,31,210,31,10,31,10,30,171,31,142,31,122,31,114,31,114,30,208,31,168,31,100,31,4,31,79,31,148,31,47,31,77,31,26,31,62,31,62,30,55,31,96,31,149,31,3,31,3,30,179,31,179,30,139,31,222,31,43,31,237,31,49,31,38,31,93,31,8,31,255,31,255,30,12,31,98,31,251,31,245,31,29,31,36,31,16,31,16,30,37,31,37,30,88,31,245,31,245,30,181,31,245,31,245,30,139,31,125,31,52,31,156,31,230,31,18,31,192,31,115,31,29,31,153,31,160,31,3,31,63,31,63,30,235,31,24,31,123,31,242,31,128,31,4,31,179,31,179,30,179,29,171,31,44,31,53,31,203,31,203,30,193,31,138,31,66,31,250,31,136,31,201,31,123,31,136,31,136,30,243,31,176,31,134,31,134,30,23,31,141,31,13,31,93,31,115,31,200,31,62,31,164,31,157,31,127,31,127,30,127,29,127,28,230,31,198,31,167,31,186,31,186,30,186,29,60,31,146,31,239,31,100,31,72,31,7,31,17,31,17,30,145,31,150,31,179,31,63,31,227,31,6,31,248,31,157,31,121,31,41,31,2,31,2,30,38,31,202,31,202,30,141,31,246,31,93,31,53,31,167,31,161,31,123,31,67,31,102,31,207,31,50,31,245,31,57,31,207,31,79,31,92,31,225,31,225,30,247,31,62,31,39,31,186,31,141,31,203,31,203,30,203,29,223,31,237,31,97,31,63,31,66,31,168,31,59,31,59,30,111,31,111,30,106,31,227,31,208,31,29,31,24,31,36,31,17,31,193,31,193,30,180,31,196,31,69,31,69,30,193,31,228,31,66,31,32,31,126,31,179,31,210,31);

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
