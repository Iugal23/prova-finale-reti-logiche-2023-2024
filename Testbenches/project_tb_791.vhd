-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_791 is
end project_tb_791;

architecture project_tb_arch_791 of project_tb_791 is
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

constant SCENARIO_LENGTH : integer := 899;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (142,0,182,0,151,0,48,0,51,0,47,0,196,0,69,0,209,0,77,0,0,0,225,0,63,0,0,0,239,0,45,0,0,0,0,0,62,0,128,0,121,0,203,0,0,0,128,0,96,0,8,0,0,0,74,0,0,0,249,0,99,0,180,0,123,0,201,0,93,0,20,0,80,0,88,0,165,0,0,0,210,0,89,0,25,0,0,0,198,0,48,0,0,0,249,0,0,0,89,0,190,0,144,0,0,0,96,0,179,0,0,0,0,0,118,0,142,0,0,0,0,0,153,0,22,0,45,0,0,0,0,0,13,0,101,0,39,0,58,0,166,0,31,0,0,0,0,0,217,0,125,0,184,0,85,0,155,0,102,0,102,0,0,0,0,0,178,0,47,0,50,0,0,0,17,0,76,0,93,0,158,0,19,0,0,0,153,0,180,0,110,0,65,0,188,0,136,0,50,0,145,0,226,0,229,0,112,0,226,0,44,0,0,0,218,0,201,0,42,0,57,0,81,0,16,0,166,0,119,0,51,0,89,0,0,0,235,0,153,0,105,0,77,0,113,0,67,0,230,0,133,0,17,0,2,0,216,0,0,0,53,0,7,0,0,0,0,0,127,0,110,0,77,0,228,0,250,0,91,0,0,0,7,0,133,0,107,0,228,0,104,0,135,0,93,0,218,0,32,0,108,0,84,0,129,0,126,0,170,0,0,0,0,0,0,0,47,0,188,0,140,0,51,0,117,0,109,0,234,0,24,0,180,0,0,0,26,0,213,0,40,0,67,0,199,0,153,0,176,0,129,0,119,0,215,0,22,0,187,0,244,0,0,0,0,0,90,0,225,0,0,0,90,0,0,0,0,0,176,0,88,0,250,0,164,0,0,0,203,0,62,0,87,0,109,0,4,0,87,0,224,0,23,0,92,0,236,0,101,0,64,0,99,0,215,0,0,0,243,0,4,0,82,0,154,0,108,0,73,0,157,0,16,0,184,0,158,0,1,0,115,0,0,0,246,0,250,0,35,0,252,0,28,0,206,0,184,0,86,0,122,0,0,0,226,0,0,0,135,0,70,0,230,0,125,0,185,0,0,0,137,0,160,0,190,0,48,0,238,0,0,0,124,0,235,0,104,0,21,0,201,0,118,0,38,0,0,0,206,0,0,0,218,0,0,0,0,0,144,0,199,0,147,0,15,0,97,0,64,0,250,0,0,0,21,0,151,0,2,0,0,0,34,0,0,0,49,0,199,0,25,0,15,0,0,0,222,0,0,0,153,0,76,0,162,0,0,0,118,0,209,0,208,0,0,0,11,0,26,0,133,0,172,0,215,0,0,0,137,0,170,0,38,0,179,0,145,0,82,0,114,0,92,0,0,0,0,0,69,0,159,0,0,0,50,0,0,0,86,0,9,0,0,0,36,0,27,0,198,0,189,0,69,0,0,0,130,0,141,0,167,0,226,0,51,0,51,0,0,0,240,0,130,0,219,0,0,0,91,0,0,0,0,0,111,0,0,0,175,0,45,0,0,0,141,0,18,0,0,0,0,0,0,0,0,0,240,0,0,0,174,0,87,0,205,0,127,0,232,0,196,0,42,0,0,0,0,0,83,0,26,0,85,0,74,0,0,0,92,0,248,0,193,0,253,0,176,0,193,0,13,0,34,0,254,0,154,0,0,0,0,0,191,0,58,0,0,0,0,0,24,0,102,0,226,0,208,0,101,0,222,0,0,0,43,0,0,0,0,0,198,0,0,0,0,0,151,0,229,0,57,0,128,0,0,0,16,0,57,0,192,0,201,0,137,0,43,0,88,0,18,0,197,0,89,0,219,0,48,0,0,0,253,0,157,0,0,0,194,0,140,0,149,0,53,0,203,0,125,0,56,0,111,0,53,0,244,0,186,0,219,0,37,0,48,0,141,0,121,0,0,0,0,0,0,0,183,0,0,0,0,0,129,0,44,0,249,0,166,0,188,0,224,0,124,0,0,0,5,0,154,0,23,0,50,0,96,0,106,0,0,0,0,0,235,0,6,0,128,0,201,0,107,0,85,0,158,0,203,0,0,0,0,0,173,0,25,0,147,0,133,0,0,0,35,0,138,0,160,0,213,0,163,0,42,0,51,0,220,0,211,0,101,0,0,0,32,0,0,0,210,0,77,0,102,0,85,0,60,0,66,0,110,0,0,0,76,0,167,0,0,0,198,0,31,0,87,0,92,0,207,0,142,0,196,0,138,0,203,0,149,0,212,0,233,0,0,0,0,0,0,0,207,0,0,0,169,0,179,0,11,0,138,0,149,0,0,0,0,0,80,0,7,0,0,0,53,0,175,0,76,0,138,0,154,0,203,0,27,0,196,0,169,0,223,0,73,0,103,0,119,0,49,0,125,0,46,0,8,0,226,0,201,0,32,0,175,0,89,0,229,0,63,0,0,0,247,0,178,0,35,0,159,0,162,0,240,0,143,0,81,0,0,0,236,0,4,0,208,0,249,0,0,0,125,0,216,0,97,0,92,0,0,0,106,0,80,0,7,0,103,0,0,0,0,0,0,0,241,0,177,0,69,0,120,0,145,0,143,0,26,0,172,0,0,0,125,0,137,0,175,0,0,0,97,0,242,0,29,0,0,0,189,0,141,0,225,0,255,0,0,0,219,0,8,0,0,0,0,0,101,0,42,0,141,0,164,0,0,0,0,0,145,0,180,0,54,0,216,0,99,0,186,0,112,0,54,0,34,0,156,0,63,0,80,0,190,0,0,0,215,0,189,0,248,0,227,0,216,0,49,0,215,0,0,0,220,0,202,0,0,0,210,0,27,0,218,0,250,0,5,0,217,0,162,0,241,0,15,0,0,0,6,0,233,0,129,0,87,0,229,0,100,0,176,0,0,0,97,0,0,0,141,0,116,0,0,0,21,0,0,0,205,0,0,0,61,0,5,0,199,0,72,0,54,0,0,0,136,0,0,0,0,0,0,0,29,0,0,0,9,0,56,0,16,0,0,0,0,0,176,0,197,0,181,0,106,0,98,0,148,0,169,0,0,0,0,0,15,0,0,0,91,0,0,0,47,0,170,0,239,0,52,0,68,0,5,0,0,0,98,0,0,0,0,0,253,0,6,0,103,0,81,0,248,0,9,0,0,0,248,0,0,0,0,0,122,0,0,0,227,0,126,0,29,0,2,0,0,0,150,0,192,0,228,0,0,0,0,0,120,0,140,0,0,0,125,0,0,0,114,0,158,0,138,0,57,0,11,0,13,0,196,0,0,0,48,0,158,0,122,0,158,0,0,0,33,0,95,0,122,0,88,0,130,0,120,0,25,0,179,0,229,0,6,0,246,0,0,0,16,0,171,0,235,0,3,0,0,0,243,0,254,0,0,0,0,0,160,0,37,0,117,0,65,0,197,0,28,0,166,0,149,0,84,0,0,0,0,0,29,0,41,0,218,0,122,0,0,0,68,0,213,0,106,0,217,0,230,0,43,0,71,0,160,0,111,0,97,0,80,0,92,0,235,0,215,0,121,0,0,0,0,0,99,0,0,0,39,0,213,0,189,0,0,0,7,0,136,0,200,0,202,0,239,0,4,0,38,0,245,0,0,0,210,0,25,0,161,0,142,0,0,0,0,0,0,0,45,0,0,0,102,0,135,0,94,0,251,0,188,0,0,0,209,0,129,0,253,0,253,0,148,0,27,0,131,0,228,0,0,0,84,0,206,0,110,0,55,0,0,0,22,0,75,0,232,0,0,0,170,0,100,0,0,0,231,0,0,0,254,0,75,0,8,0,121,0,49,0,0,0,38,0,0,0,0,0,0,0,194,0,171,0,0,0,244,0,0,0,240,0,129,0,25,0,0,0,0,0,0,0,25,0,133,0,0,0,248,0,0,0,139,0,199,0,130,0,41,0,214,0,230,0,0,0,0,0,133,0,37,0,145,0,83,0,0,0,176,0,223,0,0,0,131,0,252,0,77,0,94,0,253,0,252,0,163,0,104,0,0,0,193,0,0,0,129,0,250,0,0,0,220,0,36,0,0,0,0,0,15,0,167,0,79,0,0,0);
signal scenario_full  : scenario_type := (142,31,182,31,151,31,48,31,51,31,47,31,196,31,69,31,209,31,77,31,77,30,225,31,63,31,63,30,239,31,45,31,45,30,45,29,62,31,128,31,121,31,203,31,203,30,128,31,96,31,8,31,8,30,74,31,74,30,249,31,99,31,180,31,123,31,201,31,93,31,20,31,80,31,88,31,165,31,165,30,210,31,89,31,25,31,25,30,198,31,48,31,48,30,249,31,249,30,89,31,190,31,144,31,144,30,96,31,179,31,179,30,179,29,118,31,142,31,142,30,142,29,153,31,22,31,45,31,45,30,45,29,13,31,101,31,39,31,58,31,166,31,31,31,31,30,31,29,217,31,125,31,184,31,85,31,155,31,102,31,102,31,102,30,102,29,178,31,47,31,50,31,50,30,17,31,76,31,93,31,158,31,19,31,19,30,153,31,180,31,110,31,65,31,188,31,136,31,50,31,145,31,226,31,229,31,112,31,226,31,44,31,44,30,218,31,201,31,42,31,57,31,81,31,16,31,166,31,119,31,51,31,89,31,89,30,235,31,153,31,105,31,77,31,113,31,67,31,230,31,133,31,17,31,2,31,216,31,216,30,53,31,7,31,7,30,7,29,127,31,110,31,77,31,228,31,250,31,91,31,91,30,7,31,133,31,107,31,228,31,104,31,135,31,93,31,218,31,32,31,108,31,84,31,129,31,126,31,170,31,170,30,170,29,170,28,47,31,188,31,140,31,51,31,117,31,109,31,234,31,24,31,180,31,180,30,26,31,213,31,40,31,67,31,199,31,153,31,176,31,129,31,119,31,215,31,22,31,187,31,244,31,244,30,244,29,90,31,225,31,225,30,90,31,90,30,90,29,176,31,88,31,250,31,164,31,164,30,203,31,62,31,87,31,109,31,4,31,87,31,224,31,23,31,92,31,236,31,101,31,64,31,99,31,215,31,215,30,243,31,4,31,82,31,154,31,108,31,73,31,157,31,16,31,184,31,158,31,1,31,115,31,115,30,246,31,250,31,35,31,252,31,28,31,206,31,184,31,86,31,122,31,122,30,226,31,226,30,135,31,70,31,230,31,125,31,185,31,185,30,137,31,160,31,190,31,48,31,238,31,238,30,124,31,235,31,104,31,21,31,201,31,118,31,38,31,38,30,206,31,206,30,218,31,218,30,218,29,144,31,199,31,147,31,15,31,97,31,64,31,250,31,250,30,21,31,151,31,2,31,2,30,34,31,34,30,49,31,199,31,25,31,15,31,15,30,222,31,222,30,153,31,76,31,162,31,162,30,118,31,209,31,208,31,208,30,11,31,26,31,133,31,172,31,215,31,215,30,137,31,170,31,38,31,179,31,145,31,82,31,114,31,92,31,92,30,92,29,69,31,159,31,159,30,50,31,50,30,86,31,9,31,9,30,36,31,27,31,198,31,189,31,69,31,69,30,130,31,141,31,167,31,226,31,51,31,51,31,51,30,240,31,130,31,219,31,219,30,91,31,91,30,91,29,111,31,111,30,175,31,45,31,45,30,141,31,18,31,18,30,18,29,18,28,18,27,240,31,240,30,174,31,87,31,205,31,127,31,232,31,196,31,42,31,42,30,42,29,83,31,26,31,85,31,74,31,74,30,92,31,248,31,193,31,253,31,176,31,193,31,13,31,34,31,254,31,154,31,154,30,154,29,191,31,58,31,58,30,58,29,24,31,102,31,226,31,208,31,101,31,222,31,222,30,43,31,43,30,43,29,198,31,198,30,198,29,151,31,229,31,57,31,128,31,128,30,16,31,57,31,192,31,201,31,137,31,43,31,88,31,18,31,197,31,89,31,219,31,48,31,48,30,253,31,157,31,157,30,194,31,140,31,149,31,53,31,203,31,125,31,56,31,111,31,53,31,244,31,186,31,219,31,37,31,48,31,141,31,121,31,121,30,121,29,121,28,183,31,183,30,183,29,129,31,44,31,249,31,166,31,188,31,224,31,124,31,124,30,5,31,154,31,23,31,50,31,96,31,106,31,106,30,106,29,235,31,6,31,128,31,201,31,107,31,85,31,158,31,203,31,203,30,203,29,173,31,25,31,147,31,133,31,133,30,35,31,138,31,160,31,213,31,163,31,42,31,51,31,220,31,211,31,101,31,101,30,32,31,32,30,210,31,77,31,102,31,85,31,60,31,66,31,110,31,110,30,76,31,167,31,167,30,198,31,31,31,87,31,92,31,207,31,142,31,196,31,138,31,203,31,149,31,212,31,233,31,233,30,233,29,233,28,207,31,207,30,169,31,179,31,11,31,138,31,149,31,149,30,149,29,80,31,7,31,7,30,53,31,175,31,76,31,138,31,154,31,203,31,27,31,196,31,169,31,223,31,73,31,103,31,119,31,49,31,125,31,46,31,8,31,226,31,201,31,32,31,175,31,89,31,229,31,63,31,63,30,247,31,178,31,35,31,159,31,162,31,240,31,143,31,81,31,81,30,236,31,4,31,208,31,249,31,249,30,125,31,216,31,97,31,92,31,92,30,106,31,80,31,7,31,103,31,103,30,103,29,103,28,241,31,177,31,69,31,120,31,145,31,143,31,26,31,172,31,172,30,125,31,137,31,175,31,175,30,97,31,242,31,29,31,29,30,189,31,141,31,225,31,255,31,255,30,219,31,8,31,8,30,8,29,101,31,42,31,141,31,164,31,164,30,164,29,145,31,180,31,54,31,216,31,99,31,186,31,112,31,54,31,34,31,156,31,63,31,80,31,190,31,190,30,215,31,189,31,248,31,227,31,216,31,49,31,215,31,215,30,220,31,202,31,202,30,210,31,27,31,218,31,250,31,5,31,217,31,162,31,241,31,15,31,15,30,6,31,233,31,129,31,87,31,229,31,100,31,176,31,176,30,97,31,97,30,141,31,116,31,116,30,21,31,21,30,205,31,205,30,61,31,5,31,199,31,72,31,54,31,54,30,136,31,136,30,136,29,136,28,29,31,29,30,9,31,56,31,16,31,16,30,16,29,176,31,197,31,181,31,106,31,98,31,148,31,169,31,169,30,169,29,15,31,15,30,91,31,91,30,47,31,170,31,239,31,52,31,68,31,5,31,5,30,98,31,98,30,98,29,253,31,6,31,103,31,81,31,248,31,9,31,9,30,248,31,248,30,248,29,122,31,122,30,227,31,126,31,29,31,2,31,2,30,150,31,192,31,228,31,228,30,228,29,120,31,140,31,140,30,125,31,125,30,114,31,158,31,138,31,57,31,11,31,13,31,196,31,196,30,48,31,158,31,122,31,158,31,158,30,33,31,95,31,122,31,88,31,130,31,120,31,25,31,179,31,229,31,6,31,246,31,246,30,16,31,171,31,235,31,3,31,3,30,243,31,254,31,254,30,254,29,160,31,37,31,117,31,65,31,197,31,28,31,166,31,149,31,84,31,84,30,84,29,29,31,41,31,218,31,122,31,122,30,68,31,213,31,106,31,217,31,230,31,43,31,71,31,160,31,111,31,97,31,80,31,92,31,235,31,215,31,121,31,121,30,121,29,99,31,99,30,39,31,213,31,189,31,189,30,7,31,136,31,200,31,202,31,239,31,4,31,38,31,245,31,245,30,210,31,25,31,161,31,142,31,142,30,142,29,142,28,45,31,45,30,102,31,135,31,94,31,251,31,188,31,188,30,209,31,129,31,253,31,253,31,148,31,27,31,131,31,228,31,228,30,84,31,206,31,110,31,55,31,55,30,22,31,75,31,232,31,232,30,170,31,100,31,100,30,231,31,231,30,254,31,75,31,8,31,121,31,49,31,49,30,38,31,38,30,38,29,38,28,194,31,171,31,171,30,244,31,244,30,240,31,129,31,25,31,25,30,25,29,25,28,25,31,133,31,133,30,248,31,248,30,139,31,199,31,130,31,41,31,214,31,230,31,230,30,230,29,133,31,37,31,145,31,83,31,83,30,176,31,223,31,223,30,131,31,252,31,77,31,94,31,253,31,252,31,163,31,104,31,104,30,193,31,193,30,129,31,250,31,250,30,220,31,36,31,36,30,36,29,15,31,167,31,79,31,79,30);

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
