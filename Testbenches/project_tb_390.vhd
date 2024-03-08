-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_390 is
end project_tb_390;

architecture project_tb_arch_390 of project_tb_390 is
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

constant SCENARIO_LENGTH : integer := 348;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,77,0,242,0,0,0,1,0,83,0,255,0,166,0,4,0,0,0,165,0,167,0,145,0,20,0,16,0,0,0,18,0,0,0,0,0,31,0,0,0,76,0,0,0,10,0,82,0,0,0,158,0,107,0,151,0,127,0,0,0,114,0,253,0,0,0,0,0,133,0,118,0,72,0,175,0,78,0,0,0,89,0,44,0,124,0,91,0,0,0,123,0,30,0,108,0,46,0,129,0,72,0,136,0,0,0,102,0,29,0,219,0,41,0,70,0,6,0,33,0,131,0,226,0,118,0,253,0,104,0,0,0,49,0,67,0,0,0,72,0,0,0,128,0,135,0,201,0,226,0,195,0,103,0,171,0,242,0,0,0,128,0,216,0,0,0,0,0,210,0,94,0,191,0,18,0,88,0,10,0,239,0,226,0,0,0,159,0,14,0,228,0,0,0,95,0,0,0,24,0,172,0,234,0,22,0,45,0,0,0,0,0,0,0,67,0,121,0,197,0,68,0,223,0,39,0,211,0,5,0,0,0,19,0,0,0,177,0,112,0,0,0,192,0,47,0,106,0,182,0,46,0,36,0,123,0,149,0,0,0,78,0,68,0,197,0,23,0,216,0,165,0,59,0,152,0,13,0,167,0,226,0,114,0,8,0,192,0,22,0,75,0,118,0,172,0,123,0,202,0,153,0,243,0,0,0,65,0,154,0,43,0,167,0,191,0,135,0,209,0,145,0,222,0,95,0,10,0,161,0,183,0,164,0,0,0,115,0,100,0,0,0,58,0,0,0,14,0,135,0,114,0,153,0,86,0,54,0,130,0,24,0,0,0,243,0,203,0,111,0,59,0,6,0,60,0,48,0,222,0,212,0,5,0,193,0,108,0,0,0,79,0,201,0,201,0,93,0,0,0,0,0,63,0,189,0,225,0,64,0,228,0,108,0,211,0,6,0,107,0,228,0,221,0,81,0,0,0,222,0,176,0,27,0,214,0,205,0,117,0,72,0,48,0,0,0,63,0,0,0,0,0,61,0,27,0,4,0,170,0,147,0,101,0,88,0,221,0,2,0,0,0,0,0,33,0,39,0,0,0,38,0,0,0,215,0,0,0,48,0,151,0,0,0,34,0,165,0,111,0,0,0,124,0,43,0,172,0,25,0,134,0,0,0,98,0,232,0,209,0,16,0,152,0,252,0,247,0,127,0,78,0,78,0,50,0,164,0,25,0,196,0,56,0,64,0,68,0,94,0,0,0,206,0,29,0,0,0,0,0,0,0,0,0,218,0,165,0,0,0,0,0,0,0,91,0,8,0,181,0,83,0,33,0,141,0,103,0,84,0,80,0,65,0,64,0,88,0,56,0,46,0,0,0,0,0,46,0,195,0,67,0,131,0,172,0,215,0,86,0,54,0,0,0,140,0,246,0,5,0,59,0,178,0,77,0,0,0,0,0,0,0,16,0,190,0,57,0,94,0,71,0,33,0,171,0,29,0,0,0,0,0,0,0,62,0,0,0,101,0,0,0,31,0,160,0,122,0,173,0,233,0,47,0,32,0,83,0,166,0,0,0,158,0);
signal scenario_full  : scenario_type := (0,0,77,31,242,31,242,30,1,31,83,31,255,31,166,31,4,31,4,30,165,31,167,31,145,31,20,31,16,31,16,30,18,31,18,30,18,29,31,31,31,30,76,31,76,30,10,31,82,31,82,30,158,31,107,31,151,31,127,31,127,30,114,31,253,31,253,30,253,29,133,31,118,31,72,31,175,31,78,31,78,30,89,31,44,31,124,31,91,31,91,30,123,31,30,31,108,31,46,31,129,31,72,31,136,31,136,30,102,31,29,31,219,31,41,31,70,31,6,31,33,31,131,31,226,31,118,31,253,31,104,31,104,30,49,31,67,31,67,30,72,31,72,30,128,31,135,31,201,31,226,31,195,31,103,31,171,31,242,31,242,30,128,31,216,31,216,30,216,29,210,31,94,31,191,31,18,31,88,31,10,31,239,31,226,31,226,30,159,31,14,31,228,31,228,30,95,31,95,30,24,31,172,31,234,31,22,31,45,31,45,30,45,29,45,28,67,31,121,31,197,31,68,31,223,31,39,31,211,31,5,31,5,30,19,31,19,30,177,31,112,31,112,30,192,31,47,31,106,31,182,31,46,31,36,31,123,31,149,31,149,30,78,31,68,31,197,31,23,31,216,31,165,31,59,31,152,31,13,31,167,31,226,31,114,31,8,31,192,31,22,31,75,31,118,31,172,31,123,31,202,31,153,31,243,31,243,30,65,31,154,31,43,31,167,31,191,31,135,31,209,31,145,31,222,31,95,31,10,31,161,31,183,31,164,31,164,30,115,31,100,31,100,30,58,31,58,30,14,31,135,31,114,31,153,31,86,31,54,31,130,31,24,31,24,30,243,31,203,31,111,31,59,31,6,31,60,31,48,31,222,31,212,31,5,31,193,31,108,31,108,30,79,31,201,31,201,31,93,31,93,30,93,29,63,31,189,31,225,31,64,31,228,31,108,31,211,31,6,31,107,31,228,31,221,31,81,31,81,30,222,31,176,31,27,31,214,31,205,31,117,31,72,31,48,31,48,30,63,31,63,30,63,29,61,31,27,31,4,31,170,31,147,31,101,31,88,31,221,31,2,31,2,30,2,29,33,31,39,31,39,30,38,31,38,30,215,31,215,30,48,31,151,31,151,30,34,31,165,31,111,31,111,30,124,31,43,31,172,31,25,31,134,31,134,30,98,31,232,31,209,31,16,31,152,31,252,31,247,31,127,31,78,31,78,31,50,31,164,31,25,31,196,31,56,31,64,31,68,31,94,31,94,30,206,31,29,31,29,30,29,29,29,28,29,27,218,31,165,31,165,30,165,29,165,28,91,31,8,31,181,31,83,31,33,31,141,31,103,31,84,31,80,31,65,31,64,31,88,31,56,31,46,31,46,30,46,29,46,31,195,31,67,31,131,31,172,31,215,31,86,31,54,31,54,30,140,31,246,31,5,31,59,31,178,31,77,31,77,30,77,29,77,28,16,31,190,31,57,31,94,31,71,31,33,31,171,31,29,31,29,30,29,29,29,28,62,31,62,30,101,31,101,30,31,31,160,31,122,31,173,31,233,31,47,31,32,31,83,31,166,31,166,30,158,31);

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
