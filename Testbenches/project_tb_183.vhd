-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_183 is
end project_tb_183;

architecture project_tb_arch_183 of project_tb_183 is
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

constant SCENARIO_LENGTH : integer := 198;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (119,0,118,0,52,0,68,0,123,0,96,0,65,0,0,0,0,0,0,0,0,0,82,0,234,0,41,0,116,0,59,0,211,0,83,0,159,0,0,0,254,0,36,0,0,0,125,0,20,0,80,0,16,0,0,0,50,0,10,0,8,0,169,0,65,0,30,0,110,0,75,0,0,0,133,0,224,0,124,0,82,0,105,0,0,0,255,0,0,0,203,0,149,0,154,0,210,0,65,0,136,0,115,0,123,0,0,0,0,0,99,0,61,0,0,0,2,0,10,0,54,0,0,0,213,0,45,0,166,0,0,0,0,0,98,0,137,0,53,0,139,0,11,0,0,0,108,0,104,0,0,0,8,0,0,0,94,0,230,0,4,0,0,0,174,0,235,0,0,0,121,0,24,0,117,0,146,0,136,0,181,0,202,0,42,0,88,0,16,0,91,0,251,0,195,0,17,0,160,0,63,0,130,0,0,0,217,0,221,0,99,0,0,0,112,0,184,0,236,0,87,0,103,0,179,0,88,0,0,0,111,0,148,0,80,0,252,0,34,0,241,0,0,0,241,0,192,0,159,0,198,0,148,0,163,0,240,0,119,0,0,0,210,0,85,0,53,0,215,0,24,0,11,0,20,0,222,0,0,0,85,0,33,0,153,0,0,0,93,0,94,0,103,0,0,0,131,0,50,0,210,0,6,0,248,0,204,0,0,0,12,0,218,0,142,0,73,0,234,0,171,0,21,0,76,0,195,0,64,0,0,0,229,0,0,0,183,0,0,0,216,0,54,0,0,0,106,0,223,0,227,0,168,0,168,0,0,0,49,0,10,0,0,0,202,0,0,0,179,0,93,0,172,0,209,0,139,0,234,0,205,0,139,0,211,0,125,0,169,0,245,0,181,0,26,0);
signal scenario_full  : scenario_type := (119,31,118,31,52,31,68,31,123,31,96,31,65,31,65,30,65,29,65,28,65,27,82,31,234,31,41,31,116,31,59,31,211,31,83,31,159,31,159,30,254,31,36,31,36,30,125,31,20,31,80,31,16,31,16,30,50,31,10,31,8,31,169,31,65,31,30,31,110,31,75,31,75,30,133,31,224,31,124,31,82,31,105,31,105,30,255,31,255,30,203,31,149,31,154,31,210,31,65,31,136,31,115,31,123,31,123,30,123,29,99,31,61,31,61,30,2,31,10,31,54,31,54,30,213,31,45,31,166,31,166,30,166,29,98,31,137,31,53,31,139,31,11,31,11,30,108,31,104,31,104,30,8,31,8,30,94,31,230,31,4,31,4,30,174,31,235,31,235,30,121,31,24,31,117,31,146,31,136,31,181,31,202,31,42,31,88,31,16,31,91,31,251,31,195,31,17,31,160,31,63,31,130,31,130,30,217,31,221,31,99,31,99,30,112,31,184,31,236,31,87,31,103,31,179,31,88,31,88,30,111,31,148,31,80,31,252,31,34,31,241,31,241,30,241,31,192,31,159,31,198,31,148,31,163,31,240,31,119,31,119,30,210,31,85,31,53,31,215,31,24,31,11,31,20,31,222,31,222,30,85,31,33,31,153,31,153,30,93,31,94,31,103,31,103,30,131,31,50,31,210,31,6,31,248,31,204,31,204,30,12,31,218,31,142,31,73,31,234,31,171,31,21,31,76,31,195,31,64,31,64,30,229,31,229,30,183,31,183,30,216,31,54,31,54,30,106,31,223,31,227,31,168,31,168,31,168,30,49,31,10,31,10,30,202,31,202,30,179,31,93,31,172,31,209,31,139,31,234,31,205,31,139,31,211,31,125,31,169,31,245,31,181,31,26,31);

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
