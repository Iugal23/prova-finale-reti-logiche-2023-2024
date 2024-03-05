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

constant SCENARIO_LENGTH : integer := 387;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (75,0,40,0,190,0,211,0,152,0,31,0,82,0,0,0,180,0,3,0,176,0,5,0,175,0,67,0,233,0,187,0,186,0,253,0,252,0,141,0,178,0,249,0,0,0,0,0,139,0,0,0,130,0,218,0,0,0,119,0,250,0,0,0,0,0,146,0,249,0,107,0,31,0,0,0,253,0,163,0,0,0,86,0,133,0,123,0,161,0,182,0,151,0,130,0,200,0,255,0,0,0,121,0,149,0,78,0,59,0,34,0,158,0,157,0,188,0,203,0,238,0,0,0,140,0,0,0,190,0,185,0,62,0,226,0,21,0,0,0,5,0,61,0,166,0,188,0,127,0,190,0,152,0,247,0,0,0,0,0,234,0,0,0,43,0,119,0,0,0,110,0,137,0,0,0,59,0,0,0,236,0,101,0,0,0,47,0,47,0,19,0,147,0,165,0,79,0,0,0,244,0,44,0,93,0,159,0,72,0,184,0,236,0,0,0,32,0,132,0,143,0,88,0,227,0,249,0,0,0,55,0,110,0,90,0,110,0,4,0,191,0,179,0,98,0,0,0,0,0,152,0,121,0,143,0,0,0,99,0,225,0,43,0,0,0,0,0,146,0,0,0,0,0,0,0,153,0,0,0,10,0,0,0,251,0,216,0,59,0,176,0,38,0,104,0,155,0,106,0,0,0,40,0,148,0,124,0,129,0,104,0,54,0,47,0,0,0,252,0,25,0,202,0,20,0,3,0,0,0,0,0,254,0,114,0,0,0,241,0,119,0,173,0,16,0,114,0,103,0,101,0,29,0,4,0,245,0,189,0,108,0,128,0,3,0,0,0,0,0,36,0,162,0,0,0,113,0,0,0,84,0,205,0,49,0,0,0,0,0,6,0,105,0,0,0,88,0,78,0,193,0,252,0,206,0,161,0,157,0,142,0,237,0,18,0,115,0,253,0,0,0,221,0,205,0,201,0,0,0,0,0,0,0,48,0,115,0,121,0,0,0,146,0,254,0,200,0,13,0,155,0,0,0,98,0,35,0,203,0,180,0,57,0,200,0,0,0,78,0,217,0,68,0,75,0,70,0,157,0,148,0,153,0,64,0,139,0,0,0,77,0,59,0,0,0,102,0,51,0,53,0,0,0,77,0,0,0,103,0,154,0,160,0,209,0,71,0,198,0,142,0,239,0,69,0,204,0,159,0,0,0,143,0,0,0,74,0,0,0,85,0,231,0,0,0,0,0,0,0,0,0,43,0,81,0,97,0,43,0,182,0,89,0,158,0,230,0,155,0,0,0,0,0,186,0,0,0,28,0,254,0,0,0,243,0,162,0,240,0,90,0,222,0,181,0,0,0,211,0,54,0,236,0,0,0,92,0,172,0,0,0,0,0,91,0,207,0,42,0,0,0,121,0,92,0,0,0,0,0,187,0,73,0,133,0,221,0,24,0,242,0,15,0,0,0,221,0,238,0,243,0,47,0,140,0,98,0,56,0,127,0,132,0,238,0,48,0,180,0,183,0,97,0,0,0,233,0,139,0,19,0,133,0,115,0,227,0,211,0,177,0,13,0,77,0,163,0,141,0,0,0,0,0,135,0,158,0,0,0,16,0,96,0,103,0,0,0,62,0,112,0,57,0,81,0,0,0,101,0,0,0,218,0,0,0,90,0,87,0,0,0,237,0,0,0,54,0,10,0,211,0,22,0,0,0,0,0,217,0,166,0,35,0,47,0,44,0,42,0,45,0,96,0);
signal scenario_full  : scenario_type := (75,31,40,31,190,31,211,31,152,31,31,31,82,31,82,30,180,31,3,31,176,31,5,31,175,31,67,31,233,31,187,31,186,31,253,31,252,31,141,31,178,31,249,31,249,30,249,29,139,31,139,30,130,31,218,31,218,30,119,31,250,31,250,30,250,29,146,31,249,31,107,31,31,31,31,30,253,31,163,31,163,30,86,31,133,31,123,31,161,31,182,31,151,31,130,31,200,31,255,31,255,30,121,31,149,31,78,31,59,31,34,31,158,31,157,31,188,31,203,31,238,31,238,30,140,31,140,30,190,31,185,31,62,31,226,31,21,31,21,30,5,31,61,31,166,31,188,31,127,31,190,31,152,31,247,31,247,30,247,29,234,31,234,30,43,31,119,31,119,30,110,31,137,31,137,30,59,31,59,30,236,31,101,31,101,30,47,31,47,31,19,31,147,31,165,31,79,31,79,30,244,31,44,31,93,31,159,31,72,31,184,31,236,31,236,30,32,31,132,31,143,31,88,31,227,31,249,31,249,30,55,31,110,31,90,31,110,31,4,31,191,31,179,31,98,31,98,30,98,29,152,31,121,31,143,31,143,30,99,31,225,31,43,31,43,30,43,29,146,31,146,30,146,29,146,28,153,31,153,30,10,31,10,30,251,31,216,31,59,31,176,31,38,31,104,31,155,31,106,31,106,30,40,31,148,31,124,31,129,31,104,31,54,31,47,31,47,30,252,31,25,31,202,31,20,31,3,31,3,30,3,29,254,31,114,31,114,30,241,31,119,31,173,31,16,31,114,31,103,31,101,31,29,31,4,31,245,31,189,31,108,31,128,31,3,31,3,30,3,29,36,31,162,31,162,30,113,31,113,30,84,31,205,31,49,31,49,30,49,29,6,31,105,31,105,30,88,31,78,31,193,31,252,31,206,31,161,31,157,31,142,31,237,31,18,31,115,31,253,31,253,30,221,31,205,31,201,31,201,30,201,29,201,28,48,31,115,31,121,31,121,30,146,31,254,31,200,31,13,31,155,31,155,30,98,31,35,31,203,31,180,31,57,31,200,31,200,30,78,31,217,31,68,31,75,31,70,31,157,31,148,31,153,31,64,31,139,31,139,30,77,31,59,31,59,30,102,31,51,31,53,31,53,30,77,31,77,30,103,31,154,31,160,31,209,31,71,31,198,31,142,31,239,31,69,31,204,31,159,31,159,30,143,31,143,30,74,31,74,30,85,31,231,31,231,30,231,29,231,28,231,27,43,31,81,31,97,31,43,31,182,31,89,31,158,31,230,31,155,31,155,30,155,29,186,31,186,30,28,31,254,31,254,30,243,31,162,31,240,31,90,31,222,31,181,31,181,30,211,31,54,31,236,31,236,30,92,31,172,31,172,30,172,29,91,31,207,31,42,31,42,30,121,31,92,31,92,30,92,29,187,31,73,31,133,31,221,31,24,31,242,31,15,31,15,30,221,31,238,31,243,31,47,31,140,31,98,31,56,31,127,31,132,31,238,31,48,31,180,31,183,31,97,31,97,30,233,31,139,31,19,31,133,31,115,31,227,31,211,31,177,31,13,31,77,31,163,31,141,31,141,30,141,29,135,31,158,31,158,30,16,31,96,31,103,31,103,30,62,31,112,31,57,31,81,31,81,30,101,31,101,30,218,31,218,30,90,31,87,31,87,30,237,31,237,30,54,31,10,31,211,31,22,31,22,30,22,29,217,31,166,31,35,31,47,31,44,31,42,31,45,31,96,31);

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
