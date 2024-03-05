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

constant SCENARIO_LENGTH : integer := 985;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,0,0,98,0,39,0,120,0,0,0,0,0,0,0,82,0,248,0,38,0,0,0,236,0,0,0,126,0,0,0,232,0,103,0,0,0,0,0,13,0,229,0,153,0,86,0,118,0,0,0,196,0,85,0,196,0,0,0,203,0,109,0,249,0,61,0,7,0,230,0,86,0,85,0,15,0,0,0,234,0,251,0,129,0,41,0,111,0,174,0,124,0,128,0,29,0,193,0,70,0,155,0,126,0,56,0,6,0,97,0,113,0,34,0,64,0,63,0,208,0,91,0,156,0,146,0,232,0,92,0,31,0,137,0,123,0,88,0,0,0,0,0,0,0,88,0,0,0,0,0,70,0,191,0,135,0,250,0,122,0,61,0,161,0,124,0,91,0,0,0,240,0,15,0,244,0,0,0,35,0,83,0,0,0,96,0,0,0,223,0,0,0,243,0,151,0,128,0,153,0,19,0,239,0,0,0,69,0,30,0,154,0,168,0,70,0,0,0,97,0,24,0,189,0,0,0,119,0,23,0,119,0,36,0,0,0,234,0,116,0,57,0,50,0,221,0,164,0,159,0,220,0,145,0,138,0,210,0,193,0,152,0,0,0,0,0,173,0,126,0,76,0,0,0,0,0,0,0,86,0,236,0,35,0,0,0,70,0,184,0,76,0,60,0,72,0,176,0,56,0,141,0,197,0,158,0,200,0,15,0,111,0,16,0,0,0,173,0,0,0,0,0,159,0,177,0,232,0,78,0,93,0,226,0,188,0,0,0,145,0,170,0,0,0,47,0,0,0,137,0,38,0,188,0,168,0,108,0,231,0,30,0,13,0,184,0,111,0,3,0,139,0,192,0,16,0,251,0,5,0,0,0,3,0,249,0,0,0,132,0,0,0,102,0,243,0,75,0,0,0,162,0,27,0,0,0,85,0,210,0,191,0,0,0,255,0,108,0,55,0,43,0,193,0,167,0,15,0,58,0,135,0,182,0,117,0,147,0,96,0,237,0,0,0,59,0,38,0,93,0,43,0,93,0,113,0,174,0,54,0,177,0,206,0,0,0,188,0,154,0,76,0,0,0,104,0,227,0,192,0,172,0,110,0,73,0,243,0,61,0,119,0,70,0,0,0,200,0,69,0,0,0,200,0,248,0,7,0,0,0,0,0,177,0,196,0,128,0,139,0,35,0,0,0,120,0,161,0,98,0,229,0,188,0,0,0,26,0,108,0,163,0,131,0,0,0,230,0,255,0,201,0,93,0,253,0,0,0,48,0,239,0,202,0,22,0,103,0,98,0,0,0,248,0,196,0,71,0,0,0,70,0,12,0,138,0,162,0,182,0,225,0,223,0,200,0,0,0,255,0,0,0,115,0,0,0,95,0,119,0,0,0,7,0,229,0,11,0,10,0,14,0,137,0,204,0,244,0,221,0,182,0,240,0,138,0,76,0,225,0,55,0,150,0,0,0,137,0,104,0,215,0,221,0,230,0,155,0,78,0,82,0,40,0,139,0,27,0,21,0,231,0,96,0,0,0,87,0,26,0,205,0,37,0,8,0,204,0,178,0,7,0,59,0,76,0,129,0,123,0,0,0,0,0,66,0,0,0,0,0,186,0,168,0,184,0,15,0,161,0,127,0,1,0,96,0,184,0,0,0,203,0,126,0,82,0,233,0,0,0,227,0,166,0,59,0,0,0,0,0,150,0,95,0,42,0,115,0,136,0,0,0,131,0,52,0,142,0,0,0,208,0,156,0,129,0,235,0,38,0,184,0,110,0,13,0,0,0,236,0,121,0,11,0,128,0,24,0,0,0,188,0,116,0,135,0,91,0,117,0,52,0,0,0,58,0,211,0,94,0,85,0,0,0,73,0,244,0,0,0,165,0,152,0,125,0,0,0,172,0,210,0,44,0,41,0,32,0,0,0,101,0,4,0,252,0,158,0,137,0,244,0,139,0,247,0,50,0,203,0,92,0,134,0,18,0,5,0,26,0,25,0,175,0,17,0,108,0,0,0,31,0,46,0,73,0,16,0,98,0,150,0,247,0,80,0,25,0,158,0,196,0,53,0,191,0,1,0,0,0,23,0,254,0,232,0,233,0,0,0,116,0,0,0,0,0,201,0,179,0,0,0,207,0,12,0,111,0,224,0,112,0,236,0,132,0,38,0,60,0,0,0,63,0,141,0,0,0,0,0,106,0,0,0,198,0,138,0,136,0,0,0,236,0,41,0,0,0,0,0,112,0,120,0,235,0,204,0,22,0,0,0,124,0,0,0,202,0,151,0,0,0,71,0,0,0,244,0,118,0,242,0,78,0,171,0,217,0,184,0,128,0,203,0,37,0,84,0,43,0,0,0,0,0,188,0,62,0,21,0,246,0,0,0,55,0,110,0,83,0,0,0,174,0,95,0,149,0,51,0,26,0,0,0,58,0,235,0,21,0,0,0,0,0,167,0,197,0,6,0,123,0,171,0,181,0,18,0,83,0,147,0,0,0,179,0,0,0,247,0,123,0,132,0,74,0,128,0,69,0,199,0,0,0,77,0,195,0,16,0,116,0,0,0,129,0,155,0,57,0,134,0,173,0,0,0,137,0,236,0,32,0,247,0,37,0,229,0,165,0,240,0,136,0,81,0,94,0,141,0,0,0,0,0,71,0,164,0,73,0,217,0,186,0,35,0,18,0,74,0,68,0,55,0,206,0,0,0,0,0,103,0,0,0,163,0,126,0,84,0,24,0,248,0,26,0,157,0,169,0,234,0,0,0,110,0,241,0,150,0,78,0,0,0,218,0,118,0,0,0,19,0,214,0,42,0,0,0,147,0,0,0,212,0,94,0,0,0,230,0,25,0,41,0,125,0,0,0,0,0,0,0,21,0,22,0,12,0,228,0,0,0,100,0,244,0,0,0,245,0,125,0,140,0,0,0,71,0,66,0,177,0,0,0,56,0,76,0,160,0,80,0,187,0,49,0,0,0,199,0,0,0,159,0,0,0,202,0,198,0,0,0,178,0,0,0,254,0,113,0,148,0,229,0,184,0,234,0,137,0,116,0,155,0,244,0,0,0,113,0,72,0,217,0,185,0,6,0,59,0,62,0,227,0,126,0,98,0,141,0,153,0,140,0,46,0,183,0,0,0,210,0,217,0,0,0,184,0,178,0,71,0,8,0,239,0,164,0,207,0,233,0,70,0,0,0,115,0,244,0,117,0,129,0,62,0,52,0,94,0,152,0,51,0,164,0,0,0,242,0,60,0,0,0,153,0,0,0,0,0,0,0,37,0,104,0,131,0,32,0,0,0,147,0,59,0,214,0,0,0,244,0,54,0,55,0,80,0,76,0,100,0,0,0,0,0,0,0,0,0,222,0,58,0,64,0,32,0,51,0,0,0,250,0,37,0,0,0,171,0,118,0,251,0,87,0,30,0,0,0,130,0,91,0,0,0,115,0,0,0,0,0,163,0,246,0,0,0,132,0,0,0,203,0,232,0,88,0,209,0,27,0,143,0,0,0,9,0,26,0,103,0,127,0,211,0,214,0,184,0,0,0,154,0,96,0,225,0,0,0,23,0,196,0,5,0,42,0,0,0,104,0,118,0,192,0,142,0,252,0,105,0,223,0,110,0,177,0,175,0,144,0,207,0,134,0,157,0,0,0,160,0,238,0,61,0,162,0,108,0,0,0,0,0,169,0,180,0,193,0,152,0,0,0,226,0,192,0,0,0,247,0,191,0,29,0,125,0,35,0,170,0,102,0,206,0,62,0,96,0,238,0,63,0,162,0,133,0,0,0,20,0,251,0,195,0,88,0,0,0,239,0,23,0,0,0,0,0,102,0,116,0,11,0,15,0,0,0,70,0,97,0,22,0,152,0,0,0,182,0,52,0,151,0,101,0,58,0,138,0,140,0,24,0,147,0,101,0,93,0,33,0,161,0,24,0,152,0,144,0,126,0,0,0,0,0,115,0,93,0,79,0,249,0,218,0,0,0,0,0,0,0,39,0,0,0,199,0,189,0,56,0,0,0,202,0,170,0,159,0,0,0,221,0,59,0,136,0,0,0,0,0,0,0,0,0,85,0,106,0,99,0,130,0,37,0,227,0,150,0,0,0,39,0,155,0,83,0,152,0,126,0,197,0,167,0,124,0,0,0,97,0,215,0,99,0,39,0,103,0,247,0,213,0,0,0,0,0,140,0,209,0,14,0,0,0,214,0,154,0,113,0,13,0,213,0,34,0,189,0,41,0,76,0,165,0,173,0,86,0,213,0,116,0,78,0,69,0,182,0,179,0,178,0,9,0,210,0,93,0,183,0,207,0,207,0,0,0,110,0,173,0,159,0,0,0,227,0,3,0,18,0,87,0,177,0,102,0,137,0,0,0,199,0,60,0,0,0,224,0,66,0,0,0,0,0,73,0,69,0,217,0,63,0,207,0,119,0);
signal scenario_full  : scenario_type := (0,0,0,0,98,31,39,31,120,31,120,30,120,29,120,28,82,31,248,31,38,31,38,30,236,31,236,30,126,31,126,30,232,31,103,31,103,30,103,29,13,31,229,31,153,31,86,31,118,31,118,30,196,31,85,31,196,31,196,30,203,31,109,31,249,31,61,31,7,31,230,31,86,31,85,31,15,31,15,30,234,31,251,31,129,31,41,31,111,31,174,31,124,31,128,31,29,31,193,31,70,31,155,31,126,31,56,31,6,31,97,31,113,31,34,31,64,31,63,31,208,31,91,31,156,31,146,31,232,31,92,31,31,31,137,31,123,31,88,31,88,30,88,29,88,28,88,31,88,30,88,29,70,31,191,31,135,31,250,31,122,31,61,31,161,31,124,31,91,31,91,30,240,31,15,31,244,31,244,30,35,31,83,31,83,30,96,31,96,30,223,31,223,30,243,31,151,31,128,31,153,31,19,31,239,31,239,30,69,31,30,31,154,31,168,31,70,31,70,30,97,31,24,31,189,31,189,30,119,31,23,31,119,31,36,31,36,30,234,31,116,31,57,31,50,31,221,31,164,31,159,31,220,31,145,31,138,31,210,31,193,31,152,31,152,30,152,29,173,31,126,31,76,31,76,30,76,29,76,28,86,31,236,31,35,31,35,30,70,31,184,31,76,31,60,31,72,31,176,31,56,31,141,31,197,31,158,31,200,31,15,31,111,31,16,31,16,30,173,31,173,30,173,29,159,31,177,31,232,31,78,31,93,31,226,31,188,31,188,30,145,31,170,31,170,30,47,31,47,30,137,31,38,31,188,31,168,31,108,31,231,31,30,31,13,31,184,31,111,31,3,31,139,31,192,31,16,31,251,31,5,31,5,30,3,31,249,31,249,30,132,31,132,30,102,31,243,31,75,31,75,30,162,31,27,31,27,30,85,31,210,31,191,31,191,30,255,31,108,31,55,31,43,31,193,31,167,31,15,31,58,31,135,31,182,31,117,31,147,31,96,31,237,31,237,30,59,31,38,31,93,31,43,31,93,31,113,31,174,31,54,31,177,31,206,31,206,30,188,31,154,31,76,31,76,30,104,31,227,31,192,31,172,31,110,31,73,31,243,31,61,31,119,31,70,31,70,30,200,31,69,31,69,30,200,31,248,31,7,31,7,30,7,29,177,31,196,31,128,31,139,31,35,31,35,30,120,31,161,31,98,31,229,31,188,31,188,30,26,31,108,31,163,31,131,31,131,30,230,31,255,31,201,31,93,31,253,31,253,30,48,31,239,31,202,31,22,31,103,31,98,31,98,30,248,31,196,31,71,31,71,30,70,31,12,31,138,31,162,31,182,31,225,31,223,31,200,31,200,30,255,31,255,30,115,31,115,30,95,31,119,31,119,30,7,31,229,31,11,31,10,31,14,31,137,31,204,31,244,31,221,31,182,31,240,31,138,31,76,31,225,31,55,31,150,31,150,30,137,31,104,31,215,31,221,31,230,31,155,31,78,31,82,31,40,31,139,31,27,31,21,31,231,31,96,31,96,30,87,31,26,31,205,31,37,31,8,31,204,31,178,31,7,31,59,31,76,31,129,31,123,31,123,30,123,29,66,31,66,30,66,29,186,31,168,31,184,31,15,31,161,31,127,31,1,31,96,31,184,31,184,30,203,31,126,31,82,31,233,31,233,30,227,31,166,31,59,31,59,30,59,29,150,31,95,31,42,31,115,31,136,31,136,30,131,31,52,31,142,31,142,30,208,31,156,31,129,31,235,31,38,31,184,31,110,31,13,31,13,30,236,31,121,31,11,31,128,31,24,31,24,30,188,31,116,31,135,31,91,31,117,31,52,31,52,30,58,31,211,31,94,31,85,31,85,30,73,31,244,31,244,30,165,31,152,31,125,31,125,30,172,31,210,31,44,31,41,31,32,31,32,30,101,31,4,31,252,31,158,31,137,31,244,31,139,31,247,31,50,31,203,31,92,31,134,31,18,31,5,31,26,31,25,31,175,31,17,31,108,31,108,30,31,31,46,31,73,31,16,31,98,31,150,31,247,31,80,31,25,31,158,31,196,31,53,31,191,31,1,31,1,30,23,31,254,31,232,31,233,31,233,30,116,31,116,30,116,29,201,31,179,31,179,30,207,31,12,31,111,31,224,31,112,31,236,31,132,31,38,31,60,31,60,30,63,31,141,31,141,30,141,29,106,31,106,30,198,31,138,31,136,31,136,30,236,31,41,31,41,30,41,29,112,31,120,31,235,31,204,31,22,31,22,30,124,31,124,30,202,31,151,31,151,30,71,31,71,30,244,31,118,31,242,31,78,31,171,31,217,31,184,31,128,31,203,31,37,31,84,31,43,31,43,30,43,29,188,31,62,31,21,31,246,31,246,30,55,31,110,31,83,31,83,30,174,31,95,31,149,31,51,31,26,31,26,30,58,31,235,31,21,31,21,30,21,29,167,31,197,31,6,31,123,31,171,31,181,31,18,31,83,31,147,31,147,30,179,31,179,30,247,31,123,31,132,31,74,31,128,31,69,31,199,31,199,30,77,31,195,31,16,31,116,31,116,30,129,31,155,31,57,31,134,31,173,31,173,30,137,31,236,31,32,31,247,31,37,31,229,31,165,31,240,31,136,31,81,31,94,31,141,31,141,30,141,29,71,31,164,31,73,31,217,31,186,31,35,31,18,31,74,31,68,31,55,31,206,31,206,30,206,29,103,31,103,30,163,31,126,31,84,31,24,31,248,31,26,31,157,31,169,31,234,31,234,30,110,31,241,31,150,31,78,31,78,30,218,31,118,31,118,30,19,31,214,31,42,31,42,30,147,31,147,30,212,31,94,31,94,30,230,31,25,31,41,31,125,31,125,30,125,29,125,28,21,31,22,31,12,31,228,31,228,30,100,31,244,31,244,30,245,31,125,31,140,31,140,30,71,31,66,31,177,31,177,30,56,31,76,31,160,31,80,31,187,31,49,31,49,30,199,31,199,30,159,31,159,30,202,31,198,31,198,30,178,31,178,30,254,31,113,31,148,31,229,31,184,31,234,31,137,31,116,31,155,31,244,31,244,30,113,31,72,31,217,31,185,31,6,31,59,31,62,31,227,31,126,31,98,31,141,31,153,31,140,31,46,31,183,31,183,30,210,31,217,31,217,30,184,31,178,31,71,31,8,31,239,31,164,31,207,31,233,31,70,31,70,30,115,31,244,31,117,31,129,31,62,31,52,31,94,31,152,31,51,31,164,31,164,30,242,31,60,31,60,30,153,31,153,30,153,29,153,28,37,31,104,31,131,31,32,31,32,30,147,31,59,31,214,31,214,30,244,31,54,31,55,31,80,31,76,31,100,31,100,30,100,29,100,28,100,27,222,31,58,31,64,31,32,31,51,31,51,30,250,31,37,31,37,30,171,31,118,31,251,31,87,31,30,31,30,30,130,31,91,31,91,30,115,31,115,30,115,29,163,31,246,31,246,30,132,31,132,30,203,31,232,31,88,31,209,31,27,31,143,31,143,30,9,31,26,31,103,31,127,31,211,31,214,31,184,31,184,30,154,31,96,31,225,31,225,30,23,31,196,31,5,31,42,31,42,30,104,31,118,31,192,31,142,31,252,31,105,31,223,31,110,31,177,31,175,31,144,31,207,31,134,31,157,31,157,30,160,31,238,31,61,31,162,31,108,31,108,30,108,29,169,31,180,31,193,31,152,31,152,30,226,31,192,31,192,30,247,31,191,31,29,31,125,31,35,31,170,31,102,31,206,31,62,31,96,31,238,31,63,31,162,31,133,31,133,30,20,31,251,31,195,31,88,31,88,30,239,31,23,31,23,30,23,29,102,31,116,31,11,31,15,31,15,30,70,31,97,31,22,31,152,31,152,30,182,31,52,31,151,31,101,31,58,31,138,31,140,31,24,31,147,31,101,31,93,31,33,31,161,31,24,31,152,31,144,31,126,31,126,30,126,29,115,31,93,31,79,31,249,31,218,31,218,30,218,29,218,28,39,31,39,30,199,31,189,31,56,31,56,30,202,31,170,31,159,31,159,30,221,31,59,31,136,31,136,30,136,29,136,28,136,27,85,31,106,31,99,31,130,31,37,31,227,31,150,31,150,30,39,31,155,31,83,31,152,31,126,31,197,31,167,31,124,31,124,30,97,31,215,31,99,31,39,31,103,31,247,31,213,31,213,30,213,29,140,31,209,31,14,31,14,30,214,31,154,31,113,31,13,31,213,31,34,31,189,31,41,31,76,31,165,31,173,31,86,31,213,31,116,31,78,31,69,31,182,31,179,31,178,31,9,31,210,31,93,31,183,31,207,31,207,31,207,30,110,31,173,31,159,31,159,30,227,31,3,31,18,31,87,31,177,31,102,31,137,31,137,30,199,31,60,31,60,30,224,31,66,31,66,30,66,29,73,31,69,31,217,31,63,31,207,31,119,31);

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
