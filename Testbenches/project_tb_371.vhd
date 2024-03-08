-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_371 is
end project_tb_371;

architecture project_tb_arch_371 of project_tb_371 is
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

constant SCENARIO_LENGTH : integer := 593;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (103,0,103,0,0,0,112,0,90,0,128,0,120,0,33,0,68,0,0,0,168,0,0,0,67,0,0,0,155,0,121,0,0,0,249,0,63,0,3,0,198,0,130,0,45,0,19,0,39,0,140,0,0,0,65,0,86,0,11,0,11,0,131,0,252,0,19,0,0,0,176,0,25,0,0,0,56,0,25,0,0,0,152,0,133,0,160,0,0,0,0,0,9,0,228,0,105,0,204,0,38,0,74,0,193,0,0,0,54,0,71,0,251,0,0,0,227,0,253,0,190,0,79,0,65,0,100,0,36,0,138,0,150,0,0,0,198,0,0,0,75,0,201,0,0,0,144,0,16,0,3,0,188,0,40,0,77,0,93,0,144,0,131,0,183,0,171,0,19,0,15,0,82,0,134,0,46,0,170,0,237,0,164,0,72,0,68,0,251,0,129,0,151,0,86,0,215,0,107,0,0,0,0,0,138,0,93,0,52,0,116,0,1,0,76,0,88,0,184,0,233,0,88,0,22,0,33,0,45,0,102,0,107,0,210,0,17,0,254,0,85,0,250,0,46,0,164,0,86,0,178,0,0,0,0,0,186,0,123,0,0,0,0,0,208,0,0,0,178,0,0,0,118,0,0,0,116,0,28,0,90,0,28,0,37,0,247,0,0,0,185,0,24,0,241,0,179,0,0,0,0,0,214,0,37,0,0,0,195,0,242,0,65,0,28,0,216,0,0,0,167,0,89,0,61,0,1,0,0,0,205,0,47,0,207,0,0,0,185,0,50,0,0,0,107,0,179,0,161,0,0,0,61,0,127,0,0,0,63,0,244,0,254,0,59,0,175,0,0,0,240,0,172,0,210,0,137,0,0,0,0,0,124,0,116,0,18,0,0,0,5,0,56,0,249,0,201,0,80,0,120,0,114,0,80,0,189,0,116,0,202,0,149,0,151,0,145,0,176,0,38,0,92,0,13,0,0,0,198,0,236,0,0,0,128,0,202,0,35,0,49,0,0,0,13,0,68,0,51,0,22,0,0,0,0,0,0,0,152,0,30,0,162,0,2,0,244,0,135,0,94,0,166,0,0,0,93,0,88,0,78,0,58,0,102,0,76,0,177,0,209,0,0,0,160,0,1,0,70,0,96,0,173,0,0,0,83,0,22,0,34,0,0,0,127,0,140,0,190,0,53,0,0,0,219,0,13,0,0,0,194,0,54,0,11,0,0,0,209,0,136,0,219,0,0,0,152,0,0,0,0,0,192,0,0,0,34,0,49,0,11,0,69,0,233,0,205,0,5,0,22,0,169,0,17,0,56,0,254,0,29,0,96,0,140,0,67,0,218,0,250,0,28,0,51,0,51,0,27,0,118,0,176,0,0,0,60,0,0,0,142,0,24,0,140,0,0,0,223,0,92,0,71,0,145,0,107,0,173,0,36,0,133,0,162,0,0,0,253,0,2,0,247,0,150,0,211,0,49,0,0,0,61,0,0,0,0,0,0,0,7,0,0,0,0,0,27,0,236,0,64,0,254,0,63,0,199,0,0,0,177,0,137,0,65,0,10,0,11,0,0,0,195,0,168,0,0,0,193,0,121,0,0,0,0,0,0,0,30,0,138,0,0,0,153,0,171,0,70,0,255,0,0,0,204,0,148,0,177,0,110,0,57,0,0,0,105,0,102,0,0,0,164,0,142,0,0,0,0,0,128,0,151,0,0,0,132,0,191,0,96,0,172,0,0,0,213,0,219,0,88,0,189,0,176,0,243,0,197,0,51,0,0,0,200,0,108,0,180,0,239,0,0,0,199,0,0,0,238,0,191,0,75,0,43,0,119,0,38,0,0,0,100,0,0,0,121,0,183,0,221,0,95,0,120,0,152,0,107,0,89,0,8,0,162,0,0,0,216,0,153,0,203,0,170,0,41,0,247,0,188,0,176,0,198,0,79,0,80,0,232,0,62,0,0,0,188,0,10,0,42,0,192,0,30,0,204,0,222,0,110,0,56,0,37,0,22,0,188,0,0,0,177,0,181,0,114,0,203,0,33,0,72,0,0,0,52,0,0,0,24,0,149,0,168,0,97,0,129,0,56,0,0,0,190,0,171,0,0,0,102,0,108,0,123,0,8,0,249,0,0,0,0,0,140,0,62,0,47,0,175,0,168,0,131,0,19,0,74,0,0,0,0,0,177,0,75,0,145,0,41,0,228,0,155,0,240,0,243,0,0,0,5,0,50,0,159,0,154,0,162,0,168,0,0,0,184,0,192,0,52,0,250,0,24,0,153,0,118,0,150,0,120,0,134,0,0,0,163,0,213,0,0,0,59,0,0,0,208,0,0,0,60,0,104,0,146,0,197,0,61,0,120,0,89,0,65,0,234,0,224,0,238,0,0,0,249,0,28,0,6,0,169,0,51,0,0,0,132,0,0,0,156,0,104,0,204,0,143,0,0,0,3,0,167,0,126,0,82,0,118,0,188,0,0,0,151,0,216,0,173,0,170,0,139,0,21,0,0,0,109,0,0,0,0,0,80,0,49,0,179,0,176,0,39,0,107,0,0,0,59,0,0,0,79,0,0,0,181,0,117,0,243,0,110,0,158,0,0,0,136,0,251,0,168,0,110,0,160,0,186,0,221,0,116,0,196,0,193,0,27,0,179,0,193,0,0,0,170,0,248,0,0,0,100,0);
signal scenario_full  : scenario_type := (103,31,103,31,103,30,112,31,90,31,128,31,120,31,33,31,68,31,68,30,168,31,168,30,67,31,67,30,155,31,121,31,121,30,249,31,63,31,3,31,198,31,130,31,45,31,19,31,39,31,140,31,140,30,65,31,86,31,11,31,11,31,131,31,252,31,19,31,19,30,176,31,25,31,25,30,56,31,25,31,25,30,152,31,133,31,160,31,160,30,160,29,9,31,228,31,105,31,204,31,38,31,74,31,193,31,193,30,54,31,71,31,251,31,251,30,227,31,253,31,190,31,79,31,65,31,100,31,36,31,138,31,150,31,150,30,198,31,198,30,75,31,201,31,201,30,144,31,16,31,3,31,188,31,40,31,77,31,93,31,144,31,131,31,183,31,171,31,19,31,15,31,82,31,134,31,46,31,170,31,237,31,164,31,72,31,68,31,251,31,129,31,151,31,86,31,215,31,107,31,107,30,107,29,138,31,93,31,52,31,116,31,1,31,76,31,88,31,184,31,233,31,88,31,22,31,33,31,45,31,102,31,107,31,210,31,17,31,254,31,85,31,250,31,46,31,164,31,86,31,178,31,178,30,178,29,186,31,123,31,123,30,123,29,208,31,208,30,178,31,178,30,118,31,118,30,116,31,28,31,90,31,28,31,37,31,247,31,247,30,185,31,24,31,241,31,179,31,179,30,179,29,214,31,37,31,37,30,195,31,242,31,65,31,28,31,216,31,216,30,167,31,89,31,61,31,1,31,1,30,205,31,47,31,207,31,207,30,185,31,50,31,50,30,107,31,179,31,161,31,161,30,61,31,127,31,127,30,63,31,244,31,254,31,59,31,175,31,175,30,240,31,172,31,210,31,137,31,137,30,137,29,124,31,116,31,18,31,18,30,5,31,56,31,249,31,201,31,80,31,120,31,114,31,80,31,189,31,116,31,202,31,149,31,151,31,145,31,176,31,38,31,92,31,13,31,13,30,198,31,236,31,236,30,128,31,202,31,35,31,49,31,49,30,13,31,68,31,51,31,22,31,22,30,22,29,22,28,152,31,30,31,162,31,2,31,244,31,135,31,94,31,166,31,166,30,93,31,88,31,78,31,58,31,102,31,76,31,177,31,209,31,209,30,160,31,1,31,70,31,96,31,173,31,173,30,83,31,22,31,34,31,34,30,127,31,140,31,190,31,53,31,53,30,219,31,13,31,13,30,194,31,54,31,11,31,11,30,209,31,136,31,219,31,219,30,152,31,152,30,152,29,192,31,192,30,34,31,49,31,11,31,69,31,233,31,205,31,5,31,22,31,169,31,17,31,56,31,254,31,29,31,96,31,140,31,67,31,218,31,250,31,28,31,51,31,51,31,27,31,118,31,176,31,176,30,60,31,60,30,142,31,24,31,140,31,140,30,223,31,92,31,71,31,145,31,107,31,173,31,36,31,133,31,162,31,162,30,253,31,2,31,247,31,150,31,211,31,49,31,49,30,61,31,61,30,61,29,61,28,7,31,7,30,7,29,27,31,236,31,64,31,254,31,63,31,199,31,199,30,177,31,137,31,65,31,10,31,11,31,11,30,195,31,168,31,168,30,193,31,121,31,121,30,121,29,121,28,30,31,138,31,138,30,153,31,171,31,70,31,255,31,255,30,204,31,148,31,177,31,110,31,57,31,57,30,105,31,102,31,102,30,164,31,142,31,142,30,142,29,128,31,151,31,151,30,132,31,191,31,96,31,172,31,172,30,213,31,219,31,88,31,189,31,176,31,243,31,197,31,51,31,51,30,200,31,108,31,180,31,239,31,239,30,199,31,199,30,238,31,191,31,75,31,43,31,119,31,38,31,38,30,100,31,100,30,121,31,183,31,221,31,95,31,120,31,152,31,107,31,89,31,8,31,162,31,162,30,216,31,153,31,203,31,170,31,41,31,247,31,188,31,176,31,198,31,79,31,80,31,232,31,62,31,62,30,188,31,10,31,42,31,192,31,30,31,204,31,222,31,110,31,56,31,37,31,22,31,188,31,188,30,177,31,181,31,114,31,203,31,33,31,72,31,72,30,52,31,52,30,24,31,149,31,168,31,97,31,129,31,56,31,56,30,190,31,171,31,171,30,102,31,108,31,123,31,8,31,249,31,249,30,249,29,140,31,62,31,47,31,175,31,168,31,131,31,19,31,74,31,74,30,74,29,177,31,75,31,145,31,41,31,228,31,155,31,240,31,243,31,243,30,5,31,50,31,159,31,154,31,162,31,168,31,168,30,184,31,192,31,52,31,250,31,24,31,153,31,118,31,150,31,120,31,134,31,134,30,163,31,213,31,213,30,59,31,59,30,208,31,208,30,60,31,104,31,146,31,197,31,61,31,120,31,89,31,65,31,234,31,224,31,238,31,238,30,249,31,28,31,6,31,169,31,51,31,51,30,132,31,132,30,156,31,104,31,204,31,143,31,143,30,3,31,167,31,126,31,82,31,118,31,188,31,188,30,151,31,216,31,173,31,170,31,139,31,21,31,21,30,109,31,109,30,109,29,80,31,49,31,179,31,176,31,39,31,107,31,107,30,59,31,59,30,79,31,79,30,181,31,117,31,243,31,110,31,158,31,158,30,136,31,251,31,168,31,110,31,160,31,186,31,221,31,116,31,196,31,193,31,27,31,179,31,193,31,193,30,170,31,248,31,248,30,100,31);

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
