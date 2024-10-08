-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_291 is
end project_tb_291;

architecture project_tb_arch_291 of project_tb_291 is
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

constant SCENARIO_LENGTH : integer := 990;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,37,0,0,0,153,0,0,0,36,0,30,0,7,0,33,0,100,0,193,0,0,0,218,0,113,0,1,0,193,0,243,0,1,0,0,0,40,0,46,0,0,0,208,0,12,0,0,0,42,0,80,0,232,0,63,0,200,0,200,0,255,0,249,0,204,0,201,0,5,0,0,0,222,0,50,0,218,0,174,0,15,0,127,0,109,0,215,0,0,0,183,0,0,0,67,0,0,0,0,0,44,0,81,0,0,0,20,0,119,0,71,0,0,0,193,0,254,0,173,0,12,0,82,0,0,0,228,0,184,0,146,0,0,0,190,0,204,0,28,0,0,0,54,0,123,0,0,0,0,0,0,0,115,0,63,0,20,0,227,0,181,0,11,0,0,0,49,0,106,0,208,0,248,0,130,0,204,0,18,0,203,0,190,0,183,0,134,0,226,0,0,0,0,0,75,0,0,0,143,0,0,0,216,0,0,0,42,0,130,0,0,0,91,0,75,0,121,0,115,0,196,0,47,0,110,0,0,0,88,0,168,0,29,0,6,0,69,0,0,0,144,0,140,0,217,0,5,0,138,0,123,0,0,0,34,0,212,0,168,0,81,0,0,0,229,0,60,0,200,0,0,0,225,0,227,0,51,0,0,0,179,0,14,0,56,0,0,0,252,0,0,0,0,0,62,0,0,0,146,0,60,0,213,0,92,0,246,0,29,0,0,0,32,0,0,0,130,0,66,0,217,0,53,0,236,0,0,0,0,0,18,0,188,0,7,0,57,0,220,0,115,0,95,0,200,0,172,0,182,0,193,0,253,0,241,0,19,0,0,0,0,0,91,0,201,0,144,0,14,0,233,0,210,0,77,0,0,0,95,0,112,0,180,0,23,0,65,0,119,0,43,0,130,0,134,0,75,0,244,0,73,0,180,0,0,0,195,0,0,0,184,0,24,0,65,0,113,0,63,0,197,0,42,0,63,0,8,0,252,0,60,0,0,0,0,0,0,0,0,0,117,0,0,0,162,0,101,0,159,0,160,0,27,0,235,0,12,0,165,0,0,0,11,0,241,0,32,0,180,0,97,0,127,0,46,0,69,0,39,0,120,0,0,0,190,0,230,0,193,0,214,0,179,0,72,0,214,0,169,0,171,0,82,0,118,0,0,0,170,0,68,0,193,0,245,0,70,0,0,0,238,0,204,0,152,0,156,0,104,0,0,0,0,0,154,0,147,0,197,0,39,0,218,0,118,0,0,0,0,0,226,0,205,0,41,0,228,0,169,0,234,0,164,0,160,0,98,0,238,0,0,0,55,0,77,0,201,0,97,0,149,0,232,0,50,0,0,0,56,0,176,0,87,0,203,0,142,0,0,0,209,0,180,0,0,0,0,0,16,0,179,0,61,0,231,0,218,0,234,0,0,0,51,0,0,0,114,0,0,0,0,0,139,0,0,0,0,0,24,0,194,0,194,0,0,0,0,0,216,0,186,0,149,0,62,0,0,0,130,0,218,0,255,0,37,0,220,0,0,0,0,0,0,0,160,0,120,0,0,0,155,0,128,0,164,0,157,0,226,0,94,0,210,0,12,0,217,0,69,0,41,0,187,0,233,0,207,0,71,0,172,0,127,0,0,0,70,0,248,0,58,0,51,0,181,0,0,0,28,0,38,0,0,0,237,0,0,0,88,0,107,0,28,0,208,0,246,0,4,0,0,0,37,0,178,0,42,0,164,0,21,0,149,0,0,0,12,0,65,0,130,0,38,0,206,0,23,0,206,0,201,0,50,0,0,0,19,0,97,0,225,0,235,0,253,0,39,0,42,0,83,0,76,0,0,0,106,0,17,0,0,0,0,0,108,0,213,0,54,0,0,0,24,0,0,0,37,0,220,0,161,0,56,0,152,0,0,0,103,0,42,0,0,0,81,0,101,0,131,0,134,0,246,0,122,0,239,0,111,0,6,0,51,0,251,0,95,0,90,0,14,0,47,0,126,0,167,0,239,0,52,0,22,0,167,0,2,0,233,0,158,0,6,0,236,0,0,0,79,0,0,0,73,0,92,0,189,0,189,0,58,0,149,0,212,0,0,0,0,0,141,0,0,0,57,0,9,0,41,0,65,0,183,0,109,0,184,0,150,0,0,0,211,0,182,0,224,0,0,0,34,0,0,0,0,0,254,0,44,0,16,0,38,0,231,0,109,0,202,0,138,0,181,0,246,0,145,0,0,0,146,0,201,0,115,0,2,0,125,0,0,0,239,0,46,0,0,0,84,0,173,0,0,0,107,0,229,0,172,0,0,0,141,0,0,0,169,0,61,0,0,0,26,0,68,0,0,0,0,0,36,0,12,0,232,0,240,0,81,0,129,0,53,0,103,0,0,0,178,0,192,0,180,0,32,0,229,0,134,0,0,0,16,0,199,0,144,0,54,0,215,0,0,0,95,0,131,0,121,0,236,0,34,0,0,0,159,0,80,0,167,0,132,0,135,0,0,0,6,0,128,0,95,0,167,0,0,0,172,0,177,0,166,0,0,0,215,0,252,0,44,0,0,0,111,0,4,0,102,0,86,0,181,0,237,0,95,0,162,0,42,0,206,0,0,0,49,0,8,0,16,0,7,0,0,0,14,0,199,0,32,0,95,0,0,0,45,0,0,0,168,0,0,0,29,0,28,0,218,0,225,0,0,0,0,0,236,0,78,0,47,0,139,0,0,0,0,0,10,0,180,0,0,0,172,0,112,0,158,0,131,0,0,0,0,0,148,0,81,0,60,0,77,0,64,0,190,0,72,0,0,0,8,0,0,0,106,0,224,0,228,0,179,0,100,0,189,0,0,0,216,0,43,0,0,0,239,0,186,0,73,0,1,0,21,0,125,0,198,0,142,0,199,0,81,0,0,0,227,0,213,0,93,0,191,0,79,0,113,0,42,0,17,0,141,0,38,0,46,0,29,0,75,0,108,0,0,0,215,0,194,0,247,0,249,0,132,0,0,0,251,0,144,0,0,0,244,0,239,0,185,0,84,0,6,0,33,0,57,0,99,0,122,0,77,0,56,0,0,0,0,0,155,0,55,0,230,0,189,0,125,0,0,0,36,0,214,0,37,0,100,0,71,0,0,0,74,0,84,0,31,0,4,0,74,0,132,0,0,0,0,0,100,0,0,0,161,0,162,0,27,0,0,0,0,0,136,0,136,0,85,0,209,0,150,0,243,0,128,0,57,0,1,0,114,0,164,0,64,0,66,0,240,0,126,0,214,0,230,0,0,0,0,0,60,0,61,0,111,0,26,0,68,0,134,0,212,0,149,0,143,0,197,0,0,0,29,0,223,0,45,0,77,0,178,0,88,0,104,0,89,0,45,0,51,0,111,0,0,0,0,0,135,0,103,0,29,0,219,0,198,0,118,0,156,0,192,0,233,0,124,0,52,0,19,0,0,0,81,0,229,0,17,0,69,0,194,0,0,0,0,0,136,0,0,0,0,0,156,0,168,0,109,0,13,0,0,0,3,0,242,0,0,0,29,0,101,0,90,0,8,0,59,0,105,0,203,0,10,0,133,0,154,0,189,0,179,0,0,0,74,0,0,0,221,0,200,0,184,0,252,0,80,0,21,0,200,0,38,0,45,0,16,0,232,0,174,0,227,0,135,0,93,0,182,0,133,0,244,0,0,0,0,0,0,0,4,0,208,0,253,0,204,0,129,0,148,0,0,0,162,0,0,0,199,0,38,0,239,0,174,0,82,0,0,0,237,0,0,0,175,0,30,0,171,0,130,0,17,0,205,0,104,0,0,0,8,0,146,0,58,0,152,0,226,0,16,0,53,0,210,0,27,0,0,0,168,0,57,0,0,0,135,0,1,0,163,0,191,0,64,0,0,0,0,0,18,0,99,0,120,0,23,0,0,0,0,0,178,0,8,0,61,0,38,0,0,0,157,0,0,0,172,0,36,0,0,0,125,0,228,0,109,0,0,0,112,0,131,0,34,0,98,0,181,0,0,0,167,0,0,0,209,0,51,0,163,0,11,0,223,0,182,0,139,0,145,0,172,0,0,0,72,0,71,0,106,0,203,0,98,0,163,0,235,0,204,0,131,0,39,0,165,0,188,0,90,0,38,0,220,0,111,0,255,0,149,0,130,0,174,0,59,0,81,0,171,0,240,0,0,0,0,0,0,0,8,0,71,0,251,0,75,0,54,0,64,0,148,0,153,0,11,0,67,0,0,0,0,0,209,0,150,0,0,0,0,0,26,0,186,0,0,0,233,0,0,0,163,0,58,0,112,0,0,0,43,0,110,0,34,0,226,0,0,0,133,0,0,0,177,0,0,0,248,0,254,0,219,0,61,0,7,0,224,0,209,0,92,0,0,0,36,0,23,0,190,0,16,0,126,0,251,0,236,0,54,0,0,0,138,0,136,0,0,0,28,0,235,0,122,0,0,0,0,0,11,0,171,0,0,0,11,0,0,0,192,0);
signal scenario_full  : scenario_type := (0,0,37,31,37,30,153,31,153,30,36,31,30,31,7,31,33,31,100,31,193,31,193,30,218,31,113,31,1,31,193,31,243,31,1,31,1,30,40,31,46,31,46,30,208,31,12,31,12,30,42,31,80,31,232,31,63,31,200,31,200,31,255,31,249,31,204,31,201,31,5,31,5,30,222,31,50,31,218,31,174,31,15,31,127,31,109,31,215,31,215,30,183,31,183,30,67,31,67,30,67,29,44,31,81,31,81,30,20,31,119,31,71,31,71,30,193,31,254,31,173,31,12,31,82,31,82,30,228,31,184,31,146,31,146,30,190,31,204,31,28,31,28,30,54,31,123,31,123,30,123,29,123,28,115,31,63,31,20,31,227,31,181,31,11,31,11,30,49,31,106,31,208,31,248,31,130,31,204,31,18,31,203,31,190,31,183,31,134,31,226,31,226,30,226,29,75,31,75,30,143,31,143,30,216,31,216,30,42,31,130,31,130,30,91,31,75,31,121,31,115,31,196,31,47,31,110,31,110,30,88,31,168,31,29,31,6,31,69,31,69,30,144,31,140,31,217,31,5,31,138,31,123,31,123,30,34,31,212,31,168,31,81,31,81,30,229,31,60,31,200,31,200,30,225,31,227,31,51,31,51,30,179,31,14,31,56,31,56,30,252,31,252,30,252,29,62,31,62,30,146,31,60,31,213,31,92,31,246,31,29,31,29,30,32,31,32,30,130,31,66,31,217,31,53,31,236,31,236,30,236,29,18,31,188,31,7,31,57,31,220,31,115,31,95,31,200,31,172,31,182,31,193,31,253,31,241,31,19,31,19,30,19,29,91,31,201,31,144,31,14,31,233,31,210,31,77,31,77,30,95,31,112,31,180,31,23,31,65,31,119,31,43,31,130,31,134,31,75,31,244,31,73,31,180,31,180,30,195,31,195,30,184,31,24,31,65,31,113,31,63,31,197,31,42,31,63,31,8,31,252,31,60,31,60,30,60,29,60,28,60,27,117,31,117,30,162,31,101,31,159,31,160,31,27,31,235,31,12,31,165,31,165,30,11,31,241,31,32,31,180,31,97,31,127,31,46,31,69,31,39,31,120,31,120,30,190,31,230,31,193,31,214,31,179,31,72,31,214,31,169,31,171,31,82,31,118,31,118,30,170,31,68,31,193,31,245,31,70,31,70,30,238,31,204,31,152,31,156,31,104,31,104,30,104,29,154,31,147,31,197,31,39,31,218,31,118,31,118,30,118,29,226,31,205,31,41,31,228,31,169,31,234,31,164,31,160,31,98,31,238,31,238,30,55,31,77,31,201,31,97,31,149,31,232,31,50,31,50,30,56,31,176,31,87,31,203,31,142,31,142,30,209,31,180,31,180,30,180,29,16,31,179,31,61,31,231,31,218,31,234,31,234,30,51,31,51,30,114,31,114,30,114,29,139,31,139,30,139,29,24,31,194,31,194,31,194,30,194,29,216,31,186,31,149,31,62,31,62,30,130,31,218,31,255,31,37,31,220,31,220,30,220,29,220,28,160,31,120,31,120,30,155,31,128,31,164,31,157,31,226,31,94,31,210,31,12,31,217,31,69,31,41,31,187,31,233,31,207,31,71,31,172,31,127,31,127,30,70,31,248,31,58,31,51,31,181,31,181,30,28,31,38,31,38,30,237,31,237,30,88,31,107,31,28,31,208,31,246,31,4,31,4,30,37,31,178,31,42,31,164,31,21,31,149,31,149,30,12,31,65,31,130,31,38,31,206,31,23,31,206,31,201,31,50,31,50,30,19,31,97,31,225,31,235,31,253,31,39,31,42,31,83,31,76,31,76,30,106,31,17,31,17,30,17,29,108,31,213,31,54,31,54,30,24,31,24,30,37,31,220,31,161,31,56,31,152,31,152,30,103,31,42,31,42,30,81,31,101,31,131,31,134,31,246,31,122,31,239,31,111,31,6,31,51,31,251,31,95,31,90,31,14,31,47,31,126,31,167,31,239,31,52,31,22,31,167,31,2,31,233,31,158,31,6,31,236,31,236,30,79,31,79,30,73,31,92,31,189,31,189,31,58,31,149,31,212,31,212,30,212,29,141,31,141,30,57,31,9,31,41,31,65,31,183,31,109,31,184,31,150,31,150,30,211,31,182,31,224,31,224,30,34,31,34,30,34,29,254,31,44,31,16,31,38,31,231,31,109,31,202,31,138,31,181,31,246,31,145,31,145,30,146,31,201,31,115,31,2,31,125,31,125,30,239,31,46,31,46,30,84,31,173,31,173,30,107,31,229,31,172,31,172,30,141,31,141,30,169,31,61,31,61,30,26,31,68,31,68,30,68,29,36,31,12,31,232,31,240,31,81,31,129,31,53,31,103,31,103,30,178,31,192,31,180,31,32,31,229,31,134,31,134,30,16,31,199,31,144,31,54,31,215,31,215,30,95,31,131,31,121,31,236,31,34,31,34,30,159,31,80,31,167,31,132,31,135,31,135,30,6,31,128,31,95,31,167,31,167,30,172,31,177,31,166,31,166,30,215,31,252,31,44,31,44,30,111,31,4,31,102,31,86,31,181,31,237,31,95,31,162,31,42,31,206,31,206,30,49,31,8,31,16,31,7,31,7,30,14,31,199,31,32,31,95,31,95,30,45,31,45,30,168,31,168,30,29,31,28,31,218,31,225,31,225,30,225,29,236,31,78,31,47,31,139,31,139,30,139,29,10,31,180,31,180,30,172,31,112,31,158,31,131,31,131,30,131,29,148,31,81,31,60,31,77,31,64,31,190,31,72,31,72,30,8,31,8,30,106,31,224,31,228,31,179,31,100,31,189,31,189,30,216,31,43,31,43,30,239,31,186,31,73,31,1,31,21,31,125,31,198,31,142,31,199,31,81,31,81,30,227,31,213,31,93,31,191,31,79,31,113,31,42,31,17,31,141,31,38,31,46,31,29,31,75,31,108,31,108,30,215,31,194,31,247,31,249,31,132,31,132,30,251,31,144,31,144,30,244,31,239,31,185,31,84,31,6,31,33,31,57,31,99,31,122,31,77,31,56,31,56,30,56,29,155,31,55,31,230,31,189,31,125,31,125,30,36,31,214,31,37,31,100,31,71,31,71,30,74,31,84,31,31,31,4,31,74,31,132,31,132,30,132,29,100,31,100,30,161,31,162,31,27,31,27,30,27,29,136,31,136,31,85,31,209,31,150,31,243,31,128,31,57,31,1,31,114,31,164,31,64,31,66,31,240,31,126,31,214,31,230,31,230,30,230,29,60,31,61,31,111,31,26,31,68,31,134,31,212,31,149,31,143,31,197,31,197,30,29,31,223,31,45,31,77,31,178,31,88,31,104,31,89,31,45,31,51,31,111,31,111,30,111,29,135,31,103,31,29,31,219,31,198,31,118,31,156,31,192,31,233,31,124,31,52,31,19,31,19,30,81,31,229,31,17,31,69,31,194,31,194,30,194,29,136,31,136,30,136,29,156,31,168,31,109,31,13,31,13,30,3,31,242,31,242,30,29,31,101,31,90,31,8,31,59,31,105,31,203,31,10,31,133,31,154,31,189,31,179,31,179,30,74,31,74,30,221,31,200,31,184,31,252,31,80,31,21,31,200,31,38,31,45,31,16,31,232,31,174,31,227,31,135,31,93,31,182,31,133,31,244,31,244,30,244,29,244,28,4,31,208,31,253,31,204,31,129,31,148,31,148,30,162,31,162,30,199,31,38,31,239,31,174,31,82,31,82,30,237,31,237,30,175,31,30,31,171,31,130,31,17,31,205,31,104,31,104,30,8,31,146,31,58,31,152,31,226,31,16,31,53,31,210,31,27,31,27,30,168,31,57,31,57,30,135,31,1,31,163,31,191,31,64,31,64,30,64,29,18,31,99,31,120,31,23,31,23,30,23,29,178,31,8,31,61,31,38,31,38,30,157,31,157,30,172,31,36,31,36,30,125,31,228,31,109,31,109,30,112,31,131,31,34,31,98,31,181,31,181,30,167,31,167,30,209,31,51,31,163,31,11,31,223,31,182,31,139,31,145,31,172,31,172,30,72,31,71,31,106,31,203,31,98,31,163,31,235,31,204,31,131,31,39,31,165,31,188,31,90,31,38,31,220,31,111,31,255,31,149,31,130,31,174,31,59,31,81,31,171,31,240,31,240,30,240,29,240,28,8,31,71,31,251,31,75,31,54,31,64,31,148,31,153,31,11,31,67,31,67,30,67,29,209,31,150,31,150,30,150,29,26,31,186,31,186,30,233,31,233,30,163,31,58,31,112,31,112,30,43,31,110,31,34,31,226,31,226,30,133,31,133,30,177,31,177,30,248,31,254,31,219,31,61,31,7,31,224,31,209,31,92,31,92,30,36,31,23,31,190,31,16,31,126,31,251,31,236,31,54,31,54,30,138,31,136,31,136,30,28,31,235,31,122,31,122,30,122,29,11,31,171,31,171,30,11,31,11,30,192,31);

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
