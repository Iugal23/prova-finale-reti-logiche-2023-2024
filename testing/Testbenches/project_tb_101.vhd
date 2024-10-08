-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_101 is
end project_tb_101;

architecture project_tb_arch_101 of project_tb_101 is
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

constant SCENARIO_LENGTH : integer := 311;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,74,0,0,0,0,0,0,0,204,0,40,0,0,0,24,0,0,0,0,0,63,0,140,0,232,0,116,0,233,0,227,0,210,0,48,0,97,0,77,0,238,0,164,0,0,0,0,0,154,0,0,0,136,0,113,0,140,0,175,0,140,0,215,0,30,0,174,0,183,0,0,0,98,0,251,0,99,0,0,0,178,0,191,0,80,0,177,0,93,0,34,0,155,0,12,0,23,0,179,0,223,0,21,0,75,0,0,0,183,0,0,0,199,0,103,0,95,0,208,0,168,0,0,0,38,0,0,0,71,0,193,0,156,0,133,0,41,0,226,0,100,0,144,0,98,0,33,0,126,0,0,0,149,0,6,0,97,0,0,0,159,0,224,0,198,0,0,0,159,0,96,0,214,0,112,0,84,0,0,0,146,0,69,0,0,0,181,0,50,0,0,0,122,0,0,0,38,0,188,0,162,0,219,0,232,0,73,0,228,0,143,0,241,0,0,0,0,0,0,0,12,0,26,0,16,0,147,0,97,0,0,0,0,0,102,0,75,0,61,0,111,0,33,0,81,0,174,0,85,0,228,0,0,0,108,0,34,0,145,0,144,0,0,0,0,0,64,0,162,0,38,0,248,0,154,0,0,0,160,0,0,0,77,0,54,0,0,0,0,0,174,0,168,0,57,0,11,0,186,0,121,0,72,0,117,0,247,0,87,0,240,0,216,0,0,0,28,0,0,0,74,0,0,0,23,0,158,0,220,0,146,0,211,0,235,0,130,0,220,0,0,0,0,0,111,0,24,0,141,0,211,0,135,0,0,0,78,0,170,0,34,0,121,0,242,0,126,0,32,0,0,0,0,0,30,0,0,0,237,0,0,0,0,0,0,0,113,0,98,0,179,0,242,0,131,0,243,0,255,0,45,0,179,0,169,0,0,0,119,0,0,0,102,0,177,0,197,0,187,0,29,0,22,0,205,0,97,0,132,0,0,0,12,0,173,0,36,0,31,0,0,0,135,0,16,0,227,0,147,0,45,0,233,0,0,0,39,0,0,0,0,0,21,0,130,0,94,0,217,0,0,0,117,0,127,0,130,0,38,0,0,0,130,0,170,0,73,0,0,0,233,0,78,0,192,0,0,0,21,0,124,0,67,0,144,0,65,0,161,0,49,0,149,0,0,0,0,0,42,0,140,0,79,0,0,0,215,0,58,0,162,0,41,0,0,0,46,0,0,0,114,0,67,0,0,0,0,0,174,0,5,0,100,0,201,0,137,0,0,0,127,0,30,0,126,0,245,0,0,0,0,0,0,0,0,0,200,0,133,0,106,0,1,0,0,0,181,0,156,0,187,0,78,0,0,0,235,0,12,0,104,0,227,0,208,0,30,0,0,0,195,0,132,0,131,0,45,0,61,0);
signal scenario_full  : scenario_type := (0,0,74,31,74,30,74,29,74,28,204,31,40,31,40,30,24,31,24,30,24,29,63,31,140,31,232,31,116,31,233,31,227,31,210,31,48,31,97,31,77,31,238,31,164,31,164,30,164,29,154,31,154,30,136,31,113,31,140,31,175,31,140,31,215,31,30,31,174,31,183,31,183,30,98,31,251,31,99,31,99,30,178,31,191,31,80,31,177,31,93,31,34,31,155,31,12,31,23,31,179,31,223,31,21,31,75,31,75,30,183,31,183,30,199,31,103,31,95,31,208,31,168,31,168,30,38,31,38,30,71,31,193,31,156,31,133,31,41,31,226,31,100,31,144,31,98,31,33,31,126,31,126,30,149,31,6,31,97,31,97,30,159,31,224,31,198,31,198,30,159,31,96,31,214,31,112,31,84,31,84,30,146,31,69,31,69,30,181,31,50,31,50,30,122,31,122,30,38,31,188,31,162,31,219,31,232,31,73,31,228,31,143,31,241,31,241,30,241,29,241,28,12,31,26,31,16,31,147,31,97,31,97,30,97,29,102,31,75,31,61,31,111,31,33,31,81,31,174,31,85,31,228,31,228,30,108,31,34,31,145,31,144,31,144,30,144,29,64,31,162,31,38,31,248,31,154,31,154,30,160,31,160,30,77,31,54,31,54,30,54,29,174,31,168,31,57,31,11,31,186,31,121,31,72,31,117,31,247,31,87,31,240,31,216,31,216,30,28,31,28,30,74,31,74,30,23,31,158,31,220,31,146,31,211,31,235,31,130,31,220,31,220,30,220,29,111,31,24,31,141,31,211,31,135,31,135,30,78,31,170,31,34,31,121,31,242,31,126,31,32,31,32,30,32,29,30,31,30,30,237,31,237,30,237,29,237,28,113,31,98,31,179,31,242,31,131,31,243,31,255,31,45,31,179,31,169,31,169,30,119,31,119,30,102,31,177,31,197,31,187,31,29,31,22,31,205,31,97,31,132,31,132,30,12,31,173,31,36,31,31,31,31,30,135,31,16,31,227,31,147,31,45,31,233,31,233,30,39,31,39,30,39,29,21,31,130,31,94,31,217,31,217,30,117,31,127,31,130,31,38,31,38,30,130,31,170,31,73,31,73,30,233,31,78,31,192,31,192,30,21,31,124,31,67,31,144,31,65,31,161,31,49,31,149,31,149,30,149,29,42,31,140,31,79,31,79,30,215,31,58,31,162,31,41,31,41,30,46,31,46,30,114,31,67,31,67,30,67,29,174,31,5,31,100,31,201,31,137,31,137,30,127,31,30,31,126,31,245,31,245,30,245,29,245,28,245,27,200,31,133,31,106,31,1,31,1,30,181,31,156,31,187,31,78,31,78,30,235,31,12,31,104,31,227,31,208,31,30,31,30,30,195,31,132,31,131,31,45,31,61,31);

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
