-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_490 is
end project_tb_490;

architecture project_tb_arch_490 of project_tb_490 is
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

constant SCENARIO_LENGTH : integer := 252;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (12,0,0,0,198,0,0,0,163,0,0,0,193,0,160,0,118,0,68,0,69,0,0,0,180,0,121,0,204,0,166,0,235,0,34,0,204,0,244,0,0,0,171,0,195,0,0,0,221,0,50,0,241,0,155,0,141,0,0,0,96,0,145,0,233,0,102,0,189,0,171,0,153,0,117,0,194,0,93,0,0,0,106,0,0,0,140,0,118,0,157,0,107,0,0,0,0,0,191,0,209,0,1,0,217,0,192,0,236,0,130,0,35,0,51,0,8,0,129,0,218,0,249,0,239,0,115,0,50,0,169,0,205,0,246,0,26,0,0,0,69,0,0,0,68,0,181,0,0,0,201,0,111,0,0,0,20,0,103,0,249,0,0,0,0,0,202,0,0,0,0,0,133,0,0,0,29,0,0,0,82,0,46,0,56,0,218,0,120,0,63,0,0,0,249,0,105,0,65,0,196,0,199,0,109,0,180,0,20,0,213,0,50,0,241,0,181,0,48,0,106,0,177,0,110,0,9,0,0,0,29,0,110,0,0,0,0,0,152,0,119,0,216,0,147,0,92,0,0,0,250,0,83,0,0,0,53,0,147,0,51,0,251,0,0,0,0,0,87,0,6,0,37,0,221,0,97,0,140,0,64,0,39,0,105,0,15,0,146,0,0,0,145,0,212,0,78,0,189,0,62,0,251,0,253,0,29,0,236,0,0,0,235,0,213,0,105,0,123,0,0,0,0,0,38,0,135,0,175,0,0,0,175,0,0,0,59,0,125,0,48,0,24,0,11,0,246,0,168,0,200,0,182,0,0,0,103,0,0,0,69,0,124,0,0,0,131,0,224,0,11,0,48,0,45,0,0,0,0,0,0,0,0,0,188,0,187,0,0,0,142,0,90,0,201,0,71,0,181,0,85,0,220,0,0,0,224,0,145,0,0,0,0,0,217,0,21,0,145,0,0,0,0,0,118,0,254,0,67,0,239,0,229,0,0,0,65,0,0,0,0,0,39,0,106,0,0,0,185,0,149,0,83,0,149,0,235,0,0,0,230,0,82,0,0,0,71,0,152,0,0,0,92,0,137,0,32,0,106,0,230,0,0,0,227,0,141,0,0,0,101,0,34,0,251,0,100,0,0,0,209,0,0,0);
signal scenario_full  : scenario_type := (12,31,12,30,198,31,198,30,163,31,163,30,193,31,160,31,118,31,68,31,69,31,69,30,180,31,121,31,204,31,166,31,235,31,34,31,204,31,244,31,244,30,171,31,195,31,195,30,221,31,50,31,241,31,155,31,141,31,141,30,96,31,145,31,233,31,102,31,189,31,171,31,153,31,117,31,194,31,93,31,93,30,106,31,106,30,140,31,118,31,157,31,107,31,107,30,107,29,191,31,209,31,1,31,217,31,192,31,236,31,130,31,35,31,51,31,8,31,129,31,218,31,249,31,239,31,115,31,50,31,169,31,205,31,246,31,26,31,26,30,69,31,69,30,68,31,181,31,181,30,201,31,111,31,111,30,20,31,103,31,249,31,249,30,249,29,202,31,202,30,202,29,133,31,133,30,29,31,29,30,82,31,46,31,56,31,218,31,120,31,63,31,63,30,249,31,105,31,65,31,196,31,199,31,109,31,180,31,20,31,213,31,50,31,241,31,181,31,48,31,106,31,177,31,110,31,9,31,9,30,29,31,110,31,110,30,110,29,152,31,119,31,216,31,147,31,92,31,92,30,250,31,83,31,83,30,53,31,147,31,51,31,251,31,251,30,251,29,87,31,6,31,37,31,221,31,97,31,140,31,64,31,39,31,105,31,15,31,146,31,146,30,145,31,212,31,78,31,189,31,62,31,251,31,253,31,29,31,236,31,236,30,235,31,213,31,105,31,123,31,123,30,123,29,38,31,135,31,175,31,175,30,175,31,175,30,59,31,125,31,48,31,24,31,11,31,246,31,168,31,200,31,182,31,182,30,103,31,103,30,69,31,124,31,124,30,131,31,224,31,11,31,48,31,45,31,45,30,45,29,45,28,45,27,188,31,187,31,187,30,142,31,90,31,201,31,71,31,181,31,85,31,220,31,220,30,224,31,145,31,145,30,145,29,217,31,21,31,145,31,145,30,145,29,118,31,254,31,67,31,239,31,229,31,229,30,65,31,65,30,65,29,39,31,106,31,106,30,185,31,149,31,83,31,149,31,235,31,235,30,230,31,82,31,82,30,71,31,152,31,152,30,92,31,137,31,32,31,106,31,230,31,230,30,227,31,141,31,141,30,101,31,34,31,251,31,100,31,100,30,209,31,209,30);

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
