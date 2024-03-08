-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_576 is
end project_tb_576;

architecture project_tb_arch_576 of project_tb_576 is
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

constant SCENARIO_LENGTH : integer := 203;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (213,0,27,0,0,0,0,0,12,0,62,0,0,0,0,0,137,0,27,0,25,0,78,0,121,0,87,0,0,0,98,0,134,0,199,0,140,0,0,0,97,0,0,0,0,0,119,0,217,0,128,0,181,0,123,0,0,0,184,0,232,0,244,0,96,0,204,0,56,0,0,0,247,0,206,0,137,0,202,0,46,0,169,0,247,0,34,0,108,0,125,0,131,0,4,0,0,0,42,0,0,0,253,0,139,0,117,0,146,0,177,0,204,0,0,0,148,0,45,0,172,0,0,0,0,0,219,0,0,0,0,0,26,0,113,0,0,0,33,0,0,0,0,0,207,0,249,0,0,0,121,0,246,0,69,0,82,0,98,0,36,0,124,0,82,0,122,0,109,0,120,0,156,0,77,0,246,0,230,0,212,0,62,0,0,0,112,0,251,0,0,0,74,0,26,0,168,0,4,0,149,0,104,0,0,0,0,0,0,0,111,0,104,0,197,0,54,0,223,0,0,0,65,0,30,0,36,0,0,0,36,0,189,0,48,0,207,0,32,0,208,0,7,0,66,0,206,0,114,0,86,0,245,0,90,0,208,0,0,0,22,0,0,0,36,0,249,0,0,0,0,0,0,0,180,0,137,0,112,0,218,0,153,0,61,0,69,0,236,0,197,0,209,0,8,0,193,0,124,0,205,0,89,0,230,0,230,0,15,0,205,0,40,0,50,0,116,0,218,0,30,0,99,0,0,0,63,0,0,0,61,0,69,0,245,0,0,0,113,0,0,0,224,0,106,0,36,0,136,0,20,0,0,0,178,0,134,0,0,0,0,0,81,0,0,0,105,0,168,0,66,0,28,0,255,0,52,0,32,0,168,0,36,0,102,0,149,0,0,0,241,0,0,0,0,0,229,0,8,0,20,0,63,0,153,0);
signal scenario_full  : scenario_type := (213,31,27,31,27,30,27,29,12,31,62,31,62,30,62,29,137,31,27,31,25,31,78,31,121,31,87,31,87,30,98,31,134,31,199,31,140,31,140,30,97,31,97,30,97,29,119,31,217,31,128,31,181,31,123,31,123,30,184,31,232,31,244,31,96,31,204,31,56,31,56,30,247,31,206,31,137,31,202,31,46,31,169,31,247,31,34,31,108,31,125,31,131,31,4,31,4,30,42,31,42,30,253,31,139,31,117,31,146,31,177,31,204,31,204,30,148,31,45,31,172,31,172,30,172,29,219,31,219,30,219,29,26,31,113,31,113,30,33,31,33,30,33,29,207,31,249,31,249,30,121,31,246,31,69,31,82,31,98,31,36,31,124,31,82,31,122,31,109,31,120,31,156,31,77,31,246,31,230,31,212,31,62,31,62,30,112,31,251,31,251,30,74,31,26,31,168,31,4,31,149,31,104,31,104,30,104,29,104,28,111,31,104,31,197,31,54,31,223,31,223,30,65,31,30,31,36,31,36,30,36,31,189,31,48,31,207,31,32,31,208,31,7,31,66,31,206,31,114,31,86,31,245,31,90,31,208,31,208,30,22,31,22,30,36,31,249,31,249,30,249,29,249,28,180,31,137,31,112,31,218,31,153,31,61,31,69,31,236,31,197,31,209,31,8,31,193,31,124,31,205,31,89,31,230,31,230,31,15,31,205,31,40,31,50,31,116,31,218,31,30,31,99,31,99,30,63,31,63,30,61,31,69,31,245,31,245,30,113,31,113,30,224,31,106,31,36,31,136,31,20,31,20,30,178,31,134,31,134,30,134,29,81,31,81,30,105,31,168,31,66,31,28,31,255,31,52,31,32,31,168,31,36,31,102,31,149,31,149,30,241,31,241,30,241,29,229,31,8,31,20,31,63,31,153,31);

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
