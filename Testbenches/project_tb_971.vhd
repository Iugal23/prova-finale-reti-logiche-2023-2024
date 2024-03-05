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

constant SCENARIO_LENGTH : integer := 331;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,54,0,70,0,230,0,13,0,0,0,222,0,61,0,208,0,254,0,100,0,126,0,0,0,147,0,12,0,133,0,233,0,56,0,238,0,0,0,94,0,215,0,132,0,155,0,0,0,252,0,0,0,50,0,9,0,0,0,50,0,214,0,60,0,0,0,0,0,75,0,0,0,189,0,44,0,23,0,172,0,152,0,31,0,0,0,227,0,90,0,0,0,148,0,0,0,26,0,43,0,35,0,225,0,118,0,143,0,174,0,142,0,9,0,48,0,164,0,1,0,162,0,107,0,56,0,206,0,226,0,1,0,20,0,150,0,236,0,0,0,112,0,169,0,140,0,252,0,2,0,240,0,123,0,231,0,0,0,0,0,102,0,0,0,56,0,0,0,67,0,136,0,136,0,164,0,17,0,102,0,39,0,32,0,148,0,86,0,177,0,182,0,50,0,73,0,25,0,238,0,21,0,0,0,90,0,160,0,5,0,0,0,35,0,0,0,0,0,0,0,0,0,150,0,111,0,126,0,84,0,182,0,90,0,2,0,61,0,34,0,0,0,63,0,88,0,214,0,38,0,188,0,33,0,219,0,27,0,63,0,14,0,241,0,94,0,91,0,175,0,49,0,0,0,84,0,230,0,169,0,198,0,11,0,56,0,8,0,76,0,217,0,10,0,106,0,136,0,0,0,1,0,23,0,112,0,249,0,0,0,14,0,137,0,134,0,5,0,167,0,154,0,33,0,27,0,49,0,156,0,91,0,75,0,0,0,22,0,165,0,96,0,50,0,170,0,0,0,0,0,137,0,0,0,132,0,169,0,236,0,32,0,6,0,90,0,0,0,28,0,153,0,214,0,0,0,128,0,142,0,159,0,125,0,104,0,100,0,199,0,160,0,254,0,0,0,172,0,248,0,126,0,93,0,94,0,34,0,0,0,247,0,187,0,205,0,0,0,163,0,59,0,93,0,0,0,59,0,25,0,0,0,249,0,74,0,249,0,135,0,33,0,86,0,82,0,0,0,133,0,30,0,24,0,230,0,86,0,28,0,217,0,0,0,57,0,111,0,217,0,109,0,32,0,163,0,45,0,125,0,101,0,224,0,9,0,156,0,0,0,165,0,155,0,0,0,196,0,225,0,216,0,16,0,121,0,251,0,215,0,251,0,93,0,110,0,81,0,153,0,216,0,173,0,169,0,161,0,0,0,0,0,113,0,10,0,20,0,233,0,242,0,187,0,0,0,196,0,225,0,120,0,119,0,174,0,197,0,101,0,228,0,3,0,99,0,150,0,114,0,154,0,83,0,145,0,18,0,68,0,52,0,0,0,9,0,208,0,119,0,110,0,0,0,183,0,172,0,217,0,40,0,208,0,81,0,123,0,216,0,192,0,99,0,91,0,23,0,202,0,229,0,239,0,0,0,213,0,238,0,242,0,90,0,228,0,111,0,0,0,156,0,234,0,110,0,0,0,2,0,187,0,72,0,209,0,66,0,205,0);
signal scenario_full  : scenario_type := (0,0,54,31,70,31,230,31,13,31,13,30,222,31,61,31,208,31,254,31,100,31,126,31,126,30,147,31,12,31,133,31,233,31,56,31,238,31,238,30,94,31,215,31,132,31,155,31,155,30,252,31,252,30,50,31,9,31,9,30,50,31,214,31,60,31,60,30,60,29,75,31,75,30,189,31,44,31,23,31,172,31,152,31,31,31,31,30,227,31,90,31,90,30,148,31,148,30,26,31,43,31,35,31,225,31,118,31,143,31,174,31,142,31,9,31,48,31,164,31,1,31,162,31,107,31,56,31,206,31,226,31,1,31,20,31,150,31,236,31,236,30,112,31,169,31,140,31,252,31,2,31,240,31,123,31,231,31,231,30,231,29,102,31,102,30,56,31,56,30,67,31,136,31,136,31,164,31,17,31,102,31,39,31,32,31,148,31,86,31,177,31,182,31,50,31,73,31,25,31,238,31,21,31,21,30,90,31,160,31,5,31,5,30,35,31,35,30,35,29,35,28,35,27,150,31,111,31,126,31,84,31,182,31,90,31,2,31,61,31,34,31,34,30,63,31,88,31,214,31,38,31,188,31,33,31,219,31,27,31,63,31,14,31,241,31,94,31,91,31,175,31,49,31,49,30,84,31,230,31,169,31,198,31,11,31,56,31,8,31,76,31,217,31,10,31,106,31,136,31,136,30,1,31,23,31,112,31,249,31,249,30,14,31,137,31,134,31,5,31,167,31,154,31,33,31,27,31,49,31,156,31,91,31,75,31,75,30,22,31,165,31,96,31,50,31,170,31,170,30,170,29,137,31,137,30,132,31,169,31,236,31,32,31,6,31,90,31,90,30,28,31,153,31,214,31,214,30,128,31,142,31,159,31,125,31,104,31,100,31,199,31,160,31,254,31,254,30,172,31,248,31,126,31,93,31,94,31,34,31,34,30,247,31,187,31,205,31,205,30,163,31,59,31,93,31,93,30,59,31,25,31,25,30,249,31,74,31,249,31,135,31,33,31,86,31,82,31,82,30,133,31,30,31,24,31,230,31,86,31,28,31,217,31,217,30,57,31,111,31,217,31,109,31,32,31,163,31,45,31,125,31,101,31,224,31,9,31,156,31,156,30,165,31,155,31,155,30,196,31,225,31,216,31,16,31,121,31,251,31,215,31,251,31,93,31,110,31,81,31,153,31,216,31,173,31,169,31,161,31,161,30,161,29,113,31,10,31,20,31,233,31,242,31,187,31,187,30,196,31,225,31,120,31,119,31,174,31,197,31,101,31,228,31,3,31,99,31,150,31,114,31,154,31,83,31,145,31,18,31,68,31,52,31,52,30,9,31,208,31,119,31,110,31,110,30,183,31,172,31,217,31,40,31,208,31,81,31,123,31,216,31,192,31,99,31,91,31,23,31,202,31,229,31,239,31,239,30,213,31,238,31,242,31,90,31,228,31,111,31,111,30,156,31,234,31,110,31,110,30,2,31,187,31,72,31,209,31,66,31,205,31);

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
