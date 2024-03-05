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

constant SCENARIO_LENGTH : integer := 315;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (253,0,251,0,11,0,120,0,202,0,156,0,48,0,151,0,164,0,198,0,202,0,216,0,236,0,29,0,98,0,17,0,75,0,213,0,248,0,125,0,84,0,169,0,38,0,7,0,0,0,0,0,194,0,69,0,55,0,0,0,48,0,0,0,73,0,0,0,180,0,106,0,0,0,0,0,148,0,172,0,101,0,0,0,29,0,143,0,0,0,246,0,162,0,0,0,252,0,44,0,0,0,0,0,27,0,37,0,37,0,83,0,239,0,0,0,25,0,189,0,186,0,0,0,167,0,120,0,74,0,187,0,142,0,252,0,112,0,0,0,42,0,254,0,241,0,95,0,22,0,62,0,72,0,0,0,14,0,228,0,28,0,212,0,229,0,0,0,66,0,88,0,146,0,238,0,137,0,251,0,205,0,62,0,161,0,229,0,25,0,243,0,190,0,242,0,181,0,155,0,78,0,7,0,203,0,153,0,184,0,200,0,28,0,230,0,205,0,0,0,0,0,113,0,214,0,224,0,0,0,243,0,8,0,93,0,0,0,9,0,82,0,77,0,112,0,0,0,229,0,7,0,27,0,182,0,0,0,119,0,77,0,164,0,129,0,67,0,49,0,167,0,143,0,183,0,253,0,204,0,176,0,86,0,0,0,100,0,8,0,107,0,126,0,0,0,205,0,0,0,249,0,112,0,0,0,129,0,210,0,56,0,112,0,125,0,237,0,34,0,13,0,214,0,61,0,84,0,210,0,183,0,184,0,196,0,245,0,24,0,48,0,210,0,30,0,30,0,252,0,0,0,179,0,14,0,81,0,182,0,107,0,156,0,0,0,252,0,231,0,240,0,10,0,222,0,57,0,233,0,85,0,152,0,230,0,191,0,54,0,0,0,30,0,201,0,206,0,107,0,225,0,188,0,170,0,9,0,185,0,72,0,176,0,114,0,117,0,182,0,202,0,0,0,0,0,195,0,190,0,255,0,0,0,146,0,226,0,217,0,70,0,188,0,140,0,114,0,252,0,75,0,83,0,241,0,121,0,0,0,213,0,50,0,124,0,99,0,172,0,0,0,254,0,26,0,210,0,151,0,49,0,35,0,0,0,95,0,0,0,0,0,225,0,188,0,0,0,178,0,118,0,247,0,176,0,240,0,14,0,103,0,54,0,203,0,0,0,185,0,86,0,0,0,118,0,184,0,181,0,37,0,0,0,124,0,238,0,49,0,0,0,26,0,0,0,77,0,0,0,164,0,0,0,10,0,45,0,10,0,0,0,11,0,236,0,0,0,138,0,148,0,231,0,6,0,0,0,255,0,198,0,235,0,159,0,198,0,0,0,98,0,177,0,87,0,43,0,203,0,223,0,0,0,125,0,128,0,24,0,92,0,216,0,0,0,75,0,112,0,208,0,37,0,201,0,79,0,0,0);
signal scenario_full  : scenario_type := (253,31,251,31,11,31,120,31,202,31,156,31,48,31,151,31,164,31,198,31,202,31,216,31,236,31,29,31,98,31,17,31,75,31,213,31,248,31,125,31,84,31,169,31,38,31,7,31,7,30,7,29,194,31,69,31,55,31,55,30,48,31,48,30,73,31,73,30,180,31,106,31,106,30,106,29,148,31,172,31,101,31,101,30,29,31,143,31,143,30,246,31,162,31,162,30,252,31,44,31,44,30,44,29,27,31,37,31,37,31,83,31,239,31,239,30,25,31,189,31,186,31,186,30,167,31,120,31,74,31,187,31,142,31,252,31,112,31,112,30,42,31,254,31,241,31,95,31,22,31,62,31,72,31,72,30,14,31,228,31,28,31,212,31,229,31,229,30,66,31,88,31,146,31,238,31,137,31,251,31,205,31,62,31,161,31,229,31,25,31,243,31,190,31,242,31,181,31,155,31,78,31,7,31,203,31,153,31,184,31,200,31,28,31,230,31,205,31,205,30,205,29,113,31,214,31,224,31,224,30,243,31,8,31,93,31,93,30,9,31,82,31,77,31,112,31,112,30,229,31,7,31,27,31,182,31,182,30,119,31,77,31,164,31,129,31,67,31,49,31,167,31,143,31,183,31,253,31,204,31,176,31,86,31,86,30,100,31,8,31,107,31,126,31,126,30,205,31,205,30,249,31,112,31,112,30,129,31,210,31,56,31,112,31,125,31,237,31,34,31,13,31,214,31,61,31,84,31,210,31,183,31,184,31,196,31,245,31,24,31,48,31,210,31,30,31,30,31,252,31,252,30,179,31,14,31,81,31,182,31,107,31,156,31,156,30,252,31,231,31,240,31,10,31,222,31,57,31,233,31,85,31,152,31,230,31,191,31,54,31,54,30,30,31,201,31,206,31,107,31,225,31,188,31,170,31,9,31,185,31,72,31,176,31,114,31,117,31,182,31,202,31,202,30,202,29,195,31,190,31,255,31,255,30,146,31,226,31,217,31,70,31,188,31,140,31,114,31,252,31,75,31,83,31,241,31,121,31,121,30,213,31,50,31,124,31,99,31,172,31,172,30,254,31,26,31,210,31,151,31,49,31,35,31,35,30,95,31,95,30,95,29,225,31,188,31,188,30,178,31,118,31,247,31,176,31,240,31,14,31,103,31,54,31,203,31,203,30,185,31,86,31,86,30,118,31,184,31,181,31,37,31,37,30,124,31,238,31,49,31,49,30,26,31,26,30,77,31,77,30,164,31,164,30,10,31,45,31,10,31,10,30,11,31,236,31,236,30,138,31,148,31,231,31,6,31,6,30,255,31,198,31,235,31,159,31,198,31,198,30,98,31,177,31,87,31,43,31,203,31,223,31,223,30,125,31,128,31,24,31,92,31,216,31,216,30,75,31,112,31,208,31,37,31,201,31,79,31,79,30);

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
