-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_758 is
end project_tb_758;

architecture project_tb_arch_758 of project_tb_758 is
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

constant SCENARIO_LENGTH : integer := 359;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (97,0,231,0,247,0,135,0,237,0,0,0,104,0,20,0,221,0,217,0,240,0,134,0,151,0,0,0,16,0,147,0,227,0,232,0,0,0,46,0,0,0,186,0,98,0,31,0,82,0,237,0,44,0,152,0,54,0,0,0,93,0,0,0,0,0,0,0,125,0,48,0,106,0,240,0,84,0,241,0,86,0,234,0,0,0,123,0,111,0,124,0,0,0,0,0,118,0,25,0,191,0,0,0,152,0,89,0,206,0,233,0,69,0,187,0,43,0,237,0,134,0,135,0,0,0,79,0,0,0,73,0,158,0,49,0,0,0,17,0,117,0,212,0,231,0,181,0,0,0,112,0,149,0,112,0,3,0,0,0,0,0,87,0,231,0,0,0,212,0,0,0,0,0,151,0,110,0,0,0,240,0,197,0,237,0,146,0,224,0,135,0,0,0,114,0,182,0,193,0,81,0,98,0,91,0,23,0,89,0,193,0,5,0,79,0,0,0,170,0,0,0,104,0,198,0,0,0,88,0,51,0,0,0,23,0,213,0,178,0,215,0,255,0,3,0,141,0,0,0,0,0,136,0,0,0,185,0,255,0,200,0,83,0,169,0,96,0,57,0,0,0,0,0,173,0,114,0,0,0,116,0,20,0,208,0,253,0,196,0,230,0,139,0,0,0,51,0,254,0,0,0,74,0,181,0,57,0,30,0,114,0,243,0,133,0,47,0,213,0,123,0,0,0,0,0,198,0,162,0,92,0,0,0,171,0,219,0,198,0,0,0,0,0,157,0,13,0,135,0,244,0,39,0,195,0,99,0,100,0,0,0,170,0,37,0,0,0,227,0,173,0,59,0,0,0,89,0,52,0,118,0,233,0,7,0,0,0,182,0,149,0,116,0,253,0,159,0,183,0,20,0,69,0,106,0,0,0,136,0,58,0,42,0,240,0,0,0,95,0,58,0,0,0,0,0,25,0,83,0,0,0,0,0,187,0,0,0,0,0,0,0,224,0,0,0,0,0,13,0,24,0,186,0,213,0,0,0,160,0,62,0,0,0,0,0,148,0,67,0,149,0,201,0,146,0,97,0,223,0,200,0,227,0,74,0,150,0,65,0,226,0,79,0,24,0,61,0,139,0,249,0,51,0,72,0,0,0,127,0,170,0,0,0,156,0,81,0,24,0,0,0,242,0,56,0,76,0,105,0,220,0,0,0,251,0,56,0,0,0,142,0,189,0,32,0,51,0,0,0,23,0,237,0,230,0,49,0,0,0,82,0,43,0,181,0,0,0,0,0,0,0,72,0,0,0,41,0,20,0,37,0,55,0,224,0,0,0,121,0,132,0,0,0,177,0,66,0,220,0,65,0,174,0,10,0,162,0,83,0,249,0,223,0,195,0,110,0,55,0,136,0,34,0,39,0,100,0,183,0,7,0,124,0,184,0,0,0,75,0,244,0,32,0,175,0,0,0,93,0,183,0,98,0,18,0,241,0,75,0,101,0,59,0,11,0,50,0,143,0,16,0,131,0,71,0,142,0,0,0,163,0,58,0,160,0,14,0,134,0,163,0,234,0,116,0,81,0,0,0,252,0,104,0,241,0,0,0,86,0,93,0,97,0,91,0,254,0);
signal scenario_full  : scenario_type := (97,31,231,31,247,31,135,31,237,31,237,30,104,31,20,31,221,31,217,31,240,31,134,31,151,31,151,30,16,31,147,31,227,31,232,31,232,30,46,31,46,30,186,31,98,31,31,31,82,31,237,31,44,31,152,31,54,31,54,30,93,31,93,30,93,29,93,28,125,31,48,31,106,31,240,31,84,31,241,31,86,31,234,31,234,30,123,31,111,31,124,31,124,30,124,29,118,31,25,31,191,31,191,30,152,31,89,31,206,31,233,31,69,31,187,31,43,31,237,31,134,31,135,31,135,30,79,31,79,30,73,31,158,31,49,31,49,30,17,31,117,31,212,31,231,31,181,31,181,30,112,31,149,31,112,31,3,31,3,30,3,29,87,31,231,31,231,30,212,31,212,30,212,29,151,31,110,31,110,30,240,31,197,31,237,31,146,31,224,31,135,31,135,30,114,31,182,31,193,31,81,31,98,31,91,31,23,31,89,31,193,31,5,31,79,31,79,30,170,31,170,30,104,31,198,31,198,30,88,31,51,31,51,30,23,31,213,31,178,31,215,31,255,31,3,31,141,31,141,30,141,29,136,31,136,30,185,31,255,31,200,31,83,31,169,31,96,31,57,31,57,30,57,29,173,31,114,31,114,30,116,31,20,31,208,31,253,31,196,31,230,31,139,31,139,30,51,31,254,31,254,30,74,31,181,31,57,31,30,31,114,31,243,31,133,31,47,31,213,31,123,31,123,30,123,29,198,31,162,31,92,31,92,30,171,31,219,31,198,31,198,30,198,29,157,31,13,31,135,31,244,31,39,31,195,31,99,31,100,31,100,30,170,31,37,31,37,30,227,31,173,31,59,31,59,30,89,31,52,31,118,31,233,31,7,31,7,30,182,31,149,31,116,31,253,31,159,31,183,31,20,31,69,31,106,31,106,30,136,31,58,31,42,31,240,31,240,30,95,31,58,31,58,30,58,29,25,31,83,31,83,30,83,29,187,31,187,30,187,29,187,28,224,31,224,30,224,29,13,31,24,31,186,31,213,31,213,30,160,31,62,31,62,30,62,29,148,31,67,31,149,31,201,31,146,31,97,31,223,31,200,31,227,31,74,31,150,31,65,31,226,31,79,31,24,31,61,31,139,31,249,31,51,31,72,31,72,30,127,31,170,31,170,30,156,31,81,31,24,31,24,30,242,31,56,31,76,31,105,31,220,31,220,30,251,31,56,31,56,30,142,31,189,31,32,31,51,31,51,30,23,31,237,31,230,31,49,31,49,30,82,31,43,31,181,31,181,30,181,29,181,28,72,31,72,30,41,31,20,31,37,31,55,31,224,31,224,30,121,31,132,31,132,30,177,31,66,31,220,31,65,31,174,31,10,31,162,31,83,31,249,31,223,31,195,31,110,31,55,31,136,31,34,31,39,31,100,31,183,31,7,31,124,31,184,31,184,30,75,31,244,31,32,31,175,31,175,30,93,31,183,31,98,31,18,31,241,31,75,31,101,31,59,31,11,31,50,31,143,31,16,31,131,31,71,31,142,31,142,30,163,31,58,31,160,31,14,31,134,31,163,31,234,31,116,31,81,31,81,30,252,31,104,31,241,31,241,30,86,31,93,31,97,31,91,31,254,31);

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
