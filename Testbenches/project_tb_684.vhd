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

constant SCENARIO_LENGTH : integer := 263;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (176,0,213,0,0,0,125,0,0,0,97,0,183,0,208,0,91,0,168,0,108,0,120,0,17,0,0,0,161,0,187,0,83,0,0,0,0,0,41,0,27,0,10,0,0,0,240,0,45,0,0,0,75,0,20,0,127,0,0,0,246,0,85,0,158,0,0,0,53,0,55,0,0,0,0,0,81,0,146,0,171,0,203,0,104,0,133,0,0,0,127,0,80,0,250,0,160,0,93,0,164,0,226,0,0,0,22,0,167,0,57,0,0,0,135,0,0,0,39,0,146,0,174,0,0,0,63,0,0,0,183,0,0,0,156,0,0,0,15,0,0,0,158,0,84,0,163,0,137,0,218,0,23,0,47,0,0,0,30,0,38,0,29,0,0,0,203,0,0,0,0,0,0,0,0,0,183,0,196,0,164,0,174,0,182,0,30,0,171,0,97,0,28,0,50,0,195,0,190,0,0,0,234,0,249,0,194,0,179,0,103,0,94,0,0,0,197,0,192,0,146,0,243,0,0,0,0,0,0,0,61,0,195,0,233,0,10,0,160,0,224,0,0,0,168,0,226,0,31,0,224,0,2,0,79,0,177,0,0,0,211,0,0,0,157,0,128,0,228,0,240,0,219,0,71,0,139,0,247,0,19,0,211,0,0,0,127,0,80,0,9,0,246,0,1,0,31,0,77,0,0,0,169,0,0,0,145,0,98,0,106,0,23,0,242,0,226,0,184,0,195,0,4,0,0,0,251,0,43,0,93,0,117,0,3,0,114,0,0,0,249,0,123,0,174,0,236,0,77,0,38,0,42,0,57,0,113,0,132,0,130,0,45,0,220,0,227,0,249,0,0,0,147,0,223,0,69,0,0,0,0,0,218,0,0,0,47,0,114,0,121,0,0,0,11,0,0,0,225,0,0,0,0,0,152,0,125,0,8,0,155,0,162,0,217,0,0,0,36,0,0,0,38,0,27,0,229,0,155,0,90,0,168,0,0,0,0,0,0,0,207,0,34,0,36,0,147,0,74,0,0,0,0,0,68,0,230,0,0,0,181,0,54,0,0,0,41,0,112,0,0,0,140,0,0,0,155,0,192,0,0,0,115,0,191,0,218,0,255,0,0,0,133,0,0,0,184,0,20,0,122,0,194,0,0,0,222,0,0,0,164,0,136,0,31,0,67,0,20,0,76,0,0,0,13,0);
signal scenario_full  : scenario_type := (176,31,213,31,213,30,125,31,125,30,97,31,183,31,208,31,91,31,168,31,108,31,120,31,17,31,17,30,161,31,187,31,83,31,83,30,83,29,41,31,27,31,10,31,10,30,240,31,45,31,45,30,75,31,20,31,127,31,127,30,246,31,85,31,158,31,158,30,53,31,55,31,55,30,55,29,81,31,146,31,171,31,203,31,104,31,133,31,133,30,127,31,80,31,250,31,160,31,93,31,164,31,226,31,226,30,22,31,167,31,57,31,57,30,135,31,135,30,39,31,146,31,174,31,174,30,63,31,63,30,183,31,183,30,156,31,156,30,15,31,15,30,158,31,84,31,163,31,137,31,218,31,23,31,47,31,47,30,30,31,38,31,29,31,29,30,203,31,203,30,203,29,203,28,203,27,183,31,196,31,164,31,174,31,182,31,30,31,171,31,97,31,28,31,50,31,195,31,190,31,190,30,234,31,249,31,194,31,179,31,103,31,94,31,94,30,197,31,192,31,146,31,243,31,243,30,243,29,243,28,61,31,195,31,233,31,10,31,160,31,224,31,224,30,168,31,226,31,31,31,224,31,2,31,79,31,177,31,177,30,211,31,211,30,157,31,128,31,228,31,240,31,219,31,71,31,139,31,247,31,19,31,211,31,211,30,127,31,80,31,9,31,246,31,1,31,31,31,77,31,77,30,169,31,169,30,145,31,98,31,106,31,23,31,242,31,226,31,184,31,195,31,4,31,4,30,251,31,43,31,93,31,117,31,3,31,114,31,114,30,249,31,123,31,174,31,236,31,77,31,38,31,42,31,57,31,113,31,132,31,130,31,45,31,220,31,227,31,249,31,249,30,147,31,223,31,69,31,69,30,69,29,218,31,218,30,47,31,114,31,121,31,121,30,11,31,11,30,225,31,225,30,225,29,152,31,125,31,8,31,155,31,162,31,217,31,217,30,36,31,36,30,38,31,27,31,229,31,155,31,90,31,168,31,168,30,168,29,168,28,207,31,34,31,36,31,147,31,74,31,74,30,74,29,68,31,230,31,230,30,181,31,54,31,54,30,41,31,112,31,112,30,140,31,140,30,155,31,192,31,192,30,115,31,191,31,218,31,255,31,255,30,133,31,133,30,184,31,20,31,122,31,194,31,194,30,222,31,222,30,164,31,136,31,31,31,67,31,20,31,76,31,76,30,13,31);

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
