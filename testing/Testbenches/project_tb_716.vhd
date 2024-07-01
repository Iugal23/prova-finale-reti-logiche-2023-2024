-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_716 is
end project_tb_716;

architecture project_tb_arch_716 of project_tb_716 is
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

constant SCENARIO_LENGTH : integer := 247;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (173,0,189,0,255,0,40,0,231,0,158,0,131,0,154,0,146,0,207,0,135,0,0,0,9,0,0,0,7,0,220,0,6,0,68,0,201,0,148,0,231,0,74,0,37,0,196,0,239,0,0,0,178,0,92,0,161,0,213,0,39,0,0,0,7,0,0,0,228,0,234,0,74,0,202,0,17,0,175,0,124,0,53,0,90,0,126,0,177,0,206,0,35,0,228,0,215,0,79,0,27,0,22,0,76,0,112,0,196,0,213,0,0,0,101,0,85,0,0,0,31,0,154,0,238,0,160,0,0,0,176,0,214,0,202,0,57,0,197,0,0,0,203,0,17,0,156,0,0,0,55,0,191,0,0,0,0,0,156,0,74,0,70,0,162,0,0,0,130,0,242,0,252,0,0,0,0,0,243,0,0,0,251,0,0,0,0,0,0,0,0,0,148,0,109,0,207,0,63,0,138,0,116,0,210,0,186,0,169,0,155,0,226,0,200,0,35,0,36,0,19,0,120,0,124,0,145,0,93,0,218,0,116,0,118,0,207,0,0,0,4,0,73,0,26,0,149,0,150,0,208,0,71,0,222,0,72,0,6,0,114,0,75,0,190,0,82,0,43,0,117,0,187,0,0,0,204,0,23,0,125,0,142,0,0,0,90,0,176,0,0,0,28,0,120,0,123,0,0,0,59,0,225,0,0,0,21,0,165,0,16,0,78,0,0,0,125,0,32,0,164,0,124,0,238,0,138,0,5,0,0,0,19,0,223,0,0,0,0,0,7,0,237,0,207,0,201,0,0,0,76,0,17,0,0,0,223,0,194,0,0,0,0,0,71,0,143,0,108,0,0,0,0,0,241,0,193,0,230,0,140,0,231,0,247,0,0,0,122,0,0,0,0,0,0,0,17,0,62,0,11,0,151,0,0,0,74,0,232,0,87,0,117,0,18,0,16,0,176,0,74,0,151,0,78,0,102,0,18,0,62,0,103,0,114,0,234,0,243,0,230,0,104,0,253,0,151,0,156,0,120,0,196,0,20,0,5,0,0,0,0,0,127,0,0,0,0,0,111,0,0,0,12,0,205,0,233,0,40,0,13,0,91,0,189,0,0,0,0,0,100,0,65,0);
signal scenario_full  : scenario_type := (173,31,189,31,255,31,40,31,231,31,158,31,131,31,154,31,146,31,207,31,135,31,135,30,9,31,9,30,7,31,220,31,6,31,68,31,201,31,148,31,231,31,74,31,37,31,196,31,239,31,239,30,178,31,92,31,161,31,213,31,39,31,39,30,7,31,7,30,228,31,234,31,74,31,202,31,17,31,175,31,124,31,53,31,90,31,126,31,177,31,206,31,35,31,228,31,215,31,79,31,27,31,22,31,76,31,112,31,196,31,213,31,213,30,101,31,85,31,85,30,31,31,154,31,238,31,160,31,160,30,176,31,214,31,202,31,57,31,197,31,197,30,203,31,17,31,156,31,156,30,55,31,191,31,191,30,191,29,156,31,74,31,70,31,162,31,162,30,130,31,242,31,252,31,252,30,252,29,243,31,243,30,251,31,251,30,251,29,251,28,251,27,148,31,109,31,207,31,63,31,138,31,116,31,210,31,186,31,169,31,155,31,226,31,200,31,35,31,36,31,19,31,120,31,124,31,145,31,93,31,218,31,116,31,118,31,207,31,207,30,4,31,73,31,26,31,149,31,150,31,208,31,71,31,222,31,72,31,6,31,114,31,75,31,190,31,82,31,43,31,117,31,187,31,187,30,204,31,23,31,125,31,142,31,142,30,90,31,176,31,176,30,28,31,120,31,123,31,123,30,59,31,225,31,225,30,21,31,165,31,16,31,78,31,78,30,125,31,32,31,164,31,124,31,238,31,138,31,5,31,5,30,19,31,223,31,223,30,223,29,7,31,237,31,207,31,201,31,201,30,76,31,17,31,17,30,223,31,194,31,194,30,194,29,71,31,143,31,108,31,108,30,108,29,241,31,193,31,230,31,140,31,231,31,247,31,247,30,122,31,122,30,122,29,122,28,17,31,62,31,11,31,151,31,151,30,74,31,232,31,87,31,117,31,18,31,16,31,176,31,74,31,151,31,78,31,102,31,18,31,62,31,103,31,114,31,234,31,243,31,230,31,104,31,253,31,151,31,156,31,120,31,196,31,20,31,5,31,5,30,5,29,127,31,127,30,127,29,111,31,111,30,12,31,205,31,233,31,40,31,13,31,91,31,189,31,189,30,189,29,100,31,65,31);

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
