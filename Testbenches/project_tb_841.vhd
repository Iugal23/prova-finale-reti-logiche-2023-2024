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

constant SCENARIO_LENGTH : integer := 955;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,193,0,58,0,102,0,53,0,129,0,0,0,93,0,38,0,43,0,27,0,164,0,0,0,0,0,182,0,245,0,171,0,0,0,73,0,168,0,0,0,0,0,113,0,0,0,59,0,127,0,8,0,247,0,0,0,36,0,91,0,0,0,94,0,113,0,0,0,0,0,0,0,98,0,188,0,0,0,154,0,80,0,0,0,104,0,106,0,144,0,250,0,169,0,12,0,133,0,0,0,121,0,48,0,52,0,60,0,26,0,57,0,0,0,0,0,33,0,221,0,149,0,19,0,200,0,0,0,78,0,10,0,192,0,159,0,36,0,0,0,0,0,169,0,223,0,0,0,89,0,20,0,17,0,71,0,247,0,248,0,211,0,70,0,123,0,19,0,54,0,41,0,96,0,59,0,0,0,169,0,8,0,106,0,174,0,76,0,63,0,233,0,137,0,40,0,118,0,0,0,2,0,0,0,202,0,42,0,100,0,0,0,137,0,67,0,147,0,132,0,70,0,210,0,103,0,183,0,96,0,0,0,139,0,0,0,217,0,0,0,18,0,84,0,31,0,9,0,64,0,11,0,206,0,217,0,72,0,253,0,70,0,134,0,150,0,96,0,64,0,246,0,125,0,105,0,26,0,107,0,123,0,0,0,201,0,242,0,223,0,0,0,234,0,235,0,81,0,216,0,0,0,74,0,164,0,0,0,0,0,245,0,46,0,40,0,235,0,50,0,169,0,239,0,55,0,225,0,246,0,21,0,244,0,76,0,115,0,50,0,0,0,52,0,112,0,201,0,0,0,0,0,0,0,182,0,191,0,76,0,0,0,248,0,0,0,153,0,219,0,192,0,0,0,176,0,25,0,0,0,124,0,181,0,38,0,170,0,0,0,59,0,246,0,97,0,248,0,131,0,199,0,30,0,25,0,0,0,0,0,98,0,107,0,97,0,16,0,18,0,206,0,131,0,195,0,199,0,163,0,10,0,227,0,51,0,0,0,158,0,0,0,0,0,0,0,88,0,1,0,230,0,153,0,175,0,104,0,0,0,0,0,172,0,132,0,86,0,130,0,213,0,0,0,0,0,227,0,112,0,136,0,102,0,190,0,203,0,62,0,0,0,220,0,120,0,151,0,0,0,0,0,0,0,74,0,252,0,0,0,137,0,149,0,181,0,201,0,6,0,0,0,17,0,91,0,146,0,0,0,0,0,0,0,71,0,15,0,232,0,76,0,127,0,0,0,68,0,77,0,39,0,0,0,220,0,185,0,234,0,19,0,183,0,117,0,48,0,0,0,8,0,193,0,111,0,13,0,196,0,66,0,160,0,119,0,0,0,116,0,141,0,15,0,0,0,176,0,42,0,95,0,29,0,155,0,187,0,169,0,91,0,28,0,206,0,50,0,74,0,53,0,189,0,131,0,231,0,89,0,0,0,20,0,205,0,227,0,234,0,5,0,0,0,17,0,201,0,248,0,144,0,35,0,240,0,72,0,176,0,0,0,139,0,193,0,0,0,227,0,0,0,244,0,24,0,93,0,155,0,171,0,50,0,220,0,172,0,141,0,174,0,111,0,187,0,0,0,96,0,39,0,0,0,0,0,196,0,0,0,139,0,93,0,0,0,0,0,15,0,100,0,174,0,135,0,97,0,235,0,73,0,0,0,129,0,34,0,143,0,0,0,71,0,42,0,212,0,217,0,242,0,0,0,155,0,69,0,0,0,0,0,0,0,0,0,76,0,0,0,165,0,112,0,61,0,97,0,55,0,179,0,33,0,179,0,0,0,85,0,0,0,205,0,212,0,70,0,246,0,171,0,207,0,172,0,136,0,240,0,77,0,0,0,90,0,153,0,104,0,172,0,2,0,0,0,94,0,221,0,6,0,196,0,106,0,0,0,126,0,0,0,26,0,71,0,179,0,0,0,184,0,0,0,59,0,154,0,15,0,0,0,42,0,89,0,136,0,166,0,0,0,107,0,0,0,247,0,18,0,190,0,154,0,44,0,245,0,255,0,0,0,19,0,251,0,232,0,156,0,255,0,153,0,221,0,0,0,167,0,40,0,234,0,0,0,47,0,0,0,250,0,3,0,201,0,57,0,50,0,55,0,89,0,0,0,211,0,71,0,167,0,167,0,55,0,0,0,53,0,0,0,109,0,225,0,27,0,211,0,71,0,171,0,0,0,93,0,241,0,50,0,219,0,0,0,153,0,113,0,0,0,82,0,124,0,69,0,179,0,0,0,63,0,125,0,182,0,124,0,252,0,137,0,0,0,87,0,242,0,219,0,2,0,149,0,0,0,0,0,0,0,156,0,48,0,83,0,172,0,148,0,159,0,251,0,206,0,162,0,16,0,147,0,0,0,45,0,205,0,65,0,10,0,24,0,44,0,0,0,191,0,0,0,129,0,223,0,63,0,215,0,0,0,59,0,44,0,190,0,215,0,0,0,3,0,93,0,194,0,20,0,95,0,126,0,0,0,34,0,0,0,254,0,240,0,0,0,18,0,242,0,253,0,22,0,15,0,89,0,251,0,214,0,147,0,102,0,180,0,130,0,246,0,250,0,116,0,1,0,12,0,25,0,124,0,213,0,59,0,0,0,110,0,57,0,179,0,0,0,242,0,249,0,25,0,101,0,0,0,121,0,0,0,0,0,43,0,0,0,216,0,117,0,49,0,213,0,0,0,12,0,98,0,226,0,172,0,32,0,94,0,220,0,147,0,82,0,247,0,27,0,0,0,0,0,8,0,210,0,81,0,212,0,212,0,238,0,0,0,0,0,60,0,32,0,0,0,0,0,87,0,95,0,0,0,5,0,0,0,0,0,142,0,164,0,138,0,0,0,155,0,185,0,91,0,169,0,229,0,25,0,2,0,0,0,122,0,182,0,145,0,182,0,69,0,0,0,207,0,206,0,127,0,140,0,117,0,244,0,19,0,0,0,102,0,218,0,59,0,44,0,157,0,8,0,90,0,112,0,49,0,0,0,242,0,140,0,50,0,69,0,180,0,3,0,87,0,31,0,182,0,0,0,1,0,203,0,145,0,29,0,26,0,171,0,3,0,6,0,0,0,18,0,55,0,92,0,212,0,0,0,192,0,223,0,8,0,10,0,0,0,208,0,107,0,26,0,231,0,193,0,202,0,25,0,118,0,117,0,210,0,15,0,164,0,27,0,0,0,140,0,0,0,0,0,0,0,44,0,133,0,252,0,173,0,0,0,241,0,221,0,69,0,59,0,62,0,223,0,232,0,71,0,224,0,0,0,0,0,232,0,0,0,22,0,0,0,105,0,0,0,68,0,123,0,31,0,22,0,108,0,43,0,154,0,252,0,121,0,173,0,76,0,0,0,133,0,130,0,235,0,6,0,0,0,194,0,0,0,243,0,45,0,72,0,0,0,0,0,0,0,144,0,174,0,166,0,0,0,205,0,18,0,0,0,0,0,0,0,111,0,59,0,66,0,0,0,114,0,103,0,29,0,55,0,141,0,0,0,224,0,0,0,74,0,233,0,166,0,237,0,228,0,198,0,115,0,255,0,0,0,79,0,203,0,128,0,239,0,215,0,64,0,56,0,180,0,174,0,20,0,137,0,119,0,83,0,0,0,83,0,0,0,23,0,0,0,0,0,233,0,54,0,0,0,246,0,0,0,33,0,66,0,0,0,22,0,0,0,160,0,246,0,134,0,43,0,0,0,16,0,55,0,154,0,0,0,205,0,129,0,0,0,0,0,101,0,21,0,0,0,145,0,0,0,181,0,8,0,0,0,0,0,88,0,76,0,5,0,65,0,2,0,0,0,135,0,167,0,165,0,186,0,212,0,0,0,196,0,78,0,13,0,0,0,20,0,0,0,238,0,52,0,79,0,186,0,0,0,0,0,0,0,88,0,0,0,197,0,110,0,241,0,0,0,192,0,227,0,52,0,73,0,21,0,125,0,115,0,58,0,252,0,142,0,183,0,186,0,63,0,76,0,0,0,0,0,54,0,19,0,152,0,157,0,147,0,0,0,14,0,106,0,0,0,0,0,117,0,164,0,235,0,0,0,211,0,0,0,223,0,59,0,88,0,161,0,239,0,73,0,0,0,210,0,126,0,148,0,163,0,0,0,121,0,236,0,125,0,199,0,237,0,42,0,0,0,89,0,75,0,23,0,0,0,14,0,92,0,246,0,204,0,206,0,151,0,36,0,27,0,0,0,0,0,0,0,47,0,21,0,225,0,222,0,21,0,10,0,168,0,0,0,245,0,4,0,49,0,249,0,63,0,228,0,82,0,110,0,7,0,130,0,22,0,20,0);
signal scenario_full  : scenario_type := (0,0,193,31,58,31,102,31,53,31,129,31,129,30,93,31,38,31,43,31,27,31,164,31,164,30,164,29,182,31,245,31,171,31,171,30,73,31,168,31,168,30,168,29,113,31,113,30,59,31,127,31,8,31,247,31,247,30,36,31,91,31,91,30,94,31,113,31,113,30,113,29,113,28,98,31,188,31,188,30,154,31,80,31,80,30,104,31,106,31,144,31,250,31,169,31,12,31,133,31,133,30,121,31,48,31,52,31,60,31,26,31,57,31,57,30,57,29,33,31,221,31,149,31,19,31,200,31,200,30,78,31,10,31,192,31,159,31,36,31,36,30,36,29,169,31,223,31,223,30,89,31,20,31,17,31,71,31,247,31,248,31,211,31,70,31,123,31,19,31,54,31,41,31,96,31,59,31,59,30,169,31,8,31,106,31,174,31,76,31,63,31,233,31,137,31,40,31,118,31,118,30,2,31,2,30,202,31,42,31,100,31,100,30,137,31,67,31,147,31,132,31,70,31,210,31,103,31,183,31,96,31,96,30,139,31,139,30,217,31,217,30,18,31,84,31,31,31,9,31,64,31,11,31,206,31,217,31,72,31,253,31,70,31,134,31,150,31,96,31,64,31,246,31,125,31,105,31,26,31,107,31,123,31,123,30,201,31,242,31,223,31,223,30,234,31,235,31,81,31,216,31,216,30,74,31,164,31,164,30,164,29,245,31,46,31,40,31,235,31,50,31,169,31,239,31,55,31,225,31,246,31,21,31,244,31,76,31,115,31,50,31,50,30,52,31,112,31,201,31,201,30,201,29,201,28,182,31,191,31,76,31,76,30,248,31,248,30,153,31,219,31,192,31,192,30,176,31,25,31,25,30,124,31,181,31,38,31,170,31,170,30,59,31,246,31,97,31,248,31,131,31,199,31,30,31,25,31,25,30,25,29,98,31,107,31,97,31,16,31,18,31,206,31,131,31,195,31,199,31,163,31,10,31,227,31,51,31,51,30,158,31,158,30,158,29,158,28,88,31,1,31,230,31,153,31,175,31,104,31,104,30,104,29,172,31,132,31,86,31,130,31,213,31,213,30,213,29,227,31,112,31,136,31,102,31,190,31,203,31,62,31,62,30,220,31,120,31,151,31,151,30,151,29,151,28,74,31,252,31,252,30,137,31,149,31,181,31,201,31,6,31,6,30,17,31,91,31,146,31,146,30,146,29,146,28,71,31,15,31,232,31,76,31,127,31,127,30,68,31,77,31,39,31,39,30,220,31,185,31,234,31,19,31,183,31,117,31,48,31,48,30,8,31,193,31,111,31,13,31,196,31,66,31,160,31,119,31,119,30,116,31,141,31,15,31,15,30,176,31,42,31,95,31,29,31,155,31,187,31,169,31,91,31,28,31,206,31,50,31,74,31,53,31,189,31,131,31,231,31,89,31,89,30,20,31,205,31,227,31,234,31,5,31,5,30,17,31,201,31,248,31,144,31,35,31,240,31,72,31,176,31,176,30,139,31,193,31,193,30,227,31,227,30,244,31,24,31,93,31,155,31,171,31,50,31,220,31,172,31,141,31,174,31,111,31,187,31,187,30,96,31,39,31,39,30,39,29,196,31,196,30,139,31,93,31,93,30,93,29,15,31,100,31,174,31,135,31,97,31,235,31,73,31,73,30,129,31,34,31,143,31,143,30,71,31,42,31,212,31,217,31,242,31,242,30,155,31,69,31,69,30,69,29,69,28,69,27,76,31,76,30,165,31,112,31,61,31,97,31,55,31,179,31,33,31,179,31,179,30,85,31,85,30,205,31,212,31,70,31,246,31,171,31,207,31,172,31,136,31,240,31,77,31,77,30,90,31,153,31,104,31,172,31,2,31,2,30,94,31,221,31,6,31,196,31,106,31,106,30,126,31,126,30,26,31,71,31,179,31,179,30,184,31,184,30,59,31,154,31,15,31,15,30,42,31,89,31,136,31,166,31,166,30,107,31,107,30,247,31,18,31,190,31,154,31,44,31,245,31,255,31,255,30,19,31,251,31,232,31,156,31,255,31,153,31,221,31,221,30,167,31,40,31,234,31,234,30,47,31,47,30,250,31,3,31,201,31,57,31,50,31,55,31,89,31,89,30,211,31,71,31,167,31,167,31,55,31,55,30,53,31,53,30,109,31,225,31,27,31,211,31,71,31,171,31,171,30,93,31,241,31,50,31,219,31,219,30,153,31,113,31,113,30,82,31,124,31,69,31,179,31,179,30,63,31,125,31,182,31,124,31,252,31,137,31,137,30,87,31,242,31,219,31,2,31,149,31,149,30,149,29,149,28,156,31,48,31,83,31,172,31,148,31,159,31,251,31,206,31,162,31,16,31,147,31,147,30,45,31,205,31,65,31,10,31,24,31,44,31,44,30,191,31,191,30,129,31,223,31,63,31,215,31,215,30,59,31,44,31,190,31,215,31,215,30,3,31,93,31,194,31,20,31,95,31,126,31,126,30,34,31,34,30,254,31,240,31,240,30,18,31,242,31,253,31,22,31,15,31,89,31,251,31,214,31,147,31,102,31,180,31,130,31,246,31,250,31,116,31,1,31,12,31,25,31,124,31,213,31,59,31,59,30,110,31,57,31,179,31,179,30,242,31,249,31,25,31,101,31,101,30,121,31,121,30,121,29,43,31,43,30,216,31,117,31,49,31,213,31,213,30,12,31,98,31,226,31,172,31,32,31,94,31,220,31,147,31,82,31,247,31,27,31,27,30,27,29,8,31,210,31,81,31,212,31,212,31,238,31,238,30,238,29,60,31,32,31,32,30,32,29,87,31,95,31,95,30,5,31,5,30,5,29,142,31,164,31,138,31,138,30,155,31,185,31,91,31,169,31,229,31,25,31,2,31,2,30,122,31,182,31,145,31,182,31,69,31,69,30,207,31,206,31,127,31,140,31,117,31,244,31,19,31,19,30,102,31,218,31,59,31,44,31,157,31,8,31,90,31,112,31,49,31,49,30,242,31,140,31,50,31,69,31,180,31,3,31,87,31,31,31,182,31,182,30,1,31,203,31,145,31,29,31,26,31,171,31,3,31,6,31,6,30,18,31,55,31,92,31,212,31,212,30,192,31,223,31,8,31,10,31,10,30,208,31,107,31,26,31,231,31,193,31,202,31,25,31,118,31,117,31,210,31,15,31,164,31,27,31,27,30,140,31,140,30,140,29,140,28,44,31,133,31,252,31,173,31,173,30,241,31,221,31,69,31,59,31,62,31,223,31,232,31,71,31,224,31,224,30,224,29,232,31,232,30,22,31,22,30,105,31,105,30,68,31,123,31,31,31,22,31,108,31,43,31,154,31,252,31,121,31,173,31,76,31,76,30,133,31,130,31,235,31,6,31,6,30,194,31,194,30,243,31,45,31,72,31,72,30,72,29,72,28,144,31,174,31,166,31,166,30,205,31,18,31,18,30,18,29,18,28,111,31,59,31,66,31,66,30,114,31,103,31,29,31,55,31,141,31,141,30,224,31,224,30,74,31,233,31,166,31,237,31,228,31,198,31,115,31,255,31,255,30,79,31,203,31,128,31,239,31,215,31,64,31,56,31,180,31,174,31,20,31,137,31,119,31,83,31,83,30,83,31,83,30,23,31,23,30,23,29,233,31,54,31,54,30,246,31,246,30,33,31,66,31,66,30,22,31,22,30,160,31,246,31,134,31,43,31,43,30,16,31,55,31,154,31,154,30,205,31,129,31,129,30,129,29,101,31,21,31,21,30,145,31,145,30,181,31,8,31,8,30,8,29,88,31,76,31,5,31,65,31,2,31,2,30,135,31,167,31,165,31,186,31,212,31,212,30,196,31,78,31,13,31,13,30,20,31,20,30,238,31,52,31,79,31,186,31,186,30,186,29,186,28,88,31,88,30,197,31,110,31,241,31,241,30,192,31,227,31,52,31,73,31,21,31,125,31,115,31,58,31,252,31,142,31,183,31,186,31,63,31,76,31,76,30,76,29,54,31,19,31,152,31,157,31,147,31,147,30,14,31,106,31,106,30,106,29,117,31,164,31,235,31,235,30,211,31,211,30,223,31,59,31,88,31,161,31,239,31,73,31,73,30,210,31,126,31,148,31,163,31,163,30,121,31,236,31,125,31,199,31,237,31,42,31,42,30,89,31,75,31,23,31,23,30,14,31,92,31,246,31,204,31,206,31,151,31,36,31,27,31,27,30,27,29,27,28,47,31,21,31,225,31,222,31,21,31,10,31,168,31,168,30,245,31,4,31,49,31,249,31,63,31,228,31,82,31,110,31,7,31,130,31,22,31,20,31);

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
