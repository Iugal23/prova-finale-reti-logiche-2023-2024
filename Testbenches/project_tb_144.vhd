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

constant SCENARIO_LENGTH : integer := 253;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,0,0,240,0,21,0,61,0,66,0,227,0,102,0,0,0,55,0,0,0,110,0,178,0,107,0,153,0,128,0,12,0,28,0,91,0,94,0,125,0,0,0,37,0,111,0,121,0,86,0,0,0,118,0,7,0,126,0,0,0,22,0,247,0,102,0,141,0,40,0,57,0,17,0,92,0,0,0,177,0,0,0,18,0,187,0,39,0,100,0,200,0,254,0,3,0,146,0,146,0,0,0,161,0,0,0,0,0,55,0,40,0,40,0,235,0,2,0,194,0,29,0,61,0,126,0,197,0,255,0,0,0,4,0,212,0,126,0,153,0,180,0,58,0,71,0,94,0,0,0,164,0,44,0,116,0,0,0,219,0,159,0,17,0,44,0,0,0,54,0,0,0,0,0,90,0,48,0,189,0,228,0,111,0,0,0,201,0,6,0,0,0,226,0,93,0,153,0,139,0,132,0,0,0,60,0,47,0,31,0,79,0,67,0,232,0,39,0,131,0,56,0,9,0,158,0,176,0,35,0,253,0,105,0,217,0,44,0,209,0,0,0,41,0,0,0,46,0,239,0,0,0,119,0,108,0,0,0,85,0,41,0,124,0,245,0,3,0,0,0,138,0,111,0,178,0,116,0,0,0,151,0,21,0,120,0,105,0,2,0,54,0,7,0,0,0,161,0,119,0,34,0,0,0,33,0,219,0,251,0,0,0,94,0,61,0,223,0,0,0,12,0,12,0,172,0,0,0,129,0,133,0,81,0,252,0,222,0,68,0,0,0,126,0,188,0,21,0,14,0,206,0,207,0,184,0,245,0,87,0,0,0,126,0,0,0,86,0,207,0,0,0,102,0,138,0,202,0,221,0,111,0,95,0,0,0,0,0,77,0,32,0,107,0,101,0,78,0,87,0,0,0,11,0,30,0,0,0,58,0,224,0,57,0,74,0,188,0,0,0,156,0,0,0,224,0,207,0,0,0,126,0,158,0,205,0,72,0,138,0,22,0,82,0,106,0,245,0,0,0,214,0,175,0,249,0,0,0,174,0,66,0,185,0,0,0,105,0,11,0,0,0,105,0,244,0,92,0,194,0,181,0,236,0,0,0,154,0,181,0,117,0,0,0,107,0,126,0,64,0,207,0,143,0);
signal scenario_full  : scenario_type := (0,0,0,0,240,31,21,31,61,31,66,31,227,31,102,31,102,30,55,31,55,30,110,31,178,31,107,31,153,31,128,31,12,31,28,31,91,31,94,31,125,31,125,30,37,31,111,31,121,31,86,31,86,30,118,31,7,31,126,31,126,30,22,31,247,31,102,31,141,31,40,31,57,31,17,31,92,31,92,30,177,31,177,30,18,31,187,31,39,31,100,31,200,31,254,31,3,31,146,31,146,31,146,30,161,31,161,30,161,29,55,31,40,31,40,31,235,31,2,31,194,31,29,31,61,31,126,31,197,31,255,31,255,30,4,31,212,31,126,31,153,31,180,31,58,31,71,31,94,31,94,30,164,31,44,31,116,31,116,30,219,31,159,31,17,31,44,31,44,30,54,31,54,30,54,29,90,31,48,31,189,31,228,31,111,31,111,30,201,31,6,31,6,30,226,31,93,31,153,31,139,31,132,31,132,30,60,31,47,31,31,31,79,31,67,31,232,31,39,31,131,31,56,31,9,31,158,31,176,31,35,31,253,31,105,31,217,31,44,31,209,31,209,30,41,31,41,30,46,31,239,31,239,30,119,31,108,31,108,30,85,31,41,31,124,31,245,31,3,31,3,30,138,31,111,31,178,31,116,31,116,30,151,31,21,31,120,31,105,31,2,31,54,31,7,31,7,30,161,31,119,31,34,31,34,30,33,31,219,31,251,31,251,30,94,31,61,31,223,31,223,30,12,31,12,31,172,31,172,30,129,31,133,31,81,31,252,31,222,31,68,31,68,30,126,31,188,31,21,31,14,31,206,31,207,31,184,31,245,31,87,31,87,30,126,31,126,30,86,31,207,31,207,30,102,31,138,31,202,31,221,31,111,31,95,31,95,30,95,29,77,31,32,31,107,31,101,31,78,31,87,31,87,30,11,31,30,31,30,30,58,31,224,31,57,31,74,31,188,31,188,30,156,31,156,30,224,31,207,31,207,30,126,31,158,31,205,31,72,31,138,31,22,31,82,31,106,31,245,31,245,30,214,31,175,31,249,31,249,30,174,31,66,31,185,31,185,30,105,31,11,31,11,30,105,31,244,31,92,31,194,31,181,31,236,31,236,30,154,31,181,31,117,31,117,30,107,31,126,31,64,31,207,31,143,31);

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
