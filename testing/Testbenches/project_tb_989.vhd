-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_989 is
end project_tb_989;

architecture project_tb_arch_989 of project_tb_989 is
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

constant SCENARIO_LENGTH : integer := 148;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,33,0,45,0,235,0,0,0,137,0,0,0,0,0,118,0,0,0,156,0,0,0,48,0,132,0,17,0,91,0,251,0,0,0,80,0,0,0,120,0,185,0,224,0,0,0,17,0,20,0,0,0,0,0,0,0,209,0,10,0,79,0,198,0,42,0,206,0,227,0,0,0,239,0,0,0,48,0,130,0,65,0,116,0,2,0,129,0,0,0,162,0,114,0,226,0,0,0,221,0,117,0,145,0,39,0,0,0,252,0,5,0,199,0,20,0,0,0,0,0,72,0,0,0,0,0,0,0,133,0,21,0,12,0,195,0,234,0,200,0,0,0,61,0,146,0,0,0,182,0,0,0,0,0,61,0,59,0,0,0,177,0,105,0,9,0,47,0,0,0,122,0,0,0,251,0,160,0,0,0,110,0,0,0,0,0,0,0,23,0,153,0,217,0,0,0,150,0,52,0,242,0,0,0,39,0,16,0,131,0,72,0,0,0,248,0,246,0,156,0,229,0,29,0,23,0,0,0,0,0,0,0,135,0,88,0,0,0,0,0,0,0,0,0,88,0,0,0,86,0,103,0,92,0,28,0,253,0,30,0,170,0,0,0,201,0,98,0,0,0,105,0,0,0,0,0,79,0,152,0,253,0,69,0,99,0,24,0,243,0,220,0,0,0);
signal scenario_full  : scenario_type := (0,0,33,31,45,31,235,31,235,30,137,31,137,30,137,29,118,31,118,30,156,31,156,30,48,31,132,31,17,31,91,31,251,31,251,30,80,31,80,30,120,31,185,31,224,31,224,30,17,31,20,31,20,30,20,29,20,28,209,31,10,31,79,31,198,31,42,31,206,31,227,31,227,30,239,31,239,30,48,31,130,31,65,31,116,31,2,31,129,31,129,30,162,31,114,31,226,31,226,30,221,31,117,31,145,31,39,31,39,30,252,31,5,31,199,31,20,31,20,30,20,29,72,31,72,30,72,29,72,28,133,31,21,31,12,31,195,31,234,31,200,31,200,30,61,31,146,31,146,30,182,31,182,30,182,29,61,31,59,31,59,30,177,31,105,31,9,31,47,31,47,30,122,31,122,30,251,31,160,31,160,30,110,31,110,30,110,29,110,28,23,31,153,31,217,31,217,30,150,31,52,31,242,31,242,30,39,31,16,31,131,31,72,31,72,30,248,31,246,31,156,31,229,31,29,31,23,31,23,30,23,29,23,28,135,31,88,31,88,30,88,29,88,28,88,27,88,31,88,30,86,31,103,31,92,31,28,31,253,31,30,31,170,31,170,30,201,31,98,31,98,30,105,31,105,30,105,29,79,31,152,31,253,31,69,31,99,31,24,31,243,31,220,31,220,30);

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
