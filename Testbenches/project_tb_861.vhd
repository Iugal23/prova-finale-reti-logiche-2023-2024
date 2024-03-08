-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_861 is
end project_tb_861;

architecture project_tb_arch_861 of project_tb_861 is
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

constant SCENARIO_LENGTH : integer := 537;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (226,0,207,0,118,0,146,0,230,0,0,0,0,0,159,0,0,0,0,0,128,0,34,0,73,0,88,0,231,0,49,0,139,0,35,0,0,0,112,0,69,0,0,0,113,0,0,0,222,0,0,0,206,0,0,0,70,0,155,0,230,0,177,0,222,0,218,0,247,0,0,0,88,0,95,0,249,0,67,0,0,0,171,0,0,0,69,0,134,0,163,0,170,0,20,0,249,0,131,0,48,0,0,0,0,0,189,0,86,0,38,0,100,0,37,0,206,0,71,0,166,0,0,0,0,0,72,0,6,0,0,0,216,0,164,0,0,0,177,0,44,0,103,0,219,0,251,0,39,0,12,0,49,0,247,0,221,0,0,0,164,0,0,0,185,0,198,0,107,0,0,0,0,0,45,0,0,0,230,0,88,0,200,0,20,0,115,0,26,0,64,0,169,0,0,0,14,0,9,0,99,0,27,0,29,0,161,0,28,0,228,0,104,0,201,0,184,0,185,0,0,0,132,0,217,0,1,0,40,0,163,0,0,0,0,0,0,0,30,0,0,0,34,0,214,0,171,0,0,0,0,0,90,0,0,0,111,0,12,0,64,0,247,0,0,0,16,0,165,0,157,0,0,0,82,0,194,0,21,0,0,0,206,0,167,0,26,0,0,0,6,0,40,0,105,0,179,0,26,0,202,0,62,0,7,0,235,0,192,0,59,0,219,0,60,0,174,0,157,0,92,0,39,0,37,0,83,0,65,0,32,0,172,0,39,0,175,0,50,0,119,0,19,0,221,0,219,0,119,0,240,0,0,0,3,0,155,0,45,0,206,0,166,0,226,0,177,0,0,0,105,0,79,0,206,0,0,0,127,0,166,0,122,0,136,0,144,0,151,0,182,0,176,0,42,0,51,0,17,0,39,0,252,0,125,0,67,0,0,0,198,0,233,0,76,0,0,0,131,0,0,0,196,0,0,0,22,0,218,0,193,0,57,0,39,0,0,0,180,0,34,0,0,0,38,0,225,0,24,0,30,0,112,0,0,0,106,0,214,0,53,0,131,0,157,0,240,0,0,0,12,0,187,0,82,0,142,0,83,0,133,0,110,0,23,0,165,0,55,0,224,0,236,0,0,0,29,0,201,0,20,0,107,0,43,0,35,0,209,0,170,0,95,0,205,0,0,0,0,0,153,0,0,0,1,0,4,0,158,0,137,0,182,0,196,0,155,0,189,0,0,0,170,0,150,0,0,0,134,0,0,0,223,0,0,0,0,0,66,0,0,0,102,0,0,0,4,0,117,0,239,0,0,0,237,0,141,0,172,0,128,0,0,0,0,0,31,0,54,0,176,0,191,0,139,0,159,0,0,0,0,0,192,0,248,0,54,0,246,0,11,0,4,0,119,0,63,0,254,0,0,0,0,0,245,0,142,0,158,0,234,0,229,0,0,0,229,0,190,0,38,0,30,0,128,0,242,0,176,0,48,0,34,0,214,0,0,0,2,0,123,0,60,0,1,0,27,0,137,0,0,0,22,0,246,0,38,0,214,0,150,0,89,0,153,0,60,0,39,0,75,0,82,0,94,0,0,0,122,0,0,0,216,0,128,0,0,0,166,0,160,0,170,0,0,0,230,0,225,0,0,0,62,0,0,0,132,0,56,0,151,0,92,0,0,0,221,0,225,0,0,0,109,0,0,0,134,0,46,0,226,0,73,0,0,0,129,0,0,0,165,0,237,0,72,0,195,0,51,0,97,0,120,0,137,0,0,0,232,0,0,0,222,0,91,0,69,0,143,0,0,0,148,0,142,0,249,0,143,0,240,0,216,0,0,0,253,0,193,0,20,0,25,0,190,0,179,0,0,0,101,0,108,0,123,0,159,0,4,0,12,0,113,0,251,0,100,0,88,0,0,0,0,0,178,0,73,0,0,0,124,0,0,0,21,0,27,0,190,0,40,0,165,0,175,0,169,0,79,0,0,0,248,0,225,0,21,0,150,0,55,0,100,0,29,0,39,0,245,0,175,0,238,0,10,0,95,0,210,0,0,0,172,0,41,0,0,0,227,0,159,0,117,0,189,0,0,0,74,0,193,0,234,0,61,0,84,0,32,0,38,0,0,0,46,0,250,0,117,0,0,0,0,0,218,0,183,0,243,0,179,0,115,0,0,0,216,0,15,0,128,0,201,0,0,0,148,0,81,0,63,0,0,0,221,0,223,0,46,0,59,0,207,0,64,0,57,0,57,0,0,0,81,0,57,0,254,0,59,0,112,0,101,0,231,0,183,0,0,0,62,0,150,0,21,0,88,0,82,0,126,0,0,0,233,0,0,0,80,0,249,0,165,0,99,0,9,0,0,0,85,0,189,0,131,0,84,0,29,0,166,0,45,0,131,0,92,0,160,0,160,0,35,0,90,0,246,0,185,0,181,0,19,0);
signal scenario_full  : scenario_type := (226,31,207,31,118,31,146,31,230,31,230,30,230,29,159,31,159,30,159,29,128,31,34,31,73,31,88,31,231,31,49,31,139,31,35,31,35,30,112,31,69,31,69,30,113,31,113,30,222,31,222,30,206,31,206,30,70,31,155,31,230,31,177,31,222,31,218,31,247,31,247,30,88,31,95,31,249,31,67,31,67,30,171,31,171,30,69,31,134,31,163,31,170,31,20,31,249,31,131,31,48,31,48,30,48,29,189,31,86,31,38,31,100,31,37,31,206,31,71,31,166,31,166,30,166,29,72,31,6,31,6,30,216,31,164,31,164,30,177,31,44,31,103,31,219,31,251,31,39,31,12,31,49,31,247,31,221,31,221,30,164,31,164,30,185,31,198,31,107,31,107,30,107,29,45,31,45,30,230,31,88,31,200,31,20,31,115,31,26,31,64,31,169,31,169,30,14,31,9,31,99,31,27,31,29,31,161,31,28,31,228,31,104,31,201,31,184,31,185,31,185,30,132,31,217,31,1,31,40,31,163,31,163,30,163,29,163,28,30,31,30,30,34,31,214,31,171,31,171,30,171,29,90,31,90,30,111,31,12,31,64,31,247,31,247,30,16,31,165,31,157,31,157,30,82,31,194,31,21,31,21,30,206,31,167,31,26,31,26,30,6,31,40,31,105,31,179,31,26,31,202,31,62,31,7,31,235,31,192,31,59,31,219,31,60,31,174,31,157,31,92,31,39,31,37,31,83,31,65,31,32,31,172,31,39,31,175,31,50,31,119,31,19,31,221,31,219,31,119,31,240,31,240,30,3,31,155,31,45,31,206,31,166,31,226,31,177,31,177,30,105,31,79,31,206,31,206,30,127,31,166,31,122,31,136,31,144,31,151,31,182,31,176,31,42,31,51,31,17,31,39,31,252,31,125,31,67,31,67,30,198,31,233,31,76,31,76,30,131,31,131,30,196,31,196,30,22,31,218,31,193,31,57,31,39,31,39,30,180,31,34,31,34,30,38,31,225,31,24,31,30,31,112,31,112,30,106,31,214,31,53,31,131,31,157,31,240,31,240,30,12,31,187,31,82,31,142,31,83,31,133,31,110,31,23,31,165,31,55,31,224,31,236,31,236,30,29,31,201,31,20,31,107,31,43,31,35,31,209,31,170,31,95,31,205,31,205,30,205,29,153,31,153,30,1,31,4,31,158,31,137,31,182,31,196,31,155,31,189,31,189,30,170,31,150,31,150,30,134,31,134,30,223,31,223,30,223,29,66,31,66,30,102,31,102,30,4,31,117,31,239,31,239,30,237,31,141,31,172,31,128,31,128,30,128,29,31,31,54,31,176,31,191,31,139,31,159,31,159,30,159,29,192,31,248,31,54,31,246,31,11,31,4,31,119,31,63,31,254,31,254,30,254,29,245,31,142,31,158,31,234,31,229,31,229,30,229,31,190,31,38,31,30,31,128,31,242,31,176,31,48,31,34,31,214,31,214,30,2,31,123,31,60,31,1,31,27,31,137,31,137,30,22,31,246,31,38,31,214,31,150,31,89,31,153,31,60,31,39,31,75,31,82,31,94,31,94,30,122,31,122,30,216,31,128,31,128,30,166,31,160,31,170,31,170,30,230,31,225,31,225,30,62,31,62,30,132,31,56,31,151,31,92,31,92,30,221,31,225,31,225,30,109,31,109,30,134,31,46,31,226,31,73,31,73,30,129,31,129,30,165,31,237,31,72,31,195,31,51,31,97,31,120,31,137,31,137,30,232,31,232,30,222,31,91,31,69,31,143,31,143,30,148,31,142,31,249,31,143,31,240,31,216,31,216,30,253,31,193,31,20,31,25,31,190,31,179,31,179,30,101,31,108,31,123,31,159,31,4,31,12,31,113,31,251,31,100,31,88,31,88,30,88,29,178,31,73,31,73,30,124,31,124,30,21,31,27,31,190,31,40,31,165,31,175,31,169,31,79,31,79,30,248,31,225,31,21,31,150,31,55,31,100,31,29,31,39,31,245,31,175,31,238,31,10,31,95,31,210,31,210,30,172,31,41,31,41,30,227,31,159,31,117,31,189,31,189,30,74,31,193,31,234,31,61,31,84,31,32,31,38,31,38,30,46,31,250,31,117,31,117,30,117,29,218,31,183,31,243,31,179,31,115,31,115,30,216,31,15,31,128,31,201,31,201,30,148,31,81,31,63,31,63,30,221,31,223,31,46,31,59,31,207,31,64,31,57,31,57,31,57,30,81,31,57,31,254,31,59,31,112,31,101,31,231,31,183,31,183,30,62,31,150,31,21,31,88,31,82,31,126,31,126,30,233,31,233,30,80,31,249,31,165,31,99,31,9,31,9,30,85,31,189,31,131,31,84,31,29,31,166,31,45,31,131,31,92,31,160,31,160,31,35,31,90,31,246,31,185,31,181,31,19,31);

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
