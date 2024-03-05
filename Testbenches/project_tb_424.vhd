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

constant SCENARIO_LENGTH : integer := 852;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,123,0,175,0,236,0,0,0,55,0,183,0,0,0,55,0,54,0,0,0,54,0,251,0,175,0,0,0,42,0,222,0,61,0,108,0,159,0,52,0,0,0,59,0,6,0,95,0,89,0,0,0,13,0,191,0,252,0,111,0,30,0,0,0,0,0,225,0,122,0,178,0,0,0,0,0,72,0,146,0,206,0,69,0,182,0,59,0,122,0,202,0,203,0,24,0,228,0,44,0,24,0,92,0,0,0,207,0,28,0,86,0,99,0,28,0,236,0,167,0,162,0,53,0,240,0,166,0,91,0,190,0,207,0,144,0,0,0,137,0,90,0,35,0,0,0,188,0,231,0,0,0,133,0,74,0,54,0,213,0,76,0,0,0,179,0,240,0,127,0,135,0,59,0,132,0,188,0,222,0,30,0,194,0,14,0,31,0,215,0,184,0,0,0,0,0,107,0,0,0,210,0,128,0,253,0,19,0,0,0,0,0,0,0,203,0,65,0,27,0,77,0,0,0,159,0,0,0,0,0,210,0,146,0,228,0,149,0,139,0,146,0,237,0,198,0,12,0,100,0,222,0,236,0,135,0,94,0,0,0,228,0,124,0,80,0,239,0,228,0,95,0,0,0,225,0,27,0,0,0,62,0,77,0,209,0,21,0,224,0,253,0,226,0,135,0,176,0,0,0,71,0,93,0,0,0,11,0,156,0,81,0,172,0,170,0,0,0,248,0,23,0,236,0,60,0,115,0,0,0,173,0,0,0,0,0,0,0,14,0,184,0,29,0,200,0,249,0,39,0,30,0,239,0,162,0,245,0,122,0,0,0,0,0,200,0,0,0,246,0,184,0,0,0,51,0,211,0,191,0,207,0,38,0,121,0,199,0,0,0,169,0,197,0,0,0,0,0,0,0,178,0,90,0,183,0,126,0,121,0,10,0,98,0,0,0,43,0,242,0,0,0,36,0,16,0,0,0,24,0,249,0,43,0,67,0,31,0,0,0,100,0,144,0,96,0,36,0,179,0,201,0,0,0,162,0,0,0,200,0,108,0,183,0,216,0,177,0,123,0,233,0,232,0,0,0,0,0,242,0,104,0,115,0,11,0,159,0,164,0,26,0,8,0,51,0,0,0,136,0,68,0,99,0,161,0,69,0,0,0,210,0,76,0,4,0,0,0,206,0,46,0,69,0,4,0,0,0,181,0,217,0,0,0,0,0,236,0,115,0,102,0,0,0,0,0,42,0,214,0,0,0,123,0,19,0,30,0,206,0,33,0,209,0,110,0,0,0,34,0,169,0,61,0,220,0,114,0,7,0,19,0,63,0,24,0,150,0,183,0,112,0,0,0,181,0,219,0,51,0,222,0,243,0,147,0,150,0,45,0,129,0,0,0,221,0,115,0,144,0,224,0,84,0,204,0,36,0,42,0,209,0,26,0,0,0,0,0,223,0,197,0,86,0,51,0,0,0,0,0,67,0,199,0,95,0,0,0,67,0,255,0,148,0,46,0,0,0,96,0,112,0,178,0,92,0,193,0,186,0,153,0,0,0,154,0,182,0,182,0,242,0,231,0,81,0,173,0,119,0,111,0,36,0,0,0,241,0,205,0,57,0,98,0,70,0,12,0,0,0,230,0,0,0,0,0,144,0,97,0,227,0,172,0,195,0,136,0,55,0,19,0,144,0,5,0,229,0,128,0,209,0,5,0,47,0,0,0,209,0,0,0,23,0,151,0,218,0,0,0,0,0,71,0,43,0,137,0,235,0,3,0,0,0,212,0,85,0,215,0,118,0,228,0,149,0,98,0,211,0,159,0,214,0,182,0,78,0,165,0,185,0,110,0,150,0,28,0,210,0,166,0,209,0,215,0,148,0,125,0,247,0,254,0,95,0,84,0,250,0,0,0,0,0,16,0,0,0,240,0,192,0,0,0,102,0,0,0,196,0,217,0,245,0,172,0,38,0,77,0,240,0,30,0,204,0,186,0,179,0,138,0,201,0,242,0,0,0,103,0,251,0,26,0,202,0,128,0,0,0,114,0,0,0,135,0,240,0,224,0,16,0,72,0,165,0,72,0,241,0,178,0,86,0,52,0,194,0,0,0,225,0,77,0,156,0,94,0,42,0,0,0,55,0,160,0,3,0,207,0,91,0,0,0,0,0,73,0,101,0,181,0,2,0,0,0,0,0,183,0,204,0,92,0,0,0,0,0,2,0,121,0,0,0,214,0,249,0,129,0,115,0,62,0,34,0,18,0,141,0,130,0,0,0,118,0,214,0,82,0,0,0,119,0,80,0,0,0,15,0,0,0,0,0,0,0,41,0,0,0,202,0,10,0,0,0,156,0,20,0,141,0,215,0,68,0,15,0,4,0,0,0,134,0,110,0,20,0,102,0,251,0,0,0,73,0,182,0,0,0,0,0,207,0,86,0,137,0,156,0,220,0,219,0,89,0,152,0,0,0,175,0,5,0,210,0,0,0,82,0,163,0,39,0,219,0,37,0,155,0,245,0,33,0,0,0,0,0,64,0,196,0,248,0,3,0,167,0,229,0,87,0,0,0,57,0,74,0,223,0,173,0,193,0,125,0,164,0,65,0,73,0,4,0,97,0,13,0,231,0,0,0,0,0,234,0,75,0,100,0,168,0,111,0,242,0,241,0,0,0,0,0,152,0,242,0,90,0,0,0,55,0,200,0,55,0,122,0,0,0,0,0,65,0,0,0,111,0,0,0,41,0,5,0,196,0,0,0,97,0,19,0,34,0,142,0,0,0,0,0,0,0,189,0,120,0,190,0,198,0,0,0,0,0,88,0,185,0,0,0,8,0,0,0,14,0,209,0,176,0,77,0,252,0,255,0,0,0,181,0,169,0,175,0,12,0,8,0,143,0,95,0,11,0,65,0,0,0,0,0,64,0,56,0,37,0,32,0,114,0,144,0,105,0,0,0,234,0,36,0,0,0,51,0,204,0,0,0,175,0,0,0,0,0,68,0,67,0,151,0,93,0,158,0,0,0,229,0,184,0,0,0,131,0,212,0,152,0,0,0,198,0,164,0,107,0,150,0,12,0,6,0,0,0,0,0,0,0,141,0,4,0,112,0,63,0,70,0,240,0,152,0,132,0,184,0,165,0,172,0,66,0,4,0,118,0,0,0,77,0,40,0,199,0,142,0,226,0,173,0,15,0,163,0,10,0,0,0,202,0,240,0,118,0,227,0,202,0,53,0,84,0,124,0,0,0,38,0,59,0,202,0,0,0,0,0,144,0,248,0,170,0,196,0,33,0,252,0,160,0,0,0,1,0,0,0,253,0,0,0,233,0,0,0,79,0,0,0,47,0,215,0,63,0,159,0,239,0,146,0,0,0,48,0,102,0,106,0,0,0,255,0,82,0,71,0,131,0,195,0,0,0,10,0,30,0,110,0,98,0,137,0,150,0,48,0,179,0,182,0,0,0,65,0,65,0,43,0,108,0,94,0,174,0,144,0,194,0,8,0,196,0,9,0,0,0,78,0,71,0,79,0,200,0,28,0,195,0,0,0,19,0,0,0,152,0,178,0,0,0,177,0,220,0,213,0,150,0,0,0,227,0,244,0,140,0,0,0,95,0,209,0,246,0,0,0,70,0,196,0,0,0,0,0,73,0,0,0,237,0,139,0,0,0,232,0,131,0,213,0,155,0,0,0,155,0,219,0,149,0,0,0,210,0,233,0,158,0,218,0,176,0,0,0,0,0,0,0,27,0,35,0,243,0,89,0,178,0,233,0,216,0,162,0,0,0,192,0,78,0,99,0,101,0,41,0,61,0,42,0,200,0,231,0,101,0,79,0,0,0,81,0);
signal scenario_full  : scenario_type := (0,0,123,31,175,31,236,31,236,30,55,31,183,31,183,30,55,31,54,31,54,30,54,31,251,31,175,31,175,30,42,31,222,31,61,31,108,31,159,31,52,31,52,30,59,31,6,31,95,31,89,31,89,30,13,31,191,31,252,31,111,31,30,31,30,30,30,29,225,31,122,31,178,31,178,30,178,29,72,31,146,31,206,31,69,31,182,31,59,31,122,31,202,31,203,31,24,31,228,31,44,31,24,31,92,31,92,30,207,31,28,31,86,31,99,31,28,31,236,31,167,31,162,31,53,31,240,31,166,31,91,31,190,31,207,31,144,31,144,30,137,31,90,31,35,31,35,30,188,31,231,31,231,30,133,31,74,31,54,31,213,31,76,31,76,30,179,31,240,31,127,31,135,31,59,31,132,31,188,31,222,31,30,31,194,31,14,31,31,31,215,31,184,31,184,30,184,29,107,31,107,30,210,31,128,31,253,31,19,31,19,30,19,29,19,28,203,31,65,31,27,31,77,31,77,30,159,31,159,30,159,29,210,31,146,31,228,31,149,31,139,31,146,31,237,31,198,31,12,31,100,31,222,31,236,31,135,31,94,31,94,30,228,31,124,31,80,31,239,31,228,31,95,31,95,30,225,31,27,31,27,30,62,31,77,31,209,31,21,31,224,31,253,31,226,31,135,31,176,31,176,30,71,31,93,31,93,30,11,31,156,31,81,31,172,31,170,31,170,30,248,31,23,31,236,31,60,31,115,31,115,30,173,31,173,30,173,29,173,28,14,31,184,31,29,31,200,31,249,31,39,31,30,31,239,31,162,31,245,31,122,31,122,30,122,29,200,31,200,30,246,31,184,31,184,30,51,31,211,31,191,31,207,31,38,31,121,31,199,31,199,30,169,31,197,31,197,30,197,29,197,28,178,31,90,31,183,31,126,31,121,31,10,31,98,31,98,30,43,31,242,31,242,30,36,31,16,31,16,30,24,31,249,31,43,31,67,31,31,31,31,30,100,31,144,31,96,31,36,31,179,31,201,31,201,30,162,31,162,30,200,31,108,31,183,31,216,31,177,31,123,31,233,31,232,31,232,30,232,29,242,31,104,31,115,31,11,31,159,31,164,31,26,31,8,31,51,31,51,30,136,31,68,31,99,31,161,31,69,31,69,30,210,31,76,31,4,31,4,30,206,31,46,31,69,31,4,31,4,30,181,31,217,31,217,30,217,29,236,31,115,31,102,31,102,30,102,29,42,31,214,31,214,30,123,31,19,31,30,31,206,31,33,31,209,31,110,31,110,30,34,31,169,31,61,31,220,31,114,31,7,31,19,31,63,31,24,31,150,31,183,31,112,31,112,30,181,31,219,31,51,31,222,31,243,31,147,31,150,31,45,31,129,31,129,30,221,31,115,31,144,31,224,31,84,31,204,31,36,31,42,31,209,31,26,31,26,30,26,29,223,31,197,31,86,31,51,31,51,30,51,29,67,31,199,31,95,31,95,30,67,31,255,31,148,31,46,31,46,30,96,31,112,31,178,31,92,31,193,31,186,31,153,31,153,30,154,31,182,31,182,31,242,31,231,31,81,31,173,31,119,31,111,31,36,31,36,30,241,31,205,31,57,31,98,31,70,31,12,31,12,30,230,31,230,30,230,29,144,31,97,31,227,31,172,31,195,31,136,31,55,31,19,31,144,31,5,31,229,31,128,31,209,31,5,31,47,31,47,30,209,31,209,30,23,31,151,31,218,31,218,30,218,29,71,31,43,31,137,31,235,31,3,31,3,30,212,31,85,31,215,31,118,31,228,31,149,31,98,31,211,31,159,31,214,31,182,31,78,31,165,31,185,31,110,31,150,31,28,31,210,31,166,31,209,31,215,31,148,31,125,31,247,31,254,31,95,31,84,31,250,31,250,30,250,29,16,31,16,30,240,31,192,31,192,30,102,31,102,30,196,31,217,31,245,31,172,31,38,31,77,31,240,31,30,31,204,31,186,31,179,31,138,31,201,31,242,31,242,30,103,31,251,31,26,31,202,31,128,31,128,30,114,31,114,30,135,31,240,31,224,31,16,31,72,31,165,31,72,31,241,31,178,31,86,31,52,31,194,31,194,30,225,31,77,31,156,31,94,31,42,31,42,30,55,31,160,31,3,31,207,31,91,31,91,30,91,29,73,31,101,31,181,31,2,31,2,30,2,29,183,31,204,31,92,31,92,30,92,29,2,31,121,31,121,30,214,31,249,31,129,31,115,31,62,31,34,31,18,31,141,31,130,31,130,30,118,31,214,31,82,31,82,30,119,31,80,31,80,30,15,31,15,30,15,29,15,28,41,31,41,30,202,31,10,31,10,30,156,31,20,31,141,31,215,31,68,31,15,31,4,31,4,30,134,31,110,31,20,31,102,31,251,31,251,30,73,31,182,31,182,30,182,29,207,31,86,31,137,31,156,31,220,31,219,31,89,31,152,31,152,30,175,31,5,31,210,31,210,30,82,31,163,31,39,31,219,31,37,31,155,31,245,31,33,31,33,30,33,29,64,31,196,31,248,31,3,31,167,31,229,31,87,31,87,30,57,31,74,31,223,31,173,31,193,31,125,31,164,31,65,31,73,31,4,31,97,31,13,31,231,31,231,30,231,29,234,31,75,31,100,31,168,31,111,31,242,31,241,31,241,30,241,29,152,31,242,31,90,31,90,30,55,31,200,31,55,31,122,31,122,30,122,29,65,31,65,30,111,31,111,30,41,31,5,31,196,31,196,30,97,31,19,31,34,31,142,31,142,30,142,29,142,28,189,31,120,31,190,31,198,31,198,30,198,29,88,31,185,31,185,30,8,31,8,30,14,31,209,31,176,31,77,31,252,31,255,31,255,30,181,31,169,31,175,31,12,31,8,31,143,31,95,31,11,31,65,31,65,30,65,29,64,31,56,31,37,31,32,31,114,31,144,31,105,31,105,30,234,31,36,31,36,30,51,31,204,31,204,30,175,31,175,30,175,29,68,31,67,31,151,31,93,31,158,31,158,30,229,31,184,31,184,30,131,31,212,31,152,31,152,30,198,31,164,31,107,31,150,31,12,31,6,31,6,30,6,29,6,28,141,31,4,31,112,31,63,31,70,31,240,31,152,31,132,31,184,31,165,31,172,31,66,31,4,31,118,31,118,30,77,31,40,31,199,31,142,31,226,31,173,31,15,31,163,31,10,31,10,30,202,31,240,31,118,31,227,31,202,31,53,31,84,31,124,31,124,30,38,31,59,31,202,31,202,30,202,29,144,31,248,31,170,31,196,31,33,31,252,31,160,31,160,30,1,31,1,30,253,31,253,30,233,31,233,30,79,31,79,30,47,31,215,31,63,31,159,31,239,31,146,31,146,30,48,31,102,31,106,31,106,30,255,31,82,31,71,31,131,31,195,31,195,30,10,31,30,31,110,31,98,31,137,31,150,31,48,31,179,31,182,31,182,30,65,31,65,31,43,31,108,31,94,31,174,31,144,31,194,31,8,31,196,31,9,31,9,30,78,31,71,31,79,31,200,31,28,31,195,31,195,30,19,31,19,30,152,31,178,31,178,30,177,31,220,31,213,31,150,31,150,30,227,31,244,31,140,31,140,30,95,31,209,31,246,31,246,30,70,31,196,31,196,30,196,29,73,31,73,30,237,31,139,31,139,30,232,31,131,31,213,31,155,31,155,30,155,31,219,31,149,31,149,30,210,31,233,31,158,31,218,31,176,31,176,30,176,29,176,28,27,31,35,31,243,31,89,31,178,31,233,31,216,31,162,31,162,30,192,31,78,31,99,31,101,31,41,31,61,31,42,31,200,31,231,31,101,31,79,31,79,30,81,31);

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
