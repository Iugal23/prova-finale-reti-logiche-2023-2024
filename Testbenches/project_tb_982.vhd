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

constant SCENARIO_LENGTH : integer := 217;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (214,0,52,0,127,0,104,0,222,0,164,0,108,0,0,0,161,0,0,0,241,0,200,0,179,0,81,0,0,0,179,0,152,0,0,0,153,0,0,0,150,0,13,0,120,0,0,0,162,0,89,0,193,0,137,0,245,0,222,0,182,0,204,0,69,0,219,0,33,0,56,0,224,0,243,0,200,0,133,0,217,0,169,0,131,0,186,0,151,0,142,0,3,0,187,0,29,0,100,0,0,0,8,0,89,0,251,0,214,0,53,0,160,0,186,0,17,0,0,0,253,0,203,0,0,0,248,0,0,0,0,0,112,0,53,0,247,0,150,0,57,0,0,0,72,0,221,0,99,0,18,0,0,0,54,0,91,0,236,0,76,0,80,0,20,0,109,0,8,0,108,0,0,0,66,0,105,0,230,0,157,0,0,0,241,0,142,0,231,0,175,0,145,0,13,0,0,0,92,0,193,0,3,0,3,0,173,0,199,0,0,0,0,0,214,0,0,0,5,0,3,0,235,0,0,0,154,0,38,0,59,0,0,0,128,0,68,0,217,0,0,0,7,0,207,0,230,0,211,0,181,0,183,0,136,0,2,0,108,0,153,0,7,0,146,0,0,0,0,0,70,0,0,0,161,0,0,0,125,0,113,0,29,0,0,0,108,0,122,0,0,0,169,0,198,0,1,0,216,0,16,0,0,0,140,0,106,0,79,0,0,0,246,0,48,0,163,0,82,0,95,0,212,0,215,0,152,0,70,0,101,0,165,0,225,0,76,0,252,0,0,0,0,0,246,0,136,0,64,0,142,0,251,0,5,0,236,0,0,0,49,0,182,0,217,0,118,0,47,0,177,0,0,0,165,0,247,0,8,0,0,0,229,0,0,0,231,0,0,0,197,0,227,0,11,0,26,0,10,0,10,0,128,0,0,0,17,0,0,0,83,0,0,0,145,0,178,0,24,0,2,0,107,0,234,0,136,0,44,0,173,0,219,0);
signal scenario_full  : scenario_type := (214,31,52,31,127,31,104,31,222,31,164,31,108,31,108,30,161,31,161,30,241,31,200,31,179,31,81,31,81,30,179,31,152,31,152,30,153,31,153,30,150,31,13,31,120,31,120,30,162,31,89,31,193,31,137,31,245,31,222,31,182,31,204,31,69,31,219,31,33,31,56,31,224,31,243,31,200,31,133,31,217,31,169,31,131,31,186,31,151,31,142,31,3,31,187,31,29,31,100,31,100,30,8,31,89,31,251,31,214,31,53,31,160,31,186,31,17,31,17,30,253,31,203,31,203,30,248,31,248,30,248,29,112,31,53,31,247,31,150,31,57,31,57,30,72,31,221,31,99,31,18,31,18,30,54,31,91,31,236,31,76,31,80,31,20,31,109,31,8,31,108,31,108,30,66,31,105,31,230,31,157,31,157,30,241,31,142,31,231,31,175,31,145,31,13,31,13,30,92,31,193,31,3,31,3,31,173,31,199,31,199,30,199,29,214,31,214,30,5,31,3,31,235,31,235,30,154,31,38,31,59,31,59,30,128,31,68,31,217,31,217,30,7,31,207,31,230,31,211,31,181,31,183,31,136,31,2,31,108,31,153,31,7,31,146,31,146,30,146,29,70,31,70,30,161,31,161,30,125,31,113,31,29,31,29,30,108,31,122,31,122,30,169,31,198,31,1,31,216,31,16,31,16,30,140,31,106,31,79,31,79,30,246,31,48,31,163,31,82,31,95,31,212,31,215,31,152,31,70,31,101,31,165,31,225,31,76,31,252,31,252,30,252,29,246,31,136,31,64,31,142,31,251,31,5,31,236,31,236,30,49,31,182,31,217,31,118,31,47,31,177,31,177,30,165,31,247,31,8,31,8,30,229,31,229,30,231,31,231,30,197,31,227,31,11,31,26,31,10,31,10,31,128,31,128,30,17,31,17,30,83,31,83,30,145,31,178,31,24,31,2,31,107,31,234,31,136,31,44,31,173,31,219,31);

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
