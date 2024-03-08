-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_30 is
end project_tb_30;

architecture project_tb_arch_30 of project_tb_30 is
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

constant SCENARIO_LENGTH : integer := 268;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (107,0,248,0,0,0,218,0,32,0,0,0,136,0,103,0,77,0,86,0,146,0,0,0,254,0,55,0,136,0,73,0,206,0,123,0,205,0,76,0,0,0,0,0,49,0,235,0,192,0,121,0,0,0,132,0,0,0,33,0,141,0,0,0,0,0,57,0,0,0,0,0,54,0,0,0,0,0,0,0,36,0,209,0,128,0,55,0,0,0,0,0,84,0,0,0,0,0,59,0,0,0,0,0,19,0,0,0,119,0,68,0,25,0,0,0,101,0,56,0,151,0,251,0,128,0,0,0,0,0,189,0,103,0,185,0,90,0,42,0,153,0,30,0,79,0,53,0,170,0,119,0,213,0,130,0,239,0,0,0,219,0,0,0,125,0,178,0,40,0,122,0,108,0,0,0,148,0,249,0,154,0,171,0,23,0,229,0,78,0,40,0,0,0,72,0,168,0,128,0,235,0,24,0,114,0,179,0,171,0,0,0,5,0,21,0,248,0,198,0,0,0,0,0,199,0,109,0,97,0,169,0,93,0,173,0,0,0,203,0,141,0,51,0,147,0,0,0,32,0,39,0,95,0,198,0,81,0,224,0,113,0,163,0,0,0,223,0,153,0,233,0,208,0,59,0,148,0,227,0,176,0,208,0,237,0,185,0,133,0,0,0,0,0,103,0,172,0,0,0,42,0,106,0,0,0,234,0,132,0,0,0,86,0,214,0,229,0,181,0,232,0,159,0,120,0,0,0,155,0,179,0,0,0,184,0,8,0,234,0,223,0,146,0,235,0,244,0,248,0,0,0,212,0,156,0,66,0,176,0,244,0,144,0,144,0,145,0,0,0,218,0,6,0,120,0,0,0,0,0,0,0,0,0,0,0,88,0,94,0,70,0,208,0,0,0,94,0,177,0,185,0,0,0,29,0,232,0,203,0,218,0,100,0,165,0,0,0,26,0,115,0,74,0,230,0,28,0,141,0,122,0,249,0,187,0,56,0,0,0,0,0,198,0,61,0,40,0,161,0,76,0,1,0,112,0,105,0,0,0,201,0,0,0,104,0,3,0,228,0,0,0,185,0,121,0,0,0,94,0,122,0,100,0,242,0,0,0,29,0,0,0,190,0,14,0,145,0,248,0,0,0,39,0,255,0,77,0,32,0,107,0,209,0,112,0,0,0,0,0,0,0,116,0,0,0,0,0,151,0,42,0,27,0,0,0);
signal scenario_full  : scenario_type := (107,31,248,31,248,30,218,31,32,31,32,30,136,31,103,31,77,31,86,31,146,31,146,30,254,31,55,31,136,31,73,31,206,31,123,31,205,31,76,31,76,30,76,29,49,31,235,31,192,31,121,31,121,30,132,31,132,30,33,31,141,31,141,30,141,29,57,31,57,30,57,29,54,31,54,30,54,29,54,28,36,31,209,31,128,31,55,31,55,30,55,29,84,31,84,30,84,29,59,31,59,30,59,29,19,31,19,30,119,31,68,31,25,31,25,30,101,31,56,31,151,31,251,31,128,31,128,30,128,29,189,31,103,31,185,31,90,31,42,31,153,31,30,31,79,31,53,31,170,31,119,31,213,31,130,31,239,31,239,30,219,31,219,30,125,31,178,31,40,31,122,31,108,31,108,30,148,31,249,31,154,31,171,31,23,31,229,31,78,31,40,31,40,30,72,31,168,31,128,31,235,31,24,31,114,31,179,31,171,31,171,30,5,31,21,31,248,31,198,31,198,30,198,29,199,31,109,31,97,31,169,31,93,31,173,31,173,30,203,31,141,31,51,31,147,31,147,30,32,31,39,31,95,31,198,31,81,31,224,31,113,31,163,31,163,30,223,31,153,31,233,31,208,31,59,31,148,31,227,31,176,31,208,31,237,31,185,31,133,31,133,30,133,29,103,31,172,31,172,30,42,31,106,31,106,30,234,31,132,31,132,30,86,31,214,31,229,31,181,31,232,31,159,31,120,31,120,30,155,31,179,31,179,30,184,31,8,31,234,31,223,31,146,31,235,31,244,31,248,31,248,30,212,31,156,31,66,31,176,31,244,31,144,31,144,31,145,31,145,30,218,31,6,31,120,31,120,30,120,29,120,28,120,27,120,26,88,31,94,31,70,31,208,31,208,30,94,31,177,31,185,31,185,30,29,31,232,31,203,31,218,31,100,31,165,31,165,30,26,31,115,31,74,31,230,31,28,31,141,31,122,31,249,31,187,31,56,31,56,30,56,29,198,31,61,31,40,31,161,31,76,31,1,31,112,31,105,31,105,30,201,31,201,30,104,31,3,31,228,31,228,30,185,31,121,31,121,30,94,31,122,31,100,31,242,31,242,30,29,31,29,30,190,31,14,31,145,31,248,31,248,30,39,31,255,31,77,31,32,31,107,31,209,31,112,31,112,30,112,29,112,28,116,31,116,30,116,29,151,31,42,31,27,31,27,30);

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
