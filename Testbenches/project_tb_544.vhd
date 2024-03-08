-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_544 is
end project_tb_544;

architecture project_tb_arch_544 of project_tb_544 is
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

constant SCENARIO_LENGTH : integer := 1014;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,250,0,178,0,31,0,247,0,117,0,28,0,88,0,189,0,152,0,78,0,134,0,241,0,251,0,123,0,0,0,0,0,0,0,0,0,127,0,0,0,0,0,66,0,0,0,233,0,80,0,248,0,127,0,232,0,0,0,0,0,0,0,82,0,149,0,95,0,132,0,240,0,108,0,233,0,114,0,73,0,240,0,223,0,21,0,0,0,169,0,178,0,197,0,105,0,0,0,27,0,0,0,132,0,69,0,82,0,222,0,236,0,203,0,0,0,199,0,253,0,182,0,92,0,159,0,116,0,51,0,172,0,200,0,105,0,0,0,149,0,0,0,244,0,244,0,1,0,224,0,72,0,0,0,71,0,186,0,210,0,0,0,103,0,242,0,183,0,57,0,0,0,0,0,80,0,48,0,96,0,240,0,52,0,211,0,0,0,241,0,235,0,236,0,165,0,86,0,68,0,187,0,162,0,195,0,230,0,112,0,188,0,245,0,21,0,72,0,57,0,168,0,0,0,21,0,249,0,136,0,213,0,91,0,0,0,0,0,0,0,234,0,86,0,26,0,216,0,234,0,225,0,150,0,158,0,179,0,222,0,122,0,223,0,95,0,200,0,187,0,126,0,94,0,248,0,64,0,109,0,48,0,42,0,152,0,40,0,0,0,0,0,241,0,96,0,113,0,206,0,235,0,238,0,230,0,171,0,75,0,146,0,137,0,199,0,33,0,69,0,37,0,85,0,79,0,132,0,0,0,187,0,177,0,35,0,0,0,181,0,0,0,21,0,239,0,0,0,117,0,0,0,24,0,0,0,171,0,144,0,189,0,211,0,101,0,42,0,226,0,67,0,211,0,78,0,0,0,212,0,39,0,10,0,97,0,101,0,151,0,0,0,0,0,79,0,0,0,43,0,203,0,120,0,89,0,61,0,48,0,134,0,68,0,173,0,236,0,134,0,0,0,249,0,22,0,0,0,217,0,0,0,146,0,10,0,22,0,250,0,172,0,105,0,12,0,72,0,118,0,202,0,50,0,101,0,0,0,231,0,139,0,139,0,31,0,162,0,50,0,255,0,175,0,163,0,150,0,157,0,19,0,0,0,123,0,231,0,15,0,106,0,0,0,187,0,0,0,0,0,230,0,0,0,20,0,237,0,93,0,0,0,104,0,0,0,154,0,33,0,204,0,0,0,128,0,114,0,0,0,103,0,176,0,231,0,255,0,200,0,0,0,134,0,243,0,15,0,61,0,94,0,42,0,0,0,59,0,0,0,0,0,0,0,156,0,59,0,13,0,46,0,97,0,122,0,247,0,0,0,137,0,0,0,28,0,0,0,148,0,40,0,174,0,157,0,0,0,219,0,100,0,90,0,240,0,81,0,0,0,199,0,250,0,209,0,210,0,51,0,58,0,148,0,0,0,243,0,32,0,96,0,178,0,0,0,56,0,233,0,6,0,53,0,243,0,253,0,0,0,0,0,158,0,70,0,169,0,96,0,76,0,209,0,5,0,92,0,28,0,86,0,27,0,50,0,0,0,0,0,0,0,110,0,0,0,107,0,84,0,9,0,41,0,130,0,187,0,47,0,82,0,74,0,122,0,0,0,86,0,0,0,26,0,211,0,209,0,125,0,105,0,182,0,229,0,0,0,26,0,0,0,7,0,0,0,96,0,14,0,87,0,0,0,0,0,0,0,31,0,0,0,82,0,236,0,233,0,0,0,197,0,121,0,36,0,243,0,95,0,8,0,178,0,96,0,194,0,35,0,2,0,14,0,0,0,64,0,205,0,15,0,0,0,0,0,198,0,185,0,252,0,249,0,0,0,125,0,133,0,182,0,129,0,211,0,0,0,188,0,176,0,0,0,0,0,0,0,0,0,176,0,152,0,236,0,118,0,212,0,251,0,0,0,135,0,222,0,0,0,59,0,250,0,128,0,185,0,29,0,57,0,20,0,0,0,16,0,0,0,130,0,253,0,88,0,0,0,49,0,87,0,0,0,15,0,77,0,157,0,2,0,0,0,0,0,213,0,242,0,166,0,157,0,60,0,0,0,154,0,74,0,19,0,70,0,159,0,217,0,0,0,0,0,238,0,187,0,232,0,70,0,0,0,0,0,242,0,6,0,0,0,195,0,154,0,44,0,199,0,118,0,0,0,91,0,248,0,162,0,199,0,0,0,50,0,0,0,42,0,0,0,214,0,129,0,10,0,169,0,130,0,106,0,139,0,145,0,142,0,173,0,0,0,64,0,96,0,0,0,157,0,123,0,28,0,0,0,233,0,68,0,224,0,0,0,74,0,221,0,0,0,81,0,47,0,104,0,233,0,0,0,48,0,206,0,162,0,5,0,106,0,46,0,105,0,0,0,225,0,100,0,246,0,64,0,112,0,20,0,204,0,53,0,91,0,202,0,28,0,0,0,172,0,195,0,34,0,131,0,6,0,104,0,227,0,150,0,247,0,0,0,205,0,69,0,0,0,97,0,221,0,242,0,0,0,203,0,190,0,206,0,23,0,0,0,217,0,123,0,15,0,158,0,213,0,13,0,59,0,125,0,46,0,148,0,34,0,0,0,139,0,44,0,171,0,85,0,2,0,91,0,165,0,13,0,40,0,0,0,55,0,75,0,232,0,10,0,0,0,234,0,123,0,247,0,71,0,146,0,85,0,181,0,115,0,0,0,237,0,0,0,176,0,141,0,101,0,188,0,104,0,197,0,39,0,191,0,125,0,242,0,0,0,131,0,20,0,224,0,224,0,193,0,0,0,0,0,135,0,0,0,122,0,173,0,0,0,175,0,0,0,196,0,0,0,122,0,254,0,175,0,55,0,224,0,234,0,160,0,239,0,53,0,231,0,112,0,169,0,0,0,166,0,108,0,79,0,0,0,138,0,109,0,0,0,252,0,163,0,101,0,0,0,0,0,104,0,70,0,241,0,170,0,10,0,0,0,180,0,64,0,114,0,142,0,0,0,3,0,0,0,249,0,209,0,98,0,45,0,156,0,129,0,181,0,128,0,69,0,0,0,0,0,162,0,193,0,67,0,102,0,13,0,173,0,159,0,0,0,9,0,0,0,98,0,13,0,224,0,118,0,126,0,67,0,151,0,210,0,161,0,217,0,139,0,219,0,149,0,181,0,25,0,0,0,20,0,159,0,217,0,0,0,0,0,0,0,72,0,140,0,208,0,252,0,58,0,68,0,0,0,208,0,230,0,65,0,67,0,192,0,171,0,86,0,213,0,165,0,141,0,255,0,158,0,219,0,253,0,197,0,66,0,100,0,15,0,28,0,91,0,223,0,196,0,95,0,0,0,202,0,93,0,69,0,0,0,51,0,0,0,57,0,63,0,99,0,2,0,79,0,134,0,255,0,189,0,26,0,0,0,0,0,14,0,180,0,111,0,0,0,220,0,158,0,71,0,54,0,101,0,38,0,0,0,166,0,27,0,0,0,208,0,29,0,0,0,161,0,6,0,144,0,222,0,147,0,0,0,250,0,212,0,63,0,6,0,38,0,0,0,0,0,112,0,201,0,78,0,16,0,37,0,108,0,168,0,31,0,223,0,155,0,48,0,176,0,0,0,159,0,13,0,0,0,0,0,255,0,0,0,185,0,79,0,56,0,37,0,57,0,0,0,156,0,202,0,170,0,192,0,194,0,0,0,218,0,51,0,255,0,130,0,0,0,0,0,62,0,0,0,0,0,226,0,80,0,0,0,0,0,0,0,120,0,244,0,76,0,0,0,98,0,40,0,0,0,241,0,232,0,224,0,55,0,96,0,52,0,183,0,227,0,215,0,240,0,57,0,48,0,119,0,52,0,0,0,81,0,0,0,117,0,106,0,46,0,169,0,72,0,139,0,118,0,107,0,146,0,42,0,189,0,120,0,100,0,211,0,14,0,233,0,230,0,62,0,27,0,0,0,0,0,0,0,169,0,138,0,169,0,56,0,0,0,0,0,0,0,0,0,95,0,98,0,196,0,252,0,228,0,163,0,149,0,181,0,238,0,17,0,15,0,199,0,127,0,89,0,106,0,0,0,0,0,88,0,0,0,118,0,112,0,188,0,225,0,54,0,53,0,126,0,78,0,15,0,46,0,123,0,247,0,0,0,146,0,138,0,199,0,229,0,0,0,17,0,0,0,9,0,0,0,242,0,11,0,85,0,163,0,31,0,134,0,0,0,206,0,36,0,51,0,0,0,54,0,0,0,17,0,160,0,82,0,0,0,69,0,31,0,214,0,172,0,225,0,31,0,0,0,240,0,0,0,49,0,39,0,142,0,0,0,0,0,0,0,255,0,153,0,146,0,169,0,0,0,135,0,81,0,226,0,10,0,1,0,211,0,1,0,0,0,132,0,192,0,29,0,70,0,175,0,46,0,38,0,221,0,244,0,111,0,1,0,0,0,15,0,182,0,86,0,173,0,239,0,17,0,0,0,149,0,99,0,171,0,243,0,186,0,0,0,241,0,0,0,153,0,146,0,159,0,203,0,0,0,165,0,75,0,0,0,168,0,0,0,237,0,194,0,209,0,67,0,64,0,200,0,26,0,0,0,110,0);
signal scenario_full  : scenario_type := (0,0,250,31,178,31,31,31,247,31,117,31,28,31,88,31,189,31,152,31,78,31,134,31,241,31,251,31,123,31,123,30,123,29,123,28,123,27,127,31,127,30,127,29,66,31,66,30,233,31,80,31,248,31,127,31,232,31,232,30,232,29,232,28,82,31,149,31,95,31,132,31,240,31,108,31,233,31,114,31,73,31,240,31,223,31,21,31,21,30,169,31,178,31,197,31,105,31,105,30,27,31,27,30,132,31,69,31,82,31,222,31,236,31,203,31,203,30,199,31,253,31,182,31,92,31,159,31,116,31,51,31,172,31,200,31,105,31,105,30,149,31,149,30,244,31,244,31,1,31,224,31,72,31,72,30,71,31,186,31,210,31,210,30,103,31,242,31,183,31,57,31,57,30,57,29,80,31,48,31,96,31,240,31,52,31,211,31,211,30,241,31,235,31,236,31,165,31,86,31,68,31,187,31,162,31,195,31,230,31,112,31,188,31,245,31,21,31,72,31,57,31,168,31,168,30,21,31,249,31,136,31,213,31,91,31,91,30,91,29,91,28,234,31,86,31,26,31,216,31,234,31,225,31,150,31,158,31,179,31,222,31,122,31,223,31,95,31,200,31,187,31,126,31,94,31,248,31,64,31,109,31,48,31,42,31,152,31,40,31,40,30,40,29,241,31,96,31,113,31,206,31,235,31,238,31,230,31,171,31,75,31,146,31,137,31,199,31,33,31,69,31,37,31,85,31,79,31,132,31,132,30,187,31,177,31,35,31,35,30,181,31,181,30,21,31,239,31,239,30,117,31,117,30,24,31,24,30,171,31,144,31,189,31,211,31,101,31,42,31,226,31,67,31,211,31,78,31,78,30,212,31,39,31,10,31,97,31,101,31,151,31,151,30,151,29,79,31,79,30,43,31,203,31,120,31,89,31,61,31,48,31,134,31,68,31,173,31,236,31,134,31,134,30,249,31,22,31,22,30,217,31,217,30,146,31,10,31,22,31,250,31,172,31,105,31,12,31,72,31,118,31,202,31,50,31,101,31,101,30,231,31,139,31,139,31,31,31,162,31,50,31,255,31,175,31,163,31,150,31,157,31,19,31,19,30,123,31,231,31,15,31,106,31,106,30,187,31,187,30,187,29,230,31,230,30,20,31,237,31,93,31,93,30,104,31,104,30,154,31,33,31,204,31,204,30,128,31,114,31,114,30,103,31,176,31,231,31,255,31,200,31,200,30,134,31,243,31,15,31,61,31,94,31,42,31,42,30,59,31,59,30,59,29,59,28,156,31,59,31,13,31,46,31,97,31,122,31,247,31,247,30,137,31,137,30,28,31,28,30,148,31,40,31,174,31,157,31,157,30,219,31,100,31,90,31,240,31,81,31,81,30,199,31,250,31,209,31,210,31,51,31,58,31,148,31,148,30,243,31,32,31,96,31,178,31,178,30,56,31,233,31,6,31,53,31,243,31,253,31,253,30,253,29,158,31,70,31,169,31,96,31,76,31,209,31,5,31,92,31,28,31,86,31,27,31,50,31,50,30,50,29,50,28,110,31,110,30,107,31,84,31,9,31,41,31,130,31,187,31,47,31,82,31,74,31,122,31,122,30,86,31,86,30,26,31,211,31,209,31,125,31,105,31,182,31,229,31,229,30,26,31,26,30,7,31,7,30,96,31,14,31,87,31,87,30,87,29,87,28,31,31,31,30,82,31,236,31,233,31,233,30,197,31,121,31,36,31,243,31,95,31,8,31,178,31,96,31,194,31,35,31,2,31,14,31,14,30,64,31,205,31,15,31,15,30,15,29,198,31,185,31,252,31,249,31,249,30,125,31,133,31,182,31,129,31,211,31,211,30,188,31,176,31,176,30,176,29,176,28,176,27,176,31,152,31,236,31,118,31,212,31,251,31,251,30,135,31,222,31,222,30,59,31,250,31,128,31,185,31,29,31,57,31,20,31,20,30,16,31,16,30,130,31,253,31,88,31,88,30,49,31,87,31,87,30,15,31,77,31,157,31,2,31,2,30,2,29,213,31,242,31,166,31,157,31,60,31,60,30,154,31,74,31,19,31,70,31,159,31,217,31,217,30,217,29,238,31,187,31,232,31,70,31,70,30,70,29,242,31,6,31,6,30,195,31,154,31,44,31,199,31,118,31,118,30,91,31,248,31,162,31,199,31,199,30,50,31,50,30,42,31,42,30,214,31,129,31,10,31,169,31,130,31,106,31,139,31,145,31,142,31,173,31,173,30,64,31,96,31,96,30,157,31,123,31,28,31,28,30,233,31,68,31,224,31,224,30,74,31,221,31,221,30,81,31,47,31,104,31,233,31,233,30,48,31,206,31,162,31,5,31,106,31,46,31,105,31,105,30,225,31,100,31,246,31,64,31,112,31,20,31,204,31,53,31,91,31,202,31,28,31,28,30,172,31,195,31,34,31,131,31,6,31,104,31,227,31,150,31,247,31,247,30,205,31,69,31,69,30,97,31,221,31,242,31,242,30,203,31,190,31,206,31,23,31,23,30,217,31,123,31,15,31,158,31,213,31,13,31,59,31,125,31,46,31,148,31,34,31,34,30,139,31,44,31,171,31,85,31,2,31,91,31,165,31,13,31,40,31,40,30,55,31,75,31,232,31,10,31,10,30,234,31,123,31,247,31,71,31,146,31,85,31,181,31,115,31,115,30,237,31,237,30,176,31,141,31,101,31,188,31,104,31,197,31,39,31,191,31,125,31,242,31,242,30,131,31,20,31,224,31,224,31,193,31,193,30,193,29,135,31,135,30,122,31,173,31,173,30,175,31,175,30,196,31,196,30,122,31,254,31,175,31,55,31,224,31,234,31,160,31,239,31,53,31,231,31,112,31,169,31,169,30,166,31,108,31,79,31,79,30,138,31,109,31,109,30,252,31,163,31,101,31,101,30,101,29,104,31,70,31,241,31,170,31,10,31,10,30,180,31,64,31,114,31,142,31,142,30,3,31,3,30,249,31,209,31,98,31,45,31,156,31,129,31,181,31,128,31,69,31,69,30,69,29,162,31,193,31,67,31,102,31,13,31,173,31,159,31,159,30,9,31,9,30,98,31,13,31,224,31,118,31,126,31,67,31,151,31,210,31,161,31,217,31,139,31,219,31,149,31,181,31,25,31,25,30,20,31,159,31,217,31,217,30,217,29,217,28,72,31,140,31,208,31,252,31,58,31,68,31,68,30,208,31,230,31,65,31,67,31,192,31,171,31,86,31,213,31,165,31,141,31,255,31,158,31,219,31,253,31,197,31,66,31,100,31,15,31,28,31,91,31,223,31,196,31,95,31,95,30,202,31,93,31,69,31,69,30,51,31,51,30,57,31,63,31,99,31,2,31,79,31,134,31,255,31,189,31,26,31,26,30,26,29,14,31,180,31,111,31,111,30,220,31,158,31,71,31,54,31,101,31,38,31,38,30,166,31,27,31,27,30,208,31,29,31,29,30,161,31,6,31,144,31,222,31,147,31,147,30,250,31,212,31,63,31,6,31,38,31,38,30,38,29,112,31,201,31,78,31,16,31,37,31,108,31,168,31,31,31,223,31,155,31,48,31,176,31,176,30,159,31,13,31,13,30,13,29,255,31,255,30,185,31,79,31,56,31,37,31,57,31,57,30,156,31,202,31,170,31,192,31,194,31,194,30,218,31,51,31,255,31,130,31,130,30,130,29,62,31,62,30,62,29,226,31,80,31,80,30,80,29,80,28,120,31,244,31,76,31,76,30,98,31,40,31,40,30,241,31,232,31,224,31,55,31,96,31,52,31,183,31,227,31,215,31,240,31,57,31,48,31,119,31,52,31,52,30,81,31,81,30,117,31,106,31,46,31,169,31,72,31,139,31,118,31,107,31,146,31,42,31,189,31,120,31,100,31,211,31,14,31,233,31,230,31,62,31,27,31,27,30,27,29,27,28,169,31,138,31,169,31,56,31,56,30,56,29,56,28,56,27,95,31,98,31,196,31,252,31,228,31,163,31,149,31,181,31,238,31,17,31,15,31,199,31,127,31,89,31,106,31,106,30,106,29,88,31,88,30,118,31,112,31,188,31,225,31,54,31,53,31,126,31,78,31,15,31,46,31,123,31,247,31,247,30,146,31,138,31,199,31,229,31,229,30,17,31,17,30,9,31,9,30,242,31,11,31,85,31,163,31,31,31,134,31,134,30,206,31,36,31,51,31,51,30,54,31,54,30,17,31,160,31,82,31,82,30,69,31,31,31,214,31,172,31,225,31,31,31,31,30,240,31,240,30,49,31,39,31,142,31,142,30,142,29,142,28,255,31,153,31,146,31,169,31,169,30,135,31,81,31,226,31,10,31,1,31,211,31,1,31,1,30,132,31,192,31,29,31,70,31,175,31,46,31,38,31,221,31,244,31,111,31,1,31,1,30,15,31,182,31,86,31,173,31,239,31,17,31,17,30,149,31,99,31,171,31,243,31,186,31,186,30,241,31,241,30,153,31,146,31,159,31,203,31,203,30,165,31,75,31,75,30,168,31,168,30,237,31,194,31,209,31,67,31,64,31,200,31,26,31,26,30,110,31);

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
