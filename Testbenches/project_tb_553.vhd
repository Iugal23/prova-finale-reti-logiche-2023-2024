-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_553 is
end project_tb_553;

architecture project_tb_arch_553 of project_tb_553 is
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

constant SCENARIO_LENGTH : integer := 743;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (196,0,156,0,0,0,133,0,0,0,30,0,165,0,3,0,0,0,214,0,229,0,0,0,160,0,144,0,158,0,55,0,96,0,242,0,139,0,217,0,195,0,216,0,125,0,57,0,184,0,98,0,167,0,156,0,49,0,0,0,0,0,17,0,151,0,90,0,18,0,69,0,0,0,123,0,253,0,39,0,110,0,191,0,26,0,169,0,59,0,245,0,0,0,141,0,75,0,215,0,0,0,216,0,198,0,0,0,90,0,0,0,232,0,45,0,223,0,171,0,187,0,98,0,76,0,198,0,0,0,63,0,160,0,84,0,156,0,124,0,234,0,93,0,248,0,0,0,31,0,175,0,55,0,132,0,123,0,6,0,79,0,0,0,0,0,43,0,184,0,58,0,122,0,42,0,216,0,107,0,113,0,236,0,141,0,0,0,0,0,73,0,117,0,105,0,15,0,150,0,95,0,72,0,0,0,34,0,37,0,129,0,59,0,136,0,182,0,184,0,147,0,17,0,25,0,207,0,119,0,9,0,190,0,28,0,139,0,112,0,133,0,0,0,0,0,0,0,225,0,194,0,0,0,0,0,158,0,15,0,228,0,100,0,235,0,214,0,71,0,122,0,136,0,254,0,0,0,232,0,0,0,9,0,242,0,124,0,0,0,188,0,236,0,34,0,35,0,120,0,220,0,36,0,221,0,226,0,25,0,0,0,183,0,205,0,170,0,0,0,30,0,54,0,45,0,71,0,192,0,0,0,203,0,125,0,154,0,0,0,207,0,73,0,177,0,181,0,0,0,151,0,214,0,122,0,35,0,99,0,70,0,0,0,223,0,188,0,0,0,162,0,28,0,0,0,195,0,195,0,250,0,229,0,73,0,54,0,240,0,161,0,92,0,251,0,246,0,1,0,234,0,0,0,0,0,228,0,125,0,47,0,98,0,0,0,178,0,145,0,211,0,83,0,155,0,11,0,124,0,80,0,0,0,0,0,227,0,0,0,98,0,118,0,180,0,202,0,194,0,0,0,79,0,147,0,151,0,0,0,154,0,158,0,223,0,99,0,185,0,187,0,0,0,252,0,11,0,196,0,0,0,189,0,66,0,80,0,0,0,60,0,125,0,7,0,239,0,0,0,60,0,220,0,139,0,0,0,21,0,91,0,14,0,73,0,0,0,25,0,105,0,21,0,238,0,246,0,2,0,156,0,0,0,255,0,0,0,173,0,227,0,74,0,0,0,0,0,10,0,0,0,217,0,40,0,4,0,37,0,102,0,0,0,201,0,38,0,0,0,0,0,13,0,47,0,57,0,103,0,0,0,68,0,175,0,0,0,172,0,170,0,0,0,38,0,240,0,0,0,34,0,209,0,0,0,123,0,158,0,218,0,142,0,0,0,27,0,0,0,221,0,169,0,166,0,240,0,101,0,219,0,101,0,67,0,0,0,41,0,133,0,124,0,11,0,0,0,110,0,161,0,195,0,197,0,50,0,235,0,234,0,228,0,10,0,247,0,139,0,238,0,0,0,17,0,0,0,225,0,0,0,225,0,0,0,70,0,137,0,203,0,7,0,0,0,128,0,54,0,66,0,42,0,191,0,249,0,67,0,157,0,184,0,236,0,45,0,184,0,32,0,0,0,166,0,96,0,60,0,58,0,180,0,231,0,124,0,121,0,108,0,70,0,76,0,137,0,59,0,128,0,188,0,38,0,0,0,0,0,189,0,237,0,150,0,42,0,0,0,157,0,0,0,0,0,43,0,249,0,210,0,20,0,68,0,154,0,31,0,114,0,141,0,85,0,189,0,161,0,95,0,0,0,0,0,146,0,73,0,225,0,140,0,181,0,123,0,232,0,188,0,67,0,0,0,152,0,0,0,75,0,244,0,207,0,85,0,0,0,240,0,0,0,13,0,202,0,85,0,2,0,195,0,173,0,10,0,50,0,239,0,55,0,0,0,152,0,189,0,180,0,201,0,0,0,66,0,162,0,0,0,60,0,68,0,0,0,108,0,0,0,0,0,0,0,63,0,104,0,123,0,68,0,229,0,141,0,30,0,82,0,0,0,0,0,43,0,166,0,213,0,251,0,147,0,0,0,185,0,253,0,192,0,128,0,246,0,216,0,0,0,4,0,121,0,200,0,0,0,156,0,114,0,152,0,0,0,79,0,92,0,181,0,103,0,231,0,20,0,0,0,0,0,0,0,115,0,224,0,242,0,86,0,0,0,15,0,96,0,128,0,183,0,119,0,0,0,218,0,0,0,0,0,63,0,130,0,28,0,254,0,19,0,34,0,65,0,37,0,0,0,14,0,47,0,0,0,34,0,0,0,69,0,2,0,18,0,218,0,198,0,14,0,28,0,0,0,0,0,215,0,119,0,195,0,93,0,0,0,0,0,18,0,222,0,47,0,0,0,222,0,222,0,152,0,151,0,104,0,141,0,168,0,59,0,99,0,100,0,0,0,97,0,1,0,147,0,213,0,87,0,25,0,174,0,63,0,205,0,224,0,229,0,201,0,0,0,19,0,177,0,83,0,166,0,209,0,0,0,0,0,164,0,0,0,43,0,221,0,241,0,225,0,0,0,199,0,106,0,35,0,83,0,148,0,183,0,58,0,24,0,196,0,0,0,188,0,11,0,42,0,116,0,190,0,46,0,0,0,0,0,0,0,0,0,80,0,236,0,0,0,42,0,50,0,182,0,88,0,94,0,0,0,1,0,19,0,33,0,0,0,0,0,51,0,215,0,172,0,26,0,46,0,0,0,102,0,103,0,122,0,0,0,74,0,155,0,0,0,0,0,157,0,222,0,161,0,145,0,0,0,49,0,126,0,9,0,79,0,104,0,67,0,17,0,0,0,47,0,127,0,176,0,0,0,186,0,96,0,0,0,0,0,0,0,48,0,207,0,162,0,0,0,5,0,197,0,102,0,66,0,94,0,126,0,0,0,48,0,162,0,77,0,0,0,74,0,0,0,132,0,0,0,18,0,205,0,165,0,122,0,196,0,0,0,0,0,0,0,43,0,244,0,243,0,50,0,151,0,178,0,44,0,243,0,195,0,48,0,152,0,0,0,183,0,249,0,0,0,205,0,185,0,25,0,96,0,217,0,97,0,75,0,147,0,0,0,0,0,240,0,47,0,48,0,0,0,0,0,214,0,125,0,1,0,126,0,157,0,0,0,252,0,0,0,0,0,0,0,0,0,73,0,147,0,200,0,0,0,182,0,105,0,98,0,0,0,227,0,168,0,175,0,172,0,30,0,250,0,28,0,52,0,196,0,176,0,151,0,124,0,0,0,38,0,119,0,98,0,218,0,0,0,139,0,198,0,170,0,7,0,0,0,209,0);
signal scenario_full  : scenario_type := (196,31,156,31,156,30,133,31,133,30,30,31,165,31,3,31,3,30,214,31,229,31,229,30,160,31,144,31,158,31,55,31,96,31,242,31,139,31,217,31,195,31,216,31,125,31,57,31,184,31,98,31,167,31,156,31,49,31,49,30,49,29,17,31,151,31,90,31,18,31,69,31,69,30,123,31,253,31,39,31,110,31,191,31,26,31,169,31,59,31,245,31,245,30,141,31,75,31,215,31,215,30,216,31,198,31,198,30,90,31,90,30,232,31,45,31,223,31,171,31,187,31,98,31,76,31,198,31,198,30,63,31,160,31,84,31,156,31,124,31,234,31,93,31,248,31,248,30,31,31,175,31,55,31,132,31,123,31,6,31,79,31,79,30,79,29,43,31,184,31,58,31,122,31,42,31,216,31,107,31,113,31,236,31,141,31,141,30,141,29,73,31,117,31,105,31,15,31,150,31,95,31,72,31,72,30,34,31,37,31,129,31,59,31,136,31,182,31,184,31,147,31,17,31,25,31,207,31,119,31,9,31,190,31,28,31,139,31,112,31,133,31,133,30,133,29,133,28,225,31,194,31,194,30,194,29,158,31,15,31,228,31,100,31,235,31,214,31,71,31,122,31,136,31,254,31,254,30,232,31,232,30,9,31,242,31,124,31,124,30,188,31,236,31,34,31,35,31,120,31,220,31,36,31,221,31,226,31,25,31,25,30,183,31,205,31,170,31,170,30,30,31,54,31,45,31,71,31,192,31,192,30,203,31,125,31,154,31,154,30,207,31,73,31,177,31,181,31,181,30,151,31,214,31,122,31,35,31,99,31,70,31,70,30,223,31,188,31,188,30,162,31,28,31,28,30,195,31,195,31,250,31,229,31,73,31,54,31,240,31,161,31,92,31,251,31,246,31,1,31,234,31,234,30,234,29,228,31,125,31,47,31,98,31,98,30,178,31,145,31,211,31,83,31,155,31,11,31,124,31,80,31,80,30,80,29,227,31,227,30,98,31,118,31,180,31,202,31,194,31,194,30,79,31,147,31,151,31,151,30,154,31,158,31,223,31,99,31,185,31,187,31,187,30,252,31,11,31,196,31,196,30,189,31,66,31,80,31,80,30,60,31,125,31,7,31,239,31,239,30,60,31,220,31,139,31,139,30,21,31,91,31,14,31,73,31,73,30,25,31,105,31,21,31,238,31,246,31,2,31,156,31,156,30,255,31,255,30,173,31,227,31,74,31,74,30,74,29,10,31,10,30,217,31,40,31,4,31,37,31,102,31,102,30,201,31,38,31,38,30,38,29,13,31,47,31,57,31,103,31,103,30,68,31,175,31,175,30,172,31,170,31,170,30,38,31,240,31,240,30,34,31,209,31,209,30,123,31,158,31,218,31,142,31,142,30,27,31,27,30,221,31,169,31,166,31,240,31,101,31,219,31,101,31,67,31,67,30,41,31,133,31,124,31,11,31,11,30,110,31,161,31,195,31,197,31,50,31,235,31,234,31,228,31,10,31,247,31,139,31,238,31,238,30,17,31,17,30,225,31,225,30,225,31,225,30,70,31,137,31,203,31,7,31,7,30,128,31,54,31,66,31,42,31,191,31,249,31,67,31,157,31,184,31,236,31,45,31,184,31,32,31,32,30,166,31,96,31,60,31,58,31,180,31,231,31,124,31,121,31,108,31,70,31,76,31,137,31,59,31,128,31,188,31,38,31,38,30,38,29,189,31,237,31,150,31,42,31,42,30,157,31,157,30,157,29,43,31,249,31,210,31,20,31,68,31,154,31,31,31,114,31,141,31,85,31,189,31,161,31,95,31,95,30,95,29,146,31,73,31,225,31,140,31,181,31,123,31,232,31,188,31,67,31,67,30,152,31,152,30,75,31,244,31,207,31,85,31,85,30,240,31,240,30,13,31,202,31,85,31,2,31,195,31,173,31,10,31,50,31,239,31,55,31,55,30,152,31,189,31,180,31,201,31,201,30,66,31,162,31,162,30,60,31,68,31,68,30,108,31,108,30,108,29,108,28,63,31,104,31,123,31,68,31,229,31,141,31,30,31,82,31,82,30,82,29,43,31,166,31,213,31,251,31,147,31,147,30,185,31,253,31,192,31,128,31,246,31,216,31,216,30,4,31,121,31,200,31,200,30,156,31,114,31,152,31,152,30,79,31,92,31,181,31,103,31,231,31,20,31,20,30,20,29,20,28,115,31,224,31,242,31,86,31,86,30,15,31,96,31,128,31,183,31,119,31,119,30,218,31,218,30,218,29,63,31,130,31,28,31,254,31,19,31,34,31,65,31,37,31,37,30,14,31,47,31,47,30,34,31,34,30,69,31,2,31,18,31,218,31,198,31,14,31,28,31,28,30,28,29,215,31,119,31,195,31,93,31,93,30,93,29,18,31,222,31,47,31,47,30,222,31,222,31,152,31,151,31,104,31,141,31,168,31,59,31,99,31,100,31,100,30,97,31,1,31,147,31,213,31,87,31,25,31,174,31,63,31,205,31,224,31,229,31,201,31,201,30,19,31,177,31,83,31,166,31,209,31,209,30,209,29,164,31,164,30,43,31,221,31,241,31,225,31,225,30,199,31,106,31,35,31,83,31,148,31,183,31,58,31,24,31,196,31,196,30,188,31,11,31,42,31,116,31,190,31,46,31,46,30,46,29,46,28,46,27,80,31,236,31,236,30,42,31,50,31,182,31,88,31,94,31,94,30,1,31,19,31,33,31,33,30,33,29,51,31,215,31,172,31,26,31,46,31,46,30,102,31,103,31,122,31,122,30,74,31,155,31,155,30,155,29,157,31,222,31,161,31,145,31,145,30,49,31,126,31,9,31,79,31,104,31,67,31,17,31,17,30,47,31,127,31,176,31,176,30,186,31,96,31,96,30,96,29,96,28,48,31,207,31,162,31,162,30,5,31,197,31,102,31,66,31,94,31,126,31,126,30,48,31,162,31,77,31,77,30,74,31,74,30,132,31,132,30,18,31,205,31,165,31,122,31,196,31,196,30,196,29,196,28,43,31,244,31,243,31,50,31,151,31,178,31,44,31,243,31,195,31,48,31,152,31,152,30,183,31,249,31,249,30,205,31,185,31,25,31,96,31,217,31,97,31,75,31,147,31,147,30,147,29,240,31,47,31,48,31,48,30,48,29,214,31,125,31,1,31,126,31,157,31,157,30,252,31,252,30,252,29,252,28,252,27,73,31,147,31,200,31,200,30,182,31,105,31,98,31,98,30,227,31,168,31,175,31,172,31,30,31,250,31,28,31,52,31,196,31,176,31,151,31,124,31,124,30,38,31,119,31,98,31,218,31,218,30,139,31,198,31,170,31,7,31,7,30,209,31);

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
