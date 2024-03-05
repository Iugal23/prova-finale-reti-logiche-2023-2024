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

constant SCENARIO_LENGTH : integer := 873;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (240,0,143,0,210,0,75,0,25,0,138,0,154,0,110,0,138,0,152,0,0,0,87,0,231,0,205,0,92,0,30,0,51,0,0,0,0,0,0,0,227,0,243,0,162,0,190,0,21,0,220,0,228,0,204,0,92,0,191,0,176,0,0,0,103,0,177,0,0,0,0,0,0,0,19,0,15,0,33,0,63,0,0,0,0,0,36,0,198,0,59,0,252,0,242,0,0,0,113,0,112,0,206,0,123,0,151,0,62,0,0,0,159,0,94,0,159,0,0,0,40,0,0,0,225,0,131,0,15,0,0,0,182,0,149,0,114,0,18,0,0,0,217,0,0,0,0,0,217,0,0,0,0,0,236,0,161,0,253,0,36,0,222,0,144,0,0,0,253,0,67,0,24,0,117,0,157,0,213,0,0,0,27,0,36,0,0,0,0,0,85,0,133,0,72,0,144,0,206,0,99,0,69,0,63,0,144,0,193,0,146,0,110,0,85,0,0,0,0,0,0,0,103,0,0,0,97,0,79,0,2,0,108,0,0,0,0,0,102,0,45,0,30,0,7,0,106,0,0,0,126,0,30,0,160,0,0,0,7,0,65,0,0,0,61,0,154,0,249,0,16,0,62,0,58,0,194,0,0,0,105,0,0,0,102,0,0,0,0,0,161,0,231,0,115,0,110,0,0,0,133,0,45,0,4,0,0,0,30,0,209,0,172,0,94,0,6,0,177,0,216,0,208,0,139,0,155,0,129,0,165,0,235,0,243,0,182,0,0,0,122,0,85,0,34,0,227,0,45,0,146,0,0,0,27,0,83,0,100,0,193,0,0,0,65,0,0,0,212,0,0,0,201,0,205,0,183,0,108,0,0,0,243,0,212,0,185,0,81,0,225,0,206,0,170,0,0,0,154,0,96,0,181,0,0,0,145,0,169,0,23,0,0,0,64,0,252,0,94,0,204,0,208,0,0,0,74,0,0,0,130,0,90,0,36,0,0,0,0,0,210,0,138,0,230,0,32,0,0,0,234,0,224,0,0,0,139,0,0,0,221,0,56,0,111,0,115,0,161,0,119,0,0,0,224,0,167,0,217,0,178,0,0,0,0,0,61,0,10,0,177,0,128,0,40,0,124,0,0,0,0,0,199,0,69,0,235,0,123,0,0,0,0,0,250,0,195,0,183,0,127,0,17,0,56,0,216,0,113,0,191,0,94,0,140,0,16,0,23,0,214,0,55,0,198,0,31,0,190,0,135,0,200,0,194,0,105,0,184,0,147,0,210,0,129,0,197,0,51,0,82,0,34,0,183,0,0,0,178,0,80,0,155,0,198,0,243,0,97,0,0,0,128,0,0,0,28,0,88,0,0,0,131,0,238,0,9,0,63,0,139,0,73,0,74,0,0,0,183,0,0,0,0,0,170,0,155,0,32,0,243,0,194,0,66,0,141,0,25,0,0,0,152,0,28,0,194,0,105,0,231,0,0,0,175,0,114,0,153,0,64,0,16,0,92,0,144,0,202,0,220,0,94,0,66,0,143,0,99,0,0,0,235,0,94,0,0,0,252,0,202,0,140,0,0,0,130,0,0,0,43,0,79,0,102,0,212,0,40,0,226,0,78,0,91,0,214,0,80,0,42,0,108,0,77,0,67,0,0,0,219,0,199,0,224,0,76,0,135,0,0,0,164,0,235,0,179,0,110,0,91,0,0,0,117,0,241,0,151,0,0,0,0,0,241,0,130,0,0,0,251,0,164,0,110,0,117,0,250,0,62,0,100,0,0,0,183,0,0,0,123,0,32,0,201,0,90,0,240,0,111,0,0,0,131,0,80,0,98,0,25,0,244,0,0,0,192,0,22,0,135,0,190,0,149,0,0,0,175,0,248,0,66,0,91,0,252,0,221,0,220,0,106,0,97,0,88,0,0,0,33,0,50,0,142,0,95,0,79,0,51,0,0,0,116,0,118,0,0,0,232,0,119,0,13,0,179,0,0,0,242,0,200,0,123,0,137,0,246,0,0,0,43,0,218,0,181,0,167,0,35,0,84,0,163,0,105,0,108,0,207,0,185,0,0,0,0,0,255,0,0,0,0,0,0,0,223,0,49,0,0,0,228,0,136,0,58,0,0,0,115,0,65,0,228,0,44,0,169,0,100,0,109,0,232,0,46,0,102,0,0,0,201,0,180,0,235,0,220,0,80,0,235,0,25,0,171,0,74,0,224,0,198,0,7,0,212,0,184,0,135,0,254,0,186,0,198,0,76,0,107,0,116,0,178,0,88,0,126,0,99,0,147,0,46,0,123,0,0,0,0,0,0,0,79,0,141,0,223,0,181,0,171,0,90,0,118,0,51,0,117,0,152,0,46,0,122,0,158,0,37,0,106,0,87,0,69,0,195,0,250,0,134,0,213,0,149,0,141,0,228,0,0,0,60,0,174,0,94,0,0,0,251,0,0,0,179,0,131,0,83,0,11,0,0,0,71,0,247,0,0,0,34,0,126,0,185,0,177,0,169,0,188,0,96,0,0,0,114,0,148,0,0,0,111,0,113,0,0,0,0,0,171,0,0,0,0,0,174,0,245,0,194,0,220,0,164,0,117,0,221,0,80,0,85,0,0,0,144,0,0,0,222,0,27,0,88,0,194,0,182,0,155,0,185,0,91,0,196,0,0,0,193,0,200,0,67,0,7,0,0,0,98,0,182,0,36,0,153,0,238,0,10,0,29,0,106,0,214,0,0,0,53,0,233,0,102,0,36,0,0,0,45,0,239,0,85,0,184,0,225,0,0,0,109,0,8,0,77,0,63,0,122,0,0,0,15,0,160,0,0,0,162,0,50,0,78,0,0,0,207,0,0,0,238,0,243,0,96,0,0,0,0,0,7,0,0,0,163,0,0,0,106,0,116,0,110,0,15,0,99,0,76,0,71,0,0,0,189,0,70,0,109,0,0,0,169,0,0,0,249,0,0,0,111,0,77,0,0,0,241,0,0,0,69,0,141,0,0,0,85,0,0,0,86,0,102,0,7,0,0,0,225,0,39,0,138,0,88,0,34,0,179,0,135,0,151,0,0,0,133,0,52,0,156,0,0,0,126,0,95,0,37,0,117,0,191,0,0,0,158,0,64,0,130,0,212,0,0,0,83,0,152,0,59,0,0,0,163,0,34,0,170,0,86,0,216,0,143,0,170,0,242,0,94,0,17,0,49,0,81,0,130,0,142,0,116,0,9,0,72,0,79,0,146,0,223,0,0,0,0,0,0,0,221,0,66,0,87,0,123,0,82,0,217,0,153,0,176,0,0,0,0,0,102,0,32,0,107,0,124,0,103,0,70,0,210,0,117,0,202,0,108,0,92,0,233,0,0,0,0,0,249,0,0,0,9,0,111,0,122,0,13,0,16,0,81,0,123,0,78,0,243,0,0,0,0,0,121,0,99,0,78,0,216,0,233,0,101,0,0,0,98,0,40,0,0,0,100,0,29,0,87,0,175,0,232,0,0,0,194,0,153,0,23,0,124,0,11,0,25,0,26,0,229,0,29,0,88,0,77,0,205,0,85,0,48,0,105,0,5,0,136,0,154,0,156,0,156,0,150,0,54,0,138,0,0,0,230,0,0,0,2,0,0,0,78,0,73,0,245,0,0,0,177,0,0,0,121,0,9,0,137,0,9,0,54,0,3,0,72,0,52,0,109,0,160,0,96,0,39,0,190,0,43,0,0,0,0,0,140,0,216,0,137,0,146,0,0,0,196,0,0,0,142,0,245,0,176,0,16,0,144,0,102,0,179,0,60,0,156,0,1,0,13,0,67,0,45,0,0,0,222,0,188,0,163,0,1,0,34,0,0,0,145,0,107,0,193,0,199,0,156,0,168,0,11,0,184,0,68,0,40,0,189,0,181,0,0,0,203,0,58,0,253,0,223,0,110,0,0,0,122,0,162,0);
signal scenario_full  : scenario_type := (240,31,143,31,210,31,75,31,25,31,138,31,154,31,110,31,138,31,152,31,152,30,87,31,231,31,205,31,92,31,30,31,51,31,51,30,51,29,51,28,227,31,243,31,162,31,190,31,21,31,220,31,228,31,204,31,92,31,191,31,176,31,176,30,103,31,177,31,177,30,177,29,177,28,19,31,15,31,33,31,63,31,63,30,63,29,36,31,198,31,59,31,252,31,242,31,242,30,113,31,112,31,206,31,123,31,151,31,62,31,62,30,159,31,94,31,159,31,159,30,40,31,40,30,225,31,131,31,15,31,15,30,182,31,149,31,114,31,18,31,18,30,217,31,217,30,217,29,217,31,217,30,217,29,236,31,161,31,253,31,36,31,222,31,144,31,144,30,253,31,67,31,24,31,117,31,157,31,213,31,213,30,27,31,36,31,36,30,36,29,85,31,133,31,72,31,144,31,206,31,99,31,69,31,63,31,144,31,193,31,146,31,110,31,85,31,85,30,85,29,85,28,103,31,103,30,97,31,79,31,2,31,108,31,108,30,108,29,102,31,45,31,30,31,7,31,106,31,106,30,126,31,30,31,160,31,160,30,7,31,65,31,65,30,61,31,154,31,249,31,16,31,62,31,58,31,194,31,194,30,105,31,105,30,102,31,102,30,102,29,161,31,231,31,115,31,110,31,110,30,133,31,45,31,4,31,4,30,30,31,209,31,172,31,94,31,6,31,177,31,216,31,208,31,139,31,155,31,129,31,165,31,235,31,243,31,182,31,182,30,122,31,85,31,34,31,227,31,45,31,146,31,146,30,27,31,83,31,100,31,193,31,193,30,65,31,65,30,212,31,212,30,201,31,205,31,183,31,108,31,108,30,243,31,212,31,185,31,81,31,225,31,206,31,170,31,170,30,154,31,96,31,181,31,181,30,145,31,169,31,23,31,23,30,64,31,252,31,94,31,204,31,208,31,208,30,74,31,74,30,130,31,90,31,36,31,36,30,36,29,210,31,138,31,230,31,32,31,32,30,234,31,224,31,224,30,139,31,139,30,221,31,56,31,111,31,115,31,161,31,119,31,119,30,224,31,167,31,217,31,178,31,178,30,178,29,61,31,10,31,177,31,128,31,40,31,124,31,124,30,124,29,199,31,69,31,235,31,123,31,123,30,123,29,250,31,195,31,183,31,127,31,17,31,56,31,216,31,113,31,191,31,94,31,140,31,16,31,23,31,214,31,55,31,198,31,31,31,190,31,135,31,200,31,194,31,105,31,184,31,147,31,210,31,129,31,197,31,51,31,82,31,34,31,183,31,183,30,178,31,80,31,155,31,198,31,243,31,97,31,97,30,128,31,128,30,28,31,88,31,88,30,131,31,238,31,9,31,63,31,139,31,73,31,74,31,74,30,183,31,183,30,183,29,170,31,155,31,32,31,243,31,194,31,66,31,141,31,25,31,25,30,152,31,28,31,194,31,105,31,231,31,231,30,175,31,114,31,153,31,64,31,16,31,92,31,144,31,202,31,220,31,94,31,66,31,143,31,99,31,99,30,235,31,94,31,94,30,252,31,202,31,140,31,140,30,130,31,130,30,43,31,79,31,102,31,212,31,40,31,226,31,78,31,91,31,214,31,80,31,42,31,108,31,77,31,67,31,67,30,219,31,199,31,224,31,76,31,135,31,135,30,164,31,235,31,179,31,110,31,91,31,91,30,117,31,241,31,151,31,151,30,151,29,241,31,130,31,130,30,251,31,164,31,110,31,117,31,250,31,62,31,100,31,100,30,183,31,183,30,123,31,32,31,201,31,90,31,240,31,111,31,111,30,131,31,80,31,98,31,25,31,244,31,244,30,192,31,22,31,135,31,190,31,149,31,149,30,175,31,248,31,66,31,91,31,252,31,221,31,220,31,106,31,97,31,88,31,88,30,33,31,50,31,142,31,95,31,79,31,51,31,51,30,116,31,118,31,118,30,232,31,119,31,13,31,179,31,179,30,242,31,200,31,123,31,137,31,246,31,246,30,43,31,218,31,181,31,167,31,35,31,84,31,163,31,105,31,108,31,207,31,185,31,185,30,185,29,255,31,255,30,255,29,255,28,223,31,49,31,49,30,228,31,136,31,58,31,58,30,115,31,65,31,228,31,44,31,169,31,100,31,109,31,232,31,46,31,102,31,102,30,201,31,180,31,235,31,220,31,80,31,235,31,25,31,171,31,74,31,224,31,198,31,7,31,212,31,184,31,135,31,254,31,186,31,198,31,76,31,107,31,116,31,178,31,88,31,126,31,99,31,147,31,46,31,123,31,123,30,123,29,123,28,79,31,141,31,223,31,181,31,171,31,90,31,118,31,51,31,117,31,152,31,46,31,122,31,158,31,37,31,106,31,87,31,69,31,195,31,250,31,134,31,213,31,149,31,141,31,228,31,228,30,60,31,174,31,94,31,94,30,251,31,251,30,179,31,131,31,83,31,11,31,11,30,71,31,247,31,247,30,34,31,126,31,185,31,177,31,169,31,188,31,96,31,96,30,114,31,148,31,148,30,111,31,113,31,113,30,113,29,171,31,171,30,171,29,174,31,245,31,194,31,220,31,164,31,117,31,221,31,80,31,85,31,85,30,144,31,144,30,222,31,27,31,88,31,194,31,182,31,155,31,185,31,91,31,196,31,196,30,193,31,200,31,67,31,7,31,7,30,98,31,182,31,36,31,153,31,238,31,10,31,29,31,106,31,214,31,214,30,53,31,233,31,102,31,36,31,36,30,45,31,239,31,85,31,184,31,225,31,225,30,109,31,8,31,77,31,63,31,122,31,122,30,15,31,160,31,160,30,162,31,50,31,78,31,78,30,207,31,207,30,238,31,243,31,96,31,96,30,96,29,7,31,7,30,163,31,163,30,106,31,116,31,110,31,15,31,99,31,76,31,71,31,71,30,189,31,70,31,109,31,109,30,169,31,169,30,249,31,249,30,111,31,77,31,77,30,241,31,241,30,69,31,141,31,141,30,85,31,85,30,86,31,102,31,7,31,7,30,225,31,39,31,138,31,88,31,34,31,179,31,135,31,151,31,151,30,133,31,52,31,156,31,156,30,126,31,95,31,37,31,117,31,191,31,191,30,158,31,64,31,130,31,212,31,212,30,83,31,152,31,59,31,59,30,163,31,34,31,170,31,86,31,216,31,143,31,170,31,242,31,94,31,17,31,49,31,81,31,130,31,142,31,116,31,9,31,72,31,79,31,146,31,223,31,223,30,223,29,223,28,221,31,66,31,87,31,123,31,82,31,217,31,153,31,176,31,176,30,176,29,102,31,32,31,107,31,124,31,103,31,70,31,210,31,117,31,202,31,108,31,92,31,233,31,233,30,233,29,249,31,249,30,9,31,111,31,122,31,13,31,16,31,81,31,123,31,78,31,243,31,243,30,243,29,121,31,99,31,78,31,216,31,233,31,101,31,101,30,98,31,40,31,40,30,100,31,29,31,87,31,175,31,232,31,232,30,194,31,153,31,23,31,124,31,11,31,25,31,26,31,229,31,29,31,88,31,77,31,205,31,85,31,48,31,105,31,5,31,136,31,154,31,156,31,156,31,150,31,54,31,138,31,138,30,230,31,230,30,2,31,2,30,78,31,73,31,245,31,245,30,177,31,177,30,121,31,9,31,137,31,9,31,54,31,3,31,72,31,52,31,109,31,160,31,96,31,39,31,190,31,43,31,43,30,43,29,140,31,216,31,137,31,146,31,146,30,196,31,196,30,142,31,245,31,176,31,16,31,144,31,102,31,179,31,60,31,156,31,1,31,13,31,67,31,45,31,45,30,222,31,188,31,163,31,1,31,34,31,34,30,145,31,107,31,193,31,199,31,156,31,168,31,11,31,184,31,68,31,40,31,189,31,181,31,181,30,203,31,58,31,253,31,223,31,110,31,110,30,122,31,162,31);

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
