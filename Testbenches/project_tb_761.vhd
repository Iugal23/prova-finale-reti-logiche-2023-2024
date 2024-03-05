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

constant SCENARIO_LENGTH : integer := 163;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (24,0,0,0,164,0,90,0,56,0,82,0,0,0,113,0,107,0,26,0,15,0,0,0,34,0,148,0,17,0,97,0,28,0,20,0,105,0,231,0,0,0,61,0,163,0,213,0,41,0,0,0,172,0,193,0,0,0,0,0,136,0,116,0,229,0,0,0,13,0,0,0,0,0,1,0,135,0,0,0,37,0,0,0,84,0,99,0,44,0,67,0,218,0,0,0,14,0,223,0,223,0,181,0,251,0,72,0,162,0,36,0,52,0,0,0,25,0,37,0,254,0,39,0,15,0,97,0,80,0,23,0,193,0,133,0,69,0,0,0,172,0,0,0,149,0,53,0,0,0,105,0,15,0,38,0,131,0,79,0,71,0,0,0,239,0,0,0,234,0,32,0,140,0,30,0,0,0,177,0,237,0,0,0,98,0,30,0,245,0,96,0,0,0,37,0,193,0,176,0,210,0,120,0,0,0,135,0,39,0,135,0,24,0,81,0,143,0,12,0,0,0,131,0,69,0,151,0,0,0,0,0,72,0,47,0,178,0,0,0,250,0,39,0,0,0,45,0,156,0,77,0,91,0,48,0,0,0,0,0,107,0,0,0,108,0,25,0,206,0,179,0,0,0,96,0,0,0,50,0,141,0,250,0,136,0,0,0,0,0,47,0,0,0,62,0,5,0,52,0,121,0,193,0,130,0,137,0,71,0,220,0,0,0,55,0,117,0,216,0,101,0,120,0,109,0);
signal scenario_full  : scenario_type := (24,31,24,30,164,31,90,31,56,31,82,31,82,30,113,31,107,31,26,31,15,31,15,30,34,31,148,31,17,31,97,31,28,31,20,31,105,31,231,31,231,30,61,31,163,31,213,31,41,31,41,30,172,31,193,31,193,30,193,29,136,31,116,31,229,31,229,30,13,31,13,30,13,29,1,31,135,31,135,30,37,31,37,30,84,31,99,31,44,31,67,31,218,31,218,30,14,31,223,31,223,31,181,31,251,31,72,31,162,31,36,31,52,31,52,30,25,31,37,31,254,31,39,31,15,31,97,31,80,31,23,31,193,31,133,31,69,31,69,30,172,31,172,30,149,31,53,31,53,30,105,31,15,31,38,31,131,31,79,31,71,31,71,30,239,31,239,30,234,31,32,31,140,31,30,31,30,30,177,31,237,31,237,30,98,31,30,31,245,31,96,31,96,30,37,31,193,31,176,31,210,31,120,31,120,30,135,31,39,31,135,31,24,31,81,31,143,31,12,31,12,30,131,31,69,31,151,31,151,30,151,29,72,31,47,31,178,31,178,30,250,31,39,31,39,30,45,31,156,31,77,31,91,31,48,31,48,30,48,29,107,31,107,30,108,31,25,31,206,31,179,31,179,30,96,31,96,30,50,31,141,31,250,31,136,31,136,30,136,29,47,31,47,30,62,31,5,31,52,31,121,31,193,31,130,31,137,31,71,31,220,31,220,30,55,31,117,31,216,31,101,31,120,31,109,31);

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
