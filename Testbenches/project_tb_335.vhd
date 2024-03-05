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

constant SCENARIO_LENGTH : integer := 413;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (5,0,18,0,35,0,208,0,218,0,178,0,97,0,130,0,36,0,0,0,103,0,2,0,169,0,132,0,167,0,106,0,178,0,126,0,175,0,127,0,96,0,0,0,157,0,68,0,190,0,35,0,35,0,103,0,7,0,53,0,178,0,240,0,0,0,88,0,251,0,187,0,222,0,97,0,143,0,0,0,24,0,167,0,19,0,60,0,27,0,0,0,249,0,236,0,171,0,0,0,69,0,152,0,11,0,0,0,122,0,229,0,25,0,98,0,246,0,23,0,76,0,0,0,173,0,235,0,3,0,17,0,0,0,90,0,251,0,95,0,126,0,0,0,150,0,134,0,30,0,0,0,209,0,0,0,0,0,179,0,10,0,242,0,224,0,61,0,239,0,0,0,18,0,0,0,99,0,112,0,169,0,58,0,142,0,178,0,68,0,214,0,75,0,217,0,195,0,196,0,145,0,0,0,0,0,151,0,229,0,0,0,98,0,175,0,11,0,36,0,134,0,48,0,36,0,243,0,0,0,67,0,115,0,178,0,197,0,44,0,117,0,144,0,0,0,0,0,42,0,94,0,230,0,161,0,0,0,0,0,136,0,25,0,0,0,0,0,0,0,34,0,40,0,79,0,208,0,7,0,203,0,0,0,132,0,161,0,10,0,0,0,214,0,150,0,120,0,0,0,125,0,0,0,81,0,0,0,5,0,93,0,0,0,188,0,27,0,142,0,249,0,95,0,75,0,247,0,0,0,17,0,234,0,81,0,237,0,0,0,212,0,213,0,129,0,74,0,248,0,70,0,87,0,70,0,140,0,32,0,0,0,151,0,201,0,201,0,156,0,173,0,83,0,219,0,101,0,77,0,140,0,214,0,176,0,28,0,0,0,138,0,69,0,12,0,37,0,199,0,72,0,0,0,140,0,21,0,172,0,153,0,0,0,24,0,160,0,0,0,106,0,230,0,127,0,11,0,127,0,68,0,0,0,175,0,129,0,65,0,142,0,15,0,109,0,197,0,191,0,116,0,3,0,227,0,15,0,0,0,0,0,69,0,101,0,174,0,158,0,218,0,160,0,88,0,163,0,88,0,153,0,44,0,252,0,211,0,219,0,44,0,70,0,211,0,0,0,75,0,217,0,36,0,19,0,0,0,210,0,0,0,0,0,0,0,191,0,219,0,0,0,0,0,117,0,1,0,0,0,202,0,0,0,241,0,209,0,114,0,108,0,249,0,0,0,140,0,238,0,100,0,145,0,26,0,147,0,123,0,59,0,0,0,26,0,118,0,6,0,0,0,188,0,42,0,173,0,32,0,17,0,75,0,73,0,127,0,195,0,220,0,228,0,197,0,214,0,138,0,136,0,191,0,31,0,94,0,104,0,97,0,204,0,0,0,48,0,240,0,219,0,16,0,0,0,122,0,115,0,144,0,57,0,166,0,0,0,152,0,9,0,71,0,0,0,0,0,245,0,172,0,162,0,34,0,70,0,14,0,159,0,205,0,0,0,0,0,62,0,136,0,81,0,85,0,133,0,233,0,231,0,203,0,112,0,155,0,105,0,26,0,42,0,10,0,0,0,0,0,219,0,0,0,86,0,124,0,240,0,107,0,113,0,94,0,9,0,193,0,0,0,212,0,30,0,251,0,208,0,145,0,124,0,0,0,71,0,77,0,39,0,0,0,200,0,122,0,200,0,0,0,167,0,76,0,215,0,237,0,210,0,202,0,114,0,206,0,63,0,0,0,0,0,0,0,236,0,163,0,112,0,145,0,114,0,100,0,209,0,75,0,0,0,89,0,214,0,0,0,72,0,87,0,82,0,190,0,36,0,255,0,0,0,195,0,128,0,93,0,149,0,54,0,247,0);
signal scenario_full  : scenario_type := (5,31,18,31,35,31,208,31,218,31,178,31,97,31,130,31,36,31,36,30,103,31,2,31,169,31,132,31,167,31,106,31,178,31,126,31,175,31,127,31,96,31,96,30,157,31,68,31,190,31,35,31,35,31,103,31,7,31,53,31,178,31,240,31,240,30,88,31,251,31,187,31,222,31,97,31,143,31,143,30,24,31,167,31,19,31,60,31,27,31,27,30,249,31,236,31,171,31,171,30,69,31,152,31,11,31,11,30,122,31,229,31,25,31,98,31,246,31,23,31,76,31,76,30,173,31,235,31,3,31,17,31,17,30,90,31,251,31,95,31,126,31,126,30,150,31,134,31,30,31,30,30,209,31,209,30,209,29,179,31,10,31,242,31,224,31,61,31,239,31,239,30,18,31,18,30,99,31,112,31,169,31,58,31,142,31,178,31,68,31,214,31,75,31,217,31,195,31,196,31,145,31,145,30,145,29,151,31,229,31,229,30,98,31,175,31,11,31,36,31,134,31,48,31,36,31,243,31,243,30,67,31,115,31,178,31,197,31,44,31,117,31,144,31,144,30,144,29,42,31,94,31,230,31,161,31,161,30,161,29,136,31,25,31,25,30,25,29,25,28,34,31,40,31,79,31,208,31,7,31,203,31,203,30,132,31,161,31,10,31,10,30,214,31,150,31,120,31,120,30,125,31,125,30,81,31,81,30,5,31,93,31,93,30,188,31,27,31,142,31,249,31,95,31,75,31,247,31,247,30,17,31,234,31,81,31,237,31,237,30,212,31,213,31,129,31,74,31,248,31,70,31,87,31,70,31,140,31,32,31,32,30,151,31,201,31,201,31,156,31,173,31,83,31,219,31,101,31,77,31,140,31,214,31,176,31,28,31,28,30,138,31,69,31,12,31,37,31,199,31,72,31,72,30,140,31,21,31,172,31,153,31,153,30,24,31,160,31,160,30,106,31,230,31,127,31,11,31,127,31,68,31,68,30,175,31,129,31,65,31,142,31,15,31,109,31,197,31,191,31,116,31,3,31,227,31,15,31,15,30,15,29,69,31,101,31,174,31,158,31,218,31,160,31,88,31,163,31,88,31,153,31,44,31,252,31,211,31,219,31,44,31,70,31,211,31,211,30,75,31,217,31,36,31,19,31,19,30,210,31,210,30,210,29,210,28,191,31,219,31,219,30,219,29,117,31,1,31,1,30,202,31,202,30,241,31,209,31,114,31,108,31,249,31,249,30,140,31,238,31,100,31,145,31,26,31,147,31,123,31,59,31,59,30,26,31,118,31,6,31,6,30,188,31,42,31,173,31,32,31,17,31,75,31,73,31,127,31,195,31,220,31,228,31,197,31,214,31,138,31,136,31,191,31,31,31,94,31,104,31,97,31,204,31,204,30,48,31,240,31,219,31,16,31,16,30,122,31,115,31,144,31,57,31,166,31,166,30,152,31,9,31,71,31,71,30,71,29,245,31,172,31,162,31,34,31,70,31,14,31,159,31,205,31,205,30,205,29,62,31,136,31,81,31,85,31,133,31,233,31,231,31,203,31,112,31,155,31,105,31,26,31,42,31,10,31,10,30,10,29,219,31,219,30,86,31,124,31,240,31,107,31,113,31,94,31,9,31,193,31,193,30,212,31,30,31,251,31,208,31,145,31,124,31,124,30,71,31,77,31,39,31,39,30,200,31,122,31,200,31,200,30,167,31,76,31,215,31,237,31,210,31,202,31,114,31,206,31,63,31,63,30,63,29,63,28,236,31,163,31,112,31,145,31,114,31,100,31,209,31,75,31,75,30,89,31,214,31,214,30,72,31,87,31,82,31,190,31,36,31,255,31,255,30,195,31,128,31,93,31,149,31,54,31,247,31);

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
