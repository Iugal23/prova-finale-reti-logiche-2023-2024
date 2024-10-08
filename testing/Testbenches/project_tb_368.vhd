-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_368 is
end project_tb_368;

architecture project_tb_arch_368 of project_tb_368 is
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

constant SCENARIO_LENGTH : integer := 906;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (143,0,106,0,188,0,1,0,194,0,0,0,203,0,60,0,174,0,5,0,152,0,185,0,200,0,47,0,54,0,201,0,200,0,34,0,68,0,224,0,172,0,28,0,222,0,143,0,0,0,22,0,0,0,37,0,127,0,0,0,133,0,206,0,231,0,125,0,1,0,101,0,149,0,121,0,243,0,111,0,0,0,0,0,144,0,177,0,70,0,247,0,0,0,0,0,185,0,164,0,89,0,0,0,60,0,153,0,217,0,157,0,95,0,98,0,0,0,232,0,198,0,44,0,83,0,87,0,212,0,71,0,0,0,0,0,0,0,81,0,207,0,0,0,244,0,0,0,158,0,50,0,27,0,0,0,0,0,251,0,106,0,101,0,249,0,3,0,0,0,0,0,74,0,218,0,157,0,34,0,0,0,178,0,56,0,65,0,0,0,0,0,15,0,47,0,90,0,0,0,204,0,51,0,135,0,0,0,100,0,0,0,0,0,87,0,45,0,189,0,222,0,203,0,172,0,242,0,235,0,49,0,47,0,114,0,0,0,0,0,155,0,71,0,238,0,0,0,47,0,69,0,40,0,0,0,0,0,194,0,125,0,20,0,238,0,160,0,94,0,53,0,43,0,40,0,197,0,18,0,0,0,0,0,20,0,120,0,214,0,23,0,0,0,57,0,212,0,80,0,182,0,108,0,0,0,200,0,80,0,28,0,23,0,106,0,154,0,0,0,228,0,37,0,0,0,249,0,186,0,136,0,234,0,164,0,98,0,120,0,104,0,93,0,255,0,130,0,144,0,224,0,0,0,0,0,0,0,215,0,24,0,139,0,140,0,44,0,0,0,215,0,0,0,128,0,254,0,209,0,0,0,97,0,0,0,0,0,0,0,70,0,21,0,0,0,18,0,77,0,0,0,7,0,212,0,101,0,0,0,0,0,117,0,76,0,93,0,0,0,250,0,11,0,221,0,87,0,56,0,134,0,150,0,244,0,246,0,120,0,160,0,0,0,0,0,52,0,108,0,64,0,46,0,5,0,99,0,66,0,16,0,111,0,113,0,66,0,65,0,106,0,0,0,0,0,0,0,99,0,83,0,189,0,233,0,38,0,180,0,179,0,38,0,246,0,50,0,186,0,231,0,117,0,203,0,226,0,0,0,175,0,238,0,176,0,227,0,0,0,0,0,0,0,31,0,27,0,181,0,172,0,0,0,202,0,141,0,181,0,46,0,198,0,139,0,160,0,25,0,70,0,191,0,84,0,92,0,0,0,183,0,8,0,113,0,59,0,251,0,168,0,193,0,218,0,93,0,126,0,112,0,106,0,129,0,61,0,159,0,119,0,248,0,148,0,135,0,0,0,85,0,108,0,122,0,95,0,229,0,122,0,223,0,0,0,188,0,208,0,252,0,109,0,211,0,198,0,0,0,0,0,106,0,0,0,209,0,68,0,55,0,132,0,124,0,54,0,234,0,137,0,110,0,84,0,208,0,130,0,0,0,100,0,73,0,190,0,74,0,32,0,89,0,177,0,0,0,113,0,128,0,150,0,0,0,168,0,245,0,0,0,0,0,9,0,133,0,43,0,16,0,59,0,226,0,42,0,205,0,34,0,203,0,47,0,158,0,241,0,0,0,147,0,59,0,214,0,213,0,84,0,94,0,194,0,0,0,217,0,39,0,112,0,134,0,190,0,191,0,219,0,107,0,0,0,0,0,220,0,13,0,187,0,0,0,27,0,161,0,57,0,218,0,169,0,141,0,84,0,99,0,61,0,0,0,145,0,109,0,0,0,92,0,185,0,0,0,0,0,0,0,31,0,0,0,70,0,66,0,0,0,201,0,171,0,52,0,149,0,216,0,81,0,178,0,156,0,115,0,176,0,213,0,156,0,145,0,183,0,148,0,162,0,95,0,212,0,119,0,167,0,28,0,74,0,155,0,251,0,111,0,0,0,76,0,178,0,0,0,58,0,183,0,230,0,153,0,216,0,148,0,8,0,0,0,118,0,0,0,100,0,220,0,24,0,114,0,0,0,0,0,144,0,42,0,215,0,155,0,14,0,67,0,225,0,70,0,1,0,147,0,110,0,231,0,158,0,160,0,136,0,0,0,72,0,153,0,232,0,155,0,0,0,248,0,180,0,159,0,79,0,206,0,11,0,150,0,107,0,158,0,118,0,229,0,41,0,0,0,18,0,22,0,227,0,15,0,71,0,226,0,153,0,169,0,202,0,122,0,208,0,164,0,0,0,109,0,13,0,75,0,144,0,204,0,253,0,0,0,0,0,38,0,0,0,169,0,137,0,156,0,195,0,108,0,215,0,4,0,0,0,186,0,58,0,22,0,131,0,0,0,0,0,208,0,112,0,18,0,0,0,216,0,174,0,68,0,170,0,80,0,183,0,106,0,0,0,74,0,59,0,7,0,120,0,124,0,0,0,0,0,0,0,88,0,9,0,23,0,0,0,107,0,36,0,143,0,164,0,58,0,5,0,0,0,75,0,0,0,81,0,34,0,32,0,36,0,192,0,120,0,8,0,172,0,0,0,78,0,92,0,219,0,67,0,0,0,0,0,97,0,142,0,130,0,86,0,100,0,19,0,0,0,144,0,51,0,181,0,114,0,164,0,60,0,19,0,218,0,0,0,14,0,190,0,0,0,227,0,17,0,88,0,3,0,0,0,2,0,223,0,0,0,195,0,201,0,102,0,9,0,252,0,254,0,185,0,79,0,166,0,190,0,189,0,0,0,125,0,4,0,0,0,231,0,141,0,116,0,172,0,158,0,0,0,45,0,0,0,249,0,215,0,251,0,46,0,0,0,0,0,27,0,35,0,91,0,8,0,211,0,41,0,17,0,0,0,0,0,0,0,167,0,79,0,137,0,0,0,189,0,104,0,233,0,189,0,18,0,143,0,70,0,0,0,107,0,32,0,24,0,0,0,0,0,33,0,190,0,16,0,89,0,196,0,0,0,200,0,226,0,2,0,0,0,145,0,117,0,44,0,0,0,5,0,0,0,34,0,166,0,0,0,226,0,204,0,69,0,85,0,116,0,0,0,154,0,8,0,225,0,157,0,0,0,2,0,229,0,35,0,0,0,0,0,0,0,0,0,115,0,165,0,75,0,53,0,67,0,204,0,0,0,8,0,54,0,229,0,21,0,162,0,0,0,0,0,0,0,94,0,133,0,0,0,28,0,0,0,0,0,233,0,0,0,63,0,32,0,0,0,133,0,0,0,250,0,33,0,124,0,173,0,38,0,250,0,181,0,17,0,0,0,223,0,202,0,162,0,77,0,174,0,61,0,0,0,87,0,239,0,212,0,75,0,45,0,83,0,70,0,218,0,237,0,223,0,233,0,0,0,129,0,3,0,0,0,74,0,97,0,103,0,13,0,0,0,240,0,210,0,227,0,214,0,93,0,49,0,200,0,24,0,141,0,187,0,0,0,102,0,219,0,200,0,209,0,136,0,199,0,60,0,247,0,94,0,5,0,124,0,11,0,16,0,117,0,25,0,44,0,154,0,195,0,250,0,10,0,75,0,0,0,44,0,92,0,94,0,0,0,172,0,97,0,160,0,165,0,2,0,214,0,68,0,53,0,242,0,111,0,165,0,0,0,119,0,6,0,229,0,54,0,0,0,0,0,254,0,10,0,0,0,224,0,92,0,109,0,187,0,102,0,49,0,177,0,235,0,221,0,205,0,0,0,29,0,179,0,39,0,11,0,221,0,190,0,9,0,0,0,212,0,11,0,252,0,31,0,33,0,198,0,222,0,139,0,119,0,171,0,70,0,240,0,3,0,163,0,5,0,168,0,0,0,128,0,133,0,195,0,57,0,240,0,240,0,108,0,250,0,0,0,171,0,82,0,0,0,60,0,239,0,17,0,0,0,36,0,101,0,48,0,0,0,39,0,0,0,255,0,109,0,0,0,122,0,234,0,113,0,179,0,121,0,84,0,190,0,255,0,131,0,141,0,130,0,173,0,158,0,163,0,151,0,0,0,0,0,165,0,66,0,76,0,173,0,42,0,72,0,58,0,44,0,109,0,50,0,239,0,0,0,233,0,0,0,58,0,174,0);
signal scenario_full  : scenario_type := (143,31,106,31,188,31,1,31,194,31,194,30,203,31,60,31,174,31,5,31,152,31,185,31,200,31,47,31,54,31,201,31,200,31,34,31,68,31,224,31,172,31,28,31,222,31,143,31,143,30,22,31,22,30,37,31,127,31,127,30,133,31,206,31,231,31,125,31,1,31,101,31,149,31,121,31,243,31,111,31,111,30,111,29,144,31,177,31,70,31,247,31,247,30,247,29,185,31,164,31,89,31,89,30,60,31,153,31,217,31,157,31,95,31,98,31,98,30,232,31,198,31,44,31,83,31,87,31,212,31,71,31,71,30,71,29,71,28,81,31,207,31,207,30,244,31,244,30,158,31,50,31,27,31,27,30,27,29,251,31,106,31,101,31,249,31,3,31,3,30,3,29,74,31,218,31,157,31,34,31,34,30,178,31,56,31,65,31,65,30,65,29,15,31,47,31,90,31,90,30,204,31,51,31,135,31,135,30,100,31,100,30,100,29,87,31,45,31,189,31,222,31,203,31,172,31,242,31,235,31,49,31,47,31,114,31,114,30,114,29,155,31,71,31,238,31,238,30,47,31,69,31,40,31,40,30,40,29,194,31,125,31,20,31,238,31,160,31,94,31,53,31,43,31,40,31,197,31,18,31,18,30,18,29,20,31,120,31,214,31,23,31,23,30,57,31,212,31,80,31,182,31,108,31,108,30,200,31,80,31,28,31,23,31,106,31,154,31,154,30,228,31,37,31,37,30,249,31,186,31,136,31,234,31,164,31,98,31,120,31,104,31,93,31,255,31,130,31,144,31,224,31,224,30,224,29,224,28,215,31,24,31,139,31,140,31,44,31,44,30,215,31,215,30,128,31,254,31,209,31,209,30,97,31,97,30,97,29,97,28,70,31,21,31,21,30,18,31,77,31,77,30,7,31,212,31,101,31,101,30,101,29,117,31,76,31,93,31,93,30,250,31,11,31,221,31,87,31,56,31,134,31,150,31,244,31,246,31,120,31,160,31,160,30,160,29,52,31,108,31,64,31,46,31,5,31,99,31,66,31,16,31,111,31,113,31,66,31,65,31,106,31,106,30,106,29,106,28,99,31,83,31,189,31,233,31,38,31,180,31,179,31,38,31,246,31,50,31,186,31,231,31,117,31,203,31,226,31,226,30,175,31,238,31,176,31,227,31,227,30,227,29,227,28,31,31,27,31,181,31,172,31,172,30,202,31,141,31,181,31,46,31,198,31,139,31,160,31,25,31,70,31,191,31,84,31,92,31,92,30,183,31,8,31,113,31,59,31,251,31,168,31,193,31,218,31,93,31,126,31,112,31,106,31,129,31,61,31,159,31,119,31,248,31,148,31,135,31,135,30,85,31,108,31,122,31,95,31,229,31,122,31,223,31,223,30,188,31,208,31,252,31,109,31,211,31,198,31,198,30,198,29,106,31,106,30,209,31,68,31,55,31,132,31,124,31,54,31,234,31,137,31,110,31,84,31,208,31,130,31,130,30,100,31,73,31,190,31,74,31,32,31,89,31,177,31,177,30,113,31,128,31,150,31,150,30,168,31,245,31,245,30,245,29,9,31,133,31,43,31,16,31,59,31,226,31,42,31,205,31,34,31,203,31,47,31,158,31,241,31,241,30,147,31,59,31,214,31,213,31,84,31,94,31,194,31,194,30,217,31,39,31,112,31,134,31,190,31,191,31,219,31,107,31,107,30,107,29,220,31,13,31,187,31,187,30,27,31,161,31,57,31,218,31,169,31,141,31,84,31,99,31,61,31,61,30,145,31,109,31,109,30,92,31,185,31,185,30,185,29,185,28,31,31,31,30,70,31,66,31,66,30,201,31,171,31,52,31,149,31,216,31,81,31,178,31,156,31,115,31,176,31,213,31,156,31,145,31,183,31,148,31,162,31,95,31,212,31,119,31,167,31,28,31,74,31,155,31,251,31,111,31,111,30,76,31,178,31,178,30,58,31,183,31,230,31,153,31,216,31,148,31,8,31,8,30,118,31,118,30,100,31,220,31,24,31,114,31,114,30,114,29,144,31,42,31,215,31,155,31,14,31,67,31,225,31,70,31,1,31,147,31,110,31,231,31,158,31,160,31,136,31,136,30,72,31,153,31,232,31,155,31,155,30,248,31,180,31,159,31,79,31,206,31,11,31,150,31,107,31,158,31,118,31,229,31,41,31,41,30,18,31,22,31,227,31,15,31,71,31,226,31,153,31,169,31,202,31,122,31,208,31,164,31,164,30,109,31,13,31,75,31,144,31,204,31,253,31,253,30,253,29,38,31,38,30,169,31,137,31,156,31,195,31,108,31,215,31,4,31,4,30,186,31,58,31,22,31,131,31,131,30,131,29,208,31,112,31,18,31,18,30,216,31,174,31,68,31,170,31,80,31,183,31,106,31,106,30,74,31,59,31,7,31,120,31,124,31,124,30,124,29,124,28,88,31,9,31,23,31,23,30,107,31,36,31,143,31,164,31,58,31,5,31,5,30,75,31,75,30,81,31,34,31,32,31,36,31,192,31,120,31,8,31,172,31,172,30,78,31,92,31,219,31,67,31,67,30,67,29,97,31,142,31,130,31,86,31,100,31,19,31,19,30,144,31,51,31,181,31,114,31,164,31,60,31,19,31,218,31,218,30,14,31,190,31,190,30,227,31,17,31,88,31,3,31,3,30,2,31,223,31,223,30,195,31,201,31,102,31,9,31,252,31,254,31,185,31,79,31,166,31,190,31,189,31,189,30,125,31,4,31,4,30,231,31,141,31,116,31,172,31,158,31,158,30,45,31,45,30,249,31,215,31,251,31,46,31,46,30,46,29,27,31,35,31,91,31,8,31,211,31,41,31,17,31,17,30,17,29,17,28,167,31,79,31,137,31,137,30,189,31,104,31,233,31,189,31,18,31,143,31,70,31,70,30,107,31,32,31,24,31,24,30,24,29,33,31,190,31,16,31,89,31,196,31,196,30,200,31,226,31,2,31,2,30,145,31,117,31,44,31,44,30,5,31,5,30,34,31,166,31,166,30,226,31,204,31,69,31,85,31,116,31,116,30,154,31,8,31,225,31,157,31,157,30,2,31,229,31,35,31,35,30,35,29,35,28,35,27,115,31,165,31,75,31,53,31,67,31,204,31,204,30,8,31,54,31,229,31,21,31,162,31,162,30,162,29,162,28,94,31,133,31,133,30,28,31,28,30,28,29,233,31,233,30,63,31,32,31,32,30,133,31,133,30,250,31,33,31,124,31,173,31,38,31,250,31,181,31,17,31,17,30,223,31,202,31,162,31,77,31,174,31,61,31,61,30,87,31,239,31,212,31,75,31,45,31,83,31,70,31,218,31,237,31,223,31,233,31,233,30,129,31,3,31,3,30,74,31,97,31,103,31,13,31,13,30,240,31,210,31,227,31,214,31,93,31,49,31,200,31,24,31,141,31,187,31,187,30,102,31,219,31,200,31,209,31,136,31,199,31,60,31,247,31,94,31,5,31,124,31,11,31,16,31,117,31,25,31,44,31,154,31,195,31,250,31,10,31,75,31,75,30,44,31,92,31,94,31,94,30,172,31,97,31,160,31,165,31,2,31,214,31,68,31,53,31,242,31,111,31,165,31,165,30,119,31,6,31,229,31,54,31,54,30,54,29,254,31,10,31,10,30,224,31,92,31,109,31,187,31,102,31,49,31,177,31,235,31,221,31,205,31,205,30,29,31,179,31,39,31,11,31,221,31,190,31,9,31,9,30,212,31,11,31,252,31,31,31,33,31,198,31,222,31,139,31,119,31,171,31,70,31,240,31,3,31,163,31,5,31,168,31,168,30,128,31,133,31,195,31,57,31,240,31,240,31,108,31,250,31,250,30,171,31,82,31,82,30,60,31,239,31,17,31,17,30,36,31,101,31,48,31,48,30,39,31,39,30,255,31,109,31,109,30,122,31,234,31,113,31,179,31,121,31,84,31,190,31,255,31,131,31,141,31,130,31,173,31,158,31,163,31,151,31,151,30,151,29,165,31,66,31,76,31,173,31,42,31,72,31,58,31,44,31,109,31,50,31,239,31,239,30,233,31,233,30,58,31,174,31);

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
