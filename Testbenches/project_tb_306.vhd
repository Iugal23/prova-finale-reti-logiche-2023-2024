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

constant SCENARIO_LENGTH : integer := 178;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,169,0,198,0,125,0,99,0,10,0,73,0,0,0,232,0,194,0,158,0,186,0,239,0,8,0,30,0,0,0,124,0,74,0,0,0,128,0,117,0,105,0,88,0,0,0,26,0,54,0,121,0,179,0,23,0,0,0,180,0,48,0,0,0,239,0,72,0,11,0,126,0,202,0,0,0,84,0,128,0,0,0,66,0,0,0,245,0,22,0,132,0,52,0,0,0,186,0,0,0,110,0,120,0,146,0,0,0,176,0,43,0,195,0,3,0,125,0,6,0,0,0,233,0,139,0,106,0,119,0,0,0,0,0,41,0,133,0,0,0,155,0,70,0,13,0,19,0,0,0,0,0,0,0,0,0,0,0,0,0,32,0,79,0,81,0,0,0,80,0,233,0,149,0,214,0,99,0,11,0,179,0,0,0,248,0,166,0,0,0,199,0,0,0,196,0,113,0,69,0,67,0,171,0,132,0,12,0,203,0,23,0,155,0,0,0,186,0,86,0,207,0,245,0,232,0,0,0,0,0,230,0,245,0,239,0,179,0,34,0,0,0,0,0,43,0,0,0,235,0,44,0,193,0,52,0,25,0,159,0,39,0,139,0,175,0,164,0,226,0,27,0,144,0,119,0,11,0,1,0,118,0,189,0,133,0,0,0,0,0,4,0,224,0,170,0,42,0,0,0,126,0,0,0,0,0,82,0,0,0,245,0,0,0,0,0,123,0,69,0,0,0,177,0,71,0,227,0,0,0,7,0,239,0,231,0,0,0,93,0,216,0,43,0,208,0,37,0,220,0,249,0,209,0);
signal scenario_full  : scenario_type := (0,0,169,31,198,31,125,31,99,31,10,31,73,31,73,30,232,31,194,31,158,31,186,31,239,31,8,31,30,31,30,30,124,31,74,31,74,30,128,31,117,31,105,31,88,31,88,30,26,31,54,31,121,31,179,31,23,31,23,30,180,31,48,31,48,30,239,31,72,31,11,31,126,31,202,31,202,30,84,31,128,31,128,30,66,31,66,30,245,31,22,31,132,31,52,31,52,30,186,31,186,30,110,31,120,31,146,31,146,30,176,31,43,31,195,31,3,31,125,31,6,31,6,30,233,31,139,31,106,31,119,31,119,30,119,29,41,31,133,31,133,30,155,31,70,31,13,31,19,31,19,30,19,29,19,28,19,27,19,26,19,25,32,31,79,31,81,31,81,30,80,31,233,31,149,31,214,31,99,31,11,31,179,31,179,30,248,31,166,31,166,30,199,31,199,30,196,31,113,31,69,31,67,31,171,31,132,31,12,31,203,31,23,31,155,31,155,30,186,31,86,31,207,31,245,31,232,31,232,30,232,29,230,31,245,31,239,31,179,31,34,31,34,30,34,29,43,31,43,30,235,31,44,31,193,31,52,31,25,31,159,31,39,31,139,31,175,31,164,31,226,31,27,31,144,31,119,31,11,31,1,31,118,31,189,31,133,31,133,30,133,29,4,31,224,31,170,31,42,31,42,30,126,31,126,30,126,29,82,31,82,30,245,31,245,30,245,29,123,31,69,31,69,30,177,31,71,31,227,31,227,30,7,31,239,31,231,31,231,30,93,31,216,31,43,31,208,31,37,31,220,31,249,31,209,31);

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
