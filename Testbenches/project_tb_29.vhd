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

constant SCENARIO_LENGTH : integer := 284;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (163,0,225,0,237,0,0,0,246,0,75,0,93,0,184,0,205,0,100,0,0,0,208,0,116,0,158,0,39,0,89,0,217,0,146,0,189,0,15,0,99,0,0,0,0,0,217,0,237,0,0,0,108,0,194,0,35,0,117,0,185,0,230,0,0,0,77,0,244,0,0,0,99,0,85,0,30,0,181,0,0,0,0,0,148,0,47,0,99,0,139,0,39,0,99,0,58,0,16,0,108,0,152,0,79,0,234,0,136,0,246,0,160,0,14,0,249,0,46,0,33,0,91,0,206,0,0,0,28,0,0,0,208,0,0,0,194,0,240,0,198,0,129,0,223,0,199,0,83,0,222,0,213,0,251,0,68,0,87,0,2,0,0,0,0,0,195,0,108,0,0,0,0,0,164,0,0,0,10,0,0,0,199,0,66,0,0,0,113,0,29,0,156,0,120,0,206,0,0,0,232,0,205,0,150,0,42,0,7,0,18,0,0,0,216,0,254,0,187,0,0,0,211,0,120,0,0,0,78,0,20,0,27,0,155,0,0,0,102,0,234,0,67,0,8,0,144,0,44,0,189,0,132,0,115,0,0,0,146,0,0,0,0,0,34,0,131,0,75,0,249,0,252,0,241,0,89,0,201,0,0,0,223,0,241,0,15,0,32,0,167,0,140,0,13,0,208,0,230,0,85,0,114,0,0,0,33,0,122,0,142,0,248,0,115,0,0,0,81,0,104,0,147,0,85,0,233,0,0,0,0,0,173,0,110,0,215,0,170,0,230,0,11,0,0,0,51,0,138,0,118,0,176,0,12,0,0,0,253,0,95,0,85,0,0,0,184,0,1,0,0,0,0,0,188,0,205,0,5,0,201,0,254,0,134,0,0,0,37,0,229,0,2,0,43,0,0,0,0,0,70,0,55,0,80,0,232,0,97,0,4,0,74,0,125,0,241,0,54,0,193,0,103,0,221,0,0,0,194,0,43,0,0,0,32,0,222,0,37,0,43,0,0,0,193,0,76,0,1,0,169,0,102,0,74,0,19,0,0,0,0,0,167,0,249,0,0,0,0,0,159,0,247,0,148,0,14,0,0,0,0,0,134,0,97,0,227,0,120,0,253,0,0,0,70,0,0,0,0,0,45,0,99,0,165,0,167,0,188,0,165,0,121,0,42,0,0,0,0,0,34,0,0,0,0,0,54,0,135,0,6,0,119,0,168,0,0,0,51,0,44,0,0,0,91,0,25,0,19,0,164,0,46,0,237,0,159,0,218,0,47,0,117,0,134,0,0,0);
signal scenario_full  : scenario_type := (163,31,225,31,237,31,237,30,246,31,75,31,93,31,184,31,205,31,100,31,100,30,208,31,116,31,158,31,39,31,89,31,217,31,146,31,189,31,15,31,99,31,99,30,99,29,217,31,237,31,237,30,108,31,194,31,35,31,117,31,185,31,230,31,230,30,77,31,244,31,244,30,99,31,85,31,30,31,181,31,181,30,181,29,148,31,47,31,99,31,139,31,39,31,99,31,58,31,16,31,108,31,152,31,79,31,234,31,136,31,246,31,160,31,14,31,249,31,46,31,33,31,91,31,206,31,206,30,28,31,28,30,208,31,208,30,194,31,240,31,198,31,129,31,223,31,199,31,83,31,222,31,213,31,251,31,68,31,87,31,2,31,2,30,2,29,195,31,108,31,108,30,108,29,164,31,164,30,10,31,10,30,199,31,66,31,66,30,113,31,29,31,156,31,120,31,206,31,206,30,232,31,205,31,150,31,42,31,7,31,18,31,18,30,216,31,254,31,187,31,187,30,211,31,120,31,120,30,78,31,20,31,27,31,155,31,155,30,102,31,234,31,67,31,8,31,144,31,44,31,189,31,132,31,115,31,115,30,146,31,146,30,146,29,34,31,131,31,75,31,249,31,252,31,241,31,89,31,201,31,201,30,223,31,241,31,15,31,32,31,167,31,140,31,13,31,208,31,230,31,85,31,114,31,114,30,33,31,122,31,142,31,248,31,115,31,115,30,81,31,104,31,147,31,85,31,233,31,233,30,233,29,173,31,110,31,215,31,170,31,230,31,11,31,11,30,51,31,138,31,118,31,176,31,12,31,12,30,253,31,95,31,85,31,85,30,184,31,1,31,1,30,1,29,188,31,205,31,5,31,201,31,254,31,134,31,134,30,37,31,229,31,2,31,43,31,43,30,43,29,70,31,55,31,80,31,232,31,97,31,4,31,74,31,125,31,241,31,54,31,193,31,103,31,221,31,221,30,194,31,43,31,43,30,32,31,222,31,37,31,43,31,43,30,193,31,76,31,1,31,169,31,102,31,74,31,19,31,19,30,19,29,167,31,249,31,249,30,249,29,159,31,247,31,148,31,14,31,14,30,14,29,134,31,97,31,227,31,120,31,253,31,253,30,70,31,70,30,70,29,45,31,99,31,165,31,167,31,188,31,165,31,121,31,42,31,42,30,42,29,34,31,34,30,34,29,54,31,135,31,6,31,119,31,168,31,168,30,51,31,44,31,44,30,91,31,25,31,19,31,164,31,46,31,237,31,159,31,218,31,47,31,117,31,134,31,134,30);

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
