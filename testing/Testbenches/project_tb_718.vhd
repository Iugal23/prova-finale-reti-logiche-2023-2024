-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_718 is
end project_tb_718;

architecture project_tb_arch_718 of project_tb_718 is
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

constant SCENARIO_LENGTH : integer := 461;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (5,0,0,0,0,0,0,0,78,0,126,0,0,0,53,0,86,0,2,0,117,0,218,0,221,0,107,0,67,0,31,0,205,0,165,0,0,0,0,0,246,0,131,0,155,0,170,0,99,0,56,0,117,0,180,0,198,0,56,0,163,0,135,0,174,0,149,0,78,0,21,0,0,0,44,0,217,0,0,0,0,0,158,0,115,0,0,0,113,0,0,0,0,0,251,0,0,0,180,0,196,0,0,0,77,0,107,0,29,0,185,0,22,0,185,0,110,0,228,0,15,0,222,0,0,0,222,0,72,0,179,0,0,0,0,0,99,0,0,0,34,0,16,0,2,0,71,0,101,0,149,0,54,0,137,0,124,0,17,0,167,0,85,0,172,0,204,0,0,0,228,0,22,0,0,0,208,0,210,0,217,0,123,0,31,0,71,0,105,0,131,0,227,0,104,0,198,0,235,0,23,0,172,0,153,0,131,0,241,0,199,0,228,0,188,0,132,0,83,0,0,0,234,0,44,0,0,0,56,0,115,0,0,0,26,0,79,0,47,0,3,0,132,0,1,0,174,0,151,0,156,0,230,0,108,0,0,0,101,0,0,0,6,0,0,0,200,0,64,0,0,0,191,0,129,0,0,0,111,0,64,0,180,0,118,0,0,0,4,0,53,0,61,0,152,0,176,0,0,0,107,0,0,0,103,0,119,0,157,0,0,0,150,0,0,0,163,0,142,0,146,0,0,0,140,0,164,0,139,0,205,0,73,0,10,0,29,0,45,0,106,0,71,0,0,0,192,0,89,0,98,0,157,0,233,0,247,0,17,0,0,0,237,0,0,0,3,0,171,0,5,0,244,0,151,0,34,0,161,0,0,0,0,0,14,0,252,0,158,0,245,0,88,0,187,0,0,0,117,0,176,0,203,0,2,0,251,0,4,0,13,0,93,0,207,0,92,0,0,0,101,0,148,0,0,0,0,0,64,0,1,0,146,0,65,0,241,0,0,0,91,0,186,0,252,0,251,0,0,0,141,0,174,0,85,0,216,0,36,0,153,0,38,0,255,0,105,0,125,0,79,0,254,0,171,0,247,0,75,0,114,0,9,0,0,0,212,0,141,0,41,0,146,0,126,0,0,0,234,0,94,0,145,0,176,0,231,0,191,0,0,0,0,0,0,0,240,0,86,0,0,0,0,0,42,0,127,0,141,0,35,0,177,0,104,0,135,0,45,0,103,0,0,0,123,0,121,0,27,0,0,0,0,0,62,0,76,0,0,0,72,0,12,0,216,0,219,0,254,0,240,0,6,0,66,0,0,0,0,0,226,0,54,0,182,0,165,0,210,0,189,0,54,0,216,0,232,0,77,0,194,0,151,0,0,0,13,0,217,0,22,0,228,0,72,0,145,0,0,0,2,0,0,0,107,0,185,0,0,0,133,0,31,0,123,0,21,0,144,0,52,0,0,0,222,0,0,0,243,0,162,0,63,0,109,0,48,0,202,0,0,0,238,0,206,0,0,0,226,0,0,0,19,0,16,0,100,0,0,0,25,0,200,0,73,0,0,0,254,0,255,0,0,0,0,0,0,0,230,0,8,0,0,0,232,0,192,0,59,0,108,0,0,0,131,0,179,0,0,0,130,0,140,0,143,0,119,0,108,0,148,0,231,0,34,0,40,0,231,0,0,0,0,0,0,0,140,0,119,0,0,0,0,0,159,0,0,0,19,0,120,0,53,0,99,0,0,0,0,0,0,0,200,0,0,0,209,0,0,0,81,0,180,0,71,0,158,0,255,0,167,0,0,0,109,0,230,0,236,0,39,0,0,0,76,0,46,0,67,0,78,0,218,0,142,0,145,0,168,0,162,0,175,0,108,0,231,0,0,0,131,0,23,0,1,0,34,0,122,0,71,0,0,0,133,0,214,0,0,0,27,0,28,0,0,0,197,0,75,0,198,0,0,0,211,0,249,0,0,0,162,0,32,0,0,0,8,0,152,0,233,0,20,0,82,0,99,0,190,0,119,0,0,0,93,0,24,0,231,0,0,0,140,0,174,0,162,0,148,0,13,0,0,0,65,0,92,0,0,0,13,0);
signal scenario_full  : scenario_type := (5,31,5,30,5,29,5,28,78,31,126,31,126,30,53,31,86,31,2,31,117,31,218,31,221,31,107,31,67,31,31,31,205,31,165,31,165,30,165,29,246,31,131,31,155,31,170,31,99,31,56,31,117,31,180,31,198,31,56,31,163,31,135,31,174,31,149,31,78,31,21,31,21,30,44,31,217,31,217,30,217,29,158,31,115,31,115,30,113,31,113,30,113,29,251,31,251,30,180,31,196,31,196,30,77,31,107,31,29,31,185,31,22,31,185,31,110,31,228,31,15,31,222,31,222,30,222,31,72,31,179,31,179,30,179,29,99,31,99,30,34,31,16,31,2,31,71,31,101,31,149,31,54,31,137,31,124,31,17,31,167,31,85,31,172,31,204,31,204,30,228,31,22,31,22,30,208,31,210,31,217,31,123,31,31,31,71,31,105,31,131,31,227,31,104,31,198,31,235,31,23,31,172,31,153,31,131,31,241,31,199,31,228,31,188,31,132,31,83,31,83,30,234,31,44,31,44,30,56,31,115,31,115,30,26,31,79,31,47,31,3,31,132,31,1,31,174,31,151,31,156,31,230,31,108,31,108,30,101,31,101,30,6,31,6,30,200,31,64,31,64,30,191,31,129,31,129,30,111,31,64,31,180,31,118,31,118,30,4,31,53,31,61,31,152,31,176,31,176,30,107,31,107,30,103,31,119,31,157,31,157,30,150,31,150,30,163,31,142,31,146,31,146,30,140,31,164,31,139,31,205,31,73,31,10,31,29,31,45,31,106,31,71,31,71,30,192,31,89,31,98,31,157,31,233,31,247,31,17,31,17,30,237,31,237,30,3,31,171,31,5,31,244,31,151,31,34,31,161,31,161,30,161,29,14,31,252,31,158,31,245,31,88,31,187,31,187,30,117,31,176,31,203,31,2,31,251,31,4,31,13,31,93,31,207,31,92,31,92,30,101,31,148,31,148,30,148,29,64,31,1,31,146,31,65,31,241,31,241,30,91,31,186,31,252,31,251,31,251,30,141,31,174,31,85,31,216,31,36,31,153,31,38,31,255,31,105,31,125,31,79,31,254,31,171,31,247,31,75,31,114,31,9,31,9,30,212,31,141,31,41,31,146,31,126,31,126,30,234,31,94,31,145,31,176,31,231,31,191,31,191,30,191,29,191,28,240,31,86,31,86,30,86,29,42,31,127,31,141,31,35,31,177,31,104,31,135,31,45,31,103,31,103,30,123,31,121,31,27,31,27,30,27,29,62,31,76,31,76,30,72,31,12,31,216,31,219,31,254,31,240,31,6,31,66,31,66,30,66,29,226,31,54,31,182,31,165,31,210,31,189,31,54,31,216,31,232,31,77,31,194,31,151,31,151,30,13,31,217,31,22,31,228,31,72,31,145,31,145,30,2,31,2,30,107,31,185,31,185,30,133,31,31,31,123,31,21,31,144,31,52,31,52,30,222,31,222,30,243,31,162,31,63,31,109,31,48,31,202,31,202,30,238,31,206,31,206,30,226,31,226,30,19,31,16,31,100,31,100,30,25,31,200,31,73,31,73,30,254,31,255,31,255,30,255,29,255,28,230,31,8,31,8,30,232,31,192,31,59,31,108,31,108,30,131,31,179,31,179,30,130,31,140,31,143,31,119,31,108,31,148,31,231,31,34,31,40,31,231,31,231,30,231,29,231,28,140,31,119,31,119,30,119,29,159,31,159,30,19,31,120,31,53,31,99,31,99,30,99,29,99,28,200,31,200,30,209,31,209,30,81,31,180,31,71,31,158,31,255,31,167,31,167,30,109,31,230,31,236,31,39,31,39,30,76,31,46,31,67,31,78,31,218,31,142,31,145,31,168,31,162,31,175,31,108,31,231,31,231,30,131,31,23,31,1,31,34,31,122,31,71,31,71,30,133,31,214,31,214,30,27,31,28,31,28,30,197,31,75,31,198,31,198,30,211,31,249,31,249,30,162,31,32,31,32,30,8,31,152,31,233,31,20,31,82,31,99,31,190,31,119,31,119,30,93,31,24,31,231,31,231,30,140,31,174,31,162,31,148,31,13,31,13,30,65,31,92,31,92,30,13,31);

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
