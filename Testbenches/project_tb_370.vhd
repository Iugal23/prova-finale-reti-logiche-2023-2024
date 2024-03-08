-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_370 is
end project_tb_370;

architecture project_tb_arch_370 of project_tb_370 is
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

constant SCENARIO_LENGTH : integer := 290;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,60,0,0,0,72,0,197,0,104,0,221,0,74,0,0,0,6,0,38,0,127,0,117,0,93,0,0,0,202,0,0,0,60,0,197,0,228,0,100,0,23,0,79,0,0,0,200,0,139,0,0,0,0,0,1,0,186,0,92,0,0,0,255,0,178,0,241,0,42,0,39,0,0,0,219,0,191,0,212,0,236,0,0,0,115,0,178,0,0,0,0,0,238,0,0,0,91,0,211,0,174,0,185,0,144,0,83,0,1,0,19,0,178,0,244,0,98,0,89,0,0,0,0,0,69,0,192,0,3,0,0,0,68,0,205,0,0,0,95,0,165,0,183,0,205,0,174,0,171,0,184,0,75,0,61,0,0,0,203,0,0,0,0,0,73,0,0,0,168,0,50,0,34,0,118,0,40,0,70,0,47,0,216,0,20,0,0,0,115,0,1,0,166,0,230,0,130,0,55,0,109,0,102,0,50,0,68,0,98,0,0,0,92,0,0,0,230,0,78,0,0,0,104,0,213,0,0,0,0,0,82,0,173,0,6,0,202,0,55,0,154,0,0,0,51,0,43,0,26,0,196,0,0,0,0,0,103,0,44,0,181,0,0,0,98,0,56,0,116,0,0,0,61,0,193,0,33,0,138,0,125,0,254,0,38,0,57,0,233,0,218,0,222,0,69,0,0,0,0,0,150,0,194,0,0,0,141,0,0,0,74,0,103,0,188,0,114,0,16,0,56,0,124,0,121,0,210,0,226,0,250,0,0,0,71,0,222,0,61,0,76,0,145,0,0,0,108,0,63,0,148,0,13,0,217,0,156,0,187,0,242,0,97,0,118,0,235,0,110,0,90,0,100,0,62,0,92,0,116,0,107,0,40,0,172,0,225,0,164,0,145,0,23,0,65,0,0,0,149,0,0,0,2,0,173,0,195,0,126,0,43,0,0,0,42,0,149,0,121,0,152,0,214,0,197,0,156,0,241,0,99,0,214,0,230,0,61,0,154,0,35,0,0,0,92,0,184,0,0,0,79,0,92,0,116,0,136,0,176,0,107,0,116,0,32,0,0,0,130,0,0,0,240,0,237,0,49,0,0,0,4,0,0,0,190,0,222,0,152,0,73,0,0,0,128,0,6,0,0,0,0,0,243,0,128,0,249,0,0,0,184,0,0,0,164,0,5,0,0,0,138,0,50,0,187,0,26,0,242,0,247,0,128,0,250,0,204,0,166,0,233,0,139,0,63,0,98,0,0,0,0,0,187,0,76,0,240,0,2,0,241,0,156,0,132,0,0,0,142,0,163,0,111,0,26,0,207,0);
signal scenario_full  : scenario_type := (0,0,60,31,60,30,72,31,197,31,104,31,221,31,74,31,74,30,6,31,38,31,127,31,117,31,93,31,93,30,202,31,202,30,60,31,197,31,228,31,100,31,23,31,79,31,79,30,200,31,139,31,139,30,139,29,1,31,186,31,92,31,92,30,255,31,178,31,241,31,42,31,39,31,39,30,219,31,191,31,212,31,236,31,236,30,115,31,178,31,178,30,178,29,238,31,238,30,91,31,211,31,174,31,185,31,144,31,83,31,1,31,19,31,178,31,244,31,98,31,89,31,89,30,89,29,69,31,192,31,3,31,3,30,68,31,205,31,205,30,95,31,165,31,183,31,205,31,174,31,171,31,184,31,75,31,61,31,61,30,203,31,203,30,203,29,73,31,73,30,168,31,50,31,34,31,118,31,40,31,70,31,47,31,216,31,20,31,20,30,115,31,1,31,166,31,230,31,130,31,55,31,109,31,102,31,50,31,68,31,98,31,98,30,92,31,92,30,230,31,78,31,78,30,104,31,213,31,213,30,213,29,82,31,173,31,6,31,202,31,55,31,154,31,154,30,51,31,43,31,26,31,196,31,196,30,196,29,103,31,44,31,181,31,181,30,98,31,56,31,116,31,116,30,61,31,193,31,33,31,138,31,125,31,254,31,38,31,57,31,233,31,218,31,222,31,69,31,69,30,69,29,150,31,194,31,194,30,141,31,141,30,74,31,103,31,188,31,114,31,16,31,56,31,124,31,121,31,210,31,226,31,250,31,250,30,71,31,222,31,61,31,76,31,145,31,145,30,108,31,63,31,148,31,13,31,217,31,156,31,187,31,242,31,97,31,118,31,235,31,110,31,90,31,100,31,62,31,92,31,116,31,107,31,40,31,172,31,225,31,164,31,145,31,23,31,65,31,65,30,149,31,149,30,2,31,173,31,195,31,126,31,43,31,43,30,42,31,149,31,121,31,152,31,214,31,197,31,156,31,241,31,99,31,214,31,230,31,61,31,154,31,35,31,35,30,92,31,184,31,184,30,79,31,92,31,116,31,136,31,176,31,107,31,116,31,32,31,32,30,130,31,130,30,240,31,237,31,49,31,49,30,4,31,4,30,190,31,222,31,152,31,73,31,73,30,128,31,6,31,6,30,6,29,243,31,128,31,249,31,249,30,184,31,184,30,164,31,5,31,5,30,138,31,50,31,187,31,26,31,242,31,247,31,128,31,250,31,204,31,166,31,233,31,139,31,63,31,98,31,98,30,98,29,187,31,76,31,240,31,2,31,241,31,156,31,132,31,132,30,142,31,163,31,111,31,26,31,207,31);

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
