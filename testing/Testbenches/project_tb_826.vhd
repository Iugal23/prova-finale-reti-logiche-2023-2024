-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_826 is
end project_tb_826;

architecture project_tb_arch_826 of project_tb_826 is
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

signal scenario_input : scenario_type := (8,0,0,0,52,0,20,0,128,0,79,0,0,0,216,0,166,0,125,0,14,0,0,0,174,0,245,0,0,0,0,0,23,0,73,0,241,0,0,0,145,0,243,0,0,0,0,0,86,0,47,0,54,0,0,0,187,0,100,0,223,0,127,0,13,0,121,0,0,0,247,0,148,0,207,0,0,0,223,0,103,0,0,0,165,0,50,0,91,0,208,0,53,0,63,0,95,0,247,0,0,0,211,0,112,0,0,0,20,0,219,0,207,0,0,0,110,0,196,0,0,0,233,0,150,0,123,0,140,0,145,0,12,0,59,0,155,0,92,0,0,0,19,0,99,0,238,0,73,0,29,0,144,0,26,0,99,0,50,0,98,0,22,0,162,0,0,0,104,0,152,0,0,0,250,0,73,0,243,0,239,0,124,0,49,0,217,0,0,0,15,0,0,0,82,0,0,0,38,0,223,0,94,0,117,0,228,0,112,0,247,0,83,0,75,0,108,0,0,0,13,0,203,0,119,0,127,0,0,0,132,0,248,0,0,0,111,0,94,0,73,0,223,0,149,0,151,0,129,0,196,0,193,0,118,0,199,0,159,0,0,0,61,0,39,0,199,0,15,0,38,0,68,0,171,0,0,0,137,0,75,0,193,0,118,0,233,0,0,0,191,0,163,0,220,0,239,0,0,0,23,0,44,0,0,0,128,0,0,0,0,0,249,0,87,0,24,0,0,0,93,0,84,0,189,0,148,0,37,0,72,0,226,0,47,0,22,0,146,0,237,0,236,0,87,0,36,0,196,0,111,0,0,0,0,0,52,0,172,0,133,0,52,0,0,0,179,0,0,0,50,0,94,0,191,0,56,0,103,0,0,0,184,0,157,0,53,0,72,0,0,0,59,0,146,0,224,0,104,0,149,0,234,0,200,0,204,0,217,0,60,0,104,0,208,0,194,0,3,0,73,0,143,0,146,0,188,0,0,0,242,0,253,0,62,0,113,0,104,0,43,0,84,0,195,0,198,0,0,0,217,0,161,0,0,0,90,0,252,0,157,0,72,0,85,0,211,0,239,0,96,0,144,0,0,0,0,0,159,0,213,0,63,0,0,0,82,0,201,0,21,0,220,0,217,0,188,0,101,0,145,0,0,0,0,0,193,0,0,0,208,0,59,0,152,0,228,0,66,0,66,0,156,0,18,0,240,0,243,0,60,0,13,0,0,0,138,0,0,0,209,0,39,0,204,0,35,0,0,0,35,0,203,0,217,0,151,0,105,0,0,0,111,0,0,0,239,0,14,0,76,0,28,0,0,0,27,0,0,0,18,0,49,0,5,0,183,0,136,0,0,0,13,0,0,0,0,0,0,0,75,0,228,0,186,0,150,0,0,0,0,0,141,0,131,0,126,0,132,0,0,0,0,0,0,0,0,0,68,0,161,0,13,0,0,0,0,0,127,0,0,0,2,0,253,0,4,0,0,0,96,0,101,0,233,0,218,0,0,0,0,0,24,0,0,0,130,0,24,0,153,0,198,0,207,0,153,0,18,0,123,0,10,0,0,0,31,0,203,0,189,0,212,0,204,0,0,0,0,0,81,0,109,0,183,0,144,0,185,0,151,0,21,0,0,0,75,0,181,0,73,0,17,0,3,0,0,0,103,0,0,0,91,0,0,0,83,0,158,0,0,0,12,0,195,0,77,0,138,0,21,0,154,0,177,0,0,0,2,0,158,0,0,0,83,0,0,0,111,0,57,0,17,0,208,0,153,0,30,0,0,0,95,0,83,0,116,0,176,0,47,0,98,0,180,0,82,0,130,0,0,0,85,0,96,0,231,0,0,0,162,0,52,0,250,0,190,0,144,0,183,0,36,0,154,0,140,0,159,0,0,0,137,0,0,0,129,0,0,0,111,0,181,0,93,0,95,0,146,0,0,0,0,0,185,0,51,0,0,0,0,0,141,0,0,0,124,0,187,0,0,0,85,0,177,0,0,0,181,0,0,0,0,0,96,0,221,0,72,0,147,0,58,0,122,0,47,0,22,0,0,0,26,0,0,0,57,0,237,0,193,0,167,0,51,0,25,0,108,0,202,0,107,0,217,0,143,0,44,0,119,0,164,0,0,0,122,0,0,0,255,0,210,0,185,0,127,0,241,0,150,0,209,0,10,0,0,0,12,0,0,0,0,0,123,0,207,0,65,0,0,0,134,0,234,0,28,0,0,0,82,0,12,0,159,0,0,0,159,0,0,0,0,0,225,0,144,0,103,0,55,0,50,0,152,0,238,0,0,0,2,0,0,0,25,0,150,0,93,0,24,0,51,0,109,0,245,0,67,0,180,0,45,0,0,0,0,0,52,0,59,0,181,0,147,0,177,0,42,0,224,0,95,0,0,0,67,0,0,0,135,0,188,0,80,0,194,0,76,0,0,0,3,0,0,0,87,0,196,0,195,0,244,0,126,0,160,0,222,0,31,0,131,0,0,0,0,0,137,0,138,0,0,0,142,0,27,0,0,0,175,0,0,0,194,0,152,0,53,0,141,0,5,0,24,0,119,0,226,0,33,0,212,0,235,0,231,0,55,0,24,0,241,0,0,0,25,0,125,0,159,0,167,0,42,0,16,0,82,0,50,0,0,0,35,0,64,0,248,0,66,0,28,0,0,0,36,0,30,0,0,0,4,0,99,0,0,0,0,0,222,0,22,0,0,0,33,0,0,0,253,0,198,0,0,0,179,0,245,0,243,0,49,0,0,0,0,0,175,0,80,0,0,0,199,0,155,0,224,0,70,0,144,0,0,0,24,0,31,0,0,0,227,0,240,0,215,0,122,0,102,0,0,0,71,0,153,0,0,0,0,0,253,0,0,0,161,0,149,0,0,0,49,0,207,0,0,0,0,0,151,0,210,0,0,0,104,0,255,0,176,0,148,0,81,0,145,0,72,0,37,0,96,0,117,0,0,0,58,0,39,0,121,0,221,0,11,0,155,0,30,0,123,0,97,0,0,0,206,0,109,0,80,0,15,0,201,0,154,0,154,0,200,0,133,0,214,0,54,0,168,0,0,0,173,0,229,0,189,0,130,0,253,0,180,0,189,0,180,0,0,0,0,0,143,0,192,0,0,0,62,0,254,0,118,0,78,0,172,0,116,0,43,0,222,0,193,0,207,0,108,0,1,0,0,0,175,0,96,0,198,0,16,0,108,0,0,0,0,0,188,0,11,0,171,0,61,0,149,0,0,0,217,0,82,0,165,0,105,0,201,0,245,0,247,0,168,0,128,0,0,0,0,0,215,0,62,0,241,0,255,0,207,0,190,0,235,0,0,0,112,0,218,0,164,0,52,0,0,0,238,0,179,0,166,0,0,0,165,0,0,0,105,0,28,0,220,0,27,0,0,0,0,0,177,0,129,0,170,0,146,0,32,0,173,0,146,0,96,0,175,0,0,0,0,0,92,0,193,0,0,0,109,0,24,0,156,0,0,0,65,0,0,0,51,0,33,0,70,0,211,0,68,0,60,0,0,0,244,0,191,0,211,0,85,0,0,0,73,0,92,0,222,0,175,0,49,0,132,0,73,0,54,0,217,0,116,0,121,0,36,0,31,0,150,0,79,0,214,0,0,0,0,0,174,0,0,0,8,0,166,0,116,0,45,0,166,0,95,0,236,0,165,0,39,0,20,0,15,0,0,0,208,0,82,0,246,0,0,0,63,0,90,0,25,0,177,0,134,0,0,0,148,0,178,0,0,0,225,0,77,0,125,0,22,0,91,0,252,0,0,0,50,0,94,0,137,0,122,0,195,0,78,0,95,0,89,0,126,0,252,0,24,0,212,0,75,0,8,0,147,0,76,0,35,0,62,0,172,0,0,0,0,0,241,0,0,0,157,0,0,0,149,0,138,0,0,0,94,0,244,0,45,0,142,0,125,0,153,0,51,0,105,0,64,0,164,0,100,0,0,0,106,0,0,0,158,0,32,0,197,0,178,0,0,0,140,0,254,0,109,0,189,0,46,0,218,0,101,0,133,0,0,0,47,0,180,0,0,0,25,0,147,0,254,0,0,0,39,0,130,0,0,0,0,0,0,0,25,0,87,0,78,0,0,0,16,0,47,0,15,0,156,0,232,0,53,0,94,0);
signal scenario_full  : scenario_type := (8,31,8,30,52,31,20,31,128,31,79,31,79,30,216,31,166,31,125,31,14,31,14,30,174,31,245,31,245,30,245,29,23,31,73,31,241,31,241,30,145,31,243,31,243,30,243,29,86,31,47,31,54,31,54,30,187,31,100,31,223,31,127,31,13,31,121,31,121,30,247,31,148,31,207,31,207,30,223,31,103,31,103,30,165,31,50,31,91,31,208,31,53,31,63,31,95,31,247,31,247,30,211,31,112,31,112,30,20,31,219,31,207,31,207,30,110,31,196,31,196,30,233,31,150,31,123,31,140,31,145,31,12,31,59,31,155,31,92,31,92,30,19,31,99,31,238,31,73,31,29,31,144,31,26,31,99,31,50,31,98,31,22,31,162,31,162,30,104,31,152,31,152,30,250,31,73,31,243,31,239,31,124,31,49,31,217,31,217,30,15,31,15,30,82,31,82,30,38,31,223,31,94,31,117,31,228,31,112,31,247,31,83,31,75,31,108,31,108,30,13,31,203,31,119,31,127,31,127,30,132,31,248,31,248,30,111,31,94,31,73,31,223,31,149,31,151,31,129,31,196,31,193,31,118,31,199,31,159,31,159,30,61,31,39,31,199,31,15,31,38,31,68,31,171,31,171,30,137,31,75,31,193,31,118,31,233,31,233,30,191,31,163,31,220,31,239,31,239,30,23,31,44,31,44,30,128,31,128,30,128,29,249,31,87,31,24,31,24,30,93,31,84,31,189,31,148,31,37,31,72,31,226,31,47,31,22,31,146,31,237,31,236,31,87,31,36,31,196,31,111,31,111,30,111,29,52,31,172,31,133,31,52,31,52,30,179,31,179,30,50,31,94,31,191,31,56,31,103,31,103,30,184,31,157,31,53,31,72,31,72,30,59,31,146,31,224,31,104,31,149,31,234,31,200,31,204,31,217,31,60,31,104,31,208,31,194,31,3,31,73,31,143,31,146,31,188,31,188,30,242,31,253,31,62,31,113,31,104,31,43,31,84,31,195,31,198,31,198,30,217,31,161,31,161,30,90,31,252,31,157,31,72,31,85,31,211,31,239,31,96,31,144,31,144,30,144,29,159,31,213,31,63,31,63,30,82,31,201,31,21,31,220,31,217,31,188,31,101,31,145,31,145,30,145,29,193,31,193,30,208,31,59,31,152,31,228,31,66,31,66,31,156,31,18,31,240,31,243,31,60,31,13,31,13,30,138,31,138,30,209,31,39,31,204,31,35,31,35,30,35,31,203,31,217,31,151,31,105,31,105,30,111,31,111,30,239,31,14,31,76,31,28,31,28,30,27,31,27,30,18,31,49,31,5,31,183,31,136,31,136,30,13,31,13,30,13,29,13,28,75,31,228,31,186,31,150,31,150,30,150,29,141,31,131,31,126,31,132,31,132,30,132,29,132,28,132,27,68,31,161,31,13,31,13,30,13,29,127,31,127,30,2,31,253,31,4,31,4,30,96,31,101,31,233,31,218,31,218,30,218,29,24,31,24,30,130,31,24,31,153,31,198,31,207,31,153,31,18,31,123,31,10,31,10,30,31,31,203,31,189,31,212,31,204,31,204,30,204,29,81,31,109,31,183,31,144,31,185,31,151,31,21,31,21,30,75,31,181,31,73,31,17,31,3,31,3,30,103,31,103,30,91,31,91,30,83,31,158,31,158,30,12,31,195,31,77,31,138,31,21,31,154,31,177,31,177,30,2,31,158,31,158,30,83,31,83,30,111,31,57,31,17,31,208,31,153,31,30,31,30,30,95,31,83,31,116,31,176,31,47,31,98,31,180,31,82,31,130,31,130,30,85,31,96,31,231,31,231,30,162,31,52,31,250,31,190,31,144,31,183,31,36,31,154,31,140,31,159,31,159,30,137,31,137,30,129,31,129,30,111,31,181,31,93,31,95,31,146,31,146,30,146,29,185,31,51,31,51,30,51,29,141,31,141,30,124,31,187,31,187,30,85,31,177,31,177,30,181,31,181,30,181,29,96,31,221,31,72,31,147,31,58,31,122,31,47,31,22,31,22,30,26,31,26,30,57,31,237,31,193,31,167,31,51,31,25,31,108,31,202,31,107,31,217,31,143,31,44,31,119,31,164,31,164,30,122,31,122,30,255,31,210,31,185,31,127,31,241,31,150,31,209,31,10,31,10,30,12,31,12,30,12,29,123,31,207,31,65,31,65,30,134,31,234,31,28,31,28,30,82,31,12,31,159,31,159,30,159,31,159,30,159,29,225,31,144,31,103,31,55,31,50,31,152,31,238,31,238,30,2,31,2,30,25,31,150,31,93,31,24,31,51,31,109,31,245,31,67,31,180,31,45,31,45,30,45,29,52,31,59,31,181,31,147,31,177,31,42,31,224,31,95,31,95,30,67,31,67,30,135,31,188,31,80,31,194,31,76,31,76,30,3,31,3,30,87,31,196,31,195,31,244,31,126,31,160,31,222,31,31,31,131,31,131,30,131,29,137,31,138,31,138,30,142,31,27,31,27,30,175,31,175,30,194,31,152,31,53,31,141,31,5,31,24,31,119,31,226,31,33,31,212,31,235,31,231,31,55,31,24,31,241,31,241,30,25,31,125,31,159,31,167,31,42,31,16,31,82,31,50,31,50,30,35,31,64,31,248,31,66,31,28,31,28,30,36,31,30,31,30,30,4,31,99,31,99,30,99,29,222,31,22,31,22,30,33,31,33,30,253,31,198,31,198,30,179,31,245,31,243,31,49,31,49,30,49,29,175,31,80,31,80,30,199,31,155,31,224,31,70,31,144,31,144,30,24,31,31,31,31,30,227,31,240,31,215,31,122,31,102,31,102,30,71,31,153,31,153,30,153,29,253,31,253,30,161,31,149,31,149,30,49,31,207,31,207,30,207,29,151,31,210,31,210,30,104,31,255,31,176,31,148,31,81,31,145,31,72,31,37,31,96,31,117,31,117,30,58,31,39,31,121,31,221,31,11,31,155,31,30,31,123,31,97,31,97,30,206,31,109,31,80,31,15,31,201,31,154,31,154,31,200,31,133,31,214,31,54,31,168,31,168,30,173,31,229,31,189,31,130,31,253,31,180,31,189,31,180,31,180,30,180,29,143,31,192,31,192,30,62,31,254,31,118,31,78,31,172,31,116,31,43,31,222,31,193,31,207,31,108,31,1,31,1,30,175,31,96,31,198,31,16,31,108,31,108,30,108,29,188,31,11,31,171,31,61,31,149,31,149,30,217,31,82,31,165,31,105,31,201,31,245,31,247,31,168,31,128,31,128,30,128,29,215,31,62,31,241,31,255,31,207,31,190,31,235,31,235,30,112,31,218,31,164,31,52,31,52,30,238,31,179,31,166,31,166,30,165,31,165,30,105,31,28,31,220,31,27,31,27,30,27,29,177,31,129,31,170,31,146,31,32,31,173,31,146,31,96,31,175,31,175,30,175,29,92,31,193,31,193,30,109,31,24,31,156,31,156,30,65,31,65,30,51,31,33,31,70,31,211,31,68,31,60,31,60,30,244,31,191,31,211,31,85,31,85,30,73,31,92,31,222,31,175,31,49,31,132,31,73,31,54,31,217,31,116,31,121,31,36,31,31,31,150,31,79,31,214,31,214,30,214,29,174,31,174,30,8,31,166,31,116,31,45,31,166,31,95,31,236,31,165,31,39,31,20,31,15,31,15,30,208,31,82,31,246,31,246,30,63,31,90,31,25,31,177,31,134,31,134,30,148,31,178,31,178,30,225,31,77,31,125,31,22,31,91,31,252,31,252,30,50,31,94,31,137,31,122,31,195,31,78,31,95,31,89,31,126,31,252,31,24,31,212,31,75,31,8,31,147,31,76,31,35,31,62,31,172,31,172,30,172,29,241,31,241,30,157,31,157,30,149,31,138,31,138,30,94,31,244,31,45,31,142,31,125,31,153,31,51,31,105,31,64,31,164,31,100,31,100,30,106,31,106,30,158,31,32,31,197,31,178,31,178,30,140,31,254,31,109,31,189,31,46,31,218,31,101,31,133,31,133,30,47,31,180,31,180,30,25,31,147,31,254,31,254,30,39,31,130,31,130,30,130,29,130,28,25,31,87,31,78,31,78,30,16,31,47,31,15,31,156,31,232,31,53,31,94,31);

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
