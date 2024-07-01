-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_568 is
end project_tb_568;

architecture project_tb_arch_568 of project_tb_568 is
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

constant SCENARIO_LENGTH : integer := 453;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (238,0,57,0,11,0,142,0,242,0,230,0,157,0,213,0,114,0,0,0,104,0,43,0,242,0,242,0,2,0,212,0,241,0,9,0,184,0,221,0,132,0,23,0,0,0,13,0,248,0,172,0,162,0,210,0,28,0,0,0,21,0,58,0,148,0,138,0,216,0,166,0,19,0,221,0,234,0,1,0,34,0,0,0,194,0,0,0,0,0,127,0,178,0,40,0,197,0,6,0,202,0,107,0,61,0,227,0,143,0,120,0,7,0,201,0,0,0,103,0,71,0,0,0,0,0,233,0,0,0,108,0,51,0,238,0,0,0,118,0,0,0,243,0,0,0,33,0,177,0,214,0,209,0,249,0,132,0,0,0,100,0,28,0,74,0,246,0,9,0,159,0,245,0,84,0,7,0,243,0,201,0,59,0,50,0,141,0,113,0,143,0,143,0,251,0,214,0,251,0,21,0,0,0,35,0,50,0,107,0,99,0,144,0,25,0,0,0,24,0,215,0,181,0,74,0,0,0,243,0,80,0,160,0,210,0,69,0,0,0,246,0,169,0,210,0,50,0,0,0,146,0,2,0,0,0,229,0,194,0,161,0,129,0,0,0,196,0,0,0,159,0,151,0,38,0,196,0,250,0,249,0,211,0,145,0,0,0,60,0,207,0,11,0,255,0,14,0,161,0,205,0,96,0,210,0,89,0,117,0,0,0,49,0,26,0,0,0,212,0,200,0,158,0,228,0,0,0,0,0,212,0,28,0,0,0,0,0,0,0,0,0,215,0,243,0,54,0,0,0,238,0,156,0,0,0,0,0,0,0,136,0,113,0,253,0,240,0,71,0,0,0,133,0,182,0,0,0,47,0,80,0,117,0,235,0,128,0,227,0,0,0,0,0,78,0,100,0,223,0,146,0,64,0,0,0,188,0,132,0,0,0,37,0,50,0,118,0,0,0,253,0,116,0,115,0,34,0,41,0,0,0,191,0,26,0,0,0,46,0,0,0,0,0,79,0,46,0,210,0,112,0,76,0,0,0,0,0,94,0,76,0,93,0,67,0,171,0,252,0,20,0,179,0,61,0,0,0,223,0,27,0,0,0,85,0,0,0,69,0,68,0,106,0,0,0,158,0,177,0,221,0,205,0,174,0,133,0,42,0,0,0,236,0,178,0,166,0,103,0,0,0,167,0,84,0,0,0,178,0,185,0,198,0,0,0,113,0,0,0,0,0,227,0,10,0,171,0,182,0,236,0,80,0,136,0,222,0,11,0,134,0,84,0,236,0,139,0,0,0,171,0,19,0,101,0,241,0,213,0,225,0,0,0,149,0,95,0,137,0,143,0,15,0,0,0,0,0,243,0,222,0,38,0,205,0,0,0,178,0,0,0,28,0,0,0,98,0,179,0,0,0,0,0,204,0,0,0,0,0,144,0,254,0,0,0,188,0,79,0,0,0,83,0,4,0,130,0,16,0,0,0,45,0,234,0,47,0,0,0,146,0,0,0,215,0,0,0,43,0,111,0,0,0,178,0,226,0,201,0,0,0,72,0,242,0,48,0,48,0,115,0,135,0,140,0,0,0,146,0,0,0,104,0,10,0,115,0,61,0,0,0,197,0,154,0,0,0,131,0,161,0,203,0,39,0,141,0,225,0,101,0,60,0,0,0,25,0,5,0,219,0,88,0,181,0,0,0,0,0,0,0,0,0,237,0,240,0,205,0,86,0,67,0,0,0,103,0,178,0,31,0,128,0,0,0,189,0,0,0,228,0,110,0,72,0,122,0,186,0,219,0,0,0,0,0,86,0,236,0,0,0,44,0,0,0,0,0,7,0,120,0,103,0,216,0,245,0,8,0,176,0,0,0,173,0,75,0,217,0,253,0,22,0,0,0,95,0,0,0,168,0,43,0,120,0,203,0,195,0,188,0,0,0,0,0,212,0,172,0,189,0,94,0,12,0,211,0,0,0,0,0,231,0,246,0,72,0,122,0,0,0,0,0,134,0,109,0,0,0,26,0,26,0,0,0,0,0,30,0,0,0,120,0,68,0);
signal scenario_full  : scenario_type := (238,31,57,31,11,31,142,31,242,31,230,31,157,31,213,31,114,31,114,30,104,31,43,31,242,31,242,31,2,31,212,31,241,31,9,31,184,31,221,31,132,31,23,31,23,30,13,31,248,31,172,31,162,31,210,31,28,31,28,30,21,31,58,31,148,31,138,31,216,31,166,31,19,31,221,31,234,31,1,31,34,31,34,30,194,31,194,30,194,29,127,31,178,31,40,31,197,31,6,31,202,31,107,31,61,31,227,31,143,31,120,31,7,31,201,31,201,30,103,31,71,31,71,30,71,29,233,31,233,30,108,31,51,31,238,31,238,30,118,31,118,30,243,31,243,30,33,31,177,31,214,31,209,31,249,31,132,31,132,30,100,31,28,31,74,31,246,31,9,31,159,31,245,31,84,31,7,31,243,31,201,31,59,31,50,31,141,31,113,31,143,31,143,31,251,31,214,31,251,31,21,31,21,30,35,31,50,31,107,31,99,31,144,31,25,31,25,30,24,31,215,31,181,31,74,31,74,30,243,31,80,31,160,31,210,31,69,31,69,30,246,31,169,31,210,31,50,31,50,30,146,31,2,31,2,30,229,31,194,31,161,31,129,31,129,30,196,31,196,30,159,31,151,31,38,31,196,31,250,31,249,31,211,31,145,31,145,30,60,31,207,31,11,31,255,31,14,31,161,31,205,31,96,31,210,31,89,31,117,31,117,30,49,31,26,31,26,30,212,31,200,31,158,31,228,31,228,30,228,29,212,31,28,31,28,30,28,29,28,28,28,27,215,31,243,31,54,31,54,30,238,31,156,31,156,30,156,29,156,28,136,31,113,31,253,31,240,31,71,31,71,30,133,31,182,31,182,30,47,31,80,31,117,31,235,31,128,31,227,31,227,30,227,29,78,31,100,31,223,31,146,31,64,31,64,30,188,31,132,31,132,30,37,31,50,31,118,31,118,30,253,31,116,31,115,31,34,31,41,31,41,30,191,31,26,31,26,30,46,31,46,30,46,29,79,31,46,31,210,31,112,31,76,31,76,30,76,29,94,31,76,31,93,31,67,31,171,31,252,31,20,31,179,31,61,31,61,30,223,31,27,31,27,30,85,31,85,30,69,31,68,31,106,31,106,30,158,31,177,31,221,31,205,31,174,31,133,31,42,31,42,30,236,31,178,31,166,31,103,31,103,30,167,31,84,31,84,30,178,31,185,31,198,31,198,30,113,31,113,30,113,29,227,31,10,31,171,31,182,31,236,31,80,31,136,31,222,31,11,31,134,31,84,31,236,31,139,31,139,30,171,31,19,31,101,31,241,31,213,31,225,31,225,30,149,31,95,31,137,31,143,31,15,31,15,30,15,29,243,31,222,31,38,31,205,31,205,30,178,31,178,30,28,31,28,30,98,31,179,31,179,30,179,29,204,31,204,30,204,29,144,31,254,31,254,30,188,31,79,31,79,30,83,31,4,31,130,31,16,31,16,30,45,31,234,31,47,31,47,30,146,31,146,30,215,31,215,30,43,31,111,31,111,30,178,31,226,31,201,31,201,30,72,31,242,31,48,31,48,31,115,31,135,31,140,31,140,30,146,31,146,30,104,31,10,31,115,31,61,31,61,30,197,31,154,31,154,30,131,31,161,31,203,31,39,31,141,31,225,31,101,31,60,31,60,30,25,31,5,31,219,31,88,31,181,31,181,30,181,29,181,28,181,27,237,31,240,31,205,31,86,31,67,31,67,30,103,31,178,31,31,31,128,31,128,30,189,31,189,30,228,31,110,31,72,31,122,31,186,31,219,31,219,30,219,29,86,31,236,31,236,30,44,31,44,30,44,29,7,31,120,31,103,31,216,31,245,31,8,31,176,31,176,30,173,31,75,31,217,31,253,31,22,31,22,30,95,31,95,30,168,31,43,31,120,31,203,31,195,31,188,31,188,30,188,29,212,31,172,31,189,31,94,31,12,31,211,31,211,30,211,29,231,31,246,31,72,31,122,31,122,30,122,29,134,31,109,31,109,30,26,31,26,31,26,30,26,29,30,31,30,30,120,31,68,31);

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
