-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_356 is
end project_tb_356;

architecture project_tb_arch_356 of project_tb_356 is
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

constant SCENARIO_LENGTH : integer := 367;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (40,0,0,0,66,0,0,0,102,0,211,0,33,0,174,0,85,0,63,0,125,0,36,0,119,0,0,0,0,0,0,0,0,0,240,0,0,0,152,0,172,0,150,0,96,0,0,0,224,0,143,0,172,0,254,0,1,0,0,0,56,0,0,0,240,0,195,0,0,0,217,0,96,0,132,0,36,0,0,0,32,0,65,0,5,0,36,0,0,0,9,0,192,0,64,0,0,0,185,0,117,0,99,0,52,0,174,0,36,0,192,0,81,0,202,0,211,0,130,0,62,0,3,0,55,0,0,0,0,0,49,0,97,0,167,0,179,0,0,0,134,0,0,0,80,0,34,0,62,0,0,0,93,0,251,0,169,0,0,0,253,0,243,0,131,0,0,0,249,0,34,0,75,0,173,0,253,0,188,0,48,0,136,0,140,0,56,0,137,0,22,0,38,0,245,0,0,0,103,0,155,0,164,0,221,0,149,0,44,0,104,0,0,0,230,0,96,0,84,0,56,0,86,0,201,0,162,0,107,0,102,0,241,0,245,0,218,0,99,0,0,0,184,0,8,0,0,0,155,0,48,0,152,0,254,0,0,0,25,0,162,0,89,0,208,0,166,0,0,0,210,0,0,0,130,0,126,0,0,0,0,0,160,0,0,0,0,0,130,0,240,0,225,0,251,0,153,0,49,0,0,0,29,0,249,0,214,0,77,0,0,0,85,0,0,0,91,0,234,0,143,0,150,0,240,0,188,0,40,0,45,0,3,0,0,0,0,0,236,0,64,0,147,0,130,0,0,0,208,0,68,0,0,0,32,0,222,0,31,0,0,0,194,0,240,0,190,0,43,0,220,0,106,0,156,0,210,0,127,0,228,0,2,0,20,0,146,0,74,0,232,0,10,0,123,0,131,0,162,0,67,0,10,0,67,0,120,0,237,0,132,0,204,0,10,0,0,0,0,0,232,0,0,0,230,0,33,0,171,0,72,0,0,0,35,0,14,0,157,0,159,0,221,0,188,0,230,0,122,0,98,0,129,0,0,0,52,0,0,0,104,0,140,0,228,0,0,0,105,0,206,0,173,0,0,0,133,0,0,0,17,0,42,0,206,0,0,0,178,0,111,0,43,0,28,0,9,0,152,0,207,0,191,0,2,0,0,0,39,0,124,0,91,0,0,0,1,0,227,0,130,0,209,0,26,0,229,0,166,0,232,0,198,0,0,0,111,0,240,0,63,0,0,0,151,0,0,0,203,0,0,0,88,0,0,0,0,0,204,0,95,0,0,0,46,0,171,0,214,0,0,0,0,0,79,0,149,0,0,0,0,0,23,0,170,0,53,0,133,0,102,0,18,0,18,0,0,0,53,0,128,0,177,0,0,0,26,0,132,0,0,0,146,0,68,0,115,0,106,0,103,0,114,0,32,0,56,0,0,0,57,0,94,0,102,0,0,0,0,0,0,0,53,0,0,0,62,0,153,0,224,0,0,0,0,0,0,0,172,0,0,0,0,0,14,0,0,0,154,0,32,0,229,0,169,0,158,0,167,0,199,0,0,0,94,0,139,0,207,0,30,0,0,0,157,0,112,0,179,0,136,0,9,0,93,0,45,0,43,0,0,0,5,0,0,0,232,0,66,0,237,0,45,0,124,0,131,0,0,0,108,0,78,0);
signal scenario_full  : scenario_type := (40,31,40,30,66,31,66,30,102,31,211,31,33,31,174,31,85,31,63,31,125,31,36,31,119,31,119,30,119,29,119,28,119,27,240,31,240,30,152,31,172,31,150,31,96,31,96,30,224,31,143,31,172,31,254,31,1,31,1,30,56,31,56,30,240,31,195,31,195,30,217,31,96,31,132,31,36,31,36,30,32,31,65,31,5,31,36,31,36,30,9,31,192,31,64,31,64,30,185,31,117,31,99,31,52,31,174,31,36,31,192,31,81,31,202,31,211,31,130,31,62,31,3,31,55,31,55,30,55,29,49,31,97,31,167,31,179,31,179,30,134,31,134,30,80,31,34,31,62,31,62,30,93,31,251,31,169,31,169,30,253,31,243,31,131,31,131,30,249,31,34,31,75,31,173,31,253,31,188,31,48,31,136,31,140,31,56,31,137,31,22,31,38,31,245,31,245,30,103,31,155,31,164,31,221,31,149,31,44,31,104,31,104,30,230,31,96,31,84,31,56,31,86,31,201,31,162,31,107,31,102,31,241,31,245,31,218,31,99,31,99,30,184,31,8,31,8,30,155,31,48,31,152,31,254,31,254,30,25,31,162,31,89,31,208,31,166,31,166,30,210,31,210,30,130,31,126,31,126,30,126,29,160,31,160,30,160,29,130,31,240,31,225,31,251,31,153,31,49,31,49,30,29,31,249,31,214,31,77,31,77,30,85,31,85,30,91,31,234,31,143,31,150,31,240,31,188,31,40,31,45,31,3,31,3,30,3,29,236,31,64,31,147,31,130,31,130,30,208,31,68,31,68,30,32,31,222,31,31,31,31,30,194,31,240,31,190,31,43,31,220,31,106,31,156,31,210,31,127,31,228,31,2,31,20,31,146,31,74,31,232,31,10,31,123,31,131,31,162,31,67,31,10,31,67,31,120,31,237,31,132,31,204,31,10,31,10,30,10,29,232,31,232,30,230,31,33,31,171,31,72,31,72,30,35,31,14,31,157,31,159,31,221,31,188,31,230,31,122,31,98,31,129,31,129,30,52,31,52,30,104,31,140,31,228,31,228,30,105,31,206,31,173,31,173,30,133,31,133,30,17,31,42,31,206,31,206,30,178,31,111,31,43,31,28,31,9,31,152,31,207,31,191,31,2,31,2,30,39,31,124,31,91,31,91,30,1,31,227,31,130,31,209,31,26,31,229,31,166,31,232,31,198,31,198,30,111,31,240,31,63,31,63,30,151,31,151,30,203,31,203,30,88,31,88,30,88,29,204,31,95,31,95,30,46,31,171,31,214,31,214,30,214,29,79,31,149,31,149,30,149,29,23,31,170,31,53,31,133,31,102,31,18,31,18,31,18,30,53,31,128,31,177,31,177,30,26,31,132,31,132,30,146,31,68,31,115,31,106,31,103,31,114,31,32,31,56,31,56,30,57,31,94,31,102,31,102,30,102,29,102,28,53,31,53,30,62,31,153,31,224,31,224,30,224,29,224,28,172,31,172,30,172,29,14,31,14,30,154,31,32,31,229,31,169,31,158,31,167,31,199,31,199,30,94,31,139,31,207,31,30,31,30,30,157,31,112,31,179,31,136,31,9,31,93,31,45,31,43,31,43,30,5,31,5,30,232,31,66,31,237,31,45,31,124,31,131,31,131,30,108,31,78,31);

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
