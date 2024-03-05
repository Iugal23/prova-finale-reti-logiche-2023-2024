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

constant SCENARIO_LENGTH : integer := 870;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (128,0,87,0,225,0,226,0,0,0,96,0,179,0,116,0,0,0,0,0,201,0,153,0,11,0,238,0,99,0,0,0,112,0,126,0,170,0,0,0,86,0,241,0,9,0,182,0,230,0,0,0,0,0,203,0,89,0,235,0,79,0,195,0,141,0,0,0,128,0,19,0,10,0,92,0,163,0,188,0,166,0,154,0,111,0,196,0,0,0,151,0,67,0,249,0,21,0,0,0,34,0,0,0,0,0,83,0,44,0,120,0,25,0,136,0,159,0,252,0,95,0,0,0,0,0,132,0,233,0,112,0,0,0,0,0,195,0,143,0,154,0,9,0,79,0,253,0,26,0,0,0,0,0,9,0,85,0,178,0,0,0,0,0,106,0,0,0,0,0,0,0,184,0,79,0,109,0,127,0,25,0,174,0,2,0,97,0,249,0,233,0,0,0,153,0,31,0,252,0,38,0,90,0,74,0,35,0,27,0,97,0,186,0,223,0,27,0,35,0,120,0,137,0,19,0,43,0,104,0,0,0,110,0,177,0,191,0,31,0,0,0,140,0,0,0,52,0,134,0,47,0,187,0,0,0,145,0,250,0,69,0,117,0,238,0,175,0,66,0,76,0,184,0,4,0,86,0,54,0,199,0,189,0,111,0,0,0,215,0,201,0,28,0,118,0,0,0,0,0,0,0,199,0,242,0,52,0,229,0,3,0,0,0,49,0,0,0,0,0,203,0,2,0,165,0,158,0,102,0,245,0,220,0,193,0,179,0,141,0,252,0,230,0,178,0,159,0,214,0,57,0,229,0,11,0,0,0,0,0,178,0,30,0,25,0,60,0,77,0,71,0,140,0,0,0,33,0,0,0,78,0,178,0,139,0,220,0,197,0,248,0,174,0,97,0,219,0,110,0,150,0,247,0,203,0,0,0,192,0,0,0,0,0,221,0,92,0,112,0,248,0,75,0,218,0,204,0,176,0,0,0,111,0,121,0,128,0,222,0,22,0,0,0,0,0,0,0,162,0,150,0,119,0,61,0,143,0,117,0,10,0,238,0,0,0,0,0,0,0,0,0,0,0,0,0,95,0,11,0,249,0,212,0,0,0,94,0,174,0,0,0,55,0,218,0,86,0,0,0,76,0,241,0,43,0,190,0,232,0,109,0,178,0,166,0,134,0,0,0,161,0,146,0,156,0,148,0,73,0,230,0,235,0,197,0,137,0,77,0,0,0,212,0,166,0,0,0,111,0,134,0,188,0,24,0,188,0,35,0,120,0,35,0,42,0,181,0,0,0,255,0,194,0,156,0,18,0,0,0,187,0,106,0,185,0,147,0,120,0,110,0,128,0,184,0,233,0,0,0,112,0,132,0,73,0,196,0,220,0,128,0,163,0,182,0,220,0,85,0,124,0,97,0,133,0,157,0,118,0,164,0,46,0,238,0,190,0,215,0,64,0,242,0,255,0,146,0,233,0,76,0,134,0,248,0,131,0,182,0,165,0,11,0,0,0,91,0,87,0,55,0,73,0,99,0,0,0,249,0,210,0,190,0,0,0,136,0,23,0,20,0,125,0,131,0,221,0,128,0,0,0,192,0,69,0,168,0,0,0,127,0,131,0,226,0,214,0,56,0,121,0,9,0,0,0,219,0,39,0,187,0,0,0,38,0,37,0,0,0,228,0,75,0,0,0,0,0,230,0,60,0,0,0,234,0,234,0,27,0,117,0,56,0,51,0,141,0,0,0,0,0,116,0,209,0,69,0,138,0,238,0,0,0,130,0,113,0,244,0,159,0,88,0,39,0,63,0,0,0,1,0,91,0,154,0,168,0,239,0,120,0,142,0,243,0,21,0,217,0,105,0,222,0,0,0,0,0,246,0,86,0,195,0,173,0,0,0,137,0,127,0,79,0,41,0,0,0,72,0,39,0,150,0,0,0,0,0,238,0,4,0,171,0,0,0,92,0,30,0,38,0,89,0,0,0,98,0,173,0,0,0,240,0,0,0,52,0,132,0,240,0,107,0,0,0,192,0,124,0,0,0,152,0,195,0,72,0,0,0,98,0,0,0,201,0,0,0,112,0,0,0,178,0,17,0,239,0,87,0,48,0,0,0,191,0,57,0,128,0,111,0,250,0,108,0,79,0,101,0,46,0,105,0,179,0,99,0,217,0,235,0,3,0,138,0,44,0,148,0,78,0,0,0,35,0,0,0,231,0,0,0,3,0,104,0,201,0,158,0,36,0,0,0,120,0,72,0,0,0,193,0,253,0,20,0,213,0,91,0,63,0,218,0,20,0,190,0,203,0,162,0,0,0,186,0,130,0,53,0,11,0,120,0,185,0,0,0,176,0,119,0,52,0,109,0,214,0,0,0,157,0,38,0,185,0,0,0,128,0,189,0,0,0,133,0,3,0,79,0,59,0,224,0,128,0,241,0,48,0,0,0,52,0,242,0,46,0,38,0,122,0,99,0,0,0,51,0,49,0,0,0,61,0,132,0,8,0,72,0,0,0,110,0,156,0,148,0,218,0,139,0,99,0,48,0,60,0,207,0,202,0,158,0,206,0,0,0,141,0,0,0,47,0,80,0,71,0,0,0,51,0,225,0,0,0,72,0,81,0,9,0,129,0,91,0,172,0,0,0,215,0,220,0,235,0,248,0,45,0,178,0,236,0,0,0,182,0,0,0,160,0,93,0,137,0,129,0,182,0,210,0,0,0,156,0,67,0,0,0,217,0,165,0,171,0,144,0,30,0,38,0,54,0,94,0,83,0,226,0,224,0,162,0,38,0,103,0,177,0,0,0,0,0,31,0,51,0,102,0,8,0,221,0,0,0,231,0,146,0,0,0,239,0,245,0,112,0,0,0,59,0,122,0,172,0,72,0,0,0,152,0,216,0,180,0,0,0,0,0,107,0,157,0,131,0,155,0,181,0,181,0,168,0,0,0,0,0,0,0,0,0,0,0,183,0,63,0,231,0,23,0,120,0,101,0,234,0,0,0,0,0,0,0,162,0,159,0,118,0,160,0,50,0,219,0,2,0,0,0,0,0,74,0,208,0,105,0,122,0,39,0,80,0,59,0,232,0,28,0,38,0,219,0,86,0,96,0,134,0,0,0,36,0,0,0,245,0,128,0,14,0,201,0,64,0,106,0,0,0,109,0,91,0,0,0,221,0,183,0,168,0,220,0,121,0,120,0,16,0,199,0,209,0,112,0,0,0,207,0,172,0,105,0,211,0,140,0,0,0,27,0,87,0,115,0,40,0,0,0,207,0,106,0,32,0,171,0,239,0,65,0,61,0,109,0,203,0,0,0,110,0,0,0,14,0,182,0,106,0,40,0,0,0,100,0,0,0,91,0,50,0,0,0,159,0,0,0,0,0,181,0,0,0,189,0,182,0,33,0,129,0,228,0,81,0,38,0,0,0,114,0,101,0,46,0,70,0,164,0,110,0,0,0,138,0,187,0,147,0,101,0,9,0,152,0,140,0,86,0,21,0,119,0,151,0,0,0,164,0,51,0,169,0,87,0,177,0,120,0,209,0,147,0,3,0,165,0,132,0,120,0,238,0,88,0,244,0,12,0,94,0,183,0,97,0,0,0,0,0,0,0,22,0,235,0,213,0,0,0,181,0,253,0,0,0,201,0,181,0,171,0,71,0,0,0,242,0,49,0,0,0,0,0,211,0,230,0,135,0,87,0,186,0,122,0,235,0,0,0,233,0,132,0,0,0,169,0,0,0,203,0,54,0,86,0,0,0,0,0,27,0,239,0,0,0,0,0,156,0,150,0,145,0,148,0,94,0,58,0,195,0,46,0,162,0,40,0,165,0,170,0,0,0,110,0,146,0,157,0,0,0,220,0,71,0,48,0,64,0,100,0,203,0,230,0,0,0,0,0,74,0,190,0,26,0,184,0,76,0);
signal scenario_full  : scenario_type := (128,31,87,31,225,31,226,31,226,30,96,31,179,31,116,31,116,30,116,29,201,31,153,31,11,31,238,31,99,31,99,30,112,31,126,31,170,31,170,30,86,31,241,31,9,31,182,31,230,31,230,30,230,29,203,31,89,31,235,31,79,31,195,31,141,31,141,30,128,31,19,31,10,31,92,31,163,31,188,31,166,31,154,31,111,31,196,31,196,30,151,31,67,31,249,31,21,31,21,30,34,31,34,30,34,29,83,31,44,31,120,31,25,31,136,31,159,31,252,31,95,31,95,30,95,29,132,31,233,31,112,31,112,30,112,29,195,31,143,31,154,31,9,31,79,31,253,31,26,31,26,30,26,29,9,31,85,31,178,31,178,30,178,29,106,31,106,30,106,29,106,28,184,31,79,31,109,31,127,31,25,31,174,31,2,31,97,31,249,31,233,31,233,30,153,31,31,31,252,31,38,31,90,31,74,31,35,31,27,31,97,31,186,31,223,31,27,31,35,31,120,31,137,31,19,31,43,31,104,31,104,30,110,31,177,31,191,31,31,31,31,30,140,31,140,30,52,31,134,31,47,31,187,31,187,30,145,31,250,31,69,31,117,31,238,31,175,31,66,31,76,31,184,31,4,31,86,31,54,31,199,31,189,31,111,31,111,30,215,31,201,31,28,31,118,31,118,30,118,29,118,28,199,31,242,31,52,31,229,31,3,31,3,30,49,31,49,30,49,29,203,31,2,31,165,31,158,31,102,31,245,31,220,31,193,31,179,31,141,31,252,31,230,31,178,31,159,31,214,31,57,31,229,31,11,31,11,30,11,29,178,31,30,31,25,31,60,31,77,31,71,31,140,31,140,30,33,31,33,30,78,31,178,31,139,31,220,31,197,31,248,31,174,31,97,31,219,31,110,31,150,31,247,31,203,31,203,30,192,31,192,30,192,29,221,31,92,31,112,31,248,31,75,31,218,31,204,31,176,31,176,30,111,31,121,31,128,31,222,31,22,31,22,30,22,29,22,28,162,31,150,31,119,31,61,31,143,31,117,31,10,31,238,31,238,30,238,29,238,28,238,27,238,26,238,25,95,31,11,31,249,31,212,31,212,30,94,31,174,31,174,30,55,31,218,31,86,31,86,30,76,31,241,31,43,31,190,31,232,31,109,31,178,31,166,31,134,31,134,30,161,31,146,31,156,31,148,31,73,31,230,31,235,31,197,31,137,31,77,31,77,30,212,31,166,31,166,30,111,31,134,31,188,31,24,31,188,31,35,31,120,31,35,31,42,31,181,31,181,30,255,31,194,31,156,31,18,31,18,30,187,31,106,31,185,31,147,31,120,31,110,31,128,31,184,31,233,31,233,30,112,31,132,31,73,31,196,31,220,31,128,31,163,31,182,31,220,31,85,31,124,31,97,31,133,31,157,31,118,31,164,31,46,31,238,31,190,31,215,31,64,31,242,31,255,31,146,31,233,31,76,31,134,31,248,31,131,31,182,31,165,31,11,31,11,30,91,31,87,31,55,31,73,31,99,31,99,30,249,31,210,31,190,31,190,30,136,31,23,31,20,31,125,31,131,31,221,31,128,31,128,30,192,31,69,31,168,31,168,30,127,31,131,31,226,31,214,31,56,31,121,31,9,31,9,30,219,31,39,31,187,31,187,30,38,31,37,31,37,30,228,31,75,31,75,30,75,29,230,31,60,31,60,30,234,31,234,31,27,31,117,31,56,31,51,31,141,31,141,30,141,29,116,31,209,31,69,31,138,31,238,31,238,30,130,31,113,31,244,31,159,31,88,31,39,31,63,31,63,30,1,31,91,31,154,31,168,31,239,31,120,31,142,31,243,31,21,31,217,31,105,31,222,31,222,30,222,29,246,31,86,31,195,31,173,31,173,30,137,31,127,31,79,31,41,31,41,30,72,31,39,31,150,31,150,30,150,29,238,31,4,31,171,31,171,30,92,31,30,31,38,31,89,31,89,30,98,31,173,31,173,30,240,31,240,30,52,31,132,31,240,31,107,31,107,30,192,31,124,31,124,30,152,31,195,31,72,31,72,30,98,31,98,30,201,31,201,30,112,31,112,30,178,31,17,31,239,31,87,31,48,31,48,30,191,31,57,31,128,31,111,31,250,31,108,31,79,31,101,31,46,31,105,31,179,31,99,31,217,31,235,31,3,31,138,31,44,31,148,31,78,31,78,30,35,31,35,30,231,31,231,30,3,31,104,31,201,31,158,31,36,31,36,30,120,31,72,31,72,30,193,31,253,31,20,31,213,31,91,31,63,31,218,31,20,31,190,31,203,31,162,31,162,30,186,31,130,31,53,31,11,31,120,31,185,31,185,30,176,31,119,31,52,31,109,31,214,31,214,30,157,31,38,31,185,31,185,30,128,31,189,31,189,30,133,31,3,31,79,31,59,31,224,31,128,31,241,31,48,31,48,30,52,31,242,31,46,31,38,31,122,31,99,31,99,30,51,31,49,31,49,30,61,31,132,31,8,31,72,31,72,30,110,31,156,31,148,31,218,31,139,31,99,31,48,31,60,31,207,31,202,31,158,31,206,31,206,30,141,31,141,30,47,31,80,31,71,31,71,30,51,31,225,31,225,30,72,31,81,31,9,31,129,31,91,31,172,31,172,30,215,31,220,31,235,31,248,31,45,31,178,31,236,31,236,30,182,31,182,30,160,31,93,31,137,31,129,31,182,31,210,31,210,30,156,31,67,31,67,30,217,31,165,31,171,31,144,31,30,31,38,31,54,31,94,31,83,31,226,31,224,31,162,31,38,31,103,31,177,31,177,30,177,29,31,31,51,31,102,31,8,31,221,31,221,30,231,31,146,31,146,30,239,31,245,31,112,31,112,30,59,31,122,31,172,31,72,31,72,30,152,31,216,31,180,31,180,30,180,29,107,31,157,31,131,31,155,31,181,31,181,31,168,31,168,30,168,29,168,28,168,27,168,26,183,31,63,31,231,31,23,31,120,31,101,31,234,31,234,30,234,29,234,28,162,31,159,31,118,31,160,31,50,31,219,31,2,31,2,30,2,29,74,31,208,31,105,31,122,31,39,31,80,31,59,31,232,31,28,31,38,31,219,31,86,31,96,31,134,31,134,30,36,31,36,30,245,31,128,31,14,31,201,31,64,31,106,31,106,30,109,31,91,31,91,30,221,31,183,31,168,31,220,31,121,31,120,31,16,31,199,31,209,31,112,31,112,30,207,31,172,31,105,31,211,31,140,31,140,30,27,31,87,31,115,31,40,31,40,30,207,31,106,31,32,31,171,31,239,31,65,31,61,31,109,31,203,31,203,30,110,31,110,30,14,31,182,31,106,31,40,31,40,30,100,31,100,30,91,31,50,31,50,30,159,31,159,30,159,29,181,31,181,30,189,31,182,31,33,31,129,31,228,31,81,31,38,31,38,30,114,31,101,31,46,31,70,31,164,31,110,31,110,30,138,31,187,31,147,31,101,31,9,31,152,31,140,31,86,31,21,31,119,31,151,31,151,30,164,31,51,31,169,31,87,31,177,31,120,31,209,31,147,31,3,31,165,31,132,31,120,31,238,31,88,31,244,31,12,31,94,31,183,31,97,31,97,30,97,29,97,28,22,31,235,31,213,31,213,30,181,31,253,31,253,30,201,31,181,31,171,31,71,31,71,30,242,31,49,31,49,30,49,29,211,31,230,31,135,31,87,31,186,31,122,31,235,31,235,30,233,31,132,31,132,30,169,31,169,30,203,31,54,31,86,31,86,30,86,29,27,31,239,31,239,30,239,29,156,31,150,31,145,31,148,31,94,31,58,31,195,31,46,31,162,31,40,31,165,31,170,31,170,30,110,31,146,31,157,31,157,30,220,31,71,31,48,31,64,31,100,31,203,31,230,31,230,30,230,29,74,31,190,31,26,31,184,31,76,31);

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
