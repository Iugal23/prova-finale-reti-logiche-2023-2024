-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_976 is
end project_tb_976;

architecture project_tb_arch_976 of project_tb_976 is
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

constant SCENARIO_LENGTH : integer := 951;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (65,0,150,0,146,0,57,0,147,0,51,0,247,0,159,0,0,0,0,0,248,0,234,0,179,0,29,0,0,0,133,0,173,0,99,0,133,0,176,0,227,0,169,0,0,0,73,0,102,0,5,0,46,0,57,0,91,0,200,0,197,0,114,0,115,0,36,0,186,0,58,0,18,0,140,0,112,0,90,0,159,0,88,0,222,0,220,0,71,0,85,0,40,0,32,0,50,0,51,0,94,0,48,0,88,0,187,0,5,0,83,0,60,0,149,0,0,0,237,0,141,0,0,0,61,0,177,0,0,0,69,0,42,0,255,0,0,0,145,0,172,0,40,0,144,0,127,0,161,0,229,0,159,0,0,0,160,0,0,0,249,0,247,0,80,0,41,0,94,0,0,0,0,0,176,0,4,0,109,0,160,0,0,0,177,0,224,0,237,0,189,0,226,0,134,0,63,0,132,0,174,0,43,0,43,0,103,0,79,0,4,0,111,0,31,0,179,0,236,0,125,0,144,0,209,0,158,0,90,0,0,0,171,0,90,0,162,0,162,0,52,0,127,0,122,0,77,0,0,0,0,0,184,0,156,0,195,0,102,0,187,0,184,0,0,0,107,0,150,0,193,0,15,0,96,0,140,0,45,0,208,0,0,0,214,0,19,0,3,0,2,0,81,0,22,0,88,0,49,0,0,0,131,0,0,0,89,0,211,0,251,0,105,0,221,0,240,0,177,0,0,0,187,0,96,0,242,0,0,0,132,0,166,0,6,0,20,0,158,0,238,0,125,0,60,0,175,0,137,0,13,0,22,0,151,0,141,0,146,0,0,0,129,0,0,0,178,0,183,0,187,0,104,0,0,0,122,0,189,0,32,0,120,0,0,0,235,0,48,0,0,0,56,0,36,0,33,0,0,0,245,0,122,0,0,0,174,0,112,0,62,0,0,0,114,0,188,0,4,0,0,0,70,0,80,0,165,0,83,0,65,0,79,0,0,0,212,0,0,0,33,0,72,0,0,0,156,0,61,0,0,0,0,0,169,0,0,0,146,0,163,0,21,0,205,0,0,0,0,0,162,0,0,0,123,0,40,0,189,0,246,0,0,0,226,0,108,0,231,0,0,0,56,0,183,0,235,0,30,0,179,0,110,0,217,0,209,0,145,0,24,0,0,0,0,0,0,0,154,0,0,0,158,0,197,0,0,0,169,0,181,0,201,0,33,0,0,0,0,0,2,0,0,0,248,0,8,0,0,0,177,0,0,0,0,0,121,0,187,0,74,0,150,0,126,0,45,0,105,0,131,0,235,0,82,0,158,0,69,0,97,0,180,0,89,0,106,0,156,0,223,0,123,0,194,0,120,0,0,0,170,0,250,0,128,0,11,0,92,0,63,0,0,0,227,0,170,0,130,0,242,0,21,0,177,0,198,0,0,0,190,0,0,0,118,0,128,0,68,0,0,0,28,0,161,0,55,0,147,0,49,0,54,0,93,0,95,0,189,0,213,0,67,0,0,0,50,0,75,0,0,0,168,0,205,0,24,0,122,0,0,0,16,0,140,0,0,0,21,0,94,0,47,0,168,0,0,0,6,0,49,0,174,0,248,0,225,0,0,0,136,0,160,0,0,0,143,0,192,0,162,0,100,0,32,0,34,0,183,0,58,0,0,0,52,0,0,0,103,0,164,0,96,0,75,0,94,0,134,0,0,0,6,0,199,0,144,0,219,0,251,0,128,0,157,0,20,0,239,0,210,0,208,0,1,0,0,0,0,0,110,0,226,0,86,0,212,0,131,0,214,0,85,0,0,0,215,0,0,0,0,0,214,0,80,0,39,0,95,0,0,0,0,0,0,0,103,0,128,0,0,0,0,0,251,0,208,0,0,0,228,0,75,0,218,0,214,0,19,0,33,0,130,0,131,0,29,0,0,0,167,0,0,0,35,0,255,0,16,0,130,0,242,0,150,0,174,0,89,0,50,0,209,0,90,0,27,0,236,0,253,0,36,0,0,0,21,0,0,0,197,0,0,0,160,0,205,0,205,0,0,0,0,0,103,0,66,0,209,0,91,0,205,0,233,0,174,0,125,0,35,0,0,0,100,0,230,0,230,0,163,0,249,0,0,0,0,0,18,0,188,0,46,0,37,0,193,0,240,0,178,0,0,0,173,0,114,0,138,0,0,0,0,0,57,0,83,0,15,0,0,0,125,0,110,0,17,0,61,0,133,0,0,0,0,0,10,0,206,0,85,0,0,0,0,0,5,0,32,0,71,0,0,0,0,0,0,0,223,0,118,0,0,0,135,0,222,0,0,0,105,0,203,0,124,0,126,0,228,0,63,0,39,0,0,0,149,0,73,0,177,0,19,0,227,0,88,0,123,0,48,0,219,0,164,0,0,0,127,0,108,0,166,0,240,0,138,0,0,0,101,0,32,0,33,0,135,0,4,0,63,0,114,0,0,0,151,0,0,0,18,0,230,0,0,0,0,0,0,0,227,0,252,0,253,0,166,0,211,0,88,0,221,0,107,0,0,0,174,0,251,0,0,0,63,0,115,0,131,0,88,0,196,0,107,0,241,0,72,0,35,0,187,0,45,0,234,0,253,0,0,0,162,0,198,0,61,0,94,0,0,0,236,0,66,0,0,0,0,0,125,0,50,0,115,0,207,0,213,0,0,0,189,0,0,0,151,0,134,0,0,0,0,0,30,0,215,0,0,0,0,0,51,0,159,0,227,0,0,0,34,0,38,0,13,0,204,0,34,0,0,0,0,0,198,0,69,0,203,0,0,0,136,0,232,0,136,0,37,0,96,0,90,0,17,0,34,0,42,0,161,0,31,0,28,0,0,0,243,0,0,0,116,0,80,0,189,0,0,0,40,0,0,0,48,0,209,0,36,0,242,0,71,0,249,0,106,0,78,0,0,0,4,0,30,0,0,0,176,0,73,0,51,0,206,0,102,0,244,0,186,0,190,0,25,0,26,0,64,0,35,0,0,0,0,0,107,0,0,0,68,0,109,0,183,0,108,0,122,0,244,0,218,0,0,0,251,0,61,0,37,0,66,0,226,0,0,0,215,0,166,0,1,0,25,0,182,0,186,0,190,0,30,0,186,0,16,0,132,0,63,0,85,0,88,0,50,0,0,0,76,0,210,0,238,0,217,0,0,0,89,0,90,0,44,0,145,0,0,0,88,0,0,0,128,0,0,0,119,0,52,0,76,0,140,0,65,0,0,0,58,0,0,0,149,0,5,0,39,0,52,0,51,0,71,0,214,0,0,0,0,0,0,0,226,0,94,0,0,0,19,0,249,0,114,0,105,0,15,0,107,0,32,0,152,0,188,0,0,0,12,0,0,0,31,0,227,0,10,0,164,0,161,0,0,0,0,0,0,0,69,0,0,0,143,0,68,0,245,0,115,0,241,0,38,0,225,0,94,0,207,0,108,0,78,0,150,0,112,0,0,0,0,0,206,0,0,0,202,0,184,0,17,0,78,0,47,0,27,0,52,0,0,0,163,0,0,0,153,0,166,0,52,0,92,0,149,0,247,0,246,0,79,0,37,0,76,0,0,0,63,0,0,0,124,0,0,0,20,0,0,0,0,0,0,0,0,0,0,0,170,0,17,0,89,0,142,0,157,0,105,0,240,0,159,0,54,0,219,0,181,0,0,0,0,0,76,0,62,0,195,0,237,0,0,0,49,0,199,0,142,0,173,0,23,0,18,0,123,0,0,0,0,0,0,0,70,0,120,0,149,0,174,0,164,0,182,0,225,0,47,0,255,0,100,0,211,0,35,0,150,0,85,0,205,0,200,0,129,0,0,0,0,0,241,0,223,0,26,0,75,0,0,0,254,0,26,0,0,0,77,0,71,0,235,0,58,0,251,0,183,0,0,0,71,0,64,0,41,0,109,0,14,0,189,0,136,0,139,0,22,0,85,0,47,0,116,0,127,0,88,0,33,0,92,0,123,0,229,0,96,0,231,0,194,0,0,0,113,0,105,0,171,0,0,0,74,0,161,0,222,0,209,0,7,0,86,0,42,0,0,0,119,0,211,0,105,0,213,0,224,0,0,0,40,0,207,0,102,0,0,0,4,0,114,0,92,0,0,0,192,0,56,0,177,0,53,0,120,0,124,0,0,0,91,0,190,0,0,0,13,0,179,0,0,0,115,0,50,0,0,0,108,0,150,0,163,0,111,0,0,0,209,0,109,0,0,0,141,0,58,0,8,0,164,0,91,0,202,0,0,0,210,0,35,0,252,0,22,0,35,0,93,0,63,0,235,0,154,0,144,0);
signal scenario_full  : scenario_type := (65,31,150,31,146,31,57,31,147,31,51,31,247,31,159,31,159,30,159,29,248,31,234,31,179,31,29,31,29,30,133,31,173,31,99,31,133,31,176,31,227,31,169,31,169,30,73,31,102,31,5,31,46,31,57,31,91,31,200,31,197,31,114,31,115,31,36,31,186,31,58,31,18,31,140,31,112,31,90,31,159,31,88,31,222,31,220,31,71,31,85,31,40,31,32,31,50,31,51,31,94,31,48,31,88,31,187,31,5,31,83,31,60,31,149,31,149,30,237,31,141,31,141,30,61,31,177,31,177,30,69,31,42,31,255,31,255,30,145,31,172,31,40,31,144,31,127,31,161,31,229,31,159,31,159,30,160,31,160,30,249,31,247,31,80,31,41,31,94,31,94,30,94,29,176,31,4,31,109,31,160,31,160,30,177,31,224,31,237,31,189,31,226,31,134,31,63,31,132,31,174,31,43,31,43,31,103,31,79,31,4,31,111,31,31,31,179,31,236,31,125,31,144,31,209,31,158,31,90,31,90,30,171,31,90,31,162,31,162,31,52,31,127,31,122,31,77,31,77,30,77,29,184,31,156,31,195,31,102,31,187,31,184,31,184,30,107,31,150,31,193,31,15,31,96,31,140,31,45,31,208,31,208,30,214,31,19,31,3,31,2,31,81,31,22,31,88,31,49,31,49,30,131,31,131,30,89,31,211,31,251,31,105,31,221,31,240,31,177,31,177,30,187,31,96,31,242,31,242,30,132,31,166,31,6,31,20,31,158,31,238,31,125,31,60,31,175,31,137,31,13,31,22,31,151,31,141,31,146,31,146,30,129,31,129,30,178,31,183,31,187,31,104,31,104,30,122,31,189,31,32,31,120,31,120,30,235,31,48,31,48,30,56,31,36,31,33,31,33,30,245,31,122,31,122,30,174,31,112,31,62,31,62,30,114,31,188,31,4,31,4,30,70,31,80,31,165,31,83,31,65,31,79,31,79,30,212,31,212,30,33,31,72,31,72,30,156,31,61,31,61,30,61,29,169,31,169,30,146,31,163,31,21,31,205,31,205,30,205,29,162,31,162,30,123,31,40,31,189,31,246,31,246,30,226,31,108,31,231,31,231,30,56,31,183,31,235,31,30,31,179,31,110,31,217,31,209,31,145,31,24,31,24,30,24,29,24,28,154,31,154,30,158,31,197,31,197,30,169,31,181,31,201,31,33,31,33,30,33,29,2,31,2,30,248,31,8,31,8,30,177,31,177,30,177,29,121,31,187,31,74,31,150,31,126,31,45,31,105,31,131,31,235,31,82,31,158,31,69,31,97,31,180,31,89,31,106,31,156,31,223,31,123,31,194,31,120,31,120,30,170,31,250,31,128,31,11,31,92,31,63,31,63,30,227,31,170,31,130,31,242,31,21,31,177,31,198,31,198,30,190,31,190,30,118,31,128,31,68,31,68,30,28,31,161,31,55,31,147,31,49,31,54,31,93,31,95,31,189,31,213,31,67,31,67,30,50,31,75,31,75,30,168,31,205,31,24,31,122,31,122,30,16,31,140,31,140,30,21,31,94,31,47,31,168,31,168,30,6,31,49,31,174,31,248,31,225,31,225,30,136,31,160,31,160,30,143,31,192,31,162,31,100,31,32,31,34,31,183,31,58,31,58,30,52,31,52,30,103,31,164,31,96,31,75,31,94,31,134,31,134,30,6,31,199,31,144,31,219,31,251,31,128,31,157,31,20,31,239,31,210,31,208,31,1,31,1,30,1,29,110,31,226,31,86,31,212,31,131,31,214,31,85,31,85,30,215,31,215,30,215,29,214,31,80,31,39,31,95,31,95,30,95,29,95,28,103,31,128,31,128,30,128,29,251,31,208,31,208,30,228,31,75,31,218,31,214,31,19,31,33,31,130,31,131,31,29,31,29,30,167,31,167,30,35,31,255,31,16,31,130,31,242,31,150,31,174,31,89,31,50,31,209,31,90,31,27,31,236,31,253,31,36,31,36,30,21,31,21,30,197,31,197,30,160,31,205,31,205,31,205,30,205,29,103,31,66,31,209,31,91,31,205,31,233,31,174,31,125,31,35,31,35,30,100,31,230,31,230,31,163,31,249,31,249,30,249,29,18,31,188,31,46,31,37,31,193,31,240,31,178,31,178,30,173,31,114,31,138,31,138,30,138,29,57,31,83,31,15,31,15,30,125,31,110,31,17,31,61,31,133,31,133,30,133,29,10,31,206,31,85,31,85,30,85,29,5,31,32,31,71,31,71,30,71,29,71,28,223,31,118,31,118,30,135,31,222,31,222,30,105,31,203,31,124,31,126,31,228,31,63,31,39,31,39,30,149,31,73,31,177,31,19,31,227,31,88,31,123,31,48,31,219,31,164,31,164,30,127,31,108,31,166,31,240,31,138,31,138,30,101,31,32,31,33,31,135,31,4,31,63,31,114,31,114,30,151,31,151,30,18,31,230,31,230,30,230,29,230,28,227,31,252,31,253,31,166,31,211,31,88,31,221,31,107,31,107,30,174,31,251,31,251,30,63,31,115,31,131,31,88,31,196,31,107,31,241,31,72,31,35,31,187,31,45,31,234,31,253,31,253,30,162,31,198,31,61,31,94,31,94,30,236,31,66,31,66,30,66,29,125,31,50,31,115,31,207,31,213,31,213,30,189,31,189,30,151,31,134,31,134,30,134,29,30,31,215,31,215,30,215,29,51,31,159,31,227,31,227,30,34,31,38,31,13,31,204,31,34,31,34,30,34,29,198,31,69,31,203,31,203,30,136,31,232,31,136,31,37,31,96,31,90,31,17,31,34,31,42,31,161,31,31,31,28,31,28,30,243,31,243,30,116,31,80,31,189,31,189,30,40,31,40,30,48,31,209,31,36,31,242,31,71,31,249,31,106,31,78,31,78,30,4,31,30,31,30,30,176,31,73,31,51,31,206,31,102,31,244,31,186,31,190,31,25,31,26,31,64,31,35,31,35,30,35,29,107,31,107,30,68,31,109,31,183,31,108,31,122,31,244,31,218,31,218,30,251,31,61,31,37,31,66,31,226,31,226,30,215,31,166,31,1,31,25,31,182,31,186,31,190,31,30,31,186,31,16,31,132,31,63,31,85,31,88,31,50,31,50,30,76,31,210,31,238,31,217,31,217,30,89,31,90,31,44,31,145,31,145,30,88,31,88,30,128,31,128,30,119,31,52,31,76,31,140,31,65,31,65,30,58,31,58,30,149,31,5,31,39,31,52,31,51,31,71,31,214,31,214,30,214,29,214,28,226,31,94,31,94,30,19,31,249,31,114,31,105,31,15,31,107,31,32,31,152,31,188,31,188,30,12,31,12,30,31,31,227,31,10,31,164,31,161,31,161,30,161,29,161,28,69,31,69,30,143,31,68,31,245,31,115,31,241,31,38,31,225,31,94,31,207,31,108,31,78,31,150,31,112,31,112,30,112,29,206,31,206,30,202,31,184,31,17,31,78,31,47,31,27,31,52,31,52,30,163,31,163,30,153,31,166,31,52,31,92,31,149,31,247,31,246,31,79,31,37,31,76,31,76,30,63,31,63,30,124,31,124,30,20,31,20,30,20,29,20,28,20,27,20,26,170,31,17,31,89,31,142,31,157,31,105,31,240,31,159,31,54,31,219,31,181,31,181,30,181,29,76,31,62,31,195,31,237,31,237,30,49,31,199,31,142,31,173,31,23,31,18,31,123,31,123,30,123,29,123,28,70,31,120,31,149,31,174,31,164,31,182,31,225,31,47,31,255,31,100,31,211,31,35,31,150,31,85,31,205,31,200,31,129,31,129,30,129,29,241,31,223,31,26,31,75,31,75,30,254,31,26,31,26,30,77,31,71,31,235,31,58,31,251,31,183,31,183,30,71,31,64,31,41,31,109,31,14,31,189,31,136,31,139,31,22,31,85,31,47,31,116,31,127,31,88,31,33,31,92,31,123,31,229,31,96,31,231,31,194,31,194,30,113,31,105,31,171,31,171,30,74,31,161,31,222,31,209,31,7,31,86,31,42,31,42,30,119,31,211,31,105,31,213,31,224,31,224,30,40,31,207,31,102,31,102,30,4,31,114,31,92,31,92,30,192,31,56,31,177,31,53,31,120,31,124,31,124,30,91,31,190,31,190,30,13,31,179,31,179,30,115,31,50,31,50,30,108,31,150,31,163,31,111,31,111,30,209,31,109,31,109,30,141,31,58,31,8,31,164,31,91,31,202,31,202,30,210,31,35,31,252,31,22,31,35,31,93,31,63,31,235,31,154,31,144,31);

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
