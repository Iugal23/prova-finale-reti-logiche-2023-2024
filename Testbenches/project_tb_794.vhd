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

constant SCENARIO_LENGTH : integer := 291;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,115,0,175,0,48,0,249,0,0,0,236,0,182,0,0,0,143,0,42,0,0,0,46,0,0,0,0,0,0,0,0,0,182,0,133,0,0,0,12,0,83,0,203,0,0,0,40,0,113,0,68,0,105,0,65,0,158,0,0,0,212,0,106,0,224,0,3,0,124,0,71,0,0,0,68,0,118,0,226,0,0,0,174,0,120,0,95,0,147,0,71,0,0,0,128,0,166,0,0,0,114,0,7,0,36,0,66,0,255,0,249,0,70,0,97,0,0,0,238,0,174,0,23,0,208,0,104,0,0,0,154,0,170,0,137,0,221,0,0,0,109,0,177,0,255,0,191,0,121,0,103,0,0,0,200,0,64,0,221,0,126,0,0,0,110,0,180,0,0,0,50,0,63,0,209,0,105,0,65,0,16,0,180,0,0,0,232,0,0,0,0,0,0,0,173,0,11,0,181,0,37,0,74,0,39,0,170,0,199,0,0,0,246,0,94,0,188,0,16,0,40,0,172,0,55,0,169,0,31,0,144,0,159,0,79,0,84,0,219,0,255,0,195,0,53,0,111,0,72,0,41,0,44,0,0,0,168,0,253,0,0,0,34,0,40,0,46,0,104,0,0,0,49,0,0,0,86,0,0,0,0,0,252,0,35,0,0,0,62,0,127,0,59,0,0,0,40,0,5,0,146,0,222,0,167,0,199,0,0,0,214,0,0,0,59,0,0,0,18,0,91,0,134,0,6,0,0,0,125,0,0,0,9,0,149,0,107,0,155,0,0,0,187,0,82,0,250,0,27,0,100,0,0,0,186,0,214,0,0,0,0,0,0,0,228,0,158,0,166,0,173,0,0,0,62,0,214,0,39,0,0,0,0,0,0,0,24,0,63,0,89,0,222,0,8,0,33,0,38,0,0,0,238,0,53,0,0,0,79,0,0,0,0,0,0,0,157,0,141,0,3,0,161,0,215,0,187,0,150,0,202,0,233,0,16,0,227,0,96,0,245,0,108,0,0,0,145,0,0,0,136,0,0,0,156,0,181,0,72,0,175,0,0,0,108,0,0,0,193,0,0,0,0,0,12,0,248,0,4,0,122,0,0,0,17,0,148,0,97,0,189,0,232,0,209,0,0,0,86,0,23,0,222,0,232,0,43,0,155,0,0,0,54,0,0,0,159,0,123,0,201,0,164,0,199,0,141,0,59,0,146,0,0,0,23,0,185,0,133,0,0,0,246,0,0,0,9,0,53,0,72,0,249,0,0,0,55,0,0,0,113,0,36,0,172,0,136,0,0,0,63,0,72,0,109,0,117,0,182,0);
signal scenario_full  : scenario_type := (0,0,115,31,175,31,48,31,249,31,249,30,236,31,182,31,182,30,143,31,42,31,42,30,46,31,46,30,46,29,46,28,46,27,182,31,133,31,133,30,12,31,83,31,203,31,203,30,40,31,113,31,68,31,105,31,65,31,158,31,158,30,212,31,106,31,224,31,3,31,124,31,71,31,71,30,68,31,118,31,226,31,226,30,174,31,120,31,95,31,147,31,71,31,71,30,128,31,166,31,166,30,114,31,7,31,36,31,66,31,255,31,249,31,70,31,97,31,97,30,238,31,174,31,23,31,208,31,104,31,104,30,154,31,170,31,137,31,221,31,221,30,109,31,177,31,255,31,191,31,121,31,103,31,103,30,200,31,64,31,221,31,126,31,126,30,110,31,180,31,180,30,50,31,63,31,209,31,105,31,65,31,16,31,180,31,180,30,232,31,232,30,232,29,232,28,173,31,11,31,181,31,37,31,74,31,39,31,170,31,199,31,199,30,246,31,94,31,188,31,16,31,40,31,172,31,55,31,169,31,31,31,144,31,159,31,79,31,84,31,219,31,255,31,195,31,53,31,111,31,72,31,41,31,44,31,44,30,168,31,253,31,253,30,34,31,40,31,46,31,104,31,104,30,49,31,49,30,86,31,86,30,86,29,252,31,35,31,35,30,62,31,127,31,59,31,59,30,40,31,5,31,146,31,222,31,167,31,199,31,199,30,214,31,214,30,59,31,59,30,18,31,91,31,134,31,6,31,6,30,125,31,125,30,9,31,149,31,107,31,155,31,155,30,187,31,82,31,250,31,27,31,100,31,100,30,186,31,214,31,214,30,214,29,214,28,228,31,158,31,166,31,173,31,173,30,62,31,214,31,39,31,39,30,39,29,39,28,24,31,63,31,89,31,222,31,8,31,33,31,38,31,38,30,238,31,53,31,53,30,79,31,79,30,79,29,79,28,157,31,141,31,3,31,161,31,215,31,187,31,150,31,202,31,233,31,16,31,227,31,96,31,245,31,108,31,108,30,145,31,145,30,136,31,136,30,156,31,181,31,72,31,175,31,175,30,108,31,108,30,193,31,193,30,193,29,12,31,248,31,4,31,122,31,122,30,17,31,148,31,97,31,189,31,232,31,209,31,209,30,86,31,23,31,222,31,232,31,43,31,155,31,155,30,54,31,54,30,159,31,123,31,201,31,164,31,199,31,141,31,59,31,146,31,146,30,23,31,185,31,133,31,133,30,246,31,246,30,9,31,53,31,72,31,249,31,249,30,55,31,55,30,113,31,36,31,172,31,136,31,136,30,63,31,72,31,109,31,117,31,182,31);

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
