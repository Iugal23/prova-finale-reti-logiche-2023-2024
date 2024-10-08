-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_169 is
end project_tb_169;

architecture project_tb_arch_169 of project_tb_169 is
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

constant SCENARIO_LENGTH : integer := 1018;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (100,0,156,0,25,0,0,0,253,0,189,0,74,0,76,0,0,0,64,0,185,0,245,0,70,0,239,0,249,0,1,0,140,0,114,0,0,0,6,0,102,0,24,0,115,0,119,0,114,0,186,0,36,0,0,0,183,0,189,0,70,0,0,0,0,0,62,0,56,0,194,0,230,0,126,0,221,0,9,0,104,0,92,0,200,0,0,0,146,0,0,0,13,0,169,0,11,0,99,0,115,0,0,0,182,0,56,0,40,0,207,0,68,0,207,0,21,0,253,0,0,0,109,0,75,0,62,0,0,0,202,0,161,0,193,0,217,0,228,0,174,0,247,0,142,0,55,0,0,0,92,0,0,0,152,0,190,0,31,0,18,0,23,0,108,0,0,0,48,0,179,0,249,0,229,0,106,0,163,0,245,0,0,0,0,0,113,0,94,0,79,0,139,0,190,0,234,0,91,0,48,0,147,0,53,0,79,0,8,0,137,0,244,0,118,0,52,0,74,0,138,0,56,0,110,0,163,0,60,0,254,0,113,0,177,0,3,0,0,0,111,0,121,0,178,0,18,0,123,0,143,0,29,0,57,0,216,0,1,0,0,0,63,0,15,0,0,0,46,0,189,0,181,0,140,0,186,0,13,0,161,0,143,0,200,0,144,0,173,0,47,0,0,0,0,0,0,0,0,0,0,0,52,0,136,0,109,0,149,0,220,0,184,0,245,0,0,0,69,0,30,0,0,0,79,0,166,0,164,0,71,0,139,0,42,0,108,0,190,0,0,0,132,0,0,0,78,0,245,0,71,0,174,0,40,0,132,0,201,0,66,0,173,0,178,0,0,0,230,0,0,0,229,0,120,0,195,0,144,0,0,0,156,0,0,0,38,0,0,0,218,0,208,0,232,0,0,0,127,0,0,0,64,0,0,0,16,0,167,0,129,0,158,0,238,0,191,0,0,0,241,0,18,0,90,0,0,0,96,0,25,0,139,0,18,0,172,0,113,0,253,0,80,0,98,0,0,0,2,0,0,0,127,0,133,0,81,0,95,0,0,0,41,0,89,0,195,0,146,0,120,0,0,0,182,0,0,0,13,0,82,0,32,0,0,0,149,0,138,0,138,0,27,0,233,0,185,0,30,0,246,0,185,0,117,0,132,0,151,0,168,0,248,0,173,0,171,0,91,0,0,0,189,0,93,0,204,0,80,0,0,0,238,0,185,0,0,0,147,0,102,0,224,0,243,0,91,0,197,0,154,0,79,0,41,0,187,0,0,0,32,0,0,0,32,0,0,0,144,0,0,0,113,0,128,0,0,0,137,0,213,0,0,0,0,0,192,0,170,0,92,0,0,0,0,0,138,0,54,0,203,0,171,0,27,0,207,0,0,0,127,0,147,0,39,0,0,0,236,0,0,0,16,0,0,0,0,0,140,0,240,0,43,0,232,0,247,0,177,0,139,0,197,0,23,0,163,0,0,0,76,0,73,0,183,0,211,0,102,0,125,0,162,0,1,0,204,0,0,0,101,0,0,0,49,0,0,0,229,0,93,0,247,0,0,0,171,0,163,0,140,0,12,0,83,0,47,0,189,0,167,0,0,0,87,0,164,0,67,0,238,0,35,0,40,0,154,0,0,0,0,0,242,0,0,0,110,0,0,0,73,0,176,0,119,0,74,0,94,0,0,0,38,0,53,0,108,0,146,0,0,0,36,0,88,0,163,0,104,0,246,0,218,0,70,0,0,0,60,0,231,0,0,0,0,0,233,0,22,0,0,0,217,0,0,0,5,0,0,0,239,0,25,0,207,0,146,0,127,0,248,0,0,0,136,0,95,0,73,0,101,0,234,0,90,0,214,0,220,0,244,0,171,0,235,0,0,0,156,0,228,0,57,0,60,0,218,0,159,0,63,0,196,0,40,0,148,0,221,0,0,0,80,0,193,0,64,0,68,0,89,0,248,0,0,0,61,0,78,0,0,0,0,0,76,0,0,0,108,0,25,0,16,0,29,0,186,0,250,0,115,0,167,0,56,0,227,0,189,0,100,0,16,0,94,0,0,0,254,0,120,0,149,0,150,0,101,0,10,0,9,0,185,0,7,0,40,0,208,0,87,0,0,0,234,0,128,0,0,0,51,0,130,0,9,0,31,0,145,0,46,0,55,0,248,0,0,0,0,0,167,0,167,0,9,0,0,0,101,0,182,0,189,0,59,0,71,0,0,0,0,0,0,0,0,0,0,0,73,0,16,0,187,0,113,0,4,0,88,0,0,0,22,0,28,0,196,0,0,0,123,0,76,0,0,0,0,0,52,0,0,0,89,0,199,0,136,0,164,0,130,0,65,0,0,0,0,0,225,0,213,0,181,0,65,0,219,0,161,0,159,0,0,0,226,0,0,0,98,0,178,0,64,0,171,0,251,0,3,0,100,0,0,0,0,0,0,0,190,0,203,0,0,0,5,0,64,0,165,0,229,0,195,0,114,0,212,0,84,0,0,0,242,0,0,0,0,0,82,0,236,0,250,0,0,0,146,0,56,0,46,0,209,0,70,0,230,0,49,0,38,0,233,0,221,0,197,0,80,0,0,0,101,0,0,0,171,0,74,0,75,0,124,0,54,0,32,0,128,0,5,0,208,0,0,0,190,0,98,0,96,0,117,0,173,0,0,0,16,0,193,0,246,0,156,0,134,0,187,0,67,0,235,0,176,0,183,0,221,0,99,0,236,0,0,0,187,0,73,0,196,0,0,0,82,0,206,0,0,0,148,0,0,0,206,0,94,0,0,0,139,0,248,0,85,0,195,0,230,0,113,0,23,0,24,0,184,0,157,0,58,0,217,0,121,0,119,0,0,0,11,0,228,0,4,0,224,0,79,0,37,0,73,0,92,0,251,0,148,0,233,0,27,0,12,0,45,0,254,0,209,0,27,0,3,0,112,0,0,0,192,0,0,0,0,0,241,0,246,0,232,0,90,0,0,0,193,0,195,0,138,0,10,0,0,0,57,0,12,0,231,0,174,0,191,0,205,0,0,0,0,0,0,0,110,0,0,0,226,0,36,0,0,0,204,0,0,0,213,0,0,0,126,0,241,0,43,0,128,0,223,0,55,0,0,0,99,0,242,0,131,0,38,0,189,0,0,0,213,0,107,0,217,0,0,0,65,0,139,0,134,0,90,0,175,0,48,0,0,0,82,0,0,0,0,0,0,0,254,0,0,0,18,0,165,0,143,0,26,0,0,0,20,0,255,0,4,0,42,0,15,0,252,0,57,0,24,0,212,0,190,0,124,0,0,0,127,0,220,0,180,0,55,0,0,0,0,0,37,0,208,0,106,0,109,0,111,0,162,0,42,0,234,0,218,0,56,0,0,0,57,0,66,0,204,0,172,0,0,0,125,0,219,0,99,0,202,0,93,0,99,0,0,0,57,0,131,0,164,0,92,0,0,0,96,0,70,0,226,0,67,0,64,0,169,0,191,0,253,0,29,0,0,0,0,0,184,0,211,0,241,0,60,0,33,0,198,0,179,0,0,0,0,0,244,0,240,0,184,0,189,0,12,0,211,0,0,0,48,0,0,0,225,0,249,0,104,0,27,0,0,0,145,0,216,0,1,0,0,0,15,0,199,0,127,0,71,0,36,0,0,0,30,0,174,0,0,0,0,0,8,0,143,0,110,0,35,0,72,0,132,0,220,0,70,0,246,0,86,0,249,0,30,0,126,0,217,0,116,0,0,0,0,0,178,0,123,0,150,0,83,0,62,0,60,0,25,0,205,0,131,0,3,0,107,0,198,0,210,0,170,0,197,0,0,0,0,0,0,0,0,0,162,0,0,0,142,0,82,0,188,0,10,0,43,0,0,0,132,0,77,0,0,0,175,0,32,0,106,0,118,0,162,0,202,0,40,0,125,0,139,0,0,0,51,0,97,0,0,0,16,0,223,0,36,0,251,0,199,0,0,0,138,0,168,0,131,0,116,0,144,0,192,0,64,0,149,0,0,0,79,0,119,0,37,0,49,0,141,0,206,0,44,0,0,0,119,0,18,0,0,0,0,0,0,0,182,0,48,0,231,0,201,0,0,0,109,0,139,0,99,0,238,0,43,0,101,0,0,0,108,0,103,0,187,0,70,0,79,0,22,0,46,0,196,0,12,0,7,0,117,0,160,0,117,0,0,0,213,0,77,0,169,0,114,0,182,0,227,0,54,0,139,0,69,0,81,0,207,0,0,0,19,0,0,0,111,0,0,0,4,0,84,0,128,0,73,0,0,0,212,0,0,0,54,0,44,0,60,0,129,0,248,0,72,0,0,0,137,0,0,0,126,0,69,0,0,0,82,0,152,0,192,0,4,0,40,0,188,0,93,0,201,0,131,0,100,0,0,0,153,0,0,0,36,0,208,0,212,0,206,0,249,0,0,0,28,0,9,0,55,0,60,0,0,0,57,0,143,0,0,0,123,0,0,0,229,0,0,0,4,0,0,0,0,0,141,0,247,0,119,0,100,0,142,0,95,0,243,0,99,0,112,0,0,0,58,0,0,0,142,0,179,0,51,0,169,0,217,0,0,0,246,0,226,0,159,0,246,0,180,0,0,0,99,0);
signal scenario_full  : scenario_type := (100,31,156,31,25,31,25,30,253,31,189,31,74,31,76,31,76,30,64,31,185,31,245,31,70,31,239,31,249,31,1,31,140,31,114,31,114,30,6,31,102,31,24,31,115,31,119,31,114,31,186,31,36,31,36,30,183,31,189,31,70,31,70,30,70,29,62,31,56,31,194,31,230,31,126,31,221,31,9,31,104,31,92,31,200,31,200,30,146,31,146,30,13,31,169,31,11,31,99,31,115,31,115,30,182,31,56,31,40,31,207,31,68,31,207,31,21,31,253,31,253,30,109,31,75,31,62,31,62,30,202,31,161,31,193,31,217,31,228,31,174,31,247,31,142,31,55,31,55,30,92,31,92,30,152,31,190,31,31,31,18,31,23,31,108,31,108,30,48,31,179,31,249,31,229,31,106,31,163,31,245,31,245,30,245,29,113,31,94,31,79,31,139,31,190,31,234,31,91,31,48,31,147,31,53,31,79,31,8,31,137,31,244,31,118,31,52,31,74,31,138,31,56,31,110,31,163,31,60,31,254,31,113,31,177,31,3,31,3,30,111,31,121,31,178,31,18,31,123,31,143,31,29,31,57,31,216,31,1,31,1,30,63,31,15,31,15,30,46,31,189,31,181,31,140,31,186,31,13,31,161,31,143,31,200,31,144,31,173,31,47,31,47,30,47,29,47,28,47,27,47,26,52,31,136,31,109,31,149,31,220,31,184,31,245,31,245,30,69,31,30,31,30,30,79,31,166,31,164,31,71,31,139,31,42,31,108,31,190,31,190,30,132,31,132,30,78,31,245,31,71,31,174,31,40,31,132,31,201,31,66,31,173,31,178,31,178,30,230,31,230,30,229,31,120,31,195,31,144,31,144,30,156,31,156,30,38,31,38,30,218,31,208,31,232,31,232,30,127,31,127,30,64,31,64,30,16,31,167,31,129,31,158,31,238,31,191,31,191,30,241,31,18,31,90,31,90,30,96,31,25,31,139,31,18,31,172,31,113,31,253,31,80,31,98,31,98,30,2,31,2,30,127,31,133,31,81,31,95,31,95,30,41,31,89,31,195,31,146,31,120,31,120,30,182,31,182,30,13,31,82,31,32,31,32,30,149,31,138,31,138,31,27,31,233,31,185,31,30,31,246,31,185,31,117,31,132,31,151,31,168,31,248,31,173,31,171,31,91,31,91,30,189,31,93,31,204,31,80,31,80,30,238,31,185,31,185,30,147,31,102,31,224,31,243,31,91,31,197,31,154,31,79,31,41,31,187,31,187,30,32,31,32,30,32,31,32,30,144,31,144,30,113,31,128,31,128,30,137,31,213,31,213,30,213,29,192,31,170,31,92,31,92,30,92,29,138,31,54,31,203,31,171,31,27,31,207,31,207,30,127,31,147,31,39,31,39,30,236,31,236,30,16,31,16,30,16,29,140,31,240,31,43,31,232,31,247,31,177,31,139,31,197,31,23,31,163,31,163,30,76,31,73,31,183,31,211,31,102,31,125,31,162,31,1,31,204,31,204,30,101,31,101,30,49,31,49,30,229,31,93,31,247,31,247,30,171,31,163,31,140,31,12,31,83,31,47,31,189,31,167,31,167,30,87,31,164,31,67,31,238,31,35,31,40,31,154,31,154,30,154,29,242,31,242,30,110,31,110,30,73,31,176,31,119,31,74,31,94,31,94,30,38,31,53,31,108,31,146,31,146,30,36,31,88,31,163,31,104,31,246,31,218,31,70,31,70,30,60,31,231,31,231,30,231,29,233,31,22,31,22,30,217,31,217,30,5,31,5,30,239,31,25,31,207,31,146,31,127,31,248,31,248,30,136,31,95,31,73,31,101,31,234,31,90,31,214,31,220,31,244,31,171,31,235,31,235,30,156,31,228,31,57,31,60,31,218,31,159,31,63,31,196,31,40,31,148,31,221,31,221,30,80,31,193,31,64,31,68,31,89,31,248,31,248,30,61,31,78,31,78,30,78,29,76,31,76,30,108,31,25,31,16,31,29,31,186,31,250,31,115,31,167,31,56,31,227,31,189,31,100,31,16,31,94,31,94,30,254,31,120,31,149,31,150,31,101,31,10,31,9,31,185,31,7,31,40,31,208,31,87,31,87,30,234,31,128,31,128,30,51,31,130,31,9,31,31,31,145,31,46,31,55,31,248,31,248,30,248,29,167,31,167,31,9,31,9,30,101,31,182,31,189,31,59,31,71,31,71,30,71,29,71,28,71,27,71,26,73,31,16,31,187,31,113,31,4,31,88,31,88,30,22,31,28,31,196,31,196,30,123,31,76,31,76,30,76,29,52,31,52,30,89,31,199,31,136,31,164,31,130,31,65,31,65,30,65,29,225,31,213,31,181,31,65,31,219,31,161,31,159,31,159,30,226,31,226,30,98,31,178,31,64,31,171,31,251,31,3,31,100,31,100,30,100,29,100,28,190,31,203,31,203,30,5,31,64,31,165,31,229,31,195,31,114,31,212,31,84,31,84,30,242,31,242,30,242,29,82,31,236,31,250,31,250,30,146,31,56,31,46,31,209,31,70,31,230,31,49,31,38,31,233,31,221,31,197,31,80,31,80,30,101,31,101,30,171,31,74,31,75,31,124,31,54,31,32,31,128,31,5,31,208,31,208,30,190,31,98,31,96,31,117,31,173,31,173,30,16,31,193,31,246,31,156,31,134,31,187,31,67,31,235,31,176,31,183,31,221,31,99,31,236,31,236,30,187,31,73,31,196,31,196,30,82,31,206,31,206,30,148,31,148,30,206,31,94,31,94,30,139,31,248,31,85,31,195,31,230,31,113,31,23,31,24,31,184,31,157,31,58,31,217,31,121,31,119,31,119,30,11,31,228,31,4,31,224,31,79,31,37,31,73,31,92,31,251,31,148,31,233,31,27,31,12,31,45,31,254,31,209,31,27,31,3,31,112,31,112,30,192,31,192,30,192,29,241,31,246,31,232,31,90,31,90,30,193,31,195,31,138,31,10,31,10,30,57,31,12,31,231,31,174,31,191,31,205,31,205,30,205,29,205,28,110,31,110,30,226,31,36,31,36,30,204,31,204,30,213,31,213,30,126,31,241,31,43,31,128,31,223,31,55,31,55,30,99,31,242,31,131,31,38,31,189,31,189,30,213,31,107,31,217,31,217,30,65,31,139,31,134,31,90,31,175,31,48,31,48,30,82,31,82,30,82,29,82,28,254,31,254,30,18,31,165,31,143,31,26,31,26,30,20,31,255,31,4,31,42,31,15,31,252,31,57,31,24,31,212,31,190,31,124,31,124,30,127,31,220,31,180,31,55,31,55,30,55,29,37,31,208,31,106,31,109,31,111,31,162,31,42,31,234,31,218,31,56,31,56,30,57,31,66,31,204,31,172,31,172,30,125,31,219,31,99,31,202,31,93,31,99,31,99,30,57,31,131,31,164,31,92,31,92,30,96,31,70,31,226,31,67,31,64,31,169,31,191,31,253,31,29,31,29,30,29,29,184,31,211,31,241,31,60,31,33,31,198,31,179,31,179,30,179,29,244,31,240,31,184,31,189,31,12,31,211,31,211,30,48,31,48,30,225,31,249,31,104,31,27,31,27,30,145,31,216,31,1,31,1,30,15,31,199,31,127,31,71,31,36,31,36,30,30,31,174,31,174,30,174,29,8,31,143,31,110,31,35,31,72,31,132,31,220,31,70,31,246,31,86,31,249,31,30,31,126,31,217,31,116,31,116,30,116,29,178,31,123,31,150,31,83,31,62,31,60,31,25,31,205,31,131,31,3,31,107,31,198,31,210,31,170,31,197,31,197,30,197,29,197,28,197,27,162,31,162,30,142,31,82,31,188,31,10,31,43,31,43,30,132,31,77,31,77,30,175,31,32,31,106,31,118,31,162,31,202,31,40,31,125,31,139,31,139,30,51,31,97,31,97,30,16,31,223,31,36,31,251,31,199,31,199,30,138,31,168,31,131,31,116,31,144,31,192,31,64,31,149,31,149,30,79,31,119,31,37,31,49,31,141,31,206,31,44,31,44,30,119,31,18,31,18,30,18,29,18,28,182,31,48,31,231,31,201,31,201,30,109,31,139,31,99,31,238,31,43,31,101,31,101,30,108,31,103,31,187,31,70,31,79,31,22,31,46,31,196,31,12,31,7,31,117,31,160,31,117,31,117,30,213,31,77,31,169,31,114,31,182,31,227,31,54,31,139,31,69,31,81,31,207,31,207,30,19,31,19,30,111,31,111,30,4,31,84,31,128,31,73,31,73,30,212,31,212,30,54,31,44,31,60,31,129,31,248,31,72,31,72,30,137,31,137,30,126,31,69,31,69,30,82,31,152,31,192,31,4,31,40,31,188,31,93,31,201,31,131,31,100,31,100,30,153,31,153,30,36,31,208,31,212,31,206,31,249,31,249,30,28,31,9,31,55,31,60,31,60,30,57,31,143,31,143,30,123,31,123,30,229,31,229,30,4,31,4,30,4,29,141,31,247,31,119,31,100,31,142,31,95,31,243,31,99,31,112,31,112,30,58,31,58,30,142,31,179,31,51,31,169,31,217,31,217,30,246,31,226,31,159,31,246,31,180,31,180,30,99,31);

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
