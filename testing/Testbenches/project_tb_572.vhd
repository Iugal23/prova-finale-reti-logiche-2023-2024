-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_572 is
end project_tb_572;

architecture project_tb_arch_572 of project_tb_572 is
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

constant SCENARIO_LENGTH : integer := 897;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (141,0,31,0,177,0,206,0,0,0,190,0,0,0,172,0,56,0,74,0,157,0,82,0,227,0,28,0,178,0,159,0,26,0,50,0,252,0,0,0,181,0,0,0,244,0,150,0,160,0,78,0,61,0,145,0,208,0,59,0,111,0,25,0,207,0,166,0,97,0,187,0,224,0,49,0,118,0,117,0,214,0,0,0,18,0,50,0,59,0,0,0,221,0,0,0,0,0,7,0,226,0,150,0,157,0,0,0,224,0,136,0,247,0,58,0,53,0,205,0,232,0,45,0,0,0,0,0,0,0,0,0,81,0,43,0,247,0,0,0,63,0,0,0,203,0,0,0,184,0,225,0,43,0,145,0,102,0,199,0,51,0,79,0,0,0,157,0,0,0,123,0,11,0,0,0,41,0,194,0,0,0,150,0,219,0,20,0,31,0,0,0,18,0,0,0,17,0,194,0,155,0,0,0,245,0,19,0,0,0,0,0,254,0,84,0,27,0,30,0,161,0,199,0,176,0,116,0,5,0,0,0,176,0,0,0,214,0,223,0,250,0,247,0,218,0,212,0,124,0,186,0,37,0,70,0,0,0,46,0,177,0,205,0,0,0,222,0,128,0,215,0,0,0,234,0,62,0,0,0,192,0,171,0,216,0,142,0,0,0,160,0,55,0,237,0,168,0,204,0,121,0,0,0,157,0,184,0,93,0,100,0,127,0,44,0,201,0,204,0,233,0,66,0,205,0,158,0,136,0,69,0,197,0,32,0,74,0,0,0,174,0,155,0,0,0,145,0,184,0,79,0,168,0,0,0,0,0,5,0,233,0,125,0,0,0,0,0,167,0,141,0,205,0,49,0,46,0,235,0,202,0,180,0,0,0,65,0,32,0,162,0,0,0,0,0,135,0,70,0,0,0,83,0,130,0,0,0,157,0,249,0,151,0,21,0,132,0,146,0,0,0,140,0,182,0,0,0,135,0,253,0,31,0,83,0,233,0,13,0,105,0,233,0,0,0,11,0,0,0,143,0,76,0,183,0,191,0,127,0,1,0,0,0,240,0,143,0,238,0,85,0,17,0,0,0,167,0,253,0,0,0,0,0,233,0,16,0,111,0,0,0,91,0,207,0,0,0,25,0,95,0,3,0,0,0,73,0,253,0,27,0,0,0,0,0,54,0,196,0,1,0,26,0,0,0,172,0,7,0,232,0,34,0,5,0,113,0,18,0,97,0,0,0,200,0,49,0,0,0,56,0,229,0,232,0,52,0,150,0,153,0,168,0,87,0,51,0,0,0,175,0,155,0,0,0,196,0,8,0,235,0,29,0,141,0,90,0,77,0,237,0,212,0,0,0,253,0,219,0,150,0,192,0,185,0,0,0,35,0,88,0,204,0,144,0,0,0,75,0,94,0,0,0,124,0,81,0,115,0,37,0,0,0,119,0,105,0,21,0,0,0,95,0,9,0,43,0,0,0,0,0,20,0,169,0,0,0,221,0,107,0,78,0,199,0,235,0,152,0,78,0,163,0,0,0,0,0,62,0,148,0,242,0,29,0,92,0,91,0,221,0,202,0,0,0,128,0,200,0,231,0,197,0,189,0,119,0,86,0,50,0,126,0,0,0,0,0,0,0,246,0,20,0,8,0,153,0,107,0,55,0,213,0,228,0,0,0,153,0,166,0,0,0,147,0,170,0,182,0,161,0,58,0,0,0,235,0,102,0,162,0,63,0,112,0,157,0,190,0,204,0,146,0,211,0,115,0,0,0,10,0,97,0,79,0,57,0,18,0,238,0,134,0,141,0,0,0,0,0,0,0,231,0,14,0,203,0,20,0,11,0,208,0,149,0,102,0,0,0,197,0,0,0,0,0,172,0,129,0,245,0,116,0,136,0,92,0,49,0,198,0,208,0,0,0,136,0,167,0,210,0,16,0,135,0,89,0,196,0,215,0,0,0,252,0,160,0,8,0,195,0,200,0,191,0,0,0,202,0,10,0,204,0,195,0,223,0,0,0,153,0,204,0,23,0,184,0,64,0,210,0,198,0,0,0,137,0,214,0,184,0,116,0,204,0,92,0,104,0,109,0,0,0,207,0,20,0,20,0,196,0,152,0,89,0,163,0,128,0,40,0,36,0,168,0,162,0,222,0,49,0,0,0,116,0,20,0,41,0,2,0,158,0,23,0,196,0,250,0,120,0,105,0,17,0,0,0,195,0,144,0,248,0,41,0,64,0,35,0,15,0,47,0,232,0,156,0,90,0,0,0,129,0,124,0,0,0,156,0,239,0,248,0,228,0,1,0,238,0,217,0,88,0,133,0,64,0,88,0,222,0,175,0,218,0,220,0,17,0,181,0,96,0,0,0,121,0,87,0,6,0,155,0,58,0,143,0,55,0,90,0,0,0,193,0,16,0,193,0,0,0,37,0,137,0,250,0,8,0,0,0,135,0,233,0,70,0,0,0,0,0,16,0,161,0,76,0,152,0,141,0,0,0,181,0,15,0,0,0,86,0,14,0,28,0,124,0,73,0,149,0,183,0,136,0,78,0,182,0,225,0,142,0,78,0,57,0,67,0,235,0,184,0,188,0,179,0,210,0,0,0,0,0,187,0,42,0,215,0,174,0,245,0,0,0,251,0,105,0,102,0,51,0,57,0,0,0,171,0,0,0,143,0,46,0,133,0,228,0,222,0,184,0,6,0,241,0,27,0,2,0,161,0,127,0,184,0,0,0,0,0,131,0,172,0,124,0,95,0,0,0,70,0,116,0,34,0,110,0,204,0,195,0,126,0,65,0,0,0,37,0,194,0,181,0,218,0,2,0,230,0,44,0,246,0,0,0,155,0,0,0,34,0,204,0,0,0,56,0,65,0,14,0,251,0,6,0,0,0,114,0,252,0,0,0,242,0,114,0,0,0,14,0,203,0,255,0,128,0,47,0,102,0,207,0,66,0,0,0,138,0,160,0,168,0,140,0,80,0,0,0,114,0,203,0,101,0,102,0,1,0,47,0,1,0,9,0,0,0,0,0,97,0,147,0,39,0,51,0,228,0,0,0,51,0,101,0,125,0,227,0,227,0,111,0,164,0,90,0,240,0,183,0,45,0,63,0,221,0,170,0,107,0,193,0,0,0,0,0,85,0,0,0,216,0,50,0,13,0,0,0,173,0,0,0,94,0,175,0,154,0,105,0,0,0,0,0,0,0,3,0,0,0,61,0,99,0,148,0,181,0,182,0,96,0,1,0,47,0,0,0,148,0,68,0,0,0,218,0,40,0,199,0,106,0,255,0,57,0,99,0,0,0,0,0,249,0,44,0,130,0,14,0,86,0,207,0,235,0,182,0,180,0,70,0,140,0,0,0,169,0,0,0,0,0,156,0,100,0,110,0,10,0,0,0,73,0,0,0,215,0,232,0,28,0,152,0,190,0,0,0,62,0,21,0,162,0,0,0,0,0,87,0,34,0,64,0,0,0,0,0,216,0,0,0,183,0,208,0,143,0,242,0,8,0,0,0,120,0,33,0,181,0,94,0,62,0,212,0,44,0,217,0,81,0,19,0,141,0,229,0,13,0,144,0,80,0,0,0,179,0,254,0,184,0,172,0,88,0,157,0,18,0,235,0,179,0,48,0,134,0,222,0,176,0,81,0,202,0,250,0,166,0,0,0,194,0,197,0,195,0,222,0,94,0,234,0,0,0,54,0,114,0,0,0,6,0,47,0,217,0,202,0,0,0,229,0,0,0,241,0,88,0,0,0,162,0,127,0,90,0,107,0,238,0,0,0,0,0,221,0,108,0,51,0,0,0,230,0,65,0,215,0,251,0,47,0,0,0,123,0,130,0,102,0,192,0,122,0,89,0,0,0,88,0,0,0,235,0,5,0,80,0,231,0,44,0,216,0,26,0,72,0,50,0,249,0,141,0,0,0,50,0,30,0,9,0,94,0,22,0,132,0,104,0,165,0,0,0,0,0,146,0,143,0,240,0,24,0,214,0,71,0,169,0,197,0,0,0,90,0,118,0,200,0,84,0,136,0,0,0,49,0);
signal scenario_full  : scenario_type := (141,31,31,31,177,31,206,31,206,30,190,31,190,30,172,31,56,31,74,31,157,31,82,31,227,31,28,31,178,31,159,31,26,31,50,31,252,31,252,30,181,31,181,30,244,31,150,31,160,31,78,31,61,31,145,31,208,31,59,31,111,31,25,31,207,31,166,31,97,31,187,31,224,31,49,31,118,31,117,31,214,31,214,30,18,31,50,31,59,31,59,30,221,31,221,30,221,29,7,31,226,31,150,31,157,31,157,30,224,31,136,31,247,31,58,31,53,31,205,31,232,31,45,31,45,30,45,29,45,28,45,27,81,31,43,31,247,31,247,30,63,31,63,30,203,31,203,30,184,31,225,31,43,31,145,31,102,31,199,31,51,31,79,31,79,30,157,31,157,30,123,31,11,31,11,30,41,31,194,31,194,30,150,31,219,31,20,31,31,31,31,30,18,31,18,30,17,31,194,31,155,31,155,30,245,31,19,31,19,30,19,29,254,31,84,31,27,31,30,31,161,31,199,31,176,31,116,31,5,31,5,30,176,31,176,30,214,31,223,31,250,31,247,31,218,31,212,31,124,31,186,31,37,31,70,31,70,30,46,31,177,31,205,31,205,30,222,31,128,31,215,31,215,30,234,31,62,31,62,30,192,31,171,31,216,31,142,31,142,30,160,31,55,31,237,31,168,31,204,31,121,31,121,30,157,31,184,31,93,31,100,31,127,31,44,31,201,31,204,31,233,31,66,31,205,31,158,31,136,31,69,31,197,31,32,31,74,31,74,30,174,31,155,31,155,30,145,31,184,31,79,31,168,31,168,30,168,29,5,31,233,31,125,31,125,30,125,29,167,31,141,31,205,31,49,31,46,31,235,31,202,31,180,31,180,30,65,31,32,31,162,31,162,30,162,29,135,31,70,31,70,30,83,31,130,31,130,30,157,31,249,31,151,31,21,31,132,31,146,31,146,30,140,31,182,31,182,30,135,31,253,31,31,31,83,31,233,31,13,31,105,31,233,31,233,30,11,31,11,30,143,31,76,31,183,31,191,31,127,31,1,31,1,30,240,31,143,31,238,31,85,31,17,31,17,30,167,31,253,31,253,30,253,29,233,31,16,31,111,31,111,30,91,31,207,31,207,30,25,31,95,31,3,31,3,30,73,31,253,31,27,31,27,30,27,29,54,31,196,31,1,31,26,31,26,30,172,31,7,31,232,31,34,31,5,31,113,31,18,31,97,31,97,30,200,31,49,31,49,30,56,31,229,31,232,31,52,31,150,31,153,31,168,31,87,31,51,31,51,30,175,31,155,31,155,30,196,31,8,31,235,31,29,31,141,31,90,31,77,31,237,31,212,31,212,30,253,31,219,31,150,31,192,31,185,31,185,30,35,31,88,31,204,31,144,31,144,30,75,31,94,31,94,30,124,31,81,31,115,31,37,31,37,30,119,31,105,31,21,31,21,30,95,31,9,31,43,31,43,30,43,29,20,31,169,31,169,30,221,31,107,31,78,31,199,31,235,31,152,31,78,31,163,31,163,30,163,29,62,31,148,31,242,31,29,31,92,31,91,31,221,31,202,31,202,30,128,31,200,31,231,31,197,31,189,31,119,31,86,31,50,31,126,31,126,30,126,29,126,28,246,31,20,31,8,31,153,31,107,31,55,31,213,31,228,31,228,30,153,31,166,31,166,30,147,31,170,31,182,31,161,31,58,31,58,30,235,31,102,31,162,31,63,31,112,31,157,31,190,31,204,31,146,31,211,31,115,31,115,30,10,31,97,31,79,31,57,31,18,31,238,31,134,31,141,31,141,30,141,29,141,28,231,31,14,31,203,31,20,31,11,31,208,31,149,31,102,31,102,30,197,31,197,30,197,29,172,31,129,31,245,31,116,31,136,31,92,31,49,31,198,31,208,31,208,30,136,31,167,31,210,31,16,31,135,31,89,31,196,31,215,31,215,30,252,31,160,31,8,31,195,31,200,31,191,31,191,30,202,31,10,31,204,31,195,31,223,31,223,30,153,31,204,31,23,31,184,31,64,31,210,31,198,31,198,30,137,31,214,31,184,31,116,31,204,31,92,31,104,31,109,31,109,30,207,31,20,31,20,31,196,31,152,31,89,31,163,31,128,31,40,31,36,31,168,31,162,31,222,31,49,31,49,30,116,31,20,31,41,31,2,31,158,31,23,31,196,31,250,31,120,31,105,31,17,31,17,30,195,31,144,31,248,31,41,31,64,31,35,31,15,31,47,31,232,31,156,31,90,31,90,30,129,31,124,31,124,30,156,31,239,31,248,31,228,31,1,31,238,31,217,31,88,31,133,31,64,31,88,31,222,31,175,31,218,31,220,31,17,31,181,31,96,31,96,30,121,31,87,31,6,31,155,31,58,31,143,31,55,31,90,31,90,30,193,31,16,31,193,31,193,30,37,31,137,31,250,31,8,31,8,30,135,31,233,31,70,31,70,30,70,29,16,31,161,31,76,31,152,31,141,31,141,30,181,31,15,31,15,30,86,31,14,31,28,31,124,31,73,31,149,31,183,31,136,31,78,31,182,31,225,31,142,31,78,31,57,31,67,31,235,31,184,31,188,31,179,31,210,31,210,30,210,29,187,31,42,31,215,31,174,31,245,31,245,30,251,31,105,31,102,31,51,31,57,31,57,30,171,31,171,30,143,31,46,31,133,31,228,31,222,31,184,31,6,31,241,31,27,31,2,31,161,31,127,31,184,31,184,30,184,29,131,31,172,31,124,31,95,31,95,30,70,31,116,31,34,31,110,31,204,31,195,31,126,31,65,31,65,30,37,31,194,31,181,31,218,31,2,31,230,31,44,31,246,31,246,30,155,31,155,30,34,31,204,31,204,30,56,31,65,31,14,31,251,31,6,31,6,30,114,31,252,31,252,30,242,31,114,31,114,30,14,31,203,31,255,31,128,31,47,31,102,31,207,31,66,31,66,30,138,31,160,31,168,31,140,31,80,31,80,30,114,31,203,31,101,31,102,31,1,31,47,31,1,31,9,31,9,30,9,29,97,31,147,31,39,31,51,31,228,31,228,30,51,31,101,31,125,31,227,31,227,31,111,31,164,31,90,31,240,31,183,31,45,31,63,31,221,31,170,31,107,31,193,31,193,30,193,29,85,31,85,30,216,31,50,31,13,31,13,30,173,31,173,30,94,31,175,31,154,31,105,31,105,30,105,29,105,28,3,31,3,30,61,31,99,31,148,31,181,31,182,31,96,31,1,31,47,31,47,30,148,31,68,31,68,30,218,31,40,31,199,31,106,31,255,31,57,31,99,31,99,30,99,29,249,31,44,31,130,31,14,31,86,31,207,31,235,31,182,31,180,31,70,31,140,31,140,30,169,31,169,30,169,29,156,31,100,31,110,31,10,31,10,30,73,31,73,30,215,31,232,31,28,31,152,31,190,31,190,30,62,31,21,31,162,31,162,30,162,29,87,31,34,31,64,31,64,30,64,29,216,31,216,30,183,31,208,31,143,31,242,31,8,31,8,30,120,31,33,31,181,31,94,31,62,31,212,31,44,31,217,31,81,31,19,31,141,31,229,31,13,31,144,31,80,31,80,30,179,31,254,31,184,31,172,31,88,31,157,31,18,31,235,31,179,31,48,31,134,31,222,31,176,31,81,31,202,31,250,31,166,31,166,30,194,31,197,31,195,31,222,31,94,31,234,31,234,30,54,31,114,31,114,30,6,31,47,31,217,31,202,31,202,30,229,31,229,30,241,31,88,31,88,30,162,31,127,31,90,31,107,31,238,31,238,30,238,29,221,31,108,31,51,31,51,30,230,31,65,31,215,31,251,31,47,31,47,30,123,31,130,31,102,31,192,31,122,31,89,31,89,30,88,31,88,30,235,31,5,31,80,31,231,31,44,31,216,31,26,31,72,31,50,31,249,31,141,31,141,30,50,31,30,31,9,31,94,31,22,31,132,31,104,31,165,31,165,30,165,29,146,31,143,31,240,31,24,31,214,31,71,31,169,31,197,31,197,30,90,31,118,31,200,31,84,31,136,31,136,30,49,31);

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
