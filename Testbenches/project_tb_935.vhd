-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_935 is
end project_tb_935;

architecture project_tb_arch_935 of project_tb_935 is
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

constant SCENARIO_LENGTH : integer := 374;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (183,0,254,0,142,0,154,0,85,0,203,0,246,0,43,0,0,0,199,0,96,0,203,0,218,0,59,0,37,0,74,0,30,0,224,0,81,0,170,0,0,0,15,0,60,0,0,0,213,0,110,0,12,0,64,0,0,0,133,0,169,0,15,0,76,0,210,0,145,0,0,0,69,0,94,0,219,0,0,0,180,0,0,0,223,0,42,0,0,0,196,0,107,0,0,0,26,0,0,0,220,0,249,0,199,0,112,0,141,0,0,0,235,0,92,0,214,0,150,0,0,0,122,0,0,0,153,0,60,0,54,0,93,0,77,0,106,0,66,0,19,0,83,0,140,0,0,0,205,0,141,0,0,0,0,0,204,0,0,0,138,0,0,0,0,0,252,0,96,0,219,0,0,0,151,0,117,0,74,0,87,0,118,0,230,0,106,0,208,0,194,0,121,0,188,0,165,0,0,0,114,0,142,0,201,0,199,0,103,0,84,0,0,0,107,0,81,0,52,0,146,0,0,0,0,0,28,0,37,0,103,0,238,0,205,0,0,0,87,0,155,0,0,0,165,0,161,0,69,0,0,0,115,0,161,0,0,0,188,0,61,0,144,0,30,0,202,0,134,0,131,0,42,0,39,0,94,0,59,0,0,0,23,0,8,0,33,0,238,0,0,0,111,0,42,0,0,0,246,0,96,0,177,0,0,0,20,0,190,0,58,0,0,0,108,0,195,0,211,0,172,0,0,0,250,0,29,0,58,0,0,0,78,0,186,0,23,0,0,0,0,0,0,0,63,0,41,0,49,0,221,0,0,0,178,0,215,0,4,0,6,0,189,0,3,0,0,0,180,0,127,0,201,0,159,0,0,0,198,0,172,0,47,0,96,0,42,0,43,0,52,0,191,0,235,0,145,0,0,0,58,0,69,0,235,0,0,0,23,0,240,0,0,0,243,0,86,0,87,0,186,0,121,0,214,0,74,0,116,0,206,0,235,0,191,0,179,0,34,0,187,0,90,0,180,0,70,0,252,0,222,0,29,0,31,0,26,0,0,0,22,0,165,0,101,0,0,0,243,0,7,0,137,0,6,0,29,0,244,0,25,0,167,0,108,0,198,0,168,0,64,0,150,0,128,0,200,0,209,0,179,0,13,0,91,0,143,0,0,0,90,0,119,0,26,0,226,0,82,0,184,0,104,0,0,0,126,0,175,0,0,0,36,0,49,0,65,0,106,0,14,0,23,0,0,0,9,0,0,0,125,0,178,0,125,0,17,0,104,0,0,0,0,0,247,0,123,0,215,0,33,0,0,0,210,0,67,0,66,0,168,0,165,0,201,0,0,0,19,0,80,0,119,0,30,0,97,0,0,0,149,0,192,0,0,0,0,0,42,0,0,0,110,0,30,0,38,0,93,0,184,0,157,0,52,0,82,0,190,0,60,0,218,0,0,0,8,0,94,0,149,0,161,0,5,0,242,0,181,0,49,0,168,0,210,0,231,0,44,0,205,0,241,0,33,0,8,0,156,0,0,0,184,0,217,0,38,0,236,0,36,0,249,0,198,0,0,0,206,0,172,0,194,0,8,0,0,0,0,0,196,0,116,0,0,0,254,0,195,0,18,0,190,0,151,0,218,0,46,0,22,0,0,0,17,0,230,0,82,0,0,0,109,0,209,0,0,0,72,0,25,0,0,0,166,0,146,0);
signal scenario_full  : scenario_type := (183,31,254,31,142,31,154,31,85,31,203,31,246,31,43,31,43,30,199,31,96,31,203,31,218,31,59,31,37,31,74,31,30,31,224,31,81,31,170,31,170,30,15,31,60,31,60,30,213,31,110,31,12,31,64,31,64,30,133,31,169,31,15,31,76,31,210,31,145,31,145,30,69,31,94,31,219,31,219,30,180,31,180,30,223,31,42,31,42,30,196,31,107,31,107,30,26,31,26,30,220,31,249,31,199,31,112,31,141,31,141,30,235,31,92,31,214,31,150,31,150,30,122,31,122,30,153,31,60,31,54,31,93,31,77,31,106,31,66,31,19,31,83,31,140,31,140,30,205,31,141,31,141,30,141,29,204,31,204,30,138,31,138,30,138,29,252,31,96,31,219,31,219,30,151,31,117,31,74,31,87,31,118,31,230,31,106,31,208,31,194,31,121,31,188,31,165,31,165,30,114,31,142,31,201,31,199,31,103,31,84,31,84,30,107,31,81,31,52,31,146,31,146,30,146,29,28,31,37,31,103,31,238,31,205,31,205,30,87,31,155,31,155,30,165,31,161,31,69,31,69,30,115,31,161,31,161,30,188,31,61,31,144,31,30,31,202,31,134,31,131,31,42,31,39,31,94,31,59,31,59,30,23,31,8,31,33,31,238,31,238,30,111,31,42,31,42,30,246,31,96,31,177,31,177,30,20,31,190,31,58,31,58,30,108,31,195,31,211,31,172,31,172,30,250,31,29,31,58,31,58,30,78,31,186,31,23,31,23,30,23,29,23,28,63,31,41,31,49,31,221,31,221,30,178,31,215,31,4,31,6,31,189,31,3,31,3,30,180,31,127,31,201,31,159,31,159,30,198,31,172,31,47,31,96,31,42,31,43,31,52,31,191,31,235,31,145,31,145,30,58,31,69,31,235,31,235,30,23,31,240,31,240,30,243,31,86,31,87,31,186,31,121,31,214,31,74,31,116,31,206,31,235,31,191,31,179,31,34,31,187,31,90,31,180,31,70,31,252,31,222,31,29,31,31,31,26,31,26,30,22,31,165,31,101,31,101,30,243,31,7,31,137,31,6,31,29,31,244,31,25,31,167,31,108,31,198,31,168,31,64,31,150,31,128,31,200,31,209,31,179,31,13,31,91,31,143,31,143,30,90,31,119,31,26,31,226,31,82,31,184,31,104,31,104,30,126,31,175,31,175,30,36,31,49,31,65,31,106,31,14,31,23,31,23,30,9,31,9,30,125,31,178,31,125,31,17,31,104,31,104,30,104,29,247,31,123,31,215,31,33,31,33,30,210,31,67,31,66,31,168,31,165,31,201,31,201,30,19,31,80,31,119,31,30,31,97,31,97,30,149,31,192,31,192,30,192,29,42,31,42,30,110,31,30,31,38,31,93,31,184,31,157,31,52,31,82,31,190,31,60,31,218,31,218,30,8,31,94,31,149,31,161,31,5,31,242,31,181,31,49,31,168,31,210,31,231,31,44,31,205,31,241,31,33,31,8,31,156,31,156,30,184,31,217,31,38,31,236,31,36,31,249,31,198,31,198,30,206,31,172,31,194,31,8,31,8,30,8,29,196,31,116,31,116,30,254,31,195,31,18,31,190,31,151,31,218,31,46,31,22,31,22,30,17,31,230,31,82,31,82,30,109,31,209,31,209,30,72,31,25,31,25,30,166,31,146,31);

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
