-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_828 is
end project_tb_828;

architecture project_tb_arch_828 of project_tb_828 is
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

constant SCENARIO_LENGTH : integer := 449;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,88,0,75,0,214,0,44,0,0,0,43,0,245,0,222,0,181,0,43,0,166,0,253,0,41,0,0,0,32,0,251,0,0,0,0,0,69,0,118,0,131,0,96,0,228,0,153,0,0,0,44,0,119,0,82,0,27,0,124,0,122,0,64,0,80,0,26,0,219,0,0,0,52,0,236,0,4,0,241,0,217,0,15,0,218,0,126,0,0,0,36,0,127,0,0,0,146,0,76,0,16,0,241,0,59,0,100,0,0,0,0,0,215,0,215,0,110,0,208,0,0,0,71,0,220,0,161,0,0,0,27,0,0,0,139,0,0,0,202,0,91,0,14,0,139,0,61,0,169,0,18,0,96,0,83,0,191,0,58,0,0,0,187,0,154,0,117,0,30,0,0,0,56,0,0,0,65,0,205,0,45,0,132,0,249,0,220,0,237,0,197,0,0,0,48,0,47,0,0,0,143,0,9,0,185,0,0,0,0,0,0,0,147,0,101,0,87,0,197,0,49,0,71,0,242,0,144,0,0,0,0,0,200,0,249,0,57,0,190,0,39,0,40,0,222,0,0,0,209,0,160,0,18,0,102,0,172,0,0,0,60,0,235,0,94,0,116,0,144,0,178,0,19,0,249,0,0,0,46,0,173,0,57,0,0,0,52,0,60,0,6,0,161,0,218,0,170,0,0,0,9,0,124,0,2,0,240,0,72,0,144,0,179,0,197,0,7,0,0,0,150,0,0,0,190,0,208,0,146,0,38,0,179,0,201,0,167,0,0,0,165,0,5,0,138,0,19,0,119,0,139,0,79,0,127,0,104,0,146,0,96,0,187,0,170,0,236,0,104,0,243,0,142,0,241,0,239,0,0,0,100,0,136,0,110,0,0,0,244,0,123,0,205,0,101,0,0,0,180,0,237,0,20,0,204,0,230,0,27,0,0,0,0,0,254,0,0,0,79,0,11,0,150,0,196,0,0,0,52,0,241,0,248,0,190,0,14,0,0,0,89,0,236,0,37,0,0,0,80,0,179,0,33,0,164,0,64,0,0,0,116,0,26,0,131,0,0,0,74,0,221,0,173,0,74,0,27,0,248,0,57,0,93,0,58,0,240,0,63,0,123,0,127,0,15,0,0,0,146,0,8,0,0,0,93,0,124,0,46,0,141,0,33,0,90,0,92,0,0,0,208,0,220,0,200,0,0,0,31,0,195,0,170,0,157,0,226,0,62,0,0,0,176,0,73,0,180,0,145,0,0,0,0,0,190,0,0,0,201,0,0,0,219,0,0,0,96,0,34,0,253,0,0,0,166,0,163,0,66,0,52,0,104,0,130,0,92,0,0,0,171,0,0,0,59,0,0,0,155,0,149,0,0,0,152,0,167,0,197,0,44,0,252,0,89,0,82,0,169,0,17,0,180,0,180,0,74,0,198,0,7,0,122,0,182,0,0,0,186,0,27,0,227,0,200,0,126,0,147,0,215,0,0,0,24,0,114,0,190,0,181,0,204,0,9,0,123,0,52,0,28,0,157,0,202,0,104,0,175,0,0,0,81,0,92,0,156,0,56,0,249,0,168,0,18,0,0,0,53,0,136,0,0,0,218,0,81,0,77,0,0,0,66,0,197,0,142,0,231,0,0,0,130,0,208,0,59,0,167,0,0,0,53,0,75,0,168,0,182,0,228,0,111,0,143,0,0,0,0,0,133,0,12,0,94,0,178,0,47,0,145,0,0,0,0,0,117,0,29,0,149,0,245,0,192,0,247,0,146,0,156,0,18,0,190,0,115,0,0,0,222,0,230,0,93,0,145,0,47,0,58,0,0,0,150,0,128,0,63,0,26,0,0,0,0,0,95,0,206,0,0,0,86,0,64,0,180,0,113,0,88,0,84,0,0,0,0,0,11,0,198,0,185,0,183,0,0,0,218,0,179,0,183,0,193,0,0,0,77,0,207,0,215,0,33,0,195,0,87,0,0,0,107,0,144,0,0,0,184,0,183,0,132,0,236,0,163,0,0,0,160,0,107,0,101,0);
signal scenario_full  : scenario_type := (0,0,88,31,75,31,214,31,44,31,44,30,43,31,245,31,222,31,181,31,43,31,166,31,253,31,41,31,41,30,32,31,251,31,251,30,251,29,69,31,118,31,131,31,96,31,228,31,153,31,153,30,44,31,119,31,82,31,27,31,124,31,122,31,64,31,80,31,26,31,219,31,219,30,52,31,236,31,4,31,241,31,217,31,15,31,218,31,126,31,126,30,36,31,127,31,127,30,146,31,76,31,16,31,241,31,59,31,100,31,100,30,100,29,215,31,215,31,110,31,208,31,208,30,71,31,220,31,161,31,161,30,27,31,27,30,139,31,139,30,202,31,91,31,14,31,139,31,61,31,169,31,18,31,96,31,83,31,191,31,58,31,58,30,187,31,154,31,117,31,30,31,30,30,56,31,56,30,65,31,205,31,45,31,132,31,249,31,220,31,237,31,197,31,197,30,48,31,47,31,47,30,143,31,9,31,185,31,185,30,185,29,185,28,147,31,101,31,87,31,197,31,49,31,71,31,242,31,144,31,144,30,144,29,200,31,249,31,57,31,190,31,39,31,40,31,222,31,222,30,209,31,160,31,18,31,102,31,172,31,172,30,60,31,235,31,94,31,116,31,144,31,178,31,19,31,249,31,249,30,46,31,173,31,57,31,57,30,52,31,60,31,6,31,161,31,218,31,170,31,170,30,9,31,124,31,2,31,240,31,72,31,144,31,179,31,197,31,7,31,7,30,150,31,150,30,190,31,208,31,146,31,38,31,179,31,201,31,167,31,167,30,165,31,5,31,138,31,19,31,119,31,139,31,79,31,127,31,104,31,146,31,96,31,187,31,170,31,236,31,104,31,243,31,142,31,241,31,239,31,239,30,100,31,136,31,110,31,110,30,244,31,123,31,205,31,101,31,101,30,180,31,237,31,20,31,204,31,230,31,27,31,27,30,27,29,254,31,254,30,79,31,11,31,150,31,196,31,196,30,52,31,241,31,248,31,190,31,14,31,14,30,89,31,236,31,37,31,37,30,80,31,179,31,33,31,164,31,64,31,64,30,116,31,26,31,131,31,131,30,74,31,221,31,173,31,74,31,27,31,248,31,57,31,93,31,58,31,240,31,63,31,123,31,127,31,15,31,15,30,146,31,8,31,8,30,93,31,124,31,46,31,141,31,33,31,90,31,92,31,92,30,208,31,220,31,200,31,200,30,31,31,195,31,170,31,157,31,226,31,62,31,62,30,176,31,73,31,180,31,145,31,145,30,145,29,190,31,190,30,201,31,201,30,219,31,219,30,96,31,34,31,253,31,253,30,166,31,163,31,66,31,52,31,104,31,130,31,92,31,92,30,171,31,171,30,59,31,59,30,155,31,149,31,149,30,152,31,167,31,197,31,44,31,252,31,89,31,82,31,169,31,17,31,180,31,180,31,74,31,198,31,7,31,122,31,182,31,182,30,186,31,27,31,227,31,200,31,126,31,147,31,215,31,215,30,24,31,114,31,190,31,181,31,204,31,9,31,123,31,52,31,28,31,157,31,202,31,104,31,175,31,175,30,81,31,92,31,156,31,56,31,249,31,168,31,18,31,18,30,53,31,136,31,136,30,218,31,81,31,77,31,77,30,66,31,197,31,142,31,231,31,231,30,130,31,208,31,59,31,167,31,167,30,53,31,75,31,168,31,182,31,228,31,111,31,143,31,143,30,143,29,133,31,12,31,94,31,178,31,47,31,145,31,145,30,145,29,117,31,29,31,149,31,245,31,192,31,247,31,146,31,156,31,18,31,190,31,115,31,115,30,222,31,230,31,93,31,145,31,47,31,58,31,58,30,150,31,128,31,63,31,26,31,26,30,26,29,95,31,206,31,206,30,86,31,64,31,180,31,113,31,88,31,84,31,84,30,84,29,11,31,198,31,185,31,183,31,183,30,218,31,179,31,183,31,193,31,193,30,77,31,207,31,215,31,33,31,195,31,87,31,87,30,107,31,144,31,144,30,184,31,183,31,132,31,236,31,163,31,163,30,160,31,107,31,101,31);

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
