-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_569 is
end project_tb_569;

architecture project_tb_arch_569 of project_tb_569 is
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

constant SCENARIO_LENGTH : integer := 438;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (147,0,250,0,142,0,231,0,218,0,169,0,41,0,0,0,0,0,91,0,0,0,226,0,116,0,101,0,196,0,0,0,163,0,162,0,0,0,58,0,31,0,168,0,238,0,184,0,5,0,42,0,71,0,129,0,249,0,78,0,96,0,90,0,48,0,60,0,126,0,134,0,0,0,79,0,152,0,94,0,68,0,200,0,136,0,253,0,36,0,127,0,205,0,0,0,0,0,9,0,24,0,141,0,0,0,142,0,0,0,0,0,233,0,37,0,13,0,55,0,131,0,27,0,5,0,229,0,224,0,34,0,136,0,0,0,0,0,99,0,0,0,242,0,8,0,75,0,0,0,255,0,209,0,156,0,161,0,0,0,176,0,20,0,3,0,0,0,143,0,231,0,73,0,138,0,86,0,77,0,0,0,41,0,187,0,0,0,76,0,184,0,218,0,195,0,0,0,161,0,167,0,244,0,42,0,16,0,0,0,180,0,68,0,0,0,72,0,0,0,163,0,0,0,174,0,196,0,169,0,187,0,90,0,0,0,0,0,0,0,251,0,0,0,168,0,139,0,222,0,30,0,133,0,0,0,90,0,63,0,0,0,0,0,35,0,178,0,0,0,122,0,0,0,41,0,85,0,95,0,0,0,0,0,120,0,194,0,0,0,66,0,74,0,45,0,100,0,245,0,0,0,184,0,0,0,8,0,185,0,238,0,0,0,76,0,243,0,0,0,140,0,56,0,0,0,41,0,101,0,31,0,214,0,0,0,214,0,121,0,210,0,146,0,196,0,0,0,142,0,138,0,243,0,57,0,115,0,99,0,0,0,20,0,89,0,117,0,149,0,203,0,0,0,72,0,123,0,88,0,201,0,197,0,212,0,88,0,0,0,151,0,118,0,238,0,154,0,14,0,132,0,200,0,32,0,98,0,42,0,152,0,168,0,89,0,199,0,186,0,0,0,186,0,0,0,100,0,115,0,208,0,177,0,108,0,94,0,194,0,95,0,251,0,115,0,0,0,234,0,251,0,129,0,175,0,82,0,235,0,172,0,108,0,0,0,233,0,97,0,96,0,69,0,246,0,189,0,0,0,30,0,20,0,151,0,221,0,51,0,244,0,100,0,193,0,205,0,30,0,126,0,105,0,133,0,26,0,72,0,5,0,191,0,1,0,35,0,214,0,233,0,0,0,183,0,103,0,0,0,0,0,31,0,3,0,66,0,9,0,106,0,89,0,0,0,0,0,96,0,106,0,76,0,6,0,188,0,0,0,192,0,68,0,67,0,114,0,205,0,249,0,37,0,48,0,104,0,15,0,237,0,28,0,38,0,245,0,0,0,86,0,237,0,222,0,241,0,161,0,252,0,250,0,96,0,29,0,165,0,0,0,76,0,0,0,213,0,29,0,0,0,213,0,83,0,0,0,80,0,188,0,0,0,147,0,11,0,28,0,204,0,0,0,200,0,57,0,220,0,0,0,29,0,0,0,135,0,222,0,160,0,41,0,0,0,94,0,200,0,188,0,17,0,0,0,154,0,0,0,0,0,175,0,0,0,161,0,143,0,81,0,54,0,40,0,0,0,0,0,75,0,192,0,239,0,42,0,67,0,0,0,123,0,136,0,58,0,187,0,16,0,0,0,0,0,46,0,29,0,65,0,9,0,151,0,0,0,138,0,89,0,0,0,0,0,165,0,85,0,69,0,18,0,20,0,0,0,37,0,0,0,203,0,184,0,0,0,84,0,88,0,77,0,196,0,135,0,240,0,10,0,72,0,58,0,81,0,237,0,0,0,21,0,192,0,89,0,61,0,56,0,99,0,188,0,203,0,145,0,95,0,28,0,6,0,94,0,114,0,0,0,46,0,72,0,104,0,63,0,252,0,154,0,55,0,189,0,155,0,125,0,166,0,13,0,49,0,132,0,0,0,240,0,80,0,176,0,16,0,118,0,180,0,182,0,50,0,0,0,247,0,221,0,180,0);
signal scenario_full  : scenario_type := (147,31,250,31,142,31,231,31,218,31,169,31,41,31,41,30,41,29,91,31,91,30,226,31,116,31,101,31,196,31,196,30,163,31,162,31,162,30,58,31,31,31,168,31,238,31,184,31,5,31,42,31,71,31,129,31,249,31,78,31,96,31,90,31,48,31,60,31,126,31,134,31,134,30,79,31,152,31,94,31,68,31,200,31,136,31,253,31,36,31,127,31,205,31,205,30,205,29,9,31,24,31,141,31,141,30,142,31,142,30,142,29,233,31,37,31,13,31,55,31,131,31,27,31,5,31,229,31,224,31,34,31,136,31,136,30,136,29,99,31,99,30,242,31,8,31,75,31,75,30,255,31,209,31,156,31,161,31,161,30,176,31,20,31,3,31,3,30,143,31,231,31,73,31,138,31,86,31,77,31,77,30,41,31,187,31,187,30,76,31,184,31,218,31,195,31,195,30,161,31,167,31,244,31,42,31,16,31,16,30,180,31,68,31,68,30,72,31,72,30,163,31,163,30,174,31,196,31,169,31,187,31,90,31,90,30,90,29,90,28,251,31,251,30,168,31,139,31,222,31,30,31,133,31,133,30,90,31,63,31,63,30,63,29,35,31,178,31,178,30,122,31,122,30,41,31,85,31,95,31,95,30,95,29,120,31,194,31,194,30,66,31,74,31,45,31,100,31,245,31,245,30,184,31,184,30,8,31,185,31,238,31,238,30,76,31,243,31,243,30,140,31,56,31,56,30,41,31,101,31,31,31,214,31,214,30,214,31,121,31,210,31,146,31,196,31,196,30,142,31,138,31,243,31,57,31,115,31,99,31,99,30,20,31,89,31,117,31,149,31,203,31,203,30,72,31,123,31,88,31,201,31,197,31,212,31,88,31,88,30,151,31,118,31,238,31,154,31,14,31,132,31,200,31,32,31,98,31,42,31,152,31,168,31,89,31,199,31,186,31,186,30,186,31,186,30,100,31,115,31,208,31,177,31,108,31,94,31,194,31,95,31,251,31,115,31,115,30,234,31,251,31,129,31,175,31,82,31,235,31,172,31,108,31,108,30,233,31,97,31,96,31,69,31,246,31,189,31,189,30,30,31,20,31,151,31,221,31,51,31,244,31,100,31,193,31,205,31,30,31,126,31,105,31,133,31,26,31,72,31,5,31,191,31,1,31,35,31,214,31,233,31,233,30,183,31,103,31,103,30,103,29,31,31,3,31,66,31,9,31,106,31,89,31,89,30,89,29,96,31,106,31,76,31,6,31,188,31,188,30,192,31,68,31,67,31,114,31,205,31,249,31,37,31,48,31,104,31,15,31,237,31,28,31,38,31,245,31,245,30,86,31,237,31,222,31,241,31,161,31,252,31,250,31,96,31,29,31,165,31,165,30,76,31,76,30,213,31,29,31,29,30,213,31,83,31,83,30,80,31,188,31,188,30,147,31,11,31,28,31,204,31,204,30,200,31,57,31,220,31,220,30,29,31,29,30,135,31,222,31,160,31,41,31,41,30,94,31,200,31,188,31,17,31,17,30,154,31,154,30,154,29,175,31,175,30,161,31,143,31,81,31,54,31,40,31,40,30,40,29,75,31,192,31,239,31,42,31,67,31,67,30,123,31,136,31,58,31,187,31,16,31,16,30,16,29,46,31,29,31,65,31,9,31,151,31,151,30,138,31,89,31,89,30,89,29,165,31,85,31,69,31,18,31,20,31,20,30,37,31,37,30,203,31,184,31,184,30,84,31,88,31,77,31,196,31,135,31,240,31,10,31,72,31,58,31,81,31,237,31,237,30,21,31,192,31,89,31,61,31,56,31,99,31,188,31,203,31,145,31,95,31,28,31,6,31,94,31,114,31,114,30,46,31,72,31,104,31,63,31,252,31,154,31,55,31,189,31,155,31,125,31,166,31,13,31,49,31,132,31,132,30,240,31,80,31,176,31,16,31,118,31,180,31,182,31,50,31,50,30,247,31,221,31,180,31);

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
