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

constant SCENARIO_LENGTH : integer := 153;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (229,0,19,0,0,0,0,0,3,0,165,0,20,0,88,0,0,0,212,0,94,0,251,0,44,0,213,0,231,0,228,0,46,0,212,0,74,0,0,0,0,0,0,0,127,0,13,0,95,0,143,0,53,0,236,0,0,0,0,0,142,0,16,0,64,0,86,0,131,0,94,0,165,0,227,0,53,0,117,0,0,0,5,0,225,0,19,0,0,0,174,0,95,0,0,0,0,0,183,0,0,0,60,0,57,0,0,0,34,0,168,0,89,0,0,0,205,0,173,0,102,0,178,0,154,0,99,0,31,0,166,0,196,0,180,0,0,0,192,0,109,0,0,0,124,0,149,0,13,0,143,0,0,0,123,0,230,0,198,0,0,0,27,0,0,0,15,0,0,0,0,0,248,0,52,0,141,0,238,0,96,0,0,0,0,0,120,0,239,0,65,0,0,0,52,0,215,0,113,0,49,0,120,0,123,0,0,0,198,0,81,0,0,0,47,0,19,0,0,0,25,0,21,0,204,0,149,0,20,0,0,0,114,0,14,0,238,0,163,0,227,0,230,0,50,0,93,0,0,0,124,0,254,0,75,0,6,0,58,0,83,0,143,0,75,0,0,0,0,0,253,0,0,0,124,0,4,0,205,0,22,0,80,0,0,0,39,0,245,0,219,0,52,0,169,0,25,0,0,0,80,0,33,0,111,0);
signal scenario_full  : scenario_type := (229,31,19,31,19,30,19,29,3,31,165,31,20,31,88,31,88,30,212,31,94,31,251,31,44,31,213,31,231,31,228,31,46,31,212,31,74,31,74,30,74,29,74,28,127,31,13,31,95,31,143,31,53,31,236,31,236,30,236,29,142,31,16,31,64,31,86,31,131,31,94,31,165,31,227,31,53,31,117,31,117,30,5,31,225,31,19,31,19,30,174,31,95,31,95,30,95,29,183,31,183,30,60,31,57,31,57,30,34,31,168,31,89,31,89,30,205,31,173,31,102,31,178,31,154,31,99,31,31,31,166,31,196,31,180,31,180,30,192,31,109,31,109,30,124,31,149,31,13,31,143,31,143,30,123,31,230,31,198,31,198,30,27,31,27,30,15,31,15,30,15,29,248,31,52,31,141,31,238,31,96,31,96,30,96,29,120,31,239,31,65,31,65,30,52,31,215,31,113,31,49,31,120,31,123,31,123,30,198,31,81,31,81,30,47,31,19,31,19,30,25,31,21,31,204,31,149,31,20,31,20,30,114,31,14,31,238,31,163,31,227,31,230,31,50,31,93,31,93,30,124,31,254,31,75,31,6,31,58,31,83,31,143,31,75,31,75,30,75,29,253,31,253,30,124,31,4,31,205,31,22,31,80,31,80,30,39,31,245,31,219,31,52,31,169,31,25,31,25,30,80,31,33,31,111,31);

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
