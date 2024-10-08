-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_128 is
end project_tb_128;

architecture project_tb_arch_128 of project_tb_128 is
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

constant SCENARIO_LENGTH : integer := 326;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (9,0,14,0,234,0,140,0,62,0,12,0,198,0,78,0,0,0,92,0,20,0,19,0,173,0,133,0,36,0,24,0,0,0,89,0,179,0,0,0,157,0,62,0,243,0,0,0,0,0,8,0,197,0,255,0,82,0,43,0,0,0,10,0,203,0,156,0,0,0,52,0,0,0,86,0,187,0,131,0,6,0,199,0,86,0,156,0,111,0,83,0,169,0,0,0,162,0,202,0,165,0,243,0,171,0,0,0,251,0,79,0,232,0,245,0,251,0,74,0,179,0,236,0,75,0,32,0,159,0,203,0,63,0,42,0,0,0,226,0,142,0,65,0,66,0,127,0,201,0,161,0,171,0,8,0,86,0,40,0,134,0,218,0,223,0,163,0,185,0,0,0,185,0,209,0,222,0,188,0,64,0,206,0,250,0,0,0,200,0,18,0,0,0,94,0,166,0,143,0,0,0,40,0,0,0,252,0,32,0,30,0,221,0,117,0,104,0,125,0,226,0,232,0,41,0,106,0,39,0,91,0,108,0,131,0,150,0,0,0,229,0,0,0,219,0,0,0,0,0,189,0,86,0,120,0,5,0,183,0,248,0,141,0,116,0,46,0,247,0,133,0,93,0,130,0,0,0,184,0,188,0,101,0,212,0,34,0,0,0,2,0,206,0,73,0,77,0,255,0,181,0,118,0,33,0,4,0,0,0,89,0,52,0,171,0,92,0,146,0,5,0,25,0,156,0,87,0,54,0,217,0,0,0,57,0,240,0,195,0,66,0,49,0,0,0,37,0,91,0,75,0,151,0,250,0,121,0,46,0,83,0,111,0,0,0,42,0,0,0,26,0,226,0,104,0,223,0,255,0,146,0,155,0,147,0,248,0,9,0,123,0,0,0,170,0,0,0,0,0,121,0,161,0,188,0,188,0,46,0,0,0,216,0,60,0,218,0,251,0,84,0,0,0,161,0,213,0,0,0,199,0,69,0,118,0,44,0,165,0,80,0,0,0,0,0,84,0,189,0,197,0,142,0,118,0,52,0,13,0,8,0,0,0,0,0,41,0,112,0,219,0,1,0,0,0,0,0,0,0,92,0,0,0,221,0,213,0,150,0,83,0,0,0,7,0,135,0,153,0,144,0,73,0,52,0,230,0,213,0,0,0,205,0,67,0,194,0,145,0,148,0,0,0,184,0,87,0,0,0,0,0,0,0,190,0,115,0,8,0,27,0,255,0,83,0,126,0,173,0,13,0,199,0,164,0,186,0,0,0,165,0,81,0,127,0,101,0,34,0,178,0,0,0,188,0,113,0,129,0,0,0,198,0,0,0,0,0,0,0,145,0,52,0,0,0,71,0,221,0,82,0,163,0,230,0,221,0,135,0,211,0,194,0,226,0,0,0,121,0,158,0,249,0,230,0,46,0,184,0,111,0,164,0,48,0,197,0,177,0,43,0,27,0,0,0,10,0,199,0,19,0);
signal scenario_full  : scenario_type := (9,31,14,31,234,31,140,31,62,31,12,31,198,31,78,31,78,30,92,31,20,31,19,31,173,31,133,31,36,31,24,31,24,30,89,31,179,31,179,30,157,31,62,31,243,31,243,30,243,29,8,31,197,31,255,31,82,31,43,31,43,30,10,31,203,31,156,31,156,30,52,31,52,30,86,31,187,31,131,31,6,31,199,31,86,31,156,31,111,31,83,31,169,31,169,30,162,31,202,31,165,31,243,31,171,31,171,30,251,31,79,31,232,31,245,31,251,31,74,31,179,31,236,31,75,31,32,31,159,31,203,31,63,31,42,31,42,30,226,31,142,31,65,31,66,31,127,31,201,31,161,31,171,31,8,31,86,31,40,31,134,31,218,31,223,31,163,31,185,31,185,30,185,31,209,31,222,31,188,31,64,31,206,31,250,31,250,30,200,31,18,31,18,30,94,31,166,31,143,31,143,30,40,31,40,30,252,31,32,31,30,31,221,31,117,31,104,31,125,31,226,31,232,31,41,31,106,31,39,31,91,31,108,31,131,31,150,31,150,30,229,31,229,30,219,31,219,30,219,29,189,31,86,31,120,31,5,31,183,31,248,31,141,31,116,31,46,31,247,31,133,31,93,31,130,31,130,30,184,31,188,31,101,31,212,31,34,31,34,30,2,31,206,31,73,31,77,31,255,31,181,31,118,31,33,31,4,31,4,30,89,31,52,31,171,31,92,31,146,31,5,31,25,31,156,31,87,31,54,31,217,31,217,30,57,31,240,31,195,31,66,31,49,31,49,30,37,31,91,31,75,31,151,31,250,31,121,31,46,31,83,31,111,31,111,30,42,31,42,30,26,31,226,31,104,31,223,31,255,31,146,31,155,31,147,31,248,31,9,31,123,31,123,30,170,31,170,30,170,29,121,31,161,31,188,31,188,31,46,31,46,30,216,31,60,31,218,31,251,31,84,31,84,30,161,31,213,31,213,30,199,31,69,31,118,31,44,31,165,31,80,31,80,30,80,29,84,31,189,31,197,31,142,31,118,31,52,31,13,31,8,31,8,30,8,29,41,31,112,31,219,31,1,31,1,30,1,29,1,28,92,31,92,30,221,31,213,31,150,31,83,31,83,30,7,31,135,31,153,31,144,31,73,31,52,31,230,31,213,31,213,30,205,31,67,31,194,31,145,31,148,31,148,30,184,31,87,31,87,30,87,29,87,28,190,31,115,31,8,31,27,31,255,31,83,31,126,31,173,31,13,31,199,31,164,31,186,31,186,30,165,31,81,31,127,31,101,31,34,31,178,31,178,30,188,31,113,31,129,31,129,30,198,31,198,30,198,29,198,28,145,31,52,31,52,30,71,31,221,31,82,31,163,31,230,31,221,31,135,31,211,31,194,31,226,31,226,30,121,31,158,31,249,31,230,31,46,31,184,31,111,31,164,31,48,31,197,31,177,31,43,31,27,31,27,30,10,31,199,31,19,31);

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
