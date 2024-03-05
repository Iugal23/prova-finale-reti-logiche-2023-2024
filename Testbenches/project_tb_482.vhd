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

constant SCENARIO_LENGTH : integer := 332;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (102,0,219,0,243,0,91,0,146,0,115,0,0,0,22,0,0,0,0,0,0,0,0,0,6,0,177,0,56,0,124,0,18,0,62,0,0,0,0,0,84,0,9,0,110,0,15,0,167,0,0,0,241,0,131,0,255,0,59,0,145,0,79,0,69,0,162,0,0,0,225,0,28,0,72,0,0,0,14,0,46,0,74,0,0,0,102,0,140,0,115,0,53,0,0,0,220,0,135,0,112,0,0,0,26,0,207,0,213,0,119,0,187,0,244,0,212,0,0,0,104,0,183,0,41,0,58,0,82,0,0,0,198,0,197,0,0,0,0,0,185,0,210,0,192,0,213,0,163,0,93,0,192,0,26,0,0,0,10,0,179,0,0,0,89,0,181,0,59,0,88,0,161,0,154,0,0,0,107,0,169,0,0,0,51,0,64,0,190,0,152,0,141,0,0,0,3,0,0,0,0,0,96,0,93,0,198,0,0,0,0,0,204,0,197,0,125,0,204,0,45,0,133,0,0,0,158,0,0,0,0,0,129,0,139,0,104,0,62,0,0,0,129,0,19,0,35,0,126,0,127,0,41,0,202,0,0,0,224,0,4,0,210,0,114,0,40,0,104,0,96,0,55,0,107,0,107,0,0,0,28,0,0,0,0,0,174,0,123,0,205,0,229,0,160,0,134,0,0,0,199,0,46,0,156,0,2,0,61,0,240,0,166,0,37,0,3,0,2,0,120,0,92,0,74,0,144,0,175,0,0,0,0,0,252,0,1,0,184,0,47,0,112,0,114,0,160,0,11,0,84,0,0,0,245,0,0,0,18,0,0,0,216,0,0,0,101,0,252,0,90,0,96,0,61,0,1,0,159,0,117,0,21,0,0,0,0,0,0,0,15,0,49,0,86,0,161,0,247,0,98,0,146,0,218,0,34,0,235,0,166,0,243,0,241,0,15,0,0,0,61,0,133,0,1,0,207,0,0,0,0,0,13,0,183,0,236,0,206,0,76,0,0,0,158,0,73,0,166,0,192,0,209,0,63,0,178,0,195,0,0,0,106,0,0,0,25,0,0,0,0,0,45,0,243,0,171,0,214,0,104,0,57,0,100,0,34,0,232,0,205,0,32,0,17,0,128,0,188,0,0,0,122,0,238,0,23,0,61,0,0,0,145,0,108,0,209,0,226,0,0,0,202,0,0,0,69,0,102,0,155,0,0,0,218,0,0,0,11,0,41,0,0,0,175,0,130,0,209,0,62,0,111,0,43,0,111,0,236,0,0,0,0,0,153,0,199,0,109,0,2,0,109,0,53,0,35,0,121,0,231,0,0,0,195,0,225,0,141,0,75,0,188,0,148,0,20,0,0,0,14,0,186,0,0,0,173,0,187,0,0,0,0,0,230,0,0,0,0,0,196,0,236,0,101,0,8,0,253,0,22,0,9,0,0,0,111,0,0,0,208,0,160,0,159,0,50,0,68,0,16,0,0,0,2,0,74,0,217,0,252,0,201,0);
signal scenario_full  : scenario_type := (102,31,219,31,243,31,91,31,146,31,115,31,115,30,22,31,22,30,22,29,22,28,22,27,6,31,177,31,56,31,124,31,18,31,62,31,62,30,62,29,84,31,9,31,110,31,15,31,167,31,167,30,241,31,131,31,255,31,59,31,145,31,79,31,69,31,162,31,162,30,225,31,28,31,72,31,72,30,14,31,46,31,74,31,74,30,102,31,140,31,115,31,53,31,53,30,220,31,135,31,112,31,112,30,26,31,207,31,213,31,119,31,187,31,244,31,212,31,212,30,104,31,183,31,41,31,58,31,82,31,82,30,198,31,197,31,197,30,197,29,185,31,210,31,192,31,213,31,163,31,93,31,192,31,26,31,26,30,10,31,179,31,179,30,89,31,181,31,59,31,88,31,161,31,154,31,154,30,107,31,169,31,169,30,51,31,64,31,190,31,152,31,141,31,141,30,3,31,3,30,3,29,96,31,93,31,198,31,198,30,198,29,204,31,197,31,125,31,204,31,45,31,133,31,133,30,158,31,158,30,158,29,129,31,139,31,104,31,62,31,62,30,129,31,19,31,35,31,126,31,127,31,41,31,202,31,202,30,224,31,4,31,210,31,114,31,40,31,104,31,96,31,55,31,107,31,107,31,107,30,28,31,28,30,28,29,174,31,123,31,205,31,229,31,160,31,134,31,134,30,199,31,46,31,156,31,2,31,61,31,240,31,166,31,37,31,3,31,2,31,120,31,92,31,74,31,144,31,175,31,175,30,175,29,252,31,1,31,184,31,47,31,112,31,114,31,160,31,11,31,84,31,84,30,245,31,245,30,18,31,18,30,216,31,216,30,101,31,252,31,90,31,96,31,61,31,1,31,159,31,117,31,21,31,21,30,21,29,21,28,15,31,49,31,86,31,161,31,247,31,98,31,146,31,218,31,34,31,235,31,166,31,243,31,241,31,15,31,15,30,61,31,133,31,1,31,207,31,207,30,207,29,13,31,183,31,236,31,206,31,76,31,76,30,158,31,73,31,166,31,192,31,209,31,63,31,178,31,195,31,195,30,106,31,106,30,25,31,25,30,25,29,45,31,243,31,171,31,214,31,104,31,57,31,100,31,34,31,232,31,205,31,32,31,17,31,128,31,188,31,188,30,122,31,238,31,23,31,61,31,61,30,145,31,108,31,209,31,226,31,226,30,202,31,202,30,69,31,102,31,155,31,155,30,218,31,218,30,11,31,41,31,41,30,175,31,130,31,209,31,62,31,111,31,43,31,111,31,236,31,236,30,236,29,153,31,199,31,109,31,2,31,109,31,53,31,35,31,121,31,231,31,231,30,195,31,225,31,141,31,75,31,188,31,148,31,20,31,20,30,14,31,186,31,186,30,173,31,187,31,187,30,187,29,230,31,230,30,230,29,196,31,236,31,101,31,8,31,253,31,22,31,9,31,9,30,111,31,111,30,208,31,160,31,159,31,50,31,68,31,16,31,16,30,2,31,74,31,217,31,252,31,201,31);

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
