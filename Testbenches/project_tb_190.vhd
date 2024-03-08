-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_190 is
end project_tb_190;

architecture project_tb_arch_190 of project_tb_190 is
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

constant SCENARIO_LENGTH : integer := 295;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (80,0,36,0,177,0,156,0,251,0,55,0,141,0,0,0,235,0,0,0,232,0,206,0,106,0,178,0,0,0,0,0,94,0,89,0,0,0,41,0,149,0,32,0,175,0,0,0,125,0,0,0,108,0,78,0,160,0,252,0,252,0,210,0,0,0,233,0,46,0,150,0,51,0,176,0,122,0,42,0,0,0,178,0,229,0,78,0,41,0,141,0,9,0,9,0,129,0,233,0,0,0,0,0,192,0,0,0,0,0,39,0,221,0,88,0,205,0,205,0,39,0,102,0,238,0,9,0,67,0,234,0,228,0,193,0,240,0,0,0,0,0,9,0,0,0,166,0,71,0,159,0,248,0,45,0,135,0,195,0,97,0,167,0,212,0,178,0,31,0,182,0,191,0,184,0,132,0,168,0,20,0,178,0,0,0,139,0,19,0,0,0,229,0,0,0,99,0,202,0,151,0,202,0,31,0,0,0,185,0,172,0,45,0,33,0,249,0,243,0,189,0,184,0,245,0,10,0,146,0,76,0,244,0,25,0,188,0,108,0,52,0,153,0,22,0,243,0,141,0,0,0,248,0,224,0,21,0,247,0,46,0,238,0,0,0,52,0,0,0,252,0,166,0,74,0,38,0,20,0,104,0,117,0,155,0,216,0,169,0,93,0,0,0,135,0,93,0,14,0,78,0,37,0,142,0,217,0,8,0,180,0,0,0,27,0,231,0,0,0,116,0,235,0,199,0,13,0,231,0,2,0,0,0,0,0,0,0,182,0,116,0,27,0,21,0,0,0,0,0,212,0,96,0,106,0,60,0,181,0,192,0,40,0,157,0,0,0,42,0,0,0,149,0,24,0,198,0,228,0,250,0,216,0,140,0,0,0,89,0,148,0,0,0,197,0,162,0,178,0,0,0,132,0,108,0,0,0,0,0,0,0,49,0,0,0,223,0,33,0,62,0,246,0,23,0,50,0,175,0,0,0,253,0,235,0,167,0,249,0,157,0,225,0,0,0,4,0,41,0,131,0,149,0,134,0,116,0,0,0,63,0,101,0,0,0,194,0,24,0,18,0,146,0,19,0,253,0,118,0,119,0,235,0,0,0,0,0,177,0,0,0,145,0,123,0,230,0,235,0,0,0,247,0,14,0,161,0,124,0,27,0,181,0,133,0,121,0,64,0,121,0,174,0,184,0,152,0,235,0,95,0,80,0,71,0,51,0,252,0,0,0,198,0,230,0,20,0,54,0,52,0,58,0,156,0,206,0,54,0,233,0,192,0,153,0,176,0,136,0,104,0,111,0,0,0,194,0,42,0,143,0,41,0,245,0,121,0,219,0);
signal scenario_full  : scenario_type := (80,31,36,31,177,31,156,31,251,31,55,31,141,31,141,30,235,31,235,30,232,31,206,31,106,31,178,31,178,30,178,29,94,31,89,31,89,30,41,31,149,31,32,31,175,31,175,30,125,31,125,30,108,31,78,31,160,31,252,31,252,31,210,31,210,30,233,31,46,31,150,31,51,31,176,31,122,31,42,31,42,30,178,31,229,31,78,31,41,31,141,31,9,31,9,31,129,31,233,31,233,30,233,29,192,31,192,30,192,29,39,31,221,31,88,31,205,31,205,31,39,31,102,31,238,31,9,31,67,31,234,31,228,31,193,31,240,31,240,30,240,29,9,31,9,30,166,31,71,31,159,31,248,31,45,31,135,31,195,31,97,31,167,31,212,31,178,31,31,31,182,31,191,31,184,31,132,31,168,31,20,31,178,31,178,30,139,31,19,31,19,30,229,31,229,30,99,31,202,31,151,31,202,31,31,31,31,30,185,31,172,31,45,31,33,31,249,31,243,31,189,31,184,31,245,31,10,31,146,31,76,31,244,31,25,31,188,31,108,31,52,31,153,31,22,31,243,31,141,31,141,30,248,31,224,31,21,31,247,31,46,31,238,31,238,30,52,31,52,30,252,31,166,31,74,31,38,31,20,31,104,31,117,31,155,31,216,31,169,31,93,31,93,30,135,31,93,31,14,31,78,31,37,31,142,31,217,31,8,31,180,31,180,30,27,31,231,31,231,30,116,31,235,31,199,31,13,31,231,31,2,31,2,30,2,29,2,28,182,31,116,31,27,31,21,31,21,30,21,29,212,31,96,31,106,31,60,31,181,31,192,31,40,31,157,31,157,30,42,31,42,30,149,31,24,31,198,31,228,31,250,31,216,31,140,31,140,30,89,31,148,31,148,30,197,31,162,31,178,31,178,30,132,31,108,31,108,30,108,29,108,28,49,31,49,30,223,31,33,31,62,31,246,31,23,31,50,31,175,31,175,30,253,31,235,31,167,31,249,31,157,31,225,31,225,30,4,31,41,31,131,31,149,31,134,31,116,31,116,30,63,31,101,31,101,30,194,31,24,31,18,31,146,31,19,31,253,31,118,31,119,31,235,31,235,30,235,29,177,31,177,30,145,31,123,31,230,31,235,31,235,30,247,31,14,31,161,31,124,31,27,31,181,31,133,31,121,31,64,31,121,31,174,31,184,31,152,31,235,31,95,31,80,31,71,31,51,31,252,31,252,30,198,31,230,31,20,31,54,31,52,31,58,31,156,31,206,31,54,31,233,31,192,31,153,31,176,31,136,31,104,31,111,31,111,30,194,31,42,31,143,31,41,31,245,31,121,31,219,31);

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
