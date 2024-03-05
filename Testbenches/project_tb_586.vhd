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

constant SCENARIO_LENGTH : integer := 426;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (211,0,51,0,26,0,201,0,159,0,220,0,0,0,227,0,253,0,216,0,100,0,0,0,0,0,13,0,0,0,0,0,170,0,197,0,113,0,80,0,33,0,150,0,251,0,0,0,146,0,243,0,133,0,120,0,0,0,44,0,168,0,158,0,118,0,252,0,16,0,113,0,0,0,223,0,34,0,39,0,164,0,227,0,185,0,153,0,234,0,142,0,16,0,177,0,157,0,137,0,149,0,101,0,0,0,144,0,82,0,0,0,0,0,117,0,174,0,209,0,43,0,184,0,35,0,151,0,0,0,0,0,0,0,137,0,31,0,81,0,125,0,76,0,254,0,137,0,78,0,131,0,98,0,0,0,63,0,78,0,21,0,201,0,0,0,220,0,152,0,87,0,208,0,0,0,34,0,145,0,125,0,173,0,68,0,146,0,142,0,0,0,0,0,38,0,193,0,139,0,103,0,117,0,188,0,155,0,143,0,145,0,229,0,113,0,167,0,38,0,0,0,37,0,67,0,116,0,0,0,0,0,0,0,31,0,249,0,73,0,0,0,25,0,144,0,196,0,75,0,127,0,0,0,0,0,216,0,42,0,0,0,170,0,227,0,160,0,235,0,128,0,0,0,0,0,235,0,75,0,97,0,0,0,150,0,154,0,180,0,129,0,0,0,0,0,149,0,35,0,49,0,42,0,47,0,82,0,0,0,67,0,214,0,93,0,94,0,198,0,195,0,70,0,98,0,204,0,0,0,102,0,19,0,195,0,35,0,0,0,230,0,4,0,186,0,6,0,184,0,159,0,41,0,207,0,50,0,46,0,0,0,46,0,57,0,24,0,160,0,214,0,0,0,212,0,121,0,116,0,132,0,208,0,0,0,106,0,184,0,0,0,0,0,0,0,238,0,101,0,102,0,154,0,117,0,18,0,228,0,56,0,230,0,0,0,174,0,118,0,203,0,107,0,0,0,0,0,88,0,0,0,3,0,33,0,166,0,73,0,126,0,228,0,1,0,0,0,200,0,75,0,76,0,62,0,0,0,211,0,10,0,160,0,97,0,161,0,233,0,14,0,0,0,141,0,244,0,129,0,190,0,153,0,193,0,50,0,58,0,182,0,84,0,0,0,207,0,70,0,150,0,0,0,193,0,74,0,0,0,198,0,41,0,157,0,198,0,39,0,0,0,169,0,0,0,113,0,112,0,207,0,120,0,48,0,0,0,0,0,72,0,132,0,19,0,235,0,0,0,121,0,93,0,0,0,34,0,0,0,209,0,55,0,73,0,250,0,134,0,130,0,215,0,29,0,139,0,127,0,180,0,186,0,196,0,220,0,177,0,124,0,0,0,214,0,0,0,227,0,89,0,0,0,186,0,202,0,17,0,0,0,176,0,0,0,139,0,30,0,0,0,110,0,108,0,0,0,232,0,140,0,164,0,0,0,0,0,198,0,0,0,57,0,218,0,224,0,157,0,78,0,136,0,12,0,109,0,52,0,0,0,57,0,95,0,197,0,190,0,233,0,230,0,113,0,248,0,0,0,0,0,212,0,2,0,31,0,0,0,151,0,245,0,133,0,0,0,221,0,79,0,62,0,0,0,0,0,111,0,249,0,83,0,109,0,24,0,0,0,248,0,0,0,97,0,155,0,22,0,124,0,143,0,47,0,1,0,98,0,115,0,168,0,62,0,146,0,0,0,246,0,220,0,167,0,0,0,199,0,38,0,31,0,42,0,242,0,158,0,96,0,0,0,247,0,166,0,220,0,0,0,59,0,199,0,184,0,52,0,168,0,53,0,48,0,187,0,82,0,212,0,183,0,191,0,50,0,38,0,252,0,181,0,189,0,237,0,198,0,46,0,68,0,98,0,173,0,131,0,0,0,0,0,82,0,0,0,49,0,76,0,124,0,71,0,88,0,16,0,85,0);
signal scenario_full  : scenario_type := (211,31,51,31,26,31,201,31,159,31,220,31,220,30,227,31,253,31,216,31,100,31,100,30,100,29,13,31,13,30,13,29,170,31,197,31,113,31,80,31,33,31,150,31,251,31,251,30,146,31,243,31,133,31,120,31,120,30,44,31,168,31,158,31,118,31,252,31,16,31,113,31,113,30,223,31,34,31,39,31,164,31,227,31,185,31,153,31,234,31,142,31,16,31,177,31,157,31,137,31,149,31,101,31,101,30,144,31,82,31,82,30,82,29,117,31,174,31,209,31,43,31,184,31,35,31,151,31,151,30,151,29,151,28,137,31,31,31,81,31,125,31,76,31,254,31,137,31,78,31,131,31,98,31,98,30,63,31,78,31,21,31,201,31,201,30,220,31,152,31,87,31,208,31,208,30,34,31,145,31,125,31,173,31,68,31,146,31,142,31,142,30,142,29,38,31,193,31,139,31,103,31,117,31,188,31,155,31,143,31,145,31,229,31,113,31,167,31,38,31,38,30,37,31,67,31,116,31,116,30,116,29,116,28,31,31,249,31,73,31,73,30,25,31,144,31,196,31,75,31,127,31,127,30,127,29,216,31,42,31,42,30,170,31,227,31,160,31,235,31,128,31,128,30,128,29,235,31,75,31,97,31,97,30,150,31,154,31,180,31,129,31,129,30,129,29,149,31,35,31,49,31,42,31,47,31,82,31,82,30,67,31,214,31,93,31,94,31,198,31,195,31,70,31,98,31,204,31,204,30,102,31,19,31,195,31,35,31,35,30,230,31,4,31,186,31,6,31,184,31,159,31,41,31,207,31,50,31,46,31,46,30,46,31,57,31,24,31,160,31,214,31,214,30,212,31,121,31,116,31,132,31,208,31,208,30,106,31,184,31,184,30,184,29,184,28,238,31,101,31,102,31,154,31,117,31,18,31,228,31,56,31,230,31,230,30,174,31,118,31,203,31,107,31,107,30,107,29,88,31,88,30,3,31,33,31,166,31,73,31,126,31,228,31,1,31,1,30,200,31,75,31,76,31,62,31,62,30,211,31,10,31,160,31,97,31,161,31,233,31,14,31,14,30,141,31,244,31,129,31,190,31,153,31,193,31,50,31,58,31,182,31,84,31,84,30,207,31,70,31,150,31,150,30,193,31,74,31,74,30,198,31,41,31,157,31,198,31,39,31,39,30,169,31,169,30,113,31,112,31,207,31,120,31,48,31,48,30,48,29,72,31,132,31,19,31,235,31,235,30,121,31,93,31,93,30,34,31,34,30,209,31,55,31,73,31,250,31,134,31,130,31,215,31,29,31,139,31,127,31,180,31,186,31,196,31,220,31,177,31,124,31,124,30,214,31,214,30,227,31,89,31,89,30,186,31,202,31,17,31,17,30,176,31,176,30,139,31,30,31,30,30,110,31,108,31,108,30,232,31,140,31,164,31,164,30,164,29,198,31,198,30,57,31,218,31,224,31,157,31,78,31,136,31,12,31,109,31,52,31,52,30,57,31,95,31,197,31,190,31,233,31,230,31,113,31,248,31,248,30,248,29,212,31,2,31,31,31,31,30,151,31,245,31,133,31,133,30,221,31,79,31,62,31,62,30,62,29,111,31,249,31,83,31,109,31,24,31,24,30,248,31,248,30,97,31,155,31,22,31,124,31,143,31,47,31,1,31,98,31,115,31,168,31,62,31,146,31,146,30,246,31,220,31,167,31,167,30,199,31,38,31,31,31,42,31,242,31,158,31,96,31,96,30,247,31,166,31,220,31,220,30,59,31,199,31,184,31,52,31,168,31,53,31,48,31,187,31,82,31,212,31,183,31,191,31,50,31,38,31,252,31,181,31,189,31,237,31,198,31,46,31,68,31,98,31,173,31,131,31,131,30,131,29,82,31,82,30,49,31,76,31,124,31,71,31,88,31,16,31,85,31);

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
