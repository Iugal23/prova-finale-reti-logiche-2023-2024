-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_848 is
end project_tb_848;

architecture project_tb_arch_848 of project_tb_848 is
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

constant SCENARIO_LENGTH : integer := 186;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (137,0,25,0,179,0,217,0,151,0,0,0,0,0,151,0,60,0,0,0,213,0,106,0,7,0,23,0,81,0,25,0,66,0,64,0,220,0,0,0,0,0,0,0,16,0,0,0,45,0,206,0,0,0,224,0,187,0,67,0,13,0,208,0,254,0,217,0,0,0,231,0,85,0,26,0,154,0,0,0,78,0,0,0,150,0,0,0,134,0,116,0,0,0,184,0,186,0,0,0,105,0,251,0,0,0,198,0,68,0,0,0,140,0,140,0,22,0,0,0,58,0,164,0,234,0,151,0,249,0,21,0,0,0,79,0,0,0,19,0,67,0,238,0,71,0,22,0,0,0,95,0,3,0,106,0,0,0,127,0,0,0,0,0,65,0,234,0,0,0,169,0,188,0,199,0,1,0,89,0,104,0,164,0,166,0,41,0,120,0,247,0,0,0,66,0,18,0,195,0,105,0,93,0,210,0,0,0,233,0,79,0,203,0,60,0,198,0,144,0,0,0,107,0,251,0,29,0,0,0,4,0,135,0,120,0,15,0,0,0,116,0,0,0,0,0,113,0,114,0,215,0,67,0,0,0,75,0,246,0,0,0,130,0,219,0,2,0,61,0,114,0,86,0,0,0,22,0,117,0,0,0,79,0,95,0,158,0,0,0,0,0,210,0,90,0,124,0,60,0,198,0,184,0,0,0,86,0,0,0,0,0,0,0,67,0,245,0,187,0,217,0,245,0,13,0,186,0,222,0,172,0,0,0,128,0,241,0,58,0,91,0,69,0,68,0,67,0,210,0,0,0,252,0,116,0,240,0,85,0,123,0,177,0,190,0,250,0,201,0,238,0);
signal scenario_full  : scenario_type := (137,31,25,31,179,31,217,31,151,31,151,30,151,29,151,31,60,31,60,30,213,31,106,31,7,31,23,31,81,31,25,31,66,31,64,31,220,31,220,30,220,29,220,28,16,31,16,30,45,31,206,31,206,30,224,31,187,31,67,31,13,31,208,31,254,31,217,31,217,30,231,31,85,31,26,31,154,31,154,30,78,31,78,30,150,31,150,30,134,31,116,31,116,30,184,31,186,31,186,30,105,31,251,31,251,30,198,31,68,31,68,30,140,31,140,31,22,31,22,30,58,31,164,31,234,31,151,31,249,31,21,31,21,30,79,31,79,30,19,31,67,31,238,31,71,31,22,31,22,30,95,31,3,31,106,31,106,30,127,31,127,30,127,29,65,31,234,31,234,30,169,31,188,31,199,31,1,31,89,31,104,31,164,31,166,31,41,31,120,31,247,31,247,30,66,31,18,31,195,31,105,31,93,31,210,31,210,30,233,31,79,31,203,31,60,31,198,31,144,31,144,30,107,31,251,31,29,31,29,30,4,31,135,31,120,31,15,31,15,30,116,31,116,30,116,29,113,31,114,31,215,31,67,31,67,30,75,31,246,31,246,30,130,31,219,31,2,31,61,31,114,31,86,31,86,30,22,31,117,31,117,30,79,31,95,31,158,31,158,30,158,29,210,31,90,31,124,31,60,31,198,31,184,31,184,30,86,31,86,30,86,29,86,28,67,31,245,31,187,31,217,31,245,31,13,31,186,31,222,31,172,31,172,30,128,31,241,31,58,31,91,31,69,31,68,31,67,31,210,31,210,30,252,31,116,31,240,31,85,31,123,31,177,31,190,31,250,31,201,31,238,31);

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
