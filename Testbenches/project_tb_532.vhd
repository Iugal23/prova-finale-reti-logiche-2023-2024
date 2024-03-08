-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_532 is
end project_tb_532;

architecture project_tb_arch_532 of project_tb_532 is
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

constant SCENARIO_LENGTH : integer := 907;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,7,0,73,0,38,0,73,0,0,0,235,0,124,0,224,0,169,0,137,0,17,0,179,0,237,0,203,0,8,0,134,0,124,0,155,0,0,0,139,0,0,0,0,0,198,0,251,0,217,0,58,0,154,0,111,0,23,0,210,0,90,0,14,0,228,0,213,0,30,0,120,0,54,0,176,0,0,0,166,0,217,0,220,0,47,0,235,0,135,0,48,0,0,0,132,0,26,0,216,0,192,0,61,0,70,0,0,0,0,0,37,0,217,0,197,0,0,0,39,0,224,0,32,0,0,0,189,0,0,0,92,0,113,0,0,0,156,0,130,0,0,0,139,0,47,0,0,0,168,0,233,0,81,0,48,0,251,0,0,0,32,0,53,0,222,0,232,0,26,0,110,0,0,0,0,0,215,0,61,0,230,0,82,0,0,0,101,0,107,0,0,0,37,0,28,0,87,0,135,0,11,0,0,0,27,0,215,0,235,0,0,0,6,0,0,0,35,0,107,0,0,0,244,0,75,0,115,0,137,0,110,0,240,0,147,0,91,0,206,0,203,0,11,0,76,0,0,0,94,0,180,0,169,0,0,0,206,0,117,0,179,0,76,0,91,0,165,0,0,0,58,0,209,0,10,0,193,0,63,0,50,0,0,0,126,0,76,0,13,0,22,0,76,0,10,0,156,0,96,0,79,0,113,0,221,0,29,0,245,0,0,0,213,0,198,0,118,0,67,0,177,0,15,0,194,0,132,0,84,0,225,0,0,0,139,0,0,0,0,0,202,0,14,0,163,0,0,0,0,0,183,0,4,0,98,0,93,0,16,0,74,0,117,0,232,0,57,0,145,0,239,0,29,0,173,0,0,0,159,0,0,0,14,0,13,0,2,0,90,0,153,0,53,0,41,0,246,0,75,0,69,0,180,0,8,0,163,0,14,0,0,0,73,0,7,0,205,0,241,0,102,0,253,0,219,0,52,0,128,0,0,0,79,0,63,0,123,0,0,0,206,0,26,0,0,0,39,0,0,0,163,0,54,0,114,0,108,0,105,0,55,0,156,0,40,0,37,0,0,0,32,0,23,0,32,0,56,0,110,0,0,0,163,0,195,0,232,0,43,0,55,0,97,0,0,0,0,0,15,0,166,0,0,0,0,0,242,0,114,0,114,0,120,0,133,0,168,0,0,0,151,0,119,0,251,0,49,0,52,0,30,0,78,0,0,0,221,0,0,0,64,0,0,0,65,0,32,0,202,0,18,0,124,0,57,0,232,0,91,0,144,0,201,0,214,0,152,0,234,0,236,0,208,0,86,0,30,0,229,0,197,0,45,0,170,0,108,0,178,0,209,0,128,0,242,0,0,0,0,0,0,0,209,0,239,0,76,0,28,0,225,0,0,0,62,0,180,0,0,0,212,0,0,0,0,0,251,0,124,0,163,0,100,0,129,0,62,0,0,0,37,0,43,0,103,0,40,0,227,0,33,0,57,0,204,0,23,0,94,0,102,0,47,0,210,0,64,0,201,0,101,0,131,0,241,0,124,0,84,0,224,0,101,0,225,0,0,0,126,0,111,0,212,0,193,0,166,0,23,0,169,0,251,0,232,0,28,0,200,0,29,0,21,0,238,0,30,0,37,0,138,0,41,0,68,0,221,0,161,0,104,0,149,0,43,0,107,0,153,0,58,0,211,0,0,0,253,0,78,0,109,0,39,0,18,0,0,0,0,0,156,0,0,0,0,0,0,0,219,0,144,0,233,0,90,0,175,0,235,0,128,0,214,0,169,0,4,0,63,0,0,0,203,0,46,0,137,0,211,0,0,0,115,0,16,0,235,0,0,0,139,0,235,0,27,0,176,0,207,0,105,0,230,0,186,0,139,0,119,0,70,0,214,0,209,0,143,0,99,0,21,0,123,0,186,0,129,0,0,0,123,0,114,0,4,0,0,0,85,0,0,0,0,0,0,0,0,0,128,0,52,0,74,0,0,0,50,0,172,0,209,0,45,0,188,0,0,0,86,0,223,0,215,0,252,0,0,0,180,0,104,0,87,0,118,0,79,0,130,0,144,0,215,0,118,0,185,0,0,0,157,0,205,0,151,0,0,0,107,0,132,0,0,0,37,0,1,0,183,0,87,0,24,0,0,0,0,0,106,0,209,0,39,0,0,0,0,0,234,0,64,0,63,0,106,0,214,0,150,0,161,0,180,0,242,0,60,0,0,0,188,0,159,0,139,0,131,0,238,0,124,0,120,0,37,0,0,0,0,0,175,0,32,0,223,0,97,0,132,0,51,0,0,0,136,0,0,0,3,0,207,0,79,0,141,0,187,0,0,0,34,0,82,0,85,0,0,0,100,0,187,0,22,0,25,0,40,0,135,0,96,0,0,0,203,0,229,0,145,0,174,0,114,0,3,0,129,0,74,0,0,0,133,0,0,0,25,0,136,0,0,0,0,0,48,0,80,0,190,0,178,0,179,0,81,0,0,0,0,0,206,0,69,0,0,0,30,0,67,0,66,0,92,0,2,0,98,0,0,0,249,0,241,0,31,0,0,0,131,0,250,0,0,0,116,0,212,0,115,0,0,0,90,0,173,0,43,0,229,0,237,0,232,0,96,0,241,0,104,0,0,0,210,0,174,0,32,0,68,0,91,0,191,0,234,0,0,0,4,0,0,0,46,0,0,0,233,0,249,0,117,0,157,0,252,0,86,0,183,0,3,0,226,0,234,0,49,0,147,0,111,0,24,0,8,0,161,0,122,0,225,0,3,0,31,0,196,0,0,0,6,0,195,0,38,0,209,0,0,0,76,0,54,0,178,0,134,0,84,0,0,0,43,0,0,0,0,0,232,0,10,0,130,0,57,0,216,0,167,0,48,0,103,0,158,0,13,0,123,0,83,0,155,0,108,0,0,0,162,0,0,0,0,0,38,0,255,0,8,0,0,0,231,0,37,0,62,0,163,0,117,0,230,0,72,0,178,0,94,0,85,0,252,0,141,0,108,0,13,0,0,0,184,0,71,0,0,0,86,0,181,0,156,0,253,0,88,0,0,0,208,0,0,0,125,0,224,0,134,0,57,0,132,0,104,0,0,0,17,0,0,0,192,0,177,0,90,0,178,0,233,0,0,0,134,0,38,0,48,0,0,0,242,0,244,0,19,0,252,0,61,0,165,0,195,0,193,0,198,0,38,0,0,0,19,0,0,0,175,0,136,0,48,0,0,0,211,0,121,0,0,0,102,0,62,0,129,0,135,0,73,0,151,0,235,0,110,0,120,0,140,0,113,0,167,0,33,0,167,0,72,0,0,0,157,0,39,0,218,0,180,0,199,0,21,0,161,0,0,0,42,0,10,0,71,0,11,0,35,0,175,0,125,0,198,0,171,0,0,0,205,0,18,0,0,0,0,0,161,0,0,0,0,0,35,0,9,0,117,0,0,0,0,0,0,0,176,0,104,0,41,0,0,0,0,0,31,0,0,0,164,0,43,0,43,0,94,0,73,0,240,0,0,0,59,0,88,0,204,0,165,0,177,0,0,0,15,0,231,0,12,0,148,0,86,0,0,0,15,0,50,0,0,0,248,0,195,0,0,0,192,0,177,0,0,0,33,0,235,0,25,0,53,0,190,0,40,0,232,0,205,0,128,0,0,0,54,0,0,0,3,0,217,0,99,0,0,0,0,0,38,0,121,0,0,0,0,0,86,0,158,0,175,0,0,0,247,0,0,0,197,0,243,0,207,0,254,0,186,0,0,0,46,0,154,0,51,0,0,0,234,0,254,0,197,0,27,0,126,0,5,0,133,0,37,0,175,0,0,0,169,0,40,0,37,0,70,0,1,0,0,0,76,0,0,0,130,0,85,0,64,0,131,0,65,0,0,0,176,0,94,0,67,0,47,0,145,0,0,0,8,0,0,0,0,0,52,0,254,0,70,0,156,0,0,0,248,0,253,0,228,0,81,0,0,0,203,0,20,0,22,0,0,0,158,0,216,0,240,0,18,0,138,0,0,0,0,0,44,0,232,0,16,0,11,0,0,0,203,0,119,0,0,0,179,0,99,0,67,0,56,0,152,0,0,0,0,0,16,0,52,0);
signal scenario_full  : scenario_type := (0,0,7,31,73,31,38,31,73,31,73,30,235,31,124,31,224,31,169,31,137,31,17,31,179,31,237,31,203,31,8,31,134,31,124,31,155,31,155,30,139,31,139,30,139,29,198,31,251,31,217,31,58,31,154,31,111,31,23,31,210,31,90,31,14,31,228,31,213,31,30,31,120,31,54,31,176,31,176,30,166,31,217,31,220,31,47,31,235,31,135,31,48,31,48,30,132,31,26,31,216,31,192,31,61,31,70,31,70,30,70,29,37,31,217,31,197,31,197,30,39,31,224,31,32,31,32,30,189,31,189,30,92,31,113,31,113,30,156,31,130,31,130,30,139,31,47,31,47,30,168,31,233,31,81,31,48,31,251,31,251,30,32,31,53,31,222,31,232,31,26,31,110,31,110,30,110,29,215,31,61,31,230,31,82,31,82,30,101,31,107,31,107,30,37,31,28,31,87,31,135,31,11,31,11,30,27,31,215,31,235,31,235,30,6,31,6,30,35,31,107,31,107,30,244,31,75,31,115,31,137,31,110,31,240,31,147,31,91,31,206,31,203,31,11,31,76,31,76,30,94,31,180,31,169,31,169,30,206,31,117,31,179,31,76,31,91,31,165,31,165,30,58,31,209,31,10,31,193,31,63,31,50,31,50,30,126,31,76,31,13,31,22,31,76,31,10,31,156,31,96,31,79,31,113,31,221,31,29,31,245,31,245,30,213,31,198,31,118,31,67,31,177,31,15,31,194,31,132,31,84,31,225,31,225,30,139,31,139,30,139,29,202,31,14,31,163,31,163,30,163,29,183,31,4,31,98,31,93,31,16,31,74,31,117,31,232,31,57,31,145,31,239,31,29,31,173,31,173,30,159,31,159,30,14,31,13,31,2,31,90,31,153,31,53,31,41,31,246,31,75,31,69,31,180,31,8,31,163,31,14,31,14,30,73,31,7,31,205,31,241,31,102,31,253,31,219,31,52,31,128,31,128,30,79,31,63,31,123,31,123,30,206,31,26,31,26,30,39,31,39,30,163,31,54,31,114,31,108,31,105,31,55,31,156,31,40,31,37,31,37,30,32,31,23,31,32,31,56,31,110,31,110,30,163,31,195,31,232,31,43,31,55,31,97,31,97,30,97,29,15,31,166,31,166,30,166,29,242,31,114,31,114,31,120,31,133,31,168,31,168,30,151,31,119,31,251,31,49,31,52,31,30,31,78,31,78,30,221,31,221,30,64,31,64,30,65,31,32,31,202,31,18,31,124,31,57,31,232,31,91,31,144,31,201,31,214,31,152,31,234,31,236,31,208,31,86,31,30,31,229,31,197,31,45,31,170,31,108,31,178,31,209,31,128,31,242,31,242,30,242,29,242,28,209,31,239,31,76,31,28,31,225,31,225,30,62,31,180,31,180,30,212,31,212,30,212,29,251,31,124,31,163,31,100,31,129,31,62,31,62,30,37,31,43,31,103,31,40,31,227,31,33,31,57,31,204,31,23,31,94,31,102,31,47,31,210,31,64,31,201,31,101,31,131,31,241,31,124,31,84,31,224,31,101,31,225,31,225,30,126,31,111,31,212,31,193,31,166,31,23,31,169,31,251,31,232,31,28,31,200,31,29,31,21,31,238,31,30,31,37,31,138,31,41,31,68,31,221,31,161,31,104,31,149,31,43,31,107,31,153,31,58,31,211,31,211,30,253,31,78,31,109,31,39,31,18,31,18,30,18,29,156,31,156,30,156,29,156,28,219,31,144,31,233,31,90,31,175,31,235,31,128,31,214,31,169,31,4,31,63,31,63,30,203,31,46,31,137,31,211,31,211,30,115,31,16,31,235,31,235,30,139,31,235,31,27,31,176,31,207,31,105,31,230,31,186,31,139,31,119,31,70,31,214,31,209,31,143,31,99,31,21,31,123,31,186,31,129,31,129,30,123,31,114,31,4,31,4,30,85,31,85,30,85,29,85,28,85,27,128,31,52,31,74,31,74,30,50,31,172,31,209,31,45,31,188,31,188,30,86,31,223,31,215,31,252,31,252,30,180,31,104,31,87,31,118,31,79,31,130,31,144,31,215,31,118,31,185,31,185,30,157,31,205,31,151,31,151,30,107,31,132,31,132,30,37,31,1,31,183,31,87,31,24,31,24,30,24,29,106,31,209,31,39,31,39,30,39,29,234,31,64,31,63,31,106,31,214,31,150,31,161,31,180,31,242,31,60,31,60,30,188,31,159,31,139,31,131,31,238,31,124,31,120,31,37,31,37,30,37,29,175,31,32,31,223,31,97,31,132,31,51,31,51,30,136,31,136,30,3,31,207,31,79,31,141,31,187,31,187,30,34,31,82,31,85,31,85,30,100,31,187,31,22,31,25,31,40,31,135,31,96,31,96,30,203,31,229,31,145,31,174,31,114,31,3,31,129,31,74,31,74,30,133,31,133,30,25,31,136,31,136,30,136,29,48,31,80,31,190,31,178,31,179,31,81,31,81,30,81,29,206,31,69,31,69,30,30,31,67,31,66,31,92,31,2,31,98,31,98,30,249,31,241,31,31,31,31,30,131,31,250,31,250,30,116,31,212,31,115,31,115,30,90,31,173,31,43,31,229,31,237,31,232,31,96,31,241,31,104,31,104,30,210,31,174,31,32,31,68,31,91,31,191,31,234,31,234,30,4,31,4,30,46,31,46,30,233,31,249,31,117,31,157,31,252,31,86,31,183,31,3,31,226,31,234,31,49,31,147,31,111,31,24,31,8,31,161,31,122,31,225,31,3,31,31,31,196,31,196,30,6,31,195,31,38,31,209,31,209,30,76,31,54,31,178,31,134,31,84,31,84,30,43,31,43,30,43,29,232,31,10,31,130,31,57,31,216,31,167,31,48,31,103,31,158,31,13,31,123,31,83,31,155,31,108,31,108,30,162,31,162,30,162,29,38,31,255,31,8,31,8,30,231,31,37,31,62,31,163,31,117,31,230,31,72,31,178,31,94,31,85,31,252,31,141,31,108,31,13,31,13,30,184,31,71,31,71,30,86,31,181,31,156,31,253,31,88,31,88,30,208,31,208,30,125,31,224,31,134,31,57,31,132,31,104,31,104,30,17,31,17,30,192,31,177,31,90,31,178,31,233,31,233,30,134,31,38,31,48,31,48,30,242,31,244,31,19,31,252,31,61,31,165,31,195,31,193,31,198,31,38,31,38,30,19,31,19,30,175,31,136,31,48,31,48,30,211,31,121,31,121,30,102,31,62,31,129,31,135,31,73,31,151,31,235,31,110,31,120,31,140,31,113,31,167,31,33,31,167,31,72,31,72,30,157,31,39,31,218,31,180,31,199,31,21,31,161,31,161,30,42,31,10,31,71,31,11,31,35,31,175,31,125,31,198,31,171,31,171,30,205,31,18,31,18,30,18,29,161,31,161,30,161,29,35,31,9,31,117,31,117,30,117,29,117,28,176,31,104,31,41,31,41,30,41,29,31,31,31,30,164,31,43,31,43,31,94,31,73,31,240,31,240,30,59,31,88,31,204,31,165,31,177,31,177,30,15,31,231,31,12,31,148,31,86,31,86,30,15,31,50,31,50,30,248,31,195,31,195,30,192,31,177,31,177,30,33,31,235,31,25,31,53,31,190,31,40,31,232,31,205,31,128,31,128,30,54,31,54,30,3,31,217,31,99,31,99,30,99,29,38,31,121,31,121,30,121,29,86,31,158,31,175,31,175,30,247,31,247,30,197,31,243,31,207,31,254,31,186,31,186,30,46,31,154,31,51,31,51,30,234,31,254,31,197,31,27,31,126,31,5,31,133,31,37,31,175,31,175,30,169,31,40,31,37,31,70,31,1,31,1,30,76,31,76,30,130,31,85,31,64,31,131,31,65,31,65,30,176,31,94,31,67,31,47,31,145,31,145,30,8,31,8,30,8,29,52,31,254,31,70,31,156,31,156,30,248,31,253,31,228,31,81,31,81,30,203,31,20,31,22,31,22,30,158,31,216,31,240,31,18,31,138,31,138,30,138,29,44,31,232,31,16,31,11,31,11,30,203,31,119,31,119,30,179,31,99,31,67,31,56,31,152,31,152,30,152,29,16,31,52,31);

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
