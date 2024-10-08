-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_954 is
end project_tb_954;

architecture project_tb_arch_954 of project_tb_954 is
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

constant SCENARIO_LENGTH : integer := 161;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (89,0,240,0,0,0,133,0,224,0,199,0,226,0,30,0,0,0,0,0,197,0,0,0,98,0,147,0,151,0,103,0,72,0,81,0,242,0,146,0,144,0,56,0,0,0,35,0,144,0,120,0,0,0,103,0,18,0,110,0,103,0,215,0,192,0,43,0,191,0,42,0,0,0,242,0,0,0,73,0,0,0,0,0,32,0,130,0,159,0,124,0,124,0,226,0,0,0,233,0,86,0,84,0,0,0,95,0,19,0,0,0,220,0,19,0,74,0,127,0,112,0,46,0,105,0,102,0,77,0,19,0,37,0,227,0,92,0,113,0,199,0,212,0,0,0,197,0,115,0,64,0,79,0,95,0,220,0,0,0,69,0,41,0,64,0,3,0,0,0,0,0,154,0,227,0,187,0,51,0,0,0,185,0,18,0,50,0,53,0,0,0,43,0,205,0,250,0,0,0,176,0,156,0,55,0,179,0,167,0,0,0,98,0,210,0,0,0,0,0,196,0,29,0,145,0,232,0,111,0,252,0,151,0,189,0,234,0,121,0,61,0,61,0,221,0,33,0,51,0,185,0,216,0,62,0,232,0,193,0,77,0,33,0,12,0,33,0,49,0,123,0,48,0,145,0,7,0,39,0,106,0,81,0,0,0,97,0,193,0,237,0,57,0,0,0,133,0,0,0,94,0,0,0,18,0,102,0,0,0,179,0,0,0,144,0,184,0,29,0,0,0);
signal scenario_full  : scenario_type := (89,31,240,31,240,30,133,31,224,31,199,31,226,31,30,31,30,30,30,29,197,31,197,30,98,31,147,31,151,31,103,31,72,31,81,31,242,31,146,31,144,31,56,31,56,30,35,31,144,31,120,31,120,30,103,31,18,31,110,31,103,31,215,31,192,31,43,31,191,31,42,31,42,30,242,31,242,30,73,31,73,30,73,29,32,31,130,31,159,31,124,31,124,31,226,31,226,30,233,31,86,31,84,31,84,30,95,31,19,31,19,30,220,31,19,31,74,31,127,31,112,31,46,31,105,31,102,31,77,31,19,31,37,31,227,31,92,31,113,31,199,31,212,31,212,30,197,31,115,31,64,31,79,31,95,31,220,31,220,30,69,31,41,31,64,31,3,31,3,30,3,29,154,31,227,31,187,31,51,31,51,30,185,31,18,31,50,31,53,31,53,30,43,31,205,31,250,31,250,30,176,31,156,31,55,31,179,31,167,31,167,30,98,31,210,31,210,30,210,29,196,31,29,31,145,31,232,31,111,31,252,31,151,31,189,31,234,31,121,31,61,31,61,31,221,31,33,31,51,31,185,31,216,31,62,31,232,31,193,31,77,31,33,31,12,31,33,31,49,31,123,31,48,31,145,31,7,31,39,31,106,31,81,31,81,30,97,31,193,31,237,31,57,31,57,30,133,31,133,30,94,31,94,30,18,31,102,31,102,30,179,31,179,30,144,31,184,31,29,31,29,30);

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
