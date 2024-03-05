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

constant SCENARIO_LENGTH : integer := 506;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (244,0,0,0,150,0,205,0,236,0,0,0,0,0,0,0,125,0,53,0,150,0,0,0,246,0,139,0,124,0,179,0,115,0,0,0,0,0,0,0,241,0,156,0,0,0,241,0,50,0,98,0,189,0,92,0,192,0,232,0,0,0,228,0,80,0,74,0,64,0,0,0,183,0,23,0,215,0,0,0,0,0,0,0,74,0,254,0,0,0,0,0,122,0,49,0,0,0,10,0,81,0,36,0,155,0,65,0,246,0,0,0,12,0,196,0,46,0,62,0,197,0,104,0,166,0,198,0,169,0,251,0,197,0,161,0,47,0,225,0,199,0,150,0,0,0,16,0,221,0,7,0,242,0,245,0,131,0,226,0,89,0,92,0,0,0,72,0,8,0,0,0,232,0,254,0,72,0,0,0,120,0,74,0,229,0,134,0,38,0,9,0,131,0,0,0,167,0,0,0,0,0,0,0,254,0,215,0,158,0,0,0,225,0,103,0,154,0,6,0,4,0,136,0,27,0,29,0,207,0,125,0,146,0,0,0,0,0,96,0,0,0,11,0,235,0,0,0,74,0,0,0,247,0,6,0,173,0,249,0,108,0,60,0,0,0,211,0,192,0,146,0,110,0,54,0,0,0,23,0,0,0,221,0,0,0,227,0,227,0,88,0,147,0,159,0,181,0,40,0,214,0,62,0,0,0,0,0,123,0,92,0,0,0,230,0,183,0,169,0,150,0,123,0,84,0,131,0,112,0,81,0,220,0,130,0,27,0,34,0,89,0,113,0,0,0,0,0,112,0,0,0,0,0,148,0,46,0,232,0,31,0,0,0,249,0,68,0,164,0,171,0,83,0,0,0,191,0,0,0,248,0,146,0,156,0,166,0,15,0,137,0,252,0,0,0,146,0,0,0,207,0,76,0,0,0,0,0,69,0,186,0,91,0,75,0,32,0,154,0,65,0,248,0,59,0,178,0,154,0,31,0,0,0,241,0,216,0,233,0,154,0,208,0,118,0,134,0,170,0,244,0,220,0,98,0,37,0,200,0,22,0,50,0,2,0,93,0,0,0,126,0,0,0,129,0,209,0,0,0,0,0,46,0,67,0,134,0,172,0,86,0,161,0,103,0,232,0,32,0,242,0,21,0,93,0,239,0,92,0,78,0,156,0,27,0,0,0,14,0,203,0,126,0,240,0,0,0,223,0,253,0,0,0,175,0,231,0,136,0,15,0,68,0,4,0,100,0,0,0,215,0,93,0,0,0,10,0,59,0,0,0,208,0,58,0,193,0,7,0,68,0,49,0,0,0,62,0,0,0,125,0,228,0,169,0,67,0,0,0,114,0,0,0,0,0,213,0,252,0,0,0,177,0,166,0,23,0,122,0,214,0,141,0,117,0,20,0,253,0,222,0,0,0,0,0,0,0,226,0,42,0,23,0,0,0,243,0,54,0,23,0,0,0,25,0,143,0,0,0,0,0,254,0,6,0,80,0,0,0,62,0,176,0,22,0,75,0,246,0,100,0,247,0,0,0,189,0,212,0,217,0,251,0,47,0,31,0,22,0,195,0,72,0,169,0,0,0,170,0,53,0,175,0,23,0,32,0,148,0,0,0,122,0,0,0,44,0,0,0,212,0,74,0,1,0,20,0,0,0,155,0,109,0,79,0,123,0,0,0,34,0,0,0,8,0,153,0,241,0,60,0,159,0,133,0,207,0,216,0,217,0,4,0,56,0,195,0,41,0,96,0,56,0,245,0,152,0,68,0,0,0,5,0,227,0,144,0,15,0,3,0,115,0,0,0,0,0,255,0,170,0,133,0,243,0,71,0,0,0,148,0,223,0,106,0,0,0,248,0,0,0,132,0,247,0,43,0,50,0,137,0,219,0,238,0,152,0,29,0,0,0,9,0,204,0,138,0,202,0,99,0,22,0,180,0,93,0,11,0,131,0,90,0,126,0,195,0,0,0,156,0,84,0,215,0,243,0,144,0,0,0,0,0,251,0,103,0,233,0,56,0,47,0,8,0,100,0,76,0,0,0,146,0,209,0,233,0,127,0,203,0,114,0,72,0,174,0,249,0,95,0,197,0,251,0,118,0,206,0,9,0,78,0,42,0,0,0,0,0,108,0,96,0,119,0,196,0,73,0,69,0,81,0,0,0,26,0,166,0,180,0,2,0,231,0,46,0,71,0,99,0,126,0,0,0,0,0,150,0,45,0,162,0,7,0,12,0,77,0,179,0,151,0,1,0,163,0,0,0,175,0,179,0,12,0,100,0,0,0,0,0);
signal scenario_full  : scenario_type := (244,31,244,30,150,31,205,31,236,31,236,30,236,29,236,28,125,31,53,31,150,31,150,30,246,31,139,31,124,31,179,31,115,31,115,30,115,29,115,28,241,31,156,31,156,30,241,31,50,31,98,31,189,31,92,31,192,31,232,31,232,30,228,31,80,31,74,31,64,31,64,30,183,31,23,31,215,31,215,30,215,29,215,28,74,31,254,31,254,30,254,29,122,31,49,31,49,30,10,31,81,31,36,31,155,31,65,31,246,31,246,30,12,31,196,31,46,31,62,31,197,31,104,31,166,31,198,31,169,31,251,31,197,31,161,31,47,31,225,31,199,31,150,31,150,30,16,31,221,31,7,31,242,31,245,31,131,31,226,31,89,31,92,31,92,30,72,31,8,31,8,30,232,31,254,31,72,31,72,30,120,31,74,31,229,31,134,31,38,31,9,31,131,31,131,30,167,31,167,30,167,29,167,28,254,31,215,31,158,31,158,30,225,31,103,31,154,31,6,31,4,31,136,31,27,31,29,31,207,31,125,31,146,31,146,30,146,29,96,31,96,30,11,31,235,31,235,30,74,31,74,30,247,31,6,31,173,31,249,31,108,31,60,31,60,30,211,31,192,31,146,31,110,31,54,31,54,30,23,31,23,30,221,31,221,30,227,31,227,31,88,31,147,31,159,31,181,31,40,31,214,31,62,31,62,30,62,29,123,31,92,31,92,30,230,31,183,31,169,31,150,31,123,31,84,31,131,31,112,31,81,31,220,31,130,31,27,31,34,31,89,31,113,31,113,30,113,29,112,31,112,30,112,29,148,31,46,31,232,31,31,31,31,30,249,31,68,31,164,31,171,31,83,31,83,30,191,31,191,30,248,31,146,31,156,31,166,31,15,31,137,31,252,31,252,30,146,31,146,30,207,31,76,31,76,30,76,29,69,31,186,31,91,31,75,31,32,31,154,31,65,31,248,31,59,31,178,31,154,31,31,31,31,30,241,31,216,31,233,31,154,31,208,31,118,31,134,31,170,31,244,31,220,31,98,31,37,31,200,31,22,31,50,31,2,31,93,31,93,30,126,31,126,30,129,31,209,31,209,30,209,29,46,31,67,31,134,31,172,31,86,31,161,31,103,31,232,31,32,31,242,31,21,31,93,31,239,31,92,31,78,31,156,31,27,31,27,30,14,31,203,31,126,31,240,31,240,30,223,31,253,31,253,30,175,31,231,31,136,31,15,31,68,31,4,31,100,31,100,30,215,31,93,31,93,30,10,31,59,31,59,30,208,31,58,31,193,31,7,31,68,31,49,31,49,30,62,31,62,30,125,31,228,31,169,31,67,31,67,30,114,31,114,30,114,29,213,31,252,31,252,30,177,31,166,31,23,31,122,31,214,31,141,31,117,31,20,31,253,31,222,31,222,30,222,29,222,28,226,31,42,31,23,31,23,30,243,31,54,31,23,31,23,30,25,31,143,31,143,30,143,29,254,31,6,31,80,31,80,30,62,31,176,31,22,31,75,31,246,31,100,31,247,31,247,30,189,31,212,31,217,31,251,31,47,31,31,31,22,31,195,31,72,31,169,31,169,30,170,31,53,31,175,31,23,31,32,31,148,31,148,30,122,31,122,30,44,31,44,30,212,31,74,31,1,31,20,31,20,30,155,31,109,31,79,31,123,31,123,30,34,31,34,30,8,31,153,31,241,31,60,31,159,31,133,31,207,31,216,31,217,31,4,31,56,31,195,31,41,31,96,31,56,31,245,31,152,31,68,31,68,30,5,31,227,31,144,31,15,31,3,31,115,31,115,30,115,29,255,31,170,31,133,31,243,31,71,31,71,30,148,31,223,31,106,31,106,30,248,31,248,30,132,31,247,31,43,31,50,31,137,31,219,31,238,31,152,31,29,31,29,30,9,31,204,31,138,31,202,31,99,31,22,31,180,31,93,31,11,31,131,31,90,31,126,31,195,31,195,30,156,31,84,31,215,31,243,31,144,31,144,30,144,29,251,31,103,31,233,31,56,31,47,31,8,31,100,31,76,31,76,30,146,31,209,31,233,31,127,31,203,31,114,31,72,31,174,31,249,31,95,31,197,31,251,31,118,31,206,31,9,31,78,31,42,31,42,30,42,29,108,31,96,31,119,31,196,31,73,31,69,31,81,31,81,30,26,31,166,31,180,31,2,31,231,31,46,31,71,31,99,31,126,31,126,30,126,29,150,31,45,31,162,31,7,31,12,31,77,31,179,31,151,31,1,31,163,31,163,30,175,31,179,31,12,31,100,31,100,30,100,29);

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
