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

constant SCENARIO_LENGTH : integer := 1010;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (203,0,48,0,52,0,153,0,0,0,205,0,0,0,0,0,45,0,0,0,34,0,0,0,197,0,0,0,201,0,0,0,238,0,0,0,118,0,0,0,161,0,53,0,233,0,154,0,191,0,0,0,165,0,139,0,0,0,170,0,0,0,155,0,71,0,245,0,0,0,0,0,74,0,248,0,102,0,121,0,0,0,94,0,75,0,64,0,101,0,0,0,93,0,35,0,224,0,214,0,76,0,98,0,173,0,216,0,52,0,221,0,19,0,56,0,158,0,163,0,0,0,35,0,66,0,119,0,4,0,0,0,171,0,165,0,243,0,87,0,65,0,176,0,116,0,51,0,0,0,99,0,221,0,126,0,186,0,69,0,236,0,0,0,218,0,13,0,27,0,165,0,0,0,147,0,249,0,146,0,159,0,233,0,53,0,234,0,155,0,111,0,233,0,192,0,193,0,0,0,230,0,200,0,130,0,156,0,109,0,115,0,106,0,123,0,0,0,88,0,57,0,36,0,85,0,0,0,107,0,168,0,124,0,27,0,233,0,0,0,0,0,205,0,0,0,1,0,171,0,122,0,204,0,70,0,62,0,190,0,0,0,192,0,190,0,248,0,14,0,8,0,230,0,0,0,50,0,72,0,180,0,240,0,239,0,135,0,243,0,11,0,123,0,96,0,115,0,0,0,60,0,91,0,0,0,55,0,47,0,0,0,3,0,131,0,151,0,202,0,52,0,187,0,145,0,0,0,66,0,35,0,193,0,206,0,112,0,194,0,19,0,0,0,239,0,0,0,121,0,0,0,130,0,26,0,16,0,43,0,187,0,223,0,0,0,145,0,40,0,30,0,189,0,236,0,109,0,0,0,5,0,113,0,0,0,192,0,0,0,53,0,206,0,0,0,252,0,59,0,50,0,34,0,95,0,58,0,182,0,43,0,102,0,5,0,220,0,96,0,95,0,48,0,47,0,93,0,26,0,0,0,183,0,228,0,65,0,6,0,22,0,0,0,220,0,190,0,0,0,50,0,0,0,114,0,128,0,0,0,15,0,102,0,0,0,47,0,246,0,0,0,4,0,95,0,65,0,92,0,213,0,219,0,71,0,0,0,95,0,143,0,68,0,47,0,46,0,131,0,244,0,0,0,108,0,0,0,171,0,232,0,25,0,57,0,4,0,168,0,169,0,73,0,99,0,231,0,165,0,0,0,240,0,105,0,220,0,119,0,34,0,124,0,0,0,242,0,55,0,166,0,230,0,43,0,100,0,102,0,5,0,27,0,138,0,46,0,204,0,85,0,0,0,0,0,79,0,11,0,254,0,209,0,13,0,120,0,239,0,133,0,137,0,0,0,217,0,26,0,59,0,169,0,0,0,0,0,66,0,37,0,235,0,121,0,41,0,56,0,79,0,83,0,33,0,214,0,232,0,106,0,84,0,185,0,78,0,162,0,0,0,101,0,89,0,0,0,99,0,114,0,0,0,0,0,0,0,187,0,69,0,109,0,87,0,246,0,0,0,89,0,126,0,218,0,62,0,63,0,15,0,217,0,151,0,137,0,28,0,57,0,20,0,248,0,165,0,253,0,203,0,248,0,0,0,127,0,34,0,0,0,0,0,81,0,97,0,237,0,210,0,83,0,0,0,219,0,0,0,121,0,207,0,182,0,67,0,100,0,0,0,193,0,0,0,72,0,173,0,0,0,198,0,30,0,7,0,23,0,254,0,80,0,99,0,0,0,4,0,98,0,92,0,188,0,0,0,164,0,24,0,0,0,230,0,0,0,172,0,114,0,67,0,0,0,220,0,4,0,50,0,215,0,136,0,105,0,160,0,0,0,174,0,30,0,0,0,51,0,84,0,43,0,143,0,196,0,145,0,124,0,89,0,83,0,65,0,155,0,174,0,230,0,126,0,119,0,6,0,15,0,0,0,110,0,39,0,5,0,0,0,73,0,212,0,92,0,33,0,0,0,124,0,240,0,0,0,59,0,156,0,246,0,127,0,78,0,0,0,132,0,201,0,227,0,219,0,106,0,0,0,221,0,155,0,159,0,46,0,29,0,16,0,90,0,177,0,191,0,28,0,25,0,186,0,29,0,88,0,208,0,52,0,0,0,17,0,234,0,38,0,111,0,13,0,21,0,172,0,0,0,241,0,234,0,0,0,123,0,202,0,254,0,72,0,0,0,21,0,142,0,39,0,120,0,229,0,74,0,152,0,27,0,0,0,75,0,164,0,142,0,32,0,0,0,0,0,64,0,0,0,65,0,27,0,20,0,0,0,2,0,47,0,15,0,2,0,224,0,201,0,0,0,0,0,0,0,0,0,0,0,68,0,35,0,185,0,170,0,122,0,255,0,41,0,52,0,0,0,130,0,77,0,0,0,0,0,204,0,90,0,73,0,86,0,112,0,97,0,6,0,0,0,3,0,0,0,54,0,91,0,198,0,121,0,6,0,171,0,28,0,73,0,205,0,0,0,0,0,56,0,112,0,6,0,146,0,239,0,192,0,101,0,239,0,27,0,239,0,0,0,0,0,0,0,24,0,70,0,114,0,0,0,0,0,0,0,0,0,131,0,0,0,226,0,139,0,59,0,51,0,122,0,79,0,68,0,244,0,253,0,59,0,207,0,235,0,43,0,205,0,49,0,106,0,167,0,228,0,26,0,84,0,125,0,0,0,118,0,215,0,79,0,137,0,89,0,99,0,0,0,217,0,215,0,182,0,0,0,0,0,245,0,56,0,156,0,27,0,162,0,0,0,0,0,237,0,245,0,31,0,97,0,105,0,0,0,206,0,35,0,12,0,11,0,103,0,159,0,223,0,182,0,146,0,0,0,0,0,171,0,23,0,0,0,0,0,117,0,211,0,222,0,129,0,0,0,5,0,196,0,155,0,79,0,95,0,0,0,213,0,232,0,0,0,0,0,189,0,32,0,0,0,103,0,126,0,185,0,0,0,185,0,0,0,72,0,99,0,64,0,186,0,150,0,0,0,0,0,163,0,119,0,0,0,119,0,13,0,0,0,120,0,0,0,217,0,40,0,223,0,64,0,218,0,102,0,0,0,128,0,92,0,154,0,230,0,11,0,0,0,87,0,92,0,33,0,0,0,7,0,0,0,205,0,42,0,74,0,231,0,130,0,0,0,198,0,164,0,61,0,157,0,0,0,27,0,0,0,27,0,77,0,255,0,0,0,0,0,93,0,180,0,235,0,36,0,132,0,203,0,0,0,23,0,185,0,0,0,231,0,61,0,151,0,35,0,204,0,206,0,214,0,0,0,214,0,200,0,0,0,59,0,114,0,1,0,254,0,137,0,0,0,0,0,0,0,0,0,33,0,15,0,78,0,23,0,0,0,29,0,224,0,75,0,106,0,124,0,124,0,83,0,241,0,159,0,246,0,231,0,3,0,87,0,0,0,187,0,1,0,143,0,179,0,219,0,188,0,185,0,102,0,182,0,130,0,5,0,88,0,0,0,209,0,113,0,10,0,203,0,131,0,199,0,53,0,0,0,0,0,94,0,130,0,0,0,46,0,0,0,117,0,66,0,227,0,197,0,0,0,61,0,154,0,117,0,0,0,101,0,212,0,101,0,200,0,126,0,105,0,190,0,0,0,155,0,0,0,110,0,139,0,65,0,96,0,0,0,158,0,0,0,180,0,209,0,68,0,40,0,0,0,0,0,6,0,78,0,16,0,169,0,0,0,95,0,239,0,120,0,95,0,159,0,0,0,193,0,0,0,225,0,13,0,63,0,123,0,107,0,143,0,133,0,189,0,128,0,0,0,141,0,57,0,133,0,164,0,93,0,149,0,84,0,213,0,126,0,252,0,0,0,82,0,49,0,253,0,133,0,65,0,0,0,221,0,0,0,213,0,202,0,32,0,0,0,0,0,219,0,202,0,6,0,69,0,34,0,133,0,0,0,67,0,233,0,181,0,197,0,146,0,137,0,97,0,243,0,212,0,91,0,0,0,15,0,208,0,0,0,0,0,111,0,0,0,0,0,96,0,216,0,79,0,28,0,187,0,52,0,92,0,177,0,52,0,187,0,119,0,213,0,54,0,183,0,205,0,0,0,43,0,227,0,0,0,183,0,1,0,2,0,180,0,212,0,150,0,80,0,108,0,195,0,48,0,0,0,182,0,181,0,230,0,0,0,127,0,135,0,22,0,185,0,102,0,0,0,0,0,86,0,0,0,9,0,166,0,102,0,177,0,1,0,249,0,159,0,254,0,157,0,109,0,152,0,124,0,230,0,145,0,44,0,52,0,67,0,187,0,176,0,253,0,233,0,210,0,2,0,24,0,0,0,0,0,103,0,0,0,96,0,0,0,212,0,85,0,144,0,136,0,154,0,164,0,154,0,249,0,35,0,14,0,106,0,248,0,130,0,47,0,86,0,62,0,37,0,59,0,239,0,188,0,56,0,143,0,247,0,84,0,214,0,161,0,30,0,8,0,0,0,86,0,212,0,52,0,24,0,182,0,7,0,83,0,0,0,0,0,187,0,0,0,27,0,77,0,0,0,21,0,0,0,123,0,197,0);
signal scenario_full  : scenario_type := (203,31,48,31,52,31,153,31,153,30,205,31,205,30,205,29,45,31,45,30,34,31,34,30,197,31,197,30,201,31,201,30,238,31,238,30,118,31,118,30,161,31,53,31,233,31,154,31,191,31,191,30,165,31,139,31,139,30,170,31,170,30,155,31,71,31,245,31,245,30,245,29,74,31,248,31,102,31,121,31,121,30,94,31,75,31,64,31,101,31,101,30,93,31,35,31,224,31,214,31,76,31,98,31,173,31,216,31,52,31,221,31,19,31,56,31,158,31,163,31,163,30,35,31,66,31,119,31,4,31,4,30,171,31,165,31,243,31,87,31,65,31,176,31,116,31,51,31,51,30,99,31,221,31,126,31,186,31,69,31,236,31,236,30,218,31,13,31,27,31,165,31,165,30,147,31,249,31,146,31,159,31,233,31,53,31,234,31,155,31,111,31,233,31,192,31,193,31,193,30,230,31,200,31,130,31,156,31,109,31,115,31,106,31,123,31,123,30,88,31,57,31,36,31,85,31,85,30,107,31,168,31,124,31,27,31,233,31,233,30,233,29,205,31,205,30,1,31,171,31,122,31,204,31,70,31,62,31,190,31,190,30,192,31,190,31,248,31,14,31,8,31,230,31,230,30,50,31,72,31,180,31,240,31,239,31,135,31,243,31,11,31,123,31,96,31,115,31,115,30,60,31,91,31,91,30,55,31,47,31,47,30,3,31,131,31,151,31,202,31,52,31,187,31,145,31,145,30,66,31,35,31,193,31,206,31,112,31,194,31,19,31,19,30,239,31,239,30,121,31,121,30,130,31,26,31,16,31,43,31,187,31,223,31,223,30,145,31,40,31,30,31,189,31,236,31,109,31,109,30,5,31,113,31,113,30,192,31,192,30,53,31,206,31,206,30,252,31,59,31,50,31,34,31,95,31,58,31,182,31,43,31,102,31,5,31,220,31,96,31,95,31,48,31,47,31,93,31,26,31,26,30,183,31,228,31,65,31,6,31,22,31,22,30,220,31,190,31,190,30,50,31,50,30,114,31,128,31,128,30,15,31,102,31,102,30,47,31,246,31,246,30,4,31,95,31,65,31,92,31,213,31,219,31,71,31,71,30,95,31,143,31,68,31,47,31,46,31,131,31,244,31,244,30,108,31,108,30,171,31,232,31,25,31,57,31,4,31,168,31,169,31,73,31,99,31,231,31,165,31,165,30,240,31,105,31,220,31,119,31,34,31,124,31,124,30,242,31,55,31,166,31,230,31,43,31,100,31,102,31,5,31,27,31,138,31,46,31,204,31,85,31,85,30,85,29,79,31,11,31,254,31,209,31,13,31,120,31,239,31,133,31,137,31,137,30,217,31,26,31,59,31,169,31,169,30,169,29,66,31,37,31,235,31,121,31,41,31,56,31,79,31,83,31,33,31,214,31,232,31,106,31,84,31,185,31,78,31,162,31,162,30,101,31,89,31,89,30,99,31,114,31,114,30,114,29,114,28,187,31,69,31,109,31,87,31,246,31,246,30,89,31,126,31,218,31,62,31,63,31,15,31,217,31,151,31,137,31,28,31,57,31,20,31,248,31,165,31,253,31,203,31,248,31,248,30,127,31,34,31,34,30,34,29,81,31,97,31,237,31,210,31,83,31,83,30,219,31,219,30,121,31,207,31,182,31,67,31,100,31,100,30,193,31,193,30,72,31,173,31,173,30,198,31,30,31,7,31,23,31,254,31,80,31,99,31,99,30,4,31,98,31,92,31,188,31,188,30,164,31,24,31,24,30,230,31,230,30,172,31,114,31,67,31,67,30,220,31,4,31,50,31,215,31,136,31,105,31,160,31,160,30,174,31,30,31,30,30,51,31,84,31,43,31,143,31,196,31,145,31,124,31,89,31,83,31,65,31,155,31,174,31,230,31,126,31,119,31,6,31,15,31,15,30,110,31,39,31,5,31,5,30,73,31,212,31,92,31,33,31,33,30,124,31,240,31,240,30,59,31,156,31,246,31,127,31,78,31,78,30,132,31,201,31,227,31,219,31,106,31,106,30,221,31,155,31,159,31,46,31,29,31,16,31,90,31,177,31,191,31,28,31,25,31,186,31,29,31,88,31,208,31,52,31,52,30,17,31,234,31,38,31,111,31,13,31,21,31,172,31,172,30,241,31,234,31,234,30,123,31,202,31,254,31,72,31,72,30,21,31,142,31,39,31,120,31,229,31,74,31,152,31,27,31,27,30,75,31,164,31,142,31,32,31,32,30,32,29,64,31,64,30,65,31,27,31,20,31,20,30,2,31,47,31,15,31,2,31,224,31,201,31,201,30,201,29,201,28,201,27,201,26,68,31,35,31,185,31,170,31,122,31,255,31,41,31,52,31,52,30,130,31,77,31,77,30,77,29,204,31,90,31,73,31,86,31,112,31,97,31,6,31,6,30,3,31,3,30,54,31,91,31,198,31,121,31,6,31,171,31,28,31,73,31,205,31,205,30,205,29,56,31,112,31,6,31,146,31,239,31,192,31,101,31,239,31,27,31,239,31,239,30,239,29,239,28,24,31,70,31,114,31,114,30,114,29,114,28,114,27,131,31,131,30,226,31,139,31,59,31,51,31,122,31,79,31,68,31,244,31,253,31,59,31,207,31,235,31,43,31,205,31,49,31,106,31,167,31,228,31,26,31,84,31,125,31,125,30,118,31,215,31,79,31,137,31,89,31,99,31,99,30,217,31,215,31,182,31,182,30,182,29,245,31,56,31,156,31,27,31,162,31,162,30,162,29,237,31,245,31,31,31,97,31,105,31,105,30,206,31,35,31,12,31,11,31,103,31,159,31,223,31,182,31,146,31,146,30,146,29,171,31,23,31,23,30,23,29,117,31,211,31,222,31,129,31,129,30,5,31,196,31,155,31,79,31,95,31,95,30,213,31,232,31,232,30,232,29,189,31,32,31,32,30,103,31,126,31,185,31,185,30,185,31,185,30,72,31,99,31,64,31,186,31,150,31,150,30,150,29,163,31,119,31,119,30,119,31,13,31,13,30,120,31,120,30,217,31,40,31,223,31,64,31,218,31,102,31,102,30,128,31,92,31,154,31,230,31,11,31,11,30,87,31,92,31,33,31,33,30,7,31,7,30,205,31,42,31,74,31,231,31,130,31,130,30,198,31,164,31,61,31,157,31,157,30,27,31,27,30,27,31,77,31,255,31,255,30,255,29,93,31,180,31,235,31,36,31,132,31,203,31,203,30,23,31,185,31,185,30,231,31,61,31,151,31,35,31,204,31,206,31,214,31,214,30,214,31,200,31,200,30,59,31,114,31,1,31,254,31,137,31,137,30,137,29,137,28,137,27,33,31,15,31,78,31,23,31,23,30,29,31,224,31,75,31,106,31,124,31,124,31,83,31,241,31,159,31,246,31,231,31,3,31,87,31,87,30,187,31,1,31,143,31,179,31,219,31,188,31,185,31,102,31,182,31,130,31,5,31,88,31,88,30,209,31,113,31,10,31,203,31,131,31,199,31,53,31,53,30,53,29,94,31,130,31,130,30,46,31,46,30,117,31,66,31,227,31,197,31,197,30,61,31,154,31,117,31,117,30,101,31,212,31,101,31,200,31,126,31,105,31,190,31,190,30,155,31,155,30,110,31,139,31,65,31,96,31,96,30,158,31,158,30,180,31,209,31,68,31,40,31,40,30,40,29,6,31,78,31,16,31,169,31,169,30,95,31,239,31,120,31,95,31,159,31,159,30,193,31,193,30,225,31,13,31,63,31,123,31,107,31,143,31,133,31,189,31,128,31,128,30,141,31,57,31,133,31,164,31,93,31,149,31,84,31,213,31,126,31,252,31,252,30,82,31,49,31,253,31,133,31,65,31,65,30,221,31,221,30,213,31,202,31,32,31,32,30,32,29,219,31,202,31,6,31,69,31,34,31,133,31,133,30,67,31,233,31,181,31,197,31,146,31,137,31,97,31,243,31,212,31,91,31,91,30,15,31,208,31,208,30,208,29,111,31,111,30,111,29,96,31,216,31,79,31,28,31,187,31,52,31,92,31,177,31,52,31,187,31,119,31,213,31,54,31,183,31,205,31,205,30,43,31,227,31,227,30,183,31,1,31,2,31,180,31,212,31,150,31,80,31,108,31,195,31,48,31,48,30,182,31,181,31,230,31,230,30,127,31,135,31,22,31,185,31,102,31,102,30,102,29,86,31,86,30,9,31,166,31,102,31,177,31,1,31,249,31,159,31,254,31,157,31,109,31,152,31,124,31,230,31,145,31,44,31,52,31,67,31,187,31,176,31,253,31,233,31,210,31,2,31,24,31,24,30,24,29,103,31,103,30,96,31,96,30,212,31,85,31,144,31,136,31,154,31,164,31,154,31,249,31,35,31,14,31,106,31,248,31,130,31,47,31,86,31,62,31,37,31,59,31,239,31,188,31,56,31,143,31,247,31,84,31,214,31,161,31,30,31,8,31,8,30,86,31,212,31,52,31,24,31,182,31,7,31,83,31,83,30,83,29,187,31,187,30,27,31,77,31,77,30,21,31,21,30,123,31,197,31);

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
