-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_738 is
end project_tb_738;

architecture project_tb_arch_738 of project_tb_738 is
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

constant SCENARIO_LENGTH : integer := 224;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (21,0,0,0,60,0,0,0,250,0,212,0,103,0,90,0,212,0,63,0,203,0,135,0,111,0,75,0,106,0,102,0,82,0,194,0,0,0,0,0,226,0,0,0,0,0,209,0,133,0,144,0,226,0,188,0,149,0,248,0,105,0,77,0,142,0,0,0,55,0,63,0,39,0,122,0,93,0,136,0,230,0,120,0,88,0,166,0,117,0,42,0,34,0,94,0,0,0,232,0,185,0,88,0,189,0,0,0,0,0,191,0,76,0,64,0,0,0,209,0,173,0,50,0,48,0,41,0,0,0,176,0,87,0,15,0,49,0,86,0,193,0,0,0,228,0,24,0,0,0,32,0,0,0,98,0,182,0,195,0,0,0,142,0,176,0,38,0,0,0,0,0,96,0,90,0,22,0,0,0,52,0,0,0,111,0,39,0,72,0,7,0,27,0,159,0,195,0,133,0,186,0,0,0,48,0,164,0,148,0,0,0,25,0,231,0,249,0,214,0,129,0,154,0,121,0,65,0,195,0,19,0,210,0,0,0,0,0,0,0,186,0,207,0,239,0,43,0,228,0,0,0,0,0,0,0,0,0,191,0,154,0,0,0,0,0,249,0,61,0,96,0,177,0,0,0,9,0,43,0,0,0,86,0,200,0,0,0,227,0,180,0,0,0,190,0,129,0,103,0,179,0,248,0,63,0,0,0,200,0,231,0,200,0,72,0,0,0,183,0,177,0,156,0,209,0,198,0,15,0,0,0,229,0,31,0,238,0,193,0,101,0,222,0,230,0,72,0,190,0,194,0,0,0,0,0,10,0,0,0,188,0,0,0,0,0,0,0,190,0,65,0,246,0,157,0,77,0,62,0,241,0,62,0,0,0,0,0,0,0,227,0,25,0,97,0,147,0,57,0,81,0,159,0,215,0,178,0,0,0,0,0,135,0,31,0,0,0,52,0,234,0,0,0,23,0,232,0,230,0,50,0,215,0,96,0,183,0,158,0,0,0,91,0,159,0,142,0);
signal scenario_full  : scenario_type := (21,31,21,30,60,31,60,30,250,31,212,31,103,31,90,31,212,31,63,31,203,31,135,31,111,31,75,31,106,31,102,31,82,31,194,31,194,30,194,29,226,31,226,30,226,29,209,31,133,31,144,31,226,31,188,31,149,31,248,31,105,31,77,31,142,31,142,30,55,31,63,31,39,31,122,31,93,31,136,31,230,31,120,31,88,31,166,31,117,31,42,31,34,31,94,31,94,30,232,31,185,31,88,31,189,31,189,30,189,29,191,31,76,31,64,31,64,30,209,31,173,31,50,31,48,31,41,31,41,30,176,31,87,31,15,31,49,31,86,31,193,31,193,30,228,31,24,31,24,30,32,31,32,30,98,31,182,31,195,31,195,30,142,31,176,31,38,31,38,30,38,29,96,31,90,31,22,31,22,30,52,31,52,30,111,31,39,31,72,31,7,31,27,31,159,31,195,31,133,31,186,31,186,30,48,31,164,31,148,31,148,30,25,31,231,31,249,31,214,31,129,31,154,31,121,31,65,31,195,31,19,31,210,31,210,30,210,29,210,28,186,31,207,31,239,31,43,31,228,31,228,30,228,29,228,28,228,27,191,31,154,31,154,30,154,29,249,31,61,31,96,31,177,31,177,30,9,31,43,31,43,30,86,31,200,31,200,30,227,31,180,31,180,30,190,31,129,31,103,31,179,31,248,31,63,31,63,30,200,31,231,31,200,31,72,31,72,30,183,31,177,31,156,31,209,31,198,31,15,31,15,30,229,31,31,31,238,31,193,31,101,31,222,31,230,31,72,31,190,31,194,31,194,30,194,29,10,31,10,30,188,31,188,30,188,29,188,28,190,31,65,31,246,31,157,31,77,31,62,31,241,31,62,31,62,30,62,29,62,28,227,31,25,31,97,31,147,31,57,31,81,31,159,31,215,31,178,31,178,30,178,29,135,31,31,31,31,30,52,31,234,31,234,30,23,31,232,31,230,31,50,31,215,31,96,31,183,31,158,31,158,30,91,31,159,31,142,31);

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
