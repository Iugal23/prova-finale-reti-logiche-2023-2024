-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_279 is
end project_tb_279;

architecture project_tb_arch_279 of project_tb_279 is
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

constant SCENARIO_LENGTH : integer := 750;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (101,0,0,0,175,0,0,0,96,0,192,0,176,0,124,0,155,0,117,0,249,0,0,0,251,0,148,0,192,0,0,0,227,0,221,0,7,0,42,0,244,0,213,0,0,0,16,0,149,0,57,0,205,0,0,0,222,0,0,0,31,0,0,0,13,0,180,0,61,0,85,0,238,0,190,0,201,0,28,0,33,0,214,0,92,0,173,0,206,0,139,0,141,0,218,0,32,0,235,0,230,0,136,0,0,0,66,0,214,0,149,0,191,0,26,0,0,0,200,0,42,0,74,0,71,0,66,0,187,0,66,0,242,0,87,0,97,0,97,0,66,0,25,0,221,0,148,0,20,0,58,0,138,0,167,0,75,0,122,0,111,0,62,0,0,0,162,0,0,0,0,0,0,0,206,0,0,0,45,0,100,0,176,0,17,0,4,0,251,0,186,0,149,0,168,0,114,0,165,0,117,0,202,0,246,0,17,0,176,0,0,0,163,0,98,0,124,0,240,0,112,0,0,0,250,0,145,0,156,0,75,0,127,0,0,0,81,0,135,0,0,0,205,0,100,0,205,0,136,0,0,0,37,0,0,0,89,0,234,0,202,0,64,0,0,0,96,0,218,0,0,0,165,0,187,0,238,0,17,0,198,0,0,0,60,0,0,0,0,0,113,0,165,0,116,0,0,0,72,0,24,0,248,0,13,0,45,0,127,0,106,0,0,0,237,0,147,0,220,0,6,0,0,0,100,0,242,0,0,0,170,0,246,0,0,0,40,0,40,0,81,0,164,0,9,0,146,0,228,0,238,0,0,0,111,0,70,0,49,0,8,0,103,0,37,0,245,0,220,0,240,0,63,0,209,0,150,0,100,0,0,0,23,0,56,0,0,0,114,0,250,0,1,0,227,0,68,0,30,0,215,0,73,0,236,0,3,0,121,0,242,0,217,0,148,0,0,0,0,0,0,0,152,0,253,0,0,0,0,0,28,0,65,0,63,0,131,0,249,0,126,0,239,0,0,0,124,0,0,0,0,0,22,0,53,0,0,0,213,0,182,0,46,0,163,0,24,0,197,0,66,0,0,0,0,0,0,0,168,0,59,0,0,0,215,0,78,0,0,0,183,0,24,0,47,0,0,0,66,0,63,0,199,0,238,0,249,0,0,0,104,0,226,0,34,0,0,0,104,0,25,0,198,0,0,0,0,0,145,0,105,0,0,0,191,0,0,0,43,0,145,0,169,0,198,0,200,0,224,0,177,0,189,0,22,0,0,0,173,0,62,0,21,0,65,0,137,0,90,0,91,0,0,0,190,0,130,0,230,0,152,0,250,0,38,0,26,0,255,0,87,0,148,0,20,0,78,0,53,0,0,0,177,0,153,0,0,0,123,0,147,0,251,0,26,0,78,0,177,0,237,0,26,0,238,0,22,0,195,0,78,0,50,0,0,0,218,0,24,0,213,0,0,0,0,0,0,0,95,0,81,0,178,0,39,0,106,0,173,0,185,0,123,0,190,0,140,0,0,0,15,0,89,0,183,0,0,0,249,0,254,0,206,0,124,0,139,0,172,0,208,0,9,0,179,0,205,0,37,0,184,0,19,0,45,0,160,0,158,0,152,0,80,0,0,0,150,0,0,0,147,0,58,0,106,0,152,0,150,0,147,0,24,0,31,0,117,0,75,0,83,0,177,0,29,0,0,0,236,0,172,0,74,0,65,0,0,0,0,0,53,0,182,0,228,0,0,0,55,0,208,0,162,0,193,0,10,0,156,0,186,0,0,0,69,0,224,0,135,0,15,0,166,0,0,0,253,0,52,0,169,0,216,0,146,0,23,0,194,0,159,0,210,0,0,0,89,0,25,0,147,0,247,0,85,0,233,0,43,0,117,0,218,0,233,0,170,0,0,0,0,0,11,0,95,0,79,0,60,0,183,0,238,0,174,0,0,0,138,0,99,0,0,0,235,0,200,0,117,0,185,0,67,0,124,0,144,0,121,0,82,0,24,0,148,0,0,0,157,0,0,0,139,0,7,0,0,0,109,0,42,0,3,0,231,0,206,0,63,0,72,0,81,0,101,0,171,0,0,0,1,0,191,0,108,0,84,0,45,0,203,0,165,0,0,0,0,0,151,0,178,0,203,0,59,0,0,0,101,0,0,0,0,0,98,0,156,0,14,0,243,0,247,0,226,0,179,0,0,0,142,0,140,0,84,0,117,0,158,0,133,0,139,0,215,0,0,0,232,0,35,0,84,0,173,0,48,0,132,0,29,0,150,0,47,0,123,0,0,0,55,0,151,0,94,0,214,0,250,0,0,0,0,0,138,0,119,0,220,0,78,0,118,0,0,0,144,0,15,0,141,0,122,0,62,0,35,0,79,0,0,0,21,0,54,0,119,0,61,0,203,0,53,0,131,0,218,0,12,0,0,0,0,0,194,0,67,0,239,0,138,0,215,0,0,0,121,0,40,0,87,0,17,0,0,0,146,0,0,0,172,0,0,0,105,0,0,0,36,0,0,0,82,0,137,0,40,0,214,0,181,0,199,0,0,0,41,0,193,0,73,0,1,0,16,0,158,0,9,0,241,0,249,0,0,0,43,0,231,0,227,0,90,0,87,0,36,0,151,0,232,0,0,0,39,0,110,0,214,0,135,0,0,0,133,0,165,0,82,0,126,0,0,0,0,0,0,0,240,0,0,0,0,0,89,0,0,0,171,0,200,0,140,0,0,0,31,0,23,0,231,0,25,0,169,0,187,0,0,0,24,0,152,0,19,0,218,0,0,0,145,0,0,0,35,0,43,0,96,0,0,0,147,0,75,0,62,0,176,0,76,0,47,0,0,0,0,0,139,0,120,0,108,0,0,0,37,0,100,0,62,0,250,0,121,0,15,0,31,0,194,0,213,0,50,0,2,0,104,0,206,0,62,0,22,0,230,0,0,0,0,0,162,0,29,0,182,0,202,0,204,0,123,0,217,0,100,0,118,0,100,0,83,0,170,0,225,0,96,0,203,0,107,0,192,0,98,0,213,0,73,0,241,0,175,0,152,0,57,0,30,0,0,0,70,0,0,0,248,0,0,0,70,0,52,0,45,0,191,0,43,0,188,0,0,0,36,0,0,0,255,0,5,0,134,0,208,0,173,0,205,0,35,0,251,0,112,0,63,0,18,0,127,0,18,0,4,0,23,0,222,0,151,0,43,0,0,0,43,0,115,0,48,0,211,0,75,0,201,0,78,0,142,0,110,0,8,0,45,0,168,0,115,0,196,0,0,0,172,0,0,0,0,0,0,0,10,0,40,0,37,0,6,0,58,0,105,0,170,0,0,0,0,0,0,0,137,0,50,0,33,0,78,0,5,0,189,0,57,0,201,0,3,0,204,0,0,0,151,0);
signal scenario_full  : scenario_type := (101,31,101,30,175,31,175,30,96,31,192,31,176,31,124,31,155,31,117,31,249,31,249,30,251,31,148,31,192,31,192,30,227,31,221,31,7,31,42,31,244,31,213,31,213,30,16,31,149,31,57,31,205,31,205,30,222,31,222,30,31,31,31,30,13,31,180,31,61,31,85,31,238,31,190,31,201,31,28,31,33,31,214,31,92,31,173,31,206,31,139,31,141,31,218,31,32,31,235,31,230,31,136,31,136,30,66,31,214,31,149,31,191,31,26,31,26,30,200,31,42,31,74,31,71,31,66,31,187,31,66,31,242,31,87,31,97,31,97,31,66,31,25,31,221,31,148,31,20,31,58,31,138,31,167,31,75,31,122,31,111,31,62,31,62,30,162,31,162,30,162,29,162,28,206,31,206,30,45,31,100,31,176,31,17,31,4,31,251,31,186,31,149,31,168,31,114,31,165,31,117,31,202,31,246,31,17,31,176,31,176,30,163,31,98,31,124,31,240,31,112,31,112,30,250,31,145,31,156,31,75,31,127,31,127,30,81,31,135,31,135,30,205,31,100,31,205,31,136,31,136,30,37,31,37,30,89,31,234,31,202,31,64,31,64,30,96,31,218,31,218,30,165,31,187,31,238,31,17,31,198,31,198,30,60,31,60,30,60,29,113,31,165,31,116,31,116,30,72,31,24,31,248,31,13,31,45,31,127,31,106,31,106,30,237,31,147,31,220,31,6,31,6,30,100,31,242,31,242,30,170,31,246,31,246,30,40,31,40,31,81,31,164,31,9,31,146,31,228,31,238,31,238,30,111,31,70,31,49,31,8,31,103,31,37,31,245,31,220,31,240,31,63,31,209,31,150,31,100,31,100,30,23,31,56,31,56,30,114,31,250,31,1,31,227,31,68,31,30,31,215,31,73,31,236,31,3,31,121,31,242,31,217,31,148,31,148,30,148,29,148,28,152,31,253,31,253,30,253,29,28,31,65,31,63,31,131,31,249,31,126,31,239,31,239,30,124,31,124,30,124,29,22,31,53,31,53,30,213,31,182,31,46,31,163,31,24,31,197,31,66,31,66,30,66,29,66,28,168,31,59,31,59,30,215,31,78,31,78,30,183,31,24,31,47,31,47,30,66,31,63,31,199,31,238,31,249,31,249,30,104,31,226,31,34,31,34,30,104,31,25,31,198,31,198,30,198,29,145,31,105,31,105,30,191,31,191,30,43,31,145,31,169,31,198,31,200,31,224,31,177,31,189,31,22,31,22,30,173,31,62,31,21,31,65,31,137,31,90,31,91,31,91,30,190,31,130,31,230,31,152,31,250,31,38,31,26,31,255,31,87,31,148,31,20,31,78,31,53,31,53,30,177,31,153,31,153,30,123,31,147,31,251,31,26,31,78,31,177,31,237,31,26,31,238,31,22,31,195,31,78,31,50,31,50,30,218,31,24,31,213,31,213,30,213,29,213,28,95,31,81,31,178,31,39,31,106,31,173,31,185,31,123,31,190,31,140,31,140,30,15,31,89,31,183,31,183,30,249,31,254,31,206,31,124,31,139,31,172,31,208,31,9,31,179,31,205,31,37,31,184,31,19,31,45,31,160,31,158,31,152,31,80,31,80,30,150,31,150,30,147,31,58,31,106,31,152,31,150,31,147,31,24,31,31,31,117,31,75,31,83,31,177,31,29,31,29,30,236,31,172,31,74,31,65,31,65,30,65,29,53,31,182,31,228,31,228,30,55,31,208,31,162,31,193,31,10,31,156,31,186,31,186,30,69,31,224,31,135,31,15,31,166,31,166,30,253,31,52,31,169,31,216,31,146,31,23,31,194,31,159,31,210,31,210,30,89,31,25,31,147,31,247,31,85,31,233,31,43,31,117,31,218,31,233,31,170,31,170,30,170,29,11,31,95,31,79,31,60,31,183,31,238,31,174,31,174,30,138,31,99,31,99,30,235,31,200,31,117,31,185,31,67,31,124,31,144,31,121,31,82,31,24,31,148,31,148,30,157,31,157,30,139,31,7,31,7,30,109,31,42,31,3,31,231,31,206,31,63,31,72,31,81,31,101,31,171,31,171,30,1,31,191,31,108,31,84,31,45,31,203,31,165,31,165,30,165,29,151,31,178,31,203,31,59,31,59,30,101,31,101,30,101,29,98,31,156,31,14,31,243,31,247,31,226,31,179,31,179,30,142,31,140,31,84,31,117,31,158,31,133,31,139,31,215,31,215,30,232,31,35,31,84,31,173,31,48,31,132,31,29,31,150,31,47,31,123,31,123,30,55,31,151,31,94,31,214,31,250,31,250,30,250,29,138,31,119,31,220,31,78,31,118,31,118,30,144,31,15,31,141,31,122,31,62,31,35,31,79,31,79,30,21,31,54,31,119,31,61,31,203,31,53,31,131,31,218,31,12,31,12,30,12,29,194,31,67,31,239,31,138,31,215,31,215,30,121,31,40,31,87,31,17,31,17,30,146,31,146,30,172,31,172,30,105,31,105,30,36,31,36,30,82,31,137,31,40,31,214,31,181,31,199,31,199,30,41,31,193,31,73,31,1,31,16,31,158,31,9,31,241,31,249,31,249,30,43,31,231,31,227,31,90,31,87,31,36,31,151,31,232,31,232,30,39,31,110,31,214,31,135,31,135,30,133,31,165,31,82,31,126,31,126,30,126,29,126,28,240,31,240,30,240,29,89,31,89,30,171,31,200,31,140,31,140,30,31,31,23,31,231,31,25,31,169,31,187,31,187,30,24,31,152,31,19,31,218,31,218,30,145,31,145,30,35,31,43,31,96,31,96,30,147,31,75,31,62,31,176,31,76,31,47,31,47,30,47,29,139,31,120,31,108,31,108,30,37,31,100,31,62,31,250,31,121,31,15,31,31,31,194,31,213,31,50,31,2,31,104,31,206,31,62,31,22,31,230,31,230,30,230,29,162,31,29,31,182,31,202,31,204,31,123,31,217,31,100,31,118,31,100,31,83,31,170,31,225,31,96,31,203,31,107,31,192,31,98,31,213,31,73,31,241,31,175,31,152,31,57,31,30,31,30,30,70,31,70,30,248,31,248,30,70,31,52,31,45,31,191,31,43,31,188,31,188,30,36,31,36,30,255,31,5,31,134,31,208,31,173,31,205,31,35,31,251,31,112,31,63,31,18,31,127,31,18,31,4,31,23,31,222,31,151,31,43,31,43,30,43,31,115,31,48,31,211,31,75,31,201,31,78,31,142,31,110,31,8,31,45,31,168,31,115,31,196,31,196,30,172,31,172,30,172,29,172,28,10,31,40,31,37,31,6,31,58,31,105,31,170,31,170,30,170,29,170,28,137,31,50,31,33,31,78,31,5,31,189,31,57,31,201,31,3,31,204,31,204,30,151,31);

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
