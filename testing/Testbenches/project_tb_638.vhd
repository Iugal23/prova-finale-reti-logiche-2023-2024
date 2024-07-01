-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_638 is
end project_tb_638;

architecture project_tb_arch_638 of project_tb_638 is
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

constant SCENARIO_LENGTH : integer := 570;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (172,0,34,0,86,0,0,0,137,0,14,0,0,0,0,0,23,0,0,0,97,0,174,0,131,0,108,0,4,0,60,0,230,0,166,0,75,0,0,0,169,0,20,0,206,0,0,0,187,0,120,0,224,0,3,0,155,0,0,0,93,0,0,0,19,0,183,0,101,0,75,0,128,0,0,0,154,0,226,0,139,0,47,0,0,0,134,0,59,0,117,0,36,0,0,0,27,0,167,0,0,0,204,0,238,0,243,0,148,0,13,0,0,0,254,0,0,0,166,0,49,0,9,0,248,0,217,0,3,0,155,0,0,0,0,0,146,0,0,0,37,0,46,0,153,0,0,0,114,0,97,0,170,0,92,0,140,0,24,0,188,0,0,0,173,0,0,0,0,0,0,0,206,0,175,0,156,0,83,0,192,0,0,0,43,0,0,0,0,0,0,0,127,0,114,0,82,0,125,0,179,0,101,0,64,0,14,0,170,0,172,0,59,0,51,0,0,0,138,0,250,0,127,0,114,0,94,0,238,0,171,0,140,0,80,0,0,0,66,0,80,0,97,0,29,0,221,0,82,0,205,0,90,0,87,0,67,0,201,0,103,0,0,0,0,0,22,0,181,0,223,0,136,0,8,0,94,0,49,0,63,0,155,0,0,0,130,0,4,0,0,0,98,0,94,0,227,0,0,0,0,0,255,0,38,0,34,0,0,0,30,0,5,0,238,0,214,0,165,0,64,0,13,0,132,0,228,0,160,0,1,0,147,0,0,0,74,0,158,0,140,0,233,0,145,0,223,0,184,0,107,0,221,0,111,0,204,0,0,0,86,0,31,0,0,0,79,0,13,0,66,0,209,0,165,0,229,0,0,0,83,0,169,0,0,0,0,0,63,0,0,0,0,0,0,0,0,0,2,0,68,0,135,0,207,0,0,0,84,0,4,0,98,0,97,0,96,0,191,0,0,0,61,0,153,0,126,0,7,0,167,0,192,0,0,0,206,0,62,0,53,0,0,0,216,0,171,0,0,0,0,0,122,0,171,0,93,0,210,0,0,0,0,0,53,0,153,0,122,0,0,0,17,0,127,0,7,0,0,0,243,0,68,0,136,0,117,0,235,0,196,0,62,0,0,0,5,0,140,0,12,0,0,0,0,0,73,0,106,0,168,0,30,0,94,0,92,0,8,0,26,0,209,0,51,0,83,0,33,0,0,0,227,0,30,0,167,0,185,0,156,0,113,0,60,0,28,0,0,0,21,0,95,0,0,0,159,0,0,0,5,0,199,0,199,0,183,0,177,0,132,0,0,0,249,0,187,0,232,0,217,0,123,0,1,0,0,0,157,0,244,0,82,0,0,0,0,0,20,0,71,0,0,0,79,0,41,0,135,0,221,0,177,0,0,0,0,0,73,0,0,0,210,0,0,0,200,0,0,0,148,0,237,0,96,0,175,0,87,0,0,0,0,0,88,0,164,0,82,0,68,0,41,0,0,0,183,0,0,0,254,0,213,0,49,0,104,0,236,0,15,0,35,0,76,0,0,0,0,0,48,0,180,0,0,0,0,0,229,0,91,0,25,0,182,0,239,0,32,0,0,0,160,0,0,0,9,0,191,0,106,0,241,0,122,0,130,0,0,0,109,0,25,0,65,0,156,0,166,0,109,0,141,0,0,0,77,0,149,0,170,0,236,0,202,0,40,0,112,0,123,0,39,0,48,0,252,0,247,0,0,0,161,0,243,0,145,0,0,0,129,0,34,0,88,0,156,0,104,0,223,0,249,0,34,0,125,0,35,0,127,0,252,0,255,0,239,0,54,0,236,0,87,0,105,0,76,0,95,0,0,0,183,0,7,0,128,0,159,0,255,0,100,0,219,0,86,0,140,0,216,0,229,0,47,0,7,0,0,0,0,0,23,0,115,0,141,0,136,0,246,0,0,0,66,0,162,0,189,0,210,0,241,0,46,0,153,0,0,0,156,0,191,0,0,0,0,0,96,0,0,0,214,0,0,0,191,0,0,0,0,0,0,0,249,0,139,0,226,0,156,0,0,0,192,0,23,0,236,0,0,0,248,0,164,0,212,0,181,0,123,0,12,0,0,0,130,0,0,0,145,0,11,0,241,0,185,0,185,0,48,0,0,0,20,0,249,0,192,0,212,0,116,0,0,0,109,0,57,0,47,0,110,0,50,0,0,0,26,0,135,0,111,0,185,0,0,0,0,0,113,0,203,0,32,0,188,0,118,0,46,0,178,0,252,0,254,0,233,0,228,0,55,0,74,0,0,0,0,0,95,0,0,0,116,0,199,0,49,0,230,0,214,0,21,0,0,0,54,0,208,0,120,0,0,0,249,0,234,0,125,0,22,0,205,0,246,0,101,0,72,0,65,0,0,0,131,0,186,0,121,0,162,0,71,0,57,0,24,0,157,0,102,0,195,0,223,0,124,0,189,0,223,0,78,0,157,0,124,0,18,0,250,0,224,0,56,0,137,0,199,0,148,0,142,0,72,0,193,0,88,0,192,0,185,0,116,0,47,0,230,0,163,0,0,0,94,0,57,0,93,0,9,0,0,0,145,0,0,0);
signal scenario_full  : scenario_type := (172,31,34,31,86,31,86,30,137,31,14,31,14,30,14,29,23,31,23,30,97,31,174,31,131,31,108,31,4,31,60,31,230,31,166,31,75,31,75,30,169,31,20,31,206,31,206,30,187,31,120,31,224,31,3,31,155,31,155,30,93,31,93,30,19,31,183,31,101,31,75,31,128,31,128,30,154,31,226,31,139,31,47,31,47,30,134,31,59,31,117,31,36,31,36,30,27,31,167,31,167,30,204,31,238,31,243,31,148,31,13,31,13,30,254,31,254,30,166,31,49,31,9,31,248,31,217,31,3,31,155,31,155,30,155,29,146,31,146,30,37,31,46,31,153,31,153,30,114,31,97,31,170,31,92,31,140,31,24,31,188,31,188,30,173,31,173,30,173,29,173,28,206,31,175,31,156,31,83,31,192,31,192,30,43,31,43,30,43,29,43,28,127,31,114,31,82,31,125,31,179,31,101,31,64,31,14,31,170,31,172,31,59,31,51,31,51,30,138,31,250,31,127,31,114,31,94,31,238,31,171,31,140,31,80,31,80,30,66,31,80,31,97,31,29,31,221,31,82,31,205,31,90,31,87,31,67,31,201,31,103,31,103,30,103,29,22,31,181,31,223,31,136,31,8,31,94,31,49,31,63,31,155,31,155,30,130,31,4,31,4,30,98,31,94,31,227,31,227,30,227,29,255,31,38,31,34,31,34,30,30,31,5,31,238,31,214,31,165,31,64,31,13,31,132,31,228,31,160,31,1,31,147,31,147,30,74,31,158,31,140,31,233,31,145,31,223,31,184,31,107,31,221,31,111,31,204,31,204,30,86,31,31,31,31,30,79,31,13,31,66,31,209,31,165,31,229,31,229,30,83,31,169,31,169,30,169,29,63,31,63,30,63,29,63,28,63,27,2,31,68,31,135,31,207,31,207,30,84,31,4,31,98,31,97,31,96,31,191,31,191,30,61,31,153,31,126,31,7,31,167,31,192,31,192,30,206,31,62,31,53,31,53,30,216,31,171,31,171,30,171,29,122,31,171,31,93,31,210,31,210,30,210,29,53,31,153,31,122,31,122,30,17,31,127,31,7,31,7,30,243,31,68,31,136,31,117,31,235,31,196,31,62,31,62,30,5,31,140,31,12,31,12,30,12,29,73,31,106,31,168,31,30,31,94,31,92,31,8,31,26,31,209,31,51,31,83,31,33,31,33,30,227,31,30,31,167,31,185,31,156,31,113,31,60,31,28,31,28,30,21,31,95,31,95,30,159,31,159,30,5,31,199,31,199,31,183,31,177,31,132,31,132,30,249,31,187,31,232,31,217,31,123,31,1,31,1,30,157,31,244,31,82,31,82,30,82,29,20,31,71,31,71,30,79,31,41,31,135,31,221,31,177,31,177,30,177,29,73,31,73,30,210,31,210,30,200,31,200,30,148,31,237,31,96,31,175,31,87,31,87,30,87,29,88,31,164,31,82,31,68,31,41,31,41,30,183,31,183,30,254,31,213,31,49,31,104,31,236,31,15,31,35,31,76,31,76,30,76,29,48,31,180,31,180,30,180,29,229,31,91,31,25,31,182,31,239,31,32,31,32,30,160,31,160,30,9,31,191,31,106,31,241,31,122,31,130,31,130,30,109,31,25,31,65,31,156,31,166,31,109,31,141,31,141,30,77,31,149,31,170,31,236,31,202,31,40,31,112,31,123,31,39,31,48,31,252,31,247,31,247,30,161,31,243,31,145,31,145,30,129,31,34,31,88,31,156,31,104,31,223,31,249,31,34,31,125,31,35,31,127,31,252,31,255,31,239,31,54,31,236,31,87,31,105,31,76,31,95,31,95,30,183,31,7,31,128,31,159,31,255,31,100,31,219,31,86,31,140,31,216,31,229,31,47,31,7,31,7,30,7,29,23,31,115,31,141,31,136,31,246,31,246,30,66,31,162,31,189,31,210,31,241,31,46,31,153,31,153,30,156,31,191,31,191,30,191,29,96,31,96,30,214,31,214,30,191,31,191,30,191,29,191,28,249,31,139,31,226,31,156,31,156,30,192,31,23,31,236,31,236,30,248,31,164,31,212,31,181,31,123,31,12,31,12,30,130,31,130,30,145,31,11,31,241,31,185,31,185,31,48,31,48,30,20,31,249,31,192,31,212,31,116,31,116,30,109,31,57,31,47,31,110,31,50,31,50,30,26,31,135,31,111,31,185,31,185,30,185,29,113,31,203,31,32,31,188,31,118,31,46,31,178,31,252,31,254,31,233,31,228,31,55,31,74,31,74,30,74,29,95,31,95,30,116,31,199,31,49,31,230,31,214,31,21,31,21,30,54,31,208,31,120,31,120,30,249,31,234,31,125,31,22,31,205,31,246,31,101,31,72,31,65,31,65,30,131,31,186,31,121,31,162,31,71,31,57,31,24,31,157,31,102,31,195,31,223,31,124,31,189,31,223,31,78,31,157,31,124,31,18,31,250,31,224,31,56,31,137,31,199,31,148,31,142,31,72,31,193,31,88,31,192,31,185,31,116,31,47,31,230,31,163,31,163,30,94,31,57,31,93,31,9,31,9,30,145,31,145,30);

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
