-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_319 is
end project_tb_319;

architecture project_tb_arch_319 of project_tb_319 is
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

constant SCENARIO_LENGTH : integer := 498;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (178,0,57,0,220,0,213,0,116,0,203,0,204,0,173,0,179,0,251,0,143,0,171,0,238,0,78,0,28,0,0,0,130,0,92,0,0,0,0,0,222,0,123,0,255,0,124,0,102,0,50,0,2,0,37,0,230,0,0,0,146,0,181,0,115,0,193,0,86,0,124,0,17,0,203,0,5,0,204,0,186,0,89,0,223,0,104,0,0,0,161,0,0,0,81,0,0,0,185,0,225,0,233,0,128,0,4,0,156,0,0,0,0,0,221,0,121,0,19,0,69,0,0,0,117,0,22,0,196,0,0,0,70,0,235,0,162,0,42,0,135,0,62,0,37,0,34,0,0,0,42,0,2,0,0,0,0,0,0,0,151,0,47,0,0,0,254,0,0,0,199,0,166,0,75,0,141,0,183,0,3,0,118,0,90,0,213,0,0,0,211,0,0,0,203,0,0,0,0,0,252,0,24,0,128,0,70,0,251,0,3,0,25,0,104,0,37,0,33,0,10,0,116,0,58,0,200,0,90,0,255,0,0,0,97,0,46,0,85,0,235,0,193,0,127,0,124,0,2,0,45,0,0,0,0,0,38,0,146,0,175,0,233,0,88,0,235,0,14,0,239,0,141,0,244,0,138,0,0,0,147,0,48,0,222,0,166,0,111,0,101,0,48,0,128,0,19,0,244,0,0,0,1,0,104,0,109,0,58,0,0,0,71,0,12,0,182,0,36,0,0,0,9,0,219,0,152,0,0,0,142,0,143,0,7,0,0,0,34,0,149,0,121,0,182,0,0,0,0,0,233,0,162,0,39,0,171,0,0,0,224,0,241,0,20,0,137,0,67,0,219,0,54,0,0,0,0,0,0,0,44,0,56,0,224,0,204,0,36,0,83,0,169,0,0,0,236,0,174,0,0,0,67,0,44,0,201,0,0,0,104,0,189,0,23,0,163,0,130,0,0,0,234,0,125,0,37,0,122,0,91,0,230,0,165,0,17,0,2,0,0,0,130,0,179,0,245,0,212,0,36,0,139,0,177,0,70,0,251,0,223,0,145,0,224,0,74,0,82,0,144,0,251,0,81,0,228,0,149,0,0,0,38,0,3,0,101,0,173,0,115,0,0,0,79,0,0,0,35,0,0,0,134,0,60,0,0,0,0,0,0,0,166,0,160,0,99,0,0,0,127,0,21,0,251,0,210,0,126,0,0,0,138,0,5,0,148,0,201,0,78,0,55,0,104,0,244,0,100,0,198,0,209,0,0,0,16,0,200,0,120,0,98,0,110,0,0,0,24,0,153,0,215,0,83,0,73,0,0,0,0,0,77,0,208,0,116,0,0,0,155,0,244,0,0,0,53,0,160,0,36,0,235,0,56,0,97,0,0,0,8,0,0,0,79,0,246,0,39,0,0,0,245,0,71,0,0,0,79,0,252,0,232,0,174,0,115,0,149,0,15,0,0,0,142,0,0,0,0,0,0,0,71,0,246,0,92,0,0,0,253,0,148,0,0,0,99,0,146,0,84,0,195,0,29,0,25,0,124,0,236,0,137,0,26,0,0,0,242,0,185,0,76,0,97,0,97,0,54,0,0,0,55,0,248,0,146,0,194,0,88,0,129,0,53,0,94,0,0,0,0,0,93,0,13,0,231,0,81,0,0,0,0,0,70,0,249,0,0,0,0,0,219,0,222,0,179,0,1,0,188,0,158,0,230,0,175,0,181,0,184,0,157,0,237,0,170,0,83,0,1,0,0,0,212,0,39,0,5,0,168,0,154,0,97,0,240,0,231,0,189,0,0,0,121,0,0,0,212,0,199,0,0,0,238,0,50,0,167,0,102,0,169,0,15,0,157,0,41,0,0,0,244,0,240,0,0,0,10,0,0,0,148,0,22,0,65,0,0,0,52,0,197,0,218,0,104,0,0,0,158,0,0,0,26,0,0,0,116,0,14,0,86,0,102,0,204,0,213,0,224,0,0,0,8,0,143,0,111,0,55,0,1,0,251,0,15,0,93,0,82,0,221,0,0,0,146,0,141,0,193,0,0,0,108,0,0,0,21,0,54,0,182,0,0,0,126,0,155,0,0,0,183,0,0,0,0,0,0,0,68,0,13,0,113,0,88,0,6,0,19,0,162,0,198,0,243,0,245,0,235,0,0,0,158,0,60,0,131,0,214,0,63,0,0,0,176,0,174,0,98,0,120,0,232,0,227,0,252,0,174,0,93,0,205,0,124,0,159,0,52,0,98,0,186,0);
signal scenario_full  : scenario_type := (178,31,57,31,220,31,213,31,116,31,203,31,204,31,173,31,179,31,251,31,143,31,171,31,238,31,78,31,28,31,28,30,130,31,92,31,92,30,92,29,222,31,123,31,255,31,124,31,102,31,50,31,2,31,37,31,230,31,230,30,146,31,181,31,115,31,193,31,86,31,124,31,17,31,203,31,5,31,204,31,186,31,89,31,223,31,104,31,104,30,161,31,161,30,81,31,81,30,185,31,225,31,233,31,128,31,4,31,156,31,156,30,156,29,221,31,121,31,19,31,69,31,69,30,117,31,22,31,196,31,196,30,70,31,235,31,162,31,42,31,135,31,62,31,37,31,34,31,34,30,42,31,2,31,2,30,2,29,2,28,151,31,47,31,47,30,254,31,254,30,199,31,166,31,75,31,141,31,183,31,3,31,118,31,90,31,213,31,213,30,211,31,211,30,203,31,203,30,203,29,252,31,24,31,128,31,70,31,251,31,3,31,25,31,104,31,37,31,33,31,10,31,116,31,58,31,200,31,90,31,255,31,255,30,97,31,46,31,85,31,235,31,193,31,127,31,124,31,2,31,45,31,45,30,45,29,38,31,146,31,175,31,233,31,88,31,235,31,14,31,239,31,141,31,244,31,138,31,138,30,147,31,48,31,222,31,166,31,111,31,101,31,48,31,128,31,19,31,244,31,244,30,1,31,104,31,109,31,58,31,58,30,71,31,12,31,182,31,36,31,36,30,9,31,219,31,152,31,152,30,142,31,143,31,7,31,7,30,34,31,149,31,121,31,182,31,182,30,182,29,233,31,162,31,39,31,171,31,171,30,224,31,241,31,20,31,137,31,67,31,219,31,54,31,54,30,54,29,54,28,44,31,56,31,224,31,204,31,36,31,83,31,169,31,169,30,236,31,174,31,174,30,67,31,44,31,201,31,201,30,104,31,189,31,23,31,163,31,130,31,130,30,234,31,125,31,37,31,122,31,91,31,230,31,165,31,17,31,2,31,2,30,130,31,179,31,245,31,212,31,36,31,139,31,177,31,70,31,251,31,223,31,145,31,224,31,74,31,82,31,144,31,251,31,81,31,228,31,149,31,149,30,38,31,3,31,101,31,173,31,115,31,115,30,79,31,79,30,35,31,35,30,134,31,60,31,60,30,60,29,60,28,166,31,160,31,99,31,99,30,127,31,21,31,251,31,210,31,126,31,126,30,138,31,5,31,148,31,201,31,78,31,55,31,104,31,244,31,100,31,198,31,209,31,209,30,16,31,200,31,120,31,98,31,110,31,110,30,24,31,153,31,215,31,83,31,73,31,73,30,73,29,77,31,208,31,116,31,116,30,155,31,244,31,244,30,53,31,160,31,36,31,235,31,56,31,97,31,97,30,8,31,8,30,79,31,246,31,39,31,39,30,245,31,71,31,71,30,79,31,252,31,232,31,174,31,115,31,149,31,15,31,15,30,142,31,142,30,142,29,142,28,71,31,246,31,92,31,92,30,253,31,148,31,148,30,99,31,146,31,84,31,195,31,29,31,25,31,124,31,236,31,137,31,26,31,26,30,242,31,185,31,76,31,97,31,97,31,54,31,54,30,55,31,248,31,146,31,194,31,88,31,129,31,53,31,94,31,94,30,94,29,93,31,13,31,231,31,81,31,81,30,81,29,70,31,249,31,249,30,249,29,219,31,222,31,179,31,1,31,188,31,158,31,230,31,175,31,181,31,184,31,157,31,237,31,170,31,83,31,1,31,1,30,212,31,39,31,5,31,168,31,154,31,97,31,240,31,231,31,189,31,189,30,121,31,121,30,212,31,199,31,199,30,238,31,50,31,167,31,102,31,169,31,15,31,157,31,41,31,41,30,244,31,240,31,240,30,10,31,10,30,148,31,22,31,65,31,65,30,52,31,197,31,218,31,104,31,104,30,158,31,158,30,26,31,26,30,116,31,14,31,86,31,102,31,204,31,213,31,224,31,224,30,8,31,143,31,111,31,55,31,1,31,251,31,15,31,93,31,82,31,221,31,221,30,146,31,141,31,193,31,193,30,108,31,108,30,21,31,54,31,182,31,182,30,126,31,155,31,155,30,183,31,183,30,183,29,183,28,68,31,13,31,113,31,88,31,6,31,19,31,162,31,198,31,243,31,245,31,235,31,235,30,158,31,60,31,131,31,214,31,63,31,63,30,176,31,174,31,98,31,120,31,232,31,227,31,252,31,174,31,93,31,205,31,124,31,159,31,52,31,98,31,186,31);

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
