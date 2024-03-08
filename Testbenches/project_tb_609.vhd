-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_609 is
end project_tb_609;

architecture project_tb_arch_609 of project_tb_609 is
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

constant SCENARIO_LENGTH : integer := 383;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (96,0,0,0,104,0,0,0,0,0,247,0,235,0,123,0,189,0,125,0,223,0,216,0,56,0,34,0,157,0,219,0,218,0,140,0,0,0,12,0,94,0,245,0,0,0,238,0,170,0,157,0,152,0,0,0,153,0,129,0,84,0,0,0,229,0,187,0,190,0,139,0,13,0,0,0,48,0,254,0,51,0,0,0,22,0,226,0,6,0,114,0,93,0,0,0,233,0,60,0,20,0,51,0,239,0,74,0,195,0,172,0,210,0,44,0,118,0,0,0,0,0,25,0,74,0,228,0,117,0,176,0,185,0,88,0,244,0,109,0,96,0,102,0,49,0,185,0,56,0,251,0,248,0,239,0,69,0,108,0,131,0,53,0,52,0,53,0,0,0,50,0,148,0,155,0,0,0,51,0,206,0,0,0,0,0,86,0,240,0,0,0,172,0,141,0,212,0,122,0,73,0,209,0,84,0,125,0,85,0,38,0,26,0,151,0,123,0,31,0,95,0,202,0,38,0,255,0,211,0,104,0,220,0,0,0,0,0,137,0,0,0,72,0,72,0,181,0,0,0,0,0,234,0,145,0,227,0,180,0,190,0,162,0,85,0,242,0,14,0,169,0,160,0,216,0,177,0,150,0,144,0,175,0,173,0,95,0,102,0,52,0,0,0,139,0,82,0,48,0,154,0,51,0,155,0,2,0,218,0,142,0,0,0,234,0,219,0,0,0,98,0,0,0,151,0,143,0,110,0,0,0,56,0,31,0,225,0,130,0,51,0,125,0,168,0,228,0,215,0,187,0,197,0,15,0,50,0,45,0,0,0,119,0,141,0,0,0,35,0,193,0,29,0,30,0,124,0,0,0,231,0,176,0,47,0,24,0,192,0,249,0,183,0,40,0,131,0,77,0,181,0,145,0,252,0,182,0,165,0,185,0,151,0,103,0,0,0,0,0,196,0,144,0,114,0,40,0,68,0,89,0,253,0,242,0,98,0,5,0,151,0,116,0,183,0,213,0,0,0,222,0,153,0,110,0,148,0,89,0,184,0,34,0,0,0,193,0,223,0,247,0,164,0,168,0,18,0,0,0,202,0,139,0,135,0,0,0,154,0,28,0,187,0,0,0,20,0,0,0,45,0,0,0,64,0,0,0,217,0,255,0,61,0,99,0,21,0,99,0,94,0,0,0,165,0,42,0,79,0,0,0,45,0,0,0,171,0,92,0,69,0,136,0,37,0,205,0,153,0,104,0,0,0,148,0,0,0,56,0,181,0,222,0,108,0,183,0,0,0,56,0,231,0,255,0,2,0,181,0,42,0,244,0,156,0,255,0,38,0,35,0,177,0,146,0,3,0,114,0,127,0,15,0,254,0,221,0,144,0,144,0,224,0,53,0,25,0,175,0,76,0,0,0,94,0,191,0,211,0,0,0,115,0,44,0,61,0,170,0,35,0,83,0,246,0,0,0,0,0,16,0,165,0,0,0,21,0,34,0,181,0,102,0,0,0,60,0,11,0,145,0,164,0,88,0,126,0,246,0,184,0,17,0,0,0,124,0,44,0,139,0,156,0,0,0,16,0,45,0,183,0,0,0,58,0,163,0,155,0,107,0,0,0,0,0,192,0,253,0,87,0,127,0,225,0,175,0,156,0,190,0,168,0,82,0,0,0,88,0,50,0,196,0,230,0,100,0,0,0,190,0,249,0,232,0,25,0,160,0,239,0,158,0,233,0);
signal scenario_full  : scenario_type := (96,31,96,30,104,31,104,30,104,29,247,31,235,31,123,31,189,31,125,31,223,31,216,31,56,31,34,31,157,31,219,31,218,31,140,31,140,30,12,31,94,31,245,31,245,30,238,31,170,31,157,31,152,31,152,30,153,31,129,31,84,31,84,30,229,31,187,31,190,31,139,31,13,31,13,30,48,31,254,31,51,31,51,30,22,31,226,31,6,31,114,31,93,31,93,30,233,31,60,31,20,31,51,31,239,31,74,31,195,31,172,31,210,31,44,31,118,31,118,30,118,29,25,31,74,31,228,31,117,31,176,31,185,31,88,31,244,31,109,31,96,31,102,31,49,31,185,31,56,31,251,31,248,31,239,31,69,31,108,31,131,31,53,31,52,31,53,31,53,30,50,31,148,31,155,31,155,30,51,31,206,31,206,30,206,29,86,31,240,31,240,30,172,31,141,31,212,31,122,31,73,31,209,31,84,31,125,31,85,31,38,31,26,31,151,31,123,31,31,31,95,31,202,31,38,31,255,31,211,31,104,31,220,31,220,30,220,29,137,31,137,30,72,31,72,31,181,31,181,30,181,29,234,31,145,31,227,31,180,31,190,31,162,31,85,31,242,31,14,31,169,31,160,31,216,31,177,31,150,31,144,31,175,31,173,31,95,31,102,31,52,31,52,30,139,31,82,31,48,31,154,31,51,31,155,31,2,31,218,31,142,31,142,30,234,31,219,31,219,30,98,31,98,30,151,31,143,31,110,31,110,30,56,31,31,31,225,31,130,31,51,31,125,31,168,31,228,31,215,31,187,31,197,31,15,31,50,31,45,31,45,30,119,31,141,31,141,30,35,31,193,31,29,31,30,31,124,31,124,30,231,31,176,31,47,31,24,31,192,31,249,31,183,31,40,31,131,31,77,31,181,31,145,31,252,31,182,31,165,31,185,31,151,31,103,31,103,30,103,29,196,31,144,31,114,31,40,31,68,31,89,31,253,31,242,31,98,31,5,31,151,31,116,31,183,31,213,31,213,30,222,31,153,31,110,31,148,31,89,31,184,31,34,31,34,30,193,31,223,31,247,31,164,31,168,31,18,31,18,30,202,31,139,31,135,31,135,30,154,31,28,31,187,31,187,30,20,31,20,30,45,31,45,30,64,31,64,30,217,31,255,31,61,31,99,31,21,31,99,31,94,31,94,30,165,31,42,31,79,31,79,30,45,31,45,30,171,31,92,31,69,31,136,31,37,31,205,31,153,31,104,31,104,30,148,31,148,30,56,31,181,31,222,31,108,31,183,31,183,30,56,31,231,31,255,31,2,31,181,31,42,31,244,31,156,31,255,31,38,31,35,31,177,31,146,31,3,31,114,31,127,31,15,31,254,31,221,31,144,31,144,31,224,31,53,31,25,31,175,31,76,31,76,30,94,31,191,31,211,31,211,30,115,31,44,31,61,31,170,31,35,31,83,31,246,31,246,30,246,29,16,31,165,31,165,30,21,31,34,31,181,31,102,31,102,30,60,31,11,31,145,31,164,31,88,31,126,31,246,31,184,31,17,31,17,30,124,31,44,31,139,31,156,31,156,30,16,31,45,31,183,31,183,30,58,31,163,31,155,31,107,31,107,30,107,29,192,31,253,31,87,31,127,31,225,31,175,31,156,31,190,31,168,31,82,31,82,30,88,31,50,31,196,31,230,31,100,31,100,30,190,31,249,31,232,31,25,31,160,31,239,31,158,31,233,31);

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
