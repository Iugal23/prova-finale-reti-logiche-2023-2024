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

constant SCENARIO_LENGTH : integer := 453;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (38,0,0,0,0,0,207,0,126,0,188,0,0,0,0,0,2,0,74,0,45,0,42,0,191,0,86,0,116,0,148,0,26,0,178,0,161,0,253,0,231,0,170,0,105,0,115,0,167,0,17,0,21,0,0,0,210,0,0,0,85,0,0,0,0,0,162,0,188,0,155,0,146,0,134,0,9,0,237,0,166,0,213,0,224,0,0,0,28,0,0,0,183,0,0,0,183,0,0,0,54,0,96,0,179,0,47,0,0,0,226,0,51,0,185,0,110,0,195,0,5,0,205,0,105,0,227,0,223,0,116,0,31,0,212,0,215,0,254,0,57,0,53,0,188,0,163,0,12,0,0,0,0,0,0,0,114,0,0,0,4,0,30,0,102,0,93,0,115,0,91,0,178,0,181,0,85,0,151,0,112,0,255,0,2,0,132,0,0,0,11,0,0,0,128,0,0,0,255,0,216,0,137,0,184,0,222,0,236,0,0,0,106,0,253,0,181,0,203,0,99,0,156,0,117,0,94,0,160,0,81,0,0,0,39,0,81,0,95,0,106,0,184,0,160,0,200,0,0,0,144,0,70,0,168,0,0,0,247,0,40,0,0,0,163,0,213,0,46,0,194,0,145,0,49,0,239,0,110,0,151,0,234,0,213,0,151,0,195,0,161,0,0,0,50,0,241,0,182,0,131,0,0,0,175,0,42,0,83,0,140,0,43,0,142,0,40,0,32,0,134,0,62,0,226,0,230,0,118,0,73,0,32,0,5,0,16,0,34,0,71,0,0,0,232,0,235,0,36,0,244,0,226,0,185,0,58,0,0,0,15,0,7,0,80,0,114,0,174,0,0,0,185,0,123,0,128,0,243,0,194,0,0,0,228,0,30,0,198,0,152,0,248,0,198,0,183,0,68,0,164,0,39,0,184,0,202,0,80,0,0,0,0,0,24,0,123,0,176,0,86,0,9,0,180,0,100,0,160,0,44,0,55,0,132,0,119,0,184,0,69,0,172,0,30,0,0,0,32,0,196,0,150,0,220,0,27,0,135,0,249,0,145,0,224,0,251,0,44,0,121,0,184,0,169,0,101,0,16,0,124,0,100,0,0,0,248,0,47,0,0,0,71,0,228,0,180,0,42,0,149,0,170,0,143,0,0,0,45,0,66,0,0,0,187,0,132,0,3,0,126,0,235,0,91,0,59,0,190,0,226,0,34,0,156,0,99,0,136,0,163,0,54,0,6,0,178,0,221,0,229,0,0,0,0,0,176,0,0,0,237,0,37,0,118,0,164,0,48,0,18,0,23,0,225,0,127,0,131,0,131,0,54,0,12,0,247,0,132,0,0,0,0,0,0,0,0,0,134,0,71,0,249,0,185,0,0,0,79,0,91,0,0,0,134,0,213,0,45,0,159,0,106,0,1,0,92,0,49,0,176,0,212,0,70,0,9,0,174,0,156,0,30,0,66,0,8,0,193,0,249,0,123,0,16,0,222,0,208,0,146,0,13,0,229,0,41,0,147,0,0,0,190,0,99,0,166,0,198,0,135,0,0,0,241,0,185,0,44,0,251,0,0,0,99,0,143,0,141,0,0,0,210,0,74,0,0,0,114,0,82,0,196,0,52,0,226,0,181,0,0,0,154,0,0,0,0,0,62,0,9,0,41,0,35,0,0,0,50,0,219,0,231,0,0,0,60,0,176,0,0,0,14,0,233,0,41,0,130,0,170,0,2,0,245,0,0,0,93,0,0,0,174,0,190,0,18,0,183,0,72,0,212,0,249,0,246,0,0,0,135,0,245,0,255,0,37,0,189,0,85,0,206,0,45,0,128,0,0,0,188,0,169,0,13,0,141,0,201,0,232,0,0,0,137,0,189,0,210,0,0,0,0,0,21,0,109,0,120,0,115,0,0,0,0,0,80,0,117,0,218,0,35,0,24,0,0,0,148,0,27,0,117,0,0,0,91,0,171,0,0,0,3,0,58,0,250,0,100,0,0,0,119,0,201,0,234,0,95,0,82,0,0,0,0,0,140,0,47,0,203,0,115,0,0,0);
signal scenario_full  : scenario_type := (38,31,38,30,38,29,207,31,126,31,188,31,188,30,188,29,2,31,74,31,45,31,42,31,191,31,86,31,116,31,148,31,26,31,178,31,161,31,253,31,231,31,170,31,105,31,115,31,167,31,17,31,21,31,21,30,210,31,210,30,85,31,85,30,85,29,162,31,188,31,155,31,146,31,134,31,9,31,237,31,166,31,213,31,224,31,224,30,28,31,28,30,183,31,183,30,183,31,183,30,54,31,96,31,179,31,47,31,47,30,226,31,51,31,185,31,110,31,195,31,5,31,205,31,105,31,227,31,223,31,116,31,31,31,212,31,215,31,254,31,57,31,53,31,188,31,163,31,12,31,12,30,12,29,12,28,114,31,114,30,4,31,30,31,102,31,93,31,115,31,91,31,178,31,181,31,85,31,151,31,112,31,255,31,2,31,132,31,132,30,11,31,11,30,128,31,128,30,255,31,216,31,137,31,184,31,222,31,236,31,236,30,106,31,253,31,181,31,203,31,99,31,156,31,117,31,94,31,160,31,81,31,81,30,39,31,81,31,95,31,106,31,184,31,160,31,200,31,200,30,144,31,70,31,168,31,168,30,247,31,40,31,40,30,163,31,213,31,46,31,194,31,145,31,49,31,239,31,110,31,151,31,234,31,213,31,151,31,195,31,161,31,161,30,50,31,241,31,182,31,131,31,131,30,175,31,42,31,83,31,140,31,43,31,142,31,40,31,32,31,134,31,62,31,226,31,230,31,118,31,73,31,32,31,5,31,16,31,34,31,71,31,71,30,232,31,235,31,36,31,244,31,226,31,185,31,58,31,58,30,15,31,7,31,80,31,114,31,174,31,174,30,185,31,123,31,128,31,243,31,194,31,194,30,228,31,30,31,198,31,152,31,248,31,198,31,183,31,68,31,164,31,39,31,184,31,202,31,80,31,80,30,80,29,24,31,123,31,176,31,86,31,9,31,180,31,100,31,160,31,44,31,55,31,132,31,119,31,184,31,69,31,172,31,30,31,30,30,32,31,196,31,150,31,220,31,27,31,135,31,249,31,145,31,224,31,251,31,44,31,121,31,184,31,169,31,101,31,16,31,124,31,100,31,100,30,248,31,47,31,47,30,71,31,228,31,180,31,42,31,149,31,170,31,143,31,143,30,45,31,66,31,66,30,187,31,132,31,3,31,126,31,235,31,91,31,59,31,190,31,226,31,34,31,156,31,99,31,136,31,163,31,54,31,6,31,178,31,221,31,229,31,229,30,229,29,176,31,176,30,237,31,37,31,118,31,164,31,48,31,18,31,23,31,225,31,127,31,131,31,131,31,54,31,12,31,247,31,132,31,132,30,132,29,132,28,132,27,134,31,71,31,249,31,185,31,185,30,79,31,91,31,91,30,134,31,213,31,45,31,159,31,106,31,1,31,92,31,49,31,176,31,212,31,70,31,9,31,174,31,156,31,30,31,66,31,8,31,193,31,249,31,123,31,16,31,222,31,208,31,146,31,13,31,229,31,41,31,147,31,147,30,190,31,99,31,166,31,198,31,135,31,135,30,241,31,185,31,44,31,251,31,251,30,99,31,143,31,141,31,141,30,210,31,74,31,74,30,114,31,82,31,196,31,52,31,226,31,181,31,181,30,154,31,154,30,154,29,62,31,9,31,41,31,35,31,35,30,50,31,219,31,231,31,231,30,60,31,176,31,176,30,14,31,233,31,41,31,130,31,170,31,2,31,245,31,245,30,93,31,93,30,174,31,190,31,18,31,183,31,72,31,212,31,249,31,246,31,246,30,135,31,245,31,255,31,37,31,189,31,85,31,206,31,45,31,128,31,128,30,188,31,169,31,13,31,141,31,201,31,232,31,232,30,137,31,189,31,210,31,210,30,210,29,21,31,109,31,120,31,115,31,115,30,115,29,80,31,117,31,218,31,35,31,24,31,24,30,148,31,27,31,117,31,117,30,91,31,171,31,171,30,3,31,58,31,250,31,100,31,100,30,119,31,201,31,234,31,95,31,82,31,82,30,82,29,140,31,47,31,203,31,115,31,115,30);

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
