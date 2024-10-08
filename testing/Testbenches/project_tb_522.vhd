-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_522 is
end project_tb_522;

architecture project_tb_arch_522 of project_tb_522 is
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

constant SCENARIO_LENGTH : integer := 909;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (161,0,191,0,0,0,0,0,253,0,110,0,6,0,38,0,149,0,153,0,18,0,0,0,35,0,41,0,230,0,29,0,0,0,27,0,116,0,0,0,0,0,74,0,0,0,193,0,203,0,194,0,0,0,121,0,86,0,86,0,0,0,207,0,213,0,246,0,139,0,0,0,28,0,227,0,23,0,69,0,48,0,184,0,114,0,69,0,15,0,200,0,31,0,235,0,219,0,69,0,130,0,4,0,115,0,72,0,58,0,199,0,164,0,0,0,0,0,252,0,202,0,83,0,0,0,0,0,39,0,25,0,95,0,56,0,0,0,48,0,143,0,213,0,86,0,32,0,90,0,68,0,167,0,19,0,0,0,132,0,79,0,159,0,63,0,199,0,145,0,181,0,228,0,68,0,35,0,0,0,21,0,169,0,189,0,240,0,124,0,233,0,203,0,0,0,0,0,229,0,183,0,110,0,61,0,24,0,241,0,158,0,0,0,0,0,125,0,0,0,16,0,166,0,0,0,0,0,122,0,145,0,0,0,243,0,148,0,0,0,119,0,211,0,233,0,190,0,123,0,0,0,0,0,103,0,5,0,136,0,63,0,105,0,0,0,131,0,0,0,65,0,0,0,69,0,178,0,231,0,28,0,152,0,168,0,0,0,0,0,116,0,49,0,249,0,16,0,136,0,115,0,131,0,85,0,53,0,188,0,18,0,174,0,0,0,23,0,0,0,0,0,0,0,178,0,16,0,16,0,0,0,95,0,159,0,193,0,245,0,154,0,175,0,35,0,57,0,224,0,132,0,0,0,161,0,241,0,0,0,0,0,222,0,56,0,191,0,0,0,211,0,45,0,167,0,117,0,93,0,220,0,0,0,219,0,64,0,231,0,131,0,225,0,0,0,28,0,232,0,75,0,0,0,3,0,0,0,227,0,253,0,0,0,247,0,125,0,118,0,1,0,235,0,66,0,18,0,52,0,71,0,217,0,57,0,204,0,26,0,0,0,100,0,0,0,131,0,103,0,188,0,0,0,203,0,58,0,0,0,229,0,165,0,0,0,126,0,0,0,235,0,0,0,237,0,26,0,171,0,98,0,230,0,210,0,169,0,0,0,51,0,0,0,0,0,114,0,0,0,185,0,106,0,7,0,6,0,135,0,240,0,0,0,70,0,220,0,20,0,86,0,137,0,13,0,146,0,67,0,0,0,140,0,118,0,0,0,92,0,41,0,2,0,130,0,166,0,169,0,104,0,58,0,200,0,0,0,66,0,217,0,128,0,120,0,73,0,0,0,0,0,85,0,0,0,169,0,170,0,1,0,57,0,17,0,219,0,132,0,0,0,32,0,167,0,35,0,0,0,245,0,0,0,170,0,0,0,0,0,105,0,77,0,30,0,99,0,0,0,167,0,0,0,206,0,243,0,101,0,205,0,3,0,183,0,106,0,222,0,74,0,190,0,0,0,207,0,145,0,193,0,18,0,253,0,0,0,41,0,0,0,197,0,230,0,0,0,18,0,0,0,141,0,0,0,213,0,32,0,0,0,34,0,62,0,53,0,0,0,219,0,0,0,119,0,143,0,17,0,15,0,122,0,181,0,125,0,0,0,21,0,50,0,146,0,37,0,0,0,19,0,98,0,0,0,0,0,115,0,161,0,0,0,102,0,4,0,252,0,199,0,121,0,0,0,21,0,188,0,0,0,182,0,208,0,203,0,65,0,82,0,55,0,135,0,223,0,109,0,174,0,0,0,0,0,66,0,198,0,0,0,161,0,155,0,90,0,103,0,240,0,33,0,218,0,132,0,255,0,128,0,73,0,0,0,30,0,0,0,0,0,2,0,0,0,0,0,118,0,31,0,6,0,145,0,233,0,147,0,134,0,22,0,229,0,230,0,0,0,250,0,185,0,48,0,247,0,198,0,164,0,251,0,0,0,0,0,228,0,104,0,32,0,88,0,49,0,60,0,7,0,0,0,92,0,0,0,163,0,204,0,190,0,222,0,246,0,167,0,144,0,82,0,0,0,184,0,174,0,40,0,23,0,0,0,0,0,0,0,213,0,182,0,175,0,114,0,0,0,141,0,0,0,202,0,139,0,1,0,211,0,34,0,76,0,202,0,69,0,234,0,232,0,106,0,96,0,232,0,0,0,0,0,119,0,30,0,88,0,172,0,69,0,87,0,185,0,41,0,116,0,133,0,27,0,0,0,213,0,0,0,216,0,31,0,156,0,0,0,189,0,220,0,6,0,133,0,216,0,250,0,0,0,233,0,108,0,43,0,156,0,141,0,133,0,247,0,179,0,247,0,0,0,242,0,65,0,66,0,16,0,240,0,233,0,51,0,230,0,223,0,210,0,0,0,20,0,0,0,198,0,15,0,0,0,95,0,109,0,244,0,237,0,0,0,0,0,84,0,182,0,123,0,138,0,12,0,85,0,0,0,0,0,12,0,149,0,33,0,74,0,83,0,194,0,189,0,48,0,0,0,161,0,51,0,156,0,213,0,81,0,11,0,122,0,38,0,0,0,130,0,0,0,219,0,192,0,52,0,227,0,0,0,0,0,195,0,152,0,99,0,0,0,229,0,96,0,220,0,88,0,170,0,20,0,162,0,97,0,110,0,21,0,85,0,244,0,6,0,0,0,116,0,0,0,159,0,236,0,41,0,0,0,107,0,34,0,0,0,0,0,0,0,0,0,141,0,213,0,0,0,142,0,27,0,108,0,103,0,241,0,33,0,0,0,153,0,72,0,193,0,237,0,106,0,181,0,177,0,51,0,95,0,0,0,0,0,131,0,86,0,29,0,0,0,242,0,227,0,130,0,0,0,0,0,0,0,58,0,52,0,11,0,0,0,0,0,252,0,101,0,126,0,46,0,212,0,0,0,160,0,0,0,106,0,233,0,170,0,70,0,69,0,164,0,132,0,9,0,150,0,146,0,0,0,124,0,172,0,176,0,214,0,157,0,172,0,208,0,231,0,0,0,52,0,0,0,159,0,175,0,36,0,68,0,33,0,0,0,158,0,177,0,58,0,5,0,23,0,157,0,60,0,151,0,240,0,250,0,0,0,141,0,138,0,0,0,43,0,151,0,171,0,135,0,202,0,185,0,210,0,123,0,224,0,84,0,65,0,224,0,0,0,14,0,0,0,117,0,236,0,50,0,41,0,0,0,105,0,80,0,56,0,16,0,248,0,106,0,108,0,28,0,24,0,16,0,0,0,82,0,127,0,151,0,88,0,0,0,96,0,0,0,0,0,0,0,178,0,170,0,190,0,166,0,0,0,0,0,0,0,156,0,94,0,110,0,235,0,239,0,247,0,80,0,0,0,8,0,0,0,94,0,0,0,189,0,173,0,231,0,211,0,149,0,35,0,94,0,23,0,78,0,0,0,212,0,0,0,43,0,96,0,0,0,208,0,225,0,215,0,0,0,0,0,206,0,228,0,201,0,75,0,236,0,0,0,21,0,52,0,248,0,15,0,31,0,15,0,0,0,20,0,187,0,73,0,214,0,204,0,18,0,33,0,65,0,171,0,160,0,253,0,220,0,229,0,30,0,248,0,27,0,0,0,250,0,155,0,15,0,88,0,47,0,14,0,227,0,84,0,151,0,240,0,87,0,171,0,16,0,114,0,0,0,9,0,150,0,170,0,0,0,83,0,0,0,205,0,89,0,0,0,250,0,69,0,0,0,4,0,21,0,253,0,94,0,0,0,9,0,54,0,156,0,155,0,0,0,139,0,166,0,18,0,24,0,178,0,36,0,0,0,119,0,130,0,139,0,158,0,188,0,180,0,0,0,8,0,158,0,178,0,36,0,51,0,230,0,63,0,29,0,183,0,0,0,76,0,0,0,175,0,192,0,117,0,155,0,206,0,35,0,4,0,0,0,13,0,7,0,250,0,245,0,0,0,103,0,0,0,0,0,41,0,233,0,126,0,87,0,127,0,215,0,95,0,92,0,181,0,227,0,0,0,0,0,157,0,173,0,122,0,71,0,66,0,39,0,20,0,11,0,143,0,20,0,224,0,60,0,177,0,249,0,0,0,147,0,102,0,237,0,0,0,130,0,169,0,0,0,135,0,0,0,109,0);
signal scenario_full  : scenario_type := (161,31,191,31,191,30,191,29,253,31,110,31,6,31,38,31,149,31,153,31,18,31,18,30,35,31,41,31,230,31,29,31,29,30,27,31,116,31,116,30,116,29,74,31,74,30,193,31,203,31,194,31,194,30,121,31,86,31,86,31,86,30,207,31,213,31,246,31,139,31,139,30,28,31,227,31,23,31,69,31,48,31,184,31,114,31,69,31,15,31,200,31,31,31,235,31,219,31,69,31,130,31,4,31,115,31,72,31,58,31,199,31,164,31,164,30,164,29,252,31,202,31,83,31,83,30,83,29,39,31,25,31,95,31,56,31,56,30,48,31,143,31,213,31,86,31,32,31,90,31,68,31,167,31,19,31,19,30,132,31,79,31,159,31,63,31,199,31,145,31,181,31,228,31,68,31,35,31,35,30,21,31,169,31,189,31,240,31,124,31,233,31,203,31,203,30,203,29,229,31,183,31,110,31,61,31,24,31,241,31,158,31,158,30,158,29,125,31,125,30,16,31,166,31,166,30,166,29,122,31,145,31,145,30,243,31,148,31,148,30,119,31,211,31,233,31,190,31,123,31,123,30,123,29,103,31,5,31,136,31,63,31,105,31,105,30,131,31,131,30,65,31,65,30,69,31,178,31,231,31,28,31,152,31,168,31,168,30,168,29,116,31,49,31,249,31,16,31,136,31,115,31,131,31,85,31,53,31,188,31,18,31,174,31,174,30,23,31,23,30,23,29,23,28,178,31,16,31,16,31,16,30,95,31,159,31,193,31,245,31,154,31,175,31,35,31,57,31,224,31,132,31,132,30,161,31,241,31,241,30,241,29,222,31,56,31,191,31,191,30,211,31,45,31,167,31,117,31,93,31,220,31,220,30,219,31,64,31,231,31,131,31,225,31,225,30,28,31,232,31,75,31,75,30,3,31,3,30,227,31,253,31,253,30,247,31,125,31,118,31,1,31,235,31,66,31,18,31,52,31,71,31,217,31,57,31,204,31,26,31,26,30,100,31,100,30,131,31,103,31,188,31,188,30,203,31,58,31,58,30,229,31,165,31,165,30,126,31,126,30,235,31,235,30,237,31,26,31,171,31,98,31,230,31,210,31,169,31,169,30,51,31,51,30,51,29,114,31,114,30,185,31,106,31,7,31,6,31,135,31,240,31,240,30,70,31,220,31,20,31,86,31,137,31,13,31,146,31,67,31,67,30,140,31,118,31,118,30,92,31,41,31,2,31,130,31,166,31,169,31,104,31,58,31,200,31,200,30,66,31,217,31,128,31,120,31,73,31,73,30,73,29,85,31,85,30,169,31,170,31,1,31,57,31,17,31,219,31,132,31,132,30,32,31,167,31,35,31,35,30,245,31,245,30,170,31,170,30,170,29,105,31,77,31,30,31,99,31,99,30,167,31,167,30,206,31,243,31,101,31,205,31,3,31,183,31,106,31,222,31,74,31,190,31,190,30,207,31,145,31,193,31,18,31,253,31,253,30,41,31,41,30,197,31,230,31,230,30,18,31,18,30,141,31,141,30,213,31,32,31,32,30,34,31,62,31,53,31,53,30,219,31,219,30,119,31,143,31,17,31,15,31,122,31,181,31,125,31,125,30,21,31,50,31,146,31,37,31,37,30,19,31,98,31,98,30,98,29,115,31,161,31,161,30,102,31,4,31,252,31,199,31,121,31,121,30,21,31,188,31,188,30,182,31,208,31,203,31,65,31,82,31,55,31,135,31,223,31,109,31,174,31,174,30,174,29,66,31,198,31,198,30,161,31,155,31,90,31,103,31,240,31,33,31,218,31,132,31,255,31,128,31,73,31,73,30,30,31,30,30,30,29,2,31,2,30,2,29,118,31,31,31,6,31,145,31,233,31,147,31,134,31,22,31,229,31,230,31,230,30,250,31,185,31,48,31,247,31,198,31,164,31,251,31,251,30,251,29,228,31,104,31,32,31,88,31,49,31,60,31,7,31,7,30,92,31,92,30,163,31,204,31,190,31,222,31,246,31,167,31,144,31,82,31,82,30,184,31,174,31,40,31,23,31,23,30,23,29,23,28,213,31,182,31,175,31,114,31,114,30,141,31,141,30,202,31,139,31,1,31,211,31,34,31,76,31,202,31,69,31,234,31,232,31,106,31,96,31,232,31,232,30,232,29,119,31,30,31,88,31,172,31,69,31,87,31,185,31,41,31,116,31,133,31,27,31,27,30,213,31,213,30,216,31,31,31,156,31,156,30,189,31,220,31,6,31,133,31,216,31,250,31,250,30,233,31,108,31,43,31,156,31,141,31,133,31,247,31,179,31,247,31,247,30,242,31,65,31,66,31,16,31,240,31,233,31,51,31,230,31,223,31,210,31,210,30,20,31,20,30,198,31,15,31,15,30,95,31,109,31,244,31,237,31,237,30,237,29,84,31,182,31,123,31,138,31,12,31,85,31,85,30,85,29,12,31,149,31,33,31,74,31,83,31,194,31,189,31,48,31,48,30,161,31,51,31,156,31,213,31,81,31,11,31,122,31,38,31,38,30,130,31,130,30,219,31,192,31,52,31,227,31,227,30,227,29,195,31,152,31,99,31,99,30,229,31,96,31,220,31,88,31,170,31,20,31,162,31,97,31,110,31,21,31,85,31,244,31,6,31,6,30,116,31,116,30,159,31,236,31,41,31,41,30,107,31,34,31,34,30,34,29,34,28,34,27,141,31,213,31,213,30,142,31,27,31,108,31,103,31,241,31,33,31,33,30,153,31,72,31,193,31,237,31,106,31,181,31,177,31,51,31,95,31,95,30,95,29,131,31,86,31,29,31,29,30,242,31,227,31,130,31,130,30,130,29,130,28,58,31,52,31,11,31,11,30,11,29,252,31,101,31,126,31,46,31,212,31,212,30,160,31,160,30,106,31,233,31,170,31,70,31,69,31,164,31,132,31,9,31,150,31,146,31,146,30,124,31,172,31,176,31,214,31,157,31,172,31,208,31,231,31,231,30,52,31,52,30,159,31,175,31,36,31,68,31,33,31,33,30,158,31,177,31,58,31,5,31,23,31,157,31,60,31,151,31,240,31,250,31,250,30,141,31,138,31,138,30,43,31,151,31,171,31,135,31,202,31,185,31,210,31,123,31,224,31,84,31,65,31,224,31,224,30,14,31,14,30,117,31,236,31,50,31,41,31,41,30,105,31,80,31,56,31,16,31,248,31,106,31,108,31,28,31,24,31,16,31,16,30,82,31,127,31,151,31,88,31,88,30,96,31,96,30,96,29,96,28,178,31,170,31,190,31,166,31,166,30,166,29,166,28,156,31,94,31,110,31,235,31,239,31,247,31,80,31,80,30,8,31,8,30,94,31,94,30,189,31,173,31,231,31,211,31,149,31,35,31,94,31,23,31,78,31,78,30,212,31,212,30,43,31,96,31,96,30,208,31,225,31,215,31,215,30,215,29,206,31,228,31,201,31,75,31,236,31,236,30,21,31,52,31,248,31,15,31,31,31,15,31,15,30,20,31,187,31,73,31,214,31,204,31,18,31,33,31,65,31,171,31,160,31,253,31,220,31,229,31,30,31,248,31,27,31,27,30,250,31,155,31,15,31,88,31,47,31,14,31,227,31,84,31,151,31,240,31,87,31,171,31,16,31,114,31,114,30,9,31,150,31,170,31,170,30,83,31,83,30,205,31,89,31,89,30,250,31,69,31,69,30,4,31,21,31,253,31,94,31,94,30,9,31,54,31,156,31,155,31,155,30,139,31,166,31,18,31,24,31,178,31,36,31,36,30,119,31,130,31,139,31,158,31,188,31,180,31,180,30,8,31,158,31,178,31,36,31,51,31,230,31,63,31,29,31,183,31,183,30,76,31,76,30,175,31,192,31,117,31,155,31,206,31,35,31,4,31,4,30,13,31,7,31,250,31,245,31,245,30,103,31,103,30,103,29,41,31,233,31,126,31,87,31,127,31,215,31,95,31,92,31,181,31,227,31,227,30,227,29,157,31,173,31,122,31,71,31,66,31,39,31,20,31,11,31,143,31,20,31,224,31,60,31,177,31,249,31,249,30,147,31,102,31,237,31,237,30,130,31,169,31,169,30,135,31,135,30,109,31);

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
