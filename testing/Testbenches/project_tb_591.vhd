-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_591 is
end project_tb_591;

architecture project_tb_arch_591 of project_tb_591 is
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

constant SCENARIO_LENGTH : integer := 433;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (84,0,0,0,109,0,0,0,224,0,52,0,0,0,109,0,150,0,98,0,111,0,207,0,150,0,174,0,198,0,0,0,12,0,0,0,252,0,19,0,0,0,128,0,249,0,120,0,193,0,241,0,0,0,3,0,21,0,30,0,157,0,226,0,219,0,164,0,242,0,142,0,161,0,83,0,0,0,108,0,0,0,0,0,0,0,86,0,0,0,0,0,31,0,166,0,153,0,0,0,111,0,0,0,18,0,85,0,125,0,20,0,245,0,220,0,0,0,227,0,0,0,0,0,156,0,0,0,69,0,6,0,145,0,11,0,138,0,123,0,250,0,206,0,194,0,136,0,82,0,64,0,9,0,163,0,235,0,0,0,190,0,42,0,49,0,149,0,87,0,159,0,87,0,0,0,203,0,0,0,179,0,229,0,210,0,0,0,0,0,0,0,111,0,114,0,82,0,249,0,221,0,0,0,0,0,151,0,0,0,110,0,199,0,12,0,212,0,21,0,210,0,113,0,139,0,164,0,7,0,145,0,192,0,50,0,28,0,55,0,201,0,27,0,193,0,0,0,115,0,0,0,81,0,0,0,18,0,56,0,10,0,0,0,0,0,0,0,0,0,0,0,244,0,227,0,46,0,31,0,122,0,3,0,148,0,5,0,30,0,212,0,156,0,221,0,0,0,166,0,151,0,168,0,27,0,0,0,148,0,73,0,78,0,63,0,126,0,0,0,169,0,0,0,200,0,39,0,0,0,123,0,143,0,36,0,252,0,96,0,100,0,145,0,214,0,0,0,24,0,162,0,0,0,231,0,45,0,0,0,210,0,0,0,218,0,0,0,111,0,32,0,14,0,150,0,192,0,10,0,220,0,226,0,43,0,0,0,0,0,14,0,36,0,109,0,0,0,12,0,65,0,43,0,21,0,45,0,0,0,142,0,0,0,0,0,110,0,0,0,183,0,118,0,145,0,0,0,6,0,139,0,86,0,251,0,237,0,21,0,51,0,243,0,76,0,47,0,162,0,251,0,156,0,96,0,72,0,134,0,2,0,105,0,77,0,38,0,0,0,169,0,0,0,37,0,0,0,32,0,52,0,141,0,79,0,15,0,0,0,251,0,31,0,75,0,157,0,36,0,139,0,204,0,121,0,87,0,54,0,229,0,25,0,0,0,203,0,48,0,172,0,0,0,80,0,71,0,196,0,192,0,12,0,0,0,13,0,239,0,1,0,228,0,193,0,211,0,0,0,170,0,5,0,188,0,152,0,232,0,0,0,170,0,0,0,14,0,246,0,133,0,253,0,86,0,236,0,18,0,137,0,0,0,3,0,54,0,143,0,0,0,14,0,15,0,72,0,0,0,0,0,154,0,164,0,38,0,250,0,2,0,36,0,62,0,51,0,48,0,214,0,0,0,0,0,186,0,0,0,236,0,67,0,55,0,100,0,0,0,78,0,98,0,0,0,105,0,6,0,74,0,171,0,220,0,80,0,57,0,211,0,100,0,129,0,250,0,149,0,0,0,141,0,215,0,245,0,251,0,183,0,0,0,118,0,230,0,122,0,65,0,249,0,0,0,183,0,50,0,0,0,1,0,137,0,48,0,0,0,96,0,0,0,116,0,0,0,185,0,250,0,132,0,184,0,55,0,156,0,114,0,0,0,190,0,42,0,129,0,121,0,0,0,0,0,146,0,144,0,0,0,65,0,124,0,201,0,224,0,85,0,64,0,97,0,48,0,89,0,103,0,231,0,105,0,196,0,28,0,190,0,0,0,236,0,0,0,164,0,252,0,33,0,153,0,51,0,152,0,241,0,189,0,0,0,157,0,25,0,0,0,68,0,94,0,243,0,0,0,218,0,142,0,0,0,0,0,62,0,220,0,161,0,0,0,0,0,88,0,225,0,79,0,116,0,0,0,0,0,0,0,0,0,28,0,29,0,95,0,0,0,227,0,44,0);
signal scenario_full  : scenario_type := (84,31,84,30,109,31,109,30,224,31,52,31,52,30,109,31,150,31,98,31,111,31,207,31,150,31,174,31,198,31,198,30,12,31,12,30,252,31,19,31,19,30,128,31,249,31,120,31,193,31,241,31,241,30,3,31,21,31,30,31,157,31,226,31,219,31,164,31,242,31,142,31,161,31,83,31,83,30,108,31,108,30,108,29,108,28,86,31,86,30,86,29,31,31,166,31,153,31,153,30,111,31,111,30,18,31,85,31,125,31,20,31,245,31,220,31,220,30,227,31,227,30,227,29,156,31,156,30,69,31,6,31,145,31,11,31,138,31,123,31,250,31,206,31,194,31,136,31,82,31,64,31,9,31,163,31,235,31,235,30,190,31,42,31,49,31,149,31,87,31,159,31,87,31,87,30,203,31,203,30,179,31,229,31,210,31,210,30,210,29,210,28,111,31,114,31,82,31,249,31,221,31,221,30,221,29,151,31,151,30,110,31,199,31,12,31,212,31,21,31,210,31,113,31,139,31,164,31,7,31,145,31,192,31,50,31,28,31,55,31,201,31,27,31,193,31,193,30,115,31,115,30,81,31,81,30,18,31,56,31,10,31,10,30,10,29,10,28,10,27,10,26,244,31,227,31,46,31,31,31,122,31,3,31,148,31,5,31,30,31,212,31,156,31,221,31,221,30,166,31,151,31,168,31,27,31,27,30,148,31,73,31,78,31,63,31,126,31,126,30,169,31,169,30,200,31,39,31,39,30,123,31,143,31,36,31,252,31,96,31,100,31,145,31,214,31,214,30,24,31,162,31,162,30,231,31,45,31,45,30,210,31,210,30,218,31,218,30,111,31,32,31,14,31,150,31,192,31,10,31,220,31,226,31,43,31,43,30,43,29,14,31,36,31,109,31,109,30,12,31,65,31,43,31,21,31,45,31,45,30,142,31,142,30,142,29,110,31,110,30,183,31,118,31,145,31,145,30,6,31,139,31,86,31,251,31,237,31,21,31,51,31,243,31,76,31,47,31,162,31,251,31,156,31,96,31,72,31,134,31,2,31,105,31,77,31,38,31,38,30,169,31,169,30,37,31,37,30,32,31,52,31,141,31,79,31,15,31,15,30,251,31,31,31,75,31,157,31,36,31,139,31,204,31,121,31,87,31,54,31,229,31,25,31,25,30,203,31,48,31,172,31,172,30,80,31,71,31,196,31,192,31,12,31,12,30,13,31,239,31,1,31,228,31,193,31,211,31,211,30,170,31,5,31,188,31,152,31,232,31,232,30,170,31,170,30,14,31,246,31,133,31,253,31,86,31,236,31,18,31,137,31,137,30,3,31,54,31,143,31,143,30,14,31,15,31,72,31,72,30,72,29,154,31,164,31,38,31,250,31,2,31,36,31,62,31,51,31,48,31,214,31,214,30,214,29,186,31,186,30,236,31,67,31,55,31,100,31,100,30,78,31,98,31,98,30,105,31,6,31,74,31,171,31,220,31,80,31,57,31,211,31,100,31,129,31,250,31,149,31,149,30,141,31,215,31,245,31,251,31,183,31,183,30,118,31,230,31,122,31,65,31,249,31,249,30,183,31,50,31,50,30,1,31,137,31,48,31,48,30,96,31,96,30,116,31,116,30,185,31,250,31,132,31,184,31,55,31,156,31,114,31,114,30,190,31,42,31,129,31,121,31,121,30,121,29,146,31,144,31,144,30,65,31,124,31,201,31,224,31,85,31,64,31,97,31,48,31,89,31,103,31,231,31,105,31,196,31,28,31,190,31,190,30,236,31,236,30,164,31,252,31,33,31,153,31,51,31,152,31,241,31,189,31,189,30,157,31,25,31,25,30,68,31,94,31,243,31,243,30,218,31,142,31,142,30,142,29,62,31,220,31,161,31,161,30,161,29,88,31,225,31,79,31,116,31,116,30,116,29,116,28,116,27,28,31,29,31,95,31,95,30,227,31,44,31);

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
