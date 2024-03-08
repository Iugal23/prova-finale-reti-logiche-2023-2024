-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_68 is
end project_tb_68;

architecture project_tb_arch_68 of project_tb_68 is
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

constant SCENARIO_LENGTH : integer := 576;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (85,0,0,0,61,0,0,0,102,0,232,0,99,0,0,0,150,0,70,0,0,0,228,0,214,0,34,0,191,0,134,0,239,0,226,0,155,0,70,0,0,0,0,0,60,0,0,0,240,0,6,0,118,0,23,0,75,0,102,0,0,0,207,0,0,0,148,0,0,0,145,0,60,0,45,0,132,0,40,0,254,0,0,0,94,0,45,0,43,0,87,0,202,0,0,0,158,0,11,0,0,0,192,0,0,0,85,0,0,0,20,0,104,0,0,0,12,0,116,0,246,0,0,0,114,0,93,0,171,0,222,0,238,0,21,0,0,0,166,0,222,0,190,0,97,0,99,0,199,0,13,0,244,0,0,0,150,0,111,0,0,0,134,0,0,0,44,0,32,0,51,0,242,0,14,0,212,0,37,0,212,0,79,0,35,0,176,0,110,0,254,0,167,0,42,0,0,0,187,0,94,0,215,0,27,0,152,0,0,0,250,0,225,0,44,0,235,0,0,0,158,0,152,0,111,0,133,0,43,0,198,0,162,0,164,0,224,0,54,0,0,0,33,0,233,0,40,0,88,0,115,0,16,0,0,0,86,0,0,0,201,0,134,0,161,0,0,0,0,0,214,0,213,0,0,0,251,0,171,0,49,0,83,0,123,0,20,0,19,0,123,0,249,0,52,0,173,0,0,0,201,0,208,0,0,0,51,0,158,0,30,0,21,0,144,0,144,0,49,0,132,0,191,0,47,0,44,0,201,0,151,0,7,0,244,0,249,0,141,0,191,0,0,0,201,0,165,0,63,0,99,0,117,0,0,0,130,0,0,0,0,0,201,0,0,0,129,0,0,0,115,0,185,0,96,0,25,0,0,0,0,0,152,0,26,0,12,0,0,0,0,0,0,0,10,0,229,0,0,0,142,0,28,0,0,0,231,0,243,0,58,0,244,0,65,0,238,0,0,0,0,0,242,0,95,0,117,0,157,0,254,0,0,0,163,0,247,0,0,0,80,0,91,0,5,0,31,0,0,0,0,0,0,0,0,0,242,0,49,0,166,0,11,0,64,0,153,0,61,0,244,0,33,0,83,0,213,0,220,0,117,0,0,0,79,0,230,0,0,0,0,0,6,0,84,0,134,0,235,0,25,0,36,0,136,0,0,0,144,0,175,0,5,0,21,0,0,0,141,0,0,0,247,0,40,0,229,0,78,0,0,0,215,0,210,0,69,0,78,0,181,0,0,0,0,0,18,0,170,0,206,0,0,0,142,0,144,0,0,0,255,0,73,0,0,0,151,0,72,0,192,0,196,0,0,0,147,0,20,0,106,0,63,0,19,0,82,0,48,0,0,0,103,0,176,0,14,0,0,0,26,0,0,0,167,0,137,0,255,0,0,0,0,0,0,0,255,0,71,0,8,0,240,0,136,0,206,0,198,0,155,0,221,0,41,0,238,0,0,0,210,0,4,0,140,0,0,0,203,0,0,0,132,0,0,0,32,0,153,0,26,0,103,0,165,0,33,0,197,0,204,0,192,0,135,0,0,0,78,0,84,0,241,0,133,0,0,0,231,0,134,0,0,0,60,0,26,0,141,0,220,0,113,0,179,0,131,0,254,0,186,0,33,0,141,0,0,0,0,0,123,0,46,0,0,0,157,0,92,0,0,0,28,0,0,0,0,0,231,0,228,0,62,0,134,0,113,0,0,0,107,0,243,0,14,0,108,0,147,0,0,0,0,0,155,0,56,0,95,0,89,0,63,0,235,0,150,0,232,0,208,0,133,0,0,0,195,0,48,0,191,0,0,0,26,0,0,0,157,0,164,0,43,0,243,0,84,0,144,0,229,0,165,0,17,0,22,0,155,0,8,0,0,0,0,0,208,0,0,0,86,0,254,0,0,0,220,0,101,0,222,0,217,0,0,0,0,0,8,0,0,0,83,0,124,0,38,0,234,0,242,0,45,0,0,0,38,0,70,0,20,0,0,0,194,0,0,0,67,0,37,0,220,0,0,0,203,0,137,0,145,0,240,0,74,0,158,0,94,0,97,0,0,0,0,0,146,0,49,0,93,0,198,0,0,0,216,0,149,0,0,0,233,0,176,0,0,0,129,0,0,0,98,0,104,0,252,0,0,0,134,0,0,0,0,0,0,0,5,0,0,0,208,0,131,0,110,0,71,0,0,0,112,0,36,0,30,0,216,0,7,0,147,0,196,0,127,0,216,0,0,0,30,0,255,0,186,0,31,0,0,0,117,0,190,0,0,0,0,0,88,0,138,0,0,0,0,0,205,0,95,0,141,0,41,0,138,0,142,0,27,0,120,0,189,0,221,0,128,0,0,0,5,0,0,0,54,0,38,0,179,0,130,0,63,0,127,0,131,0,44,0,84,0,0,0,96,0,132,0,0,0,182,0,74,0,165,0,96,0,0,0,99,0,86,0,0,0,63,0,0,0,249,0,0,0,171,0,70,0,234,0,0,0,85,0,1,0,154,0,174,0,77,0,26,0,175,0,95,0,30,0,0,0,37,0,202,0,205,0,79,0,0,0,0,0,187,0,39,0,40,0,104,0,152,0,0,0,101,0,80,0,0,0,134,0,145,0,108,0,169,0);
signal scenario_full  : scenario_type := (85,31,85,30,61,31,61,30,102,31,232,31,99,31,99,30,150,31,70,31,70,30,228,31,214,31,34,31,191,31,134,31,239,31,226,31,155,31,70,31,70,30,70,29,60,31,60,30,240,31,6,31,118,31,23,31,75,31,102,31,102,30,207,31,207,30,148,31,148,30,145,31,60,31,45,31,132,31,40,31,254,31,254,30,94,31,45,31,43,31,87,31,202,31,202,30,158,31,11,31,11,30,192,31,192,30,85,31,85,30,20,31,104,31,104,30,12,31,116,31,246,31,246,30,114,31,93,31,171,31,222,31,238,31,21,31,21,30,166,31,222,31,190,31,97,31,99,31,199,31,13,31,244,31,244,30,150,31,111,31,111,30,134,31,134,30,44,31,32,31,51,31,242,31,14,31,212,31,37,31,212,31,79,31,35,31,176,31,110,31,254,31,167,31,42,31,42,30,187,31,94,31,215,31,27,31,152,31,152,30,250,31,225,31,44,31,235,31,235,30,158,31,152,31,111,31,133,31,43,31,198,31,162,31,164,31,224,31,54,31,54,30,33,31,233,31,40,31,88,31,115,31,16,31,16,30,86,31,86,30,201,31,134,31,161,31,161,30,161,29,214,31,213,31,213,30,251,31,171,31,49,31,83,31,123,31,20,31,19,31,123,31,249,31,52,31,173,31,173,30,201,31,208,31,208,30,51,31,158,31,30,31,21,31,144,31,144,31,49,31,132,31,191,31,47,31,44,31,201,31,151,31,7,31,244,31,249,31,141,31,191,31,191,30,201,31,165,31,63,31,99,31,117,31,117,30,130,31,130,30,130,29,201,31,201,30,129,31,129,30,115,31,185,31,96,31,25,31,25,30,25,29,152,31,26,31,12,31,12,30,12,29,12,28,10,31,229,31,229,30,142,31,28,31,28,30,231,31,243,31,58,31,244,31,65,31,238,31,238,30,238,29,242,31,95,31,117,31,157,31,254,31,254,30,163,31,247,31,247,30,80,31,91,31,5,31,31,31,31,30,31,29,31,28,31,27,242,31,49,31,166,31,11,31,64,31,153,31,61,31,244,31,33,31,83,31,213,31,220,31,117,31,117,30,79,31,230,31,230,30,230,29,6,31,84,31,134,31,235,31,25,31,36,31,136,31,136,30,144,31,175,31,5,31,21,31,21,30,141,31,141,30,247,31,40,31,229,31,78,31,78,30,215,31,210,31,69,31,78,31,181,31,181,30,181,29,18,31,170,31,206,31,206,30,142,31,144,31,144,30,255,31,73,31,73,30,151,31,72,31,192,31,196,31,196,30,147,31,20,31,106,31,63,31,19,31,82,31,48,31,48,30,103,31,176,31,14,31,14,30,26,31,26,30,167,31,137,31,255,31,255,30,255,29,255,28,255,31,71,31,8,31,240,31,136,31,206,31,198,31,155,31,221,31,41,31,238,31,238,30,210,31,4,31,140,31,140,30,203,31,203,30,132,31,132,30,32,31,153,31,26,31,103,31,165,31,33,31,197,31,204,31,192,31,135,31,135,30,78,31,84,31,241,31,133,31,133,30,231,31,134,31,134,30,60,31,26,31,141,31,220,31,113,31,179,31,131,31,254,31,186,31,33,31,141,31,141,30,141,29,123,31,46,31,46,30,157,31,92,31,92,30,28,31,28,30,28,29,231,31,228,31,62,31,134,31,113,31,113,30,107,31,243,31,14,31,108,31,147,31,147,30,147,29,155,31,56,31,95,31,89,31,63,31,235,31,150,31,232,31,208,31,133,31,133,30,195,31,48,31,191,31,191,30,26,31,26,30,157,31,164,31,43,31,243,31,84,31,144,31,229,31,165,31,17,31,22,31,155,31,8,31,8,30,8,29,208,31,208,30,86,31,254,31,254,30,220,31,101,31,222,31,217,31,217,30,217,29,8,31,8,30,83,31,124,31,38,31,234,31,242,31,45,31,45,30,38,31,70,31,20,31,20,30,194,31,194,30,67,31,37,31,220,31,220,30,203,31,137,31,145,31,240,31,74,31,158,31,94,31,97,31,97,30,97,29,146,31,49,31,93,31,198,31,198,30,216,31,149,31,149,30,233,31,176,31,176,30,129,31,129,30,98,31,104,31,252,31,252,30,134,31,134,30,134,29,134,28,5,31,5,30,208,31,131,31,110,31,71,31,71,30,112,31,36,31,30,31,216,31,7,31,147,31,196,31,127,31,216,31,216,30,30,31,255,31,186,31,31,31,31,30,117,31,190,31,190,30,190,29,88,31,138,31,138,30,138,29,205,31,95,31,141,31,41,31,138,31,142,31,27,31,120,31,189,31,221,31,128,31,128,30,5,31,5,30,54,31,38,31,179,31,130,31,63,31,127,31,131,31,44,31,84,31,84,30,96,31,132,31,132,30,182,31,74,31,165,31,96,31,96,30,99,31,86,31,86,30,63,31,63,30,249,31,249,30,171,31,70,31,234,31,234,30,85,31,1,31,154,31,174,31,77,31,26,31,175,31,95,31,30,31,30,30,37,31,202,31,205,31,79,31,79,30,79,29,187,31,39,31,40,31,104,31,152,31,152,30,101,31,80,31,80,30,134,31,145,31,108,31,169,31);

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
