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

constant SCENARIO_LENGTH : integer := 339;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,183,0,105,0,0,0,23,0,0,0,0,0,237,0,17,0,221,0,146,0,95,0,191,0,128,0,113,0,181,0,156,0,253,0,93,0,0,0,0,0,165,0,167,0,138,0,211,0,88,0,212,0,41,0,198,0,15,0,166,0,227,0,50,0,195,0,237,0,0,0,0,0,73,0,68,0,247,0,190,0,0,0,245,0,243,0,0,0,242,0,0,0,80,0,61,0,220,0,188,0,35,0,105,0,79,0,0,0,88,0,139,0,242,0,95,0,81,0,17,0,223,0,0,0,71,0,0,0,47,0,24,0,226,0,169,0,31,0,133,0,215,0,204,0,127,0,11,0,19,0,28,0,52,0,0,0,216,0,214,0,0,0,63,0,53,0,182,0,184,0,201,0,148,0,146,0,216,0,150,0,93,0,157,0,86,0,7,0,19,0,0,0,198,0,76,0,190,0,178,0,153,0,0,0,55,0,20,0,240,0,151,0,0,0,110,0,153,0,0,0,183,0,12,0,73,0,208,0,106,0,134,0,81,0,140,0,160,0,99,0,0,0,88,0,186,0,10,0,0,0,224,0,116,0,73,0,97,0,220,0,164,0,207,0,171,0,251,0,0,0,0,0,32,0,0,0,10,0,6,0,233,0,250,0,166,0,174,0,67,0,0,0,205,0,102,0,0,0,22,0,72,0,0,0,0,0,72,0,0,0,56,0,182,0,103,0,9,0,255,0,95,0,46,0,137,0,237,0,94,0,5,0,0,0,0,0,208,0,25,0,178,0,1,0,0,0,0,0,7,0,10,0,0,0,139,0,145,0,112,0,0,0,123,0,0,0,0,0,0,0,197,0,189,0,39,0,109,0,176,0,110,0,133,0,58,0,224,0,182,0,196,0,0,0,220,0,182,0,145,0,0,0,146,0,104,0,0,0,31,0,23,0,235,0,0,0,0,0,0,0,0,0,111,0,25,0,131,0,0,0,0,0,0,0,0,0,36,0,228,0,0,0,0,0,193,0,186,0,0,0,201,0,0,0,197,0,0,0,0,0,120,0,106,0,33,0,55,0,54,0,201,0,13,0,87,0,235,0,211,0,162,0,0,0,224,0,96,0,0,0,239,0,72,0,21,0,237,0,166,0,46,0,152,0,113,0,217,0,13,0,42,0,86,0,0,0,0,0,0,0,219,0,90,0,248,0,157,0,62,0,158,0,226,0,208,0,0,0,102,0,141,0,146,0,0,0,137,0,148,0,133,0,42,0,119,0,189,0,0,0,153,0,32,0,2,0,194,0,131,0,16,0,146,0,0,0,204,0,52,0,33,0,0,0,221,0,3,0,0,0,116,0,240,0,173,0,28,0,11,0,54,0,238,0,166,0,180,0,153,0,20,0,206,0,120,0,15,0,0,0,0,0,46,0,122,0,232,0,35,0,250,0,89,0,226,0,0,0,118,0,225,0,35,0,0,0,112,0,136,0,180,0,0,0,153,0,47,0,149,0,170,0,148,0,0,0,183,0,29,0,110,0,99,0,82,0);
signal scenario_full  : scenario_type := (0,0,183,31,105,31,105,30,23,31,23,30,23,29,237,31,17,31,221,31,146,31,95,31,191,31,128,31,113,31,181,31,156,31,253,31,93,31,93,30,93,29,165,31,167,31,138,31,211,31,88,31,212,31,41,31,198,31,15,31,166,31,227,31,50,31,195,31,237,31,237,30,237,29,73,31,68,31,247,31,190,31,190,30,245,31,243,31,243,30,242,31,242,30,80,31,61,31,220,31,188,31,35,31,105,31,79,31,79,30,88,31,139,31,242,31,95,31,81,31,17,31,223,31,223,30,71,31,71,30,47,31,24,31,226,31,169,31,31,31,133,31,215,31,204,31,127,31,11,31,19,31,28,31,52,31,52,30,216,31,214,31,214,30,63,31,53,31,182,31,184,31,201,31,148,31,146,31,216,31,150,31,93,31,157,31,86,31,7,31,19,31,19,30,198,31,76,31,190,31,178,31,153,31,153,30,55,31,20,31,240,31,151,31,151,30,110,31,153,31,153,30,183,31,12,31,73,31,208,31,106,31,134,31,81,31,140,31,160,31,99,31,99,30,88,31,186,31,10,31,10,30,224,31,116,31,73,31,97,31,220,31,164,31,207,31,171,31,251,31,251,30,251,29,32,31,32,30,10,31,6,31,233,31,250,31,166,31,174,31,67,31,67,30,205,31,102,31,102,30,22,31,72,31,72,30,72,29,72,31,72,30,56,31,182,31,103,31,9,31,255,31,95,31,46,31,137,31,237,31,94,31,5,31,5,30,5,29,208,31,25,31,178,31,1,31,1,30,1,29,7,31,10,31,10,30,139,31,145,31,112,31,112,30,123,31,123,30,123,29,123,28,197,31,189,31,39,31,109,31,176,31,110,31,133,31,58,31,224,31,182,31,196,31,196,30,220,31,182,31,145,31,145,30,146,31,104,31,104,30,31,31,23,31,235,31,235,30,235,29,235,28,235,27,111,31,25,31,131,31,131,30,131,29,131,28,131,27,36,31,228,31,228,30,228,29,193,31,186,31,186,30,201,31,201,30,197,31,197,30,197,29,120,31,106,31,33,31,55,31,54,31,201,31,13,31,87,31,235,31,211,31,162,31,162,30,224,31,96,31,96,30,239,31,72,31,21,31,237,31,166,31,46,31,152,31,113,31,217,31,13,31,42,31,86,31,86,30,86,29,86,28,219,31,90,31,248,31,157,31,62,31,158,31,226,31,208,31,208,30,102,31,141,31,146,31,146,30,137,31,148,31,133,31,42,31,119,31,189,31,189,30,153,31,32,31,2,31,194,31,131,31,16,31,146,31,146,30,204,31,52,31,33,31,33,30,221,31,3,31,3,30,116,31,240,31,173,31,28,31,11,31,54,31,238,31,166,31,180,31,153,31,20,31,206,31,120,31,15,31,15,30,15,29,46,31,122,31,232,31,35,31,250,31,89,31,226,31,226,30,118,31,225,31,35,31,35,30,112,31,136,31,180,31,180,30,153,31,47,31,149,31,170,31,148,31,148,30,183,31,29,31,110,31,99,31,82,31);

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
