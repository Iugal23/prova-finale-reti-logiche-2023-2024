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

constant SCENARIO_LENGTH : integer := 365;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (237,0,142,0,0,0,4,0,91,0,107,0,0,0,189,0,187,0,243,0,223,0,180,0,0,0,252,0,165,0,139,0,78,0,113,0,41,0,19,0,251,0,166,0,167,0,88,0,103,0,170,0,232,0,0,0,150,0,78,0,0,0,0,0,0,0,0,0,154,0,253,0,140,0,0,0,0,0,181,0,117,0,136,0,123,0,99,0,126,0,235,0,59,0,0,0,249,0,0,0,0,0,217,0,0,0,88,0,111,0,176,0,87,0,138,0,244,0,253,0,53,0,0,0,76,0,229,0,0,0,0,0,215,0,108,0,38,0,219,0,216,0,0,0,251,0,221,0,73,0,57,0,144,0,132,0,41,0,229,0,0,0,238,0,131,0,159,0,0,0,140,0,216,0,12,0,98,0,173,0,151,0,213,0,13,0,0,0,85,0,105,0,117,0,112,0,84,0,122,0,251,0,118,0,79,0,70,0,91,0,243,0,0,0,110,0,16,0,254,0,19,0,244,0,125,0,207,0,160,0,137,0,0,0,0,0,136,0,148,0,5,0,170,0,152,0,164,0,226,0,61,0,228,0,161,0,29,0,141,0,56,0,185,0,62,0,99,0,0,0,95,0,0,0,220,0,225,0,0,0,185,0,0,0,11,0,0,0,55,0,91,0,159,0,44,0,240,0,151,0,137,0,6,0,0,0,145,0,124,0,92,0,82,0,0,0,0,0,41,0,0,0,243,0,0,0,141,0,218,0,231,0,0,0,198,0,26,0,182,0,52,0,179,0,21,0,174,0,35,0,152,0,192,0,18,0,231,0,28,0,192,0,75,0,0,0,8,0,69,0,88,0,214,0,154,0,246,0,154,0,3,0,188,0,83,0,3,0,82,0,226,0,21,0,85,0,213,0,0,0,0,0,64,0,46,0,7,0,0,0,37,0,140,0,0,0,255,0,0,0,223,0,50,0,11,0,203,0,136,0,11,0,212,0,0,0,0,0,0,0,124,0,0,0,174,0,169,0,244,0,48,0,38,0,0,0,69,0,109,0,150,0,128,0,234,0,239,0,230,0,171,0,69,0,0,0,43,0,166,0,169,0,157,0,192,0,205,0,0,0,21,0,101,0,208,0,161,0,45,0,114,0,122,0,47,0,10,0,53,0,0,0,173,0,233,0,118,0,0,0,178,0,178,0,8,0,250,0,92,0,194,0,43,0,64,0,114,0,197,0,123,0,107,0,8,0,0,0,0,0,53,0,0,0,79,0,167,0,41,0,0,0,204,0,61,0,0,0,41,0,151,0,178,0,233,0,140,0,0,0,233,0,111,0,185,0,146,0,26,0,174,0,173,0,44,0,235,0,0,0,0,0,62,0,114,0,17,0,58,0,53,0,0,0,125,0,0,0,0,0,137,0,7,0,39,0,0,0,170,0,85,0,0,0,0,0,0,0,159,0,0,0,0,0,116,0,243,0,138,0,255,0,213,0,248,0,144,0,93,0,0,0,136,0,30,0,250,0,37,0,0,0,171,0,0,0,25,0,177,0,72,0,101,0,236,0,0,0,6,0,247,0,0,0,108,0,0,0,125,0,92,0,26,0,201,0,0,0,0,0,48,0,247,0,0,0,138,0,90,0,138,0,243,0,10,0,0,0,155,0);
signal scenario_full  : scenario_type := (237,31,142,31,142,30,4,31,91,31,107,31,107,30,189,31,187,31,243,31,223,31,180,31,180,30,252,31,165,31,139,31,78,31,113,31,41,31,19,31,251,31,166,31,167,31,88,31,103,31,170,31,232,31,232,30,150,31,78,31,78,30,78,29,78,28,78,27,154,31,253,31,140,31,140,30,140,29,181,31,117,31,136,31,123,31,99,31,126,31,235,31,59,31,59,30,249,31,249,30,249,29,217,31,217,30,88,31,111,31,176,31,87,31,138,31,244,31,253,31,53,31,53,30,76,31,229,31,229,30,229,29,215,31,108,31,38,31,219,31,216,31,216,30,251,31,221,31,73,31,57,31,144,31,132,31,41,31,229,31,229,30,238,31,131,31,159,31,159,30,140,31,216,31,12,31,98,31,173,31,151,31,213,31,13,31,13,30,85,31,105,31,117,31,112,31,84,31,122,31,251,31,118,31,79,31,70,31,91,31,243,31,243,30,110,31,16,31,254,31,19,31,244,31,125,31,207,31,160,31,137,31,137,30,137,29,136,31,148,31,5,31,170,31,152,31,164,31,226,31,61,31,228,31,161,31,29,31,141,31,56,31,185,31,62,31,99,31,99,30,95,31,95,30,220,31,225,31,225,30,185,31,185,30,11,31,11,30,55,31,91,31,159,31,44,31,240,31,151,31,137,31,6,31,6,30,145,31,124,31,92,31,82,31,82,30,82,29,41,31,41,30,243,31,243,30,141,31,218,31,231,31,231,30,198,31,26,31,182,31,52,31,179,31,21,31,174,31,35,31,152,31,192,31,18,31,231,31,28,31,192,31,75,31,75,30,8,31,69,31,88,31,214,31,154,31,246,31,154,31,3,31,188,31,83,31,3,31,82,31,226,31,21,31,85,31,213,31,213,30,213,29,64,31,46,31,7,31,7,30,37,31,140,31,140,30,255,31,255,30,223,31,50,31,11,31,203,31,136,31,11,31,212,31,212,30,212,29,212,28,124,31,124,30,174,31,169,31,244,31,48,31,38,31,38,30,69,31,109,31,150,31,128,31,234,31,239,31,230,31,171,31,69,31,69,30,43,31,166,31,169,31,157,31,192,31,205,31,205,30,21,31,101,31,208,31,161,31,45,31,114,31,122,31,47,31,10,31,53,31,53,30,173,31,233,31,118,31,118,30,178,31,178,31,8,31,250,31,92,31,194,31,43,31,64,31,114,31,197,31,123,31,107,31,8,31,8,30,8,29,53,31,53,30,79,31,167,31,41,31,41,30,204,31,61,31,61,30,41,31,151,31,178,31,233,31,140,31,140,30,233,31,111,31,185,31,146,31,26,31,174,31,173,31,44,31,235,31,235,30,235,29,62,31,114,31,17,31,58,31,53,31,53,30,125,31,125,30,125,29,137,31,7,31,39,31,39,30,170,31,85,31,85,30,85,29,85,28,159,31,159,30,159,29,116,31,243,31,138,31,255,31,213,31,248,31,144,31,93,31,93,30,136,31,30,31,250,31,37,31,37,30,171,31,171,30,25,31,177,31,72,31,101,31,236,31,236,30,6,31,247,31,247,30,108,31,108,30,125,31,92,31,26,31,201,31,201,30,201,29,48,31,247,31,247,30,138,31,90,31,138,31,243,31,10,31,10,30,155,31);

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
