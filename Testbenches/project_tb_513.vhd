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

constant SCENARIO_LENGTH : integer := 983;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (178,0,49,0,58,0,92,0,0,0,139,0,8,0,135,0,233,0,133,0,17,0,0,0,0,0,42,0,176,0,40,0,62,0,51,0,107,0,12,0,43,0,83,0,76,0,18,0,251,0,71,0,173,0,155,0,154,0,0,0,152,0,255,0,0,0,110,0,221,0,56,0,28,0,65,0,0,0,210,0,210,0,0,0,0,0,186,0,19,0,37,0,216,0,148,0,0,0,191,0,176,0,152,0,131,0,32,0,192,0,0,0,94,0,241,0,57,0,88,0,129,0,0,0,28,0,65,0,131,0,145,0,254,0,135,0,0,0,66,0,69,0,196,0,186,0,0,0,0,0,133,0,43,0,0,0,216,0,138,0,140,0,60,0,204,0,65,0,81,0,201,0,107,0,24,0,0,0,103,0,125,0,123,0,41,0,0,0,0,0,205,0,36,0,168,0,31,0,219,0,36,0,131,0,125,0,49,0,249,0,175,0,65,0,229,0,64,0,255,0,169,0,123,0,254,0,0,0,182,0,148,0,168,0,105,0,69,0,84,0,39,0,48,0,187,0,96,0,152,0,147,0,7,0,28,0,93,0,202,0,142,0,83,0,0,0,144,0,177,0,171,0,0,0,0,0,20,0,0,0,159,0,224,0,138,0,167,0,0,0,103,0,186,0,116,0,108,0,145,0,30,0,204,0,0,0,242,0,0,0,96,0,57,0,0,0,0,0,0,0,139,0,74,0,165,0,43,0,187,0,111,0,211,0,173,0,0,0,0,0,84,0,220,0,123,0,45,0,237,0,0,0,177,0,0,0,233,0,77,0,0,0,0,0,242,0,0,0,133,0,109,0,227,0,121,0,63,0,121,0,0,0,203,0,39,0,12,0,68,0,0,0,252,0,0,0,116,0,196,0,83,0,99,0,215,0,203,0,69,0,0,0,4,0,0,0,38,0,98,0,30,0,150,0,126,0,246,0,0,0,191,0,0,0,170,0,173,0,0,0,56,0,185,0,173,0,0,0,169,0,39,0,0,0,56,0,0,0,50,0,96,0,85,0,48,0,0,0,149,0,99,0,103,0,43,0,135,0,71,0,96,0,0,0,0,0,0,0,102,0,0,0,72,0,90,0,185,0,0,0,207,0,18,0,118,0,0,0,0,0,0,0,212,0,189,0,194,0,190,0,0,0,46,0,222,0,118,0,170,0,73,0,18,0,3,0,0,0,150,0,204,0,245,0,94,0,50,0,164,0,0,0,0,0,0,0,243,0,0,0,21,0,10,0,0,0,92,0,91,0,0,0,226,0,0,0,0,0,78,0,243,0,0,0,197,0,212,0,30,0,165,0,120,0,154,0,189,0,11,0,194,0,179,0,122,0,27,0,50,0,65,0,74,0,104,0,0,0,139,0,0,0,239,0,42,0,22,0,105,0,0,0,0,0,135,0,6,0,0,0,163,0,27,0,220,0,43,0,0,0,168,0,41,0,0,0,242,0,37,0,92,0,24,0,64,0,203,0,187,0,170,0,0,0,229,0,176,0,0,0,142,0,144,0,205,0,29,0,214,0,0,0,169,0,179,0,0,0,114,0,0,0,0,0,244,0,53,0,104,0,90,0,212,0,107,0,39,0,1,0,64,0,172,0,0,0,182,0,17,0,75,0,0,0,240,0,58,0,25,0,124,0,79,0,107,0,33,0,156,0,102,0,175,0,0,0,103,0,76,0,0,0,120,0,168,0,91,0,0,0,56,0,96,0,229,0,142,0,214,0,100,0,24,0,40,0,139,0,192,0,47,0,165,0,192,0,63,0,0,0,217,0,182,0,190,0,137,0,164,0,76,0,0,0,101,0,0,0,180,0,0,0,215,0,239,0,13,0,77,0,255,0,231,0,205,0,208,0,156,0,107,0,74,0,0,0,0,0,182,0,59,0,0,0,84,0,148,0,66,0,108,0,137,0,184,0,87,0,185,0,139,0,252,0,229,0,73,0,0,0,72,0,57,0,39,0,139,0,46,0,254,0,119,0,237,0,194,0,51,0,93,0,180,0,19,0,107,0,194,0,0,0,236,0,25,0,54,0,247,0,0,0,9,0,1,0,230,0,98,0,237,0,88,0,86,0,0,0,234,0,190,0,172,0,216,0,0,0,244,0,46,0,0,0,136,0,0,0,113,0,188,0,0,0,195,0,0,0,200,0,113,0,213,0,240,0,72,0,174,0,100,0,11,0,69,0,245,0,189,0,0,0,157,0,121,0,1,0,52,0,183,0,207,0,0,0,240,0,196,0,1,0,214,0,35,0,37,0,247,0,0,0,59,0,0,0,224,0,168,0,249,0,158,0,194,0,21,0,129,0,0,0,2,0,90,0,171,0,0,0,218,0,180,0,0,0,0,0,0,0,65,0,48,0,0,0,231,0,102,0,51,0,164,0,0,0,72,0,9,0,232,0,39,0,99,0,0,0,0,0,189,0,54,0,97,0,141,0,44,0,0,0,114,0,124,0,97,0,126,0,0,0,129,0,113,0,0,0,136,0,0,0,23,0,0,0,41,0,0,0,194,0,62,0,19,0,0,0,0,0,124,0,0,0,38,0,12,0,196,0,165,0,154,0,0,0,149,0,190,0,0,0,79,0,130,0,62,0,54,0,10,0,28,0,79,0,126,0,142,0,55,0,238,0,216,0,158,0,232,0,3,0,98,0,68,0,186,0,0,0,0,0,100,0,199,0,89,0,52,0,212,0,15,0,201,0,230,0,150,0,58,0,242,0,0,0,186,0,147,0,100,0,190,0,183,0,0,0,250,0,167,0,0,0,101,0,182,0,0,0,0,0,89,0,30,0,130,0,186,0,182,0,181,0,62,0,0,0,202,0,82,0,32,0,27,0,145,0,0,0,187,0,22,0,122,0,82,0,170,0,0,0,84,0,0,0,43,0,2,0,100,0,221,0,241,0,122,0,158,0,162,0,35,0,60,0,124,0,232,0,50,0,0,0,0,0,54,0,0,0,18,0,101,0,82,0,89,0,129,0,0,0,192,0,175,0,193,0,117,0,107,0,148,0,0,0,227,0,80,0,192,0,29,0,173,0,222,0,43,0,170,0,134,0,0,0,56,0,11,0,227,0,95,0,186,0,162,0,177,0,220,0,222,0,108,0,177,0,160,0,189,0,157,0,109,0,10,0,62,0,0,0,0,0,233,0,202,0,59,0,146,0,236,0,73,0,0,0,225,0,0,0,184,0,71,0,93,0,220,0,238,0,115,0,29,0,94,0,188,0,22,0,109,0,66,0,170,0,49,0,37,0,168,0,2,0,0,0,136,0,137,0,0,0,152,0,197,0,162,0,80,0,0,0,190,0,203,0,183,0,28,0,216,0,242,0,168,0,104,0,88,0,73,0,33,0,0,0,0,0,34,0,10,0,112,0,90,0,189,0,244,0,210,0,72,0,178,0,208,0,57,0,230,0,211,0,0,0,68,0,233,0,0,0,132,0,176,0,230,0,0,0,141,0,192,0,68,0,14,0,93,0,0,0,0,0,0,0,0,0,229,0,0,0,0,0,86,0,0,0,0,0,251,0,225,0,196,0,82,0,0,0,1,0,83,0,136,0,135,0,185,0,129,0,38,0,98,0,161,0,0,0,166,0,249,0,132,0,186,0,0,0,55,0,243,0,0,0,0,0,0,0,4,0,149,0,15,0,17,0,0,0,18,0,0,0,0,0,102,0,0,0,0,0,118,0,40,0,248,0,183,0,108,0,138,0,0,0,0,0,164,0,51,0,217,0,0,0,69,0,103,0,240,0,0,0,56,0,230,0,188,0,131,0,49,0,173,0,0,0,185,0,16,0,6,0,141,0,61,0,50,0,233,0,78,0,66,0,247,0,0,0,26,0,79,0,131,0,11,0,43,0,0,0,50,0,0,0,0,0,0,0,103,0,0,0,27,0,137,0,129,0,139,0,0,0,160,0,74,0,237,0,234,0,154,0,0,0,209,0,220,0,0,0,160,0,0,0,0,0,156,0,253,0,25,0,17,0,169,0,0,0,135,0,0,0,218,0,112,0,198,0,220,0,198,0,0,0,71,0,19,0,23,0,0,0,0,0,4,0,182,0,212,0,179,0,0,0,114,0,90,0,248,0,248,0,143,0,110,0,37,0,170,0,0,0,201,0,115,0,239,0,90,0,171,0,255,0,193,0,217,0,0,0,235,0,43,0,217,0,82,0,46,0,225,0,251,0,167,0,229,0,0,0,49,0,148,0,0,0,95,0,187,0,76,0,146,0,119,0,50,0,96,0,0,0,76,0,165,0,64,0,80,0,110,0,0,0,250,0,190,0,87,0,36,0,0,0,112,0,226,0,68,0,221,0,206,0,247,0,87,0,132,0,117,0,2,0,31,0,52,0,113,0,0,0,25,0,154,0,0,0,248,0,53,0);
signal scenario_full  : scenario_type := (178,31,49,31,58,31,92,31,92,30,139,31,8,31,135,31,233,31,133,31,17,31,17,30,17,29,42,31,176,31,40,31,62,31,51,31,107,31,12,31,43,31,83,31,76,31,18,31,251,31,71,31,173,31,155,31,154,31,154,30,152,31,255,31,255,30,110,31,221,31,56,31,28,31,65,31,65,30,210,31,210,31,210,30,210,29,186,31,19,31,37,31,216,31,148,31,148,30,191,31,176,31,152,31,131,31,32,31,192,31,192,30,94,31,241,31,57,31,88,31,129,31,129,30,28,31,65,31,131,31,145,31,254,31,135,31,135,30,66,31,69,31,196,31,186,31,186,30,186,29,133,31,43,31,43,30,216,31,138,31,140,31,60,31,204,31,65,31,81,31,201,31,107,31,24,31,24,30,103,31,125,31,123,31,41,31,41,30,41,29,205,31,36,31,168,31,31,31,219,31,36,31,131,31,125,31,49,31,249,31,175,31,65,31,229,31,64,31,255,31,169,31,123,31,254,31,254,30,182,31,148,31,168,31,105,31,69,31,84,31,39,31,48,31,187,31,96,31,152,31,147,31,7,31,28,31,93,31,202,31,142,31,83,31,83,30,144,31,177,31,171,31,171,30,171,29,20,31,20,30,159,31,224,31,138,31,167,31,167,30,103,31,186,31,116,31,108,31,145,31,30,31,204,31,204,30,242,31,242,30,96,31,57,31,57,30,57,29,57,28,139,31,74,31,165,31,43,31,187,31,111,31,211,31,173,31,173,30,173,29,84,31,220,31,123,31,45,31,237,31,237,30,177,31,177,30,233,31,77,31,77,30,77,29,242,31,242,30,133,31,109,31,227,31,121,31,63,31,121,31,121,30,203,31,39,31,12,31,68,31,68,30,252,31,252,30,116,31,196,31,83,31,99,31,215,31,203,31,69,31,69,30,4,31,4,30,38,31,98,31,30,31,150,31,126,31,246,31,246,30,191,31,191,30,170,31,173,31,173,30,56,31,185,31,173,31,173,30,169,31,39,31,39,30,56,31,56,30,50,31,96,31,85,31,48,31,48,30,149,31,99,31,103,31,43,31,135,31,71,31,96,31,96,30,96,29,96,28,102,31,102,30,72,31,90,31,185,31,185,30,207,31,18,31,118,31,118,30,118,29,118,28,212,31,189,31,194,31,190,31,190,30,46,31,222,31,118,31,170,31,73,31,18,31,3,31,3,30,150,31,204,31,245,31,94,31,50,31,164,31,164,30,164,29,164,28,243,31,243,30,21,31,10,31,10,30,92,31,91,31,91,30,226,31,226,30,226,29,78,31,243,31,243,30,197,31,212,31,30,31,165,31,120,31,154,31,189,31,11,31,194,31,179,31,122,31,27,31,50,31,65,31,74,31,104,31,104,30,139,31,139,30,239,31,42,31,22,31,105,31,105,30,105,29,135,31,6,31,6,30,163,31,27,31,220,31,43,31,43,30,168,31,41,31,41,30,242,31,37,31,92,31,24,31,64,31,203,31,187,31,170,31,170,30,229,31,176,31,176,30,142,31,144,31,205,31,29,31,214,31,214,30,169,31,179,31,179,30,114,31,114,30,114,29,244,31,53,31,104,31,90,31,212,31,107,31,39,31,1,31,64,31,172,31,172,30,182,31,17,31,75,31,75,30,240,31,58,31,25,31,124,31,79,31,107,31,33,31,156,31,102,31,175,31,175,30,103,31,76,31,76,30,120,31,168,31,91,31,91,30,56,31,96,31,229,31,142,31,214,31,100,31,24,31,40,31,139,31,192,31,47,31,165,31,192,31,63,31,63,30,217,31,182,31,190,31,137,31,164,31,76,31,76,30,101,31,101,30,180,31,180,30,215,31,239,31,13,31,77,31,255,31,231,31,205,31,208,31,156,31,107,31,74,31,74,30,74,29,182,31,59,31,59,30,84,31,148,31,66,31,108,31,137,31,184,31,87,31,185,31,139,31,252,31,229,31,73,31,73,30,72,31,57,31,39,31,139,31,46,31,254,31,119,31,237,31,194,31,51,31,93,31,180,31,19,31,107,31,194,31,194,30,236,31,25,31,54,31,247,31,247,30,9,31,1,31,230,31,98,31,237,31,88,31,86,31,86,30,234,31,190,31,172,31,216,31,216,30,244,31,46,31,46,30,136,31,136,30,113,31,188,31,188,30,195,31,195,30,200,31,113,31,213,31,240,31,72,31,174,31,100,31,11,31,69,31,245,31,189,31,189,30,157,31,121,31,1,31,52,31,183,31,207,31,207,30,240,31,196,31,1,31,214,31,35,31,37,31,247,31,247,30,59,31,59,30,224,31,168,31,249,31,158,31,194,31,21,31,129,31,129,30,2,31,90,31,171,31,171,30,218,31,180,31,180,30,180,29,180,28,65,31,48,31,48,30,231,31,102,31,51,31,164,31,164,30,72,31,9,31,232,31,39,31,99,31,99,30,99,29,189,31,54,31,97,31,141,31,44,31,44,30,114,31,124,31,97,31,126,31,126,30,129,31,113,31,113,30,136,31,136,30,23,31,23,30,41,31,41,30,194,31,62,31,19,31,19,30,19,29,124,31,124,30,38,31,12,31,196,31,165,31,154,31,154,30,149,31,190,31,190,30,79,31,130,31,62,31,54,31,10,31,28,31,79,31,126,31,142,31,55,31,238,31,216,31,158,31,232,31,3,31,98,31,68,31,186,31,186,30,186,29,100,31,199,31,89,31,52,31,212,31,15,31,201,31,230,31,150,31,58,31,242,31,242,30,186,31,147,31,100,31,190,31,183,31,183,30,250,31,167,31,167,30,101,31,182,31,182,30,182,29,89,31,30,31,130,31,186,31,182,31,181,31,62,31,62,30,202,31,82,31,32,31,27,31,145,31,145,30,187,31,22,31,122,31,82,31,170,31,170,30,84,31,84,30,43,31,2,31,100,31,221,31,241,31,122,31,158,31,162,31,35,31,60,31,124,31,232,31,50,31,50,30,50,29,54,31,54,30,18,31,101,31,82,31,89,31,129,31,129,30,192,31,175,31,193,31,117,31,107,31,148,31,148,30,227,31,80,31,192,31,29,31,173,31,222,31,43,31,170,31,134,31,134,30,56,31,11,31,227,31,95,31,186,31,162,31,177,31,220,31,222,31,108,31,177,31,160,31,189,31,157,31,109,31,10,31,62,31,62,30,62,29,233,31,202,31,59,31,146,31,236,31,73,31,73,30,225,31,225,30,184,31,71,31,93,31,220,31,238,31,115,31,29,31,94,31,188,31,22,31,109,31,66,31,170,31,49,31,37,31,168,31,2,31,2,30,136,31,137,31,137,30,152,31,197,31,162,31,80,31,80,30,190,31,203,31,183,31,28,31,216,31,242,31,168,31,104,31,88,31,73,31,33,31,33,30,33,29,34,31,10,31,112,31,90,31,189,31,244,31,210,31,72,31,178,31,208,31,57,31,230,31,211,31,211,30,68,31,233,31,233,30,132,31,176,31,230,31,230,30,141,31,192,31,68,31,14,31,93,31,93,30,93,29,93,28,93,27,229,31,229,30,229,29,86,31,86,30,86,29,251,31,225,31,196,31,82,31,82,30,1,31,83,31,136,31,135,31,185,31,129,31,38,31,98,31,161,31,161,30,166,31,249,31,132,31,186,31,186,30,55,31,243,31,243,30,243,29,243,28,4,31,149,31,15,31,17,31,17,30,18,31,18,30,18,29,102,31,102,30,102,29,118,31,40,31,248,31,183,31,108,31,138,31,138,30,138,29,164,31,51,31,217,31,217,30,69,31,103,31,240,31,240,30,56,31,230,31,188,31,131,31,49,31,173,31,173,30,185,31,16,31,6,31,141,31,61,31,50,31,233,31,78,31,66,31,247,31,247,30,26,31,79,31,131,31,11,31,43,31,43,30,50,31,50,30,50,29,50,28,103,31,103,30,27,31,137,31,129,31,139,31,139,30,160,31,74,31,237,31,234,31,154,31,154,30,209,31,220,31,220,30,160,31,160,30,160,29,156,31,253,31,25,31,17,31,169,31,169,30,135,31,135,30,218,31,112,31,198,31,220,31,198,31,198,30,71,31,19,31,23,31,23,30,23,29,4,31,182,31,212,31,179,31,179,30,114,31,90,31,248,31,248,31,143,31,110,31,37,31,170,31,170,30,201,31,115,31,239,31,90,31,171,31,255,31,193,31,217,31,217,30,235,31,43,31,217,31,82,31,46,31,225,31,251,31,167,31,229,31,229,30,49,31,148,31,148,30,95,31,187,31,76,31,146,31,119,31,50,31,96,31,96,30,76,31,165,31,64,31,80,31,110,31,110,30,250,31,190,31,87,31,36,31,36,30,112,31,226,31,68,31,221,31,206,31,247,31,87,31,132,31,117,31,2,31,31,31,52,31,113,31,113,30,25,31,154,31,154,30,248,31,53,31);

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
