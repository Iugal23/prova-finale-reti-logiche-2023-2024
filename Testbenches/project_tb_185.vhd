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

constant SCENARIO_LENGTH : integer := 392;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (86,0,179,0,221,0,0,0,138,0,228,0,94,0,42,0,0,0,115,0,195,0,0,0,78,0,109,0,146,0,193,0,0,0,0,0,0,0,25,0,0,0,80,0,190,0,0,0,0,0,169,0,104,0,0,0,142,0,28,0,76,0,138,0,0,0,196,0,116,0,126,0,187,0,0,0,37,0,69,0,0,0,137,0,225,0,11,0,86,0,248,0,66,0,47,0,167,0,114,0,67,0,200,0,11,0,0,0,180,0,165,0,63,0,231,0,112,0,129,0,125,0,249,0,28,0,68,0,173,0,215,0,0,0,238,0,177,0,68,0,195,0,25,0,145,0,46,0,30,0,187,0,215,0,156,0,0,0,34,0,75,0,65,0,117,0,3,0,143,0,100,0,4,0,9,0,0,0,0,0,141,0,0,0,246,0,0,0,14,0,226,0,174,0,99,0,0,0,231,0,190,0,0,0,0,0,0,0,35,0,14,0,46,0,0,0,1,0,193,0,0,0,132,0,12,0,97,0,168,0,33,0,56,0,194,0,247,0,89,0,62,0,141,0,0,0,116,0,180,0,202,0,151,0,0,0,52,0,245,0,2,0,174,0,0,0,28,0,0,0,0,0,231,0,0,0,0,0,114,0,107,0,255,0,205,0,91,0,212,0,201,0,186,0,27,0,108,0,86,0,92,0,0,0,92,0,0,0,61,0,186,0,37,0,108,0,89,0,6,0,92,0,123,0,123,0,204,0,0,0,76,0,65,0,66,0,0,0,0,0,220,0,24,0,7,0,163,0,0,0,0,0,0,0,173,0,174,0,179,0,4,0,0,0,13,0,26,0,115,0,125,0,192,0,201,0,188,0,206,0,106,0,17,0,0,0,0,0,0,0,0,0,171,0,83,0,239,0,108,0,125,0,198,0,171,0,47,0,164,0,95,0,149,0,131,0,0,0,141,0,0,0,220,0,166,0,231,0,0,0,13,0,171,0,206,0,249,0,0,0,67,0,218,0,0,0,202,0,112,0,0,0,180,0,212,0,2,0,0,0,124,0,147,0,0,0,198,0,0,0,0,0,186,0,35,0,161,0,202,0,37,0,37,0,55,0,180,0,0,0,153,0,91,0,106,0,48,0,108,0,27,0,144,0,220,0,80,0,48,0,12,0,27,0,0,0,0,0,0,0,182,0,37,0,0,0,110,0,255,0,67,0,151,0,32,0,184,0,255,0,231,0,173,0,0,0,103,0,5,0,0,0,28,0,0,0,190,0,140,0,139,0,221,0,77,0,235,0,161,0,183,0,5,0,0,0,37,0,33,0,236,0,198,0,106,0,0,0,99,0,24,0,0,0,3,0,149,0,99,0,117,0,36,0,0,0,240,0,208,0,80,0,66,0,35,0,86,0,145,0,189,0,0,0,10,0,165,0,111,0,84,0,11,0,124,0,120,0,0,0,194,0,0,0,0,0,1,0,91,0,0,0,127,0,0,0,95,0,71,0,8,0,134,0,1,0,0,0,0,0,19,0,46,0,232,0,227,0,0,0,120,0,163,0,0,0,0,0,53,0,61,0,97,0,20,0,68,0,151,0,0,0,227,0,106,0,0,0,17,0,116,0,62,0,211,0,148,0,0,0,19,0,221,0,210,0,0,0,84,0,235,0,0,0,0,0,163,0,159,0,78,0,60,0,0,0,54,0,0,0,45,0,98,0,169,0,22,0,243,0,242,0,0,0,118,0,0,0,134,0,143,0,79,0,127,0,67,0,0,0,151,0,17,0);
signal scenario_full  : scenario_type := (86,31,179,31,221,31,221,30,138,31,228,31,94,31,42,31,42,30,115,31,195,31,195,30,78,31,109,31,146,31,193,31,193,30,193,29,193,28,25,31,25,30,80,31,190,31,190,30,190,29,169,31,104,31,104,30,142,31,28,31,76,31,138,31,138,30,196,31,116,31,126,31,187,31,187,30,37,31,69,31,69,30,137,31,225,31,11,31,86,31,248,31,66,31,47,31,167,31,114,31,67,31,200,31,11,31,11,30,180,31,165,31,63,31,231,31,112,31,129,31,125,31,249,31,28,31,68,31,173,31,215,31,215,30,238,31,177,31,68,31,195,31,25,31,145,31,46,31,30,31,187,31,215,31,156,31,156,30,34,31,75,31,65,31,117,31,3,31,143,31,100,31,4,31,9,31,9,30,9,29,141,31,141,30,246,31,246,30,14,31,226,31,174,31,99,31,99,30,231,31,190,31,190,30,190,29,190,28,35,31,14,31,46,31,46,30,1,31,193,31,193,30,132,31,12,31,97,31,168,31,33,31,56,31,194,31,247,31,89,31,62,31,141,31,141,30,116,31,180,31,202,31,151,31,151,30,52,31,245,31,2,31,174,31,174,30,28,31,28,30,28,29,231,31,231,30,231,29,114,31,107,31,255,31,205,31,91,31,212,31,201,31,186,31,27,31,108,31,86,31,92,31,92,30,92,31,92,30,61,31,186,31,37,31,108,31,89,31,6,31,92,31,123,31,123,31,204,31,204,30,76,31,65,31,66,31,66,30,66,29,220,31,24,31,7,31,163,31,163,30,163,29,163,28,173,31,174,31,179,31,4,31,4,30,13,31,26,31,115,31,125,31,192,31,201,31,188,31,206,31,106,31,17,31,17,30,17,29,17,28,17,27,171,31,83,31,239,31,108,31,125,31,198,31,171,31,47,31,164,31,95,31,149,31,131,31,131,30,141,31,141,30,220,31,166,31,231,31,231,30,13,31,171,31,206,31,249,31,249,30,67,31,218,31,218,30,202,31,112,31,112,30,180,31,212,31,2,31,2,30,124,31,147,31,147,30,198,31,198,30,198,29,186,31,35,31,161,31,202,31,37,31,37,31,55,31,180,31,180,30,153,31,91,31,106,31,48,31,108,31,27,31,144,31,220,31,80,31,48,31,12,31,27,31,27,30,27,29,27,28,182,31,37,31,37,30,110,31,255,31,67,31,151,31,32,31,184,31,255,31,231,31,173,31,173,30,103,31,5,31,5,30,28,31,28,30,190,31,140,31,139,31,221,31,77,31,235,31,161,31,183,31,5,31,5,30,37,31,33,31,236,31,198,31,106,31,106,30,99,31,24,31,24,30,3,31,149,31,99,31,117,31,36,31,36,30,240,31,208,31,80,31,66,31,35,31,86,31,145,31,189,31,189,30,10,31,165,31,111,31,84,31,11,31,124,31,120,31,120,30,194,31,194,30,194,29,1,31,91,31,91,30,127,31,127,30,95,31,71,31,8,31,134,31,1,31,1,30,1,29,19,31,46,31,232,31,227,31,227,30,120,31,163,31,163,30,163,29,53,31,61,31,97,31,20,31,68,31,151,31,151,30,227,31,106,31,106,30,17,31,116,31,62,31,211,31,148,31,148,30,19,31,221,31,210,31,210,30,84,31,235,31,235,30,235,29,163,31,159,31,78,31,60,31,60,30,54,31,54,30,45,31,98,31,169,31,22,31,243,31,242,31,242,30,118,31,118,30,134,31,143,31,79,31,127,31,67,31,67,30,151,31,17,31);

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
