-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_560 is
end project_tb_560;

architecture project_tb_arch_560 of project_tb_560 is
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

constant SCENARIO_LENGTH : integer := 1012;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (128,0,152,0,0,0,0,0,4,0,24,0,11,0,87,0,0,0,62,0,94,0,202,0,0,0,108,0,172,0,109,0,34,0,114,0,0,0,0,0,138,0,0,0,216,0,110,0,113,0,24,0,0,0,0,0,137,0,0,0,82,0,96,0,0,0,155,0,0,0,139,0,62,0,241,0,174,0,114,0,40,0,73,0,156,0,0,0,116,0,199,0,39,0,103,0,244,0,158,0,118,0,229,0,0,0,154,0,0,0,63,0,231,0,98,0,68,0,1,0,75,0,226,0,176,0,0,0,5,0,217,0,2,0,176,0,26,0,0,0,80,0,0,0,52,0,52,0,214,0,53,0,151,0,18,0,75,0,0,0,0,0,21,0,147,0,208,0,0,0,157,0,131,0,236,0,0,0,150,0,0,0,24,0,218,0,238,0,48,0,124,0,0,0,243,0,73,0,180,0,135,0,0,0,101,0,158,0,0,0,224,0,229,0,141,0,100,0,196,0,155,0,38,0,70,0,239,0,103,0,0,0,160,0,96,0,180,0,9,0,151,0,157,0,255,0,248,0,0,0,50,0,18,0,40,0,236,0,84,0,0,0,66,0,32,0,197,0,0,0,0,0,81,0,25,0,51,0,0,0,245,0,76,0,99,0,9,0,247,0,144,0,0,0,205,0,232,0,0,0,61,0,162,0,95,0,247,0,209,0,201,0,71,0,129,0,239,0,0,0,11,0,179,0,80,0,131,0,0,0,130,0,211,0,249,0,251,0,20,0,237,0,142,0,175,0,191,0,86,0,83,0,0,0,0,0,203,0,226,0,77,0,222,0,2,0,148,0,118,0,0,0,126,0,99,0,234,0,27,0,45,0,232,0,219,0,124,0,133,0,187,0,165,0,6,0,76,0,0,0,10,0,221,0,69,0,0,0,222,0,23,0,217,0,207,0,116,0,0,0,206,0,27,0,0,0,22,0,200,0,34,0,100,0,0,0,131,0,249,0,12,0,0,0,104,0,213,0,149,0,37,0,180,0,228,0,118,0,54,0,77,0,117,0,0,0,125,0,0,0,145,0,251,0,81,0,156,0,216,0,0,0,184,0,57,0,150,0,197,0,0,0,199,0,0,0,86,0,0,0,50,0,134,0,32,0,57,0,0,0,35,0,252,0,150,0,34,0,88,0,154,0,0,0,106,0,2,0,144,0,0,0,201,0,184,0,182,0,0,0,178,0,213,0,227,0,203,0,0,0,110,0,108,0,161,0,0,0,101,0,13,0,216,0,103,0,129,0,0,0,46,0,220,0,241,0,47,0,56,0,110,0,0,0,0,0,0,0,30,0,109,0,230,0,247,0,37,0,236,0,4,0,255,0,245,0,128,0,123,0,188,0,175,0,0,0,46,0,151,0,28,0,19,0,230,0,145,0,107,0,68,0,253,0,52,0,0,0,10,0,0,0,169,0,241,0,174,0,157,0,0,0,133,0,63,0,0,0,228,0,59,0,253,0,105,0,0,0,80,0,104,0,96,0,62,0,57,0,240,0,218,0,213,0,254,0,179,0,190,0,0,0,211,0,179,0,34,0,166,0,102,0,0,0,126,0,0,0,236,0,73,0,113,0,209,0,0,0,211,0,238,0,43,0,202,0,80,0,103,0,2,0,0,0,130,0,59,0,103,0,145,0,195,0,38,0,0,0,0,0,66,0,0,0,81,0,0,0,204,0,188,0,75,0,133,0,0,0,0,0,136,0,0,0,112,0,50,0,118,0,0,0,170,0,227,0,57,0,0,0,77,0,129,0,0,0,0,0,0,0,0,0,0,0,24,0,147,0,122,0,40,0,42,0,70,0,229,0,142,0,0,0,0,0,34,0,158,0,246,0,221,0,95,0,143,0,37,0,113,0,165,0,0,0,179,0,103,0,24,0,111,0,39,0,35,0,230,0,28,0,0,0,192,0,33,0,135,0,1,0,0,0,97,0,228,0,90,0,139,0,104,0,103,0,139,0,87,0,228,0,125,0,155,0,227,0,109,0,18,0,211,0,255,0,252,0,0,0,120,0,242,0,197,0,138,0,201,0,0,0,97,0,24,0,88,0,103,0,6,0,180,0,11,0,184,0,83,0,0,0,252,0,192,0,110,0,47,0,252,0,0,0,181,0,57,0,52,0,0,0,0,0,0,0,114,0,134,0,235,0,84,0,38,0,236,0,174,0,110,0,20,0,96,0,0,0,203,0,239,0,237,0,190,0,28,0,16,0,83,0,233,0,0,0,0,0,0,0,117,0,75,0,0,0,84,0,106,0,212,0,0,0,60,0,136,0,240,0,22,0,184,0,250,0,255,0,177,0,156,0,118,0,0,0,88,0,241,0,0,0,187,0,23,0,94,0,150,0,105,0,75,0,88,0,68,0,245,0,163,0,129,0,93,0,92,0,187,0,210,0,105,0,109,0,161,0,243,0,102,0,230,0,118,0,248,0,201,0,181,0,216,0,0,0,192,0,23,0,193,0,175,0,0,0,1,0,0,0,43,0,99,0,161,0,0,0,250,0,112,0,58,0,115,0,205,0,254,0,137,0,0,0,220,0,47,0,0,0,245,0,30,0,181,0,0,0,104,0,83,0,0,0,164,0,147,0,16,0,89,0,36,0,0,0,162,0,251,0,238,0,0,0,191,0,3,0,16,0,0,0,0,0,0,0,207,0,0,0,140,0,0,0,194,0,73,0,51,0,0,0,25,0,12,0,33,0,204,0,9,0,88,0,0,0,46,0,161,0,91,0,157,0,109,0,182,0,228,0,218,0,90,0,121,0,0,0,242,0,154,0,136,0,76,0,47,0,189,0,152,0,104,0,34,0,60,0,83,0,11,0,238,0,97,0,156,0,91,0,176,0,70,0,62,0,0,0,0,0,0,0,209,0,230,0,109,0,247,0,0,0,47,0,159,0,151,0,160,0,243,0,194,0,187,0,207,0,238,0,0,0,203,0,38,0,0,0,139,0,184,0,66,0,95,0,227,0,0,0,239,0,83,0,13,0,251,0,0,0,211,0,0,0,249,0,58,0,0,0,11,0,27,0,213,0,40,0,244,0,0,0,123,0,54,0,0,0,0,0,227,0,99,0,239,0,180,0,0,0,106,0,204,0,142,0,0,0,99,0,187,0,0,0,3,0,7,0,5,0,245,0,52,0,110,0,71,0,184,0,58,0,0,0,56,0,221,0,171,0,192,0,108,0,243,0,151,0,0,0,246,0,62,0,179,0,137,0,205,0,0,0,0,0,219,0,154,0,19,0,0,0,227,0,76,0,101,0,122,0,236,0,179,0,206,0,51,0,3,0,124,0,197,0,0,0,231,0,232,0,154,0,138,0,145,0,0,0,178,0,108,0,107,0,0,0,153,0,162,0,80,0,0,0,0,0,22,0,239,0,164,0,34,0,0,0,232,0,178,0,179,0,12,0,72,0,63,0,0,0,46,0,173,0,91,0,0,0,25,0,130,0,56,0,131,0,49,0,90,0,27,0,113,0,182,0,178,0,35,0,0,0,35,0,96,0,0,0,156,0,253,0,64,0,114,0,109,0,0,0,0,0,0,0,249,0,252,0,85,0,25,0,239,0,0,0,130,0,69,0,0,0,50,0,39,0,91,0,225,0,252,0,161,0,0,0,198,0,247,0,55,0,155,0,0,0,3,0,237,0,11,0,80,0,223,0,199,0,192,0,40,0,81,0,183,0,190,0,170,0,0,0,0,0,46,0,164,0,56,0,0,0,0,0,157,0,255,0,5,0,235,0,69,0,178,0,86,0,199,0,248,0,250,0,233,0,58,0,6,0,194,0,226,0,0,0,187,0,0,0,217,0,70,0,19,0,148,0,105,0,230,0,124,0,208,0,32,0,61,0,0,0,167,0,41,0,30,0,229,0,206,0,95,0,6,0,23,0,0,0,58,0,104,0,0,0,132,0,238,0,240,0,30,0,14,0,78,0,166,0,0,0,104,0,181,0,26,0,150,0,177,0,87,0,165,0,0,0,61,0,23,0,84,0,44,0,49,0,244,0,74,0,69,0,84,0,36,0,82,0,255,0,0,0,0,0,0,0,166,0,15,0,0,0,118,0,43,0,118,0,158,0,199,0,12,0,0,0,5,0,63,0,76,0,163,0,127,0,25,0,178,0,235,0,0,0,11,0,2,0,70,0,134,0,92,0,179,0,254,0,88,0,170,0,166,0,17,0,0,0,0,0,0,0,0,0,62,0,157,0,175,0,34,0,54,0,27,0,0,0,166,0,237,0,226,0,0,0,72,0,245,0,58,0,202,0,0,0,0,0,168,0,134,0,39,0,167,0,0,0,64,0,124,0,24,0,0,0,163,0,151,0,250,0,139,0,229,0,235,0,232,0,0,0,100,0,167,0,99,0,114,0,48,0,200,0,241,0,180,0,92,0,0,0,156,0,169,0,56,0,196,0,0,0,122,0,92,0,30,0,174,0,48,0,160,0,150,0,190,0,125,0,222,0,139,0,28,0,191,0,0,0,0,0,0,0,35,0,152,0,86,0,71,0,193,0);
signal scenario_full  : scenario_type := (128,31,152,31,152,30,152,29,4,31,24,31,11,31,87,31,87,30,62,31,94,31,202,31,202,30,108,31,172,31,109,31,34,31,114,31,114,30,114,29,138,31,138,30,216,31,110,31,113,31,24,31,24,30,24,29,137,31,137,30,82,31,96,31,96,30,155,31,155,30,139,31,62,31,241,31,174,31,114,31,40,31,73,31,156,31,156,30,116,31,199,31,39,31,103,31,244,31,158,31,118,31,229,31,229,30,154,31,154,30,63,31,231,31,98,31,68,31,1,31,75,31,226,31,176,31,176,30,5,31,217,31,2,31,176,31,26,31,26,30,80,31,80,30,52,31,52,31,214,31,53,31,151,31,18,31,75,31,75,30,75,29,21,31,147,31,208,31,208,30,157,31,131,31,236,31,236,30,150,31,150,30,24,31,218,31,238,31,48,31,124,31,124,30,243,31,73,31,180,31,135,31,135,30,101,31,158,31,158,30,224,31,229,31,141,31,100,31,196,31,155,31,38,31,70,31,239,31,103,31,103,30,160,31,96,31,180,31,9,31,151,31,157,31,255,31,248,31,248,30,50,31,18,31,40,31,236,31,84,31,84,30,66,31,32,31,197,31,197,30,197,29,81,31,25,31,51,31,51,30,245,31,76,31,99,31,9,31,247,31,144,31,144,30,205,31,232,31,232,30,61,31,162,31,95,31,247,31,209,31,201,31,71,31,129,31,239,31,239,30,11,31,179,31,80,31,131,31,131,30,130,31,211,31,249,31,251,31,20,31,237,31,142,31,175,31,191,31,86,31,83,31,83,30,83,29,203,31,226,31,77,31,222,31,2,31,148,31,118,31,118,30,126,31,99,31,234,31,27,31,45,31,232,31,219,31,124,31,133,31,187,31,165,31,6,31,76,31,76,30,10,31,221,31,69,31,69,30,222,31,23,31,217,31,207,31,116,31,116,30,206,31,27,31,27,30,22,31,200,31,34,31,100,31,100,30,131,31,249,31,12,31,12,30,104,31,213,31,149,31,37,31,180,31,228,31,118,31,54,31,77,31,117,31,117,30,125,31,125,30,145,31,251,31,81,31,156,31,216,31,216,30,184,31,57,31,150,31,197,31,197,30,199,31,199,30,86,31,86,30,50,31,134,31,32,31,57,31,57,30,35,31,252,31,150,31,34,31,88,31,154,31,154,30,106,31,2,31,144,31,144,30,201,31,184,31,182,31,182,30,178,31,213,31,227,31,203,31,203,30,110,31,108,31,161,31,161,30,101,31,13,31,216,31,103,31,129,31,129,30,46,31,220,31,241,31,47,31,56,31,110,31,110,30,110,29,110,28,30,31,109,31,230,31,247,31,37,31,236,31,4,31,255,31,245,31,128,31,123,31,188,31,175,31,175,30,46,31,151,31,28,31,19,31,230,31,145,31,107,31,68,31,253,31,52,31,52,30,10,31,10,30,169,31,241,31,174,31,157,31,157,30,133,31,63,31,63,30,228,31,59,31,253,31,105,31,105,30,80,31,104,31,96,31,62,31,57,31,240,31,218,31,213,31,254,31,179,31,190,31,190,30,211,31,179,31,34,31,166,31,102,31,102,30,126,31,126,30,236,31,73,31,113,31,209,31,209,30,211,31,238,31,43,31,202,31,80,31,103,31,2,31,2,30,130,31,59,31,103,31,145,31,195,31,38,31,38,30,38,29,66,31,66,30,81,31,81,30,204,31,188,31,75,31,133,31,133,30,133,29,136,31,136,30,112,31,50,31,118,31,118,30,170,31,227,31,57,31,57,30,77,31,129,31,129,30,129,29,129,28,129,27,129,26,24,31,147,31,122,31,40,31,42,31,70,31,229,31,142,31,142,30,142,29,34,31,158,31,246,31,221,31,95,31,143,31,37,31,113,31,165,31,165,30,179,31,103,31,24,31,111,31,39,31,35,31,230,31,28,31,28,30,192,31,33,31,135,31,1,31,1,30,97,31,228,31,90,31,139,31,104,31,103,31,139,31,87,31,228,31,125,31,155,31,227,31,109,31,18,31,211,31,255,31,252,31,252,30,120,31,242,31,197,31,138,31,201,31,201,30,97,31,24,31,88,31,103,31,6,31,180,31,11,31,184,31,83,31,83,30,252,31,192,31,110,31,47,31,252,31,252,30,181,31,57,31,52,31,52,30,52,29,52,28,114,31,134,31,235,31,84,31,38,31,236,31,174,31,110,31,20,31,96,31,96,30,203,31,239,31,237,31,190,31,28,31,16,31,83,31,233,31,233,30,233,29,233,28,117,31,75,31,75,30,84,31,106,31,212,31,212,30,60,31,136,31,240,31,22,31,184,31,250,31,255,31,177,31,156,31,118,31,118,30,88,31,241,31,241,30,187,31,23,31,94,31,150,31,105,31,75,31,88,31,68,31,245,31,163,31,129,31,93,31,92,31,187,31,210,31,105,31,109,31,161,31,243,31,102,31,230,31,118,31,248,31,201,31,181,31,216,31,216,30,192,31,23,31,193,31,175,31,175,30,1,31,1,30,43,31,99,31,161,31,161,30,250,31,112,31,58,31,115,31,205,31,254,31,137,31,137,30,220,31,47,31,47,30,245,31,30,31,181,31,181,30,104,31,83,31,83,30,164,31,147,31,16,31,89,31,36,31,36,30,162,31,251,31,238,31,238,30,191,31,3,31,16,31,16,30,16,29,16,28,207,31,207,30,140,31,140,30,194,31,73,31,51,31,51,30,25,31,12,31,33,31,204,31,9,31,88,31,88,30,46,31,161,31,91,31,157,31,109,31,182,31,228,31,218,31,90,31,121,31,121,30,242,31,154,31,136,31,76,31,47,31,189,31,152,31,104,31,34,31,60,31,83,31,11,31,238,31,97,31,156,31,91,31,176,31,70,31,62,31,62,30,62,29,62,28,209,31,230,31,109,31,247,31,247,30,47,31,159,31,151,31,160,31,243,31,194,31,187,31,207,31,238,31,238,30,203,31,38,31,38,30,139,31,184,31,66,31,95,31,227,31,227,30,239,31,83,31,13,31,251,31,251,30,211,31,211,30,249,31,58,31,58,30,11,31,27,31,213,31,40,31,244,31,244,30,123,31,54,31,54,30,54,29,227,31,99,31,239,31,180,31,180,30,106,31,204,31,142,31,142,30,99,31,187,31,187,30,3,31,7,31,5,31,245,31,52,31,110,31,71,31,184,31,58,31,58,30,56,31,221,31,171,31,192,31,108,31,243,31,151,31,151,30,246,31,62,31,179,31,137,31,205,31,205,30,205,29,219,31,154,31,19,31,19,30,227,31,76,31,101,31,122,31,236,31,179,31,206,31,51,31,3,31,124,31,197,31,197,30,231,31,232,31,154,31,138,31,145,31,145,30,178,31,108,31,107,31,107,30,153,31,162,31,80,31,80,30,80,29,22,31,239,31,164,31,34,31,34,30,232,31,178,31,179,31,12,31,72,31,63,31,63,30,46,31,173,31,91,31,91,30,25,31,130,31,56,31,131,31,49,31,90,31,27,31,113,31,182,31,178,31,35,31,35,30,35,31,96,31,96,30,156,31,253,31,64,31,114,31,109,31,109,30,109,29,109,28,249,31,252,31,85,31,25,31,239,31,239,30,130,31,69,31,69,30,50,31,39,31,91,31,225,31,252,31,161,31,161,30,198,31,247,31,55,31,155,31,155,30,3,31,237,31,11,31,80,31,223,31,199,31,192,31,40,31,81,31,183,31,190,31,170,31,170,30,170,29,46,31,164,31,56,31,56,30,56,29,157,31,255,31,5,31,235,31,69,31,178,31,86,31,199,31,248,31,250,31,233,31,58,31,6,31,194,31,226,31,226,30,187,31,187,30,217,31,70,31,19,31,148,31,105,31,230,31,124,31,208,31,32,31,61,31,61,30,167,31,41,31,30,31,229,31,206,31,95,31,6,31,23,31,23,30,58,31,104,31,104,30,132,31,238,31,240,31,30,31,14,31,78,31,166,31,166,30,104,31,181,31,26,31,150,31,177,31,87,31,165,31,165,30,61,31,23,31,84,31,44,31,49,31,244,31,74,31,69,31,84,31,36,31,82,31,255,31,255,30,255,29,255,28,166,31,15,31,15,30,118,31,43,31,118,31,158,31,199,31,12,31,12,30,5,31,63,31,76,31,163,31,127,31,25,31,178,31,235,31,235,30,11,31,2,31,70,31,134,31,92,31,179,31,254,31,88,31,170,31,166,31,17,31,17,30,17,29,17,28,17,27,62,31,157,31,175,31,34,31,54,31,27,31,27,30,166,31,237,31,226,31,226,30,72,31,245,31,58,31,202,31,202,30,202,29,168,31,134,31,39,31,167,31,167,30,64,31,124,31,24,31,24,30,163,31,151,31,250,31,139,31,229,31,235,31,232,31,232,30,100,31,167,31,99,31,114,31,48,31,200,31,241,31,180,31,92,31,92,30,156,31,169,31,56,31,196,31,196,30,122,31,92,31,30,31,174,31,48,31,160,31,150,31,190,31,125,31,222,31,139,31,28,31,191,31,191,30,191,29,191,28,35,31,152,31,86,31,71,31,193,31);

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
