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

constant SCENARIO_LENGTH : integer := 521;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (70,0,197,0,127,0,43,0,255,0,108,0,184,0,166,0,85,0,189,0,44,0,209,0,134,0,11,0,234,0,139,0,0,0,84,0,54,0,0,0,73,0,222,0,0,0,232,0,105,0,0,0,0,0,24,0,133,0,160,0,4,0,86,0,0,0,226,0,30,0,248,0,35,0,0,0,118,0,172,0,167,0,245,0,0,0,215,0,92,0,84,0,255,0,180,0,160,0,125,0,174,0,0,0,0,0,204,0,208,0,135,0,95,0,4,0,65,0,142,0,80,0,155,0,230,0,62,0,26,0,115,0,0,0,198,0,31,0,19,0,119,0,122,0,0,0,176,0,100,0,132,0,86,0,53,0,223,0,163,0,172,0,201,0,114,0,0,0,8,0,53,0,120,0,0,0,134,0,77,0,101,0,175,0,207,0,245,0,252,0,0,0,198,0,0,0,223,0,210,0,117,0,10,0,121,0,12,0,220,0,0,0,165,0,132,0,187,0,119,0,75,0,82,0,108,0,27,0,20,0,98,0,46,0,193,0,180,0,167,0,227,0,214,0,86,0,0,0,74,0,93,0,0,0,161,0,199,0,252,0,106,0,132,0,20,0,137,0,70,0,5,0,124,0,139,0,170,0,246,0,209,0,151,0,0,0,93,0,153,0,20,0,0,0,0,0,0,0,81,0,149,0,0,0,210,0,34,0,111,0,0,0,201,0,153,0,13,0,0,0,0,0,0,0,102,0,76,0,22,0,79,0,175,0,0,0,139,0,167,0,87,0,221,0,81,0,0,0,0,0,0,0,33,0,103,0,0,0,11,0,254,0,0,0,182,0,6,0,123,0,0,0,177,0,178,0,21,0,101,0,161,0,0,0,52,0,0,0,215,0,94,0,84,0,21,0,0,0,67,0,161,0,39,0,236,0,91,0,59,0,0,0,223,0,135,0,244,0,87,0,179,0,148,0,0,0,0,0,4,0,0,0,75,0,240,0,117,0,13,0,72,0,89,0,0,0,234,0,115,0,0,0,111,0,242,0,251,0,206,0,0,0,121,0,0,0,181,0,232,0,22,0,0,0,18,0,165,0,213,0,11,0,82,0,240,0,4,0,248,0,237,0,148,0,0,0,0,0,0,0,229,0,0,0,0,0,159,0,240,0,229,0,174,0,136,0,115,0,171,0,129,0,0,0,0,0,11,0,0,0,253,0,185,0,28,0,221,0,193,0,162,0,93,0,249,0,148,0,144,0,104,0,17,0,136,0,133,0,130,0,253,0,79,0,135,0,11,0,21,0,142,0,17,0,67,0,70,0,32,0,4,0,239,0,21,0,0,0,232,0,135,0,39,0,249,0,132,0,10,0,0,0,229,0,0,0,182,0,20,0,0,0,96,0,148,0,163,0,151,0,238,0,137,0,190,0,0,0,166,0,60,0,45,0,104,0,99,0,188,0,140,0,0,0,211,0,0,0,0,0,13,0,205,0,102,0,35,0,226,0,0,0,154,0,208,0,119,0,44,0,14,0,249,0,81,0,66,0,32,0,42,0,84,0,190,0,242,0,105,0,160,0,0,0,112,0,0,0,212,0,154,0,113,0,0,0,237,0,194,0,196,0,165,0,100,0,78,0,58,0,0,0,0,0,141,0,46,0,253,0,0,0,0,0,13,0,72,0,213,0,194,0,5,0,37,0,116,0,114,0,74,0,230,0,68,0,5,0,50,0,239,0,152,0,0,0,206,0,92,0,23,0,159,0,111,0,159,0,253,0,0,0,97,0,212,0,74,0,85,0,101,0,164,0,86,0,28,0,91,0,0,0,191,0,0,0,175,0,12,0,198,0,187,0,134,0,68,0,0,0,94,0,216,0,163,0,160,0,150,0,0,0,50,0,220,0,146,0,156,0,65,0,188,0,213,0,124,0,105,0,237,0,134,0,0,0,29,0,194,0,0,0,59,0,0,0,240,0,1,0,73,0,45,0,255,0,0,0,214,0,96,0,0,0,19,0,89,0,0,0,0,0,244,0,0,0,0,0,104,0,98,0,149,0,0,0,205,0,57,0,211,0,244,0,131,0,69,0,164,0,45,0,56,0,0,0,0,0,0,0,121,0,122,0,0,0,125,0,176,0,250,0,100,0,66,0,84,0,0,0,0,0,0,0,0,0,96,0,144,0,0,0,199,0,210,0,66,0,38,0,153,0,150,0,0,0,70,0,171,0,10,0,180,0,0,0,185,0,0,0,105,0,173,0,210,0,14,0,58,0,61,0,179,0,179,0,119,0,156,0,134,0,157,0,76,0,0,0,40,0,110,0,206,0,111,0,0,0,16,0,31,0,106,0,128,0,151,0,118,0,0,0);
signal scenario_full  : scenario_type := (70,31,197,31,127,31,43,31,255,31,108,31,184,31,166,31,85,31,189,31,44,31,209,31,134,31,11,31,234,31,139,31,139,30,84,31,54,31,54,30,73,31,222,31,222,30,232,31,105,31,105,30,105,29,24,31,133,31,160,31,4,31,86,31,86,30,226,31,30,31,248,31,35,31,35,30,118,31,172,31,167,31,245,31,245,30,215,31,92,31,84,31,255,31,180,31,160,31,125,31,174,31,174,30,174,29,204,31,208,31,135,31,95,31,4,31,65,31,142,31,80,31,155,31,230,31,62,31,26,31,115,31,115,30,198,31,31,31,19,31,119,31,122,31,122,30,176,31,100,31,132,31,86,31,53,31,223,31,163,31,172,31,201,31,114,31,114,30,8,31,53,31,120,31,120,30,134,31,77,31,101,31,175,31,207,31,245,31,252,31,252,30,198,31,198,30,223,31,210,31,117,31,10,31,121,31,12,31,220,31,220,30,165,31,132,31,187,31,119,31,75,31,82,31,108,31,27,31,20,31,98,31,46,31,193,31,180,31,167,31,227,31,214,31,86,31,86,30,74,31,93,31,93,30,161,31,199,31,252,31,106,31,132,31,20,31,137,31,70,31,5,31,124,31,139,31,170,31,246,31,209,31,151,31,151,30,93,31,153,31,20,31,20,30,20,29,20,28,81,31,149,31,149,30,210,31,34,31,111,31,111,30,201,31,153,31,13,31,13,30,13,29,13,28,102,31,76,31,22,31,79,31,175,31,175,30,139,31,167,31,87,31,221,31,81,31,81,30,81,29,81,28,33,31,103,31,103,30,11,31,254,31,254,30,182,31,6,31,123,31,123,30,177,31,178,31,21,31,101,31,161,31,161,30,52,31,52,30,215,31,94,31,84,31,21,31,21,30,67,31,161,31,39,31,236,31,91,31,59,31,59,30,223,31,135,31,244,31,87,31,179,31,148,31,148,30,148,29,4,31,4,30,75,31,240,31,117,31,13,31,72,31,89,31,89,30,234,31,115,31,115,30,111,31,242,31,251,31,206,31,206,30,121,31,121,30,181,31,232,31,22,31,22,30,18,31,165,31,213,31,11,31,82,31,240,31,4,31,248,31,237,31,148,31,148,30,148,29,148,28,229,31,229,30,229,29,159,31,240,31,229,31,174,31,136,31,115,31,171,31,129,31,129,30,129,29,11,31,11,30,253,31,185,31,28,31,221,31,193,31,162,31,93,31,249,31,148,31,144,31,104,31,17,31,136,31,133,31,130,31,253,31,79,31,135,31,11,31,21,31,142,31,17,31,67,31,70,31,32,31,4,31,239,31,21,31,21,30,232,31,135,31,39,31,249,31,132,31,10,31,10,30,229,31,229,30,182,31,20,31,20,30,96,31,148,31,163,31,151,31,238,31,137,31,190,31,190,30,166,31,60,31,45,31,104,31,99,31,188,31,140,31,140,30,211,31,211,30,211,29,13,31,205,31,102,31,35,31,226,31,226,30,154,31,208,31,119,31,44,31,14,31,249,31,81,31,66,31,32,31,42,31,84,31,190,31,242,31,105,31,160,31,160,30,112,31,112,30,212,31,154,31,113,31,113,30,237,31,194,31,196,31,165,31,100,31,78,31,58,31,58,30,58,29,141,31,46,31,253,31,253,30,253,29,13,31,72,31,213,31,194,31,5,31,37,31,116,31,114,31,74,31,230,31,68,31,5,31,50,31,239,31,152,31,152,30,206,31,92,31,23,31,159,31,111,31,159,31,253,31,253,30,97,31,212,31,74,31,85,31,101,31,164,31,86,31,28,31,91,31,91,30,191,31,191,30,175,31,12,31,198,31,187,31,134,31,68,31,68,30,94,31,216,31,163,31,160,31,150,31,150,30,50,31,220,31,146,31,156,31,65,31,188,31,213,31,124,31,105,31,237,31,134,31,134,30,29,31,194,31,194,30,59,31,59,30,240,31,1,31,73,31,45,31,255,31,255,30,214,31,96,31,96,30,19,31,89,31,89,30,89,29,244,31,244,30,244,29,104,31,98,31,149,31,149,30,205,31,57,31,211,31,244,31,131,31,69,31,164,31,45,31,56,31,56,30,56,29,56,28,121,31,122,31,122,30,125,31,176,31,250,31,100,31,66,31,84,31,84,30,84,29,84,28,84,27,96,31,144,31,144,30,199,31,210,31,66,31,38,31,153,31,150,31,150,30,70,31,171,31,10,31,180,31,180,30,185,31,185,30,105,31,173,31,210,31,14,31,58,31,61,31,179,31,179,31,119,31,156,31,134,31,157,31,76,31,76,30,40,31,110,31,206,31,111,31,111,30,16,31,31,31,106,31,128,31,151,31,118,31,118,30);

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
