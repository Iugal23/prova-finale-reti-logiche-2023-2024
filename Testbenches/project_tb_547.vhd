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

constant SCENARIO_LENGTH : integer := 831;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (118,0,57,0,0,0,0,0,179,0,63,0,20,0,103,0,0,0,224,0,163,0,0,0,179,0,226,0,191,0,139,0,40,0,89,0,79,0,251,0,37,0,85,0,243,0,0,0,37,0,212,0,62,0,73,0,0,0,2,0,184,0,76,0,215,0,153,0,246,0,108,0,190,0,111,0,4,0,226,0,0,0,110,0,0,0,142,0,98,0,91,0,28,0,0,0,182,0,0,0,144,0,70,0,54,0,0,0,168,0,132,0,124,0,195,0,137,0,209,0,135,0,23,0,173,0,0,0,0,0,203,0,142,0,97,0,0,0,139,0,189,0,0,0,5,0,159,0,177,0,0,0,0,0,208,0,219,0,172,0,0,0,52,0,173,0,116,0,115,0,199,0,167,0,180,0,0,0,247,0,19,0,203,0,11,0,212,0,141,0,48,0,70,0,55,0,0,0,0,0,35,0,0,0,163,0,0,0,123,0,194,0,131,0,46,0,97,0,22,0,31,0,106,0,0,0,0,0,195,0,172,0,115,0,249,0,23,0,132,0,83,0,0,0,194,0,0,0,135,0,88,0,98,0,2,0,172,0,0,0,213,0,0,0,156,0,0,0,107,0,63,0,20,0,0,0,210,0,229,0,183,0,70,0,0,0,0,0,144,0,61,0,87,0,228,0,163,0,0,0,8,0,246,0,0,0,45,0,147,0,171,0,115,0,0,0,77,0,162,0,116,0,191,0,0,0,8,0,155,0,0,0,238,0,196,0,155,0,0,0,52,0,118,0,8,0,163,0,0,0,0,0,0,0,101,0,17,0,121,0,160,0,12,0,110,0,0,0,122,0,244,0,20,0,192,0,85,0,214,0,130,0,59,0,0,0,206,0,182,0,109,0,116,0,14,0,118,0,148,0,57,0,0,0,83,0,8,0,141,0,59,0,224,0,0,0,189,0,108,0,3,0,0,0,218,0,250,0,171,0,55,0,86,0,71,0,109,0,0,0,85,0,254,0,0,0,0,0,111,0,65,0,25,0,41,0,145,0,0,0,8,0,196,0,94,0,122,0,212,0,210,0,0,0,250,0,204,0,23,0,0,0,30,0,152,0,123,0,0,0,60,0,0,0,247,0,114,0,54,0,0,0,165,0,133,0,0,0,76,0,224,0,129,0,0,0,147,0,20,0,131,0,101,0,36,0,88,0,230,0,167,0,0,0,72,0,132,0,22,0,51,0,250,0,50,0,13,0,0,0,159,0,0,0,194,0,0,0,0,0,70,0,208,0,199,0,233,0,61,0,228,0,114,0,0,0,0,0,114,0,104,0,123,0,38,0,238,0,0,0,124,0,0,0,174,0,215,0,17,0,223,0,204,0,160,0,0,0,199,0,197,0,93,0,55,0,134,0,87,0,187,0,0,0,93,0,201,0,199,0,80,0,47,0,154,0,110,0,0,0,213,0,90,0,31,0,52,0,86,0,0,0,201,0,219,0,0,0,14,0,77,0,56,0,36,0,43,0,85,0,0,0,76,0,232,0,72,0,232,0,123,0,0,0,206,0,243,0,78,0,0,0,240,0,90,0,134,0,13,0,196,0,0,0,20,0,42,0,43,0,70,0,0,0,239,0,137,0,0,0,96,0,157,0,0,0,142,0,215,0,116,0,0,0,26,0,173,0,43,0,41,0,63,0,87,0,212,0,222,0,41,0,81,0,0,0,24,0,0,0,226,0,0,0,0,0,0,0,0,0,0,0,156,0,185,0,188,0,57,0,30,0,9,0,87,0,104,0,255,0,110,0,58,0,82,0,142,0,17,0,205,0,27,0,186,0,0,0,0,0,15,0,180,0,151,0,76,0,215,0,233,0,205,0,36,0,112,0,3,0,42,0,251,0,56,0,0,0,99,0,129,0,0,0,138,0,0,0,192,0,223,0,78,0,92,0,160,0,218,0,246,0,7,0,39,0,49,0,59,0,150,0,0,0,173,0,230,0,192,0,83,0,156,0,246,0,0,0,170,0,137,0,0,0,0,0,14,0,0,0,0,0,224,0,55,0,249,0,70,0,0,0,0,0,47,0,145,0,0,0,13,0,0,0,95,0,217,0,238,0,9,0,175,0,32,0,48,0,0,0,213,0,67,0,193,0,228,0,0,0,56,0,0,0,39,0,3,0,225,0,236,0,72,0,69,0,53,0,0,0,137,0,139,0,245,0,137,0,4,0,191,0,0,0,102,0,9,0,41,0,0,0,238,0,4,0,42,0,80,0,67,0,95,0,0,0,0,0,226,0,74,0,51,0,33,0,11,0,0,0,165,0,0,0,103,0,156,0,0,0,116,0,147,0,133,0,221,0,0,0,39,0,255,0,62,0,103,0,137,0,104,0,184,0,0,0,160,0,228,0,45,0,0,0,0,0,46,0,58,0,33,0,54,0,197,0,28,0,98,0,183,0,145,0,251,0,0,0,0,0,169,0,112,0,0,0,0,0,0,0,52,0,56,0,0,0,25,0,138,0,230,0,0,0,112,0,98,0,179,0,114,0,188,0,128,0,86,0,0,0,0,0,201,0,0,0,69,0,213,0,50,0,109,0,116,0,65,0,0,0,0,0,0,0,150,0,41,0,154,0,0,0,214,0,26,0,221,0,16,0,132,0,192,0,74,0,192,0,191,0,148,0,63,0,0,0,143,0,162,0,215,0,56,0,81,0,248,0,73,0,111,0,0,0,138,0,205,0,110,0,0,0,53,0,200,0,218,0,127,0,0,0,156,0,147,0,255,0,244,0,6,0,225,0,150,0,0,0,42,0,105,0,20,0,190,0,51,0,169,0,0,0,0,0,52,0,73,0,83,0,0,0,0,0,0,0,112,0,3,0,149,0,198,0,0,0,0,0,40,0,173,0,255,0,140,0,54,0,0,0,199,0,216,0,164,0,121,0,138,0,6,0,142,0,47,0,0,0,0,0,233,0,54,0,139,0,147,0,41,0,125,0,44,0,28,0,6,0,0,0,180,0,72,0,111,0,246,0,81,0,54,0,66,0,51,0,12,0,115,0,255,0,206,0,0,0,63,0,37,0,208,0,33,0,0,0,249,0,45,0,122,0,240,0,228,0,207,0,29,0,230,0,0,0,139,0,99,0,114,0,191,0,144,0,63,0,133,0,129,0,4,0,172,0,35,0,119,0,0,0,104,0,175,0,34,0,248,0,167,0,0,0,232,0,0,0,0,0,128,0,20,0,138,0,114,0,127,0,196,0,194,0,0,0,189,0,76,0,0,0,253,0,53,0,0,0,226,0,71,0,96,0,126,0,188,0,106,0,33,0,0,0,0,0,145,0,0,0,0,0,92,0,11,0,0,0,43,0,45,0,158,0,163,0,193,0,81,0,30,0,112,0,0,0,0,0,58,0,170,0,25,0,120,0,96,0,26,0,9,0,207,0,148,0,168,0,0,0,86,0,167,0,221,0,0,0,0,0,0,0,96,0,0,0,58,0,31,0,251,0,0,0,0,0,0,0,199,0,132,0,117,0,99,0,187,0,186,0,194,0,140,0,118,0,0,0,202,0,6,0,28,0,0,0,181,0,140,0,223,0,58,0,0,0,152,0,0,0,70,0,0,0,17,0,240,0,196,0,0,0,85,0,40,0,255,0,78,0,37,0,69,0,42,0,215,0,73,0,118,0,0,0,0,0,0,0,189,0,111,0,152,0,0,0,204,0,171,0,85,0,117,0,65,0,211,0,0,0,187,0,130,0);
signal scenario_full  : scenario_type := (118,31,57,31,57,30,57,29,179,31,63,31,20,31,103,31,103,30,224,31,163,31,163,30,179,31,226,31,191,31,139,31,40,31,89,31,79,31,251,31,37,31,85,31,243,31,243,30,37,31,212,31,62,31,73,31,73,30,2,31,184,31,76,31,215,31,153,31,246,31,108,31,190,31,111,31,4,31,226,31,226,30,110,31,110,30,142,31,98,31,91,31,28,31,28,30,182,31,182,30,144,31,70,31,54,31,54,30,168,31,132,31,124,31,195,31,137,31,209,31,135,31,23,31,173,31,173,30,173,29,203,31,142,31,97,31,97,30,139,31,189,31,189,30,5,31,159,31,177,31,177,30,177,29,208,31,219,31,172,31,172,30,52,31,173,31,116,31,115,31,199,31,167,31,180,31,180,30,247,31,19,31,203,31,11,31,212,31,141,31,48,31,70,31,55,31,55,30,55,29,35,31,35,30,163,31,163,30,123,31,194,31,131,31,46,31,97,31,22,31,31,31,106,31,106,30,106,29,195,31,172,31,115,31,249,31,23,31,132,31,83,31,83,30,194,31,194,30,135,31,88,31,98,31,2,31,172,31,172,30,213,31,213,30,156,31,156,30,107,31,63,31,20,31,20,30,210,31,229,31,183,31,70,31,70,30,70,29,144,31,61,31,87,31,228,31,163,31,163,30,8,31,246,31,246,30,45,31,147,31,171,31,115,31,115,30,77,31,162,31,116,31,191,31,191,30,8,31,155,31,155,30,238,31,196,31,155,31,155,30,52,31,118,31,8,31,163,31,163,30,163,29,163,28,101,31,17,31,121,31,160,31,12,31,110,31,110,30,122,31,244,31,20,31,192,31,85,31,214,31,130,31,59,31,59,30,206,31,182,31,109,31,116,31,14,31,118,31,148,31,57,31,57,30,83,31,8,31,141,31,59,31,224,31,224,30,189,31,108,31,3,31,3,30,218,31,250,31,171,31,55,31,86,31,71,31,109,31,109,30,85,31,254,31,254,30,254,29,111,31,65,31,25,31,41,31,145,31,145,30,8,31,196,31,94,31,122,31,212,31,210,31,210,30,250,31,204,31,23,31,23,30,30,31,152,31,123,31,123,30,60,31,60,30,247,31,114,31,54,31,54,30,165,31,133,31,133,30,76,31,224,31,129,31,129,30,147,31,20,31,131,31,101,31,36,31,88,31,230,31,167,31,167,30,72,31,132,31,22,31,51,31,250,31,50,31,13,31,13,30,159,31,159,30,194,31,194,30,194,29,70,31,208,31,199,31,233,31,61,31,228,31,114,31,114,30,114,29,114,31,104,31,123,31,38,31,238,31,238,30,124,31,124,30,174,31,215,31,17,31,223,31,204,31,160,31,160,30,199,31,197,31,93,31,55,31,134,31,87,31,187,31,187,30,93,31,201,31,199,31,80,31,47,31,154,31,110,31,110,30,213,31,90,31,31,31,52,31,86,31,86,30,201,31,219,31,219,30,14,31,77,31,56,31,36,31,43,31,85,31,85,30,76,31,232,31,72,31,232,31,123,31,123,30,206,31,243,31,78,31,78,30,240,31,90,31,134,31,13,31,196,31,196,30,20,31,42,31,43,31,70,31,70,30,239,31,137,31,137,30,96,31,157,31,157,30,142,31,215,31,116,31,116,30,26,31,173,31,43,31,41,31,63,31,87,31,212,31,222,31,41,31,81,31,81,30,24,31,24,30,226,31,226,30,226,29,226,28,226,27,226,26,156,31,185,31,188,31,57,31,30,31,9,31,87,31,104,31,255,31,110,31,58,31,82,31,142,31,17,31,205,31,27,31,186,31,186,30,186,29,15,31,180,31,151,31,76,31,215,31,233,31,205,31,36,31,112,31,3,31,42,31,251,31,56,31,56,30,99,31,129,31,129,30,138,31,138,30,192,31,223,31,78,31,92,31,160,31,218,31,246,31,7,31,39,31,49,31,59,31,150,31,150,30,173,31,230,31,192,31,83,31,156,31,246,31,246,30,170,31,137,31,137,30,137,29,14,31,14,30,14,29,224,31,55,31,249,31,70,31,70,30,70,29,47,31,145,31,145,30,13,31,13,30,95,31,217,31,238,31,9,31,175,31,32,31,48,31,48,30,213,31,67,31,193,31,228,31,228,30,56,31,56,30,39,31,3,31,225,31,236,31,72,31,69,31,53,31,53,30,137,31,139,31,245,31,137,31,4,31,191,31,191,30,102,31,9,31,41,31,41,30,238,31,4,31,42,31,80,31,67,31,95,31,95,30,95,29,226,31,74,31,51,31,33,31,11,31,11,30,165,31,165,30,103,31,156,31,156,30,116,31,147,31,133,31,221,31,221,30,39,31,255,31,62,31,103,31,137,31,104,31,184,31,184,30,160,31,228,31,45,31,45,30,45,29,46,31,58,31,33,31,54,31,197,31,28,31,98,31,183,31,145,31,251,31,251,30,251,29,169,31,112,31,112,30,112,29,112,28,52,31,56,31,56,30,25,31,138,31,230,31,230,30,112,31,98,31,179,31,114,31,188,31,128,31,86,31,86,30,86,29,201,31,201,30,69,31,213,31,50,31,109,31,116,31,65,31,65,30,65,29,65,28,150,31,41,31,154,31,154,30,214,31,26,31,221,31,16,31,132,31,192,31,74,31,192,31,191,31,148,31,63,31,63,30,143,31,162,31,215,31,56,31,81,31,248,31,73,31,111,31,111,30,138,31,205,31,110,31,110,30,53,31,200,31,218,31,127,31,127,30,156,31,147,31,255,31,244,31,6,31,225,31,150,31,150,30,42,31,105,31,20,31,190,31,51,31,169,31,169,30,169,29,52,31,73,31,83,31,83,30,83,29,83,28,112,31,3,31,149,31,198,31,198,30,198,29,40,31,173,31,255,31,140,31,54,31,54,30,199,31,216,31,164,31,121,31,138,31,6,31,142,31,47,31,47,30,47,29,233,31,54,31,139,31,147,31,41,31,125,31,44,31,28,31,6,31,6,30,180,31,72,31,111,31,246,31,81,31,54,31,66,31,51,31,12,31,115,31,255,31,206,31,206,30,63,31,37,31,208,31,33,31,33,30,249,31,45,31,122,31,240,31,228,31,207,31,29,31,230,31,230,30,139,31,99,31,114,31,191,31,144,31,63,31,133,31,129,31,4,31,172,31,35,31,119,31,119,30,104,31,175,31,34,31,248,31,167,31,167,30,232,31,232,30,232,29,128,31,20,31,138,31,114,31,127,31,196,31,194,31,194,30,189,31,76,31,76,30,253,31,53,31,53,30,226,31,71,31,96,31,126,31,188,31,106,31,33,31,33,30,33,29,145,31,145,30,145,29,92,31,11,31,11,30,43,31,45,31,158,31,163,31,193,31,81,31,30,31,112,31,112,30,112,29,58,31,170,31,25,31,120,31,96,31,26,31,9,31,207,31,148,31,168,31,168,30,86,31,167,31,221,31,221,30,221,29,221,28,96,31,96,30,58,31,31,31,251,31,251,30,251,29,251,28,199,31,132,31,117,31,99,31,187,31,186,31,194,31,140,31,118,31,118,30,202,31,6,31,28,31,28,30,181,31,140,31,223,31,58,31,58,30,152,31,152,30,70,31,70,30,17,31,240,31,196,31,196,30,85,31,40,31,255,31,78,31,37,31,69,31,42,31,215,31,73,31,118,31,118,30,118,29,118,28,189,31,111,31,152,31,152,30,204,31,171,31,85,31,117,31,65,31,211,31,211,30,187,31,130,31);

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
