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

constant SCENARIO_LENGTH : integer := 976;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (44,0,165,0,15,0,174,0,214,0,143,0,6,0,154,0,202,0,107,0,109,0,63,0,0,0,28,0,156,0,10,0,21,0,111,0,190,0,0,0,1,0,202,0,0,0,0,0,17,0,181,0,169,0,0,0,0,0,0,0,21,0,42,0,227,0,53,0,190,0,42,0,34,0,224,0,51,0,106,0,0,0,15,0,0,0,0,0,185,0,0,0,218,0,0,0,236,0,83,0,83,0,0,0,198,0,222,0,0,0,198,0,17,0,58,0,219,0,128,0,19,0,19,0,140,0,99,0,0,0,176,0,51,0,117,0,0,0,239,0,60,0,226,0,23,0,0,0,175,0,18,0,53,0,78,0,0,0,241,0,21,0,238,0,0,0,0,0,67,0,105,0,211,0,211,0,0,0,104,0,34,0,98,0,213,0,190,0,105,0,29,0,68,0,220,0,52,0,0,0,183,0,56,0,147,0,50,0,138,0,92,0,0,0,142,0,51,0,187,0,206,0,5,0,110,0,109,0,238,0,5,0,67,0,138,0,237,0,10,0,197,0,94,0,244,0,110,0,0,0,251,0,171,0,220,0,0,0,92,0,74,0,0,0,137,0,59,0,190,0,0,0,73,0,0,0,251,0,27,0,68,0,234,0,47,0,0,0,216,0,0,0,121,0,44,0,113,0,0,0,0,0,197,0,0,0,153,0,0,0,0,0,0,0,178,0,76,0,28,0,193,0,169,0,21,0,191,0,56,0,70,0,219,0,74,0,56,0,183,0,0,0,68,0,0,0,29,0,231,0,202,0,195,0,128,0,238,0,116,0,109,0,166,0,175,0,151,0,106,0,34,0,154,0,0,0,214,0,0,0,0,0,204,0,52,0,0,0,0,0,174,0,209,0,0,0,196,0,109,0,194,0,0,0,129,0,29,0,53,0,211,0,121,0,64,0,44,0,137,0,182,0,0,0,198,0,192,0,191,0,166,0,215,0,159,0,64,0,52,0,0,0,154,0,17,0,27,0,75,0,0,0,0,0,92,0,207,0,104,0,0,0,152,0,14,0,92,0,229,0,169,0,125,0,224,0,79,0,10,0,103,0,242,0,75,0,0,0,0,0,76,0,0,0,212,0,0,0,44,0,142,0,145,0,247,0,0,0,99,0,200,0,203,0,1,0,126,0,143,0,22,0,204,0,150,0,44,0,196,0,150,0,38,0,99,0,127,0,0,0,0,0,209,0,0,0,163,0,22,0,202,0,33,0,252,0,122,0,14,0,147,0,0,0,160,0,107,0,74,0,118,0,0,0,0,0,0,0,228,0,11,0,0,0,17,0,147,0,0,0,24,0,93,0,155,0,69,0,239,0,111,0,199,0,115,0,160,0,125,0,18,0,13,0,98,0,0,0,0,0,184,0,41,0,196,0,172,0,174,0,253,0,204,0,133,0,10,0,0,0,177,0,0,0,42,0,49,0,0,0,0,0,87,0,0,0,130,0,37,0,138,0,0,0,0,0,8,0,124,0,108,0,82,0,173,0,0,0,165,0,0,0,2,0,110,0,123,0,19,0,162,0,152,0,0,0,38,0,124,0,148,0,21,0,15,0,241,0,0,0,187,0,7,0,0,0,0,0,234,0,0,0,24,0,163,0,0,0,208,0,59,0,142,0,252,0,241,0,250,0,0,0,0,0,248,0,0,0,160,0,100,0,164,0,54,0,229,0,141,0,251,0,193,0,104,0,138,0,233,0,55,0,98,0,0,0,221,0,145,0,0,0,4,0,32,0,57,0,14,0,50,0,179,0,248,0,125,0,3,0,183,0,0,0,162,0,220,0,110,0,200,0,228,0,207,0,222,0,212,0,74,0,42,0,173,0,95,0,0,0,2,0,82,0,172,0,119,0,231,0,245,0,28,0,231,0,93,0,225,0,150,0,0,0,67,0,0,0,118,0,199,0,0,0,95,0,238,0,28,0,147,0,114,0,224,0,5,0,146,0,232,0,215,0,197,0,124,0,147,0,13,0,0,0,0,0,166,0,108,0,3,0,143,0,126,0,0,0,70,0,29,0,0,0,214,0,52,0,180,0,112,0,48,0,188,0,232,0,0,0,32,0,38,0,168,0,206,0,6,0,2,0,142,0,212,0,112,0,82,0,71,0,66,0,52,0,56,0,198,0,68,0,0,0,155,0,0,0,0,0,176,0,0,0,0,0,15,0,61,0,165,0,187,0,0,0,188,0,155,0,0,0,168,0,0,0,0,0,180,0,0,0,205,0,0,0,0,0,238,0,6,0,48,0,221,0,21,0,27,0,127,0,0,0,234,0,85,0,109,0,0,0,196,0,182,0,156,0,94,0,216,0,0,0,0,0,0,0,175,0,20,0,49,0,240,0,170,0,67,0,0,0,60,0,0,0,172,0,119,0,0,0,158,0,0,0,3,0,40,0,14,0,91,0,0,0,148,0,182,0,119,0,247,0,142,0,177,0,141,0,0,0,123,0,72,0,183,0,115,0,0,0,69,0,57,0,3,0,44,0,60,0,0,0,63,0,0,0,80,0,185,0,100,0,187,0,0,0,2,0,100,0,196,0,209,0,14,0,109,0,0,0,231,0,255,0,249,0,0,0,0,0,173,0,228,0,25,0,108,0,183,0,115,0,0,0,53,0,61,0,183,0,0,0,0,0,243,0,0,0,77,0,56,0,210,0,201,0,80,0,103,0,0,0,210,0,57,0,170,0,0,0,116,0,89,0,217,0,160,0,141,0,0,0,0,0,207,0,138,0,137,0,131,0,0,0,104,0,218,0,57,0,233,0,0,0,198,0,22,0,177,0,16,0,46,0,50,0,90,0,252,0,0,0,22,0,0,0,81,0,83,0,123,0,0,0,68,0,229,0,111,0,246,0,0,0,236,0,0,0,212,0,233,0,218,0,0,0,35,0,0,0,0,0,0,0,207,0,252,0,168,0,245,0,52,0,143,0,0,0,104,0,0,0,139,0,178,0,107,0,0,0,228,0,0,0,50,0,149,0,132,0,70,0,0,0,240,0,154,0,0,0,0,0,121,0,56,0,141,0,181,0,154,0,162,0,117,0,246,0,106,0,0,0,63,0,29,0,122,0,194,0,175,0,41,0,40,0,47,0,209,0,133,0,189,0,0,0,0,0,0,0,0,0,0,0,103,0,67,0,0,0,22,0,83,0,145,0,199,0,149,0,121,0,6,0,0,0,221,0,93,0,176,0,82,0,112,0,246,0,59,0,209,0,162,0,252,0,91,0,203,0,0,0,41,0,175,0,123,0,0,0,0,0,193,0,173,0,0,0,156,0,52,0,227,0,159,0,134,0,66,0,55,0,0,0,135,0,110,0,0,0,33,0,0,0,49,0,0,0,166,0,169,0,220,0,87,0,68,0,208,0,120,0,123,0,52,0,35,0,0,0,96,0,64,0,77,0,151,0,88,0,89,0,70,0,143,0,121,0,0,0,0,0,135,0,92,0,247,0,60,0,110,0,252,0,113,0,54,0,128,0,113,0,83,0,144,0,0,0,2,0,0,0,66,0,135,0,134,0,131,0,230,0,0,0,0,0,0,0,61,0,134,0,200,0,0,0,248,0,0,0,110,0,0,0,229,0,0,0,223,0,0,0,0,0,162,0,39,0,0,0,218,0,0,0,46,0,168,0,208,0,78,0,187,0,108,0,176,0,229,0,11,0,88,0,223,0,209,0,0,0,43,0,215,0,0,0,29,0,204,0,237,0,218,0,0,0,81,0,214,0,0,0,175,0,14,0,189,0,71,0,187,0,0,0,0,0,67,0,0,0,149,0,67,0,92,0,193,0,0,0,96,0,75,0,39,0,147,0,122,0,152,0,28,0,253,0,214,0,0,0,94,0,61,0,231,0,17,0,108,0,69,0,189,0,86,0,60,0,83,0,23,0,0,0,229,0,198,0,109,0,0,0,243,0,0,0,102,0,0,0,190,0,22,0,0,0,137,0,158,0,110,0,136,0,0,0,209,0,225,0,225,0,136,0,199,0,28,0,251,0,241,0,105,0,202,0,29,0,52,0,232,0,2,0,230,0,0,0,180,0,39,0,11,0,52,0,73,0,228,0,0,0,2,0,143,0,187,0,0,0,29,0,162,0,112,0,0,0,86,0,180,0,226,0,86,0,29,0,219,0,192,0,0,0,203,0,0,0,20,0,0,0,0,0,0,0,143,0,37,0,0,0,185,0,133,0,169,0,96,0,100,0,150,0,117,0,236,0,28,0,0,0,144,0,0,0,0,0,175,0,0,0,25,0,190,0,0,0,229,0,195,0,82,0,175,0,116,0,253,0,199,0,77,0,0,0,135,0,0,0,237,0,246,0,230,0,67,0,252,0,248,0,0,0,0,0,168,0,0,0);
signal scenario_full  : scenario_type := (44,31,165,31,15,31,174,31,214,31,143,31,6,31,154,31,202,31,107,31,109,31,63,31,63,30,28,31,156,31,10,31,21,31,111,31,190,31,190,30,1,31,202,31,202,30,202,29,17,31,181,31,169,31,169,30,169,29,169,28,21,31,42,31,227,31,53,31,190,31,42,31,34,31,224,31,51,31,106,31,106,30,15,31,15,30,15,29,185,31,185,30,218,31,218,30,236,31,83,31,83,31,83,30,198,31,222,31,222,30,198,31,17,31,58,31,219,31,128,31,19,31,19,31,140,31,99,31,99,30,176,31,51,31,117,31,117,30,239,31,60,31,226,31,23,31,23,30,175,31,18,31,53,31,78,31,78,30,241,31,21,31,238,31,238,30,238,29,67,31,105,31,211,31,211,31,211,30,104,31,34,31,98,31,213,31,190,31,105,31,29,31,68,31,220,31,52,31,52,30,183,31,56,31,147,31,50,31,138,31,92,31,92,30,142,31,51,31,187,31,206,31,5,31,110,31,109,31,238,31,5,31,67,31,138,31,237,31,10,31,197,31,94,31,244,31,110,31,110,30,251,31,171,31,220,31,220,30,92,31,74,31,74,30,137,31,59,31,190,31,190,30,73,31,73,30,251,31,27,31,68,31,234,31,47,31,47,30,216,31,216,30,121,31,44,31,113,31,113,30,113,29,197,31,197,30,153,31,153,30,153,29,153,28,178,31,76,31,28,31,193,31,169,31,21,31,191,31,56,31,70,31,219,31,74,31,56,31,183,31,183,30,68,31,68,30,29,31,231,31,202,31,195,31,128,31,238,31,116,31,109,31,166,31,175,31,151,31,106,31,34,31,154,31,154,30,214,31,214,30,214,29,204,31,52,31,52,30,52,29,174,31,209,31,209,30,196,31,109,31,194,31,194,30,129,31,29,31,53,31,211,31,121,31,64,31,44,31,137,31,182,31,182,30,198,31,192,31,191,31,166,31,215,31,159,31,64,31,52,31,52,30,154,31,17,31,27,31,75,31,75,30,75,29,92,31,207,31,104,31,104,30,152,31,14,31,92,31,229,31,169,31,125,31,224,31,79,31,10,31,103,31,242,31,75,31,75,30,75,29,76,31,76,30,212,31,212,30,44,31,142,31,145,31,247,31,247,30,99,31,200,31,203,31,1,31,126,31,143,31,22,31,204,31,150,31,44,31,196,31,150,31,38,31,99,31,127,31,127,30,127,29,209,31,209,30,163,31,22,31,202,31,33,31,252,31,122,31,14,31,147,31,147,30,160,31,107,31,74,31,118,31,118,30,118,29,118,28,228,31,11,31,11,30,17,31,147,31,147,30,24,31,93,31,155,31,69,31,239,31,111,31,199,31,115,31,160,31,125,31,18,31,13,31,98,31,98,30,98,29,184,31,41,31,196,31,172,31,174,31,253,31,204,31,133,31,10,31,10,30,177,31,177,30,42,31,49,31,49,30,49,29,87,31,87,30,130,31,37,31,138,31,138,30,138,29,8,31,124,31,108,31,82,31,173,31,173,30,165,31,165,30,2,31,110,31,123,31,19,31,162,31,152,31,152,30,38,31,124,31,148,31,21,31,15,31,241,31,241,30,187,31,7,31,7,30,7,29,234,31,234,30,24,31,163,31,163,30,208,31,59,31,142,31,252,31,241,31,250,31,250,30,250,29,248,31,248,30,160,31,100,31,164,31,54,31,229,31,141,31,251,31,193,31,104,31,138,31,233,31,55,31,98,31,98,30,221,31,145,31,145,30,4,31,32,31,57,31,14,31,50,31,179,31,248,31,125,31,3,31,183,31,183,30,162,31,220,31,110,31,200,31,228,31,207,31,222,31,212,31,74,31,42,31,173,31,95,31,95,30,2,31,82,31,172,31,119,31,231,31,245,31,28,31,231,31,93,31,225,31,150,31,150,30,67,31,67,30,118,31,199,31,199,30,95,31,238,31,28,31,147,31,114,31,224,31,5,31,146,31,232,31,215,31,197,31,124,31,147,31,13,31,13,30,13,29,166,31,108,31,3,31,143,31,126,31,126,30,70,31,29,31,29,30,214,31,52,31,180,31,112,31,48,31,188,31,232,31,232,30,32,31,38,31,168,31,206,31,6,31,2,31,142,31,212,31,112,31,82,31,71,31,66,31,52,31,56,31,198,31,68,31,68,30,155,31,155,30,155,29,176,31,176,30,176,29,15,31,61,31,165,31,187,31,187,30,188,31,155,31,155,30,168,31,168,30,168,29,180,31,180,30,205,31,205,30,205,29,238,31,6,31,48,31,221,31,21,31,27,31,127,31,127,30,234,31,85,31,109,31,109,30,196,31,182,31,156,31,94,31,216,31,216,30,216,29,216,28,175,31,20,31,49,31,240,31,170,31,67,31,67,30,60,31,60,30,172,31,119,31,119,30,158,31,158,30,3,31,40,31,14,31,91,31,91,30,148,31,182,31,119,31,247,31,142,31,177,31,141,31,141,30,123,31,72,31,183,31,115,31,115,30,69,31,57,31,3,31,44,31,60,31,60,30,63,31,63,30,80,31,185,31,100,31,187,31,187,30,2,31,100,31,196,31,209,31,14,31,109,31,109,30,231,31,255,31,249,31,249,30,249,29,173,31,228,31,25,31,108,31,183,31,115,31,115,30,53,31,61,31,183,31,183,30,183,29,243,31,243,30,77,31,56,31,210,31,201,31,80,31,103,31,103,30,210,31,57,31,170,31,170,30,116,31,89,31,217,31,160,31,141,31,141,30,141,29,207,31,138,31,137,31,131,31,131,30,104,31,218,31,57,31,233,31,233,30,198,31,22,31,177,31,16,31,46,31,50,31,90,31,252,31,252,30,22,31,22,30,81,31,83,31,123,31,123,30,68,31,229,31,111,31,246,31,246,30,236,31,236,30,212,31,233,31,218,31,218,30,35,31,35,30,35,29,35,28,207,31,252,31,168,31,245,31,52,31,143,31,143,30,104,31,104,30,139,31,178,31,107,31,107,30,228,31,228,30,50,31,149,31,132,31,70,31,70,30,240,31,154,31,154,30,154,29,121,31,56,31,141,31,181,31,154,31,162,31,117,31,246,31,106,31,106,30,63,31,29,31,122,31,194,31,175,31,41,31,40,31,47,31,209,31,133,31,189,31,189,30,189,29,189,28,189,27,189,26,103,31,67,31,67,30,22,31,83,31,145,31,199,31,149,31,121,31,6,31,6,30,221,31,93,31,176,31,82,31,112,31,246,31,59,31,209,31,162,31,252,31,91,31,203,31,203,30,41,31,175,31,123,31,123,30,123,29,193,31,173,31,173,30,156,31,52,31,227,31,159,31,134,31,66,31,55,31,55,30,135,31,110,31,110,30,33,31,33,30,49,31,49,30,166,31,169,31,220,31,87,31,68,31,208,31,120,31,123,31,52,31,35,31,35,30,96,31,64,31,77,31,151,31,88,31,89,31,70,31,143,31,121,31,121,30,121,29,135,31,92,31,247,31,60,31,110,31,252,31,113,31,54,31,128,31,113,31,83,31,144,31,144,30,2,31,2,30,66,31,135,31,134,31,131,31,230,31,230,30,230,29,230,28,61,31,134,31,200,31,200,30,248,31,248,30,110,31,110,30,229,31,229,30,223,31,223,30,223,29,162,31,39,31,39,30,218,31,218,30,46,31,168,31,208,31,78,31,187,31,108,31,176,31,229,31,11,31,88,31,223,31,209,31,209,30,43,31,215,31,215,30,29,31,204,31,237,31,218,31,218,30,81,31,214,31,214,30,175,31,14,31,189,31,71,31,187,31,187,30,187,29,67,31,67,30,149,31,67,31,92,31,193,31,193,30,96,31,75,31,39,31,147,31,122,31,152,31,28,31,253,31,214,31,214,30,94,31,61,31,231,31,17,31,108,31,69,31,189,31,86,31,60,31,83,31,23,31,23,30,229,31,198,31,109,31,109,30,243,31,243,30,102,31,102,30,190,31,22,31,22,30,137,31,158,31,110,31,136,31,136,30,209,31,225,31,225,31,136,31,199,31,28,31,251,31,241,31,105,31,202,31,29,31,52,31,232,31,2,31,230,31,230,30,180,31,39,31,11,31,52,31,73,31,228,31,228,30,2,31,143,31,187,31,187,30,29,31,162,31,112,31,112,30,86,31,180,31,226,31,86,31,29,31,219,31,192,31,192,30,203,31,203,30,20,31,20,30,20,29,20,28,143,31,37,31,37,30,185,31,133,31,169,31,96,31,100,31,150,31,117,31,236,31,28,31,28,30,144,31,144,30,144,29,175,31,175,30,25,31,190,31,190,30,229,31,195,31,82,31,175,31,116,31,253,31,199,31,77,31,77,30,135,31,135,30,237,31,246,31,230,31,67,31,252,31,248,31,248,30,248,29,168,31,168,30);

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
