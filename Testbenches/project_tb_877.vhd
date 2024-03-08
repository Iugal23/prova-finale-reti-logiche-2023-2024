-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_877 is
end project_tb_877;

architecture project_tb_arch_877 of project_tb_877 is
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

constant SCENARIO_LENGTH : integer := 445;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (138,0,74,0,0,0,0,0,0,0,145,0,90,0,141,0,93,0,118,0,0,0,191,0,124,0,159,0,149,0,28,0,131,0,152,0,169,0,0,0,76,0,95,0,72,0,180,0,144,0,152,0,195,0,191,0,29,0,0,0,78,0,139,0,0,0,0,0,179,0,107,0,54,0,149,0,224,0,81,0,187,0,35,0,190,0,223,0,251,0,0,0,0,0,9,0,237,0,74,0,132,0,167,0,200,0,165,0,212,0,106,0,48,0,63,0,169,0,120,0,235,0,107,0,46,0,38,0,168,0,197,0,47,0,134,0,183,0,0,0,48,0,60,0,113,0,0,0,8,0,20,0,22,0,150,0,0,0,48,0,166,0,99,0,63,0,128,0,170,0,46,0,168,0,63,0,148,0,93,0,55,0,27,0,0,0,0,0,121,0,196,0,106,0,217,0,145,0,45,0,62,0,71,0,81,0,69,0,197,0,140,0,104,0,243,0,27,0,58,0,16,0,0,0,101,0,166,0,0,0,168,0,143,0,0,0,26,0,0,0,213,0,90,0,140,0,168,0,141,0,71,0,83,0,81,0,50,0,226,0,192,0,71,0,66,0,240,0,91,0,202,0,101,0,246,0,38,0,234,0,0,0,226,0,222,0,0,0,148,0,196,0,1,0,63,0,0,0,215,0,78,0,75,0,61,0,0,0,141,0,181,0,9,0,209,0,19,0,28,0,79,0,0,0,27,0,27,0,234,0,83,0,157,0,249,0,130,0,57,0,232,0,0,0,179,0,37,0,2,0,0,0,80,0,0,0,156,0,0,0,101,0,101,0,0,0,10,0,113,0,93,0,133,0,0,0,119,0,150,0,150,0,0,0,0,0,77,0,200,0,192,0,86,0,39,0,126,0,0,0,104,0,137,0,2,0,43,0,198,0,18,0,210,0,80,0,52,0,207,0,75,0,208,0,0,0,77,0,65,0,0,0,80,0,0,0,168,0,141,0,50,0,55,0,160,0,196,0,184,0,30,0,126,0,89,0,65,0,133,0,80,0,213,0,181,0,0,0,178,0,143,0,75,0,20,0,8,0,76,0,149,0,205,0,99,0,0,0,71,0,128,0,77,0,43,0,242,0,0,0,46,0,139,0,0,0,164,0,73,0,188,0,130,0,225,0,184,0,107,0,25,0,111,0,116,0,115,0,120,0,166,0,144,0,0,0,0,0,172,0,60,0,77,0,0,0,0,0,46,0,84,0,143,0,0,0,0,0,182,0,79,0,120,0,0,0,0,0,0,0,159,0,133,0,97,0,26,0,0,0,61,0,120,0,0,0,40,0,228,0,242,0,29,0,200,0,68,0,87,0,0,0,181,0,35,0,193,0,0,0,155,0,77,0,24,0,42,0,78,0,0,0,104,0,240,0,135,0,85,0,0,0,20,0,116,0,131,0,198,0,196,0,0,0,23,0,221,0,0,0,253,0,254,0,16,0,37,0,179,0,215,0,0,0,217,0,111,0,211,0,0,0,84,0,0,0,52,0,136,0,122,0,195,0,0,0,212,0,105,0,169,0,66,0,62,0,178,0,35,0,37,0,191,0,49,0,249,0,195,0,170,0,0,0,0,0,143,0,4,0,246,0,79,0,28,0,0,0,0,0,69,0,124,0,20,0,0,0,251,0,0,0,0,0,39,0,0,0,200,0,13,0,121,0,82,0,187,0,47,0,226,0,0,0,48,0,103,0,157,0,0,0,213,0,220,0,0,0,53,0,237,0,154,0,0,0,238,0,0,0,51,0,198,0,240,0,147,0,97,0,238,0,0,0,48,0,0,0,253,0,107,0,6,0,154,0,218,0,228,0,181,0,91,0,74,0,133,0,139,0,221,0,99,0,17,0,0,0,9,0,30,0,0,0,75,0,75,0,137,0,0,0,66,0,0,0,170,0,59,0,189,0,48,0,71,0,127,0,153,0,0,0,247,0,0,0,89,0,94,0,198,0,43,0,192,0,207,0,164,0);
signal scenario_full  : scenario_type := (138,31,74,31,74,30,74,29,74,28,145,31,90,31,141,31,93,31,118,31,118,30,191,31,124,31,159,31,149,31,28,31,131,31,152,31,169,31,169,30,76,31,95,31,72,31,180,31,144,31,152,31,195,31,191,31,29,31,29,30,78,31,139,31,139,30,139,29,179,31,107,31,54,31,149,31,224,31,81,31,187,31,35,31,190,31,223,31,251,31,251,30,251,29,9,31,237,31,74,31,132,31,167,31,200,31,165,31,212,31,106,31,48,31,63,31,169,31,120,31,235,31,107,31,46,31,38,31,168,31,197,31,47,31,134,31,183,31,183,30,48,31,60,31,113,31,113,30,8,31,20,31,22,31,150,31,150,30,48,31,166,31,99,31,63,31,128,31,170,31,46,31,168,31,63,31,148,31,93,31,55,31,27,31,27,30,27,29,121,31,196,31,106,31,217,31,145,31,45,31,62,31,71,31,81,31,69,31,197,31,140,31,104,31,243,31,27,31,58,31,16,31,16,30,101,31,166,31,166,30,168,31,143,31,143,30,26,31,26,30,213,31,90,31,140,31,168,31,141,31,71,31,83,31,81,31,50,31,226,31,192,31,71,31,66,31,240,31,91,31,202,31,101,31,246,31,38,31,234,31,234,30,226,31,222,31,222,30,148,31,196,31,1,31,63,31,63,30,215,31,78,31,75,31,61,31,61,30,141,31,181,31,9,31,209,31,19,31,28,31,79,31,79,30,27,31,27,31,234,31,83,31,157,31,249,31,130,31,57,31,232,31,232,30,179,31,37,31,2,31,2,30,80,31,80,30,156,31,156,30,101,31,101,31,101,30,10,31,113,31,93,31,133,31,133,30,119,31,150,31,150,31,150,30,150,29,77,31,200,31,192,31,86,31,39,31,126,31,126,30,104,31,137,31,2,31,43,31,198,31,18,31,210,31,80,31,52,31,207,31,75,31,208,31,208,30,77,31,65,31,65,30,80,31,80,30,168,31,141,31,50,31,55,31,160,31,196,31,184,31,30,31,126,31,89,31,65,31,133,31,80,31,213,31,181,31,181,30,178,31,143,31,75,31,20,31,8,31,76,31,149,31,205,31,99,31,99,30,71,31,128,31,77,31,43,31,242,31,242,30,46,31,139,31,139,30,164,31,73,31,188,31,130,31,225,31,184,31,107,31,25,31,111,31,116,31,115,31,120,31,166,31,144,31,144,30,144,29,172,31,60,31,77,31,77,30,77,29,46,31,84,31,143,31,143,30,143,29,182,31,79,31,120,31,120,30,120,29,120,28,159,31,133,31,97,31,26,31,26,30,61,31,120,31,120,30,40,31,228,31,242,31,29,31,200,31,68,31,87,31,87,30,181,31,35,31,193,31,193,30,155,31,77,31,24,31,42,31,78,31,78,30,104,31,240,31,135,31,85,31,85,30,20,31,116,31,131,31,198,31,196,31,196,30,23,31,221,31,221,30,253,31,254,31,16,31,37,31,179,31,215,31,215,30,217,31,111,31,211,31,211,30,84,31,84,30,52,31,136,31,122,31,195,31,195,30,212,31,105,31,169,31,66,31,62,31,178,31,35,31,37,31,191,31,49,31,249,31,195,31,170,31,170,30,170,29,143,31,4,31,246,31,79,31,28,31,28,30,28,29,69,31,124,31,20,31,20,30,251,31,251,30,251,29,39,31,39,30,200,31,13,31,121,31,82,31,187,31,47,31,226,31,226,30,48,31,103,31,157,31,157,30,213,31,220,31,220,30,53,31,237,31,154,31,154,30,238,31,238,30,51,31,198,31,240,31,147,31,97,31,238,31,238,30,48,31,48,30,253,31,107,31,6,31,154,31,218,31,228,31,181,31,91,31,74,31,133,31,139,31,221,31,99,31,17,31,17,30,9,31,30,31,30,30,75,31,75,31,137,31,137,30,66,31,66,30,170,31,59,31,189,31,48,31,71,31,127,31,153,31,153,30,247,31,247,30,89,31,94,31,198,31,43,31,192,31,207,31,164,31);

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
