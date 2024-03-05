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

constant SCENARIO_LENGTH : integer := 205;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (150,0,154,0,0,0,121,0,98,0,242,0,101,0,0,0,230,0,37,0,219,0,132,0,113,0,118,0,0,0,16,0,115,0,242,0,0,0,80,0,141,0,0,0,190,0,102,0,38,0,0,0,88,0,57,0,72,0,225,0,146,0,132,0,32,0,11,0,80,0,179,0,244,0,0,0,0,0,130,0,169,0,245,0,173,0,86,0,174,0,160,0,52,0,79,0,0,0,0,0,195,0,117,0,216,0,17,0,63,0,111,0,0,0,0,0,181,0,9,0,30,0,0,0,168,0,99,0,128,0,0,0,0,0,0,0,189,0,13,0,195,0,236,0,210,0,43,0,152,0,241,0,203,0,143,0,11,0,2,0,76,0,199,0,144,0,65,0,209,0,118,0,32,0,211,0,0,0,94,0,194,0,104,0,205,0,0,0,159,0,0,0,13,0,138,0,147,0,6,0,0,0,174,0,11,0,0,0,107,0,0,0,89,0,84,0,89,0,34,0,184,0,49,0,212,0,29,0,0,0,0,0,2,0,8,0,154,0,140,0,81,0,244,0,225,0,165,0,101,0,0,0,26,0,48,0,11,0,201,0,158,0,210,0,0,0,250,0,236,0,55,0,46,0,95,0,20,0,181,0,174,0,187,0,35,0,225,0,186,0,84,0,118,0,205,0,111,0,126,0,209,0,131,0,118,0,41,0,0,0,125,0,252,0,225,0,84,0,54,0,243,0,25,0,206,0,59,0,98,0,7,0,224,0,221,0,215,0,7,0,160,0,176,0,235,0,16,0,156,0,248,0,213,0,5,0,35,0,208,0,75,0,131,0,48,0,0,0,37,0,147,0,185,0,0,0,122,0,32,0,183,0,24,0,239,0,188,0,85,0,75,0,0,0,0,0,38,0,0,0,113,0,92,0,191,0,172,0,0,0);
signal scenario_full  : scenario_type := (150,31,154,31,154,30,121,31,98,31,242,31,101,31,101,30,230,31,37,31,219,31,132,31,113,31,118,31,118,30,16,31,115,31,242,31,242,30,80,31,141,31,141,30,190,31,102,31,38,31,38,30,88,31,57,31,72,31,225,31,146,31,132,31,32,31,11,31,80,31,179,31,244,31,244,30,244,29,130,31,169,31,245,31,173,31,86,31,174,31,160,31,52,31,79,31,79,30,79,29,195,31,117,31,216,31,17,31,63,31,111,31,111,30,111,29,181,31,9,31,30,31,30,30,168,31,99,31,128,31,128,30,128,29,128,28,189,31,13,31,195,31,236,31,210,31,43,31,152,31,241,31,203,31,143,31,11,31,2,31,76,31,199,31,144,31,65,31,209,31,118,31,32,31,211,31,211,30,94,31,194,31,104,31,205,31,205,30,159,31,159,30,13,31,138,31,147,31,6,31,6,30,174,31,11,31,11,30,107,31,107,30,89,31,84,31,89,31,34,31,184,31,49,31,212,31,29,31,29,30,29,29,2,31,8,31,154,31,140,31,81,31,244,31,225,31,165,31,101,31,101,30,26,31,48,31,11,31,201,31,158,31,210,31,210,30,250,31,236,31,55,31,46,31,95,31,20,31,181,31,174,31,187,31,35,31,225,31,186,31,84,31,118,31,205,31,111,31,126,31,209,31,131,31,118,31,41,31,41,30,125,31,252,31,225,31,84,31,54,31,243,31,25,31,206,31,59,31,98,31,7,31,224,31,221,31,215,31,7,31,160,31,176,31,235,31,16,31,156,31,248,31,213,31,5,31,35,31,208,31,75,31,131,31,48,31,48,30,37,31,147,31,185,31,185,30,122,31,32,31,183,31,24,31,239,31,188,31,85,31,75,31,75,30,75,29,38,31,38,30,113,31,92,31,191,31,172,31,172,30);

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
