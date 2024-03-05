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

constant SCENARIO_LENGTH : integer := 382;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,145,0,0,0,89,0,113,0,75,0,157,0,201,0,4,0,0,0,0,0,68,0,134,0,56,0,35,0,40,0,254,0,92,0,65,0,44,0,30,0,140,0,244,0,26,0,195,0,0,0,253,0,229,0,0,0,0,0,128,0,151,0,164,0,53,0,42,0,46,0,220,0,200,0,181,0,13,0,119,0,210,0,103,0,0,0,190,0,161,0,229,0,0,0,43,0,26,0,161,0,156,0,242,0,5,0,23,0,171,0,0,0,9,0,189,0,188,0,231,0,0,0,67,0,0,0,193,0,91,0,0,0,232,0,34,0,47,0,225,0,39,0,226,0,40,0,104,0,115,0,73,0,0,0,83,0,84,0,94,0,0,0,199,0,22,0,30,0,175,0,63,0,57,0,0,0,181,0,159,0,0,0,193,0,163,0,5,0,3,0,163,0,27,0,167,0,245,0,0,0,54,0,0,0,141,0,66,0,174,0,255,0,150,0,230,0,236,0,0,0,100,0,34,0,159,0,244,0,120,0,156,0,188,0,148,0,70,0,218,0,114,0,209,0,16,0,22,0,126,0,222,0,12,0,85,0,66,0,213,0,159,0,175,0,0,0,0,0,194,0,208,0,195,0,245,0,205,0,201,0,81,0,253,0,17,0,144,0,127,0,28,0,35,0,178,0,103,0,18,0,155,0,56,0,247,0,19,0,60,0,240,0,114,0,127,0,219,0,76,0,17,0,40,0,14,0,19,0,246,0,0,0,214,0,166,0,0,0,2,0,250,0,109,0,45,0,39,0,101,0,44,0,8,0,29,0,22,0,36,0,53,0,138,0,226,0,249,0,159,0,218,0,185,0,245,0,66,0,19,0,78,0,0,0,125,0,63,0,219,0,0,0,39,0,0,0,131,0,0,0,58,0,192,0,234,0,80,0,0,0,172,0,0,0,98,0,55,0,71,0,0,0,0,0,0,0,0,0,191,0,123,0,0,0,66,0,54,0,22,0,59,0,102,0,5,0,92,0,0,0,0,0,241,0,146,0,236,0,153,0,207,0,61,0,60,0,155,0,49,0,61,0,94,0,7,0,76,0,117,0,0,0,43,0,170,0,85,0,0,0,201,0,48,0,103,0,0,0,24,0,7,0,245,0,82,0,88,0,173,0,87,0,0,0,62,0,1,0,0,0,5,0,0,0,104,0,127,0,210,0,0,0,0,0,216,0,61,0,177,0,159,0,0,0,129,0,121,0,159,0,208,0,124,0,182,0,237,0,139,0,236,0,115,0,113,0,131,0,182,0,131,0,219,0,112,0,0,0,208,0,121,0,76,0,0,0,105,0,0,0,32,0,222,0,42,0,36,0,189,0,234,0,172,0,24,0,9,0,251,0,180,0,0,0,48,0,42,0,15,0,34,0,0,0,201,0,49,0,241,0,0,0,226,0,141,0,115,0,62,0,101,0,45,0,208,0,0,0,158,0,66,0,133,0,43,0,94,0,0,0,25,0,0,0,101,0,253,0,192,0,209,0,190,0,58,0,20,0,112,0,14,0,248,0,140,0,48,0,0,0,139,0,0,0,218,0,35,0,50,0,198,0,170,0,9,0,15,0,118,0,40,0,0,0,252,0,107,0,0,0,230,0,66,0,231,0,201,0,0,0,20,0,108,0,174,0,142,0,51,0,193,0,1,0,110,0,246,0,0,0,79,0,131,0,240,0,28,0,93,0,149,0);
signal scenario_full  : scenario_type := (0,0,145,31,145,30,89,31,113,31,75,31,157,31,201,31,4,31,4,30,4,29,68,31,134,31,56,31,35,31,40,31,254,31,92,31,65,31,44,31,30,31,140,31,244,31,26,31,195,31,195,30,253,31,229,31,229,30,229,29,128,31,151,31,164,31,53,31,42,31,46,31,220,31,200,31,181,31,13,31,119,31,210,31,103,31,103,30,190,31,161,31,229,31,229,30,43,31,26,31,161,31,156,31,242,31,5,31,23,31,171,31,171,30,9,31,189,31,188,31,231,31,231,30,67,31,67,30,193,31,91,31,91,30,232,31,34,31,47,31,225,31,39,31,226,31,40,31,104,31,115,31,73,31,73,30,83,31,84,31,94,31,94,30,199,31,22,31,30,31,175,31,63,31,57,31,57,30,181,31,159,31,159,30,193,31,163,31,5,31,3,31,163,31,27,31,167,31,245,31,245,30,54,31,54,30,141,31,66,31,174,31,255,31,150,31,230,31,236,31,236,30,100,31,34,31,159,31,244,31,120,31,156,31,188,31,148,31,70,31,218,31,114,31,209,31,16,31,22,31,126,31,222,31,12,31,85,31,66,31,213,31,159,31,175,31,175,30,175,29,194,31,208,31,195,31,245,31,205,31,201,31,81,31,253,31,17,31,144,31,127,31,28,31,35,31,178,31,103,31,18,31,155,31,56,31,247,31,19,31,60,31,240,31,114,31,127,31,219,31,76,31,17,31,40,31,14,31,19,31,246,31,246,30,214,31,166,31,166,30,2,31,250,31,109,31,45,31,39,31,101,31,44,31,8,31,29,31,22,31,36,31,53,31,138,31,226,31,249,31,159,31,218,31,185,31,245,31,66,31,19,31,78,31,78,30,125,31,63,31,219,31,219,30,39,31,39,30,131,31,131,30,58,31,192,31,234,31,80,31,80,30,172,31,172,30,98,31,55,31,71,31,71,30,71,29,71,28,71,27,191,31,123,31,123,30,66,31,54,31,22,31,59,31,102,31,5,31,92,31,92,30,92,29,241,31,146,31,236,31,153,31,207,31,61,31,60,31,155,31,49,31,61,31,94,31,7,31,76,31,117,31,117,30,43,31,170,31,85,31,85,30,201,31,48,31,103,31,103,30,24,31,7,31,245,31,82,31,88,31,173,31,87,31,87,30,62,31,1,31,1,30,5,31,5,30,104,31,127,31,210,31,210,30,210,29,216,31,61,31,177,31,159,31,159,30,129,31,121,31,159,31,208,31,124,31,182,31,237,31,139,31,236,31,115,31,113,31,131,31,182,31,131,31,219,31,112,31,112,30,208,31,121,31,76,31,76,30,105,31,105,30,32,31,222,31,42,31,36,31,189,31,234,31,172,31,24,31,9,31,251,31,180,31,180,30,48,31,42,31,15,31,34,31,34,30,201,31,49,31,241,31,241,30,226,31,141,31,115,31,62,31,101,31,45,31,208,31,208,30,158,31,66,31,133,31,43,31,94,31,94,30,25,31,25,30,101,31,253,31,192,31,209,31,190,31,58,31,20,31,112,31,14,31,248,31,140,31,48,31,48,30,139,31,139,30,218,31,35,31,50,31,198,31,170,31,9,31,15,31,118,31,40,31,40,30,252,31,107,31,107,30,230,31,66,31,231,31,201,31,201,30,20,31,108,31,174,31,142,31,51,31,193,31,1,31,110,31,246,31,246,30,79,31,131,31,240,31,28,31,93,31,149,31);

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
