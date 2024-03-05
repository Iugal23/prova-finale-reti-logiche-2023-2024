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

constant SCENARIO_LENGTH : integer := 174;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (33,0,14,0,216,0,80,0,33,0,91,0,0,0,2,0,187,0,48,0,237,0,230,0,165,0,53,0,174,0,0,0,0,0,159,0,89,0,0,0,0,0,32,0,252,0,100,0,223,0,7,0,233,0,70,0,0,0,236,0,25,0,18,0,173,0,0,0,246,0,32,0,160,0,0,0,36,0,0,0,104,0,63,0,167,0,0,0,187,0,248,0,23,0,0,0,54,0,244,0,194,0,212,0,0,0,221,0,234,0,172,0,72,0,0,0,204,0,74,0,30,0,83,0,8,0,187,0,0,0,0,0,0,0,38,0,1,0,74,0,93,0,116,0,78,0,160,0,0,0,145,0,133,0,0,0,34,0,161,0,0,0,147,0,0,0,5,0,23,0,144,0,34,0,36,0,163,0,106,0,0,0,0,0,72,0,0,0,7,0,12,0,80,0,182,0,103,0,55,0,219,0,25,0,148,0,0,0,150,0,0,0,236,0,0,0,0,0,0,0,104,0,137,0,85,0,240,0,11,0,0,0,2,0,245,0,0,0,248,0,215,0,163,0,247,0,96,0,18,0,55,0,158,0,175,0,171,0,0,0,25,0,123,0,230,0,0,0,144,0,193,0,0,0,248,0,78,0,17,0,75,0,148,0,0,0,77,0,0,0,68,0,235,0,243,0,127,0,0,0,128,0,184,0,163,0,34,0,86,0,235,0,35,0,0,0,90,0,196,0,203,0,0,0,47,0,61,0,62,0,2,0,56,0,108,0,246,0,0,0,75,0,137,0,46,0,0,0);
signal scenario_full  : scenario_type := (33,31,14,31,216,31,80,31,33,31,91,31,91,30,2,31,187,31,48,31,237,31,230,31,165,31,53,31,174,31,174,30,174,29,159,31,89,31,89,30,89,29,32,31,252,31,100,31,223,31,7,31,233,31,70,31,70,30,236,31,25,31,18,31,173,31,173,30,246,31,32,31,160,31,160,30,36,31,36,30,104,31,63,31,167,31,167,30,187,31,248,31,23,31,23,30,54,31,244,31,194,31,212,31,212,30,221,31,234,31,172,31,72,31,72,30,204,31,74,31,30,31,83,31,8,31,187,31,187,30,187,29,187,28,38,31,1,31,74,31,93,31,116,31,78,31,160,31,160,30,145,31,133,31,133,30,34,31,161,31,161,30,147,31,147,30,5,31,23,31,144,31,34,31,36,31,163,31,106,31,106,30,106,29,72,31,72,30,7,31,12,31,80,31,182,31,103,31,55,31,219,31,25,31,148,31,148,30,150,31,150,30,236,31,236,30,236,29,236,28,104,31,137,31,85,31,240,31,11,31,11,30,2,31,245,31,245,30,248,31,215,31,163,31,247,31,96,31,18,31,55,31,158,31,175,31,171,31,171,30,25,31,123,31,230,31,230,30,144,31,193,31,193,30,248,31,78,31,17,31,75,31,148,31,148,30,77,31,77,30,68,31,235,31,243,31,127,31,127,30,128,31,184,31,163,31,34,31,86,31,235,31,35,31,35,30,90,31,196,31,203,31,203,30,47,31,61,31,62,31,2,31,56,31,108,31,246,31,246,30,75,31,137,31,46,31,46,30);

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
