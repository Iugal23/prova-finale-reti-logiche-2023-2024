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

constant SCENARIO_LENGTH : integer := 1019;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (33,0,0,0,83,0,0,0,177,0,95,0,174,0,167,0,255,0,0,0,10,0,0,0,70,0,147,0,139,0,238,0,111,0,0,0,196,0,227,0,30,0,144,0,32,0,0,0,0,0,109,0,214,0,2,0,105,0,158,0,155,0,1,0,204,0,132,0,202,0,3,0,77,0,248,0,0,0,105,0,0,0,201,0,65,0,249,0,88,0,163,0,0,0,90,0,62,0,101,0,20,0,229,0,0,0,0,0,50,0,50,0,230,0,141,0,145,0,41,0,29,0,0,0,36,0,41,0,251,0,67,0,0,0,0,0,195,0,165,0,95,0,162,0,77,0,216,0,0,0,0,0,161,0,0,0,122,0,210,0,53,0,34,0,26,0,0,0,177,0,0,0,101,0,55,0,0,0,126,0,93,0,13,0,229,0,88,0,95,0,93,0,75,0,161,0,0,0,82,0,197,0,22,0,52,0,53,0,83,0,86,0,18,0,240,0,91,0,103,0,32,0,136,0,51,0,213,0,236,0,44,0,93,0,237,0,237,0,118,0,6,0,234,0,235,0,52,0,59,0,0,0,118,0,141,0,71,0,254,0,0,0,243,0,218,0,0,0,211,0,25,0,251,0,0,0,115,0,0,0,153,0,7,0,117,0,40,0,182,0,0,0,31,0,48,0,204,0,45,0,215,0,28,0,34,0,103,0,110,0,235,0,167,0,189,0,0,0,0,0,64,0,225,0,21,0,0,0,235,0,230,0,172,0,151,0,145,0,0,0,0,0,0,0,0,0,239,0,43,0,7,0,51,0,232,0,234,0,25,0,155,0,231,0,0,0,5,0,94,0,200,0,7,0,0,0,0,0,167,0,235,0,254,0,127,0,37,0,69,0,200,0,119,0,187,0,104,0,194,0,110,0,37,0,119,0,100,0,235,0,138,0,52,0,198,0,213,0,178,0,0,0,28,0,81,0,26,0,103,0,21,0,222,0,234,0,30,0,252,0,219,0,122,0,2,0,0,0,58,0,61,0,122,0,49,0,10,0,52,0,92,0,99,0,88,0,0,0,78,0,39,0,0,0,155,0,0,0,117,0,226,0,158,0,137,0,89,0,65,0,5,0,24,0,112,0,192,0,85,0,109,0,0,0,0,0,29,0,0,0,107,0,0,0,116,0,217,0,40,0,217,0,170,0,236,0,66,0,0,0,168,0,86,0,122,0,158,0,169,0,0,0,162,0,232,0,0,0,165,0,205,0,35,0,21,0,124,0,118,0,79,0,113,0,144,0,195,0,24,0,252,0,0,0,131,0,63,0,205,0,0,0,67,0,248,0,249,0,195,0,57,0,69,0,181,0,88,0,227,0,48,0,211,0,198,0,0,0,194,0,84,0,0,0,94,0,216,0,224,0,253,0,209,0,38,0,210,0,122,0,93,0,196,0,121,0,105,0,112,0,58,0,29,0,237,0,0,0,207,0,216,0,139,0,113,0,17,0,0,0,103,0,126,0,113,0,174,0,0,0,196,0,67,0,82,0,122,0,113,0,0,0,0,0,148,0,7,0,68,0,0,0,92,0,0,0,70,0,31,0,198,0,143,0,0,0,0,0,7,0,77,0,171,0,0,0,230,0,3,0,0,0,33,0,187,0,0,0,177,0,200,0,69,0,158,0,198,0,29,0,97,0,132,0,43,0,44,0,127,0,99,0,197,0,80,0,181,0,164,0,129,0,0,0,231,0,198,0,0,0,0,0,45,0,249,0,26,0,16,0,0,0,138,0,51,0,0,0,0,0,48,0,68,0,58,0,172,0,221,0,253,0,200,0,106,0,113,0,105,0,34,0,141,0,210,0,215,0,113,0,26,0,78,0,136,0,0,0,113,0,0,0,103,0,77,0,123,0,181,0,148,0,68,0,227,0,28,0,82,0,158,0,250,0,82,0,0,0,216,0,176,0,0,0,104,0,208,0,106,0,206,0,254,0,48,0,118,0,63,0,0,0,103,0,18,0,2,0,179,0,0,0,0,0,232,0,161,0,98,0,137,0,16,0,224,0,6,0,52,0,166,0,40,0,5,0,12,0,60,0,73,0,99,0,83,0,241,0,106,0,0,0,54,0,131,0,17,0,58,0,18,0,30,0,188,0,60,0,243,0,0,0,0,0,236,0,52,0,0,0,156,0,168,0,222,0,195,0,201,0,221,0,168,0,40,0,97,0,0,0,189,0,98,0,106,0,107,0,235,0,159,0,0,0,204,0,22,0,1,0,214,0,135,0,90,0,72,0,146,0,101,0,204,0,146,0,185,0,218,0,0,0,82,0,151,0,0,0,105,0,188,0,0,0,11,0,125,0,234,0,164,0,10,0,130,0,183,0,246,0,22,0,0,0,0,0,0,0,74,0,122,0,86,0,47,0,249,0,194,0,227,0,0,0,88,0,216,0,18,0,49,0,24,0,84,0,0,0,169,0,0,0,220,0,101,0,202,0,233,0,223,0,216,0,0,0,68,0,255,0,0,0,90,0,68,0,0,0,124,0,117,0,0,0,220,0,24,0,224,0,0,0,0,0,0,0,113,0,25,0,11,0,78,0,65,0,114,0,203,0,18,0,197,0,75,0,213,0,12,0,150,0,0,0,213,0,26,0,18,0,0,0,143,0,104,0,109,0,201,0,216,0,79,0,0,0,0,0,26,0,197,0,55,0,159,0,170,0,156,0,207,0,198,0,20,0,11,0,82,0,0,0,93,0,0,0,237,0,0,0,101,0,20,0,0,0,0,0,0,0,84,0,189,0,147,0,86,0,236,0,6,0,164,0,213,0,78,0,128,0,173,0,207,0,62,0,81,0,98,0,0,0,167,0,28,0,131,0,0,0,0,0,201,0,86,0,84,0,85,0,182,0,0,0,40,0,175,0,247,0,227,0,202,0,0,0,180,0,195,0,204,0,95,0,0,0,10,0,216,0,208,0,57,0,251,0,240,0,119,0,189,0,0,0,151,0,104,0,169,0,87,0,0,0,70,0,25,0,0,0,0,0,74,0,243,0,200,0,1,0,81,0,174,0,108,0,0,0,207,0,156,0,93,0,0,0,0,0,11,0,0,0,14,0,97,0,13,0,0,0,0,0,0,0,0,0,26,0,212,0,193,0,10,0,157,0,181,0,129,0,174,0,208,0,85,0,49,0,53,0,0,0,0,0,219,0,253,0,0,0,0,0,211,0,182,0,99,0,31,0,0,0,122,0,150,0,51,0,71,0,73,0,0,0,238,0,0,0,218,0,200,0,49,0,239,0,179,0,0,0,91,0,0,0,15,0,0,0,91,0,19,0,140,0,49,0,110,0,186,0,129,0,0,0,15,0,154,0,139,0,229,0,47,0,68,0,212,0,220,0,101,0,0,0,162,0,0,0,163,0,130,0,0,0,80,0,0,0,157,0,73,0,225,0,151,0,175,0,0,0,92,0,173,0,193,0,66,0,170,0,0,0,135,0,147,0,53,0,147,0,0,0,51,0,165,0,32,0,213,0,187,0,155,0,80,0,207,0,254,0,218,0,154,0,236,0,0,0,214,0,56,0,0,0,0,0,25,0,140,0,65,0,132,0,22,0,150,0,221,0,0,0,88,0,113,0,0,0,243,0,180,0,76,0,0,0,237,0,158,0,66,0,157,0,165,0,69,0,50,0,0,0,196,0,183,0,0,0,51,0,179,0,68,0,145,0,143,0,0,0,0,0,204,0,250,0,169,0,222,0,78,0,29,0,118,0,0,0,0,0,248,0,37,0,0,0,0,0,176,0,52,0,119,0,0,0,87,0,246,0,230,0,195,0,122,0,0,0,143,0,122,0,0,0,64,0,112,0,9,0,113,0,163,0,128,0,0,0,249,0,137,0,246,0,186,0,195,0,141,0,231,0,208,0,181,0,127,0,108,0,0,0,248,0,164,0,0,0,118,0,56,0,0,0,237,0,0,0,28,0,85,0,199,0,90,0,150,0,94,0,0,0,0,0,48,0,16,0,196,0,158,0,255,0,194,0,217,0,43,0,0,0,56,0,66,0,83,0,23,0,233,0,69,0,0,0,3,0,112,0,178,0,0,0,182,0,8,0,0,0,37,0,168,0,229,0,205,0,252,0,40,0,129,0,141,0,0,0,0,0,144,0,187,0,188,0,0,0,109,0,0,0,148,0,40,0,62,0,112,0,195,0,159,0,0,0,121,0,90,0,0,0,165,0,35,0,123,0,84,0,70,0,0,0,73,0,0,0,0,0,183,0,247,0,158,0,14,0,0,0,186,0,247,0,220,0,149,0,212,0,194,0,61,0,51,0,33,0,190,0,63,0,125,0,0,0,175,0,53,0,0,0,234,0,192,0,241,0,144,0,37,0,209,0,147,0,26,0,0,0,0,0,145,0,66,0,237,0,232,0,236,0,93,0,225,0,172,0,172,0,0,0,222,0,94,0,233,0,19,0,146,0,70,0,0,0,155,0,116,0,64,0,73,0,72,0,205,0,173,0,94,0,166,0,211,0,0,0,11,0,27,0,74,0,0,0,12,0,68,0,174,0,146,0,0,0,0,0,15,0,188,0,193,0,0,0,4,0);
signal scenario_full  : scenario_type := (33,31,33,30,83,31,83,30,177,31,95,31,174,31,167,31,255,31,255,30,10,31,10,30,70,31,147,31,139,31,238,31,111,31,111,30,196,31,227,31,30,31,144,31,32,31,32,30,32,29,109,31,214,31,2,31,105,31,158,31,155,31,1,31,204,31,132,31,202,31,3,31,77,31,248,31,248,30,105,31,105,30,201,31,65,31,249,31,88,31,163,31,163,30,90,31,62,31,101,31,20,31,229,31,229,30,229,29,50,31,50,31,230,31,141,31,145,31,41,31,29,31,29,30,36,31,41,31,251,31,67,31,67,30,67,29,195,31,165,31,95,31,162,31,77,31,216,31,216,30,216,29,161,31,161,30,122,31,210,31,53,31,34,31,26,31,26,30,177,31,177,30,101,31,55,31,55,30,126,31,93,31,13,31,229,31,88,31,95,31,93,31,75,31,161,31,161,30,82,31,197,31,22,31,52,31,53,31,83,31,86,31,18,31,240,31,91,31,103,31,32,31,136,31,51,31,213,31,236,31,44,31,93,31,237,31,237,31,118,31,6,31,234,31,235,31,52,31,59,31,59,30,118,31,141,31,71,31,254,31,254,30,243,31,218,31,218,30,211,31,25,31,251,31,251,30,115,31,115,30,153,31,7,31,117,31,40,31,182,31,182,30,31,31,48,31,204,31,45,31,215,31,28,31,34,31,103,31,110,31,235,31,167,31,189,31,189,30,189,29,64,31,225,31,21,31,21,30,235,31,230,31,172,31,151,31,145,31,145,30,145,29,145,28,145,27,239,31,43,31,7,31,51,31,232,31,234,31,25,31,155,31,231,31,231,30,5,31,94,31,200,31,7,31,7,30,7,29,167,31,235,31,254,31,127,31,37,31,69,31,200,31,119,31,187,31,104,31,194,31,110,31,37,31,119,31,100,31,235,31,138,31,52,31,198,31,213,31,178,31,178,30,28,31,81,31,26,31,103,31,21,31,222,31,234,31,30,31,252,31,219,31,122,31,2,31,2,30,58,31,61,31,122,31,49,31,10,31,52,31,92,31,99,31,88,31,88,30,78,31,39,31,39,30,155,31,155,30,117,31,226,31,158,31,137,31,89,31,65,31,5,31,24,31,112,31,192,31,85,31,109,31,109,30,109,29,29,31,29,30,107,31,107,30,116,31,217,31,40,31,217,31,170,31,236,31,66,31,66,30,168,31,86,31,122,31,158,31,169,31,169,30,162,31,232,31,232,30,165,31,205,31,35,31,21,31,124,31,118,31,79,31,113,31,144,31,195,31,24,31,252,31,252,30,131,31,63,31,205,31,205,30,67,31,248,31,249,31,195,31,57,31,69,31,181,31,88,31,227,31,48,31,211,31,198,31,198,30,194,31,84,31,84,30,94,31,216,31,224,31,253,31,209,31,38,31,210,31,122,31,93,31,196,31,121,31,105,31,112,31,58,31,29,31,237,31,237,30,207,31,216,31,139,31,113,31,17,31,17,30,103,31,126,31,113,31,174,31,174,30,196,31,67,31,82,31,122,31,113,31,113,30,113,29,148,31,7,31,68,31,68,30,92,31,92,30,70,31,31,31,198,31,143,31,143,30,143,29,7,31,77,31,171,31,171,30,230,31,3,31,3,30,33,31,187,31,187,30,177,31,200,31,69,31,158,31,198,31,29,31,97,31,132,31,43,31,44,31,127,31,99,31,197,31,80,31,181,31,164,31,129,31,129,30,231,31,198,31,198,30,198,29,45,31,249,31,26,31,16,31,16,30,138,31,51,31,51,30,51,29,48,31,68,31,58,31,172,31,221,31,253,31,200,31,106,31,113,31,105,31,34,31,141,31,210,31,215,31,113,31,26,31,78,31,136,31,136,30,113,31,113,30,103,31,77,31,123,31,181,31,148,31,68,31,227,31,28,31,82,31,158,31,250,31,82,31,82,30,216,31,176,31,176,30,104,31,208,31,106,31,206,31,254,31,48,31,118,31,63,31,63,30,103,31,18,31,2,31,179,31,179,30,179,29,232,31,161,31,98,31,137,31,16,31,224,31,6,31,52,31,166,31,40,31,5,31,12,31,60,31,73,31,99,31,83,31,241,31,106,31,106,30,54,31,131,31,17,31,58,31,18,31,30,31,188,31,60,31,243,31,243,30,243,29,236,31,52,31,52,30,156,31,168,31,222,31,195,31,201,31,221,31,168,31,40,31,97,31,97,30,189,31,98,31,106,31,107,31,235,31,159,31,159,30,204,31,22,31,1,31,214,31,135,31,90,31,72,31,146,31,101,31,204,31,146,31,185,31,218,31,218,30,82,31,151,31,151,30,105,31,188,31,188,30,11,31,125,31,234,31,164,31,10,31,130,31,183,31,246,31,22,31,22,30,22,29,22,28,74,31,122,31,86,31,47,31,249,31,194,31,227,31,227,30,88,31,216,31,18,31,49,31,24,31,84,31,84,30,169,31,169,30,220,31,101,31,202,31,233,31,223,31,216,31,216,30,68,31,255,31,255,30,90,31,68,31,68,30,124,31,117,31,117,30,220,31,24,31,224,31,224,30,224,29,224,28,113,31,25,31,11,31,78,31,65,31,114,31,203,31,18,31,197,31,75,31,213,31,12,31,150,31,150,30,213,31,26,31,18,31,18,30,143,31,104,31,109,31,201,31,216,31,79,31,79,30,79,29,26,31,197,31,55,31,159,31,170,31,156,31,207,31,198,31,20,31,11,31,82,31,82,30,93,31,93,30,237,31,237,30,101,31,20,31,20,30,20,29,20,28,84,31,189,31,147,31,86,31,236,31,6,31,164,31,213,31,78,31,128,31,173,31,207,31,62,31,81,31,98,31,98,30,167,31,28,31,131,31,131,30,131,29,201,31,86,31,84,31,85,31,182,31,182,30,40,31,175,31,247,31,227,31,202,31,202,30,180,31,195,31,204,31,95,31,95,30,10,31,216,31,208,31,57,31,251,31,240,31,119,31,189,31,189,30,151,31,104,31,169,31,87,31,87,30,70,31,25,31,25,30,25,29,74,31,243,31,200,31,1,31,81,31,174,31,108,31,108,30,207,31,156,31,93,31,93,30,93,29,11,31,11,30,14,31,97,31,13,31,13,30,13,29,13,28,13,27,26,31,212,31,193,31,10,31,157,31,181,31,129,31,174,31,208,31,85,31,49,31,53,31,53,30,53,29,219,31,253,31,253,30,253,29,211,31,182,31,99,31,31,31,31,30,122,31,150,31,51,31,71,31,73,31,73,30,238,31,238,30,218,31,200,31,49,31,239,31,179,31,179,30,91,31,91,30,15,31,15,30,91,31,19,31,140,31,49,31,110,31,186,31,129,31,129,30,15,31,154,31,139,31,229,31,47,31,68,31,212,31,220,31,101,31,101,30,162,31,162,30,163,31,130,31,130,30,80,31,80,30,157,31,73,31,225,31,151,31,175,31,175,30,92,31,173,31,193,31,66,31,170,31,170,30,135,31,147,31,53,31,147,31,147,30,51,31,165,31,32,31,213,31,187,31,155,31,80,31,207,31,254,31,218,31,154,31,236,31,236,30,214,31,56,31,56,30,56,29,25,31,140,31,65,31,132,31,22,31,150,31,221,31,221,30,88,31,113,31,113,30,243,31,180,31,76,31,76,30,237,31,158,31,66,31,157,31,165,31,69,31,50,31,50,30,196,31,183,31,183,30,51,31,179,31,68,31,145,31,143,31,143,30,143,29,204,31,250,31,169,31,222,31,78,31,29,31,118,31,118,30,118,29,248,31,37,31,37,30,37,29,176,31,52,31,119,31,119,30,87,31,246,31,230,31,195,31,122,31,122,30,143,31,122,31,122,30,64,31,112,31,9,31,113,31,163,31,128,31,128,30,249,31,137,31,246,31,186,31,195,31,141,31,231,31,208,31,181,31,127,31,108,31,108,30,248,31,164,31,164,30,118,31,56,31,56,30,237,31,237,30,28,31,85,31,199,31,90,31,150,31,94,31,94,30,94,29,48,31,16,31,196,31,158,31,255,31,194,31,217,31,43,31,43,30,56,31,66,31,83,31,23,31,233,31,69,31,69,30,3,31,112,31,178,31,178,30,182,31,8,31,8,30,37,31,168,31,229,31,205,31,252,31,40,31,129,31,141,31,141,30,141,29,144,31,187,31,188,31,188,30,109,31,109,30,148,31,40,31,62,31,112,31,195,31,159,31,159,30,121,31,90,31,90,30,165,31,35,31,123,31,84,31,70,31,70,30,73,31,73,30,73,29,183,31,247,31,158,31,14,31,14,30,186,31,247,31,220,31,149,31,212,31,194,31,61,31,51,31,33,31,190,31,63,31,125,31,125,30,175,31,53,31,53,30,234,31,192,31,241,31,144,31,37,31,209,31,147,31,26,31,26,30,26,29,145,31,66,31,237,31,232,31,236,31,93,31,225,31,172,31,172,31,172,30,222,31,94,31,233,31,19,31,146,31,70,31,70,30,155,31,116,31,64,31,73,31,72,31,205,31,173,31,94,31,166,31,211,31,211,30,11,31,27,31,74,31,74,30,12,31,68,31,174,31,146,31,146,30,146,29,15,31,188,31,193,31,193,30,4,31);

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
