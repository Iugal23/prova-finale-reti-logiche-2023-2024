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

constant SCENARIO_LENGTH : integer := 237;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (47,0,0,0,250,0,217,0,30,0,7,0,209,0,59,0,227,0,193,0,37,0,0,0,157,0,99,0,96,0,143,0,104,0,129,0,158,0,86,0,5,0,0,0,0,0,79,0,77,0,123,0,8,0,144,0,8,0,206,0,148,0,79,0,242,0,22,0,101,0,0,0,32,0,114,0,0,0,37,0,123,0,0,0,123,0,9,0,0,0,96,0,147,0,126,0,0,0,0,0,14,0,26,0,100,0,196,0,238,0,33,0,44,0,227,0,144,0,19,0,213,0,0,0,220,0,43,0,41,0,73,0,0,0,0,0,219,0,246,0,78,0,243,0,18,0,235,0,151,0,235,0,27,0,0,0,0,0,99,0,11,0,162,0,194,0,213,0,243,0,0,0,127,0,60,0,33,0,40,0,168,0,0,0,241,0,0,0,123,0,0,0,0,0,54,0,42,0,27,0,0,0,0,0,179,0,156,0,234,0,189,0,182,0,246,0,7,0,216,0,0,0,0,0,49,0,192,0,162,0,31,0,201,0,27,0,205,0,132,0,204,0,0,0,80,0,0,0,238,0,44,0,153,0,12,0,193,0,42,0,7,0,30,0,60,0,227,0,114,0,150,0,223,0,0,0,170,0,167,0,0,0,0,0,0,0,127,0,81,0,226,0,132,0,213,0,2,0,35,0,240,0,0,0,131,0,254,0,187,0,164,0,181,0,168,0,251,0,63,0,0,0,222,0,245,0,0,0,151,0,0,0,97,0,49,0,228,0,45,0,0,0,112,0,0,0,169,0,98,0,0,0,0,0,91,0,0,0,206,0,78,0,0,0,0,0,204,0,96,0,73,0,0,0,148,0,179,0,116,0,243,0,252,0,207,0,90,0,0,0,171,0,0,0,205,0,229,0,100,0,101,0,159,0,240,0,140,0,99,0,201,0,56,0,34,0,122,0,180,0,182,0,0,0,150,0,60,0,50,0,126,0,0,0,250,0,236,0,169,0,190,0,0,0,0,0,213,0,0,0,20,0,245,0,0,0,244,0,153,0,239,0,39,0,73,0,49,0,54,0,233,0,0,0);
signal scenario_full  : scenario_type := (47,31,47,30,250,31,217,31,30,31,7,31,209,31,59,31,227,31,193,31,37,31,37,30,157,31,99,31,96,31,143,31,104,31,129,31,158,31,86,31,5,31,5,30,5,29,79,31,77,31,123,31,8,31,144,31,8,31,206,31,148,31,79,31,242,31,22,31,101,31,101,30,32,31,114,31,114,30,37,31,123,31,123,30,123,31,9,31,9,30,96,31,147,31,126,31,126,30,126,29,14,31,26,31,100,31,196,31,238,31,33,31,44,31,227,31,144,31,19,31,213,31,213,30,220,31,43,31,41,31,73,31,73,30,73,29,219,31,246,31,78,31,243,31,18,31,235,31,151,31,235,31,27,31,27,30,27,29,99,31,11,31,162,31,194,31,213,31,243,31,243,30,127,31,60,31,33,31,40,31,168,31,168,30,241,31,241,30,123,31,123,30,123,29,54,31,42,31,27,31,27,30,27,29,179,31,156,31,234,31,189,31,182,31,246,31,7,31,216,31,216,30,216,29,49,31,192,31,162,31,31,31,201,31,27,31,205,31,132,31,204,31,204,30,80,31,80,30,238,31,44,31,153,31,12,31,193,31,42,31,7,31,30,31,60,31,227,31,114,31,150,31,223,31,223,30,170,31,167,31,167,30,167,29,167,28,127,31,81,31,226,31,132,31,213,31,2,31,35,31,240,31,240,30,131,31,254,31,187,31,164,31,181,31,168,31,251,31,63,31,63,30,222,31,245,31,245,30,151,31,151,30,97,31,49,31,228,31,45,31,45,30,112,31,112,30,169,31,98,31,98,30,98,29,91,31,91,30,206,31,78,31,78,30,78,29,204,31,96,31,73,31,73,30,148,31,179,31,116,31,243,31,252,31,207,31,90,31,90,30,171,31,171,30,205,31,229,31,100,31,101,31,159,31,240,31,140,31,99,31,201,31,56,31,34,31,122,31,180,31,182,31,182,30,150,31,60,31,50,31,126,31,126,30,250,31,236,31,169,31,190,31,190,30,190,29,213,31,213,30,20,31,245,31,245,30,244,31,153,31,239,31,39,31,73,31,49,31,54,31,233,31,233,30);

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
