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

constant SCENARIO_LENGTH : integer := 214;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (44,0,112,0,226,0,0,0,247,0,0,0,217,0,154,0,118,0,29,0,100,0,165,0,0,0,212,0,139,0,156,0,162,0,243,0,249,0,0,0,0,0,61,0,0,0,1,0,125,0,199,0,65,0,54,0,111,0,0,0,94,0,172,0,39,0,181,0,172,0,89,0,98,0,88,0,0,0,27,0,70,0,221,0,0,0,236,0,158,0,0,0,141,0,109,0,132,0,165,0,179,0,228,0,0,0,198,0,17,0,186,0,231,0,47,0,31,0,213,0,166,0,239,0,246,0,82,0,63,0,50,0,33,0,123,0,0,0,245,0,120,0,237,0,78,0,89,0,63,0,43,0,166,0,0,0,205,0,154,0,212,0,205,0,95,0,231,0,21,0,111,0,52,0,251,0,164,0,135,0,200,0,144,0,222,0,56,0,206,0,137,0,0,0,215,0,23,0,24,0,76,0,30,0,62,0,132,0,34,0,0,0,140,0,42,0,211,0,171,0,43,0,0,0,220,0,76,0,77,0,59,0,0,0,212,0,67,0,218,0,47,0,155,0,121,0,130,0,15,0,0,0,0,0,27,0,198,0,41,0,102,0,0,0,0,0,0,0,208,0,0,0,59,0,0,0,0,0,0,0,62,0,13,0,184,0,0,0,132,0,77,0,98,0,0,0,0,0,174,0,47,0,0,0,167,0,96,0,208,0,114,0,0,0,182,0,226,0,36,0,12,0,193,0,126,0,246,0,158,0,0,0,197,0,181,0,1,0,144,0,7,0,218,0,233,0,185,0,0,0,97,0,76,0,235,0,172,0,250,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,243,0,0,0,217,0,68,0,25,0,247,0,104,0,217,0,0,0,110,0,82,0,146,0,0,0,240,0,38,0,0,0,68,0,50,0,0,0,64,0,117,0,70,0,202,0,0,0,0,0,0,0,102,0);
signal scenario_full  : scenario_type := (44,31,112,31,226,31,226,30,247,31,247,30,217,31,154,31,118,31,29,31,100,31,165,31,165,30,212,31,139,31,156,31,162,31,243,31,249,31,249,30,249,29,61,31,61,30,1,31,125,31,199,31,65,31,54,31,111,31,111,30,94,31,172,31,39,31,181,31,172,31,89,31,98,31,88,31,88,30,27,31,70,31,221,31,221,30,236,31,158,31,158,30,141,31,109,31,132,31,165,31,179,31,228,31,228,30,198,31,17,31,186,31,231,31,47,31,31,31,213,31,166,31,239,31,246,31,82,31,63,31,50,31,33,31,123,31,123,30,245,31,120,31,237,31,78,31,89,31,63,31,43,31,166,31,166,30,205,31,154,31,212,31,205,31,95,31,231,31,21,31,111,31,52,31,251,31,164,31,135,31,200,31,144,31,222,31,56,31,206,31,137,31,137,30,215,31,23,31,24,31,76,31,30,31,62,31,132,31,34,31,34,30,140,31,42,31,211,31,171,31,43,31,43,30,220,31,76,31,77,31,59,31,59,30,212,31,67,31,218,31,47,31,155,31,121,31,130,31,15,31,15,30,15,29,27,31,198,31,41,31,102,31,102,30,102,29,102,28,208,31,208,30,59,31,59,30,59,29,59,28,62,31,13,31,184,31,184,30,132,31,77,31,98,31,98,30,98,29,174,31,47,31,47,30,167,31,96,31,208,31,114,31,114,30,182,31,226,31,36,31,12,31,193,31,126,31,246,31,158,31,158,30,197,31,181,31,1,31,144,31,7,31,218,31,233,31,185,31,185,30,97,31,76,31,235,31,172,31,250,31,250,30,250,29,250,28,250,27,250,26,250,25,250,24,243,31,243,30,217,31,68,31,25,31,247,31,104,31,217,31,217,30,110,31,82,31,146,31,146,30,240,31,38,31,38,30,68,31,50,31,50,30,64,31,117,31,70,31,202,31,202,30,202,29,202,28,102,31);

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
