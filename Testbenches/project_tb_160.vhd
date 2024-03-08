-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_160 is
end project_tb_160;

architecture project_tb_arch_160 of project_tb_160 is
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

constant SCENARIO_LENGTH : integer := 309;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (132,0,4,0,125,0,38,0,0,0,253,0,207,0,8,0,226,0,0,0,227,0,64,0,0,0,76,0,9,0,68,0,0,0,125,0,0,0,0,0,7,0,200,0,102,0,125,0,100,0,133,0,72,0,105,0,31,0,0,0,154,0,0,0,73,0,11,0,38,0,58,0,62,0,0,0,22,0,95,0,177,0,46,0,0,0,0,0,168,0,0,0,0,0,214,0,56,0,47,0,0,0,11,0,237,0,156,0,192,0,80,0,0,0,26,0,21,0,196,0,0,0,0,0,147,0,236,0,16,0,0,0,210,0,49,0,38,0,255,0,0,0,0,0,0,0,110,0,0,0,195,0,39,0,107,0,75,0,194,0,222,0,199,0,0,0,110,0,0,0,66,0,132,0,205,0,52,0,0,0,160,0,29,0,22,0,29,0,222,0,0,0,0,0,20,0,40,0,63,0,211,0,129,0,220,0,228,0,241,0,36,0,77,0,0,0,237,0,94,0,14,0,78,0,108,0,214,0,190,0,36,0,69,0,196,0,144,0,155,0,92,0,0,0,167,0,0,0,28,0,104,0,185,0,198,0,9,0,115,0,0,0,92,0,155,0,0,0,12,0,55,0,183,0,33,0,143,0,0,0,134,0,69,0,242,0,150,0,0,0,90,0,52,0,122,0,34,0,140,0,113,0,13,0,113,0,0,0,0,0,157,0,199,0,55,0,128,0,157,0,186,0,0,0,25,0,77,0,0,0,164,0,189,0,54,0,177,0,208,0,0,0,27,0,219,0,51,0,0,0,164,0,94,0,132,0,49,0,7,0,0,0,248,0,0,0,132,0,0,0,106,0,112,0,0,0,108,0,87,0,228,0,71,0,210,0,17,0,33,0,243,0,53,0,208,0,182,0,0,0,209,0,249,0,37,0,45,0,9,0,38,0,34,0,97,0,172,0,198,0,123,0,51,0,94,0,112,0,228,0,0,0,169,0,43,0,160,0,2,0,0,0,218,0,0,0,113,0,103,0,0,0,105,0,68,0,95,0,131,0,0,0,214,0,109,0,168,0,156,0,170,0,242,0,148,0,102,0,115,0,219,0,70,0,0,0,20,0,82,0,25,0,147,0,0,0,227,0,207,0,71,0,94,0,0,0,104,0,72,0,0,0,205,0,98,0,0,0,0,0,0,0,30,0,107,0,45,0,23,0,211,0,39,0,120,0,28,0,102,0,196,0,78,0,25,0,236,0,175,0,78,0,243,0,194,0,149,0,66,0,18,0,33,0,0,0,125,0,154,0,2,0,35,0,143,0,144,0,251,0,0,0,141,0,76,0,0,0,166,0,157,0,61,0,226,0,0,0,241,0,0,0,0,0,200,0,176,0,26,0,227,0,0,0,0,0,78,0);
signal scenario_full  : scenario_type := (132,31,4,31,125,31,38,31,38,30,253,31,207,31,8,31,226,31,226,30,227,31,64,31,64,30,76,31,9,31,68,31,68,30,125,31,125,30,125,29,7,31,200,31,102,31,125,31,100,31,133,31,72,31,105,31,31,31,31,30,154,31,154,30,73,31,11,31,38,31,58,31,62,31,62,30,22,31,95,31,177,31,46,31,46,30,46,29,168,31,168,30,168,29,214,31,56,31,47,31,47,30,11,31,237,31,156,31,192,31,80,31,80,30,26,31,21,31,196,31,196,30,196,29,147,31,236,31,16,31,16,30,210,31,49,31,38,31,255,31,255,30,255,29,255,28,110,31,110,30,195,31,39,31,107,31,75,31,194,31,222,31,199,31,199,30,110,31,110,30,66,31,132,31,205,31,52,31,52,30,160,31,29,31,22,31,29,31,222,31,222,30,222,29,20,31,40,31,63,31,211,31,129,31,220,31,228,31,241,31,36,31,77,31,77,30,237,31,94,31,14,31,78,31,108,31,214,31,190,31,36,31,69,31,196,31,144,31,155,31,92,31,92,30,167,31,167,30,28,31,104,31,185,31,198,31,9,31,115,31,115,30,92,31,155,31,155,30,12,31,55,31,183,31,33,31,143,31,143,30,134,31,69,31,242,31,150,31,150,30,90,31,52,31,122,31,34,31,140,31,113,31,13,31,113,31,113,30,113,29,157,31,199,31,55,31,128,31,157,31,186,31,186,30,25,31,77,31,77,30,164,31,189,31,54,31,177,31,208,31,208,30,27,31,219,31,51,31,51,30,164,31,94,31,132,31,49,31,7,31,7,30,248,31,248,30,132,31,132,30,106,31,112,31,112,30,108,31,87,31,228,31,71,31,210,31,17,31,33,31,243,31,53,31,208,31,182,31,182,30,209,31,249,31,37,31,45,31,9,31,38,31,34,31,97,31,172,31,198,31,123,31,51,31,94,31,112,31,228,31,228,30,169,31,43,31,160,31,2,31,2,30,218,31,218,30,113,31,103,31,103,30,105,31,68,31,95,31,131,31,131,30,214,31,109,31,168,31,156,31,170,31,242,31,148,31,102,31,115,31,219,31,70,31,70,30,20,31,82,31,25,31,147,31,147,30,227,31,207,31,71,31,94,31,94,30,104,31,72,31,72,30,205,31,98,31,98,30,98,29,98,28,30,31,107,31,45,31,23,31,211,31,39,31,120,31,28,31,102,31,196,31,78,31,25,31,236,31,175,31,78,31,243,31,194,31,149,31,66,31,18,31,33,31,33,30,125,31,154,31,2,31,35,31,143,31,144,31,251,31,251,30,141,31,76,31,76,30,166,31,157,31,61,31,226,31,226,30,241,31,241,30,241,29,200,31,176,31,26,31,227,31,227,30,227,29,78,31);

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
