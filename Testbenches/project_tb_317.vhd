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

constant SCENARIO_LENGTH : integer := 915;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,8,0,0,0,61,0,122,0,138,0,95,0,152,0,0,0,0,0,195,0,56,0,172,0,0,0,42,0,119,0,172,0,74,0,173,0,12,0,171,0,0,0,103,0,16,0,138,0,246,0,121,0,110,0,74,0,245,0,0,0,0,0,235,0,62,0,58,0,142,0,0,0,0,0,33,0,0,0,187,0,153,0,225,0,0,0,0,0,84,0,157,0,125,0,68,0,52,0,130,0,59,0,190,0,204,0,147,0,0,0,136,0,0,0,56,0,0,0,180,0,101,0,0,0,136,0,224,0,240,0,147,0,206,0,124,0,173,0,52,0,248,0,47,0,0,0,255,0,0,0,0,0,0,0,0,0,0,0,65,0,253,0,0,0,0,0,83,0,0,0,0,0,146,0,0,0,0,0,189,0,198,0,67,0,229,0,14,0,101,0,49,0,218,0,0,0,206,0,178,0,0,0,223,0,152,0,118,0,125,0,0,0,248,0,13,0,144,0,0,0,0,0,250,0,30,0,143,0,90,0,219,0,178,0,128,0,0,0,0,0,96,0,64,0,100,0,239,0,33,0,132,0,213,0,208,0,0,0,189,0,0,0,0,0,145,0,88,0,0,0,168,0,230,0,185,0,232,0,244,0,253,0,39,0,0,0,166,0,61,0,183,0,223,0,60,0,71,0,83,0,156,0,0,0,172,0,156,0,101,0,36,0,228,0,190,0,10,0,3,0,121,0,94,0,0,0,0,0,166,0,212,0,70,0,229,0,119,0,250,0,76,0,160,0,169,0,217,0,197,0,103,0,209,0,113,0,95,0,77,0,205,0,65,0,172,0,65,0,108,0,79,0,0,0,0,0,196,0,172,0,47,0,236,0,134,0,0,0,37,0,0,0,2,0,90,0,13,0,2,0,10,0,0,0,116,0,201,0,70,0,15,0,30,0,42,0,0,0,184,0,63,0,12,0,228,0,245,0,218,0,0,0,0,0,0,0,63,0,255,0,79,0,198,0,156,0,0,0,85,0,10,0,0,0,168,0,208,0,117,0,179,0,116,0,103,0,53,0,36,0,45,0,98,0,0,0,65,0,133,0,245,0,69,0,0,0,135,0,213,0,152,0,91,0,0,0,214,0,0,0,232,0,70,0,0,0,147,0,155,0,246,0,0,0,0,0,0,0,190,0,0,0,0,0,129,0,225,0,248,0,158,0,20,0,216,0,29,0,0,0,251,0,0,0,157,0,43,0,59,0,74,0,86,0,0,0,0,0,131,0,211,0,0,0,9,0,188,0,4,0,0,0,160,0,41,0,0,0,78,0,29,0,0,0,175,0,15,0,213,0,58,0,123,0,133,0,174,0,97,0,59,0,163,0,171,0,0,0,0,0,165,0,101,0,0,0,0,0,44,0,0,0,244,0,91,0,157,0,37,0,173,0,79,0,231,0,0,0,149,0,186,0,65,0,205,0,78,0,129,0,82,0,63,0,22,0,0,0,109,0,0,0,120,0,200,0,190,0,10,0,149,0,122,0,176,0,179,0,4,0,225,0,149,0,22,0,183,0,32,0,0,0,247,0,130,0,6,0,178,0,0,0,28,0,47,0,81,0,0,0,187,0,148,0,35,0,76,0,129,0,160,0,109,0,48,0,191,0,140,0,37,0,0,0,234,0,178,0,0,0,118,0,94,0,154,0,247,0,117,0,200,0,0,0,116,0,187,0,222,0,41,0,193,0,200,0,146,0,116,0,0,0,190,0,0,0,20,0,56,0,218,0,253,0,156,0,197,0,67,0,102,0,247,0,251,0,0,0,0,0,198,0,83,0,139,0,113,0,68,0,106,0,0,0,108,0,0,0,14,0,0,0,89,0,172,0,0,0,138,0,230,0,250,0,142,0,0,0,37,0,204,0,234,0,206,0,6,0,211,0,174,0,104,0,0,0,75,0,0,0,213,0,18,0,230,0,0,0,0,0,107,0,232,0,0,0,159,0,230,0,136,0,0,0,195,0,233,0,187,0,0,0,0,0,223,0,0,0,211,0,32,0,216,0,229,0,132,0,146,0,0,0,252,0,200,0,118,0,200,0,0,0,0,0,252,0,93,0,0,0,0,0,247,0,195,0,59,0,0,0,154,0,170,0,55,0,0,0,195,0,225,0,0,0,43,0,154,0,0,0,160,0,76,0,84,0,8,0,213,0,0,0,63,0,0,0,13,0,200,0,91,0,79,0,70,0,105,0,138,0,112,0,13,0,157,0,0,0,23,0,50,0,60,0,77,0,255,0,138,0,0,0,25,0,0,0,136,0,172,0,66,0,0,0,85,0,0,0,153,0,159,0,168,0,247,0,229,0,0,0,249,0,0,0,224,0,15,0,143,0,58,0,99,0,0,0,0,0,0,0,217,0,155,0,190,0,123,0,178,0,20,0,5,0,66,0,136,0,169,0,0,0,166,0,60,0,24,0,71,0,254,0,59,0,0,0,156,0,82,0,0,0,241,0,9,0,120,0,63,0,96,0,29,0,0,0,207,0,0,0,240,0,185,0,6,0,0,0,21,0,6,0,97,0,214,0,151,0,0,0,132,0,76,0,249,0,179,0,0,0,14,0,68,0,0,0,144,0,238,0,227,0,0,0,76,0,0,0,119,0,245,0,31,0,67,0,211,0,11,0,0,0,152,0,94,0,58,0,188,0,14,0,25,0,49,0,12,0,254,0,22,0,188,0,42,0,119,0,0,0,0,0,102,0,130,0,211,0,120,0,7,0,0,0,0,0,167,0,83,0,10,0,107,0,132,0,163,0,71,0,169,0,8,0,0,0,178,0,167,0,9,0,97,0,52,0,69,0,171,0,197,0,246,0,0,0,223,0,193,0,114,0,0,0,0,0,0,0,55,0,241,0,82,0,0,0,219,0,118,0,147,0,249,0,118,0,86,0,111,0,24,0,0,0,0,0,52,0,118,0,227,0,0,0,0,0,132,0,65,0,16,0,154,0,19,0,0,0,0,0,0,0,222,0,78,0,127,0,173,0,134,0,11,0,0,0,0,0,33,0,240,0,4,0,187,0,25,0,0,0,70,0,87,0,0,0,0,0,91,0,77,0,168,0,17,0,0,0,55,0,234,0,26,0,0,0,9,0,14,0,9,0,233,0,97,0,105,0,108,0,48,0,43,0,96,0,118,0,79,0,0,0,184,0,109,0,53,0,192,0,167,0,118,0,5,0,98,0,241,0,39,0,176,0,193,0,0,0,91,0,0,0,230,0,230,0,58,0,179,0,0,0,143,0,210,0,0,0,115,0,70,0,44,0,0,0,205,0,32,0,97,0,0,0,164,0,159,0,98,0,151,0,0,0,0,0,0,0,0,0,0,0,53,0,125,0,72,0,0,0,37,0,74,0,247,0,133,0,213,0,0,0,14,0,70,0,172,0,0,0,239,0,31,0,229,0,11,0,144,0,214,0,79,0,0,0,0,0,98,0,255,0,145,0,94,0,250,0,0,0,166,0,66,0,240,0,134,0,0,0,151,0,192,0,185,0,247,0,232,0,244,0,61,0,15,0,5,0,27,0,146,0,53,0,28,0,77,0,0,0,228,0,118,0,159,0,51,0,245,0,150,0,45,0,56,0,239,0,0,0,81,0,0,0,0,0,23,0,0,0,0,0,232,0,138,0,0,0,143,0,64,0,184,0,64,0,0,0,156,0,241,0,0,0,195,0,57,0,53,0,0,0,0,0,254,0,0,0,0,0,243,0,14,0,145,0,3,0,173,0,165,0,42,0,123,0,22,0,0,0,232,0,224,0,89,0,168,0,0,0,18,0,168,0,0,0,84,0,171,0,0,0,0,0,19,0,170,0,172,0,165,0,0,0,66,0,15,0,54,0,235,0,112,0,37,0,0,0,97,0,112,0,232,0,19,0,79,0,0,0,183,0,123,0,21,0,103,0,92,0,204,0,180,0,172,0,182,0,223,0,203,0,145,0,189,0,0,0,76,0,94,0,0,0,103,0,182,0,36,0,0,0,67,0,193,0,96,0,0,0,7,0,116,0,0,0,232,0,174,0,0,0,50,0,56,0,0,0,186,0,210,0,225,0,0,0,31,0,0,0,0,0,66,0,154,0,216,0);
signal scenario_full  : scenario_type := (0,0,8,31,8,30,61,31,122,31,138,31,95,31,152,31,152,30,152,29,195,31,56,31,172,31,172,30,42,31,119,31,172,31,74,31,173,31,12,31,171,31,171,30,103,31,16,31,138,31,246,31,121,31,110,31,74,31,245,31,245,30,245,29,235,31,62,31,58,31,142,31,142,30,142,29,33,31,33,30,187,31,153,31,225,31,225,30,225,29,84,31,157,31,125,31,68,31,52,31,130,31,59,31,190,31,204,31,147,31,147,30,136,31,136,30,56,31,56,30,180,31,101,31,101,30,136,31,224,31,240,31,147,31,206,31,124,31,173,31,52,31,248,31,47,31,47,30,255,31,255,30,255,29,255,28,255,27,255,26,65,31,253,31,253,30,253,29,83,31,83,30,83,29,146,31,146,30,146,29,189,31,198,31,67,31,229,31,14,31,101,31,49,31,218,31,218,30,206,31,178,31,178,30,223,31,152,31,118,31,125,31,125,30,248,31,13,31,144,31,144,30,144,29,250,31,30,31,143,31,90,31,219,31,178,31,128,31,128,30,128,29,96,31,64,31,100,31,239,31,33,31,132,31,213,31,208,31,208,30,189,31,189,30,189,29,145,31,88,31,88,30,168,31,230,31,185,31,232,31,244,31,253,31,39,31,39,30,166,31,61,31,183,31,223,31,60,31,71,31,83,31,156,31,156,30,172,31,156,31,101,31,36,31,228,31,190,31,10,31,3,31,121,31,94,31,94,30,94,29,166,31,212,31,70,31,229,31,119,31,250,31,76,31,160,31,169,31,217,31,197,31,103,31,209,31,113,31,95,31,77,31,205,31,65,31,172,31,65,31,108,31,79,31,79,30,79,29,196,31,172,31,47,31,236,31,134,31,134,30,37,31,37,30,2,31,90,31,13,31,2,31,10,31,10,30,116,31,201,31,70,31,15,31,30,31,42,31,42,30,184,31,63,31,12,31,228,31,245,31,218,31,218,30,218,29,218,28,63,31,255,31,79,31,198,31,156,31,156,30,85,31,10,31,10,30,168,31,208,31,117,31,179,31,116,31,103,31,53,31,36,31,45,31,98,31,98,30,65,31,133,31,245,31,69,31,69,30,135,31,213,31,152,31,91,31,91,30,214,31,214,30,232,31,70,31,70,30,147,31,155,31,246,31,246,30,246,29,246,28,190,31,190,30,190,29,129,31,225,31,248,31,158,31,20,31,216,31,29,31,29,30,251,31,251,30,157,31,43,31,59,31,74,31,86,31,86,30,86,29,131,31,211,31,211,30,9,31,188,31,4,31,4,30,160,31,41,31,41,30,78,31,29,31,29,30,175,31,15,31,213,31,58,31,123,31,133,31,174,31,97,31,59,31,163,31,171,31,171,30,171,29,165,31,101,31,101,30,101,29,44,31,44,30,244,31,91,31,157,31,37,31,173,31,79,31,231,31,231,30,149,31,186,31,65,31,205,31,78,31,129,31,82,31,63,31,22,31,22,30,109,31,109,30,120,31,200,31,190,31,10,31,149,31,122,31,176,31,179,31,4,31,225,31,149,31,22,31,183,31,32,31,32,30,247,31,130,31,6,31,178,31,178,30,28,31,47,31,81,31,81,30,187,31,148,31,35,31,76,31,129,31,160,31,109,31,48,31,191,31,140,31,37,31,37,30,234,31,178,31,178,30,118,31,94,31,154,31,247,31,117,31,200,31,200,30,116,31,187,31,222,31,41,31,193,31,200,31,146,31,116,31,116,30,190,31,190,30,20,31,56,31,218,31,253,31,156,31,197,31,67,31,102,31,247,31,251,31,251,30,251,29,198,31,83,31,139,31,113,31,68,31,106,31,106,30,108,31,108,30,14,31,14,30,89,31,172,31,172,30,138,31,230,31,250,31,142,31,142,30,37,31,204,31,234,31,206,31,6,31,211,31,174,31,104,31,104,30,75,31,75,30,213,31,18,31,230,31,230,30,230,29,107,31,232,31,232,30,159,31,230,31,136,31,136,30,195,31,233,31,187,31,187,30,187,29,223,31,223,30,211,31,32,31,216,31,229,31,132,31,146,31,146,30,252,31,200,31,118,31,200,31,200,30,200,29,252,31,93,31,93,30,93,29,247,31,195,31,59,31,59,30,154,31,170,31,55,31,55,30,195,31,225,31,225,30,43,31,154,31,154,30,160,31,76,31,84,31,8,31,213,31,213,30,63,31,63,30,13,31,200,31,91,31,79,31,70,31,105,31,138,31,112,31,13,31,157,31,157,30,23,31,50,31,60,31,77,31,255,31,138,31,138,30,25,31,25,30,136,31,172,31,66,31,66,30,85,31,85,30,153,31,159,31,168,31,247,31,229,31,229,30,249,31,249,30,224,31,15,31,143,31,58,31,99,31,99,30,99,29,99,28,217,31,155,31,190,31,123,31,178,31,20,31,5,31,66,31,136,31,169,31,169,30,166,31,60,31,24,31,71,31,254,31,59,31,59,30,156,31,82,31,82,30,241,31,9,31,120,31,63,31,96,31,29,31,29,30,207,31,207,30,240,31,185,31,6,31,6,30,21,31,6,31,97,31,214,31,151,31,151,30,132,31,76,31,249,31,179,31,179,30,14,31,68,31,68,30,144,31,238,31,227,31,227,30,76,31,76,30,119,31,245,31,31,31,67,31,211,31,11,31,11,30,152,31,94,31,58,31,188,31,14,31,25,31,49,31,12,31,254,31,22,31,188,31,42,31,119,31,119,30,119,29,102,31,130,31,211,31,120,31,7,31,7,30,7,29,167,31,83,31,10,31,107,31,132,31,163,31,71,31,169,31,8,31,8,30,178,31,167,31,9,31,97,31,52,31,69,31,171,31,197,31,246,31,246,30,223,31,193,31,114,31,114,30,114,29,114,28,55,31,241,31,82,31,82,30,219,31,118,31,147,31,249,31,118,31,86,31,111,31,24,31,24,30,24,29,52,31,118,31,227,31,227,30,227,29,132,31,65,31,16,31,154,31,19,31,19,30,19,29,19,28,222,31,78,31,127,31,173,31,134,31,11,31,11,30,11,29,33,31,240,31,4,31,187,31,25,31,25,30,70,31,87,31,87,30,87,29,91,31,77,31,168,31,17,31,17,30,55,31,234,31,26,31,26,30,9,31,14,31,9,31,233,31,97,31,105,31,108,31,48,31,43,31,96,31,118,31,79,31,79,30,184,31,109,31,53,31,192,31,167,31,118,31,5,31,98,31,241,31,39,31,176,31,193,31,193,30,91,31,91,30,230,31,230,31,58,31,179,31,179,30,143,31,210,31,210,30,115,31,70,31,44,31,44,30,205,31,32,31,97,31,97,30,164,31,159,31,98,31,151,31,151,30,151,29,151,28,151,27,151,26,53,31,125,31,72,31,72,30,37,31,74,31,247,31,133,31,213,31,213,30,14,31,70,31,172,31,172,30,239,31,31,31,229,31,11,31,144,31,214,31,79,31,79,30,79,29,98,31,255,31,145,31,94,31,250,31,250,30,166,31,66,31,240,31,134,31,134,30,151,31,192,31,185,31,247,31,232,31,244,31,61,31,15,31,5,31,27,31,146,31,53,31,28,31,77,31,77,30,228,31,118,31,159,31,51,31,245,31,150,31,45,31,56,31,239,31,239,30,81,31,81,30,81,29,23,31,23,30,23,29,232,31,138,31,138,30,143,31,64,31,184,31,64,31,64,30,156,31,241,31,241,30,195,31,57,31,53,31,53,30,53,29,254,31,254,30,254,29,243,31,14,31,145,31,3,31,173,31,165,31,42,31,123,31,22,31,22,30,232,31,224,31,89,31,168,31,168,30,18,31,168,31,168,30,84,31,171,31,171,30,171,29,19,31,170,31,172,31,165,31,165,30,66,31,15,31,54,31,235,31,112,31,37,31,37,30,97,31,112,31,232,31,19,31,79,31,79,30,183,31,123,31,21,31,103,31,92,31,204,31,180,31,172,31,182,31,223,31,203,31,145,31,189,31,189,30,76,31,94,31,94,30,103,31,182,31,36,31,36,30,67,31,193,31,96,31,96,30,7,31,116,31,116,30,232,31,174,31,174,30,50,31,56,31,56,30,186,31,210,31,225,31,225,30,31,31,31,30,31,29,66,31,154,31,216,31);

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
