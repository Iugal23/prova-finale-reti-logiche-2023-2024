-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_448 is
end project_tb_448;

architecture project_tb_arch_448 of project_tb_448 is
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

constant SCENARIO_LENGTH : integer := 811;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (150,0,0,0,129,0,103,0,24,0,0,0,243,0,59,0,102,0,116,0,233,0,235,0,62,0,78,0,20,0,63,0,150,0,55,0,78,0,61,0,0,0,142,0,177,0,13,0,143,0,226,0,203,0,221,0,17,0,133,0,99,0,14,0,57,0,195,0,39,0,68,0,39,0,131,0,0,0,64,0,218,0,22,0,210,0,107,0,196,0,131,0,233,0,218,0,175,0,0,0,0,0,57,0,27,0,88,0,96,0,5,0,255,0,26,0,32,0,185,0,167,0,0,0,0,0,252,0,167,0,26,0,59,0,24,0,141,0,115,0,231,0,206,0,7,0,216,0,197,0,166,0,107,0,139,0,88,0,37,0,210,0,85,0,0,0,0,0,110,0,172,0,0,0,160,0,170,0,0,0,129,0,0,0,23,0,0,0,173,0,67,0,101,0,63,0,69,0,166,0,0,0,57,0,0,0,48,0,0,0,11,0,0,0,5,0,179,0,242,0,13,0,82,0,0,0,53,0,68,0,0,0,188,0,220,0,0,0,185,0,95,0,249,0,119,0,0,0,120,0,79,0,212,0,0,0,0,0,162,0,231,0,23,0,15,0,65,0,0,0,0,0,209,0,0,0,0,0,168,0,252,0,23,0,140,0,0,0,65,0,186,0,252,0,14,0,177,0,191,0,57,0,113,0,63,0,0,0,233,0,149,0,209,0,0,0,0,0,133,0,230,0,50,0,36,0,69,0,0,0,13,0,215,0,231,0,167,0,222,0,34,0,75,0,0,0,242,0,176,0,0,0,183,0,245,0,0,0,71,0,86,0,0,0,44,0,21,0,0,0,45,0,234,0,111,0,0,0,6,0,169,0,107,0,184,0,0,0,67,0,141,0,171,0,1,0,25,0,243,0,141,0,169,0,124,0,0,0,86,0,0,0,26,0,133,0,0,0,3,0,90,0,231,0,38,0,110,0,197,0,184,0,223,0,0,0,177,0,149,0,136,0,0,0,0,0,0,0,0,0,94,0,6,0,224,0,97,0,48,0,106,0,0,0,16,0,0,0,102,0,216,0,32,0,206,0,166,0,0,0,3,0,165,0,181,0,169,0,37,0,208,0,129,0,244,0,220,0,254,0,210,0,30,0,136,0,227,0,181,0,0,0,239,0,199,0,0,0,219,0,135,0,0,0,0,0,161,0,117,0,246,0,4,0,0,0,129,0,162,0,42,0,0,0,145,0,70,0,35,0,116,0,218,0,184,0,82,0,73,0,90,0,216,0,64,0,85,0,0,0,208,0,122,0,211,0,213,0,203,0,236,0,80,0,106,0,33,0,0,0,0,0,0,0,0,0,2,0,144,0,155,0,185,0,0,0,0,0,173,0,49,0,26,0,132,0,124,0,247,0,108,0,35,0,130,0,66,0,0,0,37,0,197,0,235,0,16,0,165,0,137,0,239,0,221,0,52,0,102,0,189,0,0,0,42,0,253,0,217,0,81,0,255,0,195,0,89,0,6,0,45,0,219,0,0,0,1,0,148,0,0,0,121,0,255,0,6,0,0,0,136,0,255,0,178,0,0,0,123,0,0,0,106,0,194,0,194,0,71,0,41,0,169,0,237,0,59,0,133,0,197,0,187,0,139,0,0,0,200,0,73,0,55,0,0,0,110,0,217,0,94,0,15,0,97,0,78,0,171,0,91,0,209,0,95,0,158,0,0,0,111,0,73,0,0,0,77,0,6,0,0,0,251,0,144,0,22,0,217,0,139,0,0,0,48,0,208,0,0,0,185,0,0,0,107,0,125,0,29,0,0,0,235,0,0,0,36,0,0,0,21,0,161,0,247,0,84,0,155,0,0,0,17,0,114,0,8,0,127,0,233,0,0,0,0,0,90,0,142,0,217,0,67,0,0,0,85,0,85,0,49,0,0,0,74,0,199,0,21,0,1,0,94,0,64,0,0,0,19,0,0,0,171,0,238,0,45,0,47,0,225,0,220,0,123,0,1,0,120,0,68,0,132,0,34,0,29,0,45,0,31,0,2,0,0,0,112,0,83,0,0,0,17,0,52,0,69,0,194,0,0,0,138,0,198,0,51,0,70,0,126,0,91,0,96,0,29,0,58,0,0,0,240,0,205,0,70,0,245,0,102,0,198,0,122,0,231,0,59,0,112,0,144,0,101,0,76,0,146,0,129,0,122,0,120,0,117,0,123,0,108,0,15,0,182,0,35,0,75,0,241,0,155,0,97,0,24,0,6,0,154,0,79,0,226,0,203,0,19,0,138,0,215,0,65,0,6,0,109,0,47,0,232,0,166,0,167,0,0,0,136,0,151,0,0,0,0,0,214,0,180,0,90,0,0,0,233,0,175,0,4,0,0,0,43,0,0,0,234,0,0,0,152,0,214,0,69,0,39,0,142,0,12,0,211,0,20,0,0,0,40,0,0,0,222,0,77,0,205,0,203,0,0,0,196,0,219,0,0,0,223,0,233,0,131,0,0,0,21,0,0,0,0,0,163,0,156,0,103,0,67,0,7,0,121,0,216,0,106,0,237,0,115,0,85,0,142,0,142,0,238,0,0,0,0,0,110,0,220,0,0,0,159,0,176,0,52,0,0,0,161,0,246,0,156,0,0,0,0,0,166,0,0,0,1,0,205,0,27,0,22,0,30,0,155,0,95,0,0,0,133,0,195,0,0,0,58,0,100,0,126,0,204,0,164,0,49,0,80,0,9,0,179,0,175,0,0,0,0,0,160,0,194,0,80,0,0,0,164,0,0,0,138,0,29,0,237,0,0,0,0,0,127,0,46,0,150,0,0,0,53,0,251,0,156,0,190,0,0,0,129,0,0,0,228,0,201,0,66,0,62,0,118,0,0,0,120,0,204,0,235,0,0,0,42,0,223,0,216,0,134,0,101,0,27,0,16,0,13,0,212,0,223,0,0,0,156,0,0,0,0,0,209,0,139,0,137,0,22,0,127,0,39,0,114,0,55,0,218,0,78,0,245,0,24,0,254,0,205,0,30,0,140,0,88,0,188,0,0,0,129,0,118,0,98,0,78,0,142,0,248,0,243,0,0,0,80,0,171,0,155,0,98,0,135,0,73,0,16,0,85,0,225,0,18,0,211,0,0,0,200,0,2,0,241,0,103,0,187,0,35,0,160,0,72,0,175,0,66,0,82,0,107,0,0,0,109,0,176,0,118,0,72,0,7,0,159,0,138,0,0,0,70,0,12,0,55,0,67,0,0,0,147,0,206,0,85,0,80,0,34,0,21,0,237,0,4,0,157,0,70,0,51,0,93,0,145,0,0,0,0,0,221,0,0,0,120,0,0,0,83,0,37,0,238,0,69,0,42,0,84,0,109,0,147,0,168,0,255,0,85,0,157,0,129,0,166,0,92,0,0,0,0,0,0,0,0,0,48,0,164,0,92,0,183,0,243,0,47,0,48,0,160,0,22,0,89,0,213,0,182,0,61,0,0,0,209,0,211,0,22,0,0,0,173,0,18,0,219,0,67,0,142,0,134,0,0,0,60,0,102,0,83,0,0,0,0,0,87,0,101,0,16,0,205,0,0,0,194,0,0,0,0,0,0,0,187,0,144,0,32,0,217,0,0,0,218,0,218,0,74,0,129,0,0,0,191,0,140,0,0,0);
signal scenario_full  : scenario_type := (150,31,150,30,129,31,103,31,24,31,24,30,243,31,59,31,102,31,116,31,233,31,235,31,62,31,78,31,20,31,63,31,150,31,55,31,78,31,61,31,61,30,142,31,177,31,13,31,143,31,226,31,203,31,221,31,17,31,133,31,99,31,14,31,57,31,195,31,39,31,68,31,39,31,131,31,131,30,64,31,218,31,22,31,210,31,107,31,196,31,131,31,233,31,218,31,175,31,175,30,175,29,57,31,27,31,88,31,96,31,5,31,255,31,26,31,32,31,185,31,167,31,167,30,167,29,252,31,167,31,26,31,59,31,24,31,141,31,115,31,231,31,206,31,7,31,216,31,197,31,166,31,107,31,139,31,88,31,37,31,210,31,85,31,85,30,85,29,110,31,172,31,172,30,160,31,170,31,170,30,129,31,129,30,23,31,23,30,173,31,67,31,101,31,63,31,69,31,166,31,166,30,57,31,57,30,48,31,48,30,11,31,11,30,5,31,179,31,242,31,13,31,82,31,82,30,53,31,68,31,68,30,188,31,220,31,220,30,185,31,95,31,249,31,119,31,119,30,120,31,79,31,212,31,212,30,212,29,162,31,231,31,23,31,15,31,65,31,65,30,65,29,209,31,209,30,209,29,168,31,252,31,23,31,140,31,140,30,65,31,186,31,252,31,14,31,177,31,191,31,57,31,113,31,63,31,63,30,233,31,149,31,209,31,209,30,209,29,133,31,230,31,50,31,36,31,69,31,69,30,13,31,215,31,231,31,167,31,222,31,34,31,75,31,75,30,242,31,176,31,176,30,183,31,245,31,245,30,71,31,86,31,86,30,44,31,21,31,21,30,45,31,234,31,111,31,111,30,6,31,169,31,107,31,184,31,184,30,67,31,141,31,171,31,1,31,25,31,243,31,141,31,169,31,124,31,124,30,86,31,86,30,26,31,133,31,133,30,3,31,90,31,231,31,38,31,110,31,197,31,184,31,223,31,223,30,177,31,149,31,136,31,136,30,136,29,136,28,136,27,94,31,6,31,224,31,97,31,48,31,106,31,106,30,16,31,16,30,102,31,216,31,32,31,206,31,166,31,166,30,3,31,165,31,181,31,169,31,37,31,208,31,129,31,244,31,220,31,254,31,210,31,30,31,136,31,227,31,181,31,181,30,239,31,199,31,199,30,219,31,135,31,135,30,135,29,161,31,117,31,246,31,4,31,4,30,129,31,162,31,42,31,42,30,145,31,70,31,35,31,116,31,218,31,184,31,82,31,73,31,90,31,216,31,64,31,85,31,85,30,208,31,122,31,211,31,213,31,203,31,236,31,80,31,106,31,33,31,33,30,33,29,33,28,33,27,2,31,144,31,155,31,185,31,185,30,185,29,173,31,49,31,26,31,132,31,124,31,247,31,108,31,35,31,130,31,66,31,66,30,37,31,197,31,235,31,16,31,165,31,137,31,239,31,221,31,52,31,102,31,189,31,189,30,42,31,253,31,217,31,81,31,255,31,195,31,89,31,6,31,45,31,219,31,219,30,1,31,148,31,148,30,121,31,255,31,6,31,6,30,136,31,255,31,178,31,178,30,123,31,123,30,106,31,194,31,194,31,71,31,41,31,169,31,237,31,59,31,133,31,197,31,187,31,139,31,139,30,200,31,73,31,55,31,55,30,110,31,217,31,94,31,15,31,97,31,78,31,171,31,91,31,209,31,95,31,158,31,158,30,111,31,73,31,73,30,77,31,6,31,6,30,251,31,144,31,22,31,217,31,139,31,139,30,48,31,208,31,208,30,185,31,185,30,107,31,125,31,29,31,29,30,235,31,235,30,36,31,36,30,21,31,161,31,247,31,84,31,155,31,155,30,17,31,114,31,8,31,127,31,233,31,233,30,233,29,90,31,142,31,217,31,67,31,67,30,85,31,85,31,49,31,49,30,74,31,199,31,21,31,1,31,94,31,64,31,64,30,19,31,19,30,171,31,238,31,45,31,47,31,225,31,220,31,123,31,1,31,120,31,68,31,132,31,34,31,29,31,45,31,31,31,2,31,2,30,112,31,83,31,83,30,17,31,52,31,69,31,194,31,194,30,138,31,198,31,51,31,70,31,126,31,91,31,96,31,29,31,58,31,58,30,240,31,205,31,70,31,245,31,102,31,198,31,122,31,231,31,59,31,112,31,144,31,101,31,76,31,146,31,129,31,122,31,120,31,117,31,123,31,108,31,15,31,182,31,35,31,75,31,241,31,155,31,97,31,24,31,6,31,154,31,79,31,226,31,203,31,19,31,138,31,215,31,65,31,6,31,109,31,47,31,232,31,166,31,167,31,167,30,136,31,151,31,151,30,151,29,214,31,180,31,90,31,90,30,233,31,175,31,4,31,4,30,43,31,43,30,234,31,234,30,152,31,214,31,69,31,39,31,142,31,12,31,211,31,20,31,20,30,40,31,40,30,222,31,77,31,205,31,203,31,203,30,196,31,219,31,219,30,223,31,233,31,131,31,131,30,21,31,21,30,21,29,163,31,156,31,103,31,67,31,7,31,121,31,216,31,106,31,237,31,115,31,85,31,142,31,142,31,238,31,238,30,238,29,110,31,220,31,220,30,159,31,176,31,52,31,52,30,161,31,246,31,156,31,156,30,156,29,166,31,166,30,1,31,205,31,27,31,22,31,30,31,155,31,95,31,95,30,133,31,195,31,195,30,58,31,100,31,126,31,204,31,164,31,49,31,80,31,9,31,179,31,175,31,175,30,175,29,160,31,194,31,80,31,80,30,164,31,164,30,138,31,29,31,237,31,237,30,237,29,127,31,46,31,150,31,150,30,53,31,251,31,156,31,190,31,190,30,129,31,129,30,228,31,201,31,66,31,62,31,118,31,118,30,120,31,204,31,235,31,235,30,42,31,223,31,216,31,134,31,101,31,27,31,16,31,13,31,212,31,223,31,223,30,156,31,156,30,156,29,209,31,139,31,137,31,22,31,127,31,39,31,114,31,55,31,218,31,78,31,245,31,24,31,254,31,205,31,30,31,140,31,88,31,188,31,188,30,129,31,118,31,98,31,78,31,142,31,248,31,243,31,243,30,80,31,171,31,155,31,98,31,135,31,73,31,16,31,85,31,225,31,18,31,211,31,211,30,200,31,2,31,241,31,103,31,187,31,35,31,160,31,72,31,175,31,66,31,82,31,107,31,107,30,109,31,176,31,118,31,72,31,7,31,159,31,138,31,138,30,70,31,12,31,55,31,67,31,67,30,147,31,206,31,85,31,80,31,34,31,21,31,237,31,4,31,157,31,70,31,51,31,93,31,145,31,145,30,145,29,221,31,221,30,120,31,120,30,83,31,37,31,238,31,69,31,42,31,84,31,109,31,147,31,168,31,255,31,85,31,157,31,129,31,166,31,92,31,92,30,92,29,92,28,92,27,48,31,164,31,92,31,183,31,243,31,47,31,48,31,160,31,22,31,89,31,213,31,182,31,61,31,61,30,209,31,211,31,22,31,22,30,173,31,18,31,219,31,67,31,142,31,134,31,134,30,60,31,102,31,83,31,83,30,83,29,87,31,101,31,16,31,205,31,205,30,194,31,194,30,194,29,194,28,187,31,144,31,32,31,217,31,217,30,218,31,218,31,74,31,129,31,129,30,191,31,140,31,140,30);

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
